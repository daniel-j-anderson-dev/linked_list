const std = @import("std");
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const Allocator = std.mem.Allocator;

/// this is a binding to the type described in `root.zig`. see `build.zig` line 7, 8
const my_lib = @import("my_lib");
const LinkedList = my_lib.LinkedList;
const terminal = my_lib.terminal;

const String = ArrayList(u8);

pub fn main() !void {
    var general_purpose_allocator = GeneralPurposeAllocator(.{}).init;
    const allocator = general_purpose_allocator.allocator();

    var list = LinkedList(String).empty;
    for (0..5) |i| {
        const input = try terminal.input(allocator, "enter {}: ", .{i});
        try list.push(allocator, input);
    }
    while (list.pop()) |popped_node|
        try terminal.print(
            "{s}\n",
            .{popped_node.data.items},
        );
}
