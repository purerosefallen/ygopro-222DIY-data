@echo off
cd /d "%~dp0\.."
git pull origin data
cd /d "%~dp0"
update.exe -m
cd ..
git add . -A
git commit -m "Update data"
git push origin data