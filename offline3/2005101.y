
%{
#include<bits/stdc++.h>
#include"2005101.cpp"
using namespace std;

int yyparse(void);
int yylex(void);
extern int yylineno;
extern FILE *yyin;
FILE *fp,*logout,*errorout,*parseout;
int error_count = 0;
void yyerror(char *s){}

SymbolTable table(11);

string varType;
int currentValue = -1;
int errorLine = -1;

vector<pair<SymbolInfo*, SymbolInfo*> > param;
vector<SymbolInfo*> varList;
vector<SymbolInfo*> argList;
    

   
bool checkVariable(SymbolInfo *symbol)
{
    if(symbol->getVarOrFunc() == "variable")
    {
        return true;
    }
    return false;
}

bool isFunction_declaration(SymbolInfo *symbol)
{
    if(symbol->getVarOrFunc()=="func_declaration")
    {
        return true;
    }
    return false;
}


void PrintParse(SymbolInfo* info, int space){

	for(int i=0;i<space;i++) fprintf(parseout," ");
	if(info->getChildList().size()==0)
	{
		fprintf(parseout,"%s : %s\t<Line: %d>\n",info->getType().c_str(),info->getName().c_str(),info->getStart());
		return;
	}
	else
	{
		fprintf(parseout,"%s : %s\t<Line: %d-%d >\n",info->getType().c_str(),info->getName().c_str(),info->getStart(),info->getEnd());
	} 

	vector<SymbolInfo*> ch= info->getChildList();

	for(int i=0;i<ch.size();i++)
	{
		PrintParse(ch[i],(space+1));
	}              
} 


%}

%union{
    SymbolInfo* symbol;
}

%token <symbol> IF ELSE FOR WHILE INT FLOAT VOID RETURN
%token <symbol> INCOP DECOP ASSIGNOP NOT ADDOP MULOP RELOP LOGICOP CONST_INT CONST_FLOAT ID LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON
%type <symbol> start program unit func_declaration func_definition parameter_list compound_statement var_declaration type_specifier declaration_list statements statement expression_statement variable expression logic_expression rel_expression simple_expression term unary_expression factor argument_list arguments

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%  

start : program 
        {
            fprintf(logout,"start : program\n");
			$$ = new SymbolInfo("program","start");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
			PrintParse($$,0);
			fprintf(logout,"Total Lines: %d\n",yylineno);
			fprintf(logout,"Total Errors: %d\n",error_count);
        }
        ;
program : program unit  
        {
            $$ = new SymbolInfo("program unit","program");
			fprintf(logout,"program : program unit\n");
			$$->setStart($1->getStart());
			$$->setEnd($2->getEnd());
			$$->addChild($1);
			$$->addChild($2);

        }  
        | unit  
        {
            $$=new SymbolInfo("unit","program");
			fprintf(logout,"program : unit\n");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
        }
        ;
unit : var_declaration  
        {
            $$=new SymbolInfo("var_declaration","unit");
            fprintf(logout,"unit : var_declaration\n");
            $$->setStart($1->getStart());
            $$->setEnd($1->getEnd());
            $$->addChild($1);
        }
        | func_declaration  
        {
            fprintf(logout,"unit : func_declaration\n");
            $$ = new SymbolInfo("func_declaration","unit");
            $$->setStart($1->getStart());
            $$->setEnd($1->getEnd());
            $$->addChild($1);
        }
        | func_definition   
        {
            fprintf(logout,"unit : func_definition\n");
            $$ = new SymbolInfo("func_definition","unit");
            $$->setStart($1->getStart());
            $$->setEnd($1->getEnd());
            $$->addChild($1);
        }
        ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON 
                {
                     fprintf(logout,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");
					 $$ = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON","func_declaration");
					 $$->setStart($1->getStart());
					 $$->setEnd($6->getEnd());
					 $$->addChild($1);
					 $$->addChild($2);
					 $$->addChild($3);
					 $$->addChild($4);
					 $$->addChild($5);
					 $$->addChild($6);
					 
					 string funcName = $2->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						SymbolInfo *info = new SymbolInfo($2->getName(),$2->getType());
						info->setStart($1->getStart());
						info->setEnd($6->getEnd());
						info->setDataType($1->getDataType());
						info->setVarOrFunc($$->getType());
						for(int i=0;i<param.size();i++)
						{
							info->setParameter(param[i]);
						}
						
						table.Insert(info);
					 } 
					 else
					 {
						if(checkVariable(temp)){
							error_count++;
							fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of '%s' function",$2->getStart(),temp->getName().c_str());
						}
					 }
					 
					 param.clear();
                }
                | type_specifier ID LPAREN RPAREN SEMICOLON 
                {
                     fprintf(logout,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n");
					 $$ = new SymbolInfo("type_specifier ID LPAREN RPAREN SEMICOLON","func_declaration");
					 $$->setStart($1->getStart());
					 $$->setEnd($5->getEnd());
					 $$->addChild($1);
					 $$->addChild($2);
					 $$->addChild($3);
					 $$->addChild($4);
					 $$->addChild($5);
					 
					 string funcName = $2->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						SymbolInfo *info = new SymbolInfo($2->getName(),$2->getType());
						info->setStart($1->getStart());
						info->setEnd($5->getEnd());
						info->setDataType($1->getDataType());
						info->setVarOrFunc($$->getType());
						table.Insert(info);
						$2->isDec = true;
					 } 
					 else
					 {
						if(checkVariable(temp)){
							error_count++;
							fprintf(errorout,"Line# %d : %s redeclared as different kind of symbol",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of %s function",$2->getStart(),temp->getName().c_str());
							
						}
					 }
                }
                ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN {
	SymbolInfo* info=new SymbolInfo($2->getName(), $2->getType());
    info->setStart($1->getStart());
    info->setEnd($2->getEnd());
    info->setDataType($1->getDataType());
    info->setVarOrFunc("func_definition");

    for(int i=0;i<param.size();i++)
    {
		info->setParameter(param[i]);
	}

    string fname = $2->getName();
    SymbolInfo* temp=table.LookUp(fname);
        if(temp==0)
        {
			$2->isDec = true; 
            table.Insert(info);
			$2->isDef = true;
			$2->isDec = false;
        }
        else
        {

            if(checkVariable(temp))
            {
                error_count++;
                fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",$2->getStart(),temp->getName().c_str());
            }    
            else
            {

                if(isFunction_declaration(temp))
                {
                    vector<pair<SymbolInfo*, SymbolInfo*> > pt = temp->getParameter();
                    
                    bool flag=true;
                    if(temp->getDataType() != $1->getDataType())
                    {
                        flag=false;
                        error_count++;
                        fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
                    }        
                    else if(pt.size()!=param.size()){

                        flag=false;        
                        error_count++;
                        fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());          
                    }
                    else
                    {
                            for(int i=0;i<param.size();i++)
                            {

                                if((param[i].first)->getType() != (pt[i].first)->getType())
                                {
                                    flag=false;
                                    error_count++;
                                    fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());			
                                    break;
                                }
                            }
                    }

                    if(flag) table.Insert(info);

                }
                else
                {
                    error_count++;
                    fprintf(errorout,"Line# %d : Redefinition of function '%s'\n",$1->getStart(),temp->getName().c_str());
                }
                }

            }
	} compound_statement 
                {
                    fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
                    $$ = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN compound_statement","func_definition");
                    $$->setStart($1->getStart());
                    $$->setEnd($7->getEnd());
                    $$->addChild($1);
                    $$->addChild($2);
                    $$->addChild($3);
                    $$->addChild($4);
                    $$->addChild($5);
                    $$->addChild($7);				 

                }
                | type_specifier ID LPAREN RPAREN {
				
					SymbolInfo* info=new SymbolInfo($2->getName(), $2->getType());
					info->setStart($1->getStart());
					info->setEnd($2->getEnd());
					info->setDataType($1->getDataType());
					info->setVarOrFunc("func_definition");

					for(int i=0;i<param.size();i++)
					{
						info->setParameter(param[i]);
					}
					string fname = $2->getName();
					SymbolInfo* temp=table.LookUp(fname);
						if(temp==0)
						{
							table.Insert(info);
							$2->isDef = true;
							$2->isDec = false;
						}
						else
						{

							if(checkVariable(temp))
							{
								error_count++;
								fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",$2->getStart(),temp->getName().c_str());
							}
							else
							{

								if(isFunction_declaration(temp))
								{
									
									bool flag=true;
									if(temp->getDataType() != $1->getDataType())
									{
										flag=false;
										error_count++;
										fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
									}

									if(flag) table.Insert(info);

								}
								else
								{
									error_count++;
									fprintf(errorout,"Line# %d : Redefinition of function '%s'\n",$1->getStart(),temp->getName().c_str());
								}
							}

						}
					} compound_statement
                {
                     fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");
					 $$ = new SymbolInfo("type_specifier ID LPAREN RPAREN compound_statement","func_definition");
					 $$->setStart($1->getStart());
					 $$->setEnd($6->getEnd());
					 $$->addChild($1);
					 $$->addChild($2);
					 $$->addChild($3);
					 $$->addChild($4);
					 $$->addChild($6);	
                }
                | type_specifier ID LPAREN error {  
                                                if(errorLine == -1)                                         
                                                {
                                                    errorLine = yylineno;
                                                    error_count++;
                                                    fprintf(errorout,"Line# %d : Syntax error at parameter list of function definition\n",$3->getStart());
                                                    fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
                                                    param.clear();
                                                }} RPAREN {errorLine = -1;} compound_statement {
                    fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
					 $$ = new SymbolInfo("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement","func_definition");
					 $$->setStart($1->getStart());
					 $$->setEnd($8->getEnd());
					 SymbolInfo *info = new SymbolInfo("error","parameter_list");
					 info->setStart($3->getStart());
					 info->setEnd($6->getEnd());
					 $$->addChild($1);
					 $$->addChild($2);
					 $$->addChild($3);
					 $$->addChild(info);
					 $$->addChild($6);
					 $$->addChild($8);	
					 errorLine = -1;

                }
                ;       
parameter_list : parameter_list COMMA type_specifier ID 
               {
                    fprintf(logout,"parameter_list : parameter_list COMMA type_specifier ID\n");
					$$ = new SymbolInfo("parameter_list COMMA type_specifier ID", "parameter_list");
					$$->setStart($1->getStart());
					$$->setEnd($4->getEnd());
					$$->addChild($1);
					$$->addChild($2);
					$$->addChild($3);
					$$->addChild($4);

					vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
					for(int i=0;i<pt.size();i++)
					{
						$$->setParameter(pt[i]);
					}
								
					$$->setParameter({$3,$4});
					param.push_back({$3,$4}); 
					$4->setDataType($3->getDataType());
           

                }
                | parameter_list COMMA type_specifier  
                {
                    fprintf(logout,"parameter_list : parameter_list COMMA type_specifier\n");
					$$ = new SymbolInfo("parameter_list COMMA type_specifier", "parameter_list");
					$$->setStart($1->getStart());
					$$->setEnd($3->getEnd());
					$$->addChild($1);
					$$->addChild($2);
					$$->addChild($3);

					vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
					for(int i=0;i<pt.size();i++)
					{
						$$->setParameter(pt[i]);
					}
							 
					SymbolInfo *info = new SymbolInfo("","");
					info->setStart($3->getStart());
					info->setEnd($3->getEnd());
					info->setDataType($3->getDataType());
					$$->setParameter({$3,info});
					param.push_back({$3,info});

                }
                | type_specifier ID 
                {
                    fprintf(logout,"parameter_list : type_specifier ID\n");
					$$ = new SymbolInfo("type_specifier ID", "parameter_list");
					$$->setStart($1->getStart());
					$$->setEnd($2->getEnd());
					$$->addChild($1);
					$$->addChild($2);
					$$->setParameter({$1,$2});
					param.push_back({$1,$2}); 
					$2->setDataType($1->getDataType());
    
                }
                | type_specifier   
                {
                    fprintf(logout,"parameter_list : type_specifier\n");
					$$ = new SymbolInfo("type_specifier", "parameter_list");
					$$->setStart($1->getStart());
					$$->setEnd($1->getEnd());
					$$->addChild($1);
					SymbolInfo *info = new SymbolInfo("","");
					info->setStart($1->getStart());
					info->setEnd($1->getEnd());
					info->setDataType($1->getDataType());
					$$->setParameter({$1,info});
					param.push_back({$1,info});
                }
                ;
compound_statement : LCURL {
	
			table.EnterScope();
			
			if(param.size() != 0)
			{
				for(int i=0;i<param.size();i++)
				{   
					pair<SymbolInfo*,SymbolInfo*> tem1 = param[i];
					SymbolInfo* tmp2 = new SymbolInfo(tem1.second->getName(), tem1.second->getType());
					tmp2->setStart(tem1.first->getStart());
					tmp2->setEnd(tem1.second->getEnd());
					tmp2->setDataType(tem1.second->getDataType());

					string nam = tmp2->getName();
					SymbolInfo* info = table.getCurrentScope()->LookUp(nam);
					if(info==0)
					{
						table.Insert(tmp2);
					}
					else
					{
						error_count++;
						fprintf(errorout,"Line# %d : Redefinition of parameter '%s'\n",tmp2->getStart(),tmp2->getName().c_str());
					}

				}
				param.clear();
			}
	} statements RCURL 
                   {
                        fprintf(logout,"compound_statement : LCURL statements RCURL\n");
						$$ = new SymbolInfo("LCURL statements RCURL", "compound_statement");
						$$->setStart($1->getStart());
						$$->setEnd($4->getEnd());
						$$->addChild($1);
						$$->addChild($3);
						$$->addChild($4);
						
						string str = table.PrintAllScopeTable();
						fprintf(logout,"%s",str.c_str());
						
						table.ExitScope();
                    }
                    | LCURL {
						
						table.EnterScope();
						
						if(param.size() != 0)
						{
							for(int i=0;i<param.size();i++)
							{   
								pair<SymbolInfo*,SymbolInfo*> tem1 = param[i];
								SymbolInfo* tmp2 = new SymbolInfo(tem1.second->getName(), tem1.second->getType());
								tmp2->setStart(tem1.first->getStart());
								tmp2->setEnd(tem1.second->getEnd());
								tmp2->setDataType(tem1.second->getDataType());

								string nam = tmp2->getName();
								SymbolInfo* info = table.getCurrentScope()->LookUp(nam);
								if(info==0)
								{
									table.Insert(tmp2);
								}
								else
								{
									error_count++;
									fprintf(errorout,"Line# %d : Redefinition of parameter '%s'\n",tmp2->getStart(),tmp2->getName().c_str());
								}

							}
							param.clear();
						}
						} RCURL  
                    {
                        fprintf(logout,"compound_statement : LCURLstatements RCURL\n");
						$$ = new SymbolInfo("LCURL statements RCURL", "compound_statement");
						$$->setStart($1->getStart());
						$$->setEnd($3->getEnd());
						$$->addChild($1);
						$$->addChild($3);
						string str = table.PrintAllScopeTable();
						fprintf(logout,"%s",str.c_str());
						table.ExitScope();
                    }
                    ;
var_declaration : type_specifier declaration_list SEMICOLON 
                {
                        fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n");
						$$ = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration");
						$$->setStart($1->getStart());
						$$->setEnd($3->getEnd());
						$$->addChild($1);
						$$->addChild($2);
						$$->addChild($3);

						for(int i=0;i<varList.size();i++)
						{

							SymbolInfo *info = varList[i];
							
							if(varType=="VOID")
							{
								fprintf(errorout,"Line# %d : Variable or field '%s' declared void\n",info->getStart(),info->getName().c_str());
								error_count++;
							}
							else 
							{
								info->setDataType(varType);

								SymbolInfo *sym = table.getCurrentScope()->LookUp(info->getName());
								if(sym!=0)
								{
									if(sym->getDataType()==info->getDataType() && sym->getVarOrFunc()==info->getVarOrFunc())
									{
										fprintf(errorout,"Redeclaration of variable '%s'\n",info->getName().c_str());
										error_count++;
									}
									else if(sym->getDataType()!=info->getDataType())
									{
										fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",info->getStart(),info->getName().c_str());
										error_count++;	
									}
									else if(sym->getVarOrFunc()!=info->getVarOrFunc())
									{
										fprintf(errorout,"Line# %d : %s redeclared as different kind of symbol\n",info->getStart(),info->getName().c_str());
										error_count++;	
									}

								}
								else 
								{
									// fprintf(logout,"%s ghg %d hhhj %s\n",info->getName().c_str(),info->getChildCount(),info->getType().c_str());
									table.Insert(info);
								}
							}
						}
						varList.clear();
						varType="";
        }
        | type_specifier error {
                                if(errorLine == -1)
                                {
                                    errorLine = yylineno;
                                    fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
                                }} SEMICOLON
                {

                    error_count++;
					fprintf(errorout,"Line# %d : Syntax error at declaration list of variable declaration\n",errorLine);
					fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n");
					$$ = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration");
					$$->setStart($1->getStart());
					$$->setEnd($4->getEnd());
					SymbolInfo *info = new SymbolInfo("error","declaration_list");
					info->setStart(errorLine);
					info->setEnd(errorLine);
					$$->addChild($1); 
					$$->addChild(info); 
					$$->addChild($4); 
					errorLine = -1;
					varList.clear();
					varType="";
                }
                ;
type_specifier : INT    
               {
                    fprintf(logout,"type_specifier : INT\n");
					$$ = new SymbolInfo("INT", "type_specifier");
					$$->setStart($1->getStart());
					$$->setEnd($1->getEnd());
					$$->addChild($1); 
					$$->setDataType("INT");
					varType = "INT";

                }
                | FLOAT 
                {
                    fprintf(logout,"type_specifier : FLOAT\n");
					$$ = new SymbolInfo("FLOAT", "type_specifier");
					$$->setStart($1->getStart());
					$$->setEnd($1->getEnd());
					$$->addChild($1); 
					$$->setDataType("FLOAT");
					varType = "FLOAT";

                }
                | VOID  
                {
                    fprintf(logout,"type_specifier : VOID\n");
					$$ = new SymbolInfo("VOID", "type_specifier");
					$$->setStart($1->getStart());
					$$->setEnd($1->getEnd());
					$$->addChild($1); 
					$$->setDataType("VOID");
					varType = "VOID";
                }
                ;
declaration_list : declaration_list COMMA ID    
                {
                    fprintf(logout,"declaration_list : declaration_list COMMA ID\n");
					$$ = new SymbolInfo("declaration_list COMMA ID", "declaration_list");
					$$->setStart($1->getStart());
					$$->setEnd($3->getEnd());
					$$->addChild($1); 
					$$->addChild($2);
					$$->addChild($3);
					varList.push_back($3);

            }
            | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE   
            {
                fprintf(logout,"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n");
				$$ = new SymbolInfo("declaration_list COMMA ID LTHIRD CONST_INT RTHIRD", "declaration_list");
				$$->setStart($1->getStart());
				$$->setEnd($6->getEnd());
				$$->addChild($1); 
				$$->addChild($2); 
				$$->addChild($3); 
				$$->addChild($4); 
				$$->addChild($5);
				$$->addChild($6);
				varList.push_back($3);
				$3->setArraySize($5->getName());
            }
            | ID    
            {
                fprintf(logout,"declaration_list : ID\n");
				$$ = new SymbolInfo("ID", "declaration_list");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1); 		
				varList.push_back($1);
                
            }
            | ID LSQUARE CONST_INT RSQUARE  
            {
                fprintf(logout,"declaration_list : ID LTHIRD CONST_INT RTHIRD\n");
				$$ = new SymbolInfo("ID LTHIRD CONST_INT RTHIRD", "declaration_list");
				$$->setStart($1->getStart());
                $$->setEnd($4->getEnd());
                $$->addChild($1); 
                $$->addChild($2); 
                $$->addChild($3); 
				$$->addChild($4); 
				varList.push_back($1);
				$1->setArraySize($3->getName());						
            }
            ;


statements : statement 
            {
                fprintf(logout,"statements : statement\n");
				$$ = new SymbolInfo("statement", "statements");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);

            }
            | statements statement  
            {
                fprintf(logout,"statements : statements statement\n");
				$$ = new SymbolInfo("statements statement", "statements");
				$$->setStart($1->getStart());
				$$->setEnd($2->getEnd());
				$$->addChild($1);
				$$->addChild($2);
            }
            ;

statement : var_declaration 
          {
                fprintf(logout,"statement : var_declaration\n");
				$$ = new SymbolInfo("var_declaration", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);
         }
         | expression_statement  
         {
                fprintf(logout,"statement : expression_statement\n");
				$$ = new SymbolInfo("expression_statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);

         }
         | compound_statement   
         {
                fprintf(logout,"statement : compound_statement\n");
				$$ = new SymbolInfo("compound_statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);
         }
         | FOR LPAREN expression_statement expression_statement expression RPAREN statement 
         {
                fprintf(logout,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
				$$ = new SymbolInfo("FOR LPAREN expression_statement expression_statement expression RPAREN statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($7->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);
				$$->addChild($5);
				$$->addChild($6);
				$$->addChild($7);

        }
        | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
        {
                fprintf(logout,"statement : IF LPAREN expression RPAREN statement\n");
				$$ = new SymbolInfo("IF LPAREN expression RPAREN statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($5->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);
				$$->addChild($5);

        }
        | IF LPAREN expression RPAREN statement ELSE statement  {
                fprintf(logout,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
				$$ = new SymbolInfo("IF LPAREN expression RPAREN statement ELSE statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($7->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);
				$$->addChild($5);
				$$->addChild($6);
				$$->addChild($7);

        }
        | WHILE LPAREN expression RPAREN statement  
        {
                fprintf(logout,"statement : WHILE LPAREN expression RPAREN statement\n");
				$$ = new SymbolInfo("WHILE LPAREN expression RPAREN statement", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($5->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);
				$$->addChild($5);
        }
        | RETURN expression SEMICOLON   
        {
                fprintf(logout,"statement : RETURN expression SEMICOLON\n");
				$$ = new SymbolInfo("RETURN expression SEMICOLON", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($3->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
        }
        ;


expression_statement : SEMICOLON   
        {
            fprintf(logout,"expression_statement : SEMICOLON\n");
			$$ = new SymbolInfo("SEMICOLON", "expression_statement");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
        }
        | expression SEMICOLON  
        {
            fprintf(logout,"expression_statement : expression SEMICOLON\n");
			$$ = new SymbolInfo("expression SEMICOLON", "expression_statement");
			$$->setStart($1->getStart());
			$$->setEnd($2->getEnd());
			$$->addChild($1);
			$$->addChild($2);
        }
        | error {if(errorLine == -1) errorLine = yylineno;} SEMICOLON   
        {

            error_count++;
			fprintf(logout,"expression_statement : expression SEMICOLON\n");
			fprintf(errorout,"Line# %d: Syntax error at expression of expression statement\n",errorLine);
			$$ = new SymbolInfo("expression SEMICOLON", "expression_statement");
			$$->setStart($3->getStart());
			$$->setEnd($3->getStart());
			SymbolInfo *info = new SymbolInfo("error","expression");
			$$->setStart(errorLine);
			$$->setEnd(errorLine);
			$$->addChild(info);
			$$->addChild($3);
			errorLine = -1;
        }
        ;
variable : ID  
         {
                fprintf(logout,"variable : ID\n");
				$$ = new SymbolInfo("ID", "variable");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);

				SymbolInfo *info = table.LookUp($1->getName());

				if(info==0)
				{
					fprintf(errorout,"Line# %d : Undeclared variable '%s'\n",$1->getStart(),$1->getName().c_str());
					error_count++;
				}
				else 
				{
					$1->setDataType(info->getDataType());
					$1->setArraySize(info->getArraySize());
				}

				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i]);
				}

        }
        | ID LSQUARE expression RSQUARE 
        {
                fprintf(logout,"variable : ID LTHIRD expression RTHIRD\n");
				$$ = new SymbolInfo("ID LTHIRD expression RTHIRD", "variable");
				$$->setStart($1->getStart());
				$$->setEnd($4->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);

				SymbolInfo *info = table.LookUp($1->getName());

				if(info==0)
				{
					fprintf(errorout,"Line# %d : Undeclared variable '%s'\n",$1->getStart(),$1->getName().c_str());
					error_count++;
				}
				else 
				{
					$1->setDataType(info->getDataType());
                	$1->setArraySize(info->getArraySize());
					if(info->isArray()==false)
					{
						fprintf(errorout,"Line# %d : '%s' is not an array\n",$1->getStart(),$1->getName().c_str());
						error_count++;
					}
					if($3->getDataType() != "INT")
					{
						error_count++;
						fprintf(errorout,"Line# %d : Array subscript is not an integer\n",$1->getStart(),$1->getName().c_str());
            		}
				}

				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					$$->setParameter(pt[i]);
				}

        }
        ;


expression : logic_expression  
            {
                fprintf(logout,"expression : logic_expression\n");
				$$ = new SymbolInfo("logic_expression", "expression");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);
				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					$$->setParameter(pt[i]);
			    }

            }
            | variable ASSIGNOP logic_expression    
            {
                fprintf(logout,"expression : variable ASSIGNOP logic_expression\n");
				$$ = new SymbolInfo("variable ASSIGNOP logic_expression", "expression");
				$$->setStart($1->getStart());
				$$->setEnd($3->getEnd());
				$$->addChild($1); 
				$$->addChild($2);
				$$->addChild($3);

				if($3->getDataType()=="VOID")
				{
					fprintf(errorout,"Line# %d : Void cannot be used in expression\n",$1->getStart());
					error_count++;
				}
				else if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT")
				{
					error_count++;
					fprintf(errorout,"Line# %d : Warning: possible loss of data in assignment of FLOAT to INT\n",$1->getStart());
				}

				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					$$->setParameter(pt[i]);
				}

            }
            ;
logic_expression : rel_expression   
        {
            fprintf(logout,"logic_expression : rel_expression\n");
			$$ = new SymbolInfo("rel_expression", "logic_expression");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
			$$->setDataType($1->getDataType());
	    	$$->setArraySize($1->getArraySize());
			$$->setVarOrFunc($1->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				$$->setParameter(pt[i]);
			}	

        }
        | rel_expression LOGICOP rel_expression 
        {
            fprintf(logout,"logic_expression : rel_expression LOGICOP rel_expression\n");
			$$ = new SymbolInfo("rel_expression LOGICOP rel_expression", "logic_expression");
			$$->setStart($1->getStart());
			$$->setEnd($3->getEnd());
			$$->addChild($1); 
			$$->addChild($2);
			$$->addChild($3);
			$$->setDataType("INT");

        }
        ;
rel_expression : simple_expression  
        {
            fprintf(logout,"rel_expression : simple_expression\n");
			$$ = new SymbolInfo("simple_expression", "rel_expression");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
			$$->setDataType($1->getDataType());
			$$->setArraySize($1->getArraySize());
			$$->setVarOrFunc($1->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				$$->setParameter(pt[i]);
			}

        }
        | simple_expression RELOP simple_expression 
        {
            fprintf(logout,"rel_expression : simple_expression RELOP simple_expression\n");
			$$ = new SymbolInfo("simple_expression RELOP simple_expression", "rel_expression");
			$$->setStart($1->getStart());
			$$->setEnd($3->getEnd());
			$$->addChild($1);
			$$->addChild($2);
			$$->addChild($3);

			if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT")
			{
				$1->setDataType("FLOAT");
			}
			else if($1->getDataType() == "FLOAT" && $3->getDataType() =="INT")
			{
				$3->setDataType("FLOAT");
			}
            $$->setDataType("INT");

        }
        ;

simple_expression : term   
        {
            fprintf(logout,"simple_expression : term\n");
			$$ = new SymbolInfo("term", "simple_expression");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
			$$->setDataType($1->getDataType());
			$$->setArraySize($1->getArraySize());
			$$->setVarOrFunc($1->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				$$->setParameter(pt[i]);
			}
			currentValue = -1;
        }
        | simple_expression ADDOP term  
                    {
                        fprintf(logout,"simple_expression : simple_expression ADDOP term\n");
						$$ = new SymbolInfo("simple_expression ADDOP term", "simple_expression");
						$$->setStart($1->getStart());
						$$->setEnd($3->getEnd());
						$$->addChild($1);
						$$->addChild($2);
						$$->addChild($3);

						currentValue=-1;
						
						if($1->getDataType()=="VOID"|| $3->getDataType()=="VOID")
						{
							fprintf(errorout,"Line# %d : Void cannot be used in expression\n",$1->getStart());
							error_count++;
						}

						if($1->getDataType() == $3->getDataType())
						{
								$$->setDataType($1->getDataType());
						}
						else if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT")
						{
							$1->setDataType("FLOAT");
							$$->setDataType("FLOAT");
						}
						else if($3->getDataType() == "INT" && $1->getDataType() == "FLOAT")
						{
							$3->setDataType("FLOAT");
							$$->setDataType("FLOAT");
						}
						else if($1->getDataType() != "VOID")
						{
							$$->setDataType($1->getDataType());
						}
						else
						{
							$$->setDataType($3->getDataType());
						}
                    }
                    ;
term : unary_expression 
        {
            fprintf(logout,"term : unary_expression\n");
            $$ = new SymbolInfo("unary_expression", "term");
            $$->setStart($1->getStart());
            $$->setEnd($1->getEnd());
            $$->addChild($1);
            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVarOrFunc($1->getVarOrFunc());
            vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
            for(int i=0;i<pt.size();i++)
            {
                $$->setParameter(pt[i]);
            }
            currentValue = -1;

        }
        | term MULOP unary_expression   
        {
            fprintf(logout,"term : term MULOP unary_expression\n");
            $$ = new SymbolInfo("term MULOP unary_expression", "term");
            $$->setStart($1->getStart());
            $$->setEnd($3->getEnd());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            if($1->getDataType()=="VOID"||$3->getDataType()=="VOID")
            {
                fprintf(errorout,"Line# %d : Void cannot be used in expression\n",$1->getStart());
                error_count++;
            }

            if($2->getName()=="%") 
            {
                if($1->getDataType()!="INT"||$3->getDataType()!="INT")
                {
                    fprintf(errorout,"Line# %d : Operands of modulus must be integers\n",$1->getStart());
                    error_count++;
                }

                if(currentValue==0)
                {
                    fprintf(errorout,"Line# %d : Warning: division by zero i=0f=1Const=0\n",$1->getStart());
                    error_count++;
                }

                $1->setDataType("INT");
                $3->setDataType("INT");
            }

            if($2->getName()=="/")
            {
                if(currentValue==0)
                {
                    fprintf(errorout,"Line# %d : Warning: division by zero i=0f=1Const=0\n",$1->getStart());
                    error_count++;
                }
            }

            if($1->getDataType() == $3->getDataType())
            {
                    $$->setDataType($1->getDataType());
            }
            else if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT")
            {
                $1->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }
            else if($3->getDataType() == "INT" && $1->getDataType() == "FLOAT")
            {
                $3->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }
            else if($1->getDataType()!="VOID")
            {
                $$->setDataType($1->getDataType());
            }
            else
            {
                $$->setDataType($3->getDataType());
            }

        }
        ;
unary_expression : ADDOP unary_expression   
                {
                    fprintf(logout,"unary_expression : ADDOP unary_expression\n");
					$$ = new SymbolInfo("ADDOP unary_expression", "unary_expression");
					$$->setStart($1->getStart());
					$$->setEnd($2->getEnd());
					$$->addChild($1);
					$$->addChild($2);
					currentValue = -1;
					$$->setDataType($2->getDataType());
					$$->setArraySize($2->getArraySize());
					$$->setVarOrFunc($2->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = $2->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						$$->setParameter(pt[i]);
					}

                }
                | NOT unary_expression  
                {
                    fprintf(logout,"unary_expression : NOT unary_expression\n");
					$$ = new SymbolInfo("NOT unary_expression", "unary_expression");
					$$->setStart($1->getStart());
					$$->setEnd($2->getEnd());
					$$->addChild($1);
					$$->addChild($2);
					currentValue = -1;
					$$->setDataType($2->getDataType());
					$$->setArraySize($2->getArraySize());
					$$->setVarOrFunc($2->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = $2->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						$$->setParameter(pt[i]);
					}

                }
                | factor 
                {
                    fprintf(logout,"unary_expression : factor\n");
					$$ = new SymbolInfo("factor", "unary_expression");
					$$->setStart($1->getStart());
					$$->setEnd($1->getEnd());
					$$->addChild($1);
					$$->setDataType($1->getDataType());
					$$->setArraySize($1->getArraySize());
					$$->setVarOrFunc($1->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						$$->setParameter(pt[i]);
					}

                }
                ;
factor : variable   
        {
            fprintf(logout,"factor : variable\n");
			$$ = new SymbolInfo("variable", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
            $$->addChild($1);
            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVarOrFunc($1->getVarOrFunc());
            vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				$$->setParameter(pt[i]);
			}
        }
        | ID LPAREN argument_list RPAREN    
        {
            fprintf(logout,"factor : ID LPAREN argument_list RPAREN\n");
			$$ = new SymbolInfo("ID LPAREN argument_list RPAREN", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($4->getEnd());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
			$$->addChild($4);

			SymbolInfo *info = table.LookUp($1->getName());

			if(info==0)
			{
				fprintf(errorout,"Line# %d : Undeclared function '%s'\n",$1->getStart(),$1->getName().c_str());
				error_count++;
			}
			else if(checkVariable(info))
			{
				fprintf(errorout,"Line# %d : '%s' is not a function\n",$1->getStart(),$1->getName().c_str());
				error_count++;
			}
			else 
			{
				$1->setDataType(info->getDataType());
				SymbolInfo *in = $1;
				if(isFunction_declaration(in)){
                    error_count++;
                    fprintf(errorout,"Line# %d : '%s' is not defined\n",$1->getStart(),$1->getName().c_str());
                }
				else {
					if(info->getParamSize()>argList.size()) 
					{
						fprintf(errorout,"Line# %d : Too few arguments to function '%s'\n",$1->getStart(),$1->getName().c_str());
						error_count++;
					}
					else if(info->getParamSize()<argList.size())
					{
						fprintf(errorout,"Line# %d : Too many arguments to function '%s'\n",$1->getStart(),$1->getName().c_str());
						error_count++;
					}
					else 
					{					
						vector<pair<SymbolInfo*,SymbolInfo*>> pt = info->getParameter();
						for(int i=0;i<argList.size();i++)
						{
							if(argList[i]->getDataType()!=(pt[i].second)->getDataType())
							{
								fprintf(errorout,"Line# %d : Type mismatch for argument %d of '%s'\n",argList[i]->getStart(),(i+1),$1->getName().c_str());
								error_count++;
							}
						}
					}
				}
				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = info->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					$$->setParameter(pt[i]);
				}
			}
            argList.clear();

        }
        | LPAREN expression RPAREN  
        {
            fprintf(logout,"factor : LPAREN expression RPAREN\n");
			$$ = new SymbolInfo("LPAREN expression RPAREN", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($3->getEnd());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());
            $$->setVarOrFunc($2->getVarOrFunc());

			vector<pair<SymbolInfo*,SymbolInfo*>> pt = $2->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				$$->setParameter(pt[i]);
			}

        }
        | CONST_INT 
        {
            fprintf(logout,"factor : CONST_INT\n");
			$$ = new SymbolInfo("CONST_INT", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
            $$->addChild($1);
            $$->setDataType("INT");
            string nm = $1->getName();
            currentValue = stoi(nm);

        }
        | CONST_FLOAT   
        {
            fprintf(logout,"factor : CONST_FLOAT\n");
			$$ = new SymbolInfo("CONST_FLOAT", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
            $$->addChild($1);
            $$->setDataType("FLOAT");
			string nm = $1->getName();
            currentValue = stoi(nm);

        }
        | variable INCOP   
        {
            fprintf(logout,"factor : variable INCOP\n");
			$$ = new SymbolInfo("variable INCOP", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($2->getEnd());
            $$->addChild($1);
            $$->addChild($2);
            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());

        }
        | variable DECOP    
        {
            fprintf(logout,"factor : variable DECOP\n");
			$$ = new SymbolInfo("variable DECOP", "factor");
			$$->setStart($1->getStart());
			$$->setEnd($2->getEnd());
            $$->addChild($1);
            $$->addChild($2);
            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());
        }
        ;


argument_list : arguments  
        {
            $$=new SymbolInfo("arguments","arguments");
			fprintf(logout,"argument_list : arguments\n");
			$$->setStart($1->getStart());
			$$->setEnd($1->getEnd());
			$$->addChild($1);
        }
        | 
        {
            $$=new SymbolInfo("","arguments");
			fprintf(logout,"argument_list : \n");
			$$->setStart(yylineno);
			$$->setEnd(yylineno);

        }
        ;


arguments : arguments COMMA logic_expression   
        {
                $$=new SymbolInfo("arguments COMMA logic_expression","arguments");
				fprintf(logout,"arguments : arguments COMMA logic_expression \n");
				$$->setStart($1->getStart());
				$$->setEnd($3->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				argList.push_back($3);

        }
        | logic_expression  
        {
                $$=new SymbolInfo("logic_expression","arguments");
				fprintf(logout,"arguments : logic_expression \n");
				$$->setStart($1->getStart());
				$$->setEnd($1->getEnd());
				$$->addChild($1);
				argList.push_back($1);
        }
        ;


%%

int main(int argc, char** argv) {
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout=fopen("2005101_log.txt","w");
    parseout=fopen("2005101_parsetree.txt","w");
    errorout=fopen("2005101_error.txt","w");
	

	yyin= fin;
	yyparse();
	fclose(yyin);
	fclose(logout);
	fclose(errorout);
	fclose(parseout);
	return 0;
}