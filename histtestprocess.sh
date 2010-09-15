#!/bin/bash
#process output...

while read LINE;
do
	WORD=$(echo "$LINE " | cut -f1 )
	A=$(echo "$LINE"|  cut -f2 )
	B=$(echo "$LINE" | cut -f3 )
	C=$(echo "$LINE" | cut -f4 )
	D=$(echo "$LINE" | cut -f5 )
	#Divide by zero will just be swallowed by bc here.
	POSAP=$(echo "$A / ( $A + $B )" | bc -l )
	NEGAP=$(echo "$C / ( $C + $D )" | bc -l )
	PRIOR=$(echo "( $A + $C ) / ( $A + $B + $C + $D )" | bc -l )
	echo -e $POSAP "\t" $NEGAP "\t" $PRIOR "\t" $WORD
done

