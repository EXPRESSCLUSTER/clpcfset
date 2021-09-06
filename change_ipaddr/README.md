# How to change the cluster server IP Address using clpcfset

## Overview
From EXPRESSCLUSTER X 4.3, EXPRESSCLUSTER can create the cluster configration data file using **clpcfset** command.  
This guide introduces a script that uses the clpcfset command to automate the change of the cluster server's IP Address.

### Script Configuration
- The following files are required to use this script.
     - In the case of Windows
         - clp_changeIP.ps1
         - clp_changeIP.ini (Configuration file)
     - In the case of Linux
         - clp_changeIP.sh
         - clp_changeIP.ini (Configuration file)

### Software versions
 - In the case of Windows
     - Windows Server 2019 or Windows Server 2016
     - EXPRESSCLUSTER X 4.3 for Windows (internal version : 12.30)
 - In the case of Linux
     - CentOS 7.9
     - EXPRESSCLUSTER X 4.3 for Linux (internal version : 4.3.0-1)

### How to use the script
1. (Linux only) Please install xmllint.
1. Place the script and configuration file in any directory.  
but, the script and configuration file must be in the **same directory**.
1. Edit clp_changeIP.ini.  
The parameters of clp_changeIP.ini are as follows.  
Also, please check the detailed modification method of clp_changeIP.ini as described later.
	```
		[interconnect1]
		CUR_IPADDR=      ★ Currently IP Address
		NEW_IPADDR=      ★ Newly IP Address
		NEW_PREFIX=      ★ Newly subnetmask
		NEW_DGW=         ★ Newly default gateway
		MODE=            ★ mdc if used as mirror disk connect
		                    lan if used as heartbeat
	```

1. Check the status of the cluster using clpstat or Cluster WebUI.  
If it is not in the normal status, remove the failure. 

1. Change to the directory that contains the script and configuration file.

1. Execute the script with **administrator privileges**.

1. If the script ends normally, perform the following operations.
     - In the case of setting at least one **mdc** in the MODE parameter in clp_changeIP.ini
         - Restart all servers manually.
     - In the case of setting **lan** in all MODE parameter in clp_changeIP.ini
         - No action is required.  
           Check the status of the cluster using clpstat or Cluster WebUI.

This completes the IP address change of the cluster server.

### Notes
- This script can only change IPv4. IPv6 cannot be changed.
- If this script terminates abnormally in the middle, the parameters modified by this script will remain reflected.  
Therefore, if you want to return to the previous parameters, you have to fix it yourself.
- This script cannot be used when **mirror communication only** is selected as the heartbeat type.
- DNS server and floating IP Address cannot be changed.  
  The parameters that can be modified using this script are as follows:
     - IP Address (IPv4)
     - subnet mask
     - default gateway
- It is possible to change multiple IP addresses at once.  
  For details, refer to How to modify the inifile described later.
- Even if the script ends normally, mdw may become abnormal.  
  In that case, please execute cluster shutdown and restart all servers manually.
     - set lan and mdc as heartbeats.
     - In the case of modifying only the IP address set in **lan**.

### (Reference) How to modify the inifile described
case 1: In the case of changing 192.168.1.90/24 to 192.168.1.96/24(no defaultgateway and using mdc)
```
	[interconnect1]
	CUR_IPADDR=192.168.1.90
	NEW_IPADDR=192.168.1.96
	NEW_PREFIX=24
	NEW_DGW=
	MODE=mdc
```
case2: In the case of changing 192.168.1.90/24 to 192.168.1.96/24(no defaultgateway and using mdc)  
      and in the case of changing 192.168.0.90/24 to 192.168.0.96/24 (defaultgateway 192.168.0.1 and using lan)
```
	[interconnect1]
	CUR_IPADDR=192.168.1.90
	NEW_IPADDR=192.168.1.96
	NEW_PREFIX=24
	NEW_DGW=
	MODE=mdc

	[interconnect2]
	CUR_IPADDR=192.168.0.90
	NEW_IPADDR=192.168.0.96
	NEW_PREFIX=24
	NEW_DGW=192.169.0.2
	MODE=lan
```
