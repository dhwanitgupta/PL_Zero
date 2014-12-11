// tNodeType: enumarate type describing the type of the node
typedef enum {t_block,t_expr,t_operator,t_id,t_number,t_procedure,t_condition,t_odd,t_call,t_print} tNodeType;

// definition of the Node 
struct _tNode {
  tNodeType type;
  int num;
  char *id;
  char *op;
  struct _tNode *left , *right;
};

typedef struct _procedures{
	char *name;
	struct _tNode *node;
}procedure_block;

typedef struct tries{
        int data;
	int value;
	char c;
        struct tries *next[63];
}tries;

// struct _Node and tNode are identical
typedef struct _tNode tNode;
int variable[26];
procedure_block procedure_info[100];
int procedure_index;

