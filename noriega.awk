function df (word, k, filelist) {
	#calculates number of documents in which 
	#word appears at least k times
	count=0

}

BEGIN {
	while (getline < "wordlist"){
		words[$0]="0 0 0 0 0 0" #initialize!
	}

	while (getline < "filelist"){
		files[$0]=""
	}

	for (word in words){
		#calc A,B,C,D
		$0=words[word]
		for (file in files){
			line=0
			hist=0;
			test=0;
			while (getline curline < file){
				line++;
				pattern=word 
				if (line == 1 && curline ~ pattern) {hist=1; }

				if (line != 1 && curline ~ pattern) {test=1; break}
			}
			close(file)
			#print hist test
			if(hist && test) $1++;
			if(hist && !test) $2++;
			if(!hist && test) $3++;
			if(!hist && !test) $4++;
			words[word]=$0

		#calc df_whatever
		}
	}

	for (w in words)
		print w " " words[w]
}

