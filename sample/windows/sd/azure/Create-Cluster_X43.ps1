######################################################
# Create Shared Disk Type Cluster on Azure
# - 2-node cluster
# - Two shared disks
# - All LUNs are formatted with GPT
######################################################

#=====================================================
# Parameters
#-----------------------------------------------------
# Cluster
$CLUSTERNAME="cluster"
$ENCODE="ASCII"
#-----------------------------------------------------
# Server
$SERVER1="ws2022-01"
$SERVER1LAN1="10.0.0.4"
$SERVER2="ws2022-02"
$SERVER2LAN1="10.0.0.5"
$HBAPORT="1"
$DEVICEID="VMBUS\{ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}"
$INSTANCEID="{f8b3781b-1e82-4818-a1c3-63d806ec15bb}"
#-----------------------------------------------------
# Disk NP
#  You can get GUID with following command
#  clpdiskctrl get guid P:
$NPDRIVE="R:\"
$NPGUID="9bcb0d48-960d-434c-83e1-d6fc67b0a633"
#-----------------------------------------------------
# Group
#-----------------------------------------------------
$FAILOVER1="failover1"
#-----------------------------------------------------
# Resource
#-----------------------------------------------------
# Disk 
#  You can get GUID with following command
#  clpdiskctrl get guid E:
$SD1NAME="sd1"
$SD1DRIVE="S:"
$SD1GUID="2c900b9d-6568-49ed-98d8-dbba0a023837"
$SD2NAME="sd2"
$SD2DRIVE="T:"
$SD2GUID="6797dfaa-1da5-4fed-a93a-659103c9ea06"
#-----------------------------------------------------
# Monitor
#-----------------------------------------------------
# Disk TUR Monitor resource
$SDW1NAME="sdw1"
$SDW2NAME="sdw2"
# User Mode Monitor resoruce
$USERWNAME="userw"
#=====================================================

#=====================================================
# Initialize clp.conf file
#-----------------------------------------------------
Write-Output "Initialize"
clpcfset create $CLUSTERNAME $ENCODE
#=====================================================

#=====================================================
# Add servers
#-----------------------------------------------------
Write-Output "Add servers"
clpcfset add srv $SERVER1 0
clpcfset add srv $SERVER2 1
#=====================================================

#=====================================================
# Add HBA filters
#-----------------------------------------------------
Write-Output "Add HBA filters"
clpcfset add hba $SERVER1 0 $HBAPORT $DEVICEID $INSTANCEID
clpcfset add hba $SERVER2 0 $HBAPORT $DEVICEID $INSTANCEID
#=====================================================

#=====================================================
# Add devices
#-----------------------------------------------------
Write-Output "Add devices (LAN)"
clpcfset add device $SERVER1 lan 0 $SERVER1LAN1
clpcfset add device $SERVER2 lan 0 $SERVER2LAN1
Write-Output "Add devices (disknp)"
clpcfset add device $SERVER1 disknp 0 $NPGUID $NPDRIVE
clpcfset add device $SERVER2 disknp 0 $NPGUID $NPDRIVE
#=====================================================

#=====================================================
# Add heartbeat resources
#-----------------------------------------------------
Write-Output "Add heartbeat resources"
clpcfset add hb lankhb 0 0
#=====================================================

#=====================================================
# Add disk NP resources
#-----------------------------------------------------
Write-Output "Add disk NP resources"
clpcfset add np disknp 0 0
#=====================================================

#=====================================================
# Add groups
#-----------------------------------------------------
Write-Output "Add failover groups"
clpcfset add grp failover $FAILOVER1
#=====================================================

#=====================================================
# Add resources
#-----------------------------------------------------
Write-Output "Add resources"
clpcfset add rsc $FAILOVER1 sd $SD1NAME
clpcfset add rsc $FAILOVER1 sd $SD2NAME
#-----------------------------------------------------
# Disk
#-----------------------------------------------------
clpcfset add rscparam sd $SD1NAME parameters/volumemountpoint $SD1DRIVE
clpcfset add rscparam sd $SD1NAME server@$SERVER1/parameters/volumeguid $SD1GUID
clpcfset add rscparam sd $SD1NAME server@$SERVER2/parameters/volumeguid $SD1GUID
clpcfset add rscparam sd $SD2NAME parameters/volumemountpoint $SD2DRIVE
clpcfset add rscparam sd $SD2NAME server@$SERVER1/parameters/volumeguid $SD2GUID
clpcfset add rscparam sd $SD2NAME server@$SERVER2/parameters/volumeguid $SD2GUID
#=====================================================

#=====================================================
# Add monitor resources
#-----------------------------------------------------
Write-Output "Add monitors"
clpcfset add mon sdw $SDW1NAME
clpcfset add mon sdw $SDW2NAME
clpcfset add mon userw $USERWNAME
#-----------------------------------------------------
# 
#-----------------------------------------------------
Write-Output "Add monitor parameters (sdw)"
clpcfset add monparam sdw $SDW1NAME parameters/object $SD1NAME
clpcfset add monparam sdw $SDW1NAME relation/type rsc
clpcfset add monparam sdw $SDW1NAME relation/name $SD1NAME
clpcfset add monparam sdw $SDW2NAME parameters/object $SD2NAME
clpcfset add monparam sdw $SDW2NAME relation/type rsc
clpcfset add monparam sdw $SDW2NAME relation/name $SD2NAME
#-----------------------------------------------------
# 
#-----------------------------------------------------
Write-Output "Add monitor parameters (userw)"
clpcfset add monparam userw $USERWNAME relation/type cls
clpcfset add monparam userw $USERWNAME relation/name LocalServer
#=====================================================
