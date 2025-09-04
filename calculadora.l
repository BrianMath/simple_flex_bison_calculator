%{
	#include "calculadora.tab.h"
	#include <stdlib.h>

	void yyerror(char *);
%}

%option yylineno noyywrap nounput noinput

VARIABLE [a-z]
INTEGER  [0-9]+
REAL    [0-9]+\.[0-9]+

%%

[ \t]+ {/* Ignorar espaços */}

{VARIABLE} {
	yylval.int_val = (int)(*yytext - 'a');
	return VARIABLE;
}

{REAL} {
	yylval.real_val = (double)(atof(yytext));
	return REAL;
}

{INTEGER} {
	yylval.int_val = atoll(yytext);
	return INTEGER;
}

[-+*/=()\n] {
	return *yytext;
}

; {
	return *yytext;
}

. {
	yyerror("Caractere desconhecido");
}

%%
