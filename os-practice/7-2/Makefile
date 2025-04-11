USE_LINKER_SCRIPT = false
OUTPUT_PATH := out

SRCS_ASM := \
	start.S \
	uart.S \
	kernel.S

CROSS_COMPILE := riscv64-unknown-elf-
CC       := ${CROSS_COMPILE}gcc
OBJCOPY  := ${CROSS_COMPILE}objcopy
OBJDUMP  := ${CROSS_COMPILE}objdump
GDB      := gdb-multiarch

QEMU     := qemu-system-riscv32
QFLAGS   := -nographic -smp 1 -machine virt -bios none

CFLAGS   := -nostdlib -fno-builtin -g -Wall
CFLAGS   += -march=rv32g -mabi=ilp32

DEFS     := 
INCLUDE  := -I.

OBJS_ASM := $(addprefix ${OUTPUT_PATH}/, $(patsubst %.S, %.o, ${SRCS_ASM}))
OBJS     := ${OBJS_ASM}

ELF := ${OUTPUT_PATH}/os.elf
BIN := ${OUTPUT_PATH}/os.bin

ifeq (${USE_LINKER_SCRIPT}, true)
LDSCRIPT := os.ld
LDFLAGS  := -T ${OUTPUT_PATH}/os.ld.generated
else
LDFLAGS  := -Ttext=0x80000000
endif

.DEFAULT_GOAL := all

all: ${OUTPUT_PATH} ${ELF}

${OUTPUT_PATH}:
	@mkdir -p $@

${OUTPUT_PATH}/%.o: %.S
	${CC} ${DEFS} ${INCLUDE} ${CFLAGS} -c -o $@ $<

${ELF}: ${OBJS}
ifeq (${USE_LINKER_SCRIPT}, true)
	${CC} -E -P -x c ${DEFS} ${CFLAGS} ${LDSCRIPT} > ${OUTPUT_PATH}/os.ld.generated
endif
	${CC} ${CFLAGS} ${LDFLAGS} -o ${ELF} $^
	${OBJCOPY} -O binary ${ELF} ${BIN}

.PHONY: run
run: all
	${QEMU} ${QFLAGS} -kernel ${ELF}

.PHONY: clean
clean:
	${RM} -rf ${OUTPUT_PATH}
