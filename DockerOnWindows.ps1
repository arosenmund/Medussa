#Docker Automation with Powershell

#install and configure docker on windows 10

#install windows feature
Enable-WindowsOptionalFeature -Online -FeatureName containers -All

#pull down docker files and install
Invoke-WebRequest "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip" -OutFile "$env:TEMP\docker.zip" -UseBasicParsing

#unpack zip
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles

#add docker to system path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)

#start docker service
dockerd --register-service

#start service
Start-Service Docker

#pull windows nanoserver image
docker pull microsoft/nanoserver

docker images

#run image and present command shell
docker run -it microsoft/nanoserver cmd
