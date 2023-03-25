#include <stdio.h>

extern "C" void TimPrint(const char* template_string, ...);

int main()
{
    const char * line = "Slim shady";
    int year = 1999;

    // TimPrint("My name is %s, its %d", line, year);
    TimPrint("Its %d", year);
    // puts("\n");

    // printf("My name is %s, shit %d", line, year);


}