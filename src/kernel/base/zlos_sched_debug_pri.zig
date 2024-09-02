const std = @import("std");
const t = @import("../zlos_typedef.zig");
const config = @import("../zlos_config.zig");
pub const SchedPercpu = struct {
    runtime: t.UINT64 = 0,
    contexSwitch: t.UINT32 = 0,
};

pub const SchedStat = struct {
    startRuntime: t.UINT64 = 0,
    allRuntime: t.UINT64 = 0,
    allContextSwitch: t.UINT32 = 0,
    schedPercpu: [config.LOSCFG_KERNEL_CORE_NUM]SchedPercpu = .{},
};

// extern VOID OsHwiStatistics(size_t intNum);

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif /* __cplusplus */
// #endif /* __cplusplus */

// #endif /* __LOS_SCHED_DEBUG_PRI_H */
