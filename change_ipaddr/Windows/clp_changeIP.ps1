#  Changing the server IP Address for windows

function GetIniContent($filePath) {

    $parameter = [ordered]@{}

    switch -regex -file $filePath {
        "^\[(.+)\]" {
            $section = $matches[1]
            $parameter[$section] = @{}
        }
        "(.+?)\s*=(.*)" {
            $name, $value = $matches[1..2]
            if($section -eq $null) {
                $section = "NoSection"
                $parameter[$section] = @{}
            }
            $parameter[$section][$name] = $value
        }
    }

    return $parameter
}

echo "start changing IP Address."
## check admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$bool_admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$bool_admin) {
    echo "Please try again with Administrator privilege."
    exit 1
}

## get ini file absolute path
$inifile_path = @(Split-Path $script:myInvocation.MyCommand.path -parent).Trim()
$inifile_name = "clp_changeIP.ini"
$inifile_path = "$inifile_path" + "\" + "$inifile_name"

## get the hostname (lowercase)
$str = HOSTNAME.EXE
$hostname = $str.ToLower()

## get the clp.conf absolute path (clustepro)
$clp_install_path = "C:\Program Files\CLUSTERPRO"
$clp_config_name = "etc\clp.conf"
$clp_config_path = "$clp_install_path" + "\" + "$clp_config_name"

## get the command absolute path (clusterpro)
$clp_cl_name = "bin\clpcl.exe"
$clp_cl_path = "$clp_install_path" + "\" + "$clp_cl_name"

$clp_cfset_name = "bin\clpcfset.exe"
$clp_cfset_path = "$clp_install_path" + "\" + "$clp_cfset_name"

$clp_cfctrl_name = "bin\clpcfctrl.exe"
$clp_cfctrl_path = "$clp_install_path" + "\" + "$clp_cfctrl_name"

$clp_stdn_name = "bin\clpstdn.exe"
$clp_stdn_path = "$clp_install_path" + "\" + "$clp_stdn_name"

## call function
If((Test-Path $inifile_path) -ne $true){
    echo "There is no $inifile_path."
    exit 1
} else {
    $parameter = GetIniContent $inifile_path
}

## copy clp.conf
$currentdir = Split-Path $MyInvocation.MyCommand.Path
Copy-Item -Path $clp_config_path -Destination $currentdir
If($? -ne $true){
    echo "failed to Copy-Item from $clp_config_fullpath to $currentdir."
    exit 1
}

## make a backup (clp.conf)
$clp_config_backup = $currentdir + "\" + "clp.conf_bak"
Copy-Item -Path $clp_config_path -Destination $clp_config_backup
If($? -ne $true){
    echo "failed to make a backup(clp.conf_bak)."
    exit 1
}

## If there is even one mdc, run cluster stop.
$rebootflag = 0
if ($parameter -ne $null) {
    foreach ($sectionKey in $parameter.Keys) {
        if ($parameter[$sectionKey].MODE -ne "lan" -and $parameter[$sectionKey].MODE -ne "mdc") {
            $mode = $parameter[$sectionKey].MODE
            echo "Invalid Parameter. Please check the clp_changeIP.ini(MODE=$mode)."
            exit 1
        }
        if ($parameter[$sectionKey].MODE -eq "mdc") {
            $rebootflag = 1;
        }    
    }
}

## suspend the cluster(rebootflag = 0) or stop the cluster (rebootflag = 1)
if($rebootflag -eq 0) {
    echo "suspend the cluster."
    &$clp_cl_path --suspend > $null
    if($? -ne $true){
        echo "failed to suspend the cluster."
        exit 1
    }
} else { 
    # $rebootflag = 1
    echo "stop the cluster."
    &$clp_cl_path -t -a > $null
    if($? -ne $true){
        echo "failed to stop the cluster."
        exit 1
    }
}

if ($parameter -ne $null) {
    foreach ($sectionKey in $parameter.Keys) {
        $cur_ipaddr = $parameter[$sectionKey].CUR_IPADDR
        $new_ipaddr = $parameter[$sectionKey].NEW_IPADDR
        $new_prefix = $parameter[$sectionKey].NEW_PREFIX
        $new_dgw = $parameter[$sectionKey].NEW_DGW
        $mode = $parameter[$sectionKey].MODE

        if ([String]::IsNullOrEmpty($cur_ipaddr) -or [String]::IsNullOrEmpty($new_ipaddr) -or [String]::IsNullOrEmpty($new_prefix)) {
            echo "Invalid Parameter. Please check the clp_changeIP.ini(CUR_IPADDR=$cur_ipaddr, NEW_IPADDR=$new_ipaddr, NEW_PREFIX=$new_prefix)."            
            exit 1
        }

        echo "change the server IP Address on OS."
        ## get the InterfaceIndex and currently prefix
        $nwinfo = Get-NetIPAddress -IPAddress $cur_ipaddr
        If($? -ne $true){
            echo "failed to Get-NetIPAddress."
            exit 1
        }

        ## get the currently Default Gateway
        $cur_dgw = Get-NetIPAddress -IPAddress $cur_ipaddr| Get-NetIPConfiguration | Foreach IPv4DefaultGateway | Foreach NextHop
        If($? -ne $true){
            echo "failed to get DefaultGateway."
            exit 1
        }

        ## Remove the currently network info (ipaddress, prefix, defaultgateway)
        if (![String]::IsNullOrEmpty($cur_dgw)) {
            Remove-NetIPAddress -AddressFamily IPv4 -IPAddress $cur_ipaddr -PrefixLength $nwinfo.PrefixLength -DefaultGateway $cur_dgw -Confirm:$false
        } else {
            Remove-NetIPAddress -AddressFamily IPv4 -IPAddress $cur_ipaddr -PrefixLength $nwinfo.PrefixLength -Confirm:$false
        }
        If($? -ne $true){
            echo "failed to Remove-NetIPAddress."
            exit 1
        }
        
        ## Set the new network info (ipaddress, prefix, defaultgateway)
        if (![String]::IsNullOrEmpty($new_dgw)) {
            New-NetIPAddress -InterfaceIndex $nwinfo.InterfaceIndex -AddressFamily IPv4 -IPAddress $new_ipaddr -PrefixLength $new_prefix -DefaultGateway $new_dgw
        } else {
            New-NetIPAddress -InterfaceIndex $nwinfo.InterfaceIndex -AddressFamily IPv4 -IPAddress $new_ipaddr -PrefixLength $new_prefix
        }
        If($? -ne $true){
            echo "failed to New-NetIPAddress."
            exit 1
        }

        ## restart the network adapter
        Restart-NetAdapter -Name $nwinfo.InterfaceAlias
        If($? -ne $true){
            echo "failed to Restart-NetAdapter."
            exit 1
        }

        echo "change the IP Address on Cluster."
        
        $clp_conf = [XML](Get-Content $clp_config_path)
        $clp_srvname = $clp_conf.root.server | Where-Object {$_.name -eq $hostname}
        $clp_lan = $clp_srvname.device | Where-Object {$_.type -eq "lan"}
        $clp_mdc = $clp_srvname.device | Where-Object {$_.type -eq "mdc"}

       
        if (![String]::IsNullOrEmpty($clp_lan)) {
            echo "change the Interconnect IP Address."
            $clp_lan_num = @($clp_lan).Length
            for ($i = 0; $i -lt $clp_lan_num; $i++) {
                if (@($clp_lan)[$i].info -eq $cur_ipaddr) {
                    &$clp_cfset_path add device $hostname lan @($clp_lan)[$i].id $new_ipaddr > $null
                    if($? -ne $true){
                        echo "failed to clpcfset command."
                        exit 1
                    }
                    break
                }
            }
            if ($i -eq $clp_lan_num) {
                echo "Invalid Parameter."
                exit 1
            }
        }

        ## only mode = mdc        
        if($mode -eq "mdc") {
            if (![String]::IsNullOrEmpty($clp_mdc)) {
                echo "change the Mirror Disk Connect IP Address."
                $clp_mdc_num = @($clp_mdc).Length
                for ($i = 0; $i -lt $clp_mdc_num; $i++) {
                    if (@($clp_mdc)[$i].info -eq $cur_ipaddr) {
                        &$clp_cfset_path add device $hostname mdc (@($clp_mdc)[$i].id -400) $new_ipaddr > $null
                        if($? -ne $true){
                            echo "failed to clpcfset command."
                            exit 1
                        }
                        break
                    }
                }
                if ($i -eq $clp_mdc_num) {
                    echo "cur_ipaddr and clsparam(mdc) do not match."
                    exit 1
                }
            } else {
                echo "mdc is NULL. Invalid Parameter."
                exit 1
            }
        }
        
        ## NIC Link Up/Down monitor resource
        $clp_conf = [xml](Get-Content $clp_config_path)
        $clp_miiw = $clp_conf.root.monitor.types| Where-Object {$_.name -eq "miiw"}
        
        if (![String]::IsNullOrEmpty($clp_miiw)) {
            $clp_miiw_num = @($clp_conf.root.monitor.miiw.name).Length
        
            for ($i = 0; $i -lt $clp_miiw_num; $i++) {
                $clp_miiw_name = @($clp_conf.root.monitor.miiw)[$i].name
                $clp_miiw_srv =  @($clp_conf.root.monitor.miiw)[$i].server| Where-Object {$_.name -eq $hostname}
        
                if (![String]::IsNullOrEmpty($clp_miiw_srv) -and $clp_miiw_srv.parameters.object -eq $cur_ipaddr) {
                    echo "change the NIC Link Up/Down monitor resource IP Address."
                    &$clp_cfset_path add monparam miiw $clp_miiw_name server@$hostname/parameters/object $new_ipaddr > $null
                    if($? -ne $true){
                        echo "failed to clpcfset command."
                        exit 1
                    }
                }
            }
        }
    }
}

sleep 10

echo "saved cluster configuration information."
&$clp_cfctrl_path --push -x $currentdir
#if($? -ne $true){
#    echo "failed to clpcfctrl command."
#    exit 1
#}

## resume the cluster(rebootflag = 0) or reboot the cluster (rebootflag = 1)
if($rebootflag -eq 0) {
    echo "restart clusterpro services."
    $clp_service = @(@("--alert"),
                     @("--web"),
                     @("--ib"),
                     @("--api"),
                     @())

    for ($i = 0; $i -lt ($clp_service.Length -1); $i++) {
        &$clp_cl_path -r -a $clp_service[$i]
        if($? -ne $true){
            echo "failed to restart clusterpro service."
            exit 1
        }
    }
    echo "resume the cluster."
    &$clp_cl_path --resume > $null
    if($? -ne $true){
        echo "failed to resume the cluster."
        exit 1
    }
    echo "Completed changing IP Address."
} else {
    # rebootflag = 1
    echo "Completed changing IP Address."
    echo "Please reboot all servers manually."
}

exit 0
