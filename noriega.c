#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uthash.h"
#include "utstring.h"

#define LINE_SIZE 10240 /*bigger than this is a problem for various reasons*/

typedef struct word word;
struct word {
	UT_string* w;
	unsigned int ht;
	unsigned int t;
	unsigned int h;
	/*it won't be checked for articles it doesn't appear in*/
	unsigned int occ; /*will not overflow - GIGAword*/
	UT_hash_handle hh;
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

int main(int argc, char *argv[]){
	if(argc != 1){
		printf("usage: \n\tnoriega filelist\n");
		exit(1);
	}

	FILE *file = fopen(argv[1], "r");
	if(file == NULL) {
		perror("Couldn't open file list!");
		exit(1);
	}

	word *allwords = NULL; /*prime hash*/
	char line[LINE_SIZE]; 
	while(1){ /*filename getting loop*/
		if(feof(file)) break;
		fgets(line, LINE_SIZE, file);
		FILE *article = fopen (line, "r");
		if(article == NULL){
			perror("Problem opening article!");
			continue;
		}
		/*OK, do the article now*/

		fgets(line, LINE_SIZE, article);
		char *tw;
		while((tw = strtok(line, " ,.\":;!?")) != NULL){
			temp_hash_update(tw, HIST);
		}
		while(!feof(article)){
			fgets(line, LINE_SIZE, article);
			while((tw = strtok(line, " ,.\":;!?")) != NULL){
			temp_hash_update(tw, TEST);
			}
		}
		/*finished the article.*/
		fclose(article);
		hash_update();
	}

	/*cleanup*/
	fclose(file);
	word *cw;
	while(words){
		cw = words;
		printf("%d\t%d\t%d\t%d\t%s\n",
				cw->ht,
				cw->h,
				cw->t,
				cw->occ,
				ustring_body(cw->w));
		HASH_DEL(words, cw);
		ustring_free(cw->w);
		free(cw);
	}


}

void hash_update(){
	word *cw;
	while (twords){
		cw = twords;
		word *tw;
		if(HASH_FIND_STR(words, ustring_body(cw->w), tw)){
			/*exists; update it*/
			if(cw->h && cw->t) tw->ht += 1;
			else if (cw->h) tw->h += 1;
			else if (cw->t) tw->t += 1;
			tw->occ += cw->occ;
			HASH_DEL(twords, cw);
			ustring_free(cw->w);
			free(cw);
		}
		else {
			/*not there; add it*/
			HASH_ADD_STR(words, ustring_body(cw->w), cw);
			if(cw->h && cw->t) {
				cw->ht = 1;
				cw->h = 0;
				cw->t = 0;
			}
			HASH_DEL(twords, cw);
		}
	}
	
}

void temp_hash_update(char* w, int stat){
	/*is this word in the hash?*/
	word *aword;

	HASH_FIND_STR(twords, w, aword);
	if(aword == NULL){
		/*didn't have it; create it*/
		aword = malloc(sizeof(word));
		if(state == HIST) aword->h = 1;
		if(state == TEST) aword->t = 1;
		aword->occ = 1;
		UT_string *s;
		utstring_new(s);
		utstring_printf(s, "%s", w);
		aword->w = s;
		HASH_ADD_STR(twords, w, aword);
		return;
	}
	else{
		/*it exists; update it*/
		if(state == HIST) aword->h = 1;
		if(state == TEST) aword->t = 1;
		aword->occ = aword->occ + 1;
		return;
	}

}
