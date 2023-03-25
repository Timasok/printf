#include <stdio.h>

extern "C" void TimPrint(const char* template_string, ...);

int main()
{
    const char * line = "Amerika";
    int year1 = 1999;
    int year2 = 1989;
    char ch = 'R';

    TimPrint("Goodbye %s oh!", line);
    TimPrint("Its %d %o %c %b %x", year1, year2, ch, 47, 12);
    puts("\n");

    // printf("My name is %s, shit %d", line, year);


}