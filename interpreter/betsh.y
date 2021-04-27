%token END 0
%token FN 'fn' FOR 'for' SHADOW 'shadow' IDENTIFIER NUMCONST STRINGCONST
%token PL '(' PR ')' BL '[' BR ']' CL '{' CR '}'
%token AND '&&' OR '||' WC '*' EQ '='
%%

file: file statement
|     function
|     %empty;

andstatement: purestatement '&&' purestatement
orstatement:  purestatement '||' purestatement

purestatement: andstatement
|              orstatement
|              variableassignment

statement: purestatement ';' | '\n'
