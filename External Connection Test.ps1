# External Connection Test

$domain = read-host "Enter FQDN"
$path = read-host "What path and name do you want he csv file to save under?"

nltest /dclist:$domain |  $DCList

Foreach($dc in $DCList)
{
ping $dc | export-csv $path
}






