//! my_lib module
//!
//! By convention, root.zig is the root source file when making a library.

// EXPORTS

/// this is a binding to the type described in `terminal.zig`.
/// `@import` will also add the zig source file to the build graph inside the `@This()`
pub const terminal = @import("terminal.zig");

pub const linked_list = @import("linked_list.zig");
