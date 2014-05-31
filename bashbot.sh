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
    barf=`echo $irc | cut -d ' ' -f 1-3`
    #message=`echo $irc | cut -d ':' -f 3` #broken by IPv6
    message=${irc##$barf :}
    botcommand=`echo $message | cut -d ' ' -f 1`
    botargs=`$message##$botcommand }
    # reaction to !cmds
    if [ "`echo $botcommand | cut -c1`" = '!' ] ; then
      string="PRIVMSG #notents :Got command \"${botcommand}\" from ${nick} on ${chan} with args \"${botargs}\""
      case #botcommand in
        "!add")   list="$botargs $list "
        "!list")  echo "List is ${list}"
        "!clear") list=""
      esac
    fi

    if [ "${cmd}" = "PRIVMSG" ] ; then
      echo "Got message \"${message}\" from ${nick} in ${chan}"
    fi
done
