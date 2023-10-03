@echo off
set filename=Yarudora_3-English
set file_type=ISO
set patch_file=patch.xdelta

pushd %~dp0
if "%~1"=="" goto :NOISO

echo Patching %file_type%...
patch_data\xdelta.exe -d -f -s "%~1" patch_data\%patch_file% %filename%.bin

if errorlevel 1 goto :XDELTAERR
goto :FIN

:NOISO
echo To patch %file_type% don't run this bat file.
echo Simply drag and drop %file_type% on it and the patch process will start.
:EXIT

:XDELTAERR
echo.
echo Something went wrong while patching files.
echo You might be trying to patch the wrong %file_type%, try using a different one.
goto :EXIT

:FIN

echo Success!
echo Patched %file_type% was saved to %filename%.iso next to this bat file
goto :EXIT

:EXIT
popd
echo Press any key to close this window
pause >nul
exit