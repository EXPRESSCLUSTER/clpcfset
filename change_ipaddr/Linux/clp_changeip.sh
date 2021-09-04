#!/bin/sh

echo "start changing IP Address."
## check admin
if [ ${EUID:-${UID}} != 0 ]; then
    echo 'Please try again with root privilege.'
	exit 1
fi

## get ini file absolute path 
current_dir=$(cd $(dirname $0);pwd)
inifile_name=clp_changeip.ini
inifile_path=${current_dir}/${inifile_name}

## get the hostname
hostname=`hostname`

## check the ini file
if [ -e "${inifile_path}" ]; then
	section=(`sed -nre 's|^[ \t]*\[([^]]+)\][ \t]*$|\1|p' < ${inifile_path}`)
	if [ "${#section[*]}" -eq 0 ]; then
		echo "${inifile_name} is abnormal."
		exit 1
	fi
	loop=`expr ${#section[*]} - 1`
else
	echo "There is no ${inifile_path}"
	exit 1
fi

## copy clp.conf
cp -a "/opt/nec/clusterpro/etc/clp.conf" ${current_dir} || {
	echo "failed to copy clp.conf"
	exit 1
}

## make a backup (clp.conf)
cp -a "clp.conf" "clp.conf_bak" || {
	echo "failed to make a backup(clp.conf_bak)"
	exit 1
}

## If there is even one mdc, run cluster stop.
rebootflag=0
for i in `seq 0 ${loop}`
do
	section_name=${section[$i]}
	# analyze inifile
	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    	-e 's/;.*$//' \
    	-e 's/[[:space:]]*$//' \
    	-e 's/^[[:space:]]*//' \
    	-e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   		< ${inifile_path} \
    	| sed -n -e "/^\[${section_name}\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

	if [ "${MODE}" != "lan" -a "${MODE}" != "mdc" ]; then
		echo "Invalid Parameter. Please check the clp_changeIP.ini(MODE=${MODE})."
		exit 1
	fi
	if [ "${MODE}" = "mdc" ]; then
		rebootflag=1
		break
	fi
done

## suspend the cluster(rebootflag = 0) or stop the cluster and mdagent. (rebootflag = 1)
if [ "${rebootflag}" -eq 0 ]; then
	echo "suspend the cluster."
	clpcl --suspend > /dev/null 2>&1
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to suspend the cluster."
		exit ${ret}
	fi
else
	# $rebootflag == 1
	echo "stop the cluster and mdagent."
	clpcl -t -a > /dev/null 2>&1
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to stop the cluster."
		exit ${ret}
	fi
	clpcl -t -a --md > /dev/null 2>&1
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to stop the mdagent."
		exit ${ret}
	fi
fi

for i in `seq 0 ${loop}`
do
	section_name=${section[$i]}

	# analyze inifile
	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    	-e 's/;.*$//' \
    	-e 's/[[:space:]]*$//' \
    	-e 's/^[[:space:]]*//' \
    	-e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   		< ${inifile_path} \
    	| sed -n -e "/^\[${section_name}\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`
	
	if [ "${CUR_IPADDR}" = "" -o "${NEW_IPADDR}" = "" -o "${NEW_PREFIX}" = "" ]; then
		echo "Invalid Parameter. Please check the clp_changeIP.ini(CUR_IPADDR=${CUR_IPADDR}, NEW_IPADDR=${NEW_IPADDR}, NEW_PREFIX=${NEW_PREFIX})."
		exit 1
	fi

	echo "change the server IP Address on OS."
	## Find the appropriate NIC
	matchflag=0
	for DEV in `find /sys/devices -name net | grep -v virtual`
	do
		## get the nic name
		dev_name=(`ls ${DEV}/`)
		ip_addr=(`ip -o -4 addr list ${dev_name} | awk '{print $4}' | cut -d/ -f1`)
		ret=$?
		if [ "${ret}" -ne 0 ]; then
			echo "failed to ip command."
			exit ${ret}
		fi
		if [ "${ip_addr}" = "${CUR_IPADDR}" ]; then
			matchflag=1
			break
		fi
	done
	if [ "${matchflag}" -ne "1" ]; then
		echo "failed to get IP Address(CUR_IPADDR=${CUR_IPADDR})."
		exit 1
	fi

	## Remove the currently network info (defaultgateway)
	nmcli_ipaddr=`nmcli c show ${dev_name} | grep "ipv4.addresses" | awk '{print $2}'`
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to nmcli command (dev_name=${dev_name})."
		exit ${ret}
	fi
	if [ "${nmcli_ipaddr:0:-3}" != "${CUR_IPADDR}" ]; then
		echo "failed to get IP Address(nmcli_curipaddr=${nmcli_ipaddr:0:-3}, CUR_IPADDR=$CUR_IPADDR)."
		exit 1
	fi

	nmcli connection modify ${dev_name} ipv4.gateway 0.0.0.0
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to nmcli command (remove dafault gateway)."
		exit ${ret}
	fi

	## Set the new network info (ipaddress, prefix, defaultgateway)
	if [ "${NEW_DGW}" = "" ]; then
		nmcli connection modify ${dev_name} +ipv4.addresses "${NEW_IPADDR}/${NEW_PREFIX}" 
	else
		nmcli connection modify ${dev_name} +ipv4.addresses "${NEW_IPADDR}/${NEW_PREFIX}" +ipv4.gateway ${NEW_DGW}
	fi
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to nmcli command (set the new network info)."
		exit ${ret}
	fi

	## Remove the currently network info (ipaddress, prefix)
	nmcli connection modify ${dev_name} -ipv4.addresses ${nmcli_ipaddr}
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to nmcli command (remove the ipaddress/prefix)."
		exit ${ret}
	fi

	## Restart the network adapter
	nmcli connection up ${dev_name} > /dev/null 2>&1
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to nmcli command (connection up)."
		exit ${ret}
	fi

	echo "change the IP Address on Cluster."
    id_path=/root/server[@name=\"${hostname}\"]/device/@id
    id_num=`xmllint --xpath "count(${id_path})" clp.conf`
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to xmllint command."
		exit ${ret}
	fi

	echo "change the Interconnect IP Address."
	lan_flag=0
    for j in `seq 1 ${id_num}`
    do
		## get device id (type == lan)
		id=`xmllint --xpath /root/server[@name=\"${hostname}\"]/device/@id clp.conf | awk "{print $"${j}"}" | cut -d\" -f2`
    	conf_mode=`xmllint --xpath "/root/server[@name=\"${hostname}\"]/device[@id=\"${id}\"]/type/text()" clp.conf`
		ret=$?
		if [ "${ret}" -ne 0 ]; then
			echo "failed to xmllint command."
			exit ${ret}
		fi
    	if [ "${conf_mode}" != "lan" ]; then
    		continue
    	fi
		
		## check the ip address (clp.conf)
		conf_ip=`xmllint --xpath "/root/server[@name=\"${hostname}\"]/device[@id=\"${id}\"]/info/text()" clp.conf`
		ret=$?
		if [ "${ret}" -ne 0 ]; then
			echo "failed to xmllint command."
			exit ${ret}
		fi
    	if [ "${conf_ip}" = "$CUR_IPADDR" ]; then
    		clpcfset add device ${hostname} lan ${id} ${NEW_IPADDR} > /dev/null 2>&1
			ret=$?
			if [ ${ret} -ne 0 ]; then
				echo "failed to clpcfset command."
				exit ${ret}
			fi
    		lan_flag=1
    		break
    	fi
    done
    if [ "${lan_flag}" -ne 1 ]; then
	    echo "Invalid Parameter(CUR_IPADDR=${CUR_IPADDR})."
    	exit 1
    fi
 
	if [ "${MODE}" = "mdc" ]; then
    	echo "change the Mirror Disk Connect IP Address."
    	mdc_flag=0
    
		for j in `seq 1 ${id_num}`
    	do
			## get device id (type == lan)
			id=`xmllint --xpath /root/server[@name=\"${hostname}\"]/device/@id clp.conf | awk "{print $"${j}"}" | cut -d\" -f2`
    		conf_mode=`xmllint --xpath "/root/server[@name=\"${hostname}\"]/device[@id=\"${id}\"]/type/text()" clp.conf`
			ret=$?
			if [ "${ret}" -ne 0 ]; then
				echo "failed to xmllint command."
				exit ${ret}
			fi
			if [ "${conf_mode}" != "mdc" ]; then
     			continue
    		fi
		
			## check the ip address (clp.conf)
    		conf_ip=`xmllint --xpath "/root/server[@name=\"${hostname}\"]/device[@id=\"${id}\"]/info/text()" clp.conf`
			ret=$?
			if [ "${ret}" -ne 0 ]; then
				echo "failed to xmllint command."
				exit ${ret}
			fi
    		if [ "${conf_ip}" = "$CUR_IPADDR" ]; then
    			clpcfset add device ${hostname} mdc $((id-400)) ${NEW_IPADDR} > /dev/null 2>&1
				ret=$?
				if [ "${ret}" -ne 0 ]; then
					echo "failed to clpcfset command."
					exit ${ret}
				fi
    			mdc_flag=1
    			break
    		fi
    	done
    	if [ "${mdc_flag}" -ne 1 ]; then
		    echo "Invalid Parameter(CUR_IPADDR=${CUR_IPADDR})."
    		exit 1
    	fi
    fi
done

## convert clp.conf
xmllint  --format --output clp.conf clp.conf
ret=$?
if [ "${ret}" -ne 0 ]; then
	echo "failed to convert clp.conf. ignore."
fi

echo "saved cluster configuration information."
clpcfctrl --push -l -x ${current_dir}

if [ "${rebootflag}" -eq 0 ]; then
	echo "restart cluster services."
	clp_services=("--alert" "--web" "--ib" "--api")
	for clp_service in ${clp_services[@]}
	do
		clpcl -r -a ${clp_service}
		ret=$?
		if [ "${ret}" -ne 0 ]; then
			echo "failed to restart clusterpro service(clp_service=${clp_service})."
			exit ${ret}
		fi
	done
	echo "resume the cluster"
	clpcl --resume > /dev/null 2>&1
	ret=$?
	if [ "${ret}" -ne 0 ]; then
		echo "failed to resume the cluster."
		exit ${ret}
	fi
	echo "Completed changing IP Address."
else
	# $rebootflag == 1
	echo "Completed changing IP Address."
	echo "Please reboot all servers manually."
fi

exit 0
