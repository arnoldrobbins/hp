# makefile for 'hp' --- reverse polish notation calculator

CFLAGS= -O
YFLAGS= -d
DESTDIR=/usr/local/bin
MANSEC=l
CP= cp

OBJS = hp.o hp.gram.o # hp.scan.o

hp: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -lm -o hp

#hp.scan.o : y.tab.h
#	lex hp.scan.l
#	cc -O -c lex.yy.c
#	rm lex.yy.c
#	mv lex.yy.o hp.scan.o

hp.gram.o y.tab.h : hp.gram.y

install: hp hp.1
	$(CP) hp $(DESTDIR)
	$(CP) hp.1 /usr/man/man$(MANSEC)/hp.$(MANSEC)

print:
	pr hp.gram.y hp.scan.l hp.h hp.c | lpr
	nroff -man hp.1 | col | lpr

clean:
	rm -f $(OBJS) hp.gram.c y.tab.h

clobber: clean
	rm -f hp
