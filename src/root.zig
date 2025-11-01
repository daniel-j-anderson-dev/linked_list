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
const ArrayList: fn (type) type = std.ArrayList;

/// A singly linked list
pub fn LinkedList(T: type) type {
    // return the data structure of our linked list type
    return struct {
        const Self: type = @This();

        /// A `Node` in the list
        pub const Node = struct {
            // A pointer to the actual data at this node
            data: *T,
            // A nullable pointer to the next node in the list
            next: ?*Node,
        };

        /// the front of the singly linked list
        head: ?*Node = null,
        /// the number of `Node`s in this list
        length: usize = 0,

        // CONSTRUCTORS

        pub const EMPTY = Self{};

        // ITERATORS

        pub const ImmutableIterator = struct {
            current: ?*const Node,
            pub fn next(self: *@This()) ?*const T {
                const output = (self.current orelse return null);
                self.current = output.next;
                return output.data;
            }
        };
        pub const MutableIterator = struct {
            current: ?*Node,
            pub fn next(self: *@This()) ?*T {
                const output = (self.current orelse return null);
                self.current = output.next;
                return output.data;
            }
        };
        pub fn immutable_iterator(self: *const Self) ImmutableIterator {
            return ImmutableIterator{ .current = self.head };
        }
        pub fn mutable_iterator(self: *Self) MutableIterator {
            return MutableIterator{ .current = self.head };
        }

        pub fn get(self: *Self, i: usize) ?*T {
            if (i >= self.length) return null;
            var n: usize = 0;
            var current = self.head;
            while (current.next) |next| : (current = next) {
                if (n == i) return current.data;
                n += 1;
            }
        }
        pub fn push(self: *Self, allocator: Allocator, value: T) Allocator.Error!void {
            var new_head = try allocator.create(Node);
            new_head.data = try allocator.create(T);

            new_head.data.* = value;
            new_head.next = self.head;

            self.head = new_head;
        }
        pub fn peek(self: *Self) ?*T {
            return (self.head orelse return null).data;
        }
        pub fn pop(self: *Self) ?*T {
            const old_head = self.peek();
            self.head = if (self.head) |head| head.next else return null;
            return old_head orelse null;
        }
    };
}

// TESTS

const expect = std.testing.expect;
const testing_allocator = std.testing.allocator;

test "test stack" {
    var linked_list = LinkedList(u8).EMPTY;
    // try is like ? in rust is the function returns an error then return the error
    try linked_list.push(testing_allocator, 'a');
    try linked_list.push(testing_allocator, 'b');
    try linked_list.push(testing_allocator, 'c');
    try linked_list.push(testing_allocator, 'd');
    try expect(linked_list.pop().?.* == 'd');
    try expect(linked_list.pop().?.* == 'c');
    try expect(linked_list.pop().?.* == 'b');
    try expect(linked_list.pop().?.* == 'a');
}

test "iterators" {
    var linked_list = LinkedList(u8).EMPTY;

    try linked_list.push(testing_allocator, '1');
    try linked_list.push(testing_allocator, '2');
    try linked_list.push(testing_allocator, '3');

    const expected_values = [_]u8{ '3', '2', '1' };

    var iterator = linked_list.immutable_iterator();
    var i: usize = 0;
    while (iterator.next()) |element| : (i += 1)
        try expect(expected_values[i] == element.*);
}
