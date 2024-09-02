const std = @import("std");
const t = @import("../zlos_typedef.zig");
const task = @import("../base/zlos_task.zig");
const config = @import("../zlos_config.zig");
var g_mainTask: [config.LOSCFG_KERNEL_CORE_NUM]task.LosTaskCB = undefined;
const cpu = @import("../../arch/arm/cortex_a_r/include/arch/cpu.zig");
const task_pri = @import("../base/zlos_task_pri.zig");
const defines = @import("../zlos_defines.zig");
const misc = @import("../base/zlos_misc.zig");
const tick = @import("../base/zlos_tick.zig");
pub fn OsGetMainTask() !*t.VOID {
    return @ptrCast(&g_mainTask[cpu.ArchCurrCpuid()]);
}
pub fn OsSetMainTask() !void {
    for (0..config.LOSCFG_KERNEL_CORE_NUM) |i| {
        g_mainTask[i].taskStatus = task_pri.OS_TASK_STATUS_UNUSED;
        g_mainTask[i].taskId = config.LOSCFG_BASE_CORE_TSK_LIMIT;
        g_mainTask[i].priority = task_pri.OS_TASK_PRIORITY_LOWEST + 1;
        g_mainTask[i].taskName = "osMain";
        if (g_mainTask[i].LOSCFG_KERNEL_SMP) |*smp| {
            if (smp.LOSCFG_KERNEL_SMP_LOCKDEP) |*lockDep| {
                lockDep.lockDep.lockDepth = 0;
                lockDep.lockDep.waitLock = null;
            }
        }
    }
}

pub fn OsRegister() !void {
    if (defines.LOSCFG_LIB_CONFIGURABLE) {
        // g_osSysClock = OS_SYS_CLOCK_CONFIG;
        // g_taskLimit = LOSCFG_BASE_CORE_TSK_LIMIT;
        // g_taskMaxNum = g_taskLimit + 1;
        // g_taskMinStkSize = LOSCFG_BASE_CORE_TSK_MIN_STACK_SIZE;
        // g_taskIdleStkSize = LOSCFG_BASE_CORE_TSK_IDLE_STACK_SIZE;
        // g_taskDfltStkSize = LOSCFG_BASE_CORE_TSK_DEFAULT_STACK_SIZE;
        // g_taskSwtmrStkSize = LOSCFG_BASE_CORE_TSK_SWTMR_STACK_SIZE;
        // g_swtmrLimit = LOSCFG_BASE_CORE_SWTMR_LIMIT;
        // g_semLimit = LOSCFG_BASE_IPC_SEM_LIMIT;
        // g_muxLimit = LOSCFG_BASE_IPC_MUX_LIMIT;
        // g_queueLimit = LOSCFG_BASE_IPC_QUEUE_LIMIT;
        if (defines.LOSCFG_BASE_CORE_TIMESLICE) {
            misc.g_timeSliceTimeOut = config.LOSCFG_BASE_CORE_TIMESLICE_TIMEOUT;
        }
    }
    tick.g_tickPerSecond = config.LOSCFG_BASE_CORE_TICK_PER_SECOND;
    tick.SET_SYS_CLOCK(config.OS_SYS_CLOCK);
    config.LOS_SET_NX_CFG(true);
    config.LOS_SET_DL_NX_HEAP_BASE(config.LOS_DL_HEAP_BASE);
    config.LOS_SET_DL_NX_HEAP_SIZE(config.LOS_DL_HEAP_SIZE);
}
