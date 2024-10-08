#include<bits/stdc++.h>
#include "2005101_ScopeTable.cpp"
using namespace std;

class SymbolTable
{
private:
    int bucket;
    int globalId;
    ScopeTable *currentScope;
    
public:

    SymbolTable(int n)
    {
        bucket = n;
        currentScope = new ScopeTable(n);
        currentScope->setParent(0);
        globalId = 1;
        currentScope->setId(to_string(globalId));
        // cout<<"\t";
        // out<<"\t";
        // cout<<"ScopeTable# "<<currentScope->getId()<<" created"<<endl;
        // out<<"ScopeTable# "<<currentScope->getId()<<" created"<<endl;
    }

    void EnterScope()
    {
        if(currentScope==0)
        {
            currentScope = new ScopeTable(bucket);
            currentScope->setParent(0);
            currentScope->setId(to_string(globalId));
        }
        else
        {
            ScopeTable *node = new ScopeTable(bucket);
            node->setParent(currentScope);
            
            node->setId(to_string(globalId));
            currentScope = node;
        }
        // cout<<"ScopeTable# "<<currentScope->getId()<<" created"<<endl;
        // out<<"ScopeTable# "<<currentScope->getId()<<" created"<<endl;
    }

    void ExitScope()
    {   
        
        if(currentScope!=0 && currentScope->getParent()!=0)
        {
            ScopeTable *node = currentScope->getParent();
            // cout<<"\t";
            // out<<"\t";
            // cout<<"ScopeTable# "<<currentScope->getId()<<" deleted"<<endl;
            // out<<"ScopeTable# "<<currentScope->getId()<<" deleted"<<endl;
            delete currentScope;
            currentScope = node;
            return;
        }
        if(currentScope->getParent()==0)
        {
            
            // cout<<"\t";
            // out<<"\t";
            // cout<<"ScopeTable# "<<currentScope->getId()<<" cannot be deleted"<<endl;
            // out<<"ScopeTable# "<<currentScope->getId()<<" cannot be deleted"<<endl;
            return;
        }
        
    }

    bool Insert(string name,string type)
    {
        
        if(currentScope!=0)
        {
            if(currentScope->Insert(name,type)) return true;
        }
        else
        {
            
            currentScope = new ScopeTable(bucket);
            currentScope->setParent(0);
            currentScope->setId(to_string(globalId));
            
            if(currentScope->Insert(name,type)) return true;
            
        }
        return false;
    }

    bool Remove(string name)
    {
        if(currentScope==0)
        {
            return false;
        }

        if(currentScope->Delete(name))
        {
            return true;
        }
        // cout<<"Not found in the current ScopeTable# "<<currentScope->getId()<<endl;
        // out<<"Not found in the current ScopeTable# "<<currentScope->getId()<<endl;
        return false;
    }

    SymbolInfo* LookUp(string name)
    {
        SymbolInfo *node;
        int flag=0;
        if(currentScope!=0)
        {
            node=currentScope->LookUp(name);

            if(node!=0) return node;

            if(node==0)
            {
                
                ScopeTable *tempScope=currentScope->getParent();
                while(tempScope!=0)
                {
                    SymbolInfo *node1=tempScope->LookUp(name);
                    if(node1!=0)
                    {
                        flag=1;
                        return node1;
                    }
                    tempScope = tempScope->getParent();
                }
            }
            if(flag==0)
            {
                // cout<<"'"<<name<<"' not found in any of the ScopeTables"<<endl;
                // out<<"'"<<name<<"' not found in any of the ScopeTables"<<endl;
                return 0;
            }
        }
        return 0;
    }

    void PrintCurrentScopeTable()
    {
        if(currentScope!=0)
        {
            currentScope->Print();
        }
    }

    string PrintAllScopeTable()
    {
        string str;
        ScopeTable *temp = currentScope;
        while(temp!=0)
        {
            str += temp->Print();
            temp = temp->getParent();
        }

        return str;
    }
    
    ~SymbolTable()
    {
        ScopeTable *temp=currentScope;
        while(temp!=0)
        {

            ScopeTable *node = temp;
            // cout<<"\t";
            // out<<"\t";
            // cout<<"ScopeTable# "<<temp->getId()<<" deleted"<<endl;
            // out<<"ScopeTable# "<<temp->getId()<<" deleted"<<endl;

            temp=temp->getParent();
            delete node;
                // currentScope = node;
            
            
        }

        currentScope=0;
    }
};



