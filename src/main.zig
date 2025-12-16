// Get the UART0 physical address at compile time (passed from build.zig)
pub const UART0_ADDR: comptime_int = @import("build_options").UART0_ADDR;

// Define the UART0 data register address as a volatile pointer
const UART0DR: *volatile u32 = @ptrFromInt(UART0_ADDR);

pub fn print_uart0(s: [*:0]const u8) void {
    var p = s;
    while (p[0] != 0) : (p += 1) { // Use indexing and increment in while clause
        UART0DR.* = p[0]; // Transmit character
    }
}

pub export fn kernel_main() void {
    print_uart0("Hello world!\n");
}
