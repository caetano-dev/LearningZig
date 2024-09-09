const std = @import("std");
const ArrayList = std.ArrayList;
const stout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var todos = ArrayList([]const u8).init(allocator);
    defer {
        for (todos.items) |item| {
            allocator.free(item);
        }
        todos.deinit();
    }

    while (true) {
        try stout.print("Enter a command: ", .{});
        var command_buf: [100]u8 = undefined;
        const command = try stdin.readUntilDelimiter(&command_buf, '\n');

        if (std.mem.eql(u8, command, "exit")) {
            break;
        } else if (std.mem.eql(u8, command, "list")) {
            for (todos.items, 0..) |todo, i| {
                try stout.print("{d}. {s}\n", .{ i + 1, todo });
            }
        } else if (std.mem.eql(u8, command, "add")) {
            try stout.print("Enter a todo: ", .{});
            var todo_buf: [100]u8 = undefined;
            const todo_input = try stdin.readUntilDelimiter(&todo_buf, '\n');

            const todo = try allocator.dupe(u8, todo_input);
            try todos.append(todo);

            try stout.print("Todo added: {s}\n", .{todo});
        } else {
            try stout.print("Unknown command: {s}\n", .{command});
        }
    }
}
