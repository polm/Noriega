#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uthash.h"
#include "utstring.h"
#include "wn.h"

#define LINE_SIZE 10240 /*bigger than this is a problem for various reasons*/

#define PUNCTUATION " ,.\":;!?\n\t"

typedef struct word word;
struct word {
	UT_string* w;
	char* s;
	unsigned int ht;
	unsigned int t;
	unsigned int h;
	/*it won't be checked for articles it doesn't appear in*/
	unsigned int occ; /*will not overflow - GIGAword*/
	UT_hash_handle hh;
	UT_hash_handle hh2; /*for the temp*/
};


/*Strategy:
 *
 * Get file with one filename per line
 * While not EOF get next file and:
 * 	create temp hash
 * 	(increment occ every time you find a word)
 * 	Open file, read line 1
		Mark HIST true for each word in temp hash
 * 	Read the rest of the file
 		Mark TEST true for each word in temp hash
 *	iterate over temp hash and modify main hash as appropriate
 *	repeat
 *
 * Do calculations/output here
 */

enum pres {BOTH, HIST, TEST}; /*where is the word?*/

word *words = NULL; /*main stats*/
word *twords = NULL; /*temp stats*/

void hash_update();
void temp_hash_update(char*,int);

int main(int argc, char *argv[]){
	if(argc != 2){
		printf("usage: \n\tnoriega filelist\n");
		exit(1);
	}

	FILE *file = fopen(argv[1], "r");
	if(file == NULL) {
		perror("Couldn't open file list!");
		exit(1);
	}

	word *allwords = NULL; /*prime hash*/
	wninit(); /*Initialize WordNet*/
	char line[LINE_SIZE]; 
	unsigned int filecount = 0;
	unsigned int wordcount = 0;
	while(1){ /*filename getting loop*/
		if(feof(file)) break;
		fgets(line, LINE_SIZE, file);
		line[strlen(line)-1] = '\0'; /*nuke newlines*/
		//printf("file:%s\n", line);
		FILE *article = fopen (line, "r");
		filecount++;
		if(article == NULL){
			perror("Problem opening article!");
			continue;
		}
		/*OK, do the article now*/

		fgets(line, LINE_SIZE, article);
		char *tw;
		tw = strtok(line, PUNCTUATION);
		do {
			wordcount++;
			temp_hash_update(tw, HIST);
		} while((tw = strtok(NULL, PUNCTUATION)) != NULL);

		while(!feof(article)){
			fgets(line, LINE_SIZE, article);
			tw = strtok(line, PUNCTUATION);
			do {
			if(tw == NULL || !strcmp(tw, "\n")) continue;
			wordcount++;
			temp_hash_update(tw, TEST);
			} while((tw = strtok(NULL, PUNCTUATION)) != NULL);
		}
		/*finished the article.*/
		fclose(article);
		hash_update();
	}

	/*cleanup*/
	fclose(file);
	word *cw;
	printf("Output time!\n");
	while(words){
		cw = words;
		double posapp = (0 != cw->h + cw->ht ) ? (double)cw->ht / (double)(cw->h + cw->ht) : -1;
		double prior = (double)cw->occ / wordcount;
		double ec = (0 != posapp) ? prior / posapp : -1;
		double newec = (-1 != ec) ? ec * prior : -1;
		printf("%.10f\t%.10f\t%.8f\t%.8f\t%u\t%u\t%u\t%u\t%s\n",
				newec,
				ec,
				posapp,
				prior,
				cw->ht,
				cw->h,
				cw->t,
				cw->occ,
				cw->s);
		HASH_DEL(words, cw);
		utstring_free(cw->w);
		free(cw);
	}


}

void hash_update(){
	word *cw;
	while (twords){
		cw = twords;
		word *tw;
		HASH_FIND(hh, words, cw->s, strlen(cw->s), tw);
		if(tw){
			/*exists; update it*/
			if(cw->h && cw->t) tw->ht += 1;
			else if (cw->h) tw->h += 1;
			else if (cw->t) tw->t += 1;
			tw->occ += cw->occ;
			HASH_DELETE(hh2, twords, cw);
			utstring_free(cw->w);
			free(cw);
		}
		else {
			/*not there; add it*/
			HASH_ADD_KEYPTR(hh, words, cw->s, strlen(cw->s), cw);
			cw->ht = 0;
			if(cw->h && cw->t) {
				cw->ht = 1;
				cw->h = 0;
				cw->t = 0;
			}
			HASH_DELETE(hh2, twords, cw);
		}
	}
	
}

void temp_hash_update(char* w, int stat){
	/*is this word in the hash?*/
	word *aword;

	HASH_FIND(hh2, twords, w, strlen(w), aword);
	if(aword == NULL){
		/*didn't have it; create it*/
		/*No capital letter words.*/
		if(w[0] >= 'A' && w[0] <= 'Z') return;
		/*No numbers.*/
		if(w[strlen(w)-1] >= '0' && w[strlen(w)-1] <= '9') return;
		/*No nouns.*/
		if(in_wn(w, NOUN)) return; 

		aword = malloc(sizeof(word));
		if(stat == HIST) aword->h = 1;
		if(stat == TEST) aword->t = 1;
		aword->occ = 1;
		UT_string *s;
		utstring_new(s);
		utstring_printf(s, "%s", w);
		aword->w = s;
		aword->s = utstring_body(s);
		HASH_ADD_KEYPTR(hh2, twords, aword->s, strlen(aword->s), aword);
		return;
	}
	else{
		/*it exists; update it*/
		if(stat == HIST) aword->h = 1;
		if(stat == TEST) aword->t = 1;
		aword->occ = aword->occ + 1;
		return;
	}

}
