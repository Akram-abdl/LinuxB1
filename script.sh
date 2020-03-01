#!/bin/bash


# checks if lock file exists and cancels the process if true 
if test -f /tmp/out/lock 
then
    error_inuse= "error 22 script in use"
    echo $error_inuse >> /tmp/out/logs.txt
    echo $error_inuse
    exit 22
fi

# create logs if logs.txt doesn't exist
if [[ ! -e /tmp/out/logs.txt ]]; then
    touch /tmp/out/logs.txt
fi


# create lock file
touch /tmp/out/lock || { 
    error_createl = "script failed, cannot create lock file. Error 22 for $file"
    echo $error_createl >> /tmp/out/logs.txt
    echo $error_createl
    exit 22 
}

# loops through the files in /tmp/in/, compresses them and moves them to /tmp/out/
for file in /tmp/in/*
do 
    gzip  "$file" && echo "success compressing file $file" >> /tmp/out/logs.txt || {
        error_comp="script failed cannot compress files. Error 22 for $file"
        echo $error_comp >> /tmp/out/logs.txt 
        echo $error_comp
        exit 22
    }
    mv "$file".gz /tmp/out && echo "success moving file $file to folder" >> /tmp/out/logs.txt || { 
        error_move = "script failed, cannot move files to /tmp/out. Error 22 for $file"
        echo $error_move >> /tmp/out/logs.txt
        echo $error_move
        exit 22
    }
done

# deletes lock which means that we can run the program again if needed
rm /tmp/out/lock || { 
    error_deletel = "script failed, cannot delete lock file. Error 22 for $file"
    echo $error_deletel >> /tmp/out/logs.txt 
    echo $error_deletel
    exit 22
}
