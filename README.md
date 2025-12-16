# grvyOS

This is an attempt to implement an OS similar to [RedactedOS](https://github.com/differrari/RedactedOS/) in Zig

## Commands

```bash
zig build
```

Builds a kernel.elf and kernel.bin file at zig-out/bin

```bash
zig build qemu
```

**NOTE**: The qemu escape character is remapped from ctrl + a to ctrl + g

Builds the kernel.bin and then runs it with qemu
