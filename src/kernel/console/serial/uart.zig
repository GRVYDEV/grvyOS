// Get the UART0 physical address at compile time (passed from build.zig)
const UART0_ADDR: comptime_int = @import("build_options").UART0_ADDR;

// Define the UART0 data register address as a volatile pointer
const UART0DR: *volatile u32 = @ptrFromInt(UART0_ADDR);
// Assuming standard PL011 UART registers (adjust offsets for your UART)
const UART0_FR: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x18); // Flag register

pub fn print_uart0(s: [*:0]const u8) void {
    var p = s;
    while (p[0] != 0) : (p += 1) { // Use indexing and increment in while clause
        while ((UART0_FR.* & (1 << 5)) != 0) {} // TXFFR = Transmit FIFO Full
        UART0DR.* = p[0]; // Transmit character
    }
}

pub fn raw_uart_putc(c: u8) void {
    while ((UART0_FR.* & (1 << 5)) != 0) {} // Wait TX ready
    UART0DR.* = c;
}

pub fn raw_uart_puts(s: [*:0]const u8) void {
    var p = s;
    while (p[0] != 0) : (p += 1) {
        // raw_uart_putc(p[0]);
        while ((UART0_FR.* & (1 << 5)) != 0) {} // Wait TX ready
        UART0DR.* = p[0];
    }
}
