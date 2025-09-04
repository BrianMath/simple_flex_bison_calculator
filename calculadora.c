#include <stdio.h>

extern FILE *yyin;
extern int yyparse(void);

int main(int argc, char *argv[]) {
	if (argc < 2) {
		fprintf(stderr, "Uso esperado: %s <entrada>\n", argv[0]);
		return 1;
	}

	FILE *input = fopen(argv[1], "r");
	if (!input) {
		fprintf(stderr, "Não foi possível abrir %s\n", argv[1]);
    	return 1;
	}

	// Analisador léxico (flex) aponta para o arquivo de entrada
	yyin = input;

	// Chama o analisador sintático (bison)
	int res = yyparse();

	fclose(input);

	return res;
}