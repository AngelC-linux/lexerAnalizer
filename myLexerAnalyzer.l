%{
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>

int line = 1;
%}

id {letter}({letter}|{digit}|{guiones})*
number	(-?[1-9][0-9]{0,4})|0
	/*numberfloat {digit}+("."{digit}+)?*/
	
letter	[a-zA-Z]
digit	[0-9]
white	[" "]
add	[+]
res	[-]
mult	[*]
div	[/]

parentesis_a	[(]
parentesis_c	[)]
llave_a		[{]
llave_c		[}]

guiones	[-_]
coma	[","]
punto	["."]
dosPuntos	[":"]
puntoYComa	[";"]
igual	["="]
mayor	[">"]
menor	["<"]
mayorIgual	\>\=
menorIgual	\<\=
igualigual	\=\=
negation	!
diferencia	\!\=

saltoLinea	[\n]
sp	[ \t]

%%

	/*RETURNS*/

{id}	return _id;
{number}	return _num;
	/*{numberFloat}	return _numberf;*/
{add}	return *yytext;
{res}	return *yytext;
{mult}	return *yytext;
{div}	return *yytext;
{parentesis_a}	return *yytext;
{parentesis_c}	return *yytext;
{llave_a}	return *yytext;
{llave_c}	return *yytext;
{coma}		{printf("\ncoma (%s)", yytext);}
{punto}		{printf("\npunto (%s)", yytext);}
{dosPuntos}	{printf("\ndosPuntos (%s)", yytext);}
{puntoYComa}	{printf("\npuntoYComa (%s)", yytext);}
{igual}		{printf("\nigual (%s)", yytext);}
{mayor}		{printf("\nmayor (%s)", yytext);}
{menor}		{printf("\nmayor (%s)", yytext);}
{mayorIgual}	{printf("\nmayorIgual (%s)", yytext);}
{menorIgual}	{printf("\nmenorIgual (%s)", yytext);}
{igualigual}	{printf("\nigualigual (%s)", yytext);}
{negation}	{printf("\nnegation (%s)", yytext);}
{diferencia}	{printf("\ndiferencia (%s)", yytext);}
{saltoLinea}	line++;


<<EOF>> return _eof;

.	{
	printf("\nError léxico [%c]", *yytext);
	return _err;
	}

%%

int yywrap(){
return 1;
}


