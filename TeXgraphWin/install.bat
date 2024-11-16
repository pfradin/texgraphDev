@echo OFF
Set version=2.0
Set installDir=%1

if %installDir%"a"=="a" (
Set first=1
goto cheminInstall)
(Set first=0
goto suite)

:cheminInstall
echo Installation de TeXgraph dans ^<chemin^>\TeXgraph
echo -------------------------------------------------
echo Entrez  un chemin existant, ne se terminant pas par \
echo Si vous entrez une chaine vide, le chemin sera simplement c: 
echo et l'installation se fera dans c:\TeXgraph
Set /P rep=chemin=
Set installDir="%rep%"
if "%rep%"=="" (
Set installDir="c:"
goto suite)
if exist %installDir% goto suite
echo Vous avez saisi %rep%
echo Ce chemin n'existe pas, veuillez recommencer...
Set rep=
goto cheminInstall

:suite
if %first%==0 (
echo IMPORTANT: fermer le programme TeXgraph pour proceder a la mise a jour! 
echo Valider quand c'est fait.
Pause
)
if exist %installDir%\TeXgraph (rmdir %installDir%\TeXgraph /S /Q)
mkdir %installDir%\TeXgraph
if exist %installDir%\TeXgraph goto installation
goto cheminInstall

:installation
echo -------------------------------------------------
echo Installation dans le dossier %installDir%\TeXgraph 
echo ...
xcopy /S /Q TeXgraph %installDir%\TeXgraph

if exist "c:\tmp" (
echo -------------------------------------------------
echo Le dossier c:\tmp contient peut-etre des fichiers TeX.
echo Voulez-vous conserver ces fichiers ^(o/n^)
echo Si vous entrez une chaine vide, la reponse sera o
Set rep=
Set /P rep=reponse=
if "%rep%"=="n" (del /Q "c:\tmp\*.tex")
)

if "%TeXgraphMac%"=="" (goto usermacdir)
:scripts
echo -------------------------------------------------
if not exist "%TeXgraphMac%" (
mkdir "%TeXgraphMac%"
echo Le dossier "%TeXgraphMac%" vient d'etre cree.
)
echo La variable TeXgraphMac pointe vers le dossier "%TeXgraphMac%"
echo Pour charger des modeles ou les mettre a jour: menu Aide/Mise a jour.

echo -------------------------------------------------
echo Creation des scripts dans %installDir%\TeXgraph
Set bureauDir="C:\users\%username%\desktop"
if exist %bureauDir% (goto desinstallation)
Set bureauDir="C:\utilisateurs\%username%\bureau"
if exist %bureauDir% (goto desinstallation)
Set bureauDir="C:\Documents and Settings\%username%\bureau"
if exist %bureauDir% (goto desinstallation)

echo -------------------------------------------------
echo NB: chemin d'acces au bureau introuvable! Il vous faudra copier
echo vous-meme le raccourci qui est dans le même dossier  que le
echo script install.bat, dans votre bureau.
Set bureauDir=
(echo setx TeXgraphDir ""
echo rmdir %installDir%\TeXgraph /S /Q) > %installDir%\TeXgraph\uninstallTeXgraph.bat
goto fin

:desinstallation
(echo del %bureauDir%\TeXgraph.lnk
echo setx TeXgraphDir ""
echo rmdir %installDir%\TeXgraph /S /Q) > %installDir%\TeXgraph\uninstallTeXgraph.bat
echo -------------------------------------------------
echo Copie du raccourci vers %bureauDir%
copy TeXgraph.lnk %bureauDir%

:fin
echo -------------------------------------------------
echo Reglage des variables d'environnement utilisateur
echo ...
cd TeXgraph
setx TeXgraphDir %installDir%\TeXgraph
if %first%==1 (
setx PATH %installDir%\TeXgraph;"%PATH%"
)
setx TeXgraphMac "%TeXgraphMac%"
cd ..
echo -------------------------------------------------
echo Voila!
echo -^> Pour lancer TeXgraph depuis une console, taper: TeXgraph
echo -^> Pour desinstaller TeXgraph, taper dans une console: uninstallTeXgraph
echo -^> ATTENTION: pour une utilisation dans un document LaTeX, n'oubliez pas de copier le 
echo fichier texgraph.sty (dossier %installDir%\TeXgraph) dans un dossier connu 
echo de votre distribution TeX.
Pause
if %first%==0 (
cd ..
rmdir TeXgraph%version% /S /Q
)
exit 0

:usermacdir
echo -------------------------------------------------
echo La variable d'environnement TeXgraphMac n'existe pas, elle doit pointer
echo vers le dossier: ^<chemin^>\TeXgraphMac qui contiendra les fichiers modeles
echo ou de macros. 
echo Entrez  un chemin existant, ne se terminant pas par \
echo Si vous entrez une chaine vide, le chemin sera simplement c: 
echo et la variable TeXgraphMac pointera vers c:\TeXgraphMac
Set /P TeXgraphMac=chemin=
if "%TeXgraphMac%"=="" (
Set TeXgraphMac=c:\TeXgraphMac
goto scripts)
if exist "%TeXgraphMac%" (
Set TeXgraphMac=%TeXgraphMac%\TeXgraphMac
goto scripts)
echo Ce chemin n'existe pas, veuillez recommencer...
Set TeXgraphMac=
goto usermacdir
