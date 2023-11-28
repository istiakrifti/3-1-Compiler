#include<bits/stdc++.h>
#include "SymbolInfo.cpp"
using namespace std;

ofstream out("out.txt");

class ScopeTable
{
private:
    SymbolInfo **hashTable;
    ScopeTable *parentScope;
    string id;
    int childScopeCount;
    int bucket;

    
    unsigned long sdbmhash(string name)
    {
        unsigned long hash = 0;

        int i=0;
        while (i<name.length())
        {
            int x = name[i];
            hash = x + (hash << 6) + (hash << 16) - hash;
            i++;
        }
            
        return hash;
    }
public:
    
    ScopeTable(int n)
    {
        bucket = n;
        childScopeCount=0;
        hashTable = new SymbolInfo*[bucket];
        
        for(int i=0;i<bucket;i++)
        {
            hashTable[i] = 0;
        }
            
    }

    bool Insert(string name,string type)
    {
        int hashValue = sdbmhash(name)%bucket;
        
        SymbolInfo *presentSymbol = hashTable[hashValue];

        int pos = 0;
        if(presentSymbol==0)
        {
            SymbolInfo *node = new SymbolInfo();
            
            node->setName(name);
            node->setType(type);

            hashTable[hashValue] = node;
            cout<<"Inserted  at position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
            out<<"Inserted  at position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
            return true;
        }
        else
        {
            while(presentSymbol->getNext()!=0)
            {
                if(presentSymbol->getName()==name)
                {
                    cout<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                    out<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                    return false;
                }
                else
                {
                    presentSymbol = presentSymbol->getNext();
                }
                pos++;
            }

            if(presentSymbol->getName()==name)
            {
                cout<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                out<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                return false;
            }

            SymbolInfo *node = new SymbolInfo();
            node->setName(name);
            node->setType(type);
            presentSymbol->setNext(node);
            cout<<"Inserted  at position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
            out<<"Inserted  at position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
            return true;
        }
        
    }

    SymbolInfo* LookUp(string name)
    {
        int hashValue = sdbmhash(name)%bucket;
        int pos=0;
        SymbolInfo *presentSymbol = hashTable[hashValue];

        if(presentSymbol!=0)
        {
            while(presentSymbol!=0)
            {
                pos++;
                if(presentSymbol->getName()==name)
                {
                    cout<<"'"<<name<<"' found at position <"<<hashValue+1<<","<<pos<<"> of ScopeTable# "<<id<<endl;
                    out<<"'"<<name<<"' found at position <"<<hashValue+1<<","<<pos<<"> of ScopeTable# "<<id<<endl;
                    return presentSymbol;
                }
                presentSymbol = presentSymbol->getNext();
            }
            
        }
        return 0;
    }

    bool Delete(string name)
    {
        int hashValue = sdbmhash(name)%bucket;
        int pos =0;
        SymbolInfo *presentSymbol = hashTable[hashValue];

        if(presentSymbol==0)
        {   
            return false;
        }
        else
        {
            if(presentSymbol->getName()==name)
            {
                SymbolInfo *temp = presentSymbol;
                hashTable[hashValue] = presentSymbol->getNext();
                delete temp;
                cout<<"Deleted "<<name<<" from position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
                out<<"Deleted "<<name<<" from position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
                return true;
            }

            SymbolInfo *prev = presentSymbol;

            while(presentSymbol!=0)
            {
                pos++;
                if(presentSymbol->getName()==name)
                {
                    prev->setNext(presentSymbol->getNext());
                    delete presentSymbol;
                    cout<<"Deleted "<<name<<" from position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
                    out<<"Deleted "<<name<<" from position <"<<hashValue+1<<","<<pos+1<<"> of ScopeTable# "<<id<<endl;
                    return true;
                }
                prev = presentSymbol;
                presentSymbol = presentSymbol->getNext();
            }
        }

        return false;
    }

    void Print()
    {
        cout<<"        ScopeTable# "<<id<<endl;
        out<<"        ScopeTable# "<<id<<endl;
        for (int i = 0; i < bucket; i++)
        {
            cout<<"        ";
            out<<"        ";
            SymbolInfo *temp=hashTable[i];
            cout<<i+1;
            out<<i+1;
            while(temp!=0){
                
                cout<<" --> ";
                out<<" --> ";
                // if(presentScope->getName())
                cout<<"("<<temp->getName()<<","<<temp->getType()<<")";
                out<<"("<<temp->getName()<<","<<temp->getType()<<")";
                // if(temp->getNext()!=0) cout<<" --> ";
                temp=temp->getNext();
            }
            cout<<endl;
            out<<endl;
        } 
    }
    ScopeTable* getParent()
    {
        return parentScope;
    }

    void setParent(ScopeTable *parent)
    {
        parentScope = parent;
    }

    string getId()
    {
        return id;
    }

    void setId(string id)
    {
        if(parentScope==0)
        {
            this->id = id;
        }
        else
        {
            parentScope->childScopeCount++;
            this->id=parentScope->id+"."+to_string(parentScope->childScopeCount);
        }
    }

    ~ScopeTable()
    {
        
    }
};