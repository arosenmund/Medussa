$keyfile = ".\.ssh\redscan-key"
$project_name = "pursuant_health"
#need to add proejct configs that this can pull from in a xml file, or json
$t = 0.5
$n = 5
#add nodes to proejct configuration as output from terraforming
$e = get-content .\nodes
$targets = Import-Clixml .\targets\pursuant_health\web-1000_target_list.xml



<#
foreach($targ in $targets){ 
    $ip = $targ.ip
    $port = $targ.port
    $n = $targ.n
    $ext_ip = $e[$n-1]
    $nmap_command = "sudo nmap -Pn -nn --scan-delay $t --data-length 0 --max-retries 2 -sS -p $port $ip  -v  -oA $project_name-$ip-$port-$n -vvv"
    ssh -i $keyfile ubuntu@$ext_ip $nmap_command
    $path=":/home/ubuntu/"+$project_name+"-"+$ip+"-"+$port+"-"+$n+".xml"
    scp -i $keyfile ubuntu@$ext_ip$path .
}
#>

# collect files iterate through each
$total = $targets.count
$ii = 0
while($ii -lt $total ){
    $seconds_remaining = ($total - $ii) * $t / $n
    $perc = $ii/$total * 100
    $r = ($ii+$n)
    write-progress -PercentComplete $perc -SecondsRemaining $seconds_remaining -CurrentOperation "Scanning batch $ii through $r" -Activity "Nmap Scanning"
        $nc = $targets.count - 1
        if($targets.count -lt $n){$c = $nc}else{$c = $n - 1}
            $batch = $targets[0..$c]
            $batch | foreach-object -parallel {
                $ip = $_.ip
                $port = $_.port
                $n = $_.n
                $pext_ip = $($using:e)[$n-1]
                write-host -Message "$pext_ip scanning $ip on port $port" -ForegroundColor Green
                $pt = $($using:t)
                $pproject_name = $($using:project_name)
                $nmap_command = "sudo nmap -Pn -nn --scan-delay $pt --data-length 0 --max-retries 2 -sS -p $port $ip  -v  -oA $pproject_name-$ip-$port-$n -vvv"
                
                ssh -i $($using:keyfile) ubuntu@$pext_ip $nmap_command
                $path=":/home/ubuntu/"+$pproject_name+"-"+$ip+"-"+$port+"-"+$n+".xml"
                #$result_path="C:\Users\tstark\OneDrive\projects\medussa\results\pursuant_health\"+$pproject_name+"-"+$ip+"-"+$port+"-"+$n+".xml"
                
                scp -i $($using:keyfile) ubuntu@$pext_ip$path C:\Users\tstark\OneDrive\projects\medussa\results\pursuant_health\
                
            } -asjob

            $ii+=5
            if($nc -le 4){ write-host -message "Scans are complete, next step is analysis."}
            $targets = $targets[5..$nc]
            
}




####Option 1 one allows all files to be uploaded to the given devices, the devices then report to files that are then collected back together.
#creat separate lists this is only necesary if we want to allow the given devices to scan by themselves, I think this should be an option.
<#$g = 1
while ($g -le $n){
    $f = $project_name-ip-targets-group-$g.txt
    $full_scope | where {$_.n -eq $g} | select ip,port |out-file $f
    scp -i $keyfile $f ubuntu@$n_ip:/home/ubuntu/$
    ssh -i $keyfile ubuntu@$n_ip $nmap_command
    $g++
}
#>
# move each file to the given device 1-$n

#run each IP individually from each file

#pull results together and run the reporting script.  Also convert reporting script results to json for export into mongo db.




#from here another process will pick up each file and distribute it to the appropriate n device spun up in terraform.

#read tf state file and pick up external IPs
#get-content
#convertfrom-json
#ssh ubuntu@$nip nmap --data-lenght 0 -sS -n -p $p $ip 
#then send scp command in parrallell to execute nmap commands and parse return from jobs into csv/json/mongdb

#calculating times