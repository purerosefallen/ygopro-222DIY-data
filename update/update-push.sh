#!/bin/bash
./update-server.sh
git add ../. -A
git commit -m "update data"
git push origin master
