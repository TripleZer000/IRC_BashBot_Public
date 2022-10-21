#!/bin/bash
#!/user/bin/perl

. bot.properties
source seen
input=".bot.cfg"
echo "Starting session: $(date "+[%y:%m:%d %T]")">$log 
echo "NICK $nick" > $input 
echo "USER $user" >> $input
#echo "JOIN #$channel" >> $input

#new=$(echo $res^^)
tail -f $input | openssl s_client -connect $server:6697 | while read res
do
  # log the session ## NEW AKUMA ADDON
  who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
  if [ "$who" = "Akuma" ]
  then
    sfix=$(echo "$res" | grep -o -P '(?<=:\[).*(?=]\:)')
    echo "$(date "+[%y-%m-%d %T]"):+:$sfix!+$res" >> $log
  else 
  echo "$(date "+[%y-%m-%d %T]")$res" >> $log
  fi
  # do things when you see output
  case "$res" in
    # respond to ping requests from the server
    PING*)
      echo "$res" | sed "s/I/O/" >> $input 
    ;;
    *"This nickname is regist"*) 
     echo "PRIVMSG NICKSERV :IDENTIFY $password" >> $input 
    ;;
    *"You are now logged in as $nick"*)
     echo "JOIN $channel" >> $input
     echo "JOIN #bots" >> $input
     echo "JOIN #lair" >> $input
    ;;

####################create command
#   *"-create"*)
#msg=$(echo "$res" | sed "s/^.*://")
#bts=$(echo "$msg" | sed "s/[^ ]* //")
#cmd=$(echo "$bts" | cut -f 1 -d " ")
#ech=$(echo "$bts" | sed "s/[^ ]* //")
#   echo $cmd - $ech  >> bot.usrcmds
#   echo "PRIVMSG $channel :Done....test" >> $input
#    ;;
#   *"?"*) 
#msg=$(echo "$res" | sed "s/^.*://")
#umd=$(echo "$msg" | sed "s/?//")
#bts=$(echo "$msg" | sed "s/[^ ]* //")
#sum=$(grep -A 1 $umd bot.usrcmds)
#   echo "PRIVMSG $channel :$sum" >> $input
#    ;;
#################create commands
#   *"-create"*)
#msg=$(echo "$res" | sed "s/^.*://")
#bts=$(echo "$msg" | sed "s/[^ ]* //")
#>> "first$".split("$")[0]
#  echo "PRIVMSG $channel :$fir" >> $input
#   ;;
#################create random
   *"-add"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
echo $bts >> bot.extra
   echo "PRIVMSG $from :ADDED!!!" >> $input
    ;;
   *"-show"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
shw=$(shuf -n 1 bot.extra)
   echo "PRIVMSG $from :$shw" >> $input
    ;;
####################help
   *"-help"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :-8ball, -seen,-give, -send idea, -fortune, -insult, -add, -show, -create, -song add, -random song,  and -megatron cookies. Type +command for more info. Example: +8ball." >> $input
    ;;
   *"+seen"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -seen nick. Case sensitive. It will send #lobby the last msg sent by them and how long ago." >> $input
    ;;
   *"+8ball"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -8ball "question here."" >> $input
    ;;
   *"+urban"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -urban "any word here". UNDER CONSTRUCTION" >> $input
    ;;
   *"+insult") from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -insult "nick here"." >> $input
    ;;
   *"+give") from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -give "nick here" "item here"." >> $input
    ;;
   *"+add") from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -add "whatever you want to add here". This command adds a random line to a randomized command(- show)." >> $input
    ;;
   *"+show") from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -show This command shows random line from - add." >> $input
    ;;
   *"+create"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :This command creates a command. To create one type -create "word_here output_here" . Example: -create vaper vaping is sis! Then to use this simply type "word_here?" Example: vaper? P.S. 000 can delete any command that is bad." >> $input
    ;;
   *"+song add"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -song add "url_here" and it will add a song to a list. You can get a random link by using -random song." >> $input
    ;;
   *"+give"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :Type -give "nick_here" "item here"." >> $input
    ;;
#   *"+ywot"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#   echo "PRIVMSG $from :Type -ywot "nick_here" to display a nick's world of text link." >> $input
#    ;;
################### xmas story
#   *"christmas"*)
#   echo "PRIVMSG $channel :Twas the night b4 xmas - https://triplezer0.hugoslop.repl.co/#xmas.html" >> $input
#    ;;
#   *"xmas"*)
#   echo "PRIVMSG $channel :Twas the night b4 xmas - https://triplezer0.hugoslop.repl.co/#xmas.html" >> $input
#    ;;
#   *"Merry"*)
#   echo "PRIVMSG $channel :Twas the night b4 xmas - https://triplezer0.hugoslop.repl.co/#xmas.html" >> $input
#    ;;
#   *"merry"*)
#   echo "PRIVMSG $channel :Twas the night b4 xmas - https://triplezer0.hugoslop.repl.co/#xmas.html" >> $input
#    ;;
## Triple away
#   *"Zer0"*)
#   echo "PRIVMSG $channel :000 is currently away. :(" >> $input
#    ;;
#   *"zer0"*)
#   echo "PRIVMSG $channel :000 is currently away. :(" >> $input
#    ;;
#   *"000"*)
#   echo "PRIVMSG $channel :000 is currently away. :(" >> $input
#    ;;
#   *"Zero")
#   echo "PRIVMSG $channel :000 is currently away. :(" >> $input
#    ;;
#   *"zero"*)
#   echo "PRIVMSG $channel :000 is currently away. :(" >> $input
#    ;;
################### only for me 8ball and restart
*":PatientZer0!000@Golden.Legend PRIVMSG Megatron :quit"*)
#   echo "PRIVMSG $channel :Rebooting..." >> $input
   echo "QUIT REBOOTING..." >> $input
echo "YOUDIDITNOWDOITAGAIN!!!"
    ./bot.sh && break
    ;;
*":TripleZer0!000@Golden.Legend PRIVMSG Megatron :quit"*)
#   echo "PRIVMSG $channel :Rebooting...." >> $input
   echo "QUIT REBOOTING..." >> $input
echo "YOUDIDITNOWDOITAGAIN!!!"
    ./bot.sh && break
    ;;
################### worlds
#   *"-ywot"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#msg=$(echo "$res" | sed "s/^.*://")
#bts=$(echo "$msg" | sed "s/[^ ]* //")
#echo "PRIVMSG $from :https://www.yourworldoftext.com/~Jaxx" >> $input
#echo "PRIVMSG $from :https://www.yourworldoftext.com/~patientzer0/" >> $input
#echo $msg
#    ;;
###################add song
   *"-song add"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
#msg=$(echo "$res" | perl -pe "s/^.*? PRIVMSG #.*? ://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
aids=$(echo add)
iph=$(echo "$bts" | grep -oP "^$aids\K")
who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
echo "$who - https:$bts" >> song.list
## https: ##^^^
   echo "PRIVMSG $from :Added your song!!!" >> $input
    ;;
   *"-random song"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
shw=$(shuf -n 1 song.list)
   echo "PRIVMSG $from :$shw" >> $input
    ;;
###################insult
   *"-insult"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
ins=$(shuf -n 1 insult.txt)
    echo "PRIVMSG $from :$bts $ins" >> $input
    echo "PRIVMSG $from :Insults are just for laughs. Not meant for hate." >> $input
    ;;
###################GIVE ITEM TO USER
   *"-give"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "PRIVMSG $from :ACTION gives $bts." >> $input
    ;;
##################
#   *"kek"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#   echo "PRIVMSG $from :F off EDbot. The user may say it all they want. heh just dont spam." >> $input
#    ;;
#   *"KEK"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#   echo "PRIVMSG $from :F off EDbot. The user may say it all they want. heh just dont spam." >> $input
#    ;;
#   *"EDbot"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#   echo "PRIVMSG $from :EvilBot need viagra... to stay online." >> $input
#    ;;
################## 8ball simple yes or no ;)
   *"-8ball"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
ball=$(shuf -n 1 8ball.txt)
   echo "PRIVMSG $from :$ball" >> $input
echo $res
    ;;
   *"-send idea"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo $res >> ideas.txt
   echo "PRIVMSG $from :Your idea has been sent" >> $input
    ;;
   *"-megatron cookies"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
   echo "PRIVMSG $from :ACTION Give's you a plate of cookies." >> $input
    ;;
   *"-copycat"*) msg=$(echo "$res" | sed "s/^.*://")
   echo "PRIVMSG $channel :$msg" >> $input
    ;;
   *"-bot2speak"*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") msg=$(echo "$res" | sed "s/^.*://") bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "PRIVMSG $channel :$bts" >> $input
    ;;
   *"-botaction"*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") msg=$(echo "$res" | sed "s/^.*://") bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "PRIVMSG $channel :ACTION $bts" >> $input
    ;;
############### URBAN DICT
   *"-urban"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
urb=$(./urban $bts)
mean=$(echo "$urb" | sed -n "/Meaning/,/Examples/p")
shit=$(tr '\n' ' ' <<<"$mean")
poop=$(echo "$shit" | sed -r "s/(([^.]*.){3}).*/\1/")
bomb=$(echo "$poop" | sed "s/1//2")
loop=$(echo "$bomb" | perl -i -pe "y/[]//d")
crap=$(echo "$loop" | tr -s ' ')
popo=$(echo "$crap" | sed -e "s/^[ \t]*//")
dodo=$(echo "$popo" | sed "s/1//")
dogo=$(echo "$dodo" | sed "s/2//")
lolo=$(echo "$dogo" | sed "s/3//")
soho=$(echo "$lolo" | sed "s/Examples//")
bobo=$(echo "$soho" | sed "s/g /g: /1")
loko=$(echo "$bobo" | sed "s/ *$//")
    if [ "$loko" = "Meaning:" ];
   then echo "PRIVMSG $from :Can not find $bts." >> $input
   else echo "PRIVMSG $from :$loko" >> $input
echo .$loko.
    fi
    ;;
################## Fortune-Mod
    *"-fortune"*) from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
fort=$(fortune)
tort=$(echo "$fort" | tr -s ' ')
kork=$(echo "$tort" | tr -d '\n') 
### if complaints cause its broken a.k.a. multi-line.... kork= tr '\n' ' '
    echo "PRIVMSG $from :$kork" >> $input
echo $kork
    ;;
################### SEEN (UNDER CONSTRUNCTION) NAH
################### LOBSTER BIG PPPPPPPPPPPPPPPPPPPPPPPP
   *":-seen "*)
     msg=$(echo "$res" | perl -pe "s/^.*? PRIVMSG #.*? ://")
     bts=$(echo "$msg" | sed "s/[^ ]* //")
     from=$(echo "$res" | perl -pe "s/^:.*? PRIVMSG (#.*)? :.*/\1/")
     str=$(echo "$bts" | perl -pe "s/(.*?)\\r/\1/")
     if [[ "$str" = *[!\ ]* ]]
     then
         if [[ "$str" = "-seen" || "$str" = "" ]]
         then
             echo "PRIVMSG $from :Invalid syntax(syntax format: \"-seen [\$NICK]\")" >> $input
        else
             seen=$(seen $str)
             echo "PRIVMSG $from :$seen" >> $input
         fi
     else
        echo "PRIVMSG $from :Invalid syntax(syntax format: \"-seen [\$NICK]\")" >> $input
     fi
    ;;
###################### BOT SPEAKs
   *"-botspeak"*) 
     str=$(echo "$res" | perl -pe "s/(.*?)\\r/\1/")
     msg=$(echo "$str" | perl -pe "s/^.*? PRIVMSG .*? ://")
     bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "$bts" >> $input
    ;;
   *"-botaction"*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") msg=$(echo "$res" | sed "s/^.*://") bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "PRIVMSG $channel :ACTION $bts" >> $input
    ;;
################### -save to save a log
#    *"-save"*)
#     who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#     msg=$(echo "$res" | sed "s/^.*://")
#     bts=$(echo "$msg" | sed "s/[^ ]* //")
#     from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#     now=$(date +"%m-%d-%y")
#     mane="log_"$now".txt"
#mv log.txt $mane
#     echo "PRIVMSG TripleZer0 :DONE???" >> $input
#    ;;
################### -users overlu ping to every users so Akuma -users
#   *"-users"*)
#     who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#     msg=$(echo "$res" | sed "s/^.*://")
#     bts=$(echo "$msg" | sed "s/[^ ]* //")
#echo "NAMES $channel" >> $input
#   ;;
################### Print users (old akuma thing)
#   *"353 Megatron = #lobby"*)
#nes=$(tac log.txt | grep -m1 '353 Megatron = #lobby')
#rel=$( echo "$res" | sed "s/^.*#lobby ://")
#echo "PRIVMSG $who :Users that are on IRC, in $from: $rel" >> $input
#   ;; 
################### rot13 ;)
    *"PRIVMSG Megatron :-cife"*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
core=$(echo "$bts" | rot13)
   echo "PRIVMSG $who :$core" >> $input
     ;;
    *"PRIVMSG Megatron :+ciph"*) who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
msg=$(echo "$res" | sed "s/^.*://")
bts=$(echo "$msg" | sed "s/[^ ]* //")
   echo "PRIVMSG $who :" >> $input
     ;;
###################
    # run when someone joins
    *'JOIN :'*)
     msg=$(echo "$res" | sed "s/^.*://")
#from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/") 
#from=$(echo "$res" | perl -pe "s/^:.*? PRIVMSG (#.*)? :.*/\1/")
#las=$(echo $from | perl -pe "s/.*?(\[.*?\]:.*? PRIVMSG #.*? :.*?)\\r.*/\1/")
#echo I AM THE MSG = $msg
who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
      if [ "$who" = "TripleZer0" ]
      then echo "PRIVMSG $msg :Get this man some whiskey and some darts!!! " >> $input
      elif [ "$who" = "Shadow_Lobster" ]
      then echo "PRIVMSG $msg :Shadow_Lobster is stupid but not smart" >> $input
      elif [ "$who" = "shadowlobster" ]
      then echo "PRIVMSG $msg :Lobster with an 8 inch PeePee" >> $input
      elif [ "$who" = "unkbe" ]
      then echo "PRIVMSG $msg :Someone will crack that nick!!!" >> $input
      elif [ "$who" = "Megatron" ]
      then echo "PRIVMSG $msg :Is it fear or courage that compels you, fleshling?" >> $input
      elif [ "$who" = "Dusted" ]
      then echo "PRIVMSG $msg :Do What Thou Wilt" >> $input
      elif [ "$who" = "rachad" ]
      then echo "PRIVMSG $msg :Welcome Back Truth Keeper!" >> $input
      elif [ "$who" = "Omen" ]
      then echo "PRIVMSG $msg :Dark clouds fill the sky!!!" >> $input
      elif [ "$who" = "Megatron" ]
      then echo "PRIVMSG $msg :BACK BISHES!!!" >> $input
      else echo "PRIVMSG $msg :sTaY eViL $who" >> $input
      fi
     ;;
    # run when a message is seen
    *PRIVMSG*)
      echo "$res"
      who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
      from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
      # "#" would mean it's a channel
      if [ "$(echo "$from" | grep '#')" ]
      then
        test "$(echo "$res" | grep ":$nick:")" || continue
        will=$(echo "$res" | perl -pe "s/.*:$nick:(.*)/\1/")
      else
        will=$(echo "$res" | perl -pe "s/.*$nick :(.*)/\1/")
        from=$who
      fi
      will=$(echo "$will" | perl -pe "s/^ //")
      com=$(echo "$will" | cut -d " " -f1)
      if [ -z "$(ls modules/ | grep -i -- "$com")" ] || [ -z "$com" ]
      then
       echo "TEST SHIT" 
##./modules/help.sh $who $from >> $input
        continue
      fi
      echo "TEST SHIT"
## ./modules/$com.sh $who $from $(echo "$will" | cut -d " " -f2-99) >> $input
    ;;
    *)
      echo "$res"
    ;;
  esac
done
