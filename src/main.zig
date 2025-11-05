const std = @import("std");
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const Allocator = std.mem.Allocator;

/// this is a binding to the type described in `linked_list.zig`. see `build.zig` line 10
const linked_list = @import("linked_list");
const LinkedList = linked_list.LinkedList;

/// this is a binding to the type described in `terminal.zig`. see `build.zig` line 11
const terminal = @import("terminal");

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
