# IRONCAT
# 11-21
# Take IP ranges and port ranges or lists and create individual lists to give to each device to perform scans.
#nmap binary is a requirment
function create_ip_list() {
        #IP Range Parsing
        $choice = read-host "Enter 1 to load a file with a list of ips or 2 to manually input networks."
                            
        if ($choice -eq 1) {
            $iplistfile = read-host "input the IP list file with full path."
            $ips = get-content $iplistfile
            return $ips
        }else{
        [array]$networks = read-host "Enter networks seaparated by comma's"
        #remove spaces
            $networks = $networks.replace(" ","").split(",")
            $networks = get-content D:\Pursuant-Health\aprooved-ph-ips.txt
            $ips = @()
            foreach($net in $networks){
                #print out list per subnet
                $iplist =  nmap -n -sL $net | foreach {$_.split(" ")[4]}
                $i = $iplist.count
                $i = $i-2
                $iplist = $iplist[1..$i]
                $ips += $iplist
            }
            return $ips}
        }



#Full Target List of IPs now match to Ports

function load_ports($iplist) {
    $choice = read-host "Enter 1 for Full Scan
Enter 2 for Discovery Scan with ports configured from file.
Enter 3 for Top 1000 Web Ports ports configured from file."
switch ($choice)
{
    1 {$ports = 0..65535}
    2 {$ports = get-content .\discovery_ports.conf }
    3 {$ports = get-content .\web_service_top.conf }
}
    #$ports = get-content .\discovery_ports.conf
#$ports = ("22","445","135","5985","80","8080")
    $full_scope=@()
    $c = $iplist.count
    $i = 1
    $pc = $ports.count
    foreach($ip in $iplist){
        $iip=1
        $perc = $i/$c *100
        write-progress -Activity "Creating Port-IP mappings." -Status "Progress -> $ip - $i of $c" -PercentComplete $perc -CurrentOperation OuterLoop
        foreach ($p in $ports) {
            $pperc = $iip/$pc * 100
            write-progress -Id 1 -Activity "Progress $iip of $pc" -PercentComplete $pperc -CurrentOperation InnerLoop
           $properties = @{
                ip = $ip
                port = $p
                n = 0
            }
            $obj = [pscustomobject]$properties  #new-object -typename psobject -property $properties
            $full_scope += $obj
            $iip++
        }
        $i++
    }
    return $full_scope
}

###
function do_math($full_scope){
    $n = 1
    $t = 1
    while ($test -ne 1){
        
        $minutes = $full_scope.count * $t / 60 / $n
        [string]$a1 = read-host "With a delay time of $t secnods and using $n external IP this scan will take $minutes minutes to complete. Is this acceptable?"
        if($a1 -like "*y*"){
            $test = 1
            }else{
        $t = read-host Set new dealy in seconds.
        $n = read-host Set new N value of IPs to be used.
    }
    }
        return $n, $t
    }

function assign_nvalue($n, $full_scope){
    $c = $full_scope.count
    $i = 0
    $ii = 1
    #n should be set in the begining of the script by the user or by the other parts of the program that setup the ec2 instances.
    $n
    #set all n values between 1 and $n
    while ($i -lt $c){
        $full_scope[$i].n = $ii 
        $ii++
        if($ii -gt $n){$ii = 1}
        $i++
    }
    return $full_scope
}


$iplist = create_ip_list
$full_scope = load_ports $iplist
$n,$t = do_math $full_scope
$final_targets = assign_nvalue $n $full_scope
$final_targets | export-clixml ".\targets\$project_name\web-1000_target_list.xml"




