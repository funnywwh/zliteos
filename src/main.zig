const std = @import("std");
const init = @import("./kernel/init/zlos_init.zig");
pub fn main() !void {
    _ = try init.OsGetMainTask();
    try init.OsSetMainTask();
    _ = try init.OsRegister();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
