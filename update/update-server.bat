@echo off
cd /d %~dp0
del -f *.txt
update -ci
