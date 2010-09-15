#!/bin/bash
#gets every word in files.

#Assumptions:
#Preserves case (Mr. Good?)
#Drops ' (cat's = cats)
#Drops - (twenty-something = twentysomething)

tr '\n' ' ' | tr -d ',\"\(\)\.\?\!\>\<\:\;\t\-'\' | tr ' ' '\n' | sort | uniq | sed -e '/^$/d' -e '/--/d' -e '/^.$/d'
