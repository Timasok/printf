CC := gcc

I_FLAG 	:=
L_FLAGS := -no-pie
C_FLAGS := #-Wno-format -g #-fsanitize=address

TEST_EXE := test

TEST_SRC := test.cpp
TEST_OBJ := test.o

ASM_SRC  := printf.s
ASM_OBJ  := printf.o

# all: link_only_c
# all: link_only_asm
all: link

link_only_asm: $(ASM_OBJ)
	@ld -s -o $(TEST_EXE) $(ASM_OBJ) 

link_only_c: $(TEST_OBJ)
	@$(CC) $(C_FLAGS) $(TEST_OBJ) -o $(TEST_EXE)

link: $(TEST_OBJ) $(ASM_OBJ)
	@$(CC) $(L_FLAGS) $(TEST_OBJ) $(ASM_OBJ) -o $(TEST_EXE)

$(ASM_OBJ) : $(ASM_SRC)
	@nasm -f elf64 -l printf.lst $(ASM_SRC) 

$(TEST_OBJ) : $(TEST_SRC)
	@$(CC) $(I_FLAG) -c $< -o $@

clean:
	./clear.sh