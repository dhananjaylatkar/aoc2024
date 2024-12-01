const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len != 2) {
        usage();
    }

    const day = try std.fmt.parseInt(u8, args[1], 10);

    switch (day) {
        1 => try @import("day_01.zig").run(),
        else => {
            if (day > 25) print("hehe :)\n", .{}) else print("not implemented :(\n", .{});
        },
    }
}

fn usage() void {
    print("Usage: aoc2024 <day>\n", .{});
    std.process.exit(1);
}
