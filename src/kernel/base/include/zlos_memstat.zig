const t = @import("../../../kernel/zlos_typedef.zig");
const defines = @import("../../../kernel/zlos_defines.zig");
const config = @import("../../../kernel/zlos_config.zig");
// extra 1 blocks is for extra temparary task */
// #define TASK_NUM        (LOSCFG_BASE_CORE_TSK_LIMIT + 1)
pub const TASK_NUM = config.LOSCFG_BASE_CORE_TSK_LIMIT;

// #ifdef LOSCFG_MEM_TASK_STAT
pub const TaskMemUsedInfo = struct {
    memUsed: t.UINT32 = 0,
    memPeak: t.UINT32 = 0,
};

pub const Memstat = struct {
    memTotalUsed: t.UINT32 = 0,
    memTotalPeak: t.UINT32 = 0,
    taskMemstats: [TASK_NUM]TaskMemUsedInfo = .{},
    // extern VOID OsMemstatTaskUsedInc(Memstat *stat, UINT32 usedSize, UINT32 taskId);
    pub fn taskUsedInc(stat: *Memstat, usedSize: t.UINT32, taskId: t.UINT32) void {
        _ = stat;
        _ = usedSize;
        _ = taskId;
    }
    // extern VOID OsMemstatTaskUsedDec(Memstat *stat, UINT32 usedSize, UINT32 taskId);
    pub fn taskUsedDec(stat: *Memstat, usedSize: t.UINT32, taskId: t.UINT32) void {
        _ = stat;
        _ = usedSize;
        _ = taskId;
    }
    // extern VOID OsMemstatTaskClear(Memstat *stat, UINT32 taskId);
    pub fn taskClear(stat: *Memstat, taskId: t.UINT32) void {
        _ = stat;
        _ = taskId;
    }
    // extern UINT32 OsMemstatTaskUsage(const Memstat *stat, UINT32 taskId);
    pub fn taskUsage(stat: *Memstat, taskId: t.UINT32) t.UINT32 {
        _ = stat;
        _ = taskId;
        return 0;
    }
};

// extern VOID OsMemTaskClear(UINT32 taskId);
pub fn OsMemTaskClear(taskId: t.UINT32) void {
    _ = taskId;
}
// extern UINT32 OsMemTaskUsage(UINT32 taskId);
pub fn OsMemTaskUsage(taskId: t.UINT32) t.UINT32 {
    _ = taskId;
}
