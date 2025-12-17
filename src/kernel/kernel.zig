const kprint = @import("console/kio.zig").kprint;
const enable_uart = @import("console/serial/uart.zig").enable_uart;

pub export fn kernel_main() void {
    enable_uart();

    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("A" ** 300 ++ "\n");
}
