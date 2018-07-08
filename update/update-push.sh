#!/bin/bash
sed -i "s/\r//g" ../expansions/script/*.lua
sed -i "s/\r//g" ../expansions/*.conf
sed -i "s/\r//g" ../deck/*.ydk
mono update.exe -ci
git add ../. -A
git commit -m "update data"
git push origin master
