/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 2 "2005101.y" /* yacc.c:339  */

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



#line 134 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    FOR = 260,
    WHILE = 261,
    INT = 262,
    FLOAT = 263,
    VOID = 264,
    RETURN = 265,
    INCOP = 266,
    DECOP = 267,
    ASSIGNOP = 268,
    NOT = 269,
    ADDOP = 270,
    MULOP = 271,
    RELOP = 272,
    LOGICOP = 273,
    CONST_INT = 274,
    CONST_FLOAT = 275,
    ID = 276,
    LPAREN = 277,
    RPAREN = 278,
    LCURL = 279,
    RCURL = 280,
    LSQUARE = 281,
    RSQUARE = 282,
    COMMA = 283,
    SEMICOLON = 284,
    LOWER_THAN_ELSE = 285
  };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define FOR 260
#define WHILE 261
#define INT 262
#define FLOAT 263
#define VOID 264
#define RETURN 265
#define INCOP 266
#define DECOP 267
#define ASSIGNOP 268
#define NOT 269
#define ADDOP 270
#define MULOP 271
#define RELOP 272
#define LOGICOP 273
#define CONST_INT 274
#define CONST_FLOAT 275
#define ID 276
#define LPAREN 277
#define RPAREN 278
#define LCURL 279
#define RCURL 280
#define LSQUARE 281
#define RSQUARE 282
#define COMMA 283
#define SEMICOLON 284
#define LOWER_THAN_ELSE 285

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 70 "2005101.y" /* yacc.c:355  */

    SymbolInfo* symbol;

#line 238 "y.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 255 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  11
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   151

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  31
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  32
/* YYNRULES -- Number of rules.  */
#define YYNRULES  74
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  128

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   285

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    83,    83,    95,   105,   114,   122,   130,   139,   184,
     225,   225,   314,   314,   379,   387,   379,   405,   428,   452,
     465,   480,   480,   524,   524,   566,   620,   620,   645,   656,
     667,   678,   690,   705,   715,   731,   740,   751,   759,   768,
     776,   791,   804,   818,   830,   843,   851,   860,   860,   877,
     907,   954,   971,  1003,  1020,  1033,  1050,  1073,  1090,  1132,
    1150,  1218,  1237,  1256,  1274,  1290,  1357,  1377,  1389,  1401,
    1413,  1427,  1436,  1446,  1458
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IF", "ELSE", "FOR", "WHILE", "INT",
  "FLOAT", "VOID", "RETURN", "INCOP", "DECOP", "ASSIGNOP", "NOT", "ADDOP",
  "MULOP", "RELOP", "LOGICOP", "CONST_INT", "CONST_FLOAT", "ID", "LPAREN",
  "RPAREN", "LCURL", "RCURL", "LSQUARE", "RSQUARE", "COMMA", "SEMICOLON",
  "LOWER_THAN_ELSE", "$accept", "start", "program", "unit",
  "func_declaration", "func_definition", "$@1", "$@2", "$@3", "$@4",
  "parameter_list", "compound_statement", "$@5", "$@6", "var_declaration",
  "$@7", "type_specifier", "declaration_list", "statements", "statement",
  "expression_statement", "$@8", "variable", "expression",
  "logic_expression", "rel_expression", "simple_expression", "term",
  "unary_expression", "factor", "argument_list", "arguments", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285
};
# endif

#define YYPACT_NINF -82

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-82)))

#define YYTABLE_NINF -24

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      51,   -82,   -82,   -82,    22,    51,   -82,   -82,   -82,   -82,
       7,   -82,   -82,   -82,    -1,    53,   -22,     9,    17,    31,
     -82,   -82,   -82,    37,    -8,    47,    48,    61,    68,   -82,
      76,    73,    51,   -82,   -82,    58,   -82,    87,   -82,   -82,
      76,   102,    97,    76,    89,   101,   -82,   -82,   -82,   -82,
     -82,   103,   106,   108,    35,    35,    35,   -82,   -82,    54,
      35,   -82,   -82,   -82,    23,    64,   -82,   -82,    94,    98,
     -82,   113,    30,   116,   -82,   -82,   -82,   104,    35,   100,
      35,   107,   105,   -82,   -82,    35,    35,   111,   109,   -82,
     -82,   -82,   -82,    35,   -82,    35,    35,    35,    35,   -82,
     114,   100,   115,   -82,   -82,   117,   118,   112,   -82,   -82,
     -82,   116,   126,   -82,    89,    35,    89,   -82,    35,   -82,
     138,   120,   -82,   -82,    89,    89,   -82,   -82
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,    28,    29,    30,     0,     2,     4,     6,     7,     5,
       0,     1,     3,    26,    33,     0,     0,     0,     0,     0,
      25,    27,    14,    12,     0,    20,     0,    31,     0,     9,
       0,    10,     0,    19,    34,     0,    15,    21,    13,     8,
       0,    18,     0,     0,     0,     0,    11,    17,    32,    16,
      47,     0,     0,     0,     0,     0,     0,    67,    68,    49,
       0,    45,    39,    37,     0,     0,    35,    38,    64,     0,
      51,    53,    55,    57,    59,    63,    24,     0,     0,     0,
       0,     0,    64,    62,    61,    72,     0,     0,    33,    22,
      36,    69,    70,     0,    46,     0,     0,     0,     0,    48,
       0,     0,     0,    44,    74,     0,    71,     0,    66,    52,
      54,    58,    56,    60,     0,     0,     0,    65,     0,    50,
      41,     0,    43,    73,     0,     0,    42,    40
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -82,   -82,   -82,   139,   -82,   -82,   -82,   -82,   -82,   -82,
     -82,   -17,   -82,   -82,    34,   -82,    14,   -82,   -82,   -63,
     -68,   -82,   -55,   -51,   -81,    50,    52,    55,   -50,   -82,
     -82,   -82
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     4,     5,     6,     7,     8,    40,    30,    28,    43,
      24,    62,    44,    45,    63,    16,    64,    15,    65,    66,
      67,    77,    68,    69,    70,    71,    72,    73,    74,    75,
     105,   106
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      82,    82,    90,    81,   104,    83,    84,    21,    13,    87,
      22,   101,   109,    38,    10,    31,     1,     2,     3,    10,
      32,    17,    11,    46,    13,    18,    49,   100,    14,   102,
      82,    25,    23,   115,     9,   107,    26,   123,    82,     9,
      82,    82,    82,    82,    88,    96,    41,    97,   113,    55,
      56,   120,    27,   122,    57,    58,    59,    60,     1,     2,
       3,   126,   127,    82,   121,    50,    29,    51,    33,    52,
      53,     1,     2,     3,    54,    34,    85,    42,    55,    56,
      86,    19,    20,    57,    58,    59,    60,    35,    37,    89,
      50,    36,    51,    61,    52,    53,     1,     2,     3,    54,
      37,    50,    39,    55,    56,    91,    92,    93,    57,    58,
      59,    60,   -23,    37,    55,    56,    91,    92,    61,    57,
      58,    59,    60,    47,    48,    78,    76,    94,    79,    61,
      80,    95,    98,    99,   108,    18,   103,   114,   116,   119,
     117,    96,   124,   125,    12,   110,   118,     0,     0,   112,
       0,   111
};

static const yytype_int8 yycheck[] =
{
      55,    56,    65,    54,    85,    55,    56,    29,     1,    60,
       1,    79,    93,    30,     0,    23,     7,     8,     9,     5,
      28,    22,     0,    40,     1,    26,    43,    78,    21,    80,
      85,    17,    23,   101,     0,    86,    19,   118,    93,     5,
      95,    96,    97,    98,    21,    15,    32,    17,    98,    14,
      15,   114,    21,   116,    19,    20,    21,    22,     7,     8,
       9,   124,   125,   118,   115,     1,    29,     3,    21,     5,
       6,     7,     8,     9,    10,    27,    22,    19,    14,    15,
      26,    28,    29,    19,    20,    21,    22,    26,    24,    25,
       1,    23,     3,    29,     5,     6,     7,     8,     9,    10,
      24,     1,    29,    14,    15,    11,    12,    13,    19,    20,
      21,    22,    25,    24,    14,    15,    11,    12,    29,    19,
      20,    21,    22,    21,    27,    22,    25,    29,    22,    29,
      22,    18,    16,    29,    23,    26,    29,    23,    23,    27,
      23,    15,     4,    23,     5,    95,    28,    -1,    -1,    97,
      -1,    96
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     7,     8,     9,    32,    33,    34,    35,    36,    45,
      47,     0,    34,     1,    21,    48,    46,    22,    26,    28,
      29,    29,     1,    23,    41,    47,    19,    21,    39,    29,
      38,    23,    28,    21,    27,    26,    23,    24,    42,    29,
      37,    47,    19,    40,    43,    44,    42,    21,    27,    42,
       1,     3,     5,     6,    10,    14,    15,    19,    20,    21,
      22,    29,    42,    45,    47,    49,    50,    51,    53,    54,
      55,    56,    57,    58,    59,    60,    25,    52,    22,    22,
      22,    54,    53,    59,    59,    22,    26,    54,    21,    25,
      50,    11,    12,    13,    29,    18,    15,    17,    16,    29,
      54,    51,    54,    29,    55,    61,    62,    54,    23,    55,
      56,    58,    57,    59,    23,    51,    23,    23,    28,    27,
      50,    54,    50,    55,     4,    23,    50,    50
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    31,    32,    33,    33,    34,    34,    34,    35,    35,
      37,    36,    38,    36,    39,    40,    36,    41,    41,    41,
      41,    43,    42,    44,    42,    45,    46,    45,    47,    47,
      47,    48,    48,    48,    48,    49,    49,    50,    50,    50,
      50,    50,    50,    50,    50,    51,    51,    52,    51,    53,
      53,    54,    54,    55,    55,    56,    56,    57,    57,    58,
      58,    59,    59,    59,    60,    60,    60,    60,    60,    60,
      60,    61,    61,    62,    62
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     6,     5,
       0,     7,     0,     6,     0,     0,     8,     4,     3,     2,
       1,     0,     4,     0,     3,     3,     0,     4,     1,     1,
       1,     3,     6,     1,     4,     1,     2,     1,     1,     1,
       7,     5,     7,     5,     3,     1,     2,     0,     3,     1,
       4,     1,     3,     1,     3,     1,     3,     1,     3,     1,
       3,     2,     2,     1,     1,     4,     3,     1,     1,     2,
       2,     1,     0,     3,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 84 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"start : program\n");
			(yyval.symbol) = new SymbolInfo("program","start");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			PrintParse((yyval.symbol),0);
			fprintf(logout,"Total Lines: %d\n",yylineno);
			fprintf(logout,"Total Errors: %d\n",error_count);
        }
#line 1437 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 96 "2005101.y" /* yacc.c:1646  */
    {
            (yyval.symbol) = new SymbolInfo("program unit","program");
			fprintf(logout,"program : program unit\n");
			(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[-1].symbol));
			(yyval.symbol)->addChild((yyvsp[0].symbol));

        }
#line 1451 "y.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 106 "2005101.y" /* yacc.c:1646  */
    {
            (yyval.symbol)=new SymbolInfo("unit","program");
			fprintf(logout,"program : unit\n");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 1463 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 115 "2005101.y" /* yacc.c:1646  */
    {
            (yyval.symbol)=new SymbolInfo("var_declaration","unit");
            fprintf(logout,"unit : var_declaration\n");
            (yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
            (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 1475 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 123 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"unit : func_declaration\n");
            (yyval.symbol) = new SymbolInfo("func_declaration","unit");
            (yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
            (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 1487 "y.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 131 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"unit : func_definition\n");
            (yyval.symbol) = new SymbolInfo("func_definition","unit");
            (yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
            (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 1499 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 140 "2005101.y" /* yacc.c:1646  */
    {
                     fprintf(logout,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");
					 (yyval.symbol) = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON","func_declaration");
					 (yyval.symbol)->setStart((yyvsp[-5].symbol)->getStart());
					 (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					 (yyval.symbol)->addChild((yyvsp[-5].symbol));
					 (yyval.symbol)->addChild((yyvsp[-4].symbol));
					 (yyval.symbol)->addChild((yyvsp[-3].symbol));
					 (yyval.symbol)->addChild((yyvsp[-2].symbol));
					 (yyval.symbol)->addChild((yyvsp[-1].symbol));
					 (yyval.symbol)->addChild((yyvsp[0].symbol));
					 
					 string funcName = (yyvsp[-4].symbol)->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						SymbolInfo *info = new SymbolInfo((yyvsp[-4].symbol)->getName(),(yyvsp[-4].symbol)->getType());
						info->setStart((yyvsp[-5].symbol)->getStart());
						info->setEnd((yyvsp[0].symbol)->getEnd());
						info->setDataType((yyvsp[-5].symbol)->getDataType());
						info->setVarOrFunc((yyval.symbol)->getType());
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
							fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of '%s' function",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());
						}
					 }
					 
					 param.clear();
                }
#line 1548 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 185 "2005101.y" /* yacc.c:1646  */
    {
                     fprintf(logout,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n");
					 (yyval.symbol) = new SymbolInfo("type_specifier ID LPAREN RPAREN SEMICOLON","func_declaration");
					 (yyval.symbol)->setStart((yyvsp[-4].symbol)->getStart());
					 (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					 (yyval.symbol)->addChild((yyvsp[-4].symbol));
					 (yyval.symbol)->addChild((yyvsp[-3].symbol));
					 (yyval.symbol)->addChild((yyvsp[-2].symbol));
					 (yyval.symbol)->addChild((yyvsp[-1].symbol));
					 (yyval.symbol)->addChild((yyvsp[0].symbol));
					 
					 string funcName = (yyvsp[-3].symbol)->getName();
					 SymbolInfo *temp = table.LookUp(funcName);

					 if(temp==0)
					 {
						SymbolInfo *info = new SymbolInfo((yyvsp[-3].symbol)->getName(),(yyvsp[-3].symbol)->getType());
						info->setStart((yyvsp[-4].symbol)->getStart());
						info->setEnd((yyvsp[0].symbol)->getEnd());
						info->setDataType((yyvsp[-4].symbol)->getDataType());
						info->setVarOrFunc((yyval.symbol)->getType());
						table.Insert(info);
						(yyvsp[-3].symbol)->isDec = true;
					 } 
					 else
					 {
						if(checkVariable(temp)){
							error_count++;
							fprintf(errorout,"Line# %d : %s redeclared as different kind of symbol",(yyvsp[-3].symbol)->getStart(),temp->getName().c_str());
                		}
						else
						{
							error_count++;
							fprintf(errorout,"Line# %d : Redeclaration of %s function",(yyvsp[-3].symbol)->getStart(),temp->getName().c_str());
							
						}
					 }
                }
#line 1591 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 225 "2005101.y" /* yacc.c:1646  */
    {
	SymbolInfo* info=new SymbolInfo((yyvsp[-3].symbol)->getName(), (yyvsp[-3].symbol)->getType());
    info->setStart((yyvsp[-4].symbol)->getStart());
    info->setEnd((yyvsp[-3].symbol)->getEnd());
    info->setDataType((yyvsp[-4].symbol)->getDataType());
    info->setVarOrFunc("func_definition");

    for(int i=0;i<param.size();i++)
    {
		info->setParameter(param[i]);
	}

    string fname = (yyvsp[-3].symbol)->getName();
    SymbolInfo* temp=table.LookUp(fname);
        if(temp==0)
        {
			(yyvsp[-3].symbol)->isDec = true; 
            table.Insert(info);
			(yyvsp[-3].symbol)->isDef = true;
			(yyvsp[-3].symbol)->isDec = false;
        }
        else
        {

            if(checkVariable(temp))
            {
                error_count++;
                fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",(yyvsp[-3].symbol)->getStart(),temp->getName().c_str());
            }    
            else
            {

                if(isFunction_declaration(temp))
                {
                    vector<pair<SymbolInfo*, SymbolInfo*> > pt = temp->getParameter();
                    
                    bool flag=true;
                    if(temp->getDataType() != (yyvsp[-4].symbol)->getDataType())
                    {
                        flag=false;
                        error_count++;
                        fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());
                    }        
                    else if(pt.size()!=param.size()){

                        flag=false;        
                        error_count++;
                        fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());          
                    }
                    else
                    {
                            for(int i=0;i<param.size();i++)
                            {

                                if((param[i].first)->getType() != (pt[i].first)->getType())
                                {
                                    flag=false;
                                    error_count++;
                                    fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());			
                                    break;
                                }
                            }
                    }

                    if(flag) table.Insert(info);

                }
                else
                {
                    error_count++;
                    fprintf(errorout,"Line# %d : Redefinition of function '%s'\n",(yyvsp[-4].symbol)->getStart(),temp->getName().c_str());
                }
                }

            }
	}
#line 1672 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 301 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
                    (yyval.symbol) = new SymbolInfo("type_specifier ID LPAREN parameter_list RPAREN compound_statement","func_definition");
                    (yyval.symbol)->setStart((yyvsp[-6].symbol)->getStart());
                    (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
                    (yyval.symbol)->addChild((yyvsp[-6].symbol));
                    (yyval.symbol)->addChild((yyvsp[-5].symbol));
                    (yyval.symbol)->addChild((yyvsp[-4].symbol));
                    (yyval.symbol)->addChild((yyvsp[-3].symbol));
                    (yyval.symbol)->addChild((yyvsp[-2].symbol));
                    (yyval.symbol)->addChild((yyvsp[0].symbol));				 

                }
#line 1690 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 314 "2005101.y" /* yacc.c:1646  */
    {
				
					SymbolInfo* info=new SymbolInfo((yyvsp[-2].symbol)->getName(), (yyvsp[-2].symbol)->getType());
					info->setStart((yyvsp[-3].symbol)->getStart());
					info->setEnd((yyvsp[-2].symbol)->getEnd());
					info->setDataType((yyvsp[-3].symbol)->getDataType());
					info->setVarOrFunc("func_definition");

					for(int i=0;i<param.size();i++)
					{
						info->setParameter(param[i]);
					}
					string fname = (yyvsp[-2].symbol)->getName();
					SymbolInfo* temp=table.LookUp(fname);
						if(temp==0)
						{
							table.Insert(info);
							(yyvsp[-2].symbol)->isDef = true;
							(yyvsp[-2].symbol)->isDec = false;
						}
						else
						{

							if(checkVariable(temp))
							{
								error_count++;
								fprintf(errorout,"Line# %d : '%s' redeclared as different kind of symbol\n",(yyvsp[-2].symbol)->getStart(),temp->getName().c_str());
							}
							else
							{

								if(isFunction_declaration(temp))
								{
									
									bool flag=true;
									if(temp->getDataType() != (yyvsp[-3].symbol)->getDataType())
									{
										flag=false;
										error_count++;
										fprintf(errorout,"Line# %d : Conflicting types for '%s'\n",(yyvsp[-3].symbol)->getStart(),temp->getName().c_str());
									}

									if(flag) table.Insert(info);

								}
								else
								{
									error_count++;
									fprintf(errorout,"Line# %d : Redefinition of function '%s'\n",(yyvsp[-3].symbol)->getStart(),temp->getName().c_str());
								}
							}

						}
					}
#line 1749 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 368 "2005101.y" /* yacc.c:1646  */
    {
                     fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");
					 (yyval.symbol) = new SymbolInfo("type_specifier ID LPAREN RPAREN compound_statement","func_definition");
					 (yyval.symbol)->setStart((yyvsp[-5].symbol)->getStart());
					 (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					 (yyval.symbol)->addChild((yyvsp[-5].symbol));
					 (yyval.symbol)->addChild((yyvsp[-4].symbol));
					 (yyval.symbol)->addChild((yyvsp[-3].symbol));
					 (yyval.symbol)->addChild((yyvsp[-2].symbol));
					 (yyval.symbol)->addChild((yyvsp[0].symbol));	
                }
#line 1765 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 379 "2005101.y" /* yacc.c:1646  */
    {  
                                                if(errorLine == -1)                                         
                                                {
                                                    errorLine = yylineno;
                                                    error_count++;
                                                    fprintf(errorout,"Line# %d : Syntax error at parameter list of function definition\n",(yyvsp[-1].symbol)->getStart());
                                                    fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
                                                    param.clear();
                                                }}
#line 1779 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 387 "2005101.y" /* yacc.c:1646  */
    {errorLine = -1;}
#line 1785 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 387 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
					 (yyval.symbol) = new SymbolInfo("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement","func_definition");
					 (yyval.symbol)->setStart((yyvsp[-7].symbol)->getStart());
					 (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					 SymbolInfo *info = new SymbolInfo("error","parameter_list");
					 info->setStart((yyvsp[-5].symbol)->getStart());
					 info->setEnd((yyvsp[-2].symbol)->getEnd());
					 (yyval.symbol)->addChild((yyvsp[-7].symbol));
					 (yyval.symbol)->addChild((yyvsp[-6].symbol));
					 (yyval.symbol)->addChild((yyvsp[-5].symbol));
					 (yyval.symbol)->addChild(info);
					 (yyval.symbol)->addChild((yyvsp[-2].symbol));
					 (yyval.symbol)->addChild((yyvsp[0].symbol));	
					 errorLine = -1;

                }
#line 1807 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 406 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"parameter_list : parameter_list COMMA type_specifier ID\n");
					(yyval.symbol) = new SymbolInfo("parameter_list COMMA type_specifier ID", "parameter_list");
					(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-3].symbol));
					(yyval.symbol)->addChild((yyvsp[-2].symbol));
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));

					vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[-3].symbol)->getParameter();
					for(int i=0;i<pt.size();i++)
					{
						(yyval.symbol)->setParameter(pt[i]);
					}
								
					(yyval.symbol)->setParameter({(yyvsp[-1].symbol),(yyvsp[0].symbol)});
					param.push_back({(yyvsp[-1].symbol),(yyvsp[0].symbol)}); 
					(yyvsp[0].symbol)->setDataType((yyvsp[-1].symbol)->getDataType());
           

                }
#line 1834 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 429 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"parameter_list : parameter_list COMMA type_specifier\n");
					(yyval.symbol) = new SymbolInfo("parameter_list COMMA type_specifier", "parameter_list");
					(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-2].symbol));
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));

					vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[-2].symbol)->getParameter();
					for(int i=0;i<pt.size();i++)
					{
						(yyval.symbol)->setParameter(pt[i]);
					}
							 
					SymbolInfo *info = new SymbolInfo("","");
					info->setStart((yyvsp[0].symbol)->getStart());
					info->setEnd((yyvsp[0].symbol)->getEnd());
					info->setDataType((yyvsp[0].symbol)->getDataType());
					(yyval.symbol)->setParameter({(yyvsp[0].symbol),info});
					param.push_back({(yyvsp[0].symbol),info});

                }
#line 1862 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 453 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"parameter_list : type_specifier ID\n");
					(yyval.symbol) = new SymbolInfo("type_specifier ID", "parameter_list");
					(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					(yyval.symbol)->setParameter({(yyvsp[-1].symbol),(yyvsp[0].symbol)});
					param.push_back({(yyvsp[-1].symbol),(yyvsp[0].symbol)}); 
					(yyvsp[0].symbol)->setDataType((yyvsp[-1].symbol)->getDataType());
    
                }
#line 1879 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 466 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"parameter_list : type_specifier\n");
					(yyval.symbol) = new SymbolInfo("type_specifier", "parameter_list");
					(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					SymbolInfo *info = new SymbolInfo("","");
					info->setStart((yyvsp[0].symbol)->getStart());
					info->setEnd((yyvsp[0].symbol)->getEnd());
					info->setDataType((yyvsp[0].symbol)->getDataType());
					(yyval.symbol)->setParameter({(yyvsp[0].symbol),info});
					param.push_back({(yyvsp[0].symbol),info});
                }
#line 1897 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 480 "2005101.y" /* yacc.c:1646  */
    {
	
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
	}
#line 1932 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 510 "2005101.y" /* yacc.c:1646  */
    {
                        fprintf(logout,"compound_statement : LCURL statements RCURL\n");
						(yyval.symbol) = new SymbolInfo("LCURL statements RCURL", "compound_statement");
						(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
						(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
						(yyval.symbol)->addChild((yyvsp[-3].symbol));
						(yyval.symbol)->addChild((yyvsp[-1].symbol));
						(yyval.symbol)->addChild((yyvsp[0].symbol));
						
						string str = table.PrintAllScopeTable();
						fprintf(logout,"%s",str.c_str());
						
						table.ExitScope();
                    }
#line 1951 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 524 "2005101.y" /* yacc.c:1646  */
    {
						
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
						}
#line 1986 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 554 "2005101.y" /* yacc.c:1646  */
    {
                        fprintf(logout,"compound_statement : LCURLstatements RCURL\n");
						(yyval.symbol) = new SymbolInfo("LCURL statements RCURL", "compound_statement");
						(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
						(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
						(yyval.symbol)->addChild((yyvsp[-2].symbol));
						(yyval.symbol)->addChild((yyvsp[0].symbol));
						string str = table.PrintAllScopeTable();
						fprintf(logout,"%s",str.c_str());
						table.ExitScope();
                    }
#line 2002 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 567 "2005101.y" /* yacc.c:1646  */
    {
                        fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n");
						(yyval.symbol) = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration");
						(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
						(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
						(yyval.symbol)->addChild((yyvsp[-2].symbol));
						(yyval.symbol)->addChild((yyvsp[-1].symbol));
						(yyval.symbol)->addChild((yyvsp[0].symbol));

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
#line 2060 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 620 "2005101.y" /* yacc.c:1646  */
    {
                                if(errorLine == -1)
                                {
                                    errorLine = yylineno;
                                    fprintf(logout,"Error at line no %d : syntax error\n",errorLine);
                                }}
#line 2071 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 626 "2005101.y" /* yacc.c:1646  */
    {

                    error_count++;
					fprintf(errorout,"Line# %d : Syntax error at declaration list of variable declaration\n",errorLine);
					fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n");
					(yyval.symbol) = new SymbolInfo("type_specifier declaration_list SEMICOLON", "var_declaration");
					(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					SymbolInfo *info = new SymbolInfo("error","declaration_list");
					info->setStart(errorLine);
					info->setEnd(errorLine);
					(yyval.symbol)->addChild((yyvsp[-3].symbol)); 
					(yyval.symbol)->addChild(info); 
					(yyval.symbol)->addChild((yyvsp[0].symbol)); 
					errorLine = -1;
					varList.clear();
					varType="";
                }
#line 2094 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 646 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"type_specifier : INT\n");
					(yyval.symbol) = new SymbolInfo("INT", "type_specifier");
					(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[0].symbol)); 
					(yyval.symbol)->setDataType("INT");
					varType = "INT";

                }
#line 2109 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 657 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"type_specifier : FLOAT\n");
					(yyval.symbol) = new SymbolInfo("FLOAT", "type_specifier");
					(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[0].symbol)); 
					(yyval.symbol)->setDataType("FLOAT");
					varType = "FLOAT";

                }
#line 2124 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 668 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"type_specifier : VOID\n");
					(yyval.symbol) = new SymbolInfo("VOID", "type_specifier");
					(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[0].symbol)); 
					(yyval.symbol)->setDataType("VOID");
					varType = "VOID";
                }
#line 2138 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 679 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"declaration_list : declaration_list COMMA ID\n");
					(yyval.symbol) = new SymbolInfo("declaration_list COMMA ID", "declaration_list");
					(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-2].symbol)); 
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					varList.push_back((yyvsp[0].symbol));

            }
#line 2154 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 691 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n");
				(yyval.symbol) = new SymbolInfo("declaration_list COMMA ID LTHIRD CONST_INT RTHIRD", "declaration_list");
				(yyval.symbol)->setStart((yyvsp[-5].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-5].symbol)); 
				(yyval.symbol)->addChild((yyvsp[-4].symbol)); 
				(yyval.symbol)->addChild((yyvsp[-3].symbol)); 
				(yyval.symbol)->addChild((yyvsp[-2].symbol)); 
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));
				varList.push_back((yyvsp[-3].symbol));
				(yyvsp[-3].symbol)->setArraySize((yyvsp[-1].symbol)->getName());
            }
#line 2173 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 706 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"declaration_list : ID\n");
				(yyval.symbol) = new SymbolInfo("ID", "declaration_list");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol)); 		
				varList.push_back((yyvsp[0].symbol));
                
            }
#line 2187 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 716 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"declaration_list : ID LTHIRD CONST_INT RTHIRD\n");
				(yyval.symbol) = new SymbolInfo("ID LTHIRD CONST_INT RTHIRD", "declaration_list");
				(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
                (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
                (yyval.symbol)->addChild((yyvsp[-3].symbol)); 
                (yyval.symbol)->addChild((yyvsp[-2].symbol)); 
                (yyval.symbol)->addChild((yyvsp[-1].symbol)); 
				(yyval.symbol)->addChild((yyvsp[0].symbol)); 
				varList.push_back((yyvsp[-3].symbol));
				(yyvsp[-3].symbol)->setArraySize((yyvsp[-1].symbol)->getName());						
            }
#line 2204 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 732 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statements : statement\n");
				(yyval.symbol) = new SymbolInfo("statement", "statements");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));

            }
#line 2217 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 741 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statements : statements statement\n");
				(yyval.symbol) = new SymbolInfo("statements statement", "statements");
				(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));
            }
#line 2230 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 752 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : var_declaration\n");
				(yyval.symbol) = new SymbolInfo("var_declaration", "statement");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));
         }
#line 2242 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 760 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : expression_statement\n");
				(yyval.symbol) = new SymbolInfo("expression_statement", "statement");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));

         }
#line 2255 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 769 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : compound_statement\n");
				(yyval.symbol) = new SymbolInfo("compound_statement", "statement");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));
         }
#line 2267 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 777 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
				(yyval.symbol) = new SymbolInfo("FOR LPAREN expression_statement expression_statement expression RPAREN statement", "statement");
				(yyval.symbol)->setStart((yyvsp[-6].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-6].symbol));
				(yyval.symbol)->addChild((yyvsp[-5].symbol));
				(yyval.symbol)->addChild((yyvsp[-4].symbol));
				(yyval.symbol)->addChild((yyvsp[-3].symbol));
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));

        }
#line 2286 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 792 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : IF LPAREN expression RPAREN statement\n");
				(yyval.symbol) = new SymbolInfo("IF LPAREN expression RPAREN statement", "statement");
				(yyval.symbol)->setStart((yyvsp[-4].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-4].symbol));
				(yyval.symbol)->addChild((yyvsp[-3].symbol));
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));

        }
#line 2303 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 804 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
				(yyval.symbol) = new SymbolInfo("IF LPAREN expression RPAREN statement ELSE statement", "statement");
				(yyval.symbol)->setStart((yyvsp[-6].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-6].symbol));
				(yyval.symbol)->addChild((yyvsp[-5].symbol));
				(yyval.symbol)->addChild((yyvsp[-4].symbol));
				(yyval.symbol)->addChild((yyvsp[-3].symbol));
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));

        }
#line 2322 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 819 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : WHILE LPAREN expression RPAREN statement\n");
				(yyval.symbol) = new SymbolInfo("WHILE LPAREN expression RPAREN statement", "statement");
				(yyval.symbol)->setStart((yyvsp[-4].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-4].symbol));
				(yyval.symbol)->addChild((yyvsp[-3].symbol));
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 2338 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 831 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"statement : RETURN expression SEMICOLON\n");
				(yyval.symbol) = new SymbolInfo("RETURN expression SEMICOLON", "statement");
				(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 2352 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 844 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"expression_statement : SEMICOLON\n");
			(yyval.symbol) = new SymbolInfo("SEMICOLON", "expression_statement");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 2364 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 852 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"expression_statement : expression SEMICOLON\n");
			(yyval.symbol) = new SymbolInfo("expression SEMICOLON", "expression_statement");
			(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[-1].symbol));
			(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 2377 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 860 "2005101.y" /* yacc.c:1646  */
    {if(errorLine == -1) errorLine = yylineno;}
#line 2383 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 861 "2005101.y" /* yacc.c:1646  */
    {

            error_count++;
			fprintf(logout,"expression_statement : expression SEMICOLON\n");
			fprintf(errorout,"Line# %d: Syntax error at expression of expression statement\n",errorLine);
			(yyval.symbol) = new SymbolInfo("expression SEMICOLON", "expression_statement");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getStart());
			SymbolInfo *info = new SymbolInfo("error","expression");
			(yyval.symbol)->setStart(errorLine);
			(yyval.symbol)->setEnd(errorLine);
			(yyval.symbol)->addChild(info);
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			errorLine = -1;
        }
#line 2403 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 878 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"variable : ID\n");
				(yyval.symbol) = new SymbolInfo("ID", "variable");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));

				SymbolInfo *info = table.LookUp((yyvsp[0].symbol)->getName());

				if(info==0)
				{
					fprintf(errorout,"Line# %d : Undeclared variable '%s'\n",(yyvsp[0].symbol)->getStart(),(yyvsp[0].symbol)->getName().c_str());
					error_count++;
				}
				else 
				{
					(yyvsp[0].symbol)->setDataType(info->getDataType());
					(yyvsp[0].symbol)->setArraySize(info->getArraySize());
				}

				(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
				(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
				(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
				for(int i=0;i<pt.size();i++){
					(yyval.symbol)->setParameter(pt[i]);
				}

        }
#line 2437 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 908 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"variable : ID LTHIRD expression RTHIRD\n");
				(yyval.symbol) = new SymbolInfo("ID LTHIRD expression RTHIRD", "variable");
				(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-3].symbol));
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));

				SymbolInfo *info = table.LookUp((yyvsp[-3].symbol)->getName());

				if(info==0)
				{
					fprintf(errorout,"Line# %d : Undeclared variable '%s'\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
					error_count++;
				}
				else 
				{
					(yyvsp[-3].symbol)->setDataType(info->getDataType());
                	(yyvsp[-3].symbol)->setArraySize(info->getArraySize());
					if(info->isArray()==false)
					{
						fprintf(errorout,"Line# %d : '%s' is not an array\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
						error_count++;
					}
					if((yyvsp[-1].symbol)->getDataType() != "INT")
					{
						error_count++;
						fprintf(errorout,"Line# %d : Array subscript is not an integer\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
            		}
				}

				(yyval.symbol)->setDataType((yyvsp[-3].symbol)->getDataType());
				(yyval.symbol)->setArraySize((yyvsp[-3].symbol)->getArraySize());
				(yyval.symbol)->setVarOrFunc((yyvsp[-3].symbol)->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[-3].symbol)->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					(yyval.symbol)->setParameter(pt[i]);
				}

        }
#line 2485 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 955 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"expression : logic_expression\n");
				(yyval.symbol) = new SymbolInfo("logic_expression", "expression");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));
				(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
				(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
				(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					(yyval.symbol)->setParameter(pt[i]);
			    }

            }
#line 2506 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 972 "2005101.y" /* yacc.c:1646  */
    {
                fprintf(logout,"expression : variable ASSIGNOP logic_expression\n");
				(yyval.symbol) = new SymbolInfo("variable ASSIGNOP logic_expression", "expression");
				(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-2].symbol)); 
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));

				if((yyvsp[0].symbol)->getDataType()=="VOID")
				{
					fprintf(errorout,"Line# %d : Void cannot be used in expression\n",(yyvsp[-2].symbol)->getStart());
					error_count++;
				}
				else if((yyvsp[-2].symbol)->getDataType() == "INT" && (yyvsp[0].symbol)->getDataType() == "FLOAT")
				{
					error_count++;
					fprintf(errorout,"Line# %d : Warning: possible loss of data in assignment of FLOAT to INT\n",(yyvsp[-2].symbol)->getStart());
				}

				(yyval.symbol)->setDataType((yyvsp[-2].symbol)->getDataType());
				(yyval.symbol)->setArraySize((yyvsp[-2].symbol)->getArraySize());
				(yyval.symbol)->setVarOrFunc((yyvsp[-2].symbol)->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[-2].symbol)->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					(yyval.symbol)->setParameter(pt[i]);
				}

            }
#line 2541 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 1004 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"logic_expression : rel_expression\n");
			(yyval.symbol) = new SymbolInfo("rel_expression", "logic_expression");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
	    	(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
			(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				(yyval.symbol)->setParameter(pt[i]);
			}	

        }
#line 2562 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 1021 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"logic_expression : rel_expression LOGICOP rel_expression\n");
			(yyval.symbol) = new SymbolInfo("rel_expression LOGICOP rel_expression", "logic_expression");
			(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[-2].symbol)); 
			(yyval.symbol)->addChild((yyvsp[-1].symbol));
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			(yyval.symbol)->setDataType("INT");

        }
#line 2578 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 1034 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"rel_expression : simple_expression\n");
			(yyval.symbol) = new SymbolInfo("simple_expression", "rel_expression");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
			(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
			(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				(yyval.symbol)->setParameter(pt[i]);
			}

        }
#line 2599 "y.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 1051 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"rel_expression : simple_expression RELOP simple_expression\n");
			(yyval.symbol) = new SymbolInfo("simple_expression RELOP simple_expression", "rel_expression");
			(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[-2].symbol));
			(yyval.symbol)->addChild((yyvsp[-1].symbol));
			(yyval.symbol)->addChild((yyvsp[0].symbol));

			if((yyvsp[-2].symbol)->getDataType() == "INT" && (yyvsp[0].symbol)->getDataType() == "FLOAT")
			{
				(yyvsp[-2].symbol)->setDataType("FLOAT");
			}
			else if((yyvsp[-2].symbol)->getDataType() == "FLOAT" && (yyvsp[0].symbol)->getDataType() =="INT")
			{
				(yyvsp[0].symbol)->setDataType("FLOAT");
			}
            (yyval.symbol)->setDataType("INT");

        }
#line 2624 "y.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 1074 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"simple_expression : term\n");
			(yyval.symbol) = new SymbolInfo("term", "simple_expression");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
			(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
			(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
			(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
			vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				(yyval.symbol)->setParameter(pt[i]);
			}
			currentValue = -1;
        }
#line 2645 "y.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 1091 "2005101.y" /* yacc.c:1646  */
    {
                        fprintf(logout,"simple_expression : simple_expression ADDOP term\n");
						(yyval.symbol) = new SymbolInfo("simple_expression ADDOP term", "simple_expression");
						(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
						(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
						(yyval.symbol)->addChild((yyvsp[-2].symbol));
						(yyval.symbol)->addChild((yyvsp[-1].symbol));
						(yyval.symbol)->addChild((yyvsp[0].symbol));

						currentValue=-1;
						
						if((yyvsp[-2].symbol)->getDataType()=="VOID"|| (yyvsp[0].symbol)->getDataType()=="VOID")
						{
							fprintf(errorout,"Line# %d : Void cannot be used in expression\n",(yyvsp[-2].symbol)->getStart());
							error_count++;
						}

						if((yyvsp[-2].symbol)->getDataType() == (yyvsp[0].symbol)->getDataType())
						{
								(yyval.symbol)->setDataType((yyvsp[-2].symbol)->getDataType());
						}
						else if((yyvsp[-2].symbol)->getDataType() == "INT" && (yyvsp[0].symbol)->getDataType() == "FLOAT")
						{
							(yyvsp[-2].symbol)->setDataType("FLOAT");
							(yyval.symbol)->setDataType("FLOAT");
						}
						else if((yyvsp[0].symbol)->getDataType() == "INT" && (yyvsp[-2].symbol)->getDataType() == "FLOAT")
						{
							(yyvsp[0].symbol)->setDataType("FLOAT");
							(yyval.symbol)->setDataType("FLOAT");
						}
						else if((yyvsp[-2].symbol)->getDataType() != "VOID")
						{
							(yyval.symbol)->setDataType((yyvsp[-2].symbol)->getDataType());
						}
						else
						{
							(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
						}
                    }
#line 2690 "y.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 1133 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"term : unary_expression\n");
            (yyval.symbol) = new SymbolInfo("unary_expression", "term");
            (yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
            (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
            (yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
            (yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
            vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
            for(int i=0;i<pt.size();i++)
            {
                (yyval.symbol)->setParameter(pt[i]);
            }
            currentValue = -1;

        }
#line 2712 "y.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 1151 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"term : term MULOP unary_expression\n");
            (yyval.symbol) = new SymbolInfo("term MULOP unary_expression", "term");
            (yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
            (yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[-2].symbol));
            (yyval.symbol)->addChild((yyvsp[-1].symbol));
            (yyval.symbol)->addChild((yyvsp[0].symbol));

            if((yyvsp[-2].symbol)->getDataType()=="VOID"||(yyvsp[0].symbol)->getDataType()=="VOID")
            {
                fprintf(errorout,"Line# %d : Void cannot be used in expression\n",(yyvsp[-2].symbol)->getStart());
                error_count++;
            }

            if((yyvsp[-1].symbol)->getName()=="%") 
            {
                if((yyvsp[-2].symbol)->getDataType()!="INT"||(yyvsp[0].symbol)->getDataType()!="INT")
                {
                    fprintf(errorout,"Line# %d : Operands of modulus must be integers\n",(yyvsp[-2].symbol)->getStart());
                    error_count++;
                }

                if(currentValue==0)
                {
                    fprintf(errorout,"Line# %d : Warning: division by zero i=0f=1Const=0\n",(yyvsp[-2].symbol)->getStart());
                    error_count++;
                }

                (yyvsp[-2].symbol)->setDataType("INT");
                (yyvsp[0].symbol)->setDataType("INT");
            }

            if((yyvsp[-1].symbol)->getName()=="/")
            {
                if(currentValue==0)
                {
                    fprintf(errorout,"Line# %d : Warning: division by zero i=0f=1Const=0\n",(yyvsp[-2].symbol)->getStart());
                    error_count++;
                }
            }

            if((yyvsp[-2].symbol)->getDataType() == (yyvsp[0].symbol)->getDataType())
            {
                    (yyval.symbol)->setDataType((yyvsp[-2].symbol)->getDataType());
            }
            else if((yyvsp[-2].symbol)->getDataType() == "INT" && (yyvsp[0].symbol)->getDataType() == "FLOAT")
            {
                (yyvsp[-2].symbol)->setDataType("FLOAT");
                (yyval.symbol)->setDataType("FLOAT");
            }
            else if((yyvsp[0].symbol)->getDataType() == "INT" && (yyvsp[-2].symbol)->getDataType() == "FLOAT")
            {
                (yyvsp[0].symbol)->setDataType("FLOAT");
                (yyval.symbol)->setDataType("FLOAT");
            }
            else if((yyvsp[-2].symbol)->getDataType()!="VOID")
            {
                (yyval.symbol)->setDataType((yyvsp[-2].symbol)->getDataType());
            }
            else
            {
                (yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
            }

        }
#line 2783 "y.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 1219 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"unary_expression : ADDOP unary_expression\n");
					(yyval.symbol) = new SymbolInfo("ADDOP unary_expression", "unary_expression");
					(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					currentValue = -1;
					(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
					(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
					(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						(yyval.symbol)->setParameter(pt[i]);
					}

                }
#line 2806 "y.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 1238 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"unary_expression : NOT unary_expression\n");
					(yyval.symbol) = new SymbolInfo("NOT unary_expression", "unary_expression");
					(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[-1].symbol));
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					currentValue = -1;
					(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
					(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
					(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						(yyval.symbol)->setParameter(pt[i]);
					}

                }
#line 2829 "y.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 1257 "2005101.y" /* yacc.c:1646  */
    {
                    fprintf(logout,"unary_expression : factor\n");
					(yyval.symbol) = new SymbolInfo("factor", "unary_expression");
					(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
					(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
					(yyval.symbol)->addChild((yyvsp[0].symbol));
					(yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
					(yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
					(yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
					vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
					for(int i=0;i<pt.size();i++)
                    {
						(yyval.symbol)->setParameter(pt[i]);
					}

                }
#line 2850 "y.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 1275 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : variable\n");
			(yyval.symbol) = new SymbolInfo("variable", "factor");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
            (yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
            (yyval.symbol)->setVarOrFunc((yyvsp[0].symbol)->getVarOrFunc());
            vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[0].symbol)->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				(yyval.symbol)->setParameter(pt[i]);
			}
        }
#line 2870 "y.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 1291 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : ID LPAREN argument_list RPAREN\n");
			(yyval.symbol) = new SymbolInfo("ID LPAREN argument_list RPAREN", "factor");
			(yyval.symbol)->setStart((yyvsp[-3].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[-3].symbol));
            (yyval.symbol)->addChild((yyvsp[-2].symbol));
            (yyval.symbol)->addChild((yyvsp[-1].symbol));
			(yyval.symbol)->addChild((yyvsp[0].symbol));

			SymbolInfo *info = table.LookUp((yyvsp[-3].symbol)->getName());

			if(info==0)
			{
				fprintf(errorout,"Line# %d : Undeclared function '%s'\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
				error_count++;
			}
			else if(checkVariable(info))
			{
				fprintf(errorout,"Line# %d : '%s' is not a function\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
				error_count++;
			}
			else 
			{
				(yyvsp[-3].symbol)->setDataType(info->getDataType());
				SymbolInfo *in = (yyvsp[-3].symbol);
				if(isFunction_declaration(in)){
                    error_count++;
                    fprintf(errorout,"Line# %d : '%s' is not defined\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
                }
				else {
					if(info->getParamSize()>argList.size()) 
					{
						fprintf(errorout,"Line# %d : Too few arguments to function '%s'\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
						error_count++;
					}
					else if(info->getParamSize()<argList.size())
					{
						fprintf(errorout,"Line# %d : Too many arguments to function '%s'\n",(yyvsp[-3].symbol)->getStart(),(yyvsp[-3].symbol)->getName().c_str());
						error_count++;
					}
					else 
					{					
						vector<pair<SymbolInfo*,SymbolInfo*>> pt = info->getParameter();
						for(int i=0;i<argList.size();i++)
						{
							if(argList[i]->getDataType()!=(pt[i].second)->getDataType())
							{
								fprintf(errorout,"Line# %d : Type mismatch for argument %d of '%s'\n",argList[i]->getStart(),(i+1),(yyvsp[-3].symbol)->getName().c_str());
								error_count++;
							}
						}
					}
				}
				(yyval.symbol)->setDataType((yyvsp[-3].symbol)->getDataType());
				(yyval.symbol)->setArraySize((yyvsp[-3].symbol)->getArraySize());
				(yyval.symbol)->setVarOrFunc((yyvsp[-3].symbol)->getVarOrFunc());
				vector<pair<SymbolInfo*,SymbolInfo*>> pt = info->getParameter();
				for(int i=0;i<pt.size();i++)
                {
					(yyval.symbol)->setParameter(pt[i]);
				}
			}
            argList.clear();

        }
#line 2941 "y.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 1358 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : LPAREN expression RPAREN\n");
			(yyval.symbol) = new SymbolInfo("LPAREN expression RPAREN", "factor");
			(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[-2].symbol));
            (yyval.symbol)->addChild((yyvsp[-1].symbol));
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType((yyvsp[-1].symbol)->getDataType());
            (yyval.symbol)->setArraySize((yyvsp[-1].symbol)->getArraySize());
            (yyval.symbol)->setVarOrFunc((yyvsp[-1].symbol)->getVarOrFunc());

			vector<pair<SymbolInfo*,SymbolInfo*>> pt = (yyvsp[-1].symbol)->getParameter();
			for(int i=0;i<pt.size();i++)
            {
				(yyval.symbol)->setParameter(pt[i]);
			}

        }
#line 2965 "y.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 1378 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : CONST_INT\n");
			(yyval.symbol) = new SymbolInfo("CONST_INT", "factor");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType("INT");
            string nm = (yyvsp[0].symbol)->getName();
            currentValue = stoi(nm);

        }
#line 2981 "y.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 1390 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : CONST_FLOAT\n");
			(yyval.symbol) = new SymbolInfo("CONST_FLOAT", "factor");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType("FLOAT");
			string nm = (yyvsp[0].symbol)->getName();
            currentValue = stoi(nm);

        }
#line 2997 "y.tab.c" /* yacc.c:1646  */
    break;

  case 69:
#line 1402 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : variable INCOP\n");
			(yyval.symbol) = new SymbolInfo("variable INCOP", "factor");
			(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[-1].symbol));
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
            (yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());

        }
#line 3013 "y.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 1414 "2005101.y" /* yacc.c:1646  */
    {
            fprintf(logout,"factor : variable DECOP\n");
			(yyval.symbol) = new SymbolInfo("variable DECOP", "factor");
			(yyval.symbol)->setStart((yyvsp[-1].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
            (yyval.symbol)->addChild((yyvsp[-1].symbol));
            (yyval.symbol)->addChild((yyvsp[0].symbol));
            (yyval.symbol)->setDataType((yyvsp[0].symbol)->getDataType());
            (yyval.symbol)->setArraySize((yyvsp[0].symbol)->getArraySize());
        }
#line 3028 "y.tab.c" /* yacc.c:1646  */
    break;

  case 71:
#line 1428 "2005101.y" /* yacc.c:1646  */
    {
            (yyval.symbol)=new SymbolInfo("arguments","arguments");
			fprintf(logout,"argument_list : arguments\n");
			(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
			(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
			(yyval.symbol)->addChild((yyvsp[0].symbol));
        }
#line 3040 "y.tab.c" /* yacc.c:1646  */
    break;

  case 72:
#line 1436 "2005101.y" /* yacc.c:1646  */
    {
            (yyval.symbol)=new SymbolInfo("","arguments");
			fprintf(logout,"argument_list : \n");
			(yyval.symbol)->setStart(yylineno);
			(yyval.symbol)->setEnd(yylineno);

        }
#line 3052 "y.tab.c" /* yacc.c:1646  */
    break;

  case 73:
#line 1447 "2005101.y" /* yacc.c:1646  */
    {
                (yyval.symbol)=new SymbolInfo("arguments COMMA logic_expression","arguments");
				fprintf(logout,"arguments : arguments COMMA logic_expression \n");
				(yyval.symbol)->setStart((yyvsp[-2].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[-2].symbol));
				(yyval.symbol)->addChild((yyvsp[-1].symbol));
				(yyval.symbol)->addChild((yyvsp[0].symbol));
				argList.push_back((yyvsp[0].symbol));

        }
#line 3068 "y.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 1459 "2005101.y" /* yacc.c:1646  */
    {
                (yyval.symbol)=new SymbolInfo("logic_expression","arguments");
				fprintf(logout,"arguments : logic_expression \n");
				(yyval.symbol)->setStart((yyvsp[0].symbol)->getStart());
				(yyval.symbol)->setEnd((yyvsp[0].symbol)->getEnd());
				(yyval.symbol)->addChild((yyvsp[0].symbol));
				argList.push_back((yyvsp[0].symbol));
        }
#line 3081 "y.tab.c" /* yacc.c:1646  */
    break;


#line 3085 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1470 "2005101.y" /* yacc.c:1906  */


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
