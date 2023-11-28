#include<bits/stdc++.h>
using namespace std;


class SymbolInfo
{
private:
    string Name;
    string Type;
    SymbolInfo *next;
public:

    SymbolInfo()
    {
        next = 0;
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

    
};
