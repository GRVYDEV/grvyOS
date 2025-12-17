const std = @import("std");

pub fn build(b: *std.Build) void {
    const build_options_32 = b.addOptions();
    build_options_32.addOption(u64, "UART0_ADDR", 0x101f1000);

    const build_options_64 = b.addOptions();
    build_options_64.addOption(u64, "UART0_ADDR", 0x09000000);

    const target_32 = b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm926ej_s },
        .os_tag = .freestanding,
        .abi = .none,
    });

    const target_64 = b.resolveTargetQuery(.{
        .cpu_arch = .aarch64,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_a57 },
        .os_tag = .freestanding,
        .abi = .none,
    });

    const exe32 = b.addExecutable(.{
        .name = "kernel32.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/kernel/kernel.zig"),
            .target = target_32,
            .link_libc = false,
            .strip = true,
        }),
    });
    exe32.root_module.addOptions("build_options", build_options_32);
    exe32.addAssemblyFile(b.path("src/bootloader/startup.s"));
    exe32.setLinkerScript(b.path("src/versatilepb.ld"));

    const exe64 = b.addExecutable(.{
        .name = "kernel64.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/kernel/kernel.zig"),
            .target = target_64,
            .link_libc = false,
            .strip = true,
        }),
    });
    exe64.root_module.addOptions("build_options", build_options_64);
    exe64.addAssemblyFile(b.path("src/bootloader/startup64.s"));
    exe64.setLinkerScript(b.path("src/virt.ld"));

    // Install ELF
    b.installArtifact(exe32);
    b.installArtifact(exe64);

    // QEMU run step
    const run_step_32 = b.addSystemCommand(&.{
        "qemu-system-arm",
        // use ctrl + g as qemu escape char to avoid collision with zellij
        "-echr",
        "0x07",
        "-M",
        "versatilepb",
        "-nographic",
        "-kernel",
        b.getInstallPath(.bin, "kernel32.elf"),
    });
    run_step_32.step.dependOn(&exe32.step);

    const run_step_64 = b.addSystemCommand(&.{
        "qemu-system-aarch64",
        // use ctrl + g as qemu escape char to avoid collision with zellij
        "-echr",
        "0x07",
        "-M",
        "virt",
        "-nographic",
        "-cpu",
        "cortex-a57",
        "-kernel",
        b.getInstallPath(.bin, "kernel64.elf"),
    });
    run_step_64.step.dependOn(&exe64.step);

    const qemu_step_32 = b.step("qemu32", "Run in QEMU versatilepb");
    qemu_step_32.dependOn(&run_step_32.step);

    const qemu_step_64 = b.step("qemu64", "Run in QEMU versatilepb");
    qemu_step_64.dependOn(&run_step_64.step);
}
