const std = @import("std");
const init = @import("./kernel/init/zlos_init.zig");
pub fn main() !void {
    try init.OsMain();
}

test "simple test" {}
