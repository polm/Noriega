#!/bin/bash
#gets every word in files.

#Assumptions:
#Preserves case (Mr. Good?)
#Drops ' (cat's = cats)

while read FILE
do 

tr '\n' ' ' < "$FILE" | tr -d ',\"\(\)\.\?\!\>\<\:\;\t'\' | tr ' ' '\n' | sort | uniq | sed -e '/^$/d' -e '/--/d' -e '/^.$/d'

done < "$1"


