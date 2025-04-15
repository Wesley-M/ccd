@echo off
setlocal

:: Config
set "TARGET_DIR=C:\Tools\ccd"
set "EXE_NAME=ccd.exe"
set "EXE_PATH=%TARGET_DIR%\%EXE_NAME%"
set "DOWNLOAD_URL=https://github.com/Wesley-M/ccd/releases/latest/download/ccd.exe"

:: Create directory if it doesn't exist
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
)

:: Download executable
echo Downloading %EXE_NAME%...
powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%EXE_PATH%'"

:: Add to USER PATH (robust check)
echo Updating user PATH...
powershell -Command "$targetDir = '%TARGET_DIR%'.TrimEnd('\', '/'); $userPath = [Environment]::GetEnvironmentVariable('Path', 'User'); $dirs = $userPath -split ';' | ForEach-Object { $_.TrimEnd('\', '/') }; if ($dirs -inotcontains $targetDir) { $newPath = $userPath + ';' + $targetDir; [Environment]::SetEnvironmentVariable('Path', $newPath, 'User') }"

:: Force-refresh PATH for current session
powershell -Command "$env:Path += ';%TARGET_DIR%'"

:: Add Defender exclusion
echo Adding Defender exclusion...
powershell -Command "Add-MpPreference -ExclusionPath '%TARGET_DIR%' -ErrorAction SilentlyContinue"

echo.
echo Installation complete. Test with 'ccd' below:
pause
