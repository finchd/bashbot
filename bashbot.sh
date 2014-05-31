#!/usr/bin/env bash

line=""
started=""
rm botfile
mkfifo botfile
tail -f botfile | nc irc.cat.pdx.edu 6667 | while true ; do
    if [ -z $started ] ; then
        echo "USER botbot 0 botbot :I iz a bot" > botfile
        echo "NICK botbot" >> botfile
        echo "JOIN #notzombies" >> botfile
        started="yes"
    fi
    if [ `echo $irc | cut -d ' ' -f 1` = "PING" ] ; then
      echo "PONG" >> botfile
    fi
    read irc
    echo $irc
done
