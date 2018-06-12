/* hp --- reverse Polish notation calculator program */

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "hp.h"		/* get declarations */

#define MAXSTACK	100
#define TRUE		1
#define FALSE		0

double stack[MAXSTACK + 1];
int scanptr = -1;
int sp = 0;
char line[BUFSIZ*4];

int
main(int argc, char **argv)
{
	int i, l;

	if (argc > 1) {
		l = 0;
		/* concatenate args into one line for input() to use... */
		for (i = 1; argv[i] != NULL; i++) {
			(void) strcpy(& line[l], argv[i]);
			l += strlen(argv[i]);
			line[l] = ' ';
			l++;
		}
		line[l] = '\0';
		scanptr = -1;
		yyparse();
		if (sound(1)) {
			if(stack[sp] > .01)
				printf("%1.3f\n", stack[sp]);
			else
				printf("%.3e\n",stack[sp]);
		}
	} else
		while (fgets(line, sizeof line, stdin) != NULL) {
			scanptr = -1;
			yyparse();
		}
	
	exit(0);
}

/* ctod --- do atof, but increment pointer into the line buffer */

double
ctod(char text[], int *indx)
{
	double result, atof();
	char buf[BUFSIZ];
	int i = 0;

	while (isdigit(text[*indx])) {
		buf[i++] = text[*indx];
		(*indx)++;
	}

	if (text[*indx] == '.') {
		buf[i++] = '.';
		(*indx)++;
	}
	
	while (isdigit(text[*indx])) {
		buf[i++] = text[*indx];
		(*indx)++;
	}

	if (text[*indx] == 'e' ||  text[*indx] == 'E') {
		buf[i++] = text[*indx];
		(*indx)++;
	
		if (text[*indx] == '-' || text[*indx] == '+') {
			buf[i++] = text[*indx];
			(*indx)++;
		}

		while (isdigit(text[*indx])) {
			buf[i++] = text[*indx];
			(*indx)++;
		}
	}

	buf[i] = '\0';

	result = atof(buf);
	return result;
}

/* fmod --- do floating modulus */

double
fmod(double x, double y)
{
	extern double modf();
	extern double fabs();
	double f;
	int flag = 0;
	double ipart;

	if (y == 0.0)
		return x;

	flag = (x < 0.0);
	x = fabs(x);
	y = fabs(y);
	(void) modf(x / y, & ipart);
	f = x - y * ipart;
	return (flag ? -f : f);
}

/* push --- push one item onto the stack */

void
push(double stuff)
{
	if (sp > MAXSTACK)
		fprintf(stderr, "stack overflow\n");
	else {
		sp++;
		stack[sp] = stuff;
	}
}



/* sound --- sound out the depth of the stack */

int
sound(int depth)
{
	if (sp < depth) {
		fprintf(stderr, "stack underflow\n");
		return FALSE;
	} else
		return TRUE;
}

int
input(void)
{
	register int c;

again:
	scanptr++;
	if ((c = line[scanptr]) == '\0') {
		scanptr = -1;
		return 0;
	} else if (isspace(c))
		goto again;
	else {
		return c;
	}
}

void
unput(int c)
{
	line[--scanptr] = c;
}

void
yyerror(char *s)
{
	fprintf(stderr, "hp: %s\n", s);
}
