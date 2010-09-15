#!/bin/bash
#Calculate document frequency.
#args:
#1. Word
#2. k
#3. list of files

COUNT=0;

WORD="$1"
K="$2"
FILES="$3"

while read FILE;
do
	OCCURS=$(tr -d ',\(\)\"\.\?\!' < $FILE | tr ' ' '\n' | grep -w "$WORD" | wc -l | cut -f1)
	if (( OCCURS >= K ))
	then ((COUNT++))
	fi
done < $FILES

echo -e $COUNT "\t" $WORD
