const builtin = @import("builtin");
const std = @import("std");
const File = std.fs.File;
const Io = std.Io;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const DefaultGeneralPurposeAllocator = std.heap.GeneralPurposeAllocator(.{});

/// this is a binding to the type described in `root.zig`.
/// - this is where the type is defined in the build graph see: `build.zig` line31 col43 and line38 col47
/// - this is where the type made visible to `main.zig` in the build graph see: `build.zig` line60 col36 and line81 col29
const linked_list = @import("linked_list");
/// this is a binding to the type described in `terminal.zig` by path instead of manually thru the build graph
const terminal = @import("terminal.zig");

pub fn main() !void {
    var general_purpose_allocator = DefaultGeneralPurposeAllocator.init;
    const allocator = general_purpose_allocator.allocator();

    var x = try terminal.input(allocator, "enter a value for x: ", .{});
    defer x.deinit(allocator);
    try terminal.print("{s}\n", .{x.items});
}
