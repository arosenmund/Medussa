<#
#<#
#.Synopsis
#	Short description of the purpose of this script
#.Description
#	Extensive description of the script
#.Parameter X
#    Description or parameter X
#.Parameter Y
#    Description or parameter Y
#.Example
#	First example of usage of the script
#.Example
#	Second example of usage of the script
##>

#>
param
(
 $searchpath,
 $scrutiny

)

:
function Remove-DuplicateFiles {

cd $searchpath
$files = Get-ChildItem $searchpath -Recurse  
foreach($file in $files){

    
get-filehash -Path 



}  
}

get-fileHash -path $searchpath -Algorithm MD5 


}
Write-host "Welcome to Data Duplication powershell script.
            This script will search through the selected directory for 
            files that have the same hash, indicating that they are an exact copy of 
            eachother.  It will the allow you to delete the files that are duplicate."

$path = read-host "Input the full path of the directory you wish to run DeDupe."

        

Get-FileHash -path $path -algorithm MD5 


