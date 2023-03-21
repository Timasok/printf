echo Hello world
filename=hi

nasm -f elf -l $filename.lst $filename.s
ld -s -m elf_i386 -o $filename $filename.o

# @cls