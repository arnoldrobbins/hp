%{
/* hp.scan.l --- lex scanner for hp calculator */

#include "y.tab.h"
#undef input
#undef unput
%}

%%
"."	return (DOT);
[0-9]	return (DIGIT);
"P"	return (BIGP);
"p"	return (LITTLEP);
"+"	return (PLUS);
"-"	return (MINUS);
[Xx*]	return (STAR);
"/"	return (SLASH);
"%"	return (PERCENT);
[:^]	return (POW);
"&"	return (AND);
"|"	return (OR);
"!"	return (NOT);
"="	return (EQ);
"<"	return (LT);
">"	return (GT);
"<="	return (LE);
">="	return (GE);
"D"	return (BIGD);
"d"	return (LITTLED);
[Qq]	return (QUIT);
[ \t\n]	;
.	fprintf(stderr, "%s: unknown command.\n", yytext);
