@echo OFF
if not exist "c:\tmp\" (mkdir "c:\tmp\")

if "%1" == "server" (goto server) else (goto execfile)

:waitserver
wait 100
if not exist "c:\tmp\TeXgraphServer.On" (goto :waitserver)
goto fin

:server
if "%2" == "on" (
	if exist "c:\tmp\TeXgraphServer.cmd" (del /q "c:\tmp\TeXgraphServer.cmd")
	if not exist "c:\tmp\TeXgraphServer.On" ( 
		(start "" /B TeXgraphCmd -s) > "c:\tmp\TeXgraphServer.log "
		 goto waitserver
		)
	goto fin)
if "%2" == "off" ((echo end) > "c:\tmp\TeXgraphServer.cmd" 
	 goto patienter)
goto fin

:execfile
if exist "c:\tmp\TeXgraphServer.On" (goto texgraphcmd) else (TeXgraphCmd %1 %2 %3 > %3.log)
goto fin

:texgraphcmd
(echo %1
echo %2
echo %3) > "c:\tmp\TeXgraphServer.cmd"
goto patienter

:patienter
wait 100
if exist "c:\tmp\TeXgraphServer.cmd" (goto patienter)

:fin

