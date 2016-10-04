@echo off

set int1 = "Local Ethernet Connection"
set int2 = "Local Ethernet Connection 2"

::netsh address ipv4 address 

echo here we goooooo.
@echo off
TIMEOUT /t 600

ECHO Checking connection, please wait...
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :SUCCESS2
IF     ERRORLEVEL 1 goto :TRYAGAIN

:TRYAGAIN
ECHO FAILURE!
ECHO Let me try a bit more, please wait...
@echo off
PING -n 3 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :SUCCESS2
IF     ERRORLEVEL 1 goto :TRYIP

:TRYIP
ECHO FAILURE!
ECHO Checking DNS...
ECHO Lets try by IP address...
@echo off
ping -n 1 216.239.37.99|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :SUCCESSDNS
IF     ERRORLEVEL 1 goto :TRYROUTER

:TRYROUTER
ECHO FAILURE!
ECHO Lets try pinging the router....
ping -n 2 192.168.1.1|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :ROUTERSUCCESS
IF     ERRORLEVEL 1 goto :NETDOWN



:SUCCESS2
ECHO You have an active internet connection but some packet loss was detected.
pause
goto :END

:FAILURE
ECHO You do not have an active Internet connection reverting settings.

netsh exec myconf.cfg

netsh interface ip add dns name=%int1%e  ###.###.###.### index=2


pause
goto :END
