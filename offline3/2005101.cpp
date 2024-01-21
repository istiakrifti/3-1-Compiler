#include<bits/stdc++.h>
using namespace std;

class SymbolInfo
{
private:
    string Name;
    string Type;
    SymbolInfo *next;

    int start;
    int end;
    string dataType = "";
    string varOrFunc = "";
    string arraySize="";
    int paramSize;
    int paramIdx;
    // SymbolInfo *child,*temp;
    vector<SymbolInfo*> childList;
    int childCount;
    vector<pair<SymbolInfo*,SymbolInfo*>> paramList;
    
public:
    bool isDec,isDef;
    SymbolInfo *next1;
    SymbolInfo()
    {
        next = 0;
    }

    // SymbolInfo(string name,string type)
    // {
    //     next = 0;
    //     // child = 0;
    //     start = 0;
    //     end = 0;
    //     // arraySize="";
    //     childCount = 0;
    //     this->Name = name;
    //     this->Type = type;
    //     paramIdx = 0;
    //     childList.clear();
    //     paramList.clear();
    // }

    // SymbolInfo(string name,string type,int x,int y)
    // {
    //     next = 0;
    //     // child = 0;
    //     // arraySize="";

    //     childCount = 0;
    //     this->Name = name;
    //     this->Type = type;
    //     dataType = "";
    //     varOrFunc = "variable";
    //     arraySize="";
    //     paramList.clear();
    //     start = x;
    //     end = y;
    //     childList.clear();
    // }
    SymbolInfo(string name,string type)
    {
        next = 0;
        // child = 0;
        // arraySize="";
        isDec = false;
        isDef = false; 
        childCount = 0;
        this->Name = name;
        this->Type = type;
        dataType = "";
        varOrFunc = "variable";
        arraySize="";
        paramList.clear();
        childList.clear();
    }

    string getName()
    {
        return Name;
    }

    string getType()
    {
        return Type;
    }

    void setName(string Name)
    {
        this->Name = Name;
    }

    void setType(string Type)
    {
        this->Type = Type;
    }

    SymbolInfo* getNext()
    {
        return next;
    }

    void setNext(SymbolInfo *next)
    {
        this->next = next;
    }  

    string getDataType()
    {
        return dataType;
    }

    void setDataType(string type)
    {
        this->dataType = type;
    }  

    int getStart()
    {
        return start;
    }

    void setStart(int st)
    {
        start = st;
    }

    int getEnd()
    {
        return end;
    }

    void setEnd(int e)
    {
        end = e;
    }

    string getArraySize()
    {
        return arraySize;
    }

    void setArraySize(string size)
    {
        arraySize = size;
    }

    string getVarOrFunc()
    {
        return varOrFunc;
    }

    void setVarOrFunc(string str)
    {
        varOrFunc = str;
    }

    // void setParameter(vector<pair<SymbolInfo*,SymbolInfo*>> p)
    // {
    //     paramList=p;
    // }

    void setParameter(pair<SymbolInfo*,SymbolInfo*> p)
    {
        paramList.push_back(p);
    }
    // void setParameter(SymbolInfo*s1,SymbolInfo* s2)
    // {
    //     paramList.push_back({s1,s2});
    // }

    vector<pair<SymbolInfo*,SymbolInfo*>> getParameter()
    {
        return paramList;
    }

    void addChild(SymbolInfo *sym)
    {
        // if(child==0)
        // {
        //     child=temp=sym;
        //     childCount++;
        // }
        // else
        // {
        //     temp->next1=sym;
        //     temp=sym;
        //     childCount++;
        // }
        childList.push_back(sym);
        childCount++;
    }

    vector<SymbolInfo*> getChildList()
    {
        return childList;
    }

    int getChildCount()
    {
        // childCount = childList.size();
        return childCount;
    }

    void setParamSize(int s)
    {
        paramSize = s;
    }

    int getParamSize()
    {
        return paramList.size();
    }

    bool isArray()
    {
        if(arraySize!="") return true;
        return false;
    }
};


class ScopeTable
{
private:
    SymbolInfo **hashTable;
    ScopeTable *parentScope;
    string id;
    int childScopeCount;
    int bucket;

    
    unsigned long long int sdbmhash(string name)
    {
        unsigned long long int hash = 0;

        int i=0;
        while (i<name.length())
        {
            unsigned long long int x = name[i];
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

    bool Insert(SymbolInfo *symbol)
    {
        int hashValue = sdbmhash(symbol->getName())%bucket;
        
        SymbolInfo *presentSymbol = hashTable[hashValue];

        int pos = 0;
        // if(presentSymbol==0)
        // {
            // SymbolInfo *node = new SymbolInfo();
            
            // node->setName(name);
            // node->setType(type);

            // hashTable[hashValue] = symbol;
            // cout<<"Inserted  at position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
            // out<<"Inserted  at position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
            // return true;
        
        // else
        // {
            while(presentSymbol!=0)
            {
                if(presentSymbol->getName()==symbol->getName())
                {
                    // cout<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                    // out<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                    return false;
                }
                
                    presentSymbol = presentSymbol->getNext();
                
                pos++;
            }

            presentSymbol = hashTable[hashValue];
            if(presentSymbol==0)
            {
                hashTable[hashValue] = symbol;
                symbol->setNext(0);
                // cout<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                // out<<"'"<<name<<"' already exists in the current ScopeTable# "<<id<<endl;
                return true;
            }
            while(presentSymbol->getNext()!=0)
            {
                presentSymbol=presentSymbol->getNext();
                pos++;
            }
            pos++;
            // SymbolInfo *node = new SymbolInfo();
            // node->setName(name);
            // node->setType(type);
            presentSymbol->setNext(symbol);
            // symbol->setNext(0);
            // cout<<"Inserted  at position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
            // out<<"Inserted  at position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
            return true;
        
        
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
                    // cout<<"'"<<name<<"' found at position <"<<hashValue+1<<", "<<pos<<"> of ScopeTable# "<<id<<endl;
                    // out<<"'"<<name<<"' found at position <"<<hashValue+1<<", "<<pos<<"> of ScopeTable# "<<id<<endl;
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
                // cout<<"Deleted '"<<name<<"' from position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
                // out<<"Deleted '"<<name<<"' from position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
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
                    // cout<<"Deleted "<<name<<" from position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
                    // out<<"Deleted "<<name<<" from position <"<<hashValue+1<<", "<<pos+1<<"> of ScopeTable# "<<id<<endl;
                    return true;
                }
                prev = presentSymbol;
                presentSymbol = presentSymbol->getNext();
            }
        }

        return false;
    }

    string Print()
    {
        string str;
        str += "\t";
        str += "ScopeTable# "+id+"\n";
        // cout<<"\t";
        // out<<"\t";
        // cout<<"ScopeTable# "<<id<<endl;
        // out<<"ScopeTable# "<<id<<endl;
        for (int i = 0; i < bucket; i++)
        {
            // cout<<"\t";
            
            // out<<"\t";
            int f=0;
            SymbolInfo *temp=hashTable[i];
            // cout<<i+1;
            if(temp!=0) {
                str += "\t";
                str += to_string(i+1);
            // out<<i+1;
            while(temp!=0){
                if(f==0)
                {
                    str += "--> ";
                    f=1;
                }
                else str += " ";
                // cout<<" --> ";
                // out<<" --> ";
                // if(presentScope->getName())
                // cout<<"("<<temp->getName()<<","<<temp->getType()<<")";
                // out<<"("<<temp->getName()<<","<<temp->getType()<<")";
                if(temp->getVarOrFunc()=="variable")
                {
                    if(temp->isArray()) str += "<"+temp->getName()+",ARRAY"+">";
                    else str += "<"+temp->getName()+","+temp->getDataType()+">";
                }
                else 
                {
                   str += "<"+temp->getName()+",FUNCTION,"+temp->getDataType()+">";

                }
                // if(temp->getNext()!=0) cout<<" --> ";
                temp=temp->getNext();
            }
            // cout<<endl;
                str += "\n";
            }
        
            // out<<endl;
        } 
        return str;
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
        this->id=id;
        // if(parentScope==0)
        // {
        //     this->id = id;
        // }
        // else
        // {
        //     parentScope->childScopeCount++;
        //     this->id=parentScope->id+"."+to_string(parentScope->childScopeCount);
        // }
    }

    // ~ScopeTable()
    // {
    //     for (int i=0; i<bucket; i++)
    //     {
    //     SymbolInfo* temp;
    //         while(hashTable[i]!=0) {
    //         temp=hashTable[i]->getNext();
    //         delete hashTable[i];
    //         hashTable[i]=temp;
    //     }
    //     }
    //     delete[] hashTable;
    // }
};

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
        currentScope->setId(to_string(globalId++));
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
            currentScope->setId(to_string(globalId++));
        }
        else
        {
            ScopeTable *node = new ScopeTable(bucket);
            node->setParent(currentScope);
            
            node->setId(to_string(globalId++));
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

    ScopeTable* getCurrentScope()
    {
        return currentScope;
    }

    bool Insert(SymbolInfo *symbol)
    {
        
        if(currentScope!=0)
        {
            if(currentScope->Insert(symbol)) return true;
        }
        // else
        // {
            
            // currentScope = new ScopeTable(bucket);
            // currentScope->setParent(0);
            // currentScope->setId(to_string(globalId));
            
            // if(currentScope->Insert(symbol)) return true;
            
        // }
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
    
    // ~SymbolTable()
    // {
    //     ScopeTable *temp=currentScope;
    //     while(temp!=0)
    //     {

    //         ScopeTable *node = temp;
    //         // cout<<"\t";
    //         // out<<"\t";
    //         // cout<<"ScopeTable# "<<temp->getId()<<" deleted"<<endl;
    //         // out<<"ScopeTable# "<<temp->getId()<<" deleted"<<endl;

    //         temp=temp->getParent();
    //         delete node;
    //             // currentScope = node;
            
            
    //     }

    //     currentScope=0;
    // }
};
