const kprint = @import("kernel/console/kio.zig").kprint;
const print_uart = @import("kernel/console/serial/uart.zig").print_uart0;
const raw_uart_putc = @import("kernel/console/serial/uart.zig").raw_uart_putc;
const enable_uart = @import("kernel/console/serial/uart.zig").enable_uart;

pub export fn kernel_main() void {
    enable_uart();

    kprint("Hello world!\n");
    var i: u32 = 0;
    while (i < 1_000_000_000) : (i += 1) {}
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("A" ** 300 ++ "\n");
}
