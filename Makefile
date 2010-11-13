noriega: noriega.c
	gcc -o noriega noriega.c 

all: noriega
	echo "Done!"

clean:
	rm -f noriega noriega.o *~

