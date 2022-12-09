%{
#include <stdio.h>
#include "type.h"
#include <stdlib.h>
#include<string.h>
#include "y.tab.h"
%}

alpha [a-zA-Z_]
digit [0-9]
%%
[ \t] 		;
CALL return CALL;
IF return IF;
ODD return ODD;
THEN return THEN;
WHILE return WHILE;
DO return DO;
CONST return CONST;
VAR return VAR;
PROCEDURE return PROCEDURE;
BEGIN return Begin;
END return END;
":=" return Assign;
"#" return yytext[0];
">=" return GE;
"<=" return LE;
">" return yytext[0];
"<" return yytext[0];
"=" return yytext[0];
"." return yytext[0];
";" return yytext[0];
"," return yytext[0];
"+" return yytext[0];
"-" return yytext[0];
"/" return yytext[0];
"*" return yytext[0];

{digit}+ 	{
		yylval.num = atoi(yytext);
		return NUMBER;
		}
{alpha}({alpha}|{digit})*  {
				char *ptr_string;
				ptr_string = (char *)calloc(strlen(yytext)+1, sizeof(char));
				strcpy(ptr_string, yytext);
				yylval.id = ptr_string;
				return ID;
			   }
"\n" 	;
.	;

%%
