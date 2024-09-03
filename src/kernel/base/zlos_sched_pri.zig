const std = @import("std");
const t = @import("../zlos_typedef.zig");
const defines = @import("../zlos_defines.zig");
const sortlink_pri = @import("../zlos_sortlink_pri.zig");
const config = @import("../zlos_config.zig");
const target = @import("../../targets/target.zig");
const cpu = target.cpu;
const list = @import("../zlos_list.zig");
const task = @import("./zlos_task.zig");

pub const ExcFlag = enum(t.UINT16) {
    CPU_RUNNING = 0, // cpu is running */
    CPU_HALT, // cpu in the halt */
    CPU_EXC, // cpu in the exc */
};

pub const Percpu = struct {
    taskSortLink: sortlink_pri.SortLinkAttribute = .{}, // task sort link */
    LOSCFG_BASE_CORE_SWTMR: ?struct {
        swtmrSortLink: sortlink_pri.SortLinkAttribute = .{}, // swtmr sort link */
    } = if (defines.LOSCFG_BASE_CORE_SWTMR)
        .{}
    else
        null,

    idleTaskId: t.UINT32 = 0, // idle task id */
    taskLockCnt: t.UINT32 = 0, // task lock flag */
    swtmrHandlerQueue: t.UINT32 = 0, // software timer timeout queue id */
    swtmrTaskId: t.UINT32 = 0, // software timer task id */

    schedFlag: t.UINT32 = 0, // pending scheduler flag */
    LOSCFG_KERNEL_SMP: ?struct {
        excFlag: t.UINT32 = 0, // cpu halt or exc flag */
        LOSCFG_KERNEL_SMP_CALL: ?struct {
            funcLink: list.LOS_DL_LIST = .{}, // mp function call link */
        } = if (defines.LOSCFG_KERNEL_SMP_CALL)
            .{}
        else
            null,
    } = if (defines.LOSCFG_KERNEL_SMP) .{} else null,
};

// the kernel per-cpu structure */
pub var g_percpu: [config.LOSCFG_KERNEL_CORE_NUM]Percpu = undefined;

pub inline fn OsPercpuGet() *Percpu {
    return &g_percpu[cpu.ArchCurrCpuid()];
}

pub inline fn OsPercpuGetByID(cpuid: t.UINT32) *Percpu {
    return &g_percpu[cpuid];
}

// /*
//  * Schedule flag, one bit represents one core.
//  * This flag is used to prevent kernel scheduling before OSStartToRun.
//  */
pub inline fn OS_SCHEDULER_SET(cpuid: t.UINT32) void {
    task.g_taskScheduled |= (1 << (cpuid));
}

pub inline fn OS_SCHEDULER_CLR(cpuid: t.UINT32) void {
    task.g_taskScheduled &= ~(1 << (cpuid));
}

pub inline fn OS_SCHEDULER_ACTIVE() t.UINT32 {
    return (task.g_taskScheduled & (1 << cpu.ArchCurrCpuid()));
}
pub const SchedFlag = enum(t.UINT16) {
    INT_NO_RESCH = 0, // no needs to schedule */
    INT_PEND_RESCH, // pending schedule flag */
};

// /* Check if preemptable with counter flag */
// STATIC INLINE BOOL OsPreemptable(VOID)
// {
//     /*
//      * Unlike OsPreemptableInSched, the int may be not disabled when OsPreemptable
//      * is called, needs manually disable interrupt, to prevent current task from
//      * being migrated to another core, and get the wrong preemptable status.
//      */
//     UINT32 intSave = LOS_IntLock();
//     BOOL preemptable = (OsPercpuGet()->taskLockCnt == 0);
//     if (!preemptable) {
//         /* Set schedule flag if preemption is disabled */
//         OsPercpuGet()->schedFlag = INT_PEND_RESCH;
//     }
//     LOS_IntRestore(intSave);
//     return preemptable;
// }

// STATIC INLINE BOOL OsPreemptableInSched(VOID)
// {
//     BOOL preemptable = FALSE;

// #ifdef LOSCFG_KERNEL_SMP
//     /*
//      * For smp systems, schedule must hold the task spinlock, and this counter
//      * will increase by 1 in that case.
//      */
//     preemptable = (OsPercpuGet()->taskLockCnt == 1);

// #else
//     preemptable = (OsPercpuGet()->taskLockCnt == 0);
// #endif
//     if (!preemptable) {
//         /* Set schedule flag if preemption is disabled */
//         OsPercpuGet()->schedFlag = INT_PEND_RESCH;
//     }

//     return preemptable;
// }

// /*
//  * This function simply picks the next task and switches to it.
//  * Current task needs to already be in the right state or the right
//  * queues it needs to be in.
//  */
// extern VOID OsSchedResched(VOID);

// /*
//  * This function put the current task back to the ready queue and
//  * try to do the schedule. However, the schedule won't be definitely
//  * taken place while there're no other higher priority tasks or locked.
//  */
// extern VOID OsSchedPreempt(VOID);

// /*
//  * Just like OsSchedPreempt, except this function will do the OS_INT_ACTIVE
//  * check, in case the schedule taken place in the middle of an interrupt.
//  */
// STATIC INLINE
pub inline fn LOS_Schedule() void {
    //     if (OS_INT_ACTIVE) {
    //         OsPercpuGet()->schedFlag = INT_PEND_RESCH;
    //         return;
    //     }

    //     /*
    //      * trigger schedule in task will also do the slice check
    //      * if necessary, it will give up the timeslice more in time.
    //      * otherwise, there's no other side effects.
    //      */
    //     OsSchedPreempt();
}

// #ifdef LOSCFG_BASE_CORE_TIMESLICE
// /**
//  * @ingroup los_sched
//  * This API is used to check time slices. If the number of Ticks equals to the time for task switch,
//  * tasks are switched. Otherwise, the Tick counting continues.
//  */
// extern VOID OsTimesliceCheck(VOID);
// #endif

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif /* __cplusplus */
// #endif /* __cplusplus */

// #endif /* _LOS_SCHED_PRI_H */
