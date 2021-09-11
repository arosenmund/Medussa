cd #application path

######Global Variables

$workingdir = Get-Location
$payloaddir = $workingdir.Path + "\Payloads"

$searchBase = read-host "Enter CN of the top level OU for the accounts that need to be migrated." #OU of the accounts you plan on migrating use top level OU over the computers and the users will vary based on your structure
write-host $searchBase

$logpath = $workingdir.Path + "\Logs\"
$logfile = $workingdir.Path + "\Logs\MainLog.txt"

#####Mapping Variables to Payloads
$payload_ReACL64 #payload for 64 bit reACL package to be dropped on each computer
$payload_ReACL32 #payload for 64 bit reACL package to be dropped on each computer
$payload_Restart #bat file to restart computer
$payload_SCCMUnIn #payload to uninstall SCCM
$payload_SCCMINstall #payload to resinstall SCCM after on new domain
$payload_GPupdate = #bat file to run gp update /force command
$payloadDynamicDNS = #Payload to change interface from static dns to "recieve dns automaticall" from DHCP
$payload_Message #bat file to give users a message.

###########HTML Formatting for computer lists
$HTMLTitle = "Computers"
$header =@"
<head>

    <style type"text/css">
    <!-
        body {
        font-family: Veranda, Geneva, Arial, Helvetica, sans-serif;
        background-color: darkblue;
        }

        #report {width: 835px; }
        table{
        border-collapse: collapse;
        border: none;
        front: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
        color: black;
        margin-bottom: 10px;
        }

        table td{
        font-size: 12px;
        padding-left: 0px;
        padding-right: 20px;
        text-align: left;
        }

        table th {
        font-size: 12px;
        padding-left: 0px;
        padding-right: 20px;
        text-align: left;
        }
        
        table.list{ float: left;}

        table.list td:nth-child(1){
        font-weight: bold;
        border-right: 1px grey solid:
        text-align: right;
        }

        table.list td:nth-child(2){padding-lef: 7px; }
        table tr:nth-child(even) td;nth-child(even){background: #BBBBBB;}
        table tr:nth-child(odd) td;nth-child(odd){background: #F2F2F2;}
        table tr:nth-child(even) td;nth-child(odd){background: #DDDDDD;}
        table tr:nth-child(odd) td;nth-child(even){background: #E5E5E5;}
        div.column {width: 320px: float: left;}
        div.second{ margin-left: 30px;}
        table{margin-left: 20px;}
        ->

    </style>

</head>
        
"@


######Create Table
$tableName = "AssetTable"
$table = new-object system.data.datatable "$tableName"
$col1 = New-Object system.data.datacolumn Computer,([string])
$col2 = New-Object system.data.datacolumn Phase,([string])
$col1 = New-Object system.data.datacolumn Status,([string])
$col1 = New-Object system.data.datacolumn Building,([string])





 