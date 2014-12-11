Implementation of  PL/0  http://en.wikipedia.org/wiki/PL/0   using lex and yacc

GRAMMAR 


program = block "." .

block = [ "const" ident "=" number {"," ident "=" number} ";"]
[ "var" ident {"," ident} ";"]
{ "procedure" ident ";" block ";" } statement .

statement = [ ident ":=" expression | "call" ident 
| "?" ident | "!" expression 
| "begin" statement {";" statement } "end" 
| "if" condition "then" statement 
| "while" condition "do" statement ].

condition = "odd" expression |
expression ("="|"#"|"<"|"<="|">"|">=") expression .

expression = [ "+"|"-"] term { ("+"|"-") term}.

term = factor {("*"|"/") factor}.

factor = ident | number | "(" expression ")".



Compile using  make.sh

and run ./a.out < inputfile


