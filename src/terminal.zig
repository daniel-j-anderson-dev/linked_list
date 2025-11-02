const builtin = @import("builtin");
const std = @import("std");
const File = std.fs.File;
const Writer = std.Io.Writer;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

fn stack_buffered(comptime n: usize) type {
    return struct {
        pub fn print(comptime format_string: []const u8, format_arguments: anytype) !void {
            var stdout_buffer = [_]u8{0} ** n;
            var stdout_reader = File.stdout().writer(&stdout_buffer);
            var stdout = &stdout_reader.interface;

            try stdout.print(format_string, format_arguments);
            try stdout.flush();
        }
        pub fn readLine(allocator: Allocator) !ArrayList(u8) {
            var stdin_buffer = [_]u8{0} ** n;
            var stdin_reader = File.stdin().reader(&stdin_buffer);
            var stdin = &stdin_reader.interface;

            var line = Writer.Allocating.init(allocator);
            defer line.deinit();
            _ = try stdin.streamDelimiterEnding(&line.writer, '\n');
            return line.toArrayList();
        }
        fn input(allocator: Allocator, comptime format_string: []const u8, format_arguments: anytype) !ArrayList(u8) {
            try .print(format_string, format_arguments);
            return try .readLine(allocator);
        }
    };
}

const buffer_size = 1024;
pub const input = stack_buffered(buffer_size).input;
pub const print = stack_buffered(buffer_size).print;
pub const readLine = stack_buffered(buffer_size).readLine;
