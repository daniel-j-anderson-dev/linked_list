// import standard library
const std= @import("std");

/// this is a binding to the type described in `root.zig`.
/// - this is where the type is defined in the build graph see: `build.zig` line31 col43 and line38 col47
/// - this is where the type made visible to `main.zig` in the build graph see: `build.zig` line60 col36 and line81 col29
const linked_list = @import("linked_list");

pub fn main() !void {
}
