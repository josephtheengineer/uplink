#rm ../bin/test.o ../bin/libtest.so
#gcc -std=c11 -fPIC -c -I../aux/headers ../src/code/test.c -o ../bin/test.o
#gcc -rdynamic -shared ../bin/test.o -o ../bin/libtest.so
