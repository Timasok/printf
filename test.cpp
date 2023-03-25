#include <stdio.h>

extern "C" void TimPrint(const char* template_string, ...);

int main()
{
    const char * real_niggaz = "NWA";
    const char * cus = "motherfucking";
    int year1 = 99;
    int year2 = 1;
    char ch[2] = {'y', 'o'};

    TimPrint("%x the %s %d %s's back in this %s %c%c, get my AK-%o, b#$*!",
              year1, cus, year2, real_niggaz, cus, ch[0], ch[1], 47);

    puts("\n");

    printf("%x the %s %d %s's back in this %s %c%c, get my AK-%o, b#$*!\n",
              year1, cus, year2, real_niggaz, cus, ch[0], ch[1], 47);

}