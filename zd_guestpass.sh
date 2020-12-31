#!/bin/bash

today=$(date +"%m/%d/%Y")
LPATH="/home/zonedirector"
PATH=$PATH:$LPATH
wwwpath="/var/www/html"
htmlfile="index.html"
textfile="guestpsk.txt"

charcnt="0"
mincharcnt="9"

# You have to base64 encode username and password.
# I recognize it's not that clever, but it will be ok...for now
# Got a better way?  I would love to know a great way to do this
tempusername="dXNlcm5hbWU"
temppassword="cGFzc3dvcmQ"
user=$(echo -n "$tempusername" | base64 -d )
password=$(echo -n "$temppassword" | base64 -d )
host="10.11.12.13"

function passgen() {
	# grab a random word from the dictionary
	# dictionary list has words with apostrophes, so we remove those
	# because we don't need them
	# I also make the password lowercase.
	guestpsk=$(shuf -n1 /usr/share/dict/words | sed s/\'//g | tr [:upper:] [:lower:])
	charcnt=$(wc -m <<< $guestpsk)
}

###########################
##### Let's Do This! ######

while [ $charcnt -lt $mincharcnt ] 
	do 
		passgen
done

echo "$guestpsk" > $LPATH/$textfile
cat $LPATH/$htmlfile | sed s/nonsense/$guestpsk/g > $wwwpath/$htmlfile

echo "$today" > "$LPATH/config.log"

$LPATH/zd_config.sh $user $password $host >> "$LPATH/config.log"
