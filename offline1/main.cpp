#include<bits/stdc++.h>
#include "SymbolTable.cpp"
using namespace std;

int main()
{
    ifstream MyFile("in.txt");
    // ofstream out("out.txt");

    string line;
    getline(MyFile,line);
    istringstream ss(line);
    int n;
    ss>>n;
    SymbolTable s(n);
    
    int countLine=1;
    string line1;
    while(getline(MyFile,line1))
    {
        istringstream ss(line1);
        char ch;
        ss>>ch;
        string str1,str2;
        ss>>str1;
        ss>>str2;
        switch(ch)
        {
            case 'I':
                cout<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<" "<<str2<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<" "<<str2<<endl;
                countLine++;
                cout<<"        ";
                out<<"        ";
                if(str2.empty()) 
                {
                    cout<<"Invalid argument for the command I"<<endl;
                    out<<"Invalid argument for the command I"<<endl;
                }
                else
                s.Insert(str1,str2);
                break;
            case 'L':
                cout<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<" "<<str2<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<" "<<str2<<endl;
                countLine++;
                cout<<"        ";
                out<<"        ";
                if(!str2.empty())
                {
                    cout<<"Wrong number of arugments for the command L"<<endl;
                    out<<"Wrong number of arugments for the command L"<<endl;
                } 
                else
                    s.LookUp(str1);
                break;
            case 'D':
                cout<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<endl;
                countLine++;
                cout<<"        ";
                out<<"        ";
                if(str1.empty()) 
                {
                    cout<<"Wrong number of arugments for the command D"<<endl;
                    out<<"Wrong number of arugments for the command D"<<endl;
                }
                else s.Remove(str1);
                break;
            case 'P':
                cout<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<" "<<str1<<endl;
                countLine++;
                if(str1=="C")
                    s.PrintCurrentScopeTable();
                else if(str1=="A")
                    s.PrintAllScopeTable();
                else
                {
                    cout<<"        Invalid argument for the command P"<<endl;
                    out<<"        Invalid argument for the command P"<<endl;
                }
                break;
            case 'S':
                cout<<"Cmd "<<countLine<<": "<<ch<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<endl;
                countLine++;
                cout<<"        ";
                out<<"        ";
                if(!str1.empty()) 
                {
                    cout<<"Invalid argument for the command S"<<endl;
                    out<<"Invalid argument for the command S"<<endl;
                }
                else s.EnterScope();
                break;
            case 'E':
                cout<<"Cmd "<<countLine<<": "<<ch<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<endl;
                countLine++;
                
                if(!str1.empty()) 
                {
                    cout<<"Invalid argument for the command E"<<endl;
                    out<<"Invalid argument for the command E"<<endl;
                }
                else s.ExitScope();
                break;
            case 'Q':
                cout<<"Cmd "<<countLine<<": "<<ch<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<endl;
                countLine++;
                
                if(!str1.empty()) 
                {
                    cout<<"Invalid argument for the command Q"<<endl;
                    out<<"Invalid argument for the command Q"<<endl;
                }
                else s.ExitScope(1);
                break;
            default:
                cout<<"Invalid input"<<endl;
                out<<"Invalid input"<<endl;
            
        }
        
    }
    // SymbolTable s(7);
    // s.Insert("FOO","FUNCTION");
    // s.Insert("i","VAR");
    // s.LookUp("i");
    // s.LookUp("j");
    // s.Insert("23","NUMBER");
    // s.PrintCurrentScopeTable();
    // s.Remove("i");
    // s.Remove("j");
    // s.PrintAllScopeTable();
    
    // else cout<<"F"<<endl;
    // s.PrintCurrentScopeTable();
    // s.EnterScope();
    // s.Insert("<=","RELOP");
    // s.Insert("==","RELOP");
    // s.PrintAllScopeTable();
    
    // s.EnterScope();
    // s.ExitScope();
    // s.EnterScope();
    // s.ExitScope();
    // s.ExitScope();
    // s.ExitScope();
    // s.EnterScope();
    // s.ExitScope();
    // s.EnterScope();
    // s.EnterScope();
    // s.EnterScope();
    // s.ExitScope();
    // s.ExitScope();
    // s.EnterScope();

    // if(s.Insert("J","VAR")) cout<<"ytyuu"<<endl;
    // if(s.Insert("20","NUMBER")) cout<<"ytyuu"<<endl;
    // s.PrintCurrentScopeTable();
    // s.LookUp("m");
    return 0;
}