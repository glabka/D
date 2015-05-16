#!/bin/bash




#IFS Matouš to použil pro to čtení...
IFS= # To make sure this shell variable won't affect "read" command
while read -r line
do
	if [ ! -n "$line" ];
		then
		break
	fi
    # echo "$line"
	tmp=$( tr ',' '\n' <<< "$line" )
	echo "$tmp"
	echo "..........."

	# tady bych to mohl poslat do dalsi fce, ktera bude na zpracování
	# jednoho řádku toho souboru
# done < recept1.txt
# done <<< $( sed 's/^ *//g' recept1.txt | sed 's/, */,/g'| sed 's/ *,/,/g' | sed 's/ *$//g' )
# done <<< $( sed -r 's/^ *| *$//g' recept1.txt | sed -r 's/, *| *,/,/g' )  # first delete spaces leading and ending spaces, after that spaces around commas
# done <<< $( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/,[ \t]*|[ \t]*,/,/g' recept1.txt )
done <<< $( sed -r -e 's/^[ \t]*|[ \t]*$//g' -e 's/[ \t]*,[ \t]*/,/g' recept1.txt )# first delete spaces/tabs leading and ending spaces/tabs, after that spaces/tabs around commas


# deleting leading spaces
# sed 's/^ *//g' recept1.txt
# deleting spaces after comma
# sed 's/, */,/g' recept1.txt
# deleting spaces before comma
# sed 's/ *,/,/g' recept1.txt
# deleting ending spaces
# sed 's/ *$//g' recept1.txt

# dohromady:
# sed 's/^ *//g' recept1.txt | sed 's/, */,/g'| sed 's/ *,/,/g' | sed 's/ *$//g'

# /g asi znamená global...
