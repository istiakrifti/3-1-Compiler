%option noyywrap

%x SINGLELINE_COMMENT_STATE
%x MULTILINE_COMMENT_STATE
%x SINGLELINE_STRING_STATE
%x MULTILINE_STRING_STATE

%{
#include "2005101_SymbolTable.cpp"

int line_count=1;
int startSingleLineCmnt;
int startMultiLineCmnt;
int stringCount;
int error_count=0;
int warning_count=0;
int tabRequired=0;
int currentTabCount=0;
int currentSpaceCount=0;
int flag=1;
string singleLineComment="";
string multiLineComment="";
string str="";
string tokenStr="";

FILE *logout;
FILE *tokenout;

SymbolTable smblTable(10);


char* toUpper(char *str)
{
	char *str1 = new char(strlen(str));
	for (int i = 0; str[i]; i++) 
	{
		str1[i] = toupper((unsigned char)str[i]);
	}
	return str1;
}

char convertToSpecialChar(char *str)
{
	char spChar;

	if(str[1]!='\\') spChar=str[1];
	else
	{
		if(str[2]=='n') spChar='\n';
		if(str[2]=='t') spChar='\t';
		if(str[2]=='a') spChar='\a';
		if(str[2]=='f') spChar='\f';
		if(str[2]=='r') spChar='\r';
		if(str[2]=='b') spChar='\b';
		if(str[2]=='v') spChar='\v';
		if(str[2]=='0') spChar='\0';
		if(str[2]=='\'') spChar='\'';
		if(str[2]=='\"') spChar='\"';
		if(str[2]=='\\') spChar='\\';
	}

	return spChar;
}

void indentation()
{
	if(currentSpaceCount!=0)
	{
		warning_count++;
		fprintf(logout,"Line# %d: Warning, tab requrired but got space.\n",line_count);	
	}
	else if(currentTabCount!=tabRequired)
	{
		warning_count++;
		fprintf(logout,"Line# %d: warning, %d of tabs needed but got %d tabs.\n",line_count,tabRequired,currentTabCount);
	}
	flag=0;
}


%}

SPACE [ ]
TAB [\t]
NEWLINE [\n]
LETTER [A-Za-z]
DIGIT [0-9]
CHAR [^\n\'\"\\]
SPECIALCHAR \\[\'\"nt\\afrbv0]
KEYWORD if|else|for|do|while|break|int|float|double|char|void|return|switch|case|default|continue
CONST_INT {DIGIT}+
CONST_FLOAT {DIGIT}*(\.{DIGIT}+)?(E[+-]?{DIGIT}+)?
ID (_|{LETTER})(_|{LETTER}|{DIGIT})* 
CONST_CHAR \'({CHAR}|{SPECIALCHAR})\'
ADDOP [+-]
MULOP [*/%]
INCOP "++"|"--"
RELOP "<"|"<="|">"|">="|"=="|"!="
ASSIGNOP [=]
LOGICOP "&&"|"||"
BITOP "&"|"|"|"^"|"<<"|">>"
NOT "!"
LPAREN "("
RPAREN ")"
LCURL "{"
RCURL "}"
LSQUARE "["
RSQUARE "]"
COMMA ","
SEMICOLON ";"
STARTSINGLELINECOMMET "\/\/"
STARTMULTILINECOMMENT "\/\*"
ENDMULTILINECOMMENT "\*\/"
STRING "\""
TOO_MANY_DECIMAL_POINTS {CONST_INT}(\.{CONST_INT}?{CONST_FLOAT}?)+
ILLFORMED_NUMBER {CONST_FLOAT}(\.{CONST_INT})+|{DIGIT}*(\.{DIGIT}+)?(E[+-]?\.{CONST_INT}+)
MULTICHAR_CONST_CHAR \'{CHAR}{CHAR}+\'
EMPTY_CONST_CHAR \'\'
UNFINISHED_CONST_CHAR \'({CHAR}?)|\'({SPECIALCHAR})|\'\\'
INVALID_ID_SUFFIX_NUM_PREFIX {CONST_INT}{ID}

%%

{SPACE} {
		if(flag==1)
		{
			currentSpaceCount++;
		}
				
}

{TAB} {
		if(flag==1)
		{
			currentTabCount++;
		}
		
}

{NEWLINE} {
		// printf("SPACE %d TAB %d\n",currentSpaceCount,currentTabCount);
		currentSpaceCount=0;
		currentTabCount=0;
		flag=1;
		line_count++;
	}

{KEYWORD} {
			char *s = yytext;
            char *str = toUpper(s);
            if(flag==1)
			{
				indentation();
			}
		    fprintf(tokenout,"<%s, %s>\n",str,yytext);
		    fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",line_count,str,yytext);
	    }

{CONST_INT} {
			if(flag==1)
			{
				indentation();
			}
		    fprintf(tokenout,"<CONST_INT, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);
			  
			}
{ID} {
		if(flag==1)
		{
			indentation();
		}
		fprintf(tokenout,"<ID, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <ID> Lexeme %s found\n",line_count,yytext);

		if(!smblTable.Insert(yytext,"ID")) 
		{
			fprintf(logout,"\t%s already exists in the current ScopeTable\n",yytext);
		}
		else
		{
			string table = smblTable.PrintAllScopeTable();
			fprintf(logout,"%s",table.c_str());
		}
		
	}				
{CONST_FLOAT} {
				if(flag==1)
				{
					indentation();
				}
			  	fprintf(tokenout,"<CONST_FLOAT, %s>\n",yytext);
		      	fprintf(logout,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
			}

{EMPTY_CONST_CHAR} {
		if(flag==1)
		{
			indentation();
		}
		error_count++;
		fprintf(logout,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
		flag=0;
}

{UNFINISHED_CONST_CHAR} {
		if(flag==1)
		{
			indentation();
		}

		error_count++;
	 	fprintf(logout,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_count,yytext);
		flag=0;
}

{CONST_CHAR} {
				if(flag==1)
				{
					indentation();
				}
				char sp = convertToSpecialChar(yytext);
				fprintf(tokenout,"<CONST_CHAR, %c>\n",sp);
		    	fprintf(logout,"Line# %d: Token <CONST_CHAR> Lexeme %c found\n",line_count,sp);
				
			}
{TOO_MANY_DECIMAL_POINTS} {

		if(flag==1)
		{
			indentation();
		}
		error_count++;
		fprintf(logout,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);
}

{ILLFORMED_NUMBER} {
		if(flag==1)
		{
			indentation();
		}
		error_count++;
		fprintf(logout,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
} 

{MULTICHAR_CONST_CHAR} {
		if(flag==1)
		{
			indentation();
		}
		error_count++;
		fprintf(logout,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_count,yytext);
}
{INVALID_ID_SUFFIX_NUM_PREFIX} {
		if(flag==1)
		{
			indentation();
		}
		error_count++;
	    fprintf(logout,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
}			 
{ADDOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<ADDOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_count,yytext);
		}
{MULOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<MULOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);
		
		}
{INCOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<INCOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);
		}
{BITOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<BITOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <BITOP> Lexeme %s found\n",line_count,yytext);
			
		}		
{RELOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<RELOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
			
		}
{ASSIGNOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<ASSIGNOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
		}
{LOGICOP} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<LOGICOP, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_count,yytext);
			
		}
{NOT} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<NOT, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <NOT> Lexeme %s found\n",line_count,yytext);
			
		}
{LPAREN} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<LPAREN, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_count,yytext);
			
		}
{RPAREN} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<RPAREN, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_count,yytext);
			
		}
{LCURL} {
			if(flag==1)
			{
				indentation();
			}
			tabRequired++;
			smblTable.EnterScope();
			fprintf(tokenout,"<LCURL, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <LCURL> Lexeme %s found\n",line_count,yytext);
			
		}
{RCURL} {
			tabRequired--;
			if(flag==1)
			{
				indentation();
			}
			
			smblTable.ExitScope();
			fprintf(tokenout,"<RCURL, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <RCURL> Lexeme %s found\n",line_count,yytext);
			
		}
{LSQUARE} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<LSQUARE, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_count,yytext);
			
		}
{RSQUARE} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<RSQUARE, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_count,yytext);
			
		}
{COMMA} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<COMMA, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <COMMA> Lexeme %s found\n",line_count,yytext);
			
		}
{SEMICOLON} {
			if(flag==1)
			{
				indentation();
			}
			fprintf(tokenout,"<SEMICOLON, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_count,yytext);
			
		}

{STARTSINGLELINECOMMET} {
			BEGIN SINGLELINE_COMMENT_STATE;
			startSingleLineCmnt=line_count;
			singleLineComment += yytext;
			if(flag==1)
			{
				indentation();
			}
		}	
<SINGLELINE_COMMENT_STATE>\\{NEWLINE} {
			singleLineComment += yytext;
			line_count++;
		}
<SINGLELINE_COMMENT_STATE>{NEWLINE} {
			line_count++;
			fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",startSingleLineCmnt,singleLineComment.c_str());
			BEGIN INITIAL;
			singleLineComment = "";
		}
<SINGLELINE_COMMENT_STATE>\\[^{NEWLINE}] {
			singleLineComment += yytext;
			BEGIN INITIAL;
}		
<SINGLELINE_COMMENT_STATE>. {
			singleLineComment += yytext;
		}
<SINGLELINE_COMMENT_STATE><<EOF>> {
			fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",startSingleLineCmnt,singleLineComment.c_str());
			singleLineComment="";
			BEGIN INITIAL;
		}

{STARTMULTILINECOMMENT} {
		BEGIN MULTILINE_COMMENT_STATE;
		startMultiLineCmnt=line_count;
		multiLineComment += yytext;
		if(flag==1)
		{
			indentation();
		}
}

<MULTILINE_COMMENT_STATE>{ENDMULTILINECOMMENT} {
		BEGIN INITIAL;
		multiLineComment +=yytext;
		fprintf(logout,"Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n",startMultiLineCmnt,multiLineComment.c_str());
		multiLineComment="";
		BEGIN INITIAL;
} 

<MULTILINE_COMMENT_STATE>{NEWLINE} {
		line_count++;
		multiLineComment +=yytext;
}

<MULTILINE_COMMENT_STATE>. {
		multiLineComment +=yytext;
}

<MULTILINE_COMMENT_STATE><<EOF>> {
			error_count++;
			fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,multiLineComment.c_str());
			multiLineComment="";
			BEGIN INITIAL;
		}

{STRING} {
		BEGIN SINGLELINE_STRING_STATE;
		stringCount=line_count;
		str += yytext;
		if(flag==1)
		{
			indentation();
		}

}

<SINGLELINE_STRING_STATE>{STRING} {
		str +=yytext;
		fprintf(tokenout,"<SINGLE LINE STRING, %s>\n",tokenStr.c_str());
		fprintf(logout,"Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n",stringCount,str.c_str());
		str="";
		tokenStr="";
		BEGIN INITIAL;
}

<SINGLELINE_STRING_STATE>{SPECIALCHAR} {
		char *st = new char(strlen(yytext)+3);
		st[0] = '\'';
		strcpy(st+1,yytext);
		st[strlen(yytext)+1] = '\'';
		st[strlen(yytext)+2] = '\0';		
		char ch = convertToSpecialChar(st);
		str += yytext;
		tokenStr += ch;
		
}

<SINGLELINE_STRING_STATE>{NEWLINE} {
	line_count++;
	BEGIN INITIAL;
	error_count++;
	fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",stringCount,str.c_str());
	str="";
	tokenStr="";
}


<SINGLELINE_STRING_STATE>. {
		str +=yytext;
		tokenStr +=yytext;
}

<SINGLELINE_STRING_STATE>\\{NEWLINE} {
	line_count++;
	BEGIN MULTILINE_STRING_STATE;
	str += yytext;
}

<SINGLELINE_STRING_STATE><<EOF>> {
		error_count++;
		fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",stringCount,str.c_str());
		str="";
		tokenStr="";
		BEGIN INITIAL;
}

<MULTILINE_STRING_STATE>{STRING} {
		str +=yytext;
		fprintf(tokenout,"<MULTI LINE STRING, %s>\n",tokenStr.c_str());
		fprintf(logout,"Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n",stringCount,str.c_str());
		str="";
		tokenStr="";
		BEGIN INITIAL;
} 

<MULTILINE_STRING_STATE>{SPECIALCHAR} {
		char *st = new char(strlen(yytext)+3);
		st[0] = '\'';
		strcpy(st+1,yytext);
		st[strlen(yytext)+1] = '\'';
		st[strlen(yytext)+2] = '\0';		
		char ch = convertToSpecialChar(st);
		str += yytext;
		tokenStr += ch;		
}

<MULTILINE_STRING_STATE>{NEWLINE} {
	BEGIN INITIAL;
	error_count++;
	fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count,str.c_str());
	line_count++;
	str="";
	tokenStr="";
}

<MULTILINE_STRING_STATE>\\{NEWLINE} {
	line_count++;
	str += yytext;
}

<MULTILINE_STRING_STATE>. {
		str +=yytext;
		tokenStr +=yytext;
}

<MULTILINE_STRING_STATE><<EOF>> {
		error_count++;
		fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count,str.c_str());
		str="";
		tokenStr="";
		BEGIN INITIAL;
}

. {
		if(flag==1)
		{
			indentation();
		}
		error_count++;
	 	fprintf(logout,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_count,yytext);
}

 

<<EOF>> {
	string table = smblTable.PrintAllScopeTable();
	fprintf(logout,"%s",table.c_str());
	fprintf(logout,"Total lines: %d\n",line_count);
	fprintf(logout,"Total errors: %d\n",error_count);
	fprintf(logout,"Total warnings: %d\n",warning_count);

	return 0;
}

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}