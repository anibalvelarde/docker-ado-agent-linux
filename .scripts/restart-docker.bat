:: Kill DockerDesktop if it is still running
wmic Path win32_process Where "Caption Like 'Docker Desktop.exe'" Call Terminate

:: Ensure that the LxssManager Service is running
sc config LxssManager start=auto

:: Stop Docker Service
sc stop com.docker.Service
@echo off
echo %time%
timeout 5 > NUL
echo %time%

:: Restart (stop/start) Hyper-V Virtual Manchine Management
sc stop vmms
@echo off
echo %time%
timeout 5 > NUL
echo %time%
sc start vmms

:: Start Docker Service
sc start com.docker.Service

:: Run Docker Desktop
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"