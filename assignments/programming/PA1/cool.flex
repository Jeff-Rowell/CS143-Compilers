/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 *  Define names for regular expressions here.
 */

DARROW                  =>
SINGLE_LINE_COMMENTS    --(.*)
CLASS                   [C|c][L|l][A|a][S|s][S|s]
ELSE                    [E|e][L|l][S|s][E|e]
IF                      [I|i][F|f]
FI                      [F|f][I|i]
IN                      [I|i][N|n]
ISVOID                  [I|i][S|s][V|v][O|o][I|i][D|d]
LET                     [L|l][E|e][T|t]
LOOP                    [L|l][O|o][O|o][P|p]
POOL                    [P|p][O|o][O|o][L|l]
THEN                    [T|t][H|h][E|e][N|n]
WHILE                   [W|w][H|h][I|i][L|l][E|e]
CASE                    [C|c][A|a][S|s][E|e]
ESAC                    [E|e][S|s][A|a][C|c]
NEW                     [N|n][E|e][W|w]
OF                      [O|o][F|f]
NOT                     [N|n][O|o][T|t]
TRUE                    [t][R|r][U|u][E|e]
FALSE                   [f][A|a][L|l][S|s][E|e]
INHERITS                [I|i][N|n][H|h][E|e][R|r][I|i][T|t][S|s]
TYPEID                  [A-Z]([a-zA-Z0-9_]*)
OBJECTID                [a-z]([a-zA-Z0-9_]*)
WHITESPACE              [\32|\n|\f|\r|\t|\v|[:space:]]
NEWLINE                 [\n|\r\n]
ASSIGN                  [<][-]
INT_CONST               [0-9]+
INVALID                 ['|\[|\]>]

/*  Globals used for start conditions
 *  https://westes.github.io/flex/manual/Start-Conditions.html 
 */
%x COMMENT
%x STRING
%%

 /*
  *  Matches special syntax symbols
  */
[{] {return '{';}
[}] {return '}';}
[(] {return '(';}
[)] {return ')';}
[+] {return '+';}
[-] {return '-';}
[*] {return '*';}
[/] {return '/';}
[:] {return ':';}
[;] {return ';';}
[.] {return '.';}
[,] {return ',';}
[=] {return '=';}
[<] {return '<';}

 /*
  *  Keeps track of the curent line number being scanned
  */
{NEWLINE} {
  ++curr_lineno;
}

 /*
  *  Matches integer constants
  */
{INT_CONST} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return (INT_CONST);
}

 /*
  *  Matches assignments
  */
{ASSIGN} {
  return (ASSIGN);
}

 /*
  *  One line comments
  */
{SINGLE_LINE_COMMENTS} {}

 /*
  *  Multi-line/nested comments
  */
\(\* { BEGIN(COMMENT); }
<COMMENT><<EOF>> {
  BEGIN(INITIAL);
  cool_yylval.error_msg = "EOF in comment";
  return (ERROR);
}
<COMMENT>[^*\n]* {}
<COMMENT>"*"+[^\*\)\n]* {}
<COMMENT>\n { ++curr_lineno; }
<COMMENT>\*\)\n { 
  ++curr_lineno;
  BEGIN(INITIAL); 
}

 /*
  *  Unmatched multi-line comments
  */
[*][)] {
  BEGIN(INITIAL);
  cool_yylval.error_msg = "Unmatched *)";
  return (ERROR);
}

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }

 /*
  *  Keywords are case-insensitive except for the values true and false,
  *  which must begin with a lower-case letter.
  */
{CLASS} { return (CLASS); }
{INHERITS} { return (INHERITS); }
{ELSE} { return (ELSE); }
{IF} { return (IF); }
{FI} { return (FI); }
{IN} { return (IN); }
{ISVOID} { return (ISVOID); }
{LET} { return (LET); }
{LOOP} { return (LOOP); }
{POOL} { return (POOL); }
{THEN} { return (THEN); }
{WHILE} { return (WHILE); }
{CASE} { return (CASE); }
{ESAC} { return (ESAC); }
{NEW} { return (NEW); }
{OF} { return (OF); }
{NOT} { return (NOT); }
{TRUE} { return (BOOL_CONST); }
{FALSE} { return (BOOL_CONST); }

 /*
  *  Matches Type identifiers besides self and SELF_TYPE
  */
{TYPEID} { 
  cool_yylval.symbol = idtable.add_string(yytext, yyleng);
  return (TYPEID); 
}

 /*
  *  Matches object identifiers
  */
{OBJECTID} { 
  cool_yylval.symbol = idtable.add_string(yytext, yyleng);
  return (OBJECTID); 
}

 /*
  *  Whitespace
  */
{WHITESPACE} {}

  /*
   *  Matches invalid characters and returns an error
   */
{INVALID} {
  cool_yylval.error_msg = yytext;
  return (ERROR);  
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  */
 \" string_buf_ptr = string_buf; BEGIN(STRING);
<STRING>\" { 
  /* 
   * Saw closing quote, check the length of the string buffer
   * and return an error if necessary
   */
  BEGIN(INITIAL);
  if (strlen(string_buf) > MAX_STR_CONST) {
    memset(string_buf, 0, sizeof(string_buf));
    cool_yylval.error_msg = "String constant too long";
    return (ERROR); 
  } else {
    *string_buf_ptr = '\0';
    cool_yylval.symbol = stringtable.add_string(string_buf);
    return (STR_CONST);
  } 
}
<STRING>\n {
  /* 
   * Matches unterminated string constants
   */
  BEGIN(INITIAL);
  ++curr_lineno;
  cool_yylval.error_msg = "Unterminated string constant";
  return (ERROR); 
}
<STRING>\0 {
  /* 
   * Matches the literal null character and returns an error token
   */
  BEGIN(INITIAL);
  cool_yylval.error_msg = "String contains null character";
  return (ERROR); 
}
<STRING>{
  /* 
   * Self explanatory, matches escape sequence exceptions
   */
  \\n  *string_buf_ptr++ = '\n';
  \\t  *string_buf_ptr++ = '\t';
  \\r  *string_buf_ptr++ = '\r';
  \\b  *string_buf_ptr++ = '\b';
  \\f  *string_buf_ptr++ = '\f';
  \\0  *string_buf_ptr++ = '0';
}
<STRING>\\(.|\n)  {
  /* 
   * Matches a properly escaped newline character inside a string
   */
  ++curr_lineno;
  *string_buf_ptr++ = yytext[1]; 
}
<STRING>[^\\\n\"]+ {
  /* 
   * Eats up the remainder of a valid string constant
   */
  char *yptr = yytext;
  while ( *yptr )
    *string_buf_ptr++ = *yptr++;
}
%%
