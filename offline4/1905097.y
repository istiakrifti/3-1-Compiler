
%{
    #include<bits/stdc++.h>
    #include"1905097.cpp"

    using namespace std;

    int yyparse(void);
    int yylex(void);
    extern FILE *yyin;
    extern int yylineno;
    int scopeTableID=0;
    int bucketLength=11;
    ofstream logout;
    int error_count=0;
    ofstream parseTreeOut;
    ofstream errorout;

    SymbolTable* symbolTable = new SymbolTable(++scopeTableID, bucketLength);
    vector<pair<SymbolInfo*, SymbolInfo*> > param;
    string variableType;
    vector<SymbolInfo*> variableList;
    vector<SymbolInfo*> argumentList;
    int value = -1;
    int errorLine = -1;
    
    vector<SymbolInfo*> globalVarList;
    int label = 0;
    bool isGlobal=true;
    int stackOffset=0;
    //int paramOffset=0;
    string curLabel = "";
    string returnLabel="";
    ofstream codeout;
    ofstream optimizedcodeout;
    bool isNegated=false;
    int paramSize=0;
    //bool labelCreated=false;

    void start(SymbolInfo*);
    void func_definition(SymbolInfo*);
    void var_declaration(SymbolInfo*);
    void compound_statement(SymbolInfo*);
    void declaration_list(SymbolInfo*);
    void statements(SymbolInfo*);
    void statement(SymbolInfo*);
    void expression_statement(SymbolInfo*);
    void expression(SymbolInfo*);
    void logic_expression(SymbolInfo*);
    void rel_expression(SymbolInfo*);
    void simple_expression(SymbolInfo*);
    void term(SymbolInfo*);
    void unary_expression(SymbolInfo*);
    void factor(SymbolInfo*);
    void argument_list(SymbolInfo*);
    void arguments(SymbolInfo*);
    void ifElseBranching(SymbolInfo*, string);
    //void testString(string);

    string newLabel(){
        label++;
        string s = "L" + to_string(label);
        return s;
    }

    void yyerror(char *s)
    {
	    //write your code
    }

    void printParseTree(SymbolInfo* symbol, int space){

        for(int i=0;i<space;i++){
            parseTreeOut<<" ";
        }

        if(symbol->getChildList().size() == 0){
            parseTreeOut<<symbol->getType()<<" : "<<symbol->getName()<<"\t"<<"<Line: "<<symbol->getStartLine()<<">"<<endl;
            return;
        }

        else{
            parseTreeOut<<symbol->getType()<<" : "<<symbol->getName()<<" \t"<<"<Line: "<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
        }

        vector<SymbolInfo*> child=symbol->getChildList();
        for(int i=0;i<child.size();i++){
            printParseTree(child[i], space+1);
        }
    }


    void giveFunctionDefinitionWithParameters(SymbolInfo* returnType, SymbolInfo* functionName){

        SymbolInfo* tmp=new SymbolInfo(functionName->getName(), functionName->getType(), returnType->getStartLine(), functionName->getEndLine());
        tmp->setDataType(returnType->getDataType());
        tmp->setVariableOrFunction("func_definition");

        for(pair<SymbolInfo*, SymbolInfo*> tmp1: param){
            tmp->addParameter(tmp1);
        }

        SymbolInfo* symbol=symbolTable->lookUp(functionName->getName());

            if(symbol == NULL){

                symbolTable->insertKey(*tmp, logout);

            }

            else{

                if(symbol->getVariableOrFunction() == "variable"){
                    error_count++;
                    errorout<<"Line# "<<functionName->getStartLine()<<": '"<<symbol->getName()<<"' redeclared as different kind of symbol"<<endl;
                }

                else{

                    if(symbol->getVariableOrFunction() == "func_declaration"){

                        vector<pair<SymbolInfo*, SymbolInfo*> > param1 = symbol->getParametersList();

                        bool flag=true;
                        if(symbol->getDataType() != returnType->getDataType()){
                            error_count++;
                            errorout<<"Line# "<<returnType->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                            flag=false;
                        }

                        else if(param1.size() != param.size()){
                            error_count++;
                            errorout<<"Line# "<<returnType->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                            flag=false;
                        }

                        else{
                            for(int i=0;i<param1.size();i++){
                            if((param1[i].first)->getType() != (param[i].first)->getType()){
                                error_count++;
                                errorout<<"Line# "<<returnType->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                                flag=false;
                                break;
                            }
                        }
                        }

                        if(flag){;
                            symbolTable->insertKey(*tmp, logout);
                        }

                    }

                    else{
                        error_count++;
                        errorout<<"Line# "<<returnType->getStartLine()<<": Redefinition of function '"<<symbol->getName()<<"'"<<endl;
                    }
                }

            }

            param.clear();

    }


    void giveFunctionDefinitionWithoutParameters(SymbolInfo* returnType, SymbolInfo* functionName){

        SymbolInfo* tmp=new SymbolInfo(functionName->getName(), functionName->getType(), returnType->getStartLine(), functionName->getEndLine());
        tmp->setDataType(returnType->getDataType());
        tmp->setVariableOrFunction("func_definition");

        SymbolInfo* symbol=symbolTable->lookUp(functionName->getName());

            if(symbol == NULL){

                symbolTable->insertKey(*tmp, logout);

            }

            else{

                if(symbol->getVariableOrFunction() == "variable"){
                    error_count++;
                    errorout<<"Line# "<<functionName->getStartLine()<<": '"<<symbol->getName()<<"' redeclared as different kind of symbol"<<endl;
                }

                else{

                    if(symbol->getVariableOrFunction() == "func_declaration"){

                        bool flag=true;
                        if(symbol->getDataType() != returnType->getDataType()){
                            error_count++;
                            errorout<<"Line# "<<returnType->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                            flag=false;
                        } 

                        if(flag){
                            symbolTable->insertKey(*tmp, logout);
                        }

                    }

                    else{
                        error_count++;
                        errorout<<"Line# "<<returnType->getStartLine()<<": Redefinition of function '"<<symbol->getName()<<"'"<<endl;
                    }
                }

            }

    }

    void createNewScope(){
        symbolTable->enterScope(++scopeTableID, bucketLength);
        
        if(param.size() != 0){
            for(pair<SymbolInfo*, SymbolInfo*> tmp1: param){
                SymbolInfo* tmp2 = new SymbolInfo(tmp1.second->getName(), tmp1.second->getType(), tmp1.first->getStartLine(), tmp1.second->getEndLine());
                tmp2->setDataType(tmp1.second->getDataType());

                SymbolInfo* symbol1 = symbolTable->getCurrentScopeTable()->lookUp(tmp2->getName());
                if(symbol1 == NULL){
                    symbolTable->insertKey(*tmp2, logout);
                }

                else{
                    error_count++;
                    errorout<<"Line# "<<tmp2->getStartLine()<<": Redefinition of parameter '"<<tmp2->getName()<<"'"<<endl;
                }

            }
            param.clear();
        }
    }

    void print_new_line(){
        codeout<<"new_line proc\n"
            "\tpush ax\n"
            "\tpush dx\n"
            "\tmov ah,2\n"
            "\tmov dl,cr\n"
            "\tint 21h\n"
            "\tmov ah,2\n"
            "\tmov dl,lf\n"
            "\tint 21h\n"
            "\tpop dx\n"
            "\tpop ax\n"
            "\tret\n"
        "new_line endp"<<endl;
    }

    void print_output(){
        codeout<<"print_output proc  ;print what is in ax\n"
            "\tpush ax\n"
            "\tpush bx\n"
            "\tpush cx\n"
            "\tpush dx\n"
            "\tpush si\n"
            "\tlea si,number\n"
            "\tmov bx,10\n"
            "\tadd si,4\n"
            "\tcmp ax,0\n"
            "\tjnge negate\n"
            "\tprint:\n"
            "\txor dx,dx\n"
            "\tdiv bx\n"
            "\tmov [si],dl\n"
            "\tadd [si],'0'\n"
            "\tdec si\n"
            "\tcmp ax,0\n"
            "\tjne print\n"
            "\tinc si\n"
            "\tlea dx,si\n"
            "\tmov ah,9\n"
            "\tint 21h\n"
            "\tpop si\n"
            "\tpop dx\n"
            "\tpop cx\n"
            "\tpop bx\n"
            "\tpop ax\n"
            "\tret\n"
            "\tnegate:\n"
            "\tpush ax\n"
            "\tmov ah,2\n"
            "\tmov dl,'-'\n"
            "\tint 21h\n"
            "\tpop ax\n"
            "\tneg ax\n"
            "\tjmp print\n"
        "print_output endp"<<endl;
    }

    void start(SymbolInfo* symbol){
        codeout.open("1905097_code.asm");
        codeout<<".MODEL SMALL"<<endl;
        codeout<<".STACK 1000H"<<endl;
        codeout<<".Data"<<endl;
	    codeout<<"\tCR EQU 0DH"<<endl;
        codeout<<"\tLF EQU 0AH"<<endl;
	    codeout<<"\tnumber DB \"00000$\""<<endl;
        SymbolInfo* program = (symbol->getChildList())[0];
        vector<SymbolInfo*> unitList;
	    while(program->getChildList().size() == 2){
            unitList.push_back((program->getChildList())[1]);
            program = (program->getChildList())[0];
        }
        unitList.push_back((program->getChildList())[0]);

        codeout<<"\t\t;declaring global variables"<<endl;
        for(SymbolInfo* globalVar: globalVarList){
            if(globalVar->isArray()){
                codeout<<"\t"<<globalVar->getName()<<" DW "<<globalVar->getArraySize()<<" DUP (0000H)"<<endl;
            }

            else{
                codeout<<"\t"<<globalVar->getName()<<" DW 1 DUP (0000H)"<<endl;
            }
        }

        codeout<<".CODE"<<endl;
        isGlobal=false;

        for(SymbolInfo* unit1: unitList){
            if(unit1->getName() == "func_definition"){
                func_definition((unit1->getChildList())[0]);
            }
        }

        print_new_line();
        print_output();
        codeout<<"END main"<<endl;

        ifstream codein;
        string inputLine;
        vector<string> codeLines;
        codein.open("1905097_code.asm");
        optimizedcodeout.open("1905097_optimized_code.asm");
        //testString("\tADD AX, 0");

        while(getline(codein, inputLine)){
            codeLines.push_back(inputLine);
        }

        for(int i=0;i<codeLines.size(); i++){
            if(i+1>=codeLines.size()){

            }

            else if(codeLines[i].substr(1,3) == "ADD" || codeLines[i].substr(1,3) == "SUB"){
                string line1=codeLines[i].substr(4);
                int commaIndex1=line1.find(",");
                if(line1.substr(commaIndex1+2) == "0"){
                    optimizedcodeout<<"\t\t;removed addition with 0"<<endl;
                    continue;
                }
            }

            else if(codeLines[i].substr(1,3) == "MUL"){
                string line1=codeLines[i].substr(4);
                int commaIndex1=line1.find(",");
                if(line1.substr(commaIndex1+2) == "1"){
                    optimizedcodeout<<"\t\t;removed multiplication with 1"<<endl;
                    continue;
                }
            }

            else if(codeLines[i].substr(1,4) == "PUSH" && codeLines[i+1].substr(1,3) == "POP"){
                if(codeLines[i].substr(6) == codeLines[i+1].substr(5)){
                    optimizedcodeout<<"\t\t;removed PUSH and POP of the same register in consecutive lines"<<endl;
                    i++;
                    continue;
                }
            }

            else if(codeLines[i].substr(1,3) == "MOV" && codeLines[i+1].substr(1,3) == "MOV"){
                string line1=codeLines[i].substr(4);
                string line2=codeLines[i+1].substr(4);

                int commaIndex1=line1.find(",");
                int commaIndex2=line2.find(",");

                if(line1.substr(1,commaIndex1-1) == line2.substr(commaIndex2+2) && line1.substr(commaIndex1+2) == line2.substr(1,commaIndex2-1)){
                    optimizedcodeout<<codeLines[i]<<endl;
                    optimizedcodeout<<"\t\t;removed reduntant MOV instruction"<<endl;
                    i++;
                    continue;
                }
            }

            optimizedcodeout<<codeLines[i]<<endl;
        }

        codein.close();
        codeout.close();
        optimizedcodeout.close();
    }


    void var_declaration(SymbolInfo* symbol){
        codeout<<"\t\t;variable declaration"<<endl;
        declaration_list((symbol->getChildList())[1]);
    }


    void declaration_list(SymbolInfo* symbol){
        if(isGlobal){
            return;
        }
        if(symbol->getChildList().size() == 1){
            stackOffset+=2;
            ((symbol->getChildList())[0])->setStackOffset(stackOffset);
            symbolTable->insertKey(*((symbol->getChildList())[0]), logout);
            codeout<<"\tSUB SP, 2"<<endl;
        }

        else if(symbol->getChildList().size() == 3){
            stackOffset+=2;
            ((symbol->getChildList())[2])->setStackOffset(stackOffset);
            symbolTable->insertKey(*((symbol->getChildList())[2]), logout);
            codeout<<"\tSUB SP, 2"<<endl;
            declaration_list((symbol->getChildList())[0]);
        }

        else if(symbol->getChildList().size() == 4){
            stackOffset+=2*stoi(((symbol->getChildList())[0])->getArraySize());
            ((symbol->getChildList())[0])->setStackOffset(stackOffset);
            symbolTable->insertKey(*((symbol->getChildList())[0]), logout);
            codeout<<"\tSUB SP, "<<2*stoi(((symbol->getChildList())[0])->getArraySize())<<endl;
        }

        else if(symbol->getChildList().size() == 6){
            stackOffset+=2*stoi(((symbol->getChildList())[2])->getArraySize());
            ((symbol->getChildList())[2])->setStackOffset(stackOffset);
            symbolTable->insertKey(*((symbol->getChildList())[2]), logout);
            codeout<<"\tSUB SP, "<<2*stoi(((symbol->getChildList())[2])->getArraySize())<<endl;
            declaration_list((symbol->getChildList())[0]);
        }
    }


    void func_definition(SymbolInfo* symbol){
        stackOffset=-2;
        string funcName=((symbol->getChildList())[1])->getName();
        //symbolTable->enterScope(++scopeTableId, bucketLength);
        codeout<<"\t\t;function definition"<<endl;
        codeout<<funcName<<" PROC"<<endl;
        if(funcName == "main"){
            codeout<<"\tMOV AX, @DATA"<<endl;
            codeout<<"\tMOV DS, AX"<<endl;
        }
        if(symbol->getChildList().size() == 6){
            param=((symbol->getChildList())[3])->getParametersList();

            for(int i=0;i<param.size();i++){
                stackOffset-=2;
                (param[i].second)->setStackOffset(stackOffset);
                //codeout<<"\tSUB SP, 2"<<endl;
            }
        }
        //paramOffset=stackOffset*(-1);
        stackOffset=0;
        paramSize=param.size();
        codeout<<"\t\t;pushing base pointer"<<endl;
        codeout<<"\tPUSH BP"<<endl;
        codeout<<"\tMOV BP, SP"<<endl;
        returnLabel=newLabel();
        //curLabel=newLabel();

        if(symbol->getChildList().size() == 6){
            compound_statement((symbol->getChildList())[5]);
        }

        else{
            compound_statement((symbol->getChildList())[4]);
        }
        //codeout<<curLabel<<":"<<endl;
        codeout<<returnLabel<<":"<<"\t\t;returning from function"<<endl;
        //codeout<<"\tADD SP, "<<stackOffset<<endl;
        codeout<<"\tMOV SP, BP"<<endl;
        codeout<<"\tPOP BP"<<endl;
        if(funcName == "main"){
            codeout<<"\tMOV AX, 4CH"<<endl;
            codeout<<"\tINT 21H"<<endl;
        }

        else{
            if(paramSize>0){
                codeout<<"\tRET "<<(2*paramSize)<<endl;
            }
            else{
                codeout<<"\tRET"<<endl;
            }
            paramSize=0;
        }
        codeout<<funcName<<" ENDP"<<endl;
        stackOffset=0;
        //paramSize=0;
        //paramOffset=0;

    }


    void compound_statement(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 3){
            symbolTable->enterScope(++scopeTableID, bucketLength);
            if(param.size() != 0){
                for(int i=0;i<param.size();i++){
                    symbolTable->insertKey(*(param[i].second), logout);
                }
                param.clear();
            }
            statements((symbol->getChildList())[1]);
            symbolTable->exitScope();
        }

        else{
            symbolTable->enterScope(++scopeTableID, bucketLength);
            symbolTable->exitScope();
        }
    }


    void statements(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            statement((symbol->getChildList())[0]);
        }

        else if(symbol->getChildList().size() == 2){
            statements((symbol->getChildList())[0]);
            statement((symbol->getChildList())[1]);
        }
    }


    void statement(SymbolInfo* symbol){
        //curLabel=newLabel();    
        //codeout<<curLabel<<":"<<endl;
        //labelCreated=false;
        //codeout<<"\t\t;Line no "<<symbol->getStartLine()<<endl;
        if(symbol->getName() == "var_declaration"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            var_declaration((symbol->getChildList())[0]);
        }

        else if(symbol->getName() == "expression_statement"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            expression_statement((symbol->getChildList())[0]);
        }

        else if(symbol->getName() == "PRINTLN LPAREN ID RPAREN SEMICOLON"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            string varName=((symbol->getChildList())[2])->getName();
            SymbolInfo* symbol1=symbolTable->lookUp(varName);
            string varName1="";

            if(symbol1->getStackOffset() == 0){
                varName1=symbol1->getName();
            }

            else if(symbol1->getStackOffset() > 0){
                varName1="[BP-"+to_string(symbol1->getStackOffset())+"]";
            }

            else if(symbol1->getStackOffset() < 0){
                varName1="[BP+"+to_string((symbol1->getStackOffset())*(-1))+"]";
            }

            codeout<<"\t\t;calling println function"<<endl;
            codeout<<"\tMOV AX, "<<varName1<<endl;
            codeout<<"\tCALL print_output"<<endl;
	        codeout<<"\tCALL new_line"<<endl;
        }

        else if(symbol->getName() == "compound_statement"){
            compound_statement((symbol->getChildList())[0]);
        }

        else if(symbol->getName() == "RETURN expression SEMICOLON"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            expression((symbol->getChildList())[1]);
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tJMP "<<returnLabel<<endl;
        }

        else if(symbol->getName() == "IF LPAREN expression RPAREN statement"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            codeout<<"\t\t;if else statement"<<endl;
            expression((symbol->getChildList())[2]);
            string nextLabel=newLabel();
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJE "<<nextLabel<<endl;
            statement((symbol->getChildList())[4]);
            codeout<<nextLabel<<":"<<endl;
        }

        else if(symbol->getName() == "IF LPAREN expression RPAREN statement ELSE statement"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            codeout<<"\t\t;if else statement"<<endl;
            expression((symbol->getChildList())[2]);
            string labelOne=newLabel();
            string labelZero=newLabel();
            string nextLabel=newLabel();
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJNE "<<labelOne<<endl;
            codeout<<"\tJMP "<<labelZero<<endl;
            codeout<<labelOne<<":"<<endl;
            statement((symbol->getChildList())[4]);
            codeout<<"\tJMP "<<nextLabel<<endl;
            codeout<<labelZero<<":"<<endl;
            ifElseBranching((symbol->getChildList())[6], nextLabel);
            codeout<<nextLabel<<":"<<endl;
        }

        else if(symbol->getName() == "FOR LPAREN expression_statement expression_statement expression RPAREN statement"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            codeout<<"\t\t;for initialization"<<endl;
            expression_statement((symbol->getChildList())[2]);
            //codeout<<"\tPOP AX"<<endl;
            string labelBegin=newLabel();
            string labelEnd=newLabel();
            codeout<<labelBegin<<":"<<"\t\t;for loop start"<<endl;
            expression_statement((symbol->getChildList())[3]);
            //codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJE "<<labelEnd<<endl;
            statement((symbol->getChildList())[6]);
            expression((symbol->getChildList())[4]);
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tJMP "<<labelBegin<<endl;
            codeout<<labelEnd<<":"<<endl;
        }

        else if(symbol->getName() == "WHILE LPAREN expression RPAREN statement"){
            codeout<<"\t\t;Line no <"<<symbol->getStartLine()<<"-"<<symbol->getEndLine()<<">"<<endl;
            string labelBegin=newLabel();
            string labelEnd=newLabel();
            codeout<<labelBegin<<":"<<"\t\t;while loop start"<<endl;
            expression((symbol->getChildList())[2]);
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJE "<<labelEnd<<endl;
            statement((symbol->getChildList())[4]);
            //codeout<<"\tPOP AX"<<endl;
            codeout<<"\tJMP "<<labelBegin<<endl;
            codeout<<labelEnd<<":"<<endl;
        }
    }


    void ifElseBranching(SymbolInfo* symbol, string nextLabel){
        if(symbol->getName() == "IF LPAREN expression RPAREN statement ELSE statement"){
            expression((symbol->getChildList())[2]);
            string labelZero=newLabel();
            string labelOne=newLabel();
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJNE "<<labelOne<<endl;
            codeout<<"\tJMP "<<labelZero<<endl;
            codeout<<labelOne<<":"<<endl;
            statement((symbol->getChildList())[4]);
            codeout<<"\tJMP "<<nextLabel<<endl;
            codeout<<labelZero<<":"<<endl;
            ifElseBranching((symbol->getChildList())[6], nextLabel);
        }

        else if(symbol->getName() == "IF LPAREN expression RPAREN statement"){
            expression((symbol->getChildList())[2]);
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJE "<<nextLabel<<endl;
            statement((symbol->getChildList())[4]);
        }

        else{
            statement(symbol);
        }
    }


    void expression_statement(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 2){
            expression((symbol->getChildList())[0]);
            codeout<<"\tPOP AX"<<endl;
        }
    }


    void expression(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 3){

            logic_expression((symbol->getChildList())[2]);
            string varName1="";
            
            if(((symbol->getChildList())[0])->getChildList().size() == 1){
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName();
                }

                else if(symbol1->getStackOffset() > 0){
                    varName1="[BP-"+to_string(symbol1->getStackOffset())+"]";
                }

                else if(symbol1->getStackOffset() < 0){
                    varName1="[BP+"+to_string((symbol1->getStackOffset())*(-1))+"]";
                }
            }

            else{
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                //codeout<<variableName<<endl;
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);
                expression((((symbol->getChildList())[0])->getChildList())[2]);
                //codeout<<symbol1->getName()<<endl;
                codeout<<"\tPOP SI"<<endl;
                codeout<<"\tSHL SI, 1"<<endl;

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName()+"[SI]";
                }

                else if(symbol1->getStackOffset() > 0){
                    //codeout<<"Hi"<<endl;
                    codeout<<"\tNEG SI"<<endl;
                    codeout<<"\tADD SI, "<<symbol1->getStackOffset()<<endl;
                    codeout<<"\tNEG SI"<<endl;
                    varName1="BP[SI]";
                }

                else if(symbol1->getStackOffset() < 0){
                    codeout<<"\tSUB SI, "<<symbol1->getStackOffset()<<endl;
                    varName1="BP[SI]";
                }
            }
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tMOV "<<varName1<<", AX"<<endl;
            codeout<<"\tPUSH AX"<<endl;
        }

        else{
            logic_expression((symbol->getChildList())[0]);
        }
    }


    void logic_expression(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            rel_expression((symbol->getChildList())[0]);
        }

        else{
            rel_expression((symbol->getChildList())[0]);
            string labelZero=newLabel();
            string labelOne=newLabel();
            string nextLabel=newLabel();
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            if(((symbol->getChildList())[1])->getName() == "||"){
                codeout<<"\tJNE "<<labelOne<<endl;
                rel_expression((symbol->getChildList())[2]);
                codeout<<"\tPOP AX"<<endl;
                codeout<<"\tCMP AX, 0"<<endl;
                codeout<<"\tJE "<<labelZero<<endl;
                codeout<<labelOne<<":"<<endl;
                codeout<<"\tMOV AX, 1"<<endl;
                codeout<<"\tPUSH AX"<<endl;
                codeout<<"\tJMP "<<nextLabel<<endl;
                codeout<<labelZero<<":"<<endl;
                codeout<<"\tMOV AX, 0"<<endl;
                codeout<<"\tPUSH AX"<<endl;
                codeout<<nextLabel<<":"<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "&&"){
                codeout<<"\tJE "<<labelZero<<endl;
                rel_expression((symbol->getChildList())[2]);
                codeout<<"\tPOP AX"<<endl;
                codeout<<"\tCMP AX, 0"<<endl;
                codeout<<"\tJNE "<<labelOne<<endl;
                codeout<<labelZero<<":"<<endl;
                codeout<<"\tMOV AX, 0"<<endl;
                codeout<<"\tPUSH AX"<<endl;
                codeout<<"\tJMP "<<nextLabel<<endl;
                codeout<<labelOne<<":"<<endl;
                codeout<<"\tMOV AX, 1"<<endl;
                codeout<<"\tPUSH AX"<<endl;
                codeout<<nextLabel<<":"<<endl;
            }
        }
    }


    void rel_expression(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            simple_expression((symbol->getChildList())[0]);
        }

        else{
            simple_expression((symbol->getChildList())[0]);
            simple_expression((symbol->getChildList())[2]);
            string labelZero=newLabel();
            string labelOne=newLabel();
            string nextLabel=newLabel();
            //labelCreated=true;
            codeout<<"\tPOP DX"<<endl;
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, DX"<<endl;

            if(((symbol->getChildList())[1])->getName() == "<"){
                codeout<<"\tJL "<<labelOne<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "<="){
                codeout<<"\tJLE "<<labelOne<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == ">"){
                codeout<<"\tJG "<<labelOne<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == ">="){
                codeout<<"\tJGE "<<labelOne<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "=="){
                codeout<<"\tJE "<<labelOne<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "!="){
                codeout<<"\tJNE "<<labelOne<<endl;
            }

            codeout<<"\tJMP "<<labelZero<<endl;
            codeout<<labelOne<<":"<<endl;
            codeout<<"\tMOV AX, 1"<<endl;
            codeout<<"\tPUSH AX"<<endl;
            codeout<<"\tJMP "<<nextLabel<<endl;
            codeout<<labelZero<<":"<<endl;
            codeout<<"\tMOV AX, 0"<<endl;
            codeout<<"\tPUSH AX"<<endl;
            codeout<<nextLabel<<":"<<endl;
        }
    }


    void simple_expression(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            term((symbol->getChildList())[0]);
        }
        

        else{
            simple_expression((symbol->getChildList())[0]);
            term((symbol->getChildList())[2]);
            codeout<<"\tPOP DX"<<endl;
            codeout<<"\tPOP AX"<<endl;
            if(((symbol->getChildList())[1])->getName() == "+"){
                codeout<<"\tADD AX, DX"<<endl;
            }

            else{
                codeout<<"\tSUB AX, DX"<<endl;
            }
            codeout<<"\tPUSH AX"<<endl;
        }
    }


    void term(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            unary_expression((symbol->getChildList())[0]);
        }

        else{
            term((symbol->getChildList())[0]);
            unary_expression((symbol->getChildList())[2]);
            codeout<<"\tPOP CX"<<endl;
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCWD"<<endl;
            if(((symbol->getChildList())[1])->getName() == "*"){
                codeout<<"\tIMUL CX"<<endl;
                codeout<<"\tPUSH AX"<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "/"){
                codeout<<"\tIDIV CX"<<endl;
                codeout<<"\tPUSH AX"<<endl;
            }

            else if(((symbol->getChildList())[1])->getName() == "%"){
                codeout<<"\tIDIV CX"<<endl;
                codeout<<"\tPUSH DX"<<endl;
            }
        }
    }


    void unary_expression(SymbolInfo* symbol){
        if(symbol->getChildList().size() == 1){
            factor((symbol->getChildList())[0]);
        }

        else if(symbol->getName() == "ADDOP unary_expression"){
            if(((symbol->getChildList())[0])->getName() == "-"){
                isNegated=true;
            }

            unary_expression((symbol->getChildList())[1]);
        }

        else if(symbol->getName() == "NOT unary_expression"){
            unary_expression((symbol->getChildList())[1]);
            string labelZero=newLabel();
            string labelOne=newLabel();
            string nextLabel=newLabel();
            codeout<<"\tPOP AX"<<endl;
            codeout<<"\tCMP AX, 0"<<endl;
            codeout<<"\tJE "<<labelOne<<endl;
            codeout<<"\tJMP "<<labelZero<<endl;
            codeout<<labelOne<<":"<<endl;
            codeout<<"\tMOV AX, 1"<<endl;
            codeout<<"\tPUSH AX"<<endl;
            codeout<<"\tJMP "<<nextLabel<<endl;
            codeout<<labelZero<<":"<<endl;
            codeout<<"\tMOV AX, 0"<<endl;
            codeout<<"\tPUSH AX"<<endl;
            codeout<<nextLabel<<":"<<endl;

        }
    }


    void factor(SymbolInfo* symbol){
        if((symbol->getChildList())[0]->getType() == "CONST_INT"){
            codeout<<"\tMOV AX, "<<(symbol->getChildList())[0]->getName()<<endl;
            if(isNegated){
                codeout<<"\tNEG AX"<<endl;
                isNegated=false;
            }
            codeout<<"\tPUSH AX"<<endl;
        }

        else if((symbol->getChildList())[0]->getType() == "CONST_FLOAT"){
            codeout<<"\tMOV AX, "<<(symbol->getChildList())[0]->getName()<<endl;
            if(isNegated){
                codeout<<"\tNEG AX"<<endl;
                isNegated=false;
            }
            codeout<<"\tPUSH AX"<<endl;
        }

        else if(symbol->getName() == "variable"){
            string varName1="";
            if(((symbol->getChildList())[0])->getChildList().size() == 1){
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName();
                }

                else if(symbol1->getStackOffset() > 0){
                    varName1="[BP-"+to_string(symbol1->getStackOffset())+"]";
                }

                else if(symbol1->getStackOffset() < 0){
                    varName1="[BP+"+to_string((symbol1->getStackOffset())*(-1))+"]";
                }
            }

            else{
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);
                expression((((symbol->getChildList())[0])->getChildList())[2]);
                codeout<<"\tPOP SI"<<endl;
                codeout<<"\tSHL SI, 1"<<endl;

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName()+"[SI]";
                }

                else if(symbol1->getStackOffset() > 0){
                    codeout<<"\tNEG SI"<<endl;
                    codeout<<"\tADD SI, "<<symbol1->getStackOffset()<<endl;
                    codeout<<"\tNEG SI"<<endl;
                    varName1="BP[SI]";
                }

                else if(symbol1->getStackOffset() < 0){
                    codeout<<"\tSUB SI, "<<symbol1->getStackOffset()<<endl;
                    varName1="BP[SI]";
                }
            }

            codeout<<"\tMOV AX, "<<varName1<<endl;
            if(isNegated){
                codeout<<"\tNEG AX"<<endl;
                isNegated=false;
            }
            codeout<<"\tPUSH AX"<<endl;
        }

        else if(symbol->getName() == "variable INCOP"){
            string varName1="";
            if(((symbol->getChildList())[0])->getChildList().size() == 1){
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName();
                }

                else if(symbol1->getStackOffset() > 0){
                    varName1="[BP-"+to_string(symbol1->getStackOffset())+"]";
                }

                else if(symbol1->getStackOffset() < 0){
                    varName1="[BP+"+to_string((symbol1->getStackOffset())*(-1))+"]";
                }
            }

            else{
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);
                expression((((symbol->getChildList())[0])->getChildList())[2]);
                codeout<<"\tPOP SI"<<endl;
                codeout<<"\tSHL SI, 1"<<endl;

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName()+"[SI]";
                }

                else if(symbol1->getStackOffset() > 0){
                    codeout<<"\tNEG SI"<<endl;
                    codeout<<"\tADD SI, "<<symbol1->getStackOffset()<<endl;
                    codeout<<"\tNEG SI"<<endl;
                    varName1="BP[SI]";
                }

                else if(symbol1->getStackOffset() < 0){
                    codeout<<"\tSUB SI, "<<symbol1->getStackOffset()<<endl;
                    varName1="BP[SI]";
                }
            }

            codeout<<"\tMOV AX, "<<varName1<<endl;
            if(isNegated){
                codeout<<"\tNEG AX"<<endl;
                isNegated=false;
            }
            codeout<<"\tPUSH AX"<<endl;
            codeout<<"\tINC AX"<<endl;
            codeout<<"\tMOV "<<varName1<<", AX"<<endl;
        }

        else if(symbol->getName() == "variable DECOP"){
            string varName1="";
            if(((symbol->getChildList())[0])->getChildList().size() == 1){
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName();
                }

                else if(symbol1->getStackOffset() > 0){
                    varName1="[BP-"+to_string(symbol1->getStackOffset())+"]";
                }

                else if(symbol1->getStackOffset() < 0){
                    varName1="[BP+"+to_string((symbol1->getStackOffset())*(-1))+"]";
                }
            }

            else{
                string variableName=((((symbol->getChildList())[0])->getChildList())[0])->getName();
                SymbolInfo* symbol1=symbolTable->lookUp(variableName);
                expression((((symbol->getChildList())[0])->getChildList())[2]);
                codeout<<"\tPOP SI"<<endl;
                codeout<<"\tSHL SI, 1"<<endl;

                if(symbol1->getStackOffset() == 0){
                    varName1=symbol1->getName()+"[SI]";
                }

                else if(symbol1->getStackOffset() > 0){
                    codeout<<"\tNEG SI"<<endl;
                    codeout<<"\tADD SI, "<<symbol1->getStackOffset()<<endl;
                    codeout<<"\tNEG SI"<<endl;
                    varName1="BP[SI]";
                }

                else if(symbol1->getStackOffset() < 0){
                    codeout<<"\tSUB SI, "<<symbol1->getStackOffset()<<endl;
                    varName1="BP[SI]";
                }
            }

            codeout<<"\tMOV AX, "<<varName1<<endl;
            if(isNegated){
                codeout<<"\tNEG AX"<<endl;
                isNegated=false;
            }
            codeout<<"\tPUSH AX"<<endl;
            codeout<<"\tDEC AX"<<endl;
            codeout<<"\tMOV "<<varName1<<", AX"<<endl;
        }

        else if(symbol->getName() == "LPAREN expression RPAREN"){
            expression((symbol->getChildList())[1]);
        }

        else if(symbol->getName() == "ID LPAREN argument_list RPAREN"){
            argument_list((symbol->getChildList())[2]);
            codeout<<"\tCALL "<<((symbol->getChildList())[0])->getName()<<endl;
            codeout<<"\tPUSH AX"<<endl;
        }
    }


    void argument_list(SymbolInfo* symbol){
        if(symbol->getName() == "arguments"){
            arguments((symbol->getChildList())[0]);
        }
    }


    void arguments(SymbolInfo* symbol){
        if(symbol->getName() == "arguments COMMA logic_expression"){
            logic_expression((symbol->getChildList())[2]);
            arguments((symbol->getChildList())[0]);
        }

        else if(symbol->getName() == "logic_expression"){
            logic_expression((symbol->getChildList())[0]);
        }
    }


%}

%union{
    SymbolInfo* symbol;
}

%token <symbol> IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN 
%token <symbol> INCOP DECOP ASSIGNOP NOT ADDOP MULOP RELOP LOGICOP BITOP CONST_INT CONST_FLOAT CONST_CHAR ID LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON

%type <symbol> start program unit func_declaration func_definition parameter_list compound_statement 
%type <symbol> var_declaration type_specifier declaration_list statements statement expression_statement
%type <symbol> variable expression logic_expression rel_expression simple_expression term unary_expression factor argument_list arguments

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%  

start : program {
            $$ = new SymbolInfo("program", "start", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            printParseTree($$, 0);
            logout<<"start : program "<<endl;
            //symbolTable->printAll(logout);
            logout<<"Total Lines: "<<yylineno<<endl;
            logout<<"Total Errors: "<<error_count<<endl;

            start($$);

        }
        ;


program : program unit  {
            logout<<"program : program unit "<<endl;
            $$ = new SymbolInfo("program unit", "program", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

        }  
        | unit  {
            logout<<"program : unit "<<endl;
            $$ = new SymbolInfo("unit", "program", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);
        }
        ;


unit : var_declaration  {
            logout<<"unit : var_declaration "<<endl;
            $$ = new SymbolInfo("var_declaration", "unit", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | func_declaration  {
            logout<<"unit : func_declaration "<<endl;
            $$ = new SymbolInfo("func_declaration", "unit", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);
        }
        | func_definition   {
            logout<<"unit : func_definition "<<endl;
            $$ = new SymbolInfo("func_definition", "unit", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);
        }
        ;


func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
            logout<<"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON "<<endl;
            $$ = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON", "func_declaration", $1->getStartLine(), $6->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);
            $$->addChild($6);

            SymbolInfo* symbol=symbolTable->lookUp($2->getName());

            if(symbol == NULL){
                SymbolInfo* tmp=new SymbolInfo($2->getName(), $2->getType(), $1->getStartLine(), $6->getEndLine());
                tmp->setDataType($1->getDataType());
                tmp->setVariableOrFunction($$->getType());

                //vector<pair<SymbolInfo*, SymbolInfo*> > param = $4->getParametersList();
                for(pair<SymbolInfo*, SymbolInfo*> tmp1: param){
                    tmp->addParameter(tmp1);
                }

                symbolTable->insertKey(*tmp, logout);
            }

            else{

                if(symbol->getVariableOrFunction() == "variable"){
                    error_count++;
                    errorout<<"Line# "<<$2->getStartLine()<<": '"<<symbol->getName()<<"' redeclared as different kind of symbol"<<endl;
                }

                else{
                    error_count++;
                    errorout<<"Line# "<<$2->getStartLine()<<": Redeclaration of "<<symbol->getName()<<" function"<<endl;
                }

            }

            if(param.size() > 0){
                param.clear();
            }

        }
        | type_specifier ID LPAREN RPAREN SEMICOLON {
            logout<<"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON "<<endl;
            $$ = new SymbolInfo("type_specifier ID LPAREN RPAREN SEMICOLON", "func_declaration", $1->getStartLine(), $5->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);

            SymbolInfo* symbol=symbolTable->lookUp($2->getName());

            if(symbol == NULL){
                SymbolInfo* tmp=new SymbolInfo($2->getName(), $2->getType(), $1->getStartLine(), $5->getEndLine());
                tmp->setDataType($1->getDataType());
                tmp->setVariableOrFunction($$->getType());
                symbolTable->insertKey(*tmp, logout);
            }

            else{

                if(symbol->getVariableOrFunction() == "variable"){
                    error_count++;
                    errorout<<"Line# "<<$2->getStartLine()<<": '"<<symbol->getName()<<"' redeclared as different kind of symbol"<<endl;
                }

                else{
                    error_count++;
                    errorout<<"Line# "<<$2->getStartLine()<<": Redeclaration of "<<symbol->getName()<<" function"<<endl;
                }

            }

        }
        ;


func_definition : type_specifier ID LPAREN parameter_list RPAREN {giveFunctionDefinitionWithParameters($1, $2);} compound_statement {
        logout<<"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl;
        $$ = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN compound_statement", "func_definition", $1->getStartLine(), $7->getEndLine());
        $$->addChild($1);
        $$->addChild($2);
        $$->addChild($3);
        $$->addChild($4);
        $$->addChild($5);
        $$->addChild($7);

        /*
        SymbolInfo* tmp1 = new SymbolInfo($2->getName(), "FUNCTION", $1->getType(), "func_definition", "", $1->getStartLine(), $2->getEndLine());
        tmp1->setParametersList(param);

        symbolTable->printCur(logout);

        bool isInserted = symbolTable->insertKey(*tmp1, logout);
        logout<<tmp1->getName()<<" "<<tmp1->getType()<<endl;
        logout<<isInserted<<endl;
        // if(!isInserted){
        //     logout<<"Function definition exists"<<endl;
        // }

        //symbolTable->printAll(logout);
        symbolTable->printCur(logout);


        */
        /*
        SymbolInfo* tmp=new SymbolInfo($2->getName(), $2->getType(), $1->getStartLine(), $6->getEndLine());
        tmp->setDataType($1->getType());
        tmp->setVariableOrFunction("func_definition");

        //param = paramList->getParametersList();
        logout<<"MOTTTTT"<<endl;
        for(pair<SymbolInfo*, SymbolInfo*> tmp1: param){
            tmp->addParameter(tmp1);
        }

        SymbolInfo* symbol=symbolTable->lookUp($2->getName());

            if(symbol == NULL){

                symbolTable->insertKey(*tmp);

            }

            else{

                if(symbol->getVariableOrFunction() == "variable"){
                    error_count++;
                    errorout<<"Line# "<<$2->getStartLine()<<": '"<<symbol->getName()<<"' redeclared as different kind of symbol"<<endl;
                }

                else{

                    if(symbol->getVariableOrFunction() == "func_declaration"){

                        vector<pair<SymbolInfo*, SymbolInfo*> > param1 = symbol->getParametersList();
                        //vector<pair<SymbolInfo*, SymbolInfo*> > param2 = paramList->getParametersList();

                        bool flag=true;
                        if(symbol->getDataType() != $1->getName()){
                            error_count++;
                            errorout<<"Line# "<<$1->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                            flag=false;
                        }

                        else if(param1.size() != param.size()){
                            error_count++;
                            errorout<<"Line# "<<$1->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                            flag=false;
                        }

                        for(int i=0;i<param1.size();i++){
                            if((param1[i].first)->getType() != (param[i].first)->getType()){
                                error_count++;
                                errorout<<"Line# "<<$1->getStartLine()<<": Conflicting types for '"<<symbol->getName()<<"'"<<endl;
                                flag=false;
                                break;
                            }
                        }

                        if(flag){
                            symbolTable->insertKey(*tmp);
                        }

                    }

                    else{
                        error_count++;
                        errorout<<"Line# "<<$1->getStartLine()<<": Redefinition of function '"<<symbol->getName()<<"'"<<endl;
                    }
                }

            }

            logout<<"Com7"<<endl;
            symbolTable->printAll(logout);
            */

        }
        | type_specifier ID LPAREN RPAREN {giveFunctionDefinitionWithoutParameters($1, $2);} compound_statement    {
            logout<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl;
            $$ = new SymbolInfo("type_specifier ID LPAREN RPAREN compound_statement", "func_definition", $1->getStartLine(), $6->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($6);

        }
        | type_specifier ID LPAREN error {  if(errorLine == -1){
                                            errorLine = yylineno;
                                            error_count++;
                                            errorout<<"Line# "<<$3->getStartLine()<<": Syntax error at parameter list of function definition"<<endl;
                                            logout<<"Error at line no "<<errorLine<<" : syntax error"<<endl;
                                            param.clear();
                                            }} RPAREN {errorLine = -1;} compound_statement    {
            logout<<"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl;
            $$ = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN compound_statement", "func_definition", $1->getStartLine(), $8->getEndLine());
            SymbolInfo* symbol1 = new SymbolInfo("error", "parameter_list", $3->getEndLine(), $6->getStartLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild(symbol1);
            $$->addChild($6);
            $$->addChild($8);

            errorLine = -1;

        }
        ;       


parameter_list : parameter_list COMMA type_specifier ID {
            logout<<"parameter_list : parameter_list COMMA type_specifier ID "<<endl;
            $$ = new SymbolInfo("parameter_list COMMA type_specifier ID", "parameter_list", $1->getStartLine(), $4->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);

            for(pair<SymbolInfo*, SymbolInfo*> tmp1: $1->getParametersList()){
                $$->addParameter(tmp1);
            }
            //logout<<"Com3"<<endl;
            $4->setDataType($3->getDataType());
            $$->addParameter({$3, $4});
            param.push_back({$3, $4});
            //symbolTable->printAll(logout);

        }
        | parameter_list COMMA type_specifier   {
            logout<<"parameter_list : parameter_list COMMA type_specifier "<<endl;
            $$ = new SymbolInfo("parameter_list COMMA type_specifier", "parameter_list", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            for(pair<SymbolInfo*, SymbolInfo*> tmp1: $1->getParametersList()){
                $$->addParameter(tmp1);
            }
            SymbolInfo* symbol = new SymbolInfo("", "", $3->getStartLine(), $3->getEndLine());
            symbol->setDataType($3->getDataType());
            $$->addParameter({$3, symbol});
            param.push_back({$3, symbol});
            //logout<<"Com4"<<endl;
            //symbolTable->printAll(logout);

        }
        | type_specifier ID {
            logout<<"parameter_list : type_specifier ID "<<endl;
            $$ = new SymbolInfo("type_specifier ID", "parameter_list", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

            $2->setDataType($1->getDataType());
            $$->addParameter({$1, $2});
            param.push_back({$1, $2});
            //logout<<"Com5"<<endl;
            //symbolTable->printAll(logout);

        }
        | type_specifier    {
            logout<<"parameter_list : type_specifier "<<endl;
            $$ = new SymbolInfo("type_specifier", "parameter_list", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            SymbolInfo* symbol = new SymbolInfo("", "", $1->getStartLine(), $1->getEndLine());
            symbol->setDataType($1->getDataType());
            $$->addParameter({$1, symbol});
            param.push_back({$1, symbol});
            //logout<<"Com6"<<endl;
            //symbolTable->printAll(logout);
        }
        ;


compound_statement : LCURL {createNewScope();} statements RCURL {
            logout<<"compound_statement : LCURL statements RCURL "<<endl;
            $$ = new SymbolInfo("LCURL statements RCURL", "compound_statement", $1->getStartLine(), $4->getEndLine());
            $$->addChild($1);
            $$->addChild($3);
            $$->addChild($4);

            //logout<<"Com1"<<endl;
            symbolTable->printAll(logout);
            symbolTable->exitScope();

        }
        | LCURL {createNewScope();} RCURL   {
            logout<<"compound_statement : LCURL RCURL "<<endl;
            $$ = new SymbolInfo("LCURL RCURL", "compound_statement", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($3);

            //logout<<"Com2"<<endl;
            symbolTable->printAll(logout);
            symbolTable->exitScope();
        }
        ;


var_declaration : type_specifier declaration_list SEMICOLON {
            logout<<"var_declaration : type_specifier declaration_list SEMICOLON "<<endl;
            $$ = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            for(SymbolInfo* tmp1: variableList){

                if(variableType == "VOID"){
                    error_count++;
                    errorout<<"Line# "<<tmp1->getStartLine()<<": Variable or field '"<<tmp1->getName()<<"' declared void"<<endl;
                }

                else{
                tmp1->setDataType(variableType);

                SymbolInfo* symbol1 = symbolTable->getCurrentScopeTable()->lookUp(tmp1->getName());

                if(symbol1 != NULL){
                    if(symbol1->getDataType() == tmp1->getDataType() && symbol1->getVariableOrFunction() == tmp1->getVariableOrFunction()){
                        error_count++;
                        errorout<<"Line# "<<tmp1->getStartLine()<<": Redeclaration of variable '"<<tmp1->getName()<<"'"<<endl;
                    }

                    else if(symbol1->getVariableOrFunction() != tmp1->getVariableOrFunction()){
                        error_count++;
                        errorout<<"Line# "<<tmp1->getStartLine()<<": '"<<tmp1->getName()<<"' redeclared as different kind of symbol"<<endl;
                    }

                    else if(symbol1->getDataType() != tmp1->getDataType()){
                        error_count++;
                        errorout<<"Line# "<<tmp1->getStartLine()<<": Conflicting types for'"<<tmp1->getName()<<"'"<<endl;
                    }
                    
                }

                symbolTable->insertKey(*tmp1, logout);
                }
            }

            variableList.clear();
            variableType="";
        }
        | type_specifier error {if(errorLine == -1){
                                    errorLine = yylineno;
                                    logout<<"Error at line no "<<errorLine<<" : syntax error"<<endl;
                                    }} SEMICOLON    {

            error_count++;
            errorout<<"Line# "<<errorLine<<": Syntax error at declaration list of variable declaration"<<endl;
            logout<<"var_declaration : type_specifier declaration_list SEMICOLON "<<endl;
            $$ = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration", $1->getStartLine(), $4->getEndLine());
            SymbolInfo* symbol1 = new SymbolInfo("error", "declaration_list", errorLine, errorLine);
            $$->addChild($1);
            $$->addChild(symbol1);
            $$->addChild($4);

            errorLine = -1;
            variableList.clear();
            variableType="";
        }
        ;


type_specifier : INT    {
            logout<<"type_specifier : INT "<<endl;
            $$ = new SymbolInfo("INT", "type_specifier", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType("INT");
            variableType = "INT";

        }
        | FLOAT {
            logout<<"type_specifier : FLOAT "<<endl;
            $$ = new SymbolInfo("FLOAT", "type_specifier", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType("FLOAT");
            variableType = "FLOAT";

        }
        | VOID  {
            logout<<"type_specifier : VOID "<<endl;
            $$ = new SymbolInfo("VOID", "type_specifier", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType("VOID");
            variableType = "VOID";

        }
        ;

declaration_list : declaration_list COMMA ID    {
            logout<<"declaration_list : declaration_list COMMA ID "<<endl;
            $$ = new SymbolInfo("declaration_list COMMA ID", "declaration_list", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            variableList.push_back($3);
            if(symbolTable->getCurrentScopeTable()->getId() == 1){
                globalVarList.push_back($3);
            }

        }
        | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE   {
            logout<<"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE "<<endl;
            $$ = new SymbolInfo("declaration_list COMMA ID LSQUARE CONST_INT RSQUARE", "declaration_list", $1->getStartLine(), $6->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);
            $$->addChild($6);

            $3->setArraySize($5->getName());
            variableList.push_back($3);
            if(symbolTable->getCurrentScopeTable()->getId() == 1){
                globalVarList.push_back($3);
            }
        }
        | ID    {
            logout<<"declaration_list : ID "<<endl;
            $$ = new SymbolInfo("ID", "declaration_list", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            variableList.push_back($1);
            if(symbolTable->getCurrentScopeTable()->getId() == 1){
                globalVarList.push_back($1);
            }

        }
        | ID LSQUARE CONST_INT RSQUARE  {
            logout<<"declaration_list : ID LSQUARE CONST_INT RSQUARE "<<endl;
            $$ = new SymbolInfo("ID LSQUARE CONST_INT RSQUARE", "declaration_list", $1->getStartLine(), $4->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);

            $1->setArraySize($3->getName());
            variableList.push_back($1);
            if(symbolTable->getCurrentScopeTable()->getId() == 1){
                globalVarList.push_back($1);
            }

        }
        ;


statements : statement  {
            logout<<"statements : statement "<<endl;
            $$ = new SymbolInfo("statement", "statements", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | statements statement  {
            logout<<"statements : statements statement "<<endl;
            $$ = new SymbolInfo("statements statement", "statements", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

        }
        ;

statement : var_declaration {
            logout<<"statement : var_declaration "<<endl;
            $$ = new SymbolInfo("var_declaration", "statement", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | expression_statement  {
            logout<<"statement : expression_statement "<<endl;
            $$ = new SymbolInfo("expression_statement", "statement", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | compound_statement    {
            logout<<"statement : compound_statement "<<endl;
            $$ = new SymbolInfo("compound_statement", "statement", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | FOR LPAREN expression_statement expression_statement expression RPAREN statement  {
            logout<<"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl;
            $$ = new SymbolInfo("FOR LPAREN expression_statement expression_statement expression RPAREN statement", "statement", $1->getStartLine(), $7->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);
            $$->addChild($6);
            $$->addChild($7);

        }
        | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE{
            logout<<"statement : IF LPAREN expression RPAREN statement "<<endl;
            $$ = new SymbolInfo("IF LPAREN expression RPAREN statement", "statement", $1->getStartLine(), $5->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);

        }
        | IF LPAREN expression RPAREN statement ELSE statement  {
            logout<<"statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl;
            $$ = new SymbolInfo("IF LPAREN expression RPAREN statement ELSE statement", "statement", $1->getStartLine(), $7->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);
            $$->addChild($6);
            $$->addChild($7);

        }
        | WHILE LPAREN expression RPAREN statement  {
            logout<<"statement : WHILE LPAREN expression RPAREN statement "<<endl;
            $$ = new SymbolInfo("WHILE LPAREN expression RPAREN statement", "statement", $1->getStartLine(), $5->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);

        }
        | PRINTLN LPAREN ID RPAREN SEMICOLON    {
            logout<<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl;
            $$ = new SymbolInfo("PRINTLN LPAREN ID RPAREN SEMICOLON", "statement", $1->getStartLine(), $5->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);
            $$->addChild($5);

            SymbolInfo* symbol1 = symbolTable->lookUp($3->getName());
            if(symbol1 == NULL){
                error_count++;
                errorout<<"Line# "<<$3->getStartLine()<<": Undeclared variable '"<<$3->getName()<<"'"<<endl;
            }

        }
        | RETURN expression SEMICOLON   {
            logout<<"statement : RETURN expression SEMICOLON "<<endl;
            $$ = new SymbolInfo("RETURN expression SEMICOLON", "statement", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

        }
        ;


expression_statement : SEMICOLON    {
            logout<<"expression_statement : SEMICOLON "<<endl;
            $$ = new SymbolInfo("SEMICOLON", "expression_statement", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

        }
        | expression SEMICOLON  {
            logout<<"expression_statement : expression SEMICOLON "<<endl;
            $$ = new SymbolInfo("expression SEMICOLON", "expression_statement", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

        }
        | error {if(errorLine == -1)
                    errorLine = yylineno;} SEMICOLON   {

            error_count++;
            errorout<<"Line# "<<errorLine<<": Syntax error at expression of expression statement"<<endl;
            logout<<"expression_statement : expression SEMICOLON "<<endl;
            $$ = new SymbolInfo("expression SEMICOLON", "expression_statement", $3->getStartLine(), $3->getEndLine());
            SymbolInfo* symbol1 = new SymbolInfo("error", "expression", errorLine, errorLine);
            $$->addChild(symbol1);
            $$->addChild($3);

            errorLine = -1;
        }
        ;


variable : ID   {
            logout<<"variable : ID "<<endl;
            $$ = new SymbolInfo("ID", "variable", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            SymbolInfo* symbol1 = symbolTable->lookUp($1->getName());
            if(symbol1 == NULL){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": Undeclared variable '"<<$1->getName()<<"'"<<endl;
            }

            else{
                // if(symbol1->isArray()){
                //     error_count++;
                //     errorout<<"Line# "<<$1->getStartLine()<<": '"<<$1->getName()<<"' is an array"<<endl;
                // }

                $1->setDataType(symbol1->getDataType());
                $1->setArraySize(symbol1->getArraySize());
            }

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        | ID LSQUARE expression RSQUARE {
            logout<<"variable : ID LSQUARE expression RSQUARE "<<endl;
            $$ = new SymbolInfo("ID LSQUARE expression RSQUARE", "variable", $1->getStartLine(), $4->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);

            SymbolInfo* symbol1 = symbolTable->lookUp($1->getName());
            if(symbol1 == NULL){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": Undeclared variable '"<<$1->getName()<<"'"<<endl;
            }

            else{
                $1->setDataType(symbol1->getDataType());
                $1->setArraySize(symbol1->getArraySize());
                if(!symbol1->isArray()){
                    error_count++;
                    errorout<<"Line# "<<$1->getStartLine()<<": '"<<$1->getName()<<"' is not an array"<<endl;
                }

                if($3->getDataType() != "INT"){
                    error_count++;
                    errorout<<"Line# "<<$3->getStartLine()<<": Array subscript is not an integer"<<endl;
                }
            }

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        ;


expression : logic_expression   {
            logout<<"expression : logic_expression "<<endl;
            $$ = new SymbolInfo("logic_expression", "expression", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line "<<$1->getStartLine()<<" Hello 11: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        | variable ASSIGNOP logic_expression    {
            logout<<"expression : variable ASSIGNOP logic_expression "<<endl;
            $$ = new SymbolInfo("variable ASSIGNOP logic_expression", "expression", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            //SymbolInfo* symbol1 = symbolTable->lookUp($3->getName());
            //errorout<<"Line "<<$1->getStartLine()<<$3->getName()<<" Hello 11: "<<$3->getDataType()<<endl;
        
            if($3->getDataType() == "VOID"){
                error_count++;
                errorout<<"Line# "<<$3->getStartLine()<<": Void cannot be used in expression "<<endl;
            }

            if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT"){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": Warning: possible loss of data in assignment of FLOAT to INT"<<endl;
            }

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        ;


logic_expression : rel_expression   {
            logout<<"logic_expression : rel_expression "<<endl;
            $$ = new SymbolInfo("rel_expression", "logic_expression", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line "<<$1->getStartLine()<<" Hello 10: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        | rel_expression LOGICOP rel_expression {
            logout<<"logic_expression : rel_expression LOGICOP rel_expression "<<endl;
            $$ = new SymbolInfo("rel_expression LOGICOP rel_expression", "logic_expression", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            $$->setDataType("INT");

        }
        ;


rel_expression : simple_expression  {
            logout<<"rel_expression : simple_expression "<<endl;
            $$ = new SymbolInfo("simple_expression", "rel_expression", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line "<<$1->getStartLine()<<" Hello 9: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        | simple_expression RELOP simple_expression {
            logout<<"rel_expression : simple_expression RELOP simple_expression "<<endl;
            $$ = new SymbolInfo("simple_expression RELOP simple_expression", "rel_expression", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT"){
                $1->setDataType("FLOAT");
            }

            else if($1->getDataType() == "FLOAT" && $3->getDataType() =="INT"){
                $3->setDataType("FLOAT");
            }

            $$->setDataType("INT");

        }
        ;


simple_expression : term    {
            logout<<"simple_expression : term "<<endl;
            $$ = new SymbolInfo("term", "simple_expression", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line "<<$1->getStartLine()<<" Hello 8: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

            value=-1;

        }
        | simple_expression ADDOP term  {
            logout<<"simple_expression : simple_expression ADDOP term "<<endl;
            $$ = new SymbolInfo("simple_expression ADDOP term", "simple_expression", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            if($1->getDataType() == "VOID" || $3->getDataType() == "VOID"){
                error_count++;
                errorout<<"Line# "<<$3->getStartLine()<<": Void cannot be used in expression "<<endl;
            }

            if($1->getDataType() == $3->getDataType()){
                $$->setDataType($1->getDataType());
            }

            else if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT"){
                $1->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }

            else if($3->getDataType() == "INT" && $1->getDataType() == "FLOAT"){
                $3->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }

            else if($1->getDataType() != "VOID"){
                $$->setDataType($1->getDataType());
            }

            else{
                $$->setDataType($3->getDataType());
            }

            value=-1;

        }
        ;


term : unary_expression {
            logout<<"term : unary_expression "<<endl;
            $$ = new SymbolInfo("unary_expression", "term", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line "<<$1->getStartLine()<<" Hello 7: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

            value=-1;

        }
        | term MULOP unary_expression   {
            logout<<"term : term MULOP unary_expression "<<endl;
            $$ = new SymbolInfo("term MULOP unary_expression", "term", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            //errorout<<"Hello 4: "<<$3->getDataType()<<endl;

            if($1->getDataType() == "VOID" || $3->getDataType() == "VOID"){
                error_count++;
                errorout<<"Line# "<<$3->getStartLine()<<": Void cannot be used in expression "<<endl;
            }

            if($2->getName() == "%"){

                if(value == 0){
                    error_count++;
                    errorout<<"Line# "<<$1->getStartLine()<<": Warning: division by zero i=0f=1Const=0"<<endl;
                }

                if($1->getDataType() != "INT" || $3->getDataType() != "INT"){
                    error_count++;
                    errorout<<"Line# "<<$1->getStartLine()<<": Operands of modulus must be integers "<<endl;
                }

                $1->setDataType("INT");
                $3->setDataType("INT");

            }

            if($2->getName() == "/" && value == 0){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": Warning: division by zero i=0f=1Const=0"<<endl;
            }

            if($1->getDataType() == $3->getDataType()){
                $$->setDataType($1->getDataType());
            }

            else if($1->getDataType() == "INT" && $3->getDataType() == "FLOAT"){
                $1->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }

            else if($3->getDataType() == "INT" && $1->getDataType() == "FLOAT"){
                $3->setDataType("FLOAT");
                $$->setDataType("FLOAT");
            }

            else if($1->getDataType() != "VOID"){
                $$->setDataType($1->getDataType());
            }

            else{
                $$->setDataType($3->getDataType());
            }

        }
        ;


unary_expression : ADDOP unary_expression   {
            logout<<"unary_expression : ADDOP unary_expression "<<endl;
            $$ = new SymbolInfo("ADDOP unary_expression", "unary_expression", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());
            $$->setVariableOrFunction($2->getVariableOrFunction());
            $$->setParametersList($2->getParametersList());
            
            value=-1;

        }
        | NOT unary_expression  {
            logout<<"unary_expression : NOT unary_expression "<<endl;
            $$ = new SymbolInfo("NOT unary_expression", "unary_expression", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());
            $$->setVariableOrFunction($2->getVariableOrFunction());
            $$->setParametersList($2->getParametersList());

            value=-1;

        }
        | factor    {
            logout<<"unary_expression : factor "<<endl;
            $$ = new SymbolInfo("factor", "unary_expression", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Line: <<yylineno<<Hello 6: "<<$1->getDataType()<<endl;

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        ;


factor : variable   {
            logout<<"factor : variable "<<endl;
            $$ = new SymbolInfo("variable", "factor", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType($1->getDataType());
            $$->setArraySize($1->getArraySize());
            $$->setVariableOrFunction($1->getVariableOrFunction());
            $$->setParametersList($1->getParametersList());

        }
        | ID LPAREN argument_list RPAREN    {
            logout<<"factor : ID LPAREN argument_list RPAREN "<<endl;
            $$ = new SymbolInfo("ID LPAREN argument_list RPAREN", "factor", $1->getStartLine(), $4->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);
            $$->addChild($4);

            SymbolInfo* symbol1 = symbolTable->lookUp($1->getName());
            if(symbol1 == NULL){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": Undeclared function '"<<$1->getName()<<"'"<<endl;
            }

            else if(symbol1->getVariableOrFunction() == "variable"){
                error_count++;
                errorout<<"Line# "<<$1->getStartLine()<<": '"<<$1->getName()<<"' is not a function"<<endl;
            }

            else{
                
                $1->setDataType(symbol1->getDataType());
                if($1->getVariableOrFunction() == "func_declaration"){
                    error_count++;
                    errorout<<"Line# "<<$1->getStartLine()<<": '"<<$1->getName()<<"' is not defined"<<endl;
                }

                else{
                    if(symbol1->getParametersList().size() < argumentList.size()){
                        error_count++;
                        errorout<<"Line# "<<$1->getStartLine()<<": Too many arguments to function '"<<$1->getName()<<"'"<<endl;
                    }

                    else if(symbol1->getParametersList().size() > argumentList.size()){
                        error_count++;
                        errorout<<"Line# "<<$1->getStartLine()<<": Too few arguments to function '"<<$1->getName()<<"'"<<endl;
                    }

                    else{
                        //errorout<<"Hello1"<<endl;
                        vector<pair<SymbolInfo*, SymbolInfo*> > param1 = symbol1->getParametersList();

                        for(int i=0; i<argumentList.size(); i++){
                            //typeList.push_back(param1[i].first);
                            //errorout<<(param1[i].second)->getDataType()<<"   "<<argumentList[i]->getDataType()<<endl;
                            //errorout<<"ArgumentList[i] is an array: "<<argumentList[i]->getArraySize()<<endl;
                            if((param1[i].second)->getDataType() != argumentList[i]->getDataType()){
                                //errorout<<(param1[i].first)->getType()<<"   "<<argumentList[i]->getDataType()<<endl;
                                error_count++;
                                errorout<<"Line# "<<argumentList[i]->getStartLine()<<": Type mismatch for argument "<<i+1<<" of '"<<$1->getName()<<"'"<<endl;
                            }
                        }
                    }
                }

                //errorout<<"Line "<<yylineno<<"Hello 5: "<<$1->getDataType()<<endl;

                $$->setDataType($1->getDataType());
                $$->setVariableOrFunction($1->getVariableOrFunction());
                $$->setArraySize($1->getArraySize());
                $$->setParametersList(symbol1->getParametersList());
            }

            argumentList.clear();

        }
        | LPAREN expression RPAREN  {
            logout<<"factor : LPAREN expression RPAREN "<<endl;
            $$ = new SymbolInfo("LPAREN expression RPAREN", "factor", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());
            $$->setVariableOrFunction($2->getVariableOrFunction());
            $$->setParametersList($2->getParametersList());

        }
        | CONST_INT {
            logout<<"factor : CONST_INT "<<endl;
            $$ = new SymbolInfo("CONST_INT", "factor", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType("INT");
            value=stoi($1->getName());

        }
        | CONST_FLOAT   {
            logout<<"factor : CONST_FLOAT "<<endl;
            $$ = new SymbolInfo("CONST_FLOAT", "factor", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            $$->setDataType("FLOAT");
            value=stoi($1->getName());

        }
        | variable INCOP    {
            logout<<"factor : variable INCOP "<<endl;
            $$ = new SymbolInfo("variable INCOP", "factor", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());

        }
        | variable DECOP    {
            logout<<"factor : variable DECOP "<<endl;
            $$ = new SymbolInfo("variable DECOP", "factor", $1->getStartLine(), $2->getEndLine());
            $$->addChild($1);
            $$->addChild($2);

            $$->setDataType($2->getDataType());
            $$->setArraySize($2->getArraySize());

        }
        ;


argument_list : arguments   {
            logout<<"argument_list : arguments "<<endl;
            $$ = new SymbolInfo("arguments", "argument_list", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);
        }
        |       {
            logout<<"argument_list :  "<<endl;
            $$ = new SymbolInfo("", "argument_list", yylineno, yylineno);

        }
        ;


arguments : arguments COMMA logic_expression    {
            logout<<"arguments : arguments COMMA logic_expression "<<endl;
            $$ = new SymbolInfo("arguments COMMA logic_expression", "arguments", $1->getStartLine(), $3->getEndLine());
            $$->addChild($1);
            $$->addChild($2);
            $$->addChild($3);

            //errorout<<"Hello 3: "<<$3->getDataType()<<endl;

            argumentList.push_back($3);

        }
        | logic_expression  {
            logout<<"arguments : logic_expression "<<endl;
            $$ = new SymbolInfo("logic_expression", "arguments", $1->getStartLine(), $1->getEndLine());
            $$->addChild($1);

            //errorout<<"Hello 2: "<<$1->getDataType()<<endl;

            argumentList.push_back($1);

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
	
	logout.open("1905097_log.txt");
    parseTreeOut.open("1905097_parsetree.txt");
    errorout.open("1905097_error.txt");
	//tokenout.open("1905097_token.txt");

	//scopeTableID++;
	//symbolTable.enterScope(scopeTableID, bucketLength, logout);

	yyin= fin;
    //yylineno=1;
    //symbolTable->enterScope(++scopeTableID, bucketLength);
	yyparse();
	//st.print();
	fclose(yyin);
    //fclose(fin);
	//tokenout.close();
	logout.close();
    parseTreeOut.close();
    errorout.close();
	return 0;
}