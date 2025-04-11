### === 项目通用配置 ===
USE_LINKER_SCRIPT = false
OUTPUT_PATH := out

SRCS_ASM := \
	start.S \
	uart.S \
	kernel.S

SRCS_C :=

### === 工具链设置 ===
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

### === 源文件 & 目标文件 ===
OBJS_ASM := $(addprefix ${OUTPUT_PATH}/, $(patsubst %.S, %.o, ${SRCS_ASM}))
OBJS_C   := $(addprefix ${OUTPUT_PATH}/, $(patsubst %.c, %.o, ${SRCS_C}))
OBJS     := ${OBJS_ASM} ${OBJS_C}

ELF := ${OUTPUT_PATH}/os.elf
BIN := ${OUTPUT_PATH}/os.bin

### === 链接配置 ===
ifeq (${USE_LINKER_SCRIPT}, true)
LDSCRIPT := os.ld
LDFLAGS  := -T ${OUTPUT_PATH}/os.ld.generated
else
LDFLAGS  := -Ttext=0x80000000
endif

### === 默认目标 ===
.DEFAULT_GOAL := all

all: ${OUTPUT_PATH} ${ELF}

${OUTPUT_PATH}:
	@mkdir -p $@

### === 编译汇编和 C 源文件 ===
${OUTPUT_PATH}/%.o: %.S
	${CC} ${DEFS} ${INCLUDE} ${CFLAGS} -c -o $@ $<

${OUTPUT_PATH}/%.o: %.c
	${CC} ${DEFS} ${INCLUDE} ${CFLAGS} -c -o $@ $<

### === 链接生成 ELF + BIN ===
${ELF}: ${OBJS}
ifeq (${USE_LINKER_SCRIPT}, true)
	@echo "[LD] Preprocessing linker script..."
	${CC} -E -P -x c ${DEFS} ${CFLAGS} ${LDSCRIPT} > ${OUTPUT_PATH}/os.ld.generated
endif
	@echo "[LD] Linking kernel ELF..."
	${CC} ${CFLAGS} ${LDFLAGS} -o ${ELF} $^
	@echo "[CP] Copying binary..."
	${OBJCOPY} -O binary ${ELF} ${BIN}

### === 运行项目 ===
.PHONY: run
run: all
	@echo "------------------------------------"
	@echo "Press Ctrl-A then X to exit QEMU"
	@${QEMU} ${QFLAGS} -kernel ${ELF}

### === 调试 ===
.PHONY: debug
debug: all
	@echo "Press Ctrl-C in GDB to stop"
	@${QEMU} ${QFLAGS} -kernel ${ELF} -s -S &
	@${GDB} ${ELF} -q -x ../gdbinit

### === 查看反汇编 ===
.PHONY: code
code: all
	${OBJDUMP} -S ${ELF} | less

### === 清理 ===
.PHONY: clean
clean:
	${RM} -rf ${OUTPUT_PATH}
