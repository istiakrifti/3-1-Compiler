%{
#include "2005101.cpp"
using namespace std;

int yyparse(void);
int yylex(void);
extern int yylineno;
extern FILE *yyin;
FILE *fp,*logout,*errorout,*parseout;
int error_count = 0;

void yyerror(char *s){}

SymbolTable table(11);

int currentValue = -1;
int errorLine = -1;

// struct arguments {
// 	SymbolInfo *s;
// };

// struct variables {
// 	SymbolInfo *s;
// };

// struct Pair {
// 	SymbolInfo *s1,*s2;
// };

// struct parameterList {
// 	Pair p[100];
// }param;


// struct variableList
// {
// 	variables var[100];
// }varList;

// struct argumentList
// {
// 	arguments arg[100];
// }argList;
// int varCount=0,argCount=0,parCount=0;
string varType;
// void clearParam {
    
//     for (int i = 0; i < 100; i++) {
//         param.p[i].s1 = 0;
//         param.p[i].s2 = 0;
//     }
// 	parCount=0;
// }

// void clearArg {
//     for (int i = 0; i < 100; i++) {
//        argList.arg[i].s=0;
//     }
// 	argCount=0;
// }

// void clearVar {
//     for (int i = 0; i < 100; i++) {
//        varList.var[i].s=0;
//     }
// 	varCount=0;
// }

vector<pair<SymbolInfo*,SymbolInfo*>> param;
vector<SymbolInfo*> varList;
vector<SymbolInfo*> argList;


void PrintParse(SymbolInfo *info,int space)
{

	for(int i=0;i<space;i++) fprintf(parseout," ");
	// vector<SymbolInfo*> ch2= info->getChildList();
	// vector<SymbolInfo*> ch1 = ch2[0]->getChildList();
	// vector<
	// for(int j=0;j<ch1.size();j++)
	// {

	// 	vector<SymbolInfo*> ch = ch1[j]->getChildList();
	// 	for(int i=0;i<ch.size();i++)
	// 	{
			
	// 		fprintf(parseout,"%s hf %d\t<Line: >\n",ch[i]->getName().c_str(),ch[i]->getChildCount());
	// 		// PrintParse(ch[i],(space+1));
	// 	}
	// }
			


}


%}

%union{
    SymbolInfo *symbol;
}

%token <symbol> IF ELSE FOR WHILE INT FLOAT VOID RETURN PRINTLN ASSIGNOP NOT COMMA SEMICOLON LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD INCOP DECOP
%token <symbol> ID ADDOP MULOP LOGICOP RELOP CONST_INT CONST_FLOAT 
%type <symbol> start program unit var_declaration declaration_list func_declaration func_definition type_specifier compound_statement parameter_list statements statement variable expression_statement logic_expression arguments argument_list expression simple_expression unary_expression factor term rel_expression 
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
						for(int i=0;i<param.size();i++){
							info->setParameter(param[i].first,param[i].second);
						}
						
						table.Insert(info);
					 } 
					 else
					 {
						if(temp->getVarOrFunc() != "variable"){
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of '%s' function",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol",$2->getStart(),temp->getName().c_str());
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
					 } 
					 else
					 {
						if(temp->getVarOrFunc() != "variable"){
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of %s function",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : %s redeclared as different kind of symbol",$2->getStart(),temp->getName().c_str());
						}
					 }
				 }
				 ;
func_definition : type_specifier ID LPAREN parameter_list RPAREN {

					 SymbolInfo *info = new SymbolInfo($2->getName(),$2->getType());
					 info->setStart($1->getStart());
					 info->setEnd($2->getEnd());
					 info->setDataType($1->getDataType());
					 info->setVarOrFunc("func_defination");
					 for(int i=0;i<param.size();i++){
							info->setParameter(param[i].first,param[i].second);
						}

					 string funcName = $2->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						table.Insert(info);
					 } 
					 else
					 {
						if(temp->getVarOrFunc()=="variable")
						{
							error_count++;
							fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							if(temp->getVarOrFunc()=="func_declaration")
							{	
								// parameterList par;
								vector<pair<SymbolInfo*,SymbolInfo*>> pt = temp->getParameter();
								// for(int i=0;i<pt.size();i++)
								// {
								// 	par.p[i].s1 = pt[i].first;
								// 	par.p[i].s2 = pt[i].second;
								// }
								
								// int size = temp->getParamSize();

								bool flag = true;

								if(temp->getDataType() != $1->getDataType())
								{
									error_count++;
									fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
									flag=false;
                        		}
								else if(param.size()!=pt.size())
								{
									error_count++;
									fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
									flag=false;
								
								}
								else
								{
									for(int i=0;i<param.size();i++)
									{

										if((param[i].first)->getType() != (pt[i].first)->getType())
										{
											error_count++;
											fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
											flag=false;
											break;
										}
									}
								}

								
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
					 SymbolInfo *info = new SymbolInfo($2->getName(),$2->getType());
					 info->setStart($1->getStart());
					 info->setEnd($2->getEnd());
					 info->setDataType($1->getDataType());
					 info->setVarOrFunc("func_defination");

					 string funcName = $2->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						table.Insert(info);
					 } 
					 else
					 {
						if(temp->getVarOrFunc()=="variable")
						{
							error_count++;
							fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",$2->getStart(),temp->getName().c_str());
                		}
						else
						{
							if(temp->getVarOrFunc()=="func_declaration")
							{
								bool flag = true;

								if(temp->getDataType() != $1->getDataType())
								{
									error_count++;
									fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",$1->getStart(),temp->getName().c_str());
									flag=false;
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
					 fprintf(logout,"%s fhfg %d\n",$2->getName().c_str(),$2->getChildCount());
					 $$->addChild($1);
					 $$->addChild($2);
					 $$->addChild($3);
					 $$->addChild($4);
					 $$->addChild($6);	 
				}
				| type_specifier ID LPAREN error {  
											if(errorLine==-1)
											{
												errorLine = yylineno;
												error_count++;
												fprintf(errorout,"Line# %d : Syntax error at parameter list of function definition\n",$3->getStart());
												fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
												param.clear();
                                            }} RPAREN {errorLine = -1;} compound_statement
				{
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
						$$->setParameter(pt[i].first,pt[i].second);
					}
								
					$$->setParameter($3,$4);
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
						$$->setParameter(pt[i].first,pt[i].second);
					}
							 
					SymbolInfo *info = new SymbolInfo("","");
					info->setStart($3->getStart());
					info->setEnd($3->getEnd());
					info->setDataType($3->getDataType());
					$$->setParameter($3,info);
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
					$$->setParameter($1,$2);
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
					$$->setParameter($1,info);
					param.push_back({$1,info});
			   }
			   ;
compound_statement : LCURL {
							table.EnterScope();
							if(param.size()!=0)
							{
								for(int i=0;i<param.size();i++)
								{
									SymbolInfo *temp1 = param[i].first;
									SymbolInfo *temp2 = param[i].second;

									SymbolInfo *sym = new SymbolInfo(temp2->getName(),temp2->getType());
									sym->setStart(temp1->getStart());
									sym->setEnd(temp2->getEnd());
									sym->setDataType(temp2->getDataType());

									SymbolInfo *sym1 = table.getCurrentScope()->LookUp(sym->getName());
									if(sym1!=0)
									{
                    					fprintf(errorout,"Line# %d : Redefinition of parameter '%s'\n",sym->getStart(),sym->getName().c_str());
										error_count++;
									}
									else 
									{
										table.Insert(sym);
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
							if(param.size()!=0)
							{
								for(int i=0;i<param.size();i++)
								{
									SymbolInfo *temp1 = param[i].first;
									SymbolInfo *temp2 = param[i].second;

									SymbolInfo *sym = new SymbolInfo(temp2->getName(),temp2->getType());
									sym->setStart(temp1->getStart());
									sym->setEnd(temp2->getEnd());
									sym->setDataType(temp2->getDataType());

									SymbolInfo *sym1 = table.getCurrentScope()->LookUp(sym->getName());
									if(sym1!=0)
									{
                    					fprintf(errorout,"Line# %d : Redefinition of parameter '%s'\n",sym->getStart(),sym->getName().c_str());
										error_count++;
									}
									else 
									{
										table.Insert(sym);
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
							
							fprintf(logout,"%s ghg %d hhhj %s\n",info->getName().c_str(),info->getChildCount(),info->getType().c_str());
							
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
									fprintf(logout,"%s ghg %d hhhj %s\n",info->getName().c_str(),info->getChildCount(),info->getType().c_str());
									table.Insert(info);
								}
							}
						}
						varList.clear();
						varType="";
				}	
				| type_specifier error {
						if(errorLine==-1)
						{
							errorLine=yylineno;
							fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
						} 
					} SEMICOLON 
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
				 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
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
				 | ID LTHIRD CONST_INT RTHIRD
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
		  | IF LPAREN expression RPAREN statement ELSE statement
		  {
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
	      | PRINTLN LPAREN ID RPAREN SEMICOLON
		  {
				fprintf(logout,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
				$$ = new SymbolInfo("PRINTLN LPAREN ID RPAREN SEMICOLON", "statement");
				$$->setStart($1->getStart());
				$$->setEnd($5->getEnd());
				$$->addChild($1);
				$$->addChild($2);
				$$->addChild($3);
				$$->addChild($4);
				$$->addChild($5);

				SymbolInfo *info = table.LookUp($3->getName());
				if(info==0)
				{
					error_count++;
					fprintf(errorout,"Line# %d : Undeclared variable '%s'\n",$3->getStart(),$3->getName().c_str());
				}
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
					 | error {if(errorLine==-1) errorLine=yylineno;} SEMICOLON 
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
					$$->setParameter(pt[i].first,pt[i].second);
				}
		 }
         | ID LTHIRD expression RTHIRD
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
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i].first,pt[i].second);
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
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i].first,pt[i].second);
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
					fprintf(errorout,"Line# %d : Warning: possible loss of data in assignment of FLOAT to INT\n",$1->getStart());
				}

				$$->setDataType($1->getDataType());
				$$->setArraySize($1->getArraySize());
				$$->setVarOrFunc($1->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = $1->getParameter();
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i].first,pt[i].second);
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
						for(int i=0;i<pt.size();i++){
							$$->setParameter(pt[i].first,pt[i].second);
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
						for(int i=0;i<pt.size();i++){
							$$->setParameter(pt[i].first,pt[i].second);
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
						for(int i=0;i<pt.size();i++){
							$$->setParameter(pt[i].first,pt[i].second);
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
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i].first,pt[i].second);
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
					for(int i=0;i<pt.size();i++){
						$$->setParameter(pt[i].first,pt[i].second);
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
					for(int i=0;i<pt.size();i++){
						$$->setParameter(pt[i].first,pt[i].second);
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
					for(int i=0;i<pt.size();i++){
						$$->setParameter(pt[i].first,pt[i].second);
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
			for(int i=0;i<pt.size();i++){
				$$->setParameter(pt[i].first,pt[i].second);
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
			else if(info->getVarOrFunc()=="variable")
			{
				fprintf(errorout,"Line# %d : '%s' is not a function\n",$1->getStart(),$1->getName().c_str());
				error_count++;
			}
			else 
			{
				$1->setDataType(info->getDataType());

				if($1->getVarOrFunc() == "func_declaration"){
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
				for(int i=0;i<pt.size();i++){
					$$->setParameter(pt[i].first,pt[i].second);
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
			for(int i=0;i<pt.size();i++){
				$$->setParameter(pt[i].first,pt[i].second);
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
	
	logout= fopen("2005101_log.txt","w");
	errorout = fopen("2005101_error.txt","w");
	parseout = fopen("2005101_parsetree.txt","w");


	yyin= fin;
	yyparse();
	fclose(yyin);
	fclose(logout);
	fclose(errorout);
	fclose(parseout);
	return 0;
}
