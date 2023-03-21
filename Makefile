CC := gcc
I_FLAG 	:=
L_FLAGS := -no-pie
TEST_EXE := test

# TEST_SRC := test.cpp
# TEST_OBJ := test.o

TEST_SRC := 
TEST_OBJ := 

ASM_SRC  := printf.s
ASM_OBJ  := printf.o

all: link_only_asm
# all: link

link: $(TEST_OBJ) $(ASM_OBJ)
	@$(CC) $(L_FLAGS) $(TEST_OBJ) $(ASM_OBJ) -o $(TEST_EXE)

$(ASM_OBJ) : $(ASM_SRC)
	@nasm -f elf64 -l printf.lst $(ASM_SRC) 

$(TEST_OBJ) : $(TEST_SRC)
	@$(CC) $(I_FLAG) -c $< -o $@

link_only_asm: 
	@ld -s -o $(TEST_EXE) $(ASM_OBJ) 

clean:
	./clear.sh