const std = @import("std");
const OptimizeMode = std.builtin.OptimizeMode;
const Build = std.Build;

const executable_name = "a.out";
const executable_path = "src/main.zig";

const str = []const u8; // type alias `str` for a slice of bytes
const module_meta_data = [_]struct { str, str }{
    .{ "linked_list", "src/root.zig" },
    .{ "terminal", "src/terminal.zig" },
};
const module_count = module_meta_data.len;

pub fn build(build_graph: *Build) void {
    // SETTINGS

    // use zig to choose a default build target
    const target = build_graph.standardTargetOptions(.{});
    // use zig to choose a default build optimization
    const optimization_options = build_graph.standardOptimizeOption(.{});

    // MODULES

    // declare arrays to hold pointers to each `Build.Module` added to the `build_graph` and
    var modules: [module_count]*Build.Module = undefined;
    var executable_imports: [module_count]Build.Module.Import = undefined;
    // populate arrays
    for (0..module_count) |i| {
        // get the name and path of each module from the global constant
        const name, const path = module_meta_data[i];
        // add a node that represent the `i`th source file as a module
        modules[i] = build_graph.addModule(
            name,
            .{
                .root_source_file = build_graph.path(path),
                .target = target,
                .optimize = optimization_options,
            },
        );
        executable_imports[i] = .{
            .name = name,
            .module = modules[i],
        };
    }

    // EXECUTABLES

    // add a node to compile the executable
    const compile_executable = build_graph.addExecutable(.{
        .name = executable_name,
        .root_module = build_graph.createModule(.{
            .root_source_file = build_graph.path(executable_path),
            .target = target,
            .optimize = optimization_options,
            .imports = &executable_imports,
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
    // add each test node
    for (modules) |module| {
        // add a compilation node for the test module
        const compile_module_tests = build_graph.addTest(.{ .root_module = module });
        // Add a run node for the module's tests
        const run_module_tests = build_graph.addRunArtifact(compile_module_tests);
        // the test command depends on each module's tests
        test_command.dependOn(&run_module_tests.step);
    }
    const compile_executable_test = build_graph.addTest(.{ .root_module = compile_executable.root_module });
    const run_module_tests = build_graph.addRunArtifact(compile_executable_test);
    test_command.dependOn(&run_module_tests.step);
}
