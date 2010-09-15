#!/bin/sh
#Get occurrences of a given word in a list of files.

WORD="$1"
FILELIST="$2"

TMP=$(mktemp)
while read FILE;
do cat "$FILE" >> $TMP
done < $FILELIST

#This just outputs the answer.
tr -d ',\(\)\"\!\?\:\;\.' < $TMP | tr ' ' '\n' | grep -w $WORD | wc -l | cut -f1
