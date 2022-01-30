# NMAP Output Parser
# -sS -Pn -vvvv -oA xml used

#point script at folder with output .xml files in it...only this xml's please, other file types will be excluded but xml's with other data will error.
$cwd = (get-location).path
$directory = $cwd

$files = (Get-ChildItem $directory) |?{$_.name -like "*xml"}

$results = @()
$file_i = 1
$file_c = $files.count

foreach($f in $files){
   
    write-progress -Activity "Parsing data from $f" -Status "$file_i of $file_c" -PercentComplete ($file_i/$file_c*100)

    $xmlpath = $f
    [xml]$xml_scan = get-content $xmlpath

    #total hosts
    $i = $xml_scan.nmaprun.runstats.hosts.total

    # my version of reporting what is and is not up! based on responses of reject or syn-ack
    Write-host $i scanned 

#so it totally works next you need to cycle through all the xml files in a directory!

#1 host at a time in an array
$hosts = $xml_scan.nmaprun.host
$host_i = 1
$host_c = $hosts.count
        foreach($h in $hosts){
            $h_name = $h.address.addr
            write-progress -Activity "Parsing data from $h_name" -Status "$host_i of $host_c" -PercentComplete ($host_i/$host_c*100)
        #addresses
        $ports = $h.ports.port
        $port_i = 1
        $port_c = $ports.count
                                foreach($port in $ports){
                                    write-progress -Activity "Parsing data from $port" -Status "$port_i of $port_c" -PercentComplete ($port_i/$port_c*100)
                                        $ipv4_Address = $h.address.addr
                                        $p = $port.portid
                                        $protocol = $port.protocol
                                        $state = $port.state.state
                                        $response = $port.state.reason
                                        $ttl = $port.state.reason_ttl
                                        $service = $port.service.name
                                        $properties = [ordered]@{
                                                                        ipv4_Address = $ipv4_Address
                                                                        port = $p
                                                                        protocol = $protocol
                                                                        state = $state
                                                                        response = $response
                                                                        ttl = $ttl
                                                                        service = $service
                                                                }
                                                                    
                                                                    
                                                                    $obj = new-object -TypeName psobject -Property $properties
                                                                    $results += $obj
                                                                    $port_i++
                                                                    }
                                                                    $host_i++
                                                                }                                                
        
                                                $file_i++
                                                }


                                        #time for some dope ass stats
#were ttl is greater than 0 indicates an actual response and host is up - syn scan no host check
$total_ports = $results.count
$total_hosts = ($results.ipv4_Address | Get-Unique).count
$resp_ports = $results | ?{$_.ttl -gt 0}
$resp_hosts = $resp_ports.ipv4_Address |Get-Unique
$resp_open_ports = $results | ?{$_.response -eq "syn-ack"} 
$resp_open_hosts = $resp_open_ports.ipv4_Address | Get-unique
$resp_reset_ports = $results | ?{$_.response -eq "reset"}

#Report

Write-host -foregroundcolor Green "Completed analysis for "$total_hosts" hosts across $total_ports in this scan:"
Write-host -backgroundcolor yellow $resp_hosts.count "Responded with a non zero ttl packet."
Write-host -backgroundcolor green $resp_open_hosts.count  " Responded with open ports."
Write-host $resp_ports.Count "responding ports, over" $resp_hosts.count " responding hosts."
Write-host $resp_open_ports.count  "ports found open by syn-ack response"
Write-host $resp_reset_ports.count "ports responded with reset but had a non zero ttl"


## Exporting results!!!
$filename = Read-host "input new file name"
$path = (get-location).path
$path = $directory+"\"+$filename
$results | Export-Clixml -path "$path.xml"
$results | Export-csv -notypeinformation -encoding utf8 -Delimiter "," -path "$path.csv"

#create uplists
$resp_hosts.ipv4_Address | out-file -filepath $directory/all_hosts.txt


# Module 2 for Trace Route

##############################################################################################
#######################Ping Echo Discovery and Traceroute Response Parsing####################
##############################################################################################
#Currently Only takes one file at a time.
#ping with traceroute
# -PE -sn -iL -oA -vvv
#what scan do you want to parse question.
<#
Function nmaparse-pe_tr(){
$pe_tr_file = "D:\FLDFS\hosttraceroute\all_ping_responding_hosts_traceroute.xml"

[xml]$pe_tr_scan = get-content $pe_tr_file

$host_results = $pe_tr_scan.nmaprun.host

$results = @()

foreach($h in $host_results){
                                    $i = $h.trace.count - 2
                                    $lasthop = $h.trace.hop

                                    $properties = @{ 
                                                        Host_IP = $h.address.addr   

                                                        State = $h.status.state

                                                        Reason = $h.status.reason

                                                        TTL = $h.status.reason_ttl

                                                        Trace_PROTO = $h.trace.proto
                                                        
                                                        LAST_HOP_TTL = $lasthop[$i].ttl
                                                        
                                                        LAST_HOP_IP  = $lasthop[$i].ipaddr
                                                    }
                                    
                                    $obj = new-object -TypeName psobject -Property $properties
                                    $results += $obj
                                }



## Exporting results!!!
$filename = Read-host "input new file name"
$path = (get-location).path
$path = $directory+"\"+$filename
$results | Export-Clixml -path "$path.xml"
$results | Export-csv -notypeinformation -encoding utf8 -Delimiter "," -path "$path.csv"

}#>