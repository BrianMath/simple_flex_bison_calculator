%{
	#include <stdio.h>
	#include <stdlib.h>
	void yyerror(char *);
	int yylex(void);

	double sym[26];
%}

%union {
	long long int_val;
	double real_val;
}

%token <int_val> INTEGER VARIABLE
%token <real_val> REAL
%type <real_val> expression

%left '+' '-'
%left '*' '/'
%nonassoc NEGATIVE

%%

program:
	program statement '\n';
	| /* ε */
	;

statement:
	expression						{ printf("%.2lf\n", $1); }
	| VARIABLE '=' expression		{ sym[$1] = $3; }
	;

expression:
	INTEGER							{ $$ = (double)$1; }
	| REAL							{ $$ = $1; }
	| VARIABLE						{ $$ = sym[$1]; }
	| expression '+' expression		{ $$ = $1 + $3; }
	| expression '-' expression		{ $$ = $1 - $3; }
	| expression '*' expression		{ $$ = $1 * $3; }
	| expression '/' expression {
		if ($3 == 0) {
			yyerror("Não é possível dividir por 0");
		} else {
			$$ = $1 / $3;
		}
	  }
	| '-' expression %prec NEGATIVE	{ $$ = -$2; }
	| '(' expression ')'			{ $$ = $2; }
	;

%%

void yyerror(char *str) {
	fprintf(stderr, "%s\n", str);
	exit(1);
}
