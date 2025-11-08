// IMPORTS
/// `const` creates an immutable binding.
/// In this case it is a type binding.
/// the specific type is the standard library type which is just module.
/// the standard library type is accessed through the compiler builtin function `@import`
const std: type = @import("std");
/// create a type level binding to the standard library's `Allocator` interface.
const Allocator: type = std.mem.Allocator;

/// `ArrayList` is a function that takes in the element type and returns the specific ArrayList type
const ArrayList: fn (type) type = std.ArrayList;

const my_lib = @import("my_lib");
const terminal = my_lib.terminal;

/// `LinkedList` is a function that takes in the element type and returns the specific `LinkedList` type.
pub fn LinkedList(T: type) type {
    // return the data structure of our linked list type
    return struct {
        // TYPES
        /// A type level binding to this specific `LinkedList` type
        const Self: type = @This();

        /// A `Node` in this `LinkedList`
        pub const Node = struct {
            /// A pointer to the actual data at this node
            data: *T,
            /// A nullable (aka optional) pointer to the next node in the list
            next: ?*Node,

            /// allocate a `Node` and it's
            ///  `T` `data`, then link the `next` `Node`
            pub fn init(allocator: Allocator, value: T, next: ?*Node) !*Node {
                // allocate memory for the node
                const output = try allocator.create(Node);
                // allocate memory for the value
                output.data = try allocator.create(T);

                // assign params to output
                output.data.* = value;
                output.next = next;

                return output;
            }
            /// recursively `deinit` all `next` `Node`s then `destroy` this `Node` and it's `T` `data`
            pub fn deinit(self: *Node, allocator: Allocator) void {
                // recursively destroy all nodes after this one
                // `self.next` being `null` is the base case
                if (self.next) |next| next.deinit(allocator);
                // deallocate data and the node itself
                allocator.destroy(self.data);
                allocator.destroy(self);
            }
        };

        // FIELDS
        /// the front of the singly linked list. default to `null`
        head: ?*Node = null,

        // CONSTANTS
        /// use the default values to initialize a `LinkedList`. use `defer node.deinit()` to clean up the `Node`s
        pub const empty = Self{};

        // DESTRUCTORS
        /// `deinit` the `head` if it exists
        pub fn deinit(self: *Self, allocator: Allocator) void {
            // same thing as `if let Some(head) = self.head { head.deinit(allocator) }`
            if (self.head) |head| head.deinit(allocator);
            // `.*` is the dereference operator in zig
            // `undefined` keyword means that any reads or writes to the value are undefined behavior
            self.* = undefined;
        }

        // ACCESSORS
        /// append value to the front of this `LinkedList`
        pub fn push(self: *Self, allocator: Allocator, value: T) !void {
            self.head = try Node.init(allocator, value, self.head);
            self.length += 1;
        }

        // MUTATORS
        /// remove the head form this `LinkedList` the caller owns the `Node` destroy it with `Node.deinit`
        pub fn pop(self: *Self) ?*Node {
            var popped = self.head orelse return null;
            self.head = popped.next;
            self.length -= 1;
            popped.next = null;
            return popped;
        }
    };
}

const test_allocator = std.testing.allocator;
const expect = std.testing.expect;
test "push and pop" {
    var l = LinkedList(usize).empty;
    defer l.deinit(test_allocator);
    for (0..100) |i| {
        try l.push(test_allocator, i);
        (try l.pop()).deinit(test_allocator);
    }
}
