<#Sensors



#>

#Generate XML
#IPConfiguration
netsh interface ipv4 show interface
Get-DnsClientServerAddress# |where-object -property  Select-Object –ExpandProperty ServerAddresses
Get-NetAdapter |select *
#After Running the Generat XML part of the Sensor set up a task in the stask scheduler to run onl the following function to check the xml and write to another logfile.

Function Run-Sensor
{
$Status = Import-Clixml $XML_Path
#Comparison Logic
$c = $Stats.count
$i = 0
While($i -le $c){
                  If($Status[$i].Desired -ne $Status[$i].Current){
                                                                 #Consistently Formatted indicator for monitor script to pick up like ^ or ANOM or something cool.
                                                                 }Else{
                  $i++}
                }

#Connection Check

Test-Connection $Status.DNS1.Desired
Test-Connection $Status.DNS2.Desired
Test-Connection $Status.



}
#Read XML

#Compare Values in XML


