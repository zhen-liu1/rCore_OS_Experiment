TARGET = riscv64gc-unknown-none-elf
MODE = release
KERNEL_ELF = target/$(TARGET)/$(MODE)/os
KERNEL_BIN = $(KERNEL_ELF).bin
BOOTLOADER = ../bootloader/rustsbi-qemu.bin
KERNEL_ENTRY_PA = 0x80200000

# Binutils
OBJDUMP := rust-objdump --arch-name=riscv64
OBJCOPY := rust-objcopy --binary-architecture=riscv64

QEMU_ARGS := -machine virt \
			 -nographic \
			 -bios $(BOOTLOADER) \
			 -device loader,file=$(KERNEL_BIN),addr=$(KERNEL_ENTRY_PA)

run: $(KERNEL_BIN)
	qemu-system-riscv64 $(QEMU_ARGS)

$(KERNEL_BIN): src/*
	cargo build --$(MODE)
	@$(OBJCOPY) $(KERNEL_ELF) --strip-all -O binary $@

.PHONY: run 