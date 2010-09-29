{
	word=$1
	posap=-1
	negap=-1
	prior=-1
if ( ($2 + $3) != 0) {posap = $2 / ($2 + $3) }
if ( ($4 + $5) != 0) {negap = $4 / ($4 + $5) }
if ($6 > 0) prior = $6 / 535759
print prior "\t" posap "\t" negap "\t" $1
}
