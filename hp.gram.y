/* yacc grammar for hp reverse polish calculator */

%{
#include "y.tab.h"

#include "hp.h"
#include <math.h>

#include <stdio.h>

int i;
extern int sound();
extern double ctod(), pow(), fmod();
%}

%start expression
%term DOT DIGIT BIGP LITTLEP PLUS MINUS STAR SLASH PERCENT POW
%term AND OR NOT EQ LT GT LE GE BIGD LITTLED QUIT

%%
expression : constant_or_command_list
	|
	;

constant_or_command_list : constant_or_command_list constant_or_command
	| constant_or_command
	;

constant_or_command : constant
	| command
	;

constant : DOT	{ push(ctod(line, & scanptr)); scanptr--; }
	| DIGIT	{ push(ctod(line, & scanptr)); scanptr--; }
	;

command : LITTLEP	{ if (sound(1)) printf("%f\n", stack[sp]); }

	| BIGP	{
			for (i = 1; i < sp; i++)
				printf("%f\n", stack[i]);
		}

	| PLUS	{
			if (sound(2)) {
				stack[sp - 1] += stack[sp];
				sp--;
			}
		}

	| MINUS	{
			if (sound(2)) {
				stack[sp - 1] -= stack[sp];
				sp--;
			}
		}

	| STAR	{
			if (sound(2)) {
				stack[sp - 1] *= stack[sp];
				sp--;
			}
		}

	| SLASH	{
			if (sound(2)) {
				stack[sp - 1] /= stack[sp];
				sp--;
			}
		}

	| PERCENT	{
				if (sound(2)) {
					stack[sp - 1] = fmod(stack[sp - 1], stack[sp]);
					sp--;
				}
			}

	| POW	{
			if (sound(2)) {
				stack[sp - 1] = pow(stack[sp - 1], stack[sp]);
				sp--;
			}
		}

	| LITTLED	{ if (sound(1)) sp--; }

	| BIGD		{ sp = 0; }

	| LT	{
			if (sound(2)) {
				if (stack[sp - 1] < stack[sp])
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| LE	{
			if (sound(2)) {
				if (stack[sp - 1] <= stack[sp])
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| EQ	{
			if (sound(2)) {
				if (stack[sp - 1] == stack[sp])
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0;
				sp--;
			}
		}

	| GT	{
			if (sound(2)) {
				if (stack[sp - 1] > stack[sp])
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| GE	{
			if (sound(2)) {
				if (stack[sp - 1] >= stack[sp])
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| AND	{
			if (sound(2)) {
				if (stack[sp - 1] != 0.0 && stack[sp] != 0.0)
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| OR	{
			if (sound(2)) {
				if (stack[sp - 1] != 0.0 || stack[sp] != 0.0)
					stack[sp - 1] = 1.0;
				else
					stack[sp - 1] = 0.0;
				sp--;
			}
		}

	| NOT	{
			if (sound(1)) if (stack[sp] != 0.0)
					stack[sp] = 0.0;
				else
					stack[sp] = 1.0;
		}

	| QUIT	{ exit (0); }
	;

%%

int
yylex()
{
	int c, c1;

next:
	c = input();

	if (c == 0)
		return 0;

	switch (c) {
	case '.':	return (DOT);
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
			return (DIGIT);
	case 'P':	return (BIGP);
	case 'p':	return (LITTLEP);
	case '+':	return (PLUS);
	case '-':	return (MINUS);
	case 'X':
	case 'x':
	case '*':
			return (STAR);
	case '/':	return (SLASH);
	case '%':	return (PERCENT);
	case ':':
	case '^':
			return (POW);
	case '&':	return (AND);
	case '|':	return (OR);
	case '!':	return (NOT);
	case '=':	return (EQ);
	case '<':	
		c1 = input();
		if (c1 == '=')
			return (LE);
		else {
			unput(c1);
			return (LT);
		}
		break;
	case '>':	return (GT);
		c1 = input();
		if (c1 == '=')
			return (GE);
		else {
			unput(c1);
			return (GT);
		}
	case 'D':	return (BIGD);
	case 'd':	return (LITTLED);
	case 'Q':
	case 'q':
			return (QUIT);
	case ' ':
	case '\t':
	case '\n':	break;
	default:
		fprintf(stderr, "%c: unknown command.\n", c);
		break;
	}
	goto next;
}
