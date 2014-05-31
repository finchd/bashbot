#!/usr/bin/env bash

line=""
started=""
rm botfile
mkfifo botfile
tail -f botfile | nc irc.cat.pdx.edu 6667 | while true ; do
    if [ -z $started ] ; then
        echo "USER botbot 0 botbot :I iz a bot" > botfile
        echo "NICK botbot" >> botfile
        echo "JOIN #notents" >> botfile
        started="yes"
    fi
    if [ "`echo $irc | cut -d ' ' -f 1`" = "PING" ] ; then
      echo "PONG" >> botfile
    fi
    read irc
    # parse msg fields
    nick=`echo $irc | cut -d '!' -f 1 | tr -d :`
    cmd=`echo $irc | cut -d ' ' -f 2`
    chan=`echo $irc | cut -d ' ' -f 3`
    message=`echo $irc | cut -d ':' -f 3`
    if [ "${cmd}" = "PRIVMSG" ] ; then
      echo "Got message \"${message}\" from ${nick} in ${chan}"
    fi
done
