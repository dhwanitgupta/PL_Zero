%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
#include "type.h"
#include<ctype.h>

int variable[26];
procedure_block procedure_info[100];
int procedure_index;

tries* root_tries = NULL;

tNode *build_operator(char *op,tNodeType t, tNode* left , tNode* right){

	tNode *ptr;
	ptr = (tNode*)malloc(sizeof(tNode));
	ptr->op = op;
	ptr->type = t;
	ptr->left = left;
	ptr->right = right;
	if(strcmp(op,"procedure") == 0){
		procedure_info[procedure_index].node = ptr;
		procedure_info[procedure_index].name = left->id;
		procedure_index++;
	}
	return ptr;
}

tNode* build_id(char* id){
	
	tNode *ptr;
	ptr = (tNode*)malloc(sizeof(tNode));
	ptr->type = t_id;
	ptr->id = id;
	return ptr;
}

tNode* build_number(int num){
	
	tNode *ptr;
	ptr = (tNode*)malloc(sizeof(tNode));
	ptr->type = t_number;
	ptr->num = num;
	return ptr;
}

tNode* get_procedure(char* p_name){
	
	int i = 0;
	for(i=0;i<procedure_index;i++){
		if(strcmp(p_name,procedure_info[i].name)==0){
			return procedure_info[i].node->right;
		}
	}
}
int evaluate(tNode *root){
	
	if(root == NULL)
		return 0;

	if(root->type == t_number)
		return root->num;

	if(root->type == t_id){
		int *val;
		int t_val = 10;
		val = &t_val;
		if(check(root->id,val)==1){
			//printf("%d \n",*val);
			return *val;
		}
//		return variable[(int)root->id[0] - 97];
	}

	if(root->type == t_operator ){
		if(strcmp(root->op,"=")==0 || strcmp(root->op,":=")==0){
			//variable[(int)root->left->id[0] - 97] = evaluate(root->right);
			insert(root->left->id,evaluate(root->right));
			return -1;
		}
		if(strcmp(root->op,"+") ==0)
			return evaluate(root->left) + evaluate(root->right);
		if(strcmp(root->op,"-") ==0)
			return evaluate(root->left) - evaluate(root->right);
		if(strcmp(root->op,"*") ==0)
			return evaluate(root->left) * evaluate(root->right);
		if(strcmp(root->op,"/") ==0)
			return evaluate(root->left) / evaluate(root->right);
		if(strcmp(root->op,"UM") == 0)
			return -1*evaluate(root->left);

	}

	if(root->type == t_condition){

		if(strcmp(root->op,"=") ==0 ){
			if(evaluate(root->left) == evaluate(root->right))
				return 1;
			return 0;
		}	
		if(strcmp(root->op,">=") ==0 ){
			if(evaluate(root->left) >= evaluate(root->right))
				return 1;
			return 0;
		}	
		if(strcmp(root->op,"<=") ==0 ){
			if(evaluate(root->left) <= evaluate(root->right))
				return 1;
			return 0;
		}	

		if(strcmp(root->op,"#") ==0 ){
			if(evaluate(root->left) != evaluate(root->right))
				return 1;
			return 0;
		}	
		if(strcmp(root->op,">") ==0 ){
			if(evaluate(root->left) > evaluate(root->right))
				return 1;
			return 0;
		}	
		
		if(strcmp(root->op,"<") ==0 ){
			if(evaluate(root->left) < evaluate(root->right))
				return 1;
			return 0;
		}	
	}

	if(root->type == t_block){

		if(strcmp(root->op,"IF") == 0){
			if(evaluate(root->left) == 1)
				evaluate(root->right);
			return -1;
		}
		if(strcmp(root->op,"WHILE")==0){
			while(evaluate(root->left)){
				evaluate(root->right);
			}
			return -1;
		}
		evaluate(root->left);
		evaluate(root->right);
		return -1;
	}
	if(root->type == t_call){
		evaluate(root->left);
		evaluate(root->right);
		return -1;
	}

	if(root->type == t_odd){
		if(evaluate(root->left)%2 == 0)
			return 0;
		return 1;
	}
}

void printTree(tNode *root){
	
	if(root == NULL || root->type ==t_procedure )
		return;

	switch (root->type){
		case t_number : { printf("%d ",root->num);break;}

		case t_id : { printf("%s ",root->id); break;}

		case t_operator :{
				printTree(root->left);
				printf("%s ",root->op);
				printTree(root->right);
				break;
			}
		case t_block :{
				printTree(root->left);
				printf("%s ",root->op);
				printTree(root->right);
				break;
			      }
		case t_call :{
					printTree(root->left);
					printf("%s ",root->op);
					printTree(root->right);
					break;
				  }
		case t_condition :{
					printTree(root->left);
					printf("%s ",root->op);
					printTree(root->right);
					break;
				  }
		case t_odd : {
				printTree(root->left);
				break;
			     }
	}
	return ;
}
void printTree_pre(tNode* root){
	if(root == NULL)
		return;

	switch (root->type){
		case t_number : { printf("%d ",root->num);break;}

		case t_id : { printf("%s ",root->id); break;}

		case t_operator :{
				printf("%s ",root->op);
				printTree_pre(root->left);
				printTree_pre(root->right);
				break;
			}
		case t_block :{
				printf("%s ",root->op);
				printTree_pre(root->left);
				printTree_pre(root->right);
				break;
			      }
		case t_procedure :{
					printf("%s ",root->op);
					printTree_pre(root->left);
					printTree_pre(root->right);
					break;
				  }
		case t_condition :{
					printf("%s ",root->op);
					printTree_pre(root->left);
					printTree_pre(root->right);
					break;
				  }
		case t_odd : {
				printTree_pre(root->left);
				break;
			     }
	}

}
int get_index(char c){
	
	int ind = (int)c;
	if(c >= '0' && c <= '9')
		return (int)c - 48;

	if(c >= 'a' && c <= 'z')
		return (int)c - 87;

	if(c >= 'A' && c <= 'Z')
		return (int)c - 29;

	if(c == '_')
		return 62;
}
tries* get_block(){
	
	tries* temp;
	temp = (tries *)malloc(sizeof(tries));
	temp->data = 0;
	temp->value = 0;
	int i;
	for(i=0;i<63;i++)
		temp->next[i] =NULL;
	return temp;
}
int check(char *str,int* val){
	int i = 0;
	tries* root = root_tries;
	int index;
	while(str[i] != '\0'){
		index = get_index(str[i]);
		if(root->next[index] == NULL)
			return 0;
		if(str[i+1] == '\0' && root->next[index]->data == 1){
			*val = root->next[index]->value;
			return 1;
		}
		root = root->next[index];
		i++;
	}
	return 0;
}
int insert(char *str,int value){

	tries* temp = root_tries;
	int i =0;
	int index;
	while(str[i] != '\0'){
		index = get_index(str[i]);
		if(root_tries->next[index] == NULL){
			root_tries->next[index] = get_block();
			if(str[i+1] == '\0'){
				root_tries->next[index]->data = 1;
				root_tries->next[index]->value = value;
			}
			root_tries = root_tries->next[index];
			root_tries->c = str[i];
		}	
		else{
			root_tries = root_tries->next[index];
			root_tries->c = str[i];

			if(str[i+1] =='\0'){
			//	if(root_tries->data == 1)
			//		return 0;
			//	else{
					root_tries->data = 1;
					root_tries->value = value;
			//	}
			}
		}
		i++;
	}
	root_tries = temp;
	return 1;
}
void printf_values(tries* root,char str[100],int index){
/*	int i;

	for(i=0;i<26;i++)
		if(variable[i] != -1)
			printf("%c = %d \n",i+97,variable[i]);
*/
	if(root==NULL)
		return;
	int i;
	char c;
	for(i=0;i<63;i++){
		if(root->next[i] != NULL){
			//printf("%c",root->next[i]->c);
			str[index] = root->next[i]->c;
			if(root->next[i]->data == 1){
				str[index+1] = '\0';
				printf("%s %d\n",str,root->next[i]->value);
			}
			printf_values(root->next[i],str,index + 1);	
		}
	}
}
void init(){
	procedure_index = 0;
	root_tries = get_block();
	int i;
	for(i=0;i<26;i++)
		variable[i] = -1;
}
void yyerror(char *s) {
	 fprintf(stderr, "%s", s);
 }
int yywrap(void){

	return 1;
}
int main(int argc, char *argv[])
{
        
     return yyparse();
}
%}

%union {
	int num;
	char* id;
	tNode *node;
};

%token <num>NUMBER 
%token <id> ID 
%token CONST VAR PROCEDURE Assign Begin END IF THEN WHILE DO ODD 
%token CALL 

%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>' LE GE '#' 
%nonassoc UMINUS
%type <node> block Program assign1 expr block1 block2 assign2 block3 procedures temp_block3 statement statements condition
%%

Program: block '.' { char str[100]; init(); evaluate($1) ;printf_values(root_tries,str,0); exit(0);} 
        ;

block: block1 {$$ = $1;}
	;

block1: CONST assign1 ';' block2 {  $$ = build_operator("block1",t_block,$2,$4);}
	|block2 { $$ = $1; } 
	;

assign1: assign1 ',' ID '=' expr { $$ = build_operator("assign1",t_block,$1,build_operator("=",t_operator,build_id($3),$5));}
	| ID '=' expr { $$ = build_operator("=",t_operator,build_id($1),$3);}
	;

block2 : VAR assign2 ';' temp_block3 {$$ = build_operator("block2",t_block,$2,$4);}
	|temp_block3{ $$ = $1;}
	;

assign2: assign2 ',' ID { $$ = build_operator("assign2" , t_block,$1,build_id($3));}
	| ID { $$ = build_id($1);}
	;

temp_block3: block3 statement { $$ = build_operator("block3_out",t_block,$1,$2);}
	;

block3 : block3 procedures { $$ = build_operator("block3",t_block,$1,$2);}
	|{$$=NULL;}
	;

procedures: PROCEDURE ID ';' block ';' { $$ = build_operator("procedure",t_procedure,build_id($2),$4);}
	;

statement:  ID Assign expr { $$ = build_operator(":=",t_operator,build_id($1),$3);}
	| CALL ID { $$ = get_procedure($2);}
	| Begin statements END { $$ = build_operator("statements",t_block,NULL,$2);}
	| IF condition THEN statement { $$ = build_operator("IF",t_block,$2,$4);}
	| WHILE condition DO statement { $$ = build_operator("WHILE",t_block,$2,$4);}
	| {$$ = NULL;}
	;

statements: statement ';' statements { $$ = build_operator("statement",t_block,$1,$3);}
	| statement {$$ = build_operator("statement",t_block,$1,NULL);}
	;

condition: ODD expr { $$ = build_operator("ODD",t_odd,$2,NULL);}
	|expr '=' expr { $$ = build_operator("=",t_condition,$1,$3);}
	| expr '>' expr { $$ = build_operator(">",t_condition,$1,$3);}
	| expr '<' expr { $$ = build_operator("<",t_condition,$1,$3);}
	| expr '#' expr { $$ = build_operator("#",t_condition,$1,$3);}
	| expr LE expr { $$ = build_operator("<=",t_condition,$1,$3);}
	| expr GE expr { $$ = build_operator(">=",t_condition,$1,$3);}
	;


expr: '-' expr %prec UMINUS { $$ = build_operator("UM",t_operator,$2,NULL);}
     |NUMBER { $$ = build_number($1);} 
     | ID     { $$ = build_id($1);}
     | expr '+' expr { $$ = build_operator("+",t_operator,$1,$3);}
     | expr '-' expr { $$ = build_operator("-",t_operator,$1,$3); }
     | expr '*' expr { $$ = build_operator("*",t_operator,$1,$3);}
     | expr '/' expr { $$ = build_operator("/",t_operator,$1,$3);}
     | expr LE expr { $$ = build_operator("<=",t_operator,$1,$3);}
     | expr GE expr { $$ = build_operator(">=",t_operator,$1,$3);}
     | expr '<' expr { $$ = build_operator("<",t_operator,$1,$3);}
     | expr '>' expr { $$ = build_operator(">",t_operator,$1,$3); }
     | expr '#' expr { $$ = build_operator("#",t_operator,$1,$3); }
     ;

%%
