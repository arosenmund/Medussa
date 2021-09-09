###FMA Application
import sqlite3
####Global Variables
UNIT_NAME = "601 AOG"

###Data Structure Creation
conn = sqlite3.connect("fmac.db")
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS mission
                COLUMN 
                    ''' )

###Welcome Human
x = "Welcome to FMA-C for " + UNIT_NAME
print(x)
c.execute()
Mission_List = c.fetchall()
print(Mission_List[0])
x = raw_input("Select Mission Thread")


#####Mission component relationship table

###Logic Operations for Relationships
#reusable control loop


#1####Create Mission Statement

#a system to
sys = raw_input("Input desired System operation from operational design:")
System_To = "A system to" + sys
#by means of
means = raw_input("Input how the system does what it does:")
By_Means = "By means of" + means
#in support of
sup = raw_input("Input the operation or commander it is in support of:")
In_Support = "In support of " + sup
[str]Mission_Statement = System_To + By_Means + In_Support
print(Mission_Statement)

####take not of other priorities

#2####Unacceptable Losses
Print("Unacceptable Losses")


#3####Hazards
##You controll it, it is in the systems control, it is part of the mission statement, in addition to a enbironmental condition equals a loss

##Generate contraints as oppisite of the hazard conditions

#4####generate hazards versus loss table

#5####create controll loop
###control actions
###create process model description, contrall action plus some context to tell the controller to issue or not issue.




####
###



