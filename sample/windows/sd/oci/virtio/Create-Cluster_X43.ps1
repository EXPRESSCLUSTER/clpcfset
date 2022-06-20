######################################################
# Create Shared Disk Type Cluster on OCI (VirtIO)
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
$SERVER1="server1"
$SERVER1LAN1="10.0.1.120"
$SERVER2="server2"
$SERVER2LAN1="10.0.1.150"
$HBA="PCI\VEN_1AF4&amp;DEV_1004&amp;SUBSYS_0008108E&amp;REV_00"
$SYSTEMGUID1="55edbb61-db75-49cc-9e3e-5c108aae6c04"
$CGUID1="e5ed6e77-9bf5-4c2f-8e37-00cad39ab7c6"
$SYSTEMGUID2="55edbb61-db75-49cc-9e3e-5c108aae6c04"
$CGUID2="e5ed6e77-9bf5-4c2f-8e37-00cad39ab7c6"
#-----------------------------------------------------
# Network Partition (NP) Resource
# Ping NP
$PINGTARGET=""
# Disk NP
#  You can get GUID with following command
#  clpdiskctrl get guid P:
$NPDRIVE="D:\"
$NPGUID="a1f0d795-caa3-47a2-b911-598c7e38a2da"
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
$SD1DRIVE="E:"
$SD1GUID="bc6d06d2-63f3-410a-aab2-8dc12b75add6"
$SD2NAME="sd2"
$SD2DRIVE="F:"
$SD2GUID="a02906de-d3d3-4b6e-9946-ad000cc1718d"
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
clpcfset add hba $SERVER1 0 0 $HBA 20
clpcfset add hba $SERVER2 0 0 $HBA 20
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

#=====================================================
# Add [Partition excluded from cluster management]
# - clpcfset doesn't support the above parameter so 
#   that you need to create a XML node as below.
#-----------------------------------------------------
Copy-Item clp.conf clp.conf.bak
$clpconf = [XML](Get-Content clp.conf)
#-----------------------------------------------------
# Add [Partition excluded from cluster management] for server1
#-----------------------------------------------------
$ID=0
$newVolElement = $clpconf.root.server[$ID].hba.AppendChild($clpconf.CreateElement("vol"))
$newVolElement.SetAttribute("id", "0")
$newVolGUID = $newVolElement.AppendChild($clpconf.CreateElement("volumeguid"))
$newVolGUID.AppendChild($clpconf.CreateTextNode($SYSTEMGUID1))
$newVolMout = $newVolElement.AppendChild($clpconf.CreateElement("volumemountpoint"))
$newVolElement = $clpconf.root.server[$ID].hba.AppendChild($clpconf.CreateElement("vol"))
$newVolElement.SetAttribute("id", "1")
$newVolGUID = $newVolElement.AppendChild($clpconf.CreateElement("volumeguid"))
$newVolGUID.AppendChild($clpconf.CreateTextNode($CGUID1))
$newVolMout = $newVolElement.AppendChild($clpconf.CreateElement("volumemountpoint"))
$newVolMout.AppendChild($clpconf.CreateTextNode("C:\"))
#-----------------------------------------------------
# Add [Partition excluded from cluster management] for server2
#-----------------------------------------------------
$ID=1
$newVolElement = $clpconf.root.server[$ID].hba.AppendChild($clpconf.CreateElement("vol"))
$newVolElement.SetAttribute("id", "0")
$newVolGUID = $newVolElement.AppendChild($clpconf.CreateElement("volumeguid"))
$newVolGUID.AppendChild($clpconf.CreateTextNode($SYSTEMGUID2))
$newVolMout = $newVolElement.AppendChild($clpconf.CreateElement("volumemountpoint"))
$newVolElement = $clpconf.root.server[$ID].hba.AppendChild($clpconf.CreateElement("vol"))
$newVolElement.SetAttribute("id", "1")
$newVolGUID = $newVolElement.AppendChild($clpconf.CreateElement("volumeguid"))
$newVolGUID.AppendChild($clpconf.CreateTextNode($CGUID2))
$newVolMout = $newVolElement.AppendChild($clpconf.CreateElement("volumemountpoint"))
$newVolMout.AppendChild($clpconf.CreateTextNode("C:\"))
#-----------------------------------------------------
# Save
#-----------------------------------------------------
$clpconf.Save("$pwd\clp.conf")
#=====================================================
