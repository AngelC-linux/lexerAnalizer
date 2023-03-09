%{
#include <studio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
FILE *yyin;
%}

%option noyywrap
%option yylileno

DIGITO		[0-9]
LETRA		[a-zA-Z]
ESPACIO		[" "]
INI_COMENTARIO	["/*"]
FIN_COMENTARIO	["*/"]
GUIONES		[-_]
CHAR_COMA	[","]
CHAR_PUNTO	["."]
CHAR_PUNTOYCOMA	[";"]
CHAR_DOSPUNTOS	[":"]

IDENTIFICADOR	{LETRA}({LETRA}|{DIGITO}|{GUIONES})*
CONST_INTEGER	(-?[1-9][0-9]{0,4})|0
CONST_FLOAT	{DIGITO}{0,8}{CHAR_PUNTO}{DIGITO}{1,8}
CONST_CADENA	\"[^\n"]*\"
OP_SUMA		["+"]
OP_RESTA	["-"]
OP_MULT		["*"]
OP_DIV		["/"]
OP_IGUAL	["="]
OP_MAYOR	[">"]
OP_MENOR	["<"]
OP_MAYORIGUAL	">="
OP_MENORIGUAL	"<="
OP_COMP_IGUAL	"=="
OP_NEGACION	"!"
OP_DISTINTO	"!="

/*Tiene doble funcionalidad, definir un tipo de datos o asignar un valor*/
OP_DOSPUNTOS	[":"]

/*Caracteres que de apertura, cierre y fin de linea*/
LLAVE_A		["{"]
LLAVE_C		["}"]
PARENTESIS_A	["("]
PARENTESIS_C	[")"]
FIN_SENTENCIA	[";"]

/*PALABRAS RESERVADAS*/
IF	"if"|"IF"
WHILE	"while"|"WHILE"
DECVAR	"DECVAR"
ENDDEC	"ENDDEC"
INTEGER	"integer"|"INTEGER"
FLOAT	"float"|"FLOAT"
WRITE	"write"|"WRITE"

/*SECCIÓN REGLAS (Pratón y acción semántica(Bloque de código que se ejecuta al detectar un patrón))
* Es importante el órden, dado que se va a ir buscando el patrón y ejecutando la acción en orden secuencial
*si una regla hace match pasa al siguiente token y puede que la regla siguiente era la que yo quería matchear
*Ej: si pongo la regla del IDENTIFICADOR primero no va a llegar a las reglas de las palabras reservadas*/

%%

{OP_DOSPUNTOS}		{printf("\nOP_DOSPUNTOS (%s)", yytext);}
{FIN_SENTENCIA}		{printf("\nFIN_SENTENCIA (%s)", yytext);}
{CHAR_COMA}		{printf("\nCHAR_COMA (%s)", yytext);}
{CHAR_PUNTOYCOMA}	{printf("\nCHAR_PUNTOYCOMA (%s)", yytext);}
{CONST_INTEGER}		{fn_verificarRango(yytext); printf("\nCONST_INTEGER (%s)", yytext);}
{CONST_FLOAT}		{printf("\nCONST_FLOAT (%s)", yytext);}
{CONST_CADENA}		{printf("\nCONST_CADENA (%s)", yytext);}

{OP_SUMA}		{printf("\nOP_SUMA (%s)", yytext);}
{OP_RESTA}		{printf("\nOP_RESTA (%s)", yytext);}
{OP_MULT}		{printf("\nOP_MULT (%s)", yytext);}
{OP_DIV}		{printf("\nOP_DIV (%s)", yytext);} //7:07
{OP_IGUAL}		{printf("\nOP_IGUAL (%s)", yytext);}
{OP_MAYOR}		{printf("\nOP_MAYOR (%s)", yytext);}
{OP_MENOR}		{printf("\NOP_MENOR (%s)", yytext);}
{OP_MAYORIGUAL}		{printf("\nOP_MAYORIGUAL (%s)", yytext);}
{OP_MENORIGUAL}		{printf("\nOP_MENORIGUAL (%s)", yytext);}
{OP_COMP_IGUAL}		{printf("\nOP_COMP_IGUAL (%s)", yytext);}
{OP_NEGACION}		{printf("\nOP_NEGACION (%s)", yytext);}
{OP_DISTINTO}		{printf("\nOP_DISTINTO (%s)", yytext);}
{OP_DOSPUNTOS}		{printf("\nOP_DOSPUNTOS (%s)", yytext);}

{LLAVE_A}		{printf("\nLLAVE_A (%s)", yytext);}
{LLAVE_C}		{printf("\nLLAVE_C (%s)", yytext);}
{PARENTESIS_A}		{printf("\nPARENTESIS_A (%s)", yytext);}
{PARENTESIS_C}		{printf("\nPARENTESIS_C (%s)", yytext);}

{IF}			{printf("\nPalabra Reservada IF: (%s)", yytext);}
{WHILE}			{printf("\nPalabra Reservada WHILE: (%s)", yytext);}
{INTEGER}		{printf("\nPalabra Reservada INTEGER: (%s)", yytext);}
{FLOAT}			{printf("\nPalabra Reservada FLOAT: (%s)", yytext);}
{WRITE}			{printf("\nPalabra Reservada WRITE: (%s)", yytext);}
{DECVAR}		{printf("\nPalabra Reservada DECVAR: (%s)", yytext);}
{ENDDEC}		{printf("\nPalabra Reservada ENDDEC: (%s)", yytext);}
{FLOAT}			{printf("\nPalabra Reservada FLOAT: (%s)", yytext);}
{INTEGER}		{printf("\nPalabra Reservada INTEGER: (%s)", yytext);}

{IDENTIFICADOR}		{printf("\nIDENTIFICADOR (%s)", yytext);}

"\n"
"\t"
" "
.	yyerror() //Si llego aquí es porque no encontro Regex o token que matchee con el caracter leído por FLEX.
%%

int main(int argc, char *argv[]){

/*Abro el archivo en modo lectura y dejo apuntando el puntero yyvin que nos pide FLEX.*/
	if((yyin = fopen(argv[1], "rt"))== NULL){

	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	return 0;

	}else{
	printf("\nEl archivo %s se abrió correctamente\n", argv[1]);
	yylex();

	}
	printf("\nFLEX finalizó la lectura del archivo %s \n", argv[1]);
	fclose(yyin);
	return 0;

}

/*-32768 a 32767*/

int fn_verificarRango(char*ptr){

	int value = atoi(ptr);

	if(value < -32768) || (value > 32767){

		printf("Error: variable fuera de rango: %s", yytext);
		return yyerror();
	}
	return 0;
}

int yyerror(void){

	printf("\nError léxico: Caracter inválido: %s, saliendo ...\n", yytext);
	exit(1);
}
