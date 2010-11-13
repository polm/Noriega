noriega: noriega.c
	gcc -o noriega noriega.c 

all: noriega
	echo "Done!"

clean:
	rm noriega noriega.o *~

