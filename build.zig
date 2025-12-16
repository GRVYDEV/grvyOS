const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .arm,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm926ej_s },
        .os_tag = .freestanding,
        .abi = .none,
    } });

    const exe = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .link_libc = false,
            // NOTE: this is needed otherwise the elf entrypoint does not work
            .optimize = .ReleaseSmall,
        }),
    });
    exe.addAssemblyFile(b.path("src/bootloader/startup.s"));
    exe.setLinkerScript(b.path("src/versatilepb.ld"));

    // Install ELF
    b.installArtifact(exe);

    const kernel_bin_path = b.fmt("zig-out/bin/kernel.bin", .{});
    // Add objcopy step - create kernel.bin from ELF
    const objcopy_step = b.addSystemCommand(&.{
        "arm-none-eabi-objcopy",
        "-O",
        "binary",
        b.getInstallPath(.bin, "kernel.elf"),
        kernel_bin_path,
    });

    objcopy_step.step.dependOn(&exe.step);

    // Custom steps
    const install_bin_step = b.step("install-bin", "Install kernel.bin");
    install_bin_step.dependOn(&objcopy_step.step);

    b.default_step.dependOn(install_bin_step);

    // QEMU run step
    const run_step = b.addSystemCommand(&.{
        "qemu-system-arm",
        // use ctrl + g as qemu escape char to avoid collision with zellij
        "-echr",
        "0x07",
        "-M",
        "versatilepb",
        "-nographic",
        "-kernel",
        kernel_bin_path,
    });
    run_step.step.dependOn(install_bin_step);

    const qemu_step = b.step("qemu", "Run in QEMU");
    qemu_step.dependOn(&run_step.step);
}
