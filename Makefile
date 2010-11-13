noriega: noriega.c
	gcc -o noriega noriega.c -lWN -L/usr/local/wn/lib

all: noriega
	echo "Done!"

clean:
	rm noriega noriega.o *~

