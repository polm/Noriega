#!/bin/bash
#gets every word in files.

tr '\n' ' ' | tr -d ',\"-\(\)\.'\' | tr ' ' '\n' | sed -e '/^$/d' -e '/--/d' | sort | uniq 
