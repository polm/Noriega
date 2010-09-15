#!/bin/bash
#using document frequency to calculate stuff.

WORDS="$1"
FILES="$2"

while read WORD;
do 
	DO=$(./df.sh $WORD 1 $FILES | cut -f1)
	DT=$(./df.sh $WORD 2 $FILES | cut -f1)
	RATIO=$(echo "$DT / $DO" | bc -l)
	if [ -z "$RATIO" ]
	then RATIO="-1"
	fi
	echo $RATIO " " $WORD
done < $WORDS
