const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const input_file = "./input/day_01.txt";

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) print("Memory leak detected\n", .{});
    }
    var in = try std.fs.cwd().openFile(input_file, .{ .mode = .read_only });
    defer in.close();

    const file_contents = try in.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_contents);

    var lines = std.mem.tokenizeSequence(u8, file_contents, "\n");

    var left_list = std.ArrayList(i64).init(allocator);
    defer left_list.deinit();

    var right_list = std.ArrayList(i64).init(allocator);
    defer right_list.deinit();

    while (lines.next()) |line| {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const left_token = tokens.next().?;
        const right_token = tokens.next().?;

        const left_int = try std.fmt.parseInt(i64, left_token, 10);
        const right_int = try std.fmt.parseInt(i64, right_token, 10);

        try left_list.append(left_int);
        try right_list.append(right_int);
    }

    assert(left_list.items.len == right_list.items.len);

    std.mem.sort(i64, left_list.items, {}, std.sort.asc(i64));
    std.mem.sort(i64, right_list.items, {}, std.sort.asc(i64));

    var p1: u64 = 0;
    for (left_list.items, right_list.items) |l, r| {
        p1 += @abs(l - r);
    }
    print("D01P1: {}\n", .{p1});

    var p2: i64 = 0;
    for (left_list.items) |l| {
        var count: i64 = 0;
        for (right_list.items) |r| {
            if (r > l) break;
            if (r == l) count += 1;
        }
        p2 += l * count;
    }
    print("D01P2: {}\n", .{p2});
}
