#Compares to lists and removes the items in the "exclusion list" from the Action list.






function ExclusionList
    	{
    		$ExclusionList = get-content 'C:\SCRIPT WORKBENCH\Test Scripts\Test_Lists\ExclusionList.txt'
    		$ActionList = get-content 'C:\SCRIPT WORKBENCH\Test Scripts\Test_Lists\ActionList.txt'

		$newlist =    Compare-Object -ReferenceObject $ActionList -DifferenceObject $ExclusionList -IncludeEqual | where {$_.sideindicator -eq "=="}  | select {$_.inputobject

	}


