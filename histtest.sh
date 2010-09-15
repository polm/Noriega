#!/bin/bash
# Probability of two Noriegas and sundry.

#1. get words

#2. Calc Test/Hist results.

WORDS="$1"
FILES="$2"

while read w;
do
	TESTCOUNT=0
	HISTCOUNT=0
	BOTHCOUNT=0
	NEITHERCOUNT=0

	while read f;
	do
		THISHIST=0
		THISTEST=0
		#HIST is defined as the first line (paragraph) right now.
		#BOOBOO: not separating words means "ward" will catch "edward". BLARG.
		if [ -n "$(head -n 1 "$f" | grep -w $w)" ]
		then THISHIST=1
		fi
		if [ -n "$(tail -n +2 "$f" | grep -w $w)" ]
		then THISTEST=1
		fi
		if [[ $THISHIST == 1 && $THISTEST == 1 ]]; then ((BOTHCOUNT++)); fi;
		if [[ $THISHIST == 1 && $THISTEST == 0 ]]; then ((HISTCOUNT++)); fi;
		if [[ $THISHIST == 0 && $THISTEST == 1 ]]; then ((TESTCOUNT++)); fi;
		if [[ $THISHIST == 0 && $THISTEST == 0 ]]; then ((NEITHERCOUNT++)); fi;
	done < $FILES

	#output stats
	echo -e $w"\t"$BOTHCOUNT "\t" $TESTCOUNT "\t" $HISTCOUNT "\t" $NEITHERCOUNT
done < $WORDS


		


	

