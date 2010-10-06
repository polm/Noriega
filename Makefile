noriegac: noriega.c
	gcc -o noriegac noriega.c

all: noriegac
	echo "Done!"

clean:
	rm noriegac noriega.o *~

