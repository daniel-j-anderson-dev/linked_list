const std = @import("std");
const OptimizeMode = std.builtin.OptimizeMode;
const Build = std.Build;

const executable_name = "a.out";
const executable_path = "src/main.zig";
const library_name = "linked_list";
const library_path = "src/root.zig";

pub fn build(build_graph: *Build) void {
    // SETTINGS

    // use zig to choose a default build target
    const target = build_graph.standardTargetOptions(.{});
    // use zig to choose a default build optimization
    const optimization_options = build_graph.standardOptimizeOption(.{});

    // MODULES

    // add the root library to the build graph
    const library_module = build_graph.addModule(
        library_name,
        .{
            .root_source_file = build_graph.path(library_path),
            .target = target,
            .optimize = optimization_options,
        },
    );

    // EXECUTABLES

    // add a node to compile the executable
    const compile_executable = build_graph.addExecutable(.{
        .name = executable_name,
        .root_module = build_graph.createModule(.{
            .root_source_file = build_graph.path(executable_path),
            .target = target,
            .optimize = optimization_options,
            .imports = &.{
                .{ .module = library_module, .name = library_name },
            },
        }),
    });
    // add a node to store the compiled executable binary as an artifact
    build_graph.installArtifact(compile_executable);

    // COMMANDS

    // declare `zig build run`
    const run_command = build_graph.step("run", "Run the app");
    // add a node to run the compiled executable. (`compile_executable` is the artifact that will be ran)
    const run_executable = build_graph.addRunArtifact(compile_executable);
    // running the executable depends on artifacts being installed
    run_executable.step.dependOn(build_graph.getInstallStep());
    // pass arguments from the build graph into the run command
    if (build_graph.args) |args| run_executable.addArgs(args);
    run_command.dependOn(&run_executable.step);

    // declare `zig build run`
    const test_command = build_graph.step("test", "Run tests");
    // add a compilation node for the module's tests
    const compile_module_tests = build_graph.addTest(.{ .root_module = library_module });
    // Add a run node for the module's tests
    const run_module_tests = build_graph.addRunArtifact(compile_module_tests);
    // the test command depends on each module's tests
    test_command.dependOn(&run_module_tests.step);
    
    const executable_tests = build_graph.addTest(.{ .root_module = compile_executable.root_module });
    const run_executable_tests = build_graph.addRunArtifact(executable_tests);
    test_command.dependOn(&run_executable_tests.step);
}
