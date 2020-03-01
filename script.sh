#!/bin/bash

if test -f /tmp/out/lock 
then
    echo "error 22 script in use"
    exit 22
fi
touch /tmp/out/lock
for file in /tmp/in/*
do 
    gzip  "$file" 
    mv $file.gz /tmp/out
done
rm /tmp/out/lock
