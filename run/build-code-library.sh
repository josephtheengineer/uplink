gcc -std=c11 -fPIC -c -I../aux/headers ../src/code/test.c -o test.o
gcc -rdynamic -shared test.o -o ../bin/libtest.so
