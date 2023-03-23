#include <stdio.h>

extern "C" void TimPrint(const char* template_string, ...);

int main()
{
    const char * line = "Slim shady";
    int year = 1999;

    TimPrint("My name is %s, its %d%s, its %d%s, its %d%s, its %d", line, year);

    // printf("My name id %s, %d%d%d%d%d%d%d%d", line, year, year, year, year, year, year, year, year);
}