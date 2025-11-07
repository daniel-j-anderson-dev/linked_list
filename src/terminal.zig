const std = @import("std");
const File = std.fs.File;
const Writer = std.Io.Writer;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const String = ArrayList(u8);

fn stack_buffered(comptime n: usize) type {
    return struct {
        const Self = @This();
        pub fn print(comptime format_string: []const u8, format_arguments: anytype) !void {
            var stdout_buffer = [_]u8{0} ** n;
            var stdout_writer = File.stdout().writer(&stdout_buffer);
            var stdout = &stdout_writer.interface;
            try stdout.print(format_string, format_arguments);
            try stdout.flush();
        }
        pub fn print_line(comptime format_string: []const u8, format_arguments: anytype) !void {
            return Self.print(format_string ++ "\n", format_arguments);
        }
        pub fn readLine(allocator: Allocator) !String {
            var stdin_buffer = [_]u8{0} ** n;
            var stdin_reader = File.stdin().reader(&stdin_buffer);
            var stdin = &stdin_reader.interface;

            var line = Writer.Allocating.init(allocator);
            defer line.deinit();
            _ = try stdin.streamDelimiterEnding(&line.writer, '\n');
            return line.toArrayList();
        }
        fn input(allocator: Allocator, comptime format_string: []const u8, format_arguments: anytype) !String {
            try Self.print(format_string, format_arguments);
            return try Self.readLine(allocator);
        }
    };
}

const buffer_size = 1024;
pub const input = stack_buffered(buffer_size).input;
pub const print = stack_buffered(buffer_size).print;
pub const print_line = stack_buffered(buffer_size).print_line;
pub const readLine = stack_buffered(buffer_size).readLine;
