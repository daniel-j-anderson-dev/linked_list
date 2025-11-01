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

// `ArrayList` is a function that takes in the element type and returns the specific ArrayList type
const ArrayList: fn (type) type = std.ArrayList;

// `LinkedList` is a function that takes in the element type and returns the specific `LinkedList` type.
pub fn LinkedList(T: type) type {
    // return the data structure of our linked list type
    return struct {
        const Self: type = @This();

        /// A `Node` in the list
        pub const Node = struct {
            /// A pointer to the actual data at this node
            data: *T,
            /// A nullable pointer to the next node in the list
            next: ?*Node,

            /// allocate a `Node`
            pub fn init(allocator: Allocator, value: T, next: ?*Node) Allocator.Error!*@This() {
                // allocate memory for the node
                const output = try allocator.create(@This());
                // allocate memory for the value
                output.data = try allocator.create(T);

                // assign params to output
                output.data.* = value;
                output.next = next;

                return output;
            }
            pub fn deinit(self: *@This(), allocator: Allocator) void {
                // recursively destroy all nodes after this one
                // `self.next` being `null` is the base case
                if (self.next) |next| next.deinit(allocator);
                // deallocate data and the node itself
                allocator.destroy(self.data);
                allocator.destroy(self);
            }
        };

        /// the front of the singly linked list. default to `null`
        head: ?*Node = null,
        /// the number of `Node`s in this list. default to zero
        length: usize = 0,

        /// use the default values to initialize a `LinkedList`. use `defer` to clean up `Node`s
        pub const init = Self{};
        pub fn deinit(self: *Self, allocator: Allocator) void {
            if (self.head) |head| head.deinit(allocator);
        }

        /// define how to loop over the linked list without exposing the underlying `Node`s of the list
        pub const Iterator = struct {
            current: ?*Node,
            pub fn next(self: *@This()) ?*T {
                const output = (self.current orelse return null);
                self.current = output.next;
                return output.data;
            }
        };
        pub fn iterator(self: *Self) Iterator {
            return .{ .current = self.head };
        }
        pub fn get(self: *Self, i: usize) ?*T {
            if (i >= self.length) return null;
            var iter = self.iterator();
            var n: usize = 0;
            while (iter.next()) |element| : (n += 1)
                if (i == n) return element;
            return null;
        }

        pub fn push(self: *Self, allocator: Allocator, value: T) Allocator.Error!void {
            self.head = try Node.init(allocator, value, self.head);
            self.length += 1;
        }
        pub fn peek(self: *Self) ?*T {
            return (self.head orelse return null).data;
        }
        fn popNode(self: *Self) ?*Node {
            const old_head = self.head;
            self.head = if (self.head) |head| head.next else return null;
            self.length -= 1;
            return old_head orelse null;
        }
        pub fn pop(self: *Self) ?*T {
            return (self.popNode() orelse return null).data;
        }
    };
}
