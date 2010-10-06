#!/bin/bash
#Behavior: Assume every file from $1 down is one article in the corpus. 
# Pump results to stdout.
find "$1" -type f > /tmp/noriega.files.$$
noriegac /tmp/noriega.files.$$ | \
sort -n -r


