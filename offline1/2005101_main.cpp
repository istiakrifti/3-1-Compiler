#include<bits/stdc++.h>
#include "2005101_SymbolTable.cpp"
using namespace std;

int main()
{
    ifstream MyFile("input.txt");

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
        string str,str1,str2;
        int c=0;
        switch(ch)
        {
            case 'I':
                
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    if(c==0) str1=str;
                    if(c==1) str2=str;
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                countLine++;
                cout<<"\t";
                out<<"\t";
                if(c!=2) 
                {
                    cout<<"Wrong number of arugments for the command I"<<endl;
                    out<<"Wrong number of arugments for the command I"<<endl;
                }
                else
                s.Insert(str1,str2);
                c=0;
                break;
            case 'L':
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    if(c==0) str1=str;
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                countLine++;
                cout<<"\t";
                out<<"\t";
                if(c!=1) 
                {
                    cout<<"Wrong number of arugments for the command L"<<endl;
                    out<<"Wrong number of arugments for the command L"<<endl;
                }
                else
                    s.LookUp(str1);
                c=0;    
                break;
            case 'D':
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    if(c==0) str1=str;
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                countLine++;
                cout<<"\t";
                out<<"\t";
                if(c!=1) 
                {
                    cout<<"Wrong number of arugments for the command D"<<endl;
                    out<<"Wrong number of arugments for the command D"<<endl;
                }
                else s.Remove(str1);
                c=0;
                break;
            case 'P':
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    if(c==0) str1=str;
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                if(c!=1) 
                {
                    cout<<"Wrong number of arugments for the command P"<<endl;
                    out<<"Wrong number of arugments for the command P"<<endl;
                }
                countLine++;
                if(str1=="C")
                    s.PrintCurrentScopeTable();
                else if(str1=="A")
                    s.PrintAllScopeTable();
                else
                {
                    cout<<"\t";
                    out<<"\t";
                    cout<<"Invalid argument for the command P"<<endl;
                    out<<"Invalid argument for the command P"<<endl;
                }
                c=0;
                break;
            case 'S':
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                countLine++;
                cout<<"\t";
                out<<"\t";
                if(c!=0) 
                {
                    cout<<"Invalid argument for the command S"<<endl;
                    out<<"Invalid argument for the command S"<<endl;
                }
                else s.EnterScope();
                c=0;
                break;
            case 'E':
                cout<<"Cmd "<<countLine<<": "<<ch<<" ";
                out<<"Cmd "<<countLine<<": "<<ch<<" ";
                while(ss>>str)
                {
                    cout<<str<<" ";
                    out<<str<<" ";
                    c++;
                }
                cout<<endl;
                out<<endl;
                countLine++;
                
                if(c!=0) 
                {
                    cout<<"Invalid argument for the command E"<<endl;
                    out<<"Invalid argument for the command E"<<endl;
                }
                else s.ExitScope();
                c=0;
                break;
            case 'Q':
                cout<<"Cmd "<<countLine<<": "<<ch<<endl;
                out<<"Cmd "<<countLine<<": "<<ch<<endl;
                break;
            default:
                cout<<"\t";
                out<<"\t";
                cout<<"Invalid input"<<endl;
                out<<"Invalid input"<<endl;
            
        }
        
    }
    
    return 0;
}