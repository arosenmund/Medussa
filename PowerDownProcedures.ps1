#Power down procedures.


#allow the script to work with powercli commands
Add-PSSnapin Vmware.VIMautomation.core

#Set Variables
$VIserver = "10.101.1.142"

$esxihostVal

[array]$DbServer = "test1","test2","test3"

$DbServer[]

[array]$Esxi = "10.101.1.142"
#input vcenter credential.
$cred = Get-Credential

#connect to vcneter before executing commands
connect-viserver $VIserver

#stop sets of servers in order but not Vcenter
Stop-VMGuest $NonEssentials

Stop-VmGuest $VDI

Stop-VmGuest $fileServers

Stop-VmGuest $DbServer

Stop-VmGuest $Backups

Stop-VMGuest -

###Find out what esxi host the Vcenter server is on.

$VCHost = get-vm vcenter | select-object vmhost
$VCHost = $VCHost.vmhost.name

$Hoststurned = get-vmhost |where name -ne $VChost

for-each($host in $Hoststurned){
set-vmhost -VMHost $host -State Maintenance

start-sleep 20

}

for-each($host in $Hoststurned){
stop-vmhost -VMHost $host -Force

start-sleep 20

}

###all machines execpt for the one running Vcenter will now be off.

