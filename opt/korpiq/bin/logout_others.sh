#!/bin/bash

[ "$UID" = "0" ] || exec sudo "$0" <<<"$USER"

while read keep_user
do
    ps ax -o user,pid,command |
        grep /loginwindow.app/ |
        grep -v "^$keep_user " |
        while read user pid command
        do
            launchctl bsexec $pid osascript -e \
                'tell application "loginwindow" to «event aevtrlgo»'
        done
done

