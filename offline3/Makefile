main:
	yacc -d -y 2005101.y
	g++ -w -c -o y.o y.tab.c
	flex 2005101.l
	g++ -w -c -o l.o lex.yy.c
	g++ y.o l.o -o parser
	./parser errorrecover.c