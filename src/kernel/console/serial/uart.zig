// Get the UART0 physical address at compile time (passed from build.zig)
const UART0_ADDR: comptime_int = @import("build_options").UART0_ADDR;

// Define the UART0 data register address as a volatile pointer
const UART0DR: *volatile u32 = @ptrFromInt(UART0_ADDR);
// Assuming standard PL011 UART registers (adjust offsets for your UART)
const UART0_FR: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x18); // Flag register
const UART0_IBRD: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x24);
const UART0_FBRD: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x28);
const UART0_LCRH: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x2C);
const UART0_CR: *volatile u32 = @ptrFromInt(UART0_ADDR + 0x30);

const UART_FIFO = 4;
const UART_8B_WLEN = 0b11;
const UART_WLEN = 5;
const UART_EN = 0;
const UART_TXE = 8;
const UART_RXE = 9;

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

pub fn enable_uart() void {
    // disable uart to configure
    UART0_CR.* = 0x0;

    const ibrd: u32 = 1;
    const fbrd: u32 = 40;
    // const baud: u32 = 115200;

    UART0_IBRD.* = ibrd;
    UART0_FBRD.* = fbrd;

    UART0_LCRH.* = (1 << UART_FIFO) | (UART_8B_WLEN << UART_WLEN);
    UART0_CR.* = (1 << UART_EN) | (1 << UART_TXE) | (1 << UART_RXE);
}
