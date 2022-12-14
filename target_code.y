%{
#include<stdio.h>
#include<stdlib.h>

void TargetCode();
char AddToTable(char ,char, char);
int ind=0;
char temp='0';
struct incod
{
    char opd1;
    char opd2;
    char opr;
};
%}

%union
{
    char sym;
}
%token <sym> LETTER NUMBER
%type <sym> E
%left '-' '+'
%left '*' '/'

%%
S: LETTER '=' E {AddToTable((char)$1,(char)$3,'=');}
| E
;

E: E '+' E {$$ = AddToTable((char)$1,(char)$3,'+');}
| E '-' E {$$ = AddToTable((char)$1,(char)$3,'-');}
| E '*' E {$$ = AddToTable((char)$1,(char)$3,'*');}
| E '/' E {$$ = AddToTable((char)$1,(char)$3,'/');}
| '(' E ')' {$$ = (char)$2;}
| NUMBER {$$ = (char)($1+17);}
| LETTER {$$ = AddToTable((char)$1,(char)$1,'$');} 
;
%%

int yyerror(char *s){
    //printf("Error in Input\n");
    return 1;
}

struct incod code[20];
int id=0;

char AddToTable(char opd1,char opd2,char opr){
    code[ind].opd1=opd1;
    code[ind].opd2=opd2;
    code[ind].opr=opr;
    ind++;
    temp++;
    return temp;
}

void PrintOpr(int cnt){
    if(isdigit(code[cnt].opd1))
        printf("R%c ", code[cnt].opd1); //Print Register Numbers
    else if(isalpha(code[cnt].opd1))
        printf("#%c ", code[cnt].opd1-17); //Print NUM - 17 added in grammar to check against isalpha()
    else printf("R%c ", temp);
    if(isdigit(code[cnt].opd2))
        printf("R%c ", code[cnt].opd2);
    else if(isalpha(code[cnt].opd2))
        printf("#%c ", code[cnt].opd2-17);
    else printf("R%c ", temp);
        printf("\n");
}

void TargetCode(){
    temp++;
    int cnt=0;
    printf("\n\n\t TARGET CODE\n\n");
    while(cnt<ind){

        switch(code[cnt].opr)
        {
            case '+': 
                    printf("ADD\tR%c ", temp);
                    PrintOpr(cnt);
                    break;
            case '-': 
                    printf("SUB\tR%c ", temp);
                    PrintOpr(cnt);
                    break;
            case '*': 
                    printf("MUL\tR%c ", temp);
                    PrintOpr(cnt);
                    break;
            case '/': 
                    printf("DIV\tR%c ", temp);
                    PrintOpr(cnt);
                    break;
            case '=': 
                    printf("STR\t%c R%c\n", code[cnt].opd1, temp-1); //Store into variable
                    break;
            case '$':
                    printf("LD\t"); //Load ID, $ added in grammar
                    printf("R%c %c\n", temp, code[cnt].opd1);
                    break;
        }
        temp++;
        cnt++;
    }
}

int main(){
    printf("\nEnter the Expression: ");
    yyparse();
    temp='0';
    TargetCode();
    printf("\n");
    return 0;
}

int yywrap(){
    return 1;
}

/* 
EXAMPLE OUTPUT
Enter the Expression: a=(b+c)*7


         TARGET CODE

LD      R1 b
LD      R2 c
ADD     R3 R1 R2
MUL     R4 R3 7
STR     a R4
*/
