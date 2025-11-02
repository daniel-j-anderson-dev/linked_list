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
            /// free this node and recursively free all `next` nodes
            pub fn deinit(self: *Node, allocator: Allocator) void {
                // recursively destroy all nodes after this one
                // `self.next` being `null` is the base case
                if (self.next) |next| next.deinit(allocator);
                // deallocate data and the node itself
                allocator.destroy(self.data);
                allocator.destroy(self);
                self.* = undefined;
            }
        };

        /// the front of the singly linked list. default to `null`
        head: ?*Node = null,
        /// the number of `Node`s in this list. default to zero
        length: usize = 0,

        /// use the default values to initialize a `LinkedList`. use `defer` to clean up the `Node`s
        pub const init = Self{};
        /// `deinit` the `head` if it exists
        pub fn deinit(self: *Self, allocator: Allocator) void {
            if (self.head) |head| head.deinit(allocator);
        }

        /// Returns the a constant pointer to the element at the given `index` (the `head` of the this `LinkedList` is index 0).
        pub fn get(self: *const Self, index: usize) !*const T {
            if (self.length == 0) return error.Empty;
            if (index >= self.length) return error.IndexOutOfBounds;

            var i: usize = 0;
            var current = self.head;
            while (current) |c| : (current = c.next) {
                if (i == index) break;
                i += 1;
            }
            return current.?.data;
        }
        /// Assigns the a `data` pointer of the element at the given `index` (the `head` of the this `LinkedList` is index 0).
        pub fn set(self: *Self, index: usize, data: *T) !void {
            if (self.length == 0) return error.Empty;
            if (index >= self.length) return error.IndexOutOfBounds;

            var i: usize = 0;
            var current = self.head;
            while (current) |c| : (current = c.next) {
                if (i == index) break;
                i += 1;
            }
            current.?.data = data;
        }
        /// append value to the front of this `LinkedList`
        pub fn push(self: *Self, allocator: Allocator, value: T) !void {
            self.head = try Node.init(allocator, value, self.head);
            self.length += 1;
        }
        /// remove the head form this `LinkedList` the caller owns the `T` value
        pub fn pop(self: *Self) !*T {
            const old_head = self.head orelse return error.Empty;
            self.head = old_head.next;
            self.length -= 1;
            return old_head.data;
        }
    };
}
