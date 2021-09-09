<#
SpaceGhost

Mode Redirect

Monitor Sensors and Alert

#>

Write-Host "Hello, how may I help you?"
Write-Verbose "Hello, how may I help you?"

#categories
$global:cat = $null
function change-mode{
$c = read-host "Choose a Mode
                 1 -->Local System Diagnosis"
                 Set-Variable -Name cat -Value ($c) -Scope Global

#cat 1 local system launch

switch ($cat)
                {
                1 {start-process F:\WorkBench\PowerShell\SpaceGhost\Mode\LocalSys-Diag.ps1; change-mode }
                2 {start-process}
                3 {start-process}
                4 {start-process}
                default{Mode-Main}
                }

            }
#When you choose nothing monitor mode to sensors.
Mode-Main
{
   $error = $false
   
   While($error = $false)   {
                                #Check Sensor 1
                                #Check Sensor 2
                                #Check Sensor 3
                                #Check Sensor 4
                                #Check Sensor 5
                                #if message -match $triggers $error = $true  & $finding = $check#

   
                            }
   
   
   
   
   Write-error -Message "I have found an problem" -RecommendedAction "I recommend you run error-report"
   Write-Warning -Message "I have found an anomoly that may require your attention"








}
#cat 2 launch


#cat 3 launch


#cat 4 launch


#Helpful functions

function Report-localSystems   {
                                    #current computer domain
                                    Get-WmiObject -class win32_computersystem |select Domain
                                    #current windows operating version
                                    Get-WmiObject -class win32_operatingsystem | select version
                                    #current ip configuration
                                    Get-NetAdapter |where -property Status -eq Up


                                }



function Report-serverSystems {}



function Report-externalSystems {}
$a = 001
$b = 254
$ip = "172.20.4."



$i = $a
while($i -lt $b){
$ip = "172.20.0."
$ip = $ip + $i
$ip
test-connection -Count 1 $ip -Quiet
$i++

}






