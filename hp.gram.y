/* yacc grammar for hp reverse polish calculator */

%{
#include "y.tab.h"

#include "hp.h"

int i;
extern int sound ();
extern double ctod (), pow (), fmod ();
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

constant : DOT	{ push (ctod (line, & scanptr)); scanptr--; }
	| DIGIT	{ push (ctod (line, & scanptr)); scanptr--; }
	;

command : LITTLEP	{ if (sound (1)) printf ("%lf\n", stack [sp]); }

	| BIGP	{ for (i = 1; i < sp; i++)
			printf ("%lf\n", stack [i]); }

	| PLUS	{
			if (sound (2))
			{
				stack [sp - 1] += stack [sp];
				sp--;
			}
		}

	| MINUS	{
			if (sound (2))
			{
				stack [sp - 1] -= stack [sp];
				sp--;
			}
		}

	| STAR	{
			if (sound (2))
			{
				stack [sp - 1] *= stack [sp];
				sp--;
			}
		}

	| SLASH	{
			if (sound (2))
			{
				stack [sp - 1] /= stack [sp];
				sp--;
			}
		}

	| PERCENT	{
				if (sound (2))
				{
					stack [sp - 1] = fmod (stack [sp - 1], stack[sp]);
					sp--;
				}
			}

	| POW	{
			if (sound (2))
			{
				stack [sp - 1] = pow (stack [sp - 1], stack [sp]);
				sp--;
			}
		}

	| LITTLED	{ if (sound (1)) sp--; }

	| BIGD		{ sp = 0; }

	| LT	{
			if (sound (2))
			{
				if (stack [sp - 1] < stack [sp])
					stack [sp - 1] = 1.0;
				else
					stack [sp - 1] = 0.0;
				sp--;
			}
		}

	| EQ	{
			if (sound (2))
			{
				if (stack [sp - 1] == stack [sp])
					stack [sp - 1] = 1.0;
				else
					stack [sp - 1] = 0;
				sp--;
			}
		}

	| GT	{
			if (sound (2))
			{
				if (stack [sp - 1] > stack [sp])
					stack [sp - 1] = 1.0;
				else
					stack [sp - 1] = 0.0;
				sp--;
			}
		}

	| AND	{
			if (sound (2))
			{
				if (stack [sp - 1] != 0.0 && stack [sp] != 0.0)
					stack [sp - 1] = 1.0;
				else
					stack [sp - 1] = 0.0;
				sp--;
			}
		}

	| OR	{
			if (sound (2))
			{
				if (stack [sp - 1] != 0.0 || stack [sp] != 0.0)
					stack [sp - 1] = 1.0;
				else
					stack [sp - 1] = 0.0;
				sp--;
			}
		}

	| NOT	{
			if (sound (1))
				if (stack [sp] != 0.0)
					stack [sp] = 0.0;
				else
					stack [sp] = 1.0;
		}

	| QUIT	{ exit (0); }
	;
