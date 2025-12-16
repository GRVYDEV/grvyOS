// Define the UART0 data register address as a volatile pointer
const UART0DR: *volatile u32 = @ptrFromInt(0x101f1000);

pub fn print_uart0(s: [*:0]const u8) void {
    var p = s;
    while (p[0] != 0) : (p += 1) { // Use indexing and increment in while clause
        UART0DR.* = p[0]; // Transmit character
    }
}

pub export fn zig_entry() void {
    print_uart0("Hello world!\n");
}
