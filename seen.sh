#!/bin/bash
read sea
sen=$( grep "$sea" seme.txt | tail -1)
rel=$( echo "$sen" | sed "s/^.*#lobby ://")
exc=$( echo "$sen" | sed "s/].*//")
axc=$( echo "$exc" | tr -d '[')
#hel=$( dateutils.ddiff -f "%d day and %h hour" |  echo "$axc" | date "+%y-%m-%d %T"  )
hek=$(date "+%y-%m-%d %T")
#pel=$(dateutils.ddiff | "$hel" | -f '%dD %HH %mM')
hel=$(date -u -d @$(($(date -d "$hek" '+%s') - $(date -d "$axc" '+%s'))) '+%HH %MM')



echo $rel
echo $sen
echo $axc
echo $hel
echo $pel
