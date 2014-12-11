#!/bin/bash

yacc -d simple.y
lex simple.lex
gcc y.tab.c lex.yy.c -g 

