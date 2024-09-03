const std = @import("std");
const t = @import("./zlos_typedef.zig");
// /**
//  * @ingroup los_list
//  * Structure of a node in a doubly linked list.
//  */
pub const LOS_DL_LIST = struct {
    pstPrev: ?*LOS_DL_LIST = null, //**< Current node's pointer to the previous node */
    pstNext: ?*LOS_DL_LIST = null, //**< Current node's pointer to the next node */

    pub fn init(this: *LOS_DL_LIST) void {
        this.pstPrev = this;
        this.pstNext = this;
    }
    pub fn first(this: *LOS_DL_LIST) ?*LOS_DL_LIST {
        return this.pstNext;
    }
    // /**
    //  * @ingroup los_list
    //  * @brief Point to the previous node of the current node.
    //  *
    //  * @par Description:
    //  * This API is used to point to the previous node of the current node.
    //  * @attention
    //  * None.
    //  *
    pub fn last(this: *LOS_DL_LIST) ?*LOS_DL_LIST {
        return this.pstPrev;
    }
    pub fn add(this: *LOS_DL_LIST, node: *LOS_DL_LIST) void {
        node.pstNext = this.pstNext;
        node.pstPrev = this;
        if (this.pstNext) |pstNext| {
            pstNext.pstPrev = node;
        }
        this.pstNext = node;
    }
    pub fn insert(this: *LOS_DL_LIST, node: *LOS_DL_LIST) void {
        this.add(node);
    }
    pub fn tailInsert(this: *LOS_DL_LIST, node: *LOS_DL_LIST) void {
        if (this.pstPrev) |prev| {
            prev.add(node);
        }
    }
    pub fn headInsert(this: *LOS_DL_LIST, node: *LOS_DL_LIST) void {
        this.add(node);
    }
    pub fn delete(node: *LOS_DL_LIST) void {
        node.pstNext.pstPrev = node.pstPrev;
        node.pstPrev.pstNext = node.pstNext;
        node.pstNext = null;
        node.pstPrev = null;
    }
    pub fn delInit(this: *LOS_DL_LIST) void {
        this.pstNext.pstPrev = this.pstPrev;
        this.pstPrev.pstNext = this.pstNext;
        this.init();
    }
    pub fn empty(this: *LOS_DL_LIST) bool {
        return this == this.pstNext;
    }

    pub const Iter = struct {
        head: ?*LOS_DL_LIST = null,
        nxt: ?*LOS_DL_LIST = null,
        pub fn next(this: *Iter, T: type, comptime fieldName: []const u8) ?*T {
            if (this.nxt) |_next| {
                const obj: *T = @fieldParentPtr(fieldName, _next);
                this.nxt = _next.pstNext;
                std.log.debug("next:{*}", .{this.nxt});
                if (this.nxt == this.head) {
                    this.nxt = null;
                }
                std.log.debug("obj.id:{d}", .{obj.id});
                return obj;
            }
            return null;
        }
    };
    pub fn for_each(this: *LOS_DL_LIST) Iter {
        const iter = Iter{
            .head = this,
            .nxt = this,
        };
        std.log.debug("iter.head:{*}", .{this});
        return iter;
    }
};

test "list" {
    std.testing.log_level = .debug;
    const A = struct {
        id: u32 = 0,
        list: LOS_DL_LIST = .{},
    };
    var a: A = .{
        .id = 1,
    };
    var b: A = .{
        .id = 2,
    };
    var c: A = .{
        .id = 3,
    };
    var d: A = .{
        .id = 4,
    };
    std.log.debug("a:{*}\nb:{*}\nc:{*}\nd:{*}", .{ &a.list, &b.list, &c.list, &d.list });
    a.list.init();
    b.list.init();
    c.list.init();
    d.list.init();

    a.list.add(&b.list);
    b.list.add(&c.list);
    try std.testing.expect(a.list.pstNext == &b.list);
    try std.testing.expect(b.list.pstNext == &c.list);

    std.log.debug("begin loop1", .{});
    var iter = a.list.for_each();
    while (iter.next(A, "list")) |item| {
        std.log.debug("next:{d}", .{item.id});
    }
    std.log.debug("begin loop2", .{});
    iter = c.list.for_each();
    while (iter.next(A, "list")) |item| {
        std.log.debug("next:{d}", .{item.id});
    }

    a.list.init();
    b.list.init();
    c.list.init();
    d.list.init();
    try std.testing.expect(a.list.empty() == true);
    a.list.add(&b.list);
    b.list.add(&c.list);
    a.list.tailInsert(&d.list);
    try std.testing.expect(a.list.pstNext == &b.list);
    try std.testing.expect(b.list.pstNext == &c.list);
    try std.testing.expect(c.list.pstNext == &d.list);
    try std.testing.expect(d.list.pstNext == &a.list);

    std.log.debug("begin loop3", .{});
    iter = d.list.for_each();
    var i: u32 = 0;
    while (iter.next(A, "list")) |item| : (i += 1) {
        std.log.debug("next:{d}", .{item.id});
    }
    try std.testing.expect(i == 4);
}
