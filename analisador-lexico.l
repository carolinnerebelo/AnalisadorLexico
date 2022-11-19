%{

/*
TRABALHO 2 DE LINGUAGENS FORMAIS
Caroline Bernat Rebelo - DRE 118046249
Júlio Ricardo Burlamaqui dos Santos - DRE 121125214
Lucas Cavalcante Nascimento Silva - DRE 121056863
*/

int cont = 0;
int linha_coment = 0;
int indent = 0;

FILE *file;

%}

%option yylineno
%x COMMENT
%x INDENT

%%

"//".*    fprintf(file, "<COMENTARIO, '%s', %d, %d>\n", yytext, yylineno, indent);
"/*"    { cont++; fprintf(file, "<COMENTARIO, '"); linha_coment = yylineno; BEGIN(COMMENT); }

<COMMENT>{
    "/*"        cont++;
    \n" "*      fprintf(file, "\\n ");
    .           fprintf(file, "%s", yytext);
    "*/"        cont--; if (cont == 0) { fprintf(file, "', %d, %d>\n", linha_coment, indent); BEGIN(INITIAL); }
}

\n      indent = 0;
\n" "  { indent = 0; indent++; BEGIN(INDENT); }

<INDENT>{
    " "    indent++;
    .|\n   unput(yytext[yyleng-1]); BEGIN(INITIAL);
}

    /*PALAVRAS RESERVADAS E OUTROS TOKENS*/
if      fprintf(file, "<IF, 'if', %d, %d>\n", yylineno, indent);
else    fprintf(file, "<ELSE, 'else', %d, %d>\n", yylineno, indent);
while   fprintf(file, "<WHILE, 'while', %d, %d>\n", yylineno, indent);
var     fprintf(file, "<VAR, 'var', %d, %d>\n", yylineno, indent);
return  fprintf(file, "<RETURN, 'return', %d, %d>\n", yylineno, indent);
fn      fprintf(file, "<FN, 'fn', %d, %d>\n", yylineno, indent);
bool    fprintf(file, "<BOOL, 'bool', %d, %d>\n", yylineno, indent);
int     fprintf(file, "<INT, 'int', %d, %d>\n", yylineno, indent);
float   fprintf(file, "<FLOAT, 'float', %d, %d>\n", yylineno, indent);
true    fprintf(file, "<TRUE, 'true', %d, %d>\n", yylineno, indent);
false   fprintf(file, "<FALSE, 'false', %d, %d>\n", yylineno, indent);
"="     fprintf(file, "<=, '=', %d, %d>\n", yylineno, indent);
"("     fprintf(file, "<(, '(', %d, %d>\n", yylineno, indent);
")"     fprintf(file, "<), ')', %d, %d>\n", yylineno, indent);
"{"     fprintf(file, "<{, '{', %d, %d>\n", yylineno, indent);
"}"     fprintf(file, "<}, '}', %d, %d>\n", yylineno, indent);
";"     fprintf(file, "<;, ';', %d, %d>\n", yylineno, indent);
","     fprintf(file, "<,, ',', %d, %d>\n", yylineno, indent);
":"     fprintf(file, "<:, ':', %d, %d>\n", yylineno, indent);

    /*IDENTIFICADORES*/
[a-zA-Z_][a-zA-Z0-9_]*  fprintf(file, "<ID, '%s', %d, %d>\n", yytext, yylineno, indent);

    /*NUMEROS*/
0|[1-9][0-9]*               fprintf(file, "<INTEIRO, '%s', %d, %d>\n", yytext, yylineno, indent);
0[.][0-9]+|[1-9]+[.][0-9]+  fprintf(file, "<FLOAT, '%s', %d, %d>\n", yytext, yylineno, indent);

    /*OPERADORES BINÁRIOS*/
"+"     fprintf(file, "<+, '+', %d, %d>\n", yylineno, indent);
"-"     fprintf(file, "<-, '-', %d, %d>\n", yylineno, indent);
"=="    fprintf(file, "<==, '==', %d, %d>\n", yylineno, indent);
"!="    fprintf(file, "<!=, '!=', %d, %d>\n", yylineno, indent);

    /*ERROS LEXICOS*/
0[0-9]+[.][0-9]*|"*/"|[0-9]+[a-zA-Z]+   fprintf(file, "<ERRO LÉXICO: '%s', %d, %d>\n", yytext, yylineno, indent);

%%


yywrap(){}

int main(int argc, char *argv[]) {
    
    file = fopen("output.txt", "w");
    yyin = fopen(argv[1], "r");
    
    yylex();

    fclose(file);
    return 0;
}
