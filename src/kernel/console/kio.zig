const raw_uart_puts = @import("serial/uart.zig").raw_uart_puts;

// Tunable max length for kprint strings (excluding terminator)
const KPRINT_BUF_LEN: usize = 256;

// Global static buffer.
var kprint_buf: [KPRINT_BUF_LEN + 1]u8 = undefined;

pub fn kprint(str: [*:0]const u8) void {
    var p = str;

    while (p[0] != 0) {
        var n: usize = 0;
        while (n < KPRINT_BUF_LEN and p[n] != 0) : (n += 1) {}

        // Copy + explicit null term
        var i: usize = 0;
        while (i < n) : (i += 1) {
            kprint_buf[i] = p[i];
        }
        kprint_buf[n] = 0;

        // @ptrCast promises the 0 is there (it is, at index n)
        const chunk_ptr: [*:0]const u8 = @ptrCast(&kprint_buf);
        raw_uart_puts(chunk_ptr);

        p += n;
    }
}
