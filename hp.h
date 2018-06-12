/* hp.h --- external declarations for hp */

extern double stack[];
extern int scanptr;
extern int sp;
extern char line[];

extern int main(int argc, char **argv);
extern double ctod(char text[], int *indx);
extern double fmod(double x, double y);
extern void push(double stuff);
extern int sound(int depth);
extern int input(void);
extern void unput(int c);
extern void yyerror(char *s);
extern int yylex(void);
extern int yyparse(void);
