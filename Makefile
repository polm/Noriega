noriegac: noriega.c
	gcc -o noriegac noriega.c -lWN -L/usr/local/wn/lib

all: noriegac
	echo "Done!"

clean:
	rm noriegac noriega.o *~

