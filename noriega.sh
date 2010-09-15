#!/bin/bash
# Probability of two Noriegas and sundry.

df () {
#args:
#1. k
#2. word to look for
#??? filenames.
}

#1. get words

#2. Calc Test/Hist results.

for w in WORDS;
do
	TESTCOUNT=0
	HISTCOUNT=0
	BOTHCOUNT=0
	NEITHERCOUNT=0

	for f in FILES;
	do
		THISHIST=0
		THISTEST=0
		#HIST is defined as the first line (paragraph) right now.
		if [ -n "$(head -n 1 "$f" | grep $w)" ]
		then THISHIST=1
		fi
		if [ -n "$(tail -n +2 "$f" | grep $w)" ]
		then THISTEST=1
		fi
		if [ $THISHIST && $THISTEST ]; then ((BOTHCOUNT++)); fi;
		if [ $THISHIST && !$THISTEST ]; then ((HISTCOUNT++)); fi;
		if [ !$THISHIST && $THISTEST ]; then ((TESTCOUNT++)); fi;
		if [ !$THISHIST && !$THISTEST ]; then ((NEITHERCOUNT++)); fi;
	done

	#output stats
	echo -e $w"\t"$BOTHCOUNT "\t" $TESTCOUNT "\t" $HISTCOUNT "\t" $NEITHERCOUNT
done


		


	

