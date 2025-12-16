const kprint = @import("kernel/console/kio.zig").kprint;
const print_uart = @import("kernel/console/serial/uart.zig").print_uart0;
const raw_uart_putc = @import("kernel/console/serial/uart.zig").raw_uart_putc;

pub export fn kernel_main() void {
    kprint("Hello world!\n");
    kprint("Hello world!\n");
    kprint("Hello world!\n");
}
