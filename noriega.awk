BEGIN {
	total=0
	while (getline < wordlist){
		words[$0]="0 0 0 0 0" #initialize!
		occ[$0]=0;
		hist[$0]=0;
		test[$0]=0;
	}

	while (getline < filelist){
		files[$0]=""
	}

	for (file in files){
		#calc A,B,C,D
			line=0
			curwords[""] = "";
			while (getline curline < file) {
				line++;
				split(curline, curarray, "\\W");
				for (x in curarray) {
					curwords[curarray[x]]=0; #This word is in this document.
					total++;
					occ[curarray[x]]++;
					if (line==1) hist[curarray[x]]=1;
					else test[curarray[x]]=1;
					#print curarray[x]" "hist[curarray[x]]" " test[curarray[x]]
				}
			}
			close(file)
			#print hist test
			for (word in curwords){
				$0=words[word]
				if(hist[word] && test[word]) $1++;
				if(hist[word] && !test[word]) $2++;
				if(!hist[word] && test[word]) $3++;
				if(!hist[word] && !test[word]) $4++;
				hist[word] = 0;
				test[word] = 0;
				$5 = occ[word];

				words[word]=$0
			}

		#calc df_whatever
		}

	for (w in words){
		posap=-1
		negap=-1
		prior=-1
		$0 = words[w];
		if ($2 + $3 > 0) posap= $2 / ($2 + $3)
		if ($2 + $3 > 0) negap= $4 / ($4 + $5)
		prior= $5 / total
		if(prior > 0) ratio = posap / prior
		if (posap < 0 || negap < 0 || prior < 0)  continue;
		print ratio " " prior " " posap " " negap " " w
	}
		print "total words: " total
}

