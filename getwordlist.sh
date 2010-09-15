#!/bin/bash
#gets every word in files.

#Assumptions:
#Preserves case (Mr. Good?)
#Drops ' (cat's = cats)
#Drops - (twenty-something = twentysomething)

tr '\n' ' ' | tr -d ',\"-\(\)\.\?\!\>\<'\' | tr ' ' '\n' | sed -e '/^$/d' -e '/--/d' | sort | uniq 
