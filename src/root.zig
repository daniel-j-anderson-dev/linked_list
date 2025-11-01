//! linked_list module
//!
//! By convention, root.zig is the root source file when making a library.

// IMPORTS

// `const` creates an immutable binding.
// In this case it is a type binding.
// the specific type is the standard library type which is just module.
// the standard library type is accessed through the compiler builtin function `@import`
const std: type = @import("std");
// create a type level binding to the standard library's `Allocator` interface.
const Allocator: type = std.mem.Allocator;
