const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});
    const t = target.result;
    var os_target: []const u8 = "";
    if (t.os.tag == .linux and t.cpu.arch == .x86_64) {
        os_target = "linux_x86_64";
    } else if (t.os.tag == .linux and t.cpu.arch == .aarch64) {
        os_target = "linux_aarch64";
    } else if (t.os.tag == .windows and t.cpu.arch == .x86_64) {
        os_target = "windows_x86_64";
    } else {
        std.log.err("Unsupported target: {}\n", .{t.os.tag});
        return;
    }
    _ = b.addModule("libzlmediakit.include", .{ .root_source_file = b.path("include") });
    _ = b.addModule("libzlmediakit.library", .{ .root_source_file = b.path(b.fmt("lib/{s}", .{os_target})) });
    _ = b.addModule("libzlmediakit.h", .{ .root_source_file = b.path("include/mk_mediakit.h") });
    _ = b.addModule("libzlmediakit.so", .{ .root_source_file = b.path(b.fmt("lib/{s}/libmk_api.a", .{os_target})) });
}
