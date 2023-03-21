filename=hi

./clear.sh

nasm -f elf64 -l $filename.lst $filename.s       #   64 bit version
ld -s -o $filename $filename.o

# nasm -f elf -l $filename.lst $filename.s        #   32 bit version
# ld -s -m elf_i386 -o $filename $filename.o

echo Compilation succeeded!

# find . -type f -executable -name "$filename"
./$filename