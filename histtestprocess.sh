#!/bin/bash
#process output...

while read LINE;
do
	WORD=$(echo "$LINE " | cut -f1 )
	A=$(echo "$LINE"|  cut -f2 )
	B=$(echo "$LINE" | cut -f3 )
	POSAP=$(echo "$A / ( $A + $B)" | bc -l )
	if [[ $A > 0 || $B > 0 ]]
	then echo $POSAP " " $WORD
	fi
done

