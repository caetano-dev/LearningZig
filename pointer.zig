const std = @import("std");
const expect = std.testing.expect;
const stout = std.io.getStdOut().writer();

fn incrementAsReference(num: *u8) void {
    num.* += 1;
}

fn incrementAsValue(num: u8) u8 {
    const incremented: u8 = num + 1;
    return incremented;
}
pub fn main() !void {
    var x: u8 = 1;
    incrementAsReference(&x);
    try stout.print("x = {}\n", .{x});

    const y: u8 = 1;
    const y_incremented = incrementAsValue(y);
    try stout.print("y = {}\n", .{y_incremented});
}

test "asReference" {
    var x: u8 = 1;
    incrementAsReference(&x);
    try expect(x == 2);
}

test "asValue" {
    const y: u8 = 1;
    const y_incremented = incrementAsValue(y);
    try expect(y_incremented == 2);
}
