@echo off
cd /d %~dp0
del -f *.txt
update -ci
git add ../. -A
git commit -m "update data"
git push origin master