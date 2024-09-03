const std = @import("std");
const t = @import("../zlos_typedef.zig");
const defines = @import("../zlos_defines.zig");
const list = @import("../zlos_list.zig");
const sortlink = @import("../zlos_sortlink_pri.zig");
const event = @import("../zlos_event.zig");
const lockdep = @import("../zlos_lockdep.zig");
const sched_debug_pri = @import("../base/zlos_sched_debug_pri.zig");
const sched_pri = @import("../base/zlos_sched_pri.zig");
const hwi = @import("../zlos_hwi.zig");

const INT_PEND_RESCH = @intFromEnum(sched_pri.SchedFlag.INT_PEND_RESCH);

pub const TSK_ENTRY_FUNC = if (defines.LOSCFG_OBSOLETE_API)
    *const fn (*t.VOID) *t.VOID
else
    *const fn (
        p1: t.UINTPTR, //
        p2: t.UINTPTR,
        p3: t.UINTPTR,
        p4: t.UINTPTR,
    ) *t.VOID;

pub const LosTaskCB = struct {
    //     VOID            *stackPointer;      /* Task stack pointer */
    stackPointer: ?*t.VOID = null,
    //     UINT16          taskStatus;         /* Task status */
    taskStatus: t.UINT16 = 0,
    //     UINT16          priority;           /* Task priority */
    priority: t.UINT16 = 0,
    //     UINT32          taskFlags : 31;     /* Task extend flags: taskFlags uses 8 bits now. 23 bits left */
    taskFlags: u31 = 0,
    //     UINT32          usrStack : 1;       /* Usr Stack uses the last bit */
    usrStack: u1 = 0,
    //     UINT32          stackSize;          /* Task stack size */
    stackSize: t.UINT32 = 0,
    //     UINTPTR         topOfStack;         /* Task stack top */
    topOfStack: t.UINTPTR = 0,
    //     UINT32          taskId;             /* Task ID */
    taskId: t.UINT32 = 0,
    //     TSK_ENTRY_FUNC  taskEntry;          /* Task entrance function */
    taskEntry: TSK_ENTRY_FUNC,
    //     VOID            *taskSem;           /* Task-held semaphore */
    taskSem: ?*t.VOID = null,
    // #ifdef LOSCFG_COMPAT_POSIX
    //     VOID            *threadJoin;        /* pthread adaption */
    //     VOID            *threadJoinRetval;  /* pthread adaption */
    // #endif
    LOSCFG_COMPAT_POSIX: ?struct {
        threadJoin: ?*t.VOID = null,
        threadJoinRetval: ?*t.VOID = null,
    } = if (defines.LOSCFG_COMPAT_POSIX) .{} else null,
    //     VOID            *taskMux;           /* Task-held mutex */
    taskMux: ?*t.VOID,
    // #ifdef LOSCFG_OBSOLETE_API
    //     UINTPTR         args[4];            /* Parameter, of which the maximum number is 4 */
    // #else
    //     VOID            *args;              /* Parameter, of which the type is void * */
    // #endif
    LOSCFG_OBSOLETE_API: if (defines.LOSCFG_OBSOLETE_API) struct {
        args: [4]t.UINTPTR = std.mem.zeroes([4]t.UINTPTR),
    } else struct {
        args: ?*t.VOID = null,
    },
    //     CHAR            *taskName;          /* Task name */
    taskName: ?[]const u8 = null,
    //     LOS_DL_LIST     pendList;           /* Task pend node */
    pendList: list.LOS_DL_LIST = .{},
    //     SortLinkList    sortList;           /* Task sortlink node */
    sortList: sortlink.SortLinkList = .{},
    // #ifdef LOSCFG_BASE_IPC_EVENT
    //     EVENT_CB_S      event;
    //     UINT32          eventMask;          /* Event mask */
    //     UINT32          eventMode;          /* Event mode */
    // #endif
    LOSCFG_BASE_IPC_EVENT: ?struct {
        event: event.EVENT_CB_S = .{},
        eventMask: t.UINT32 = 0,
        eventMode: t.UINT32 = 0,
    } = if (defines.LOSCFG_BASE_IPC_EVENT)
        .{}
    else
        null,
    //     VOID            *msg;               /* Memory allocated to queues */
    msg: ?*t.VOID = null,
    //     UINT32          priBitMap;          /* BitMap for recording the change of task priority,
    priBitMap: t.UINT32 = 0,
    //                                              the priority can not be greater than 31 */
    //     UINT32          signal;             /* Task signal */
    signal: t.UINT32,
    // #ifdef LOSCFG_BASE_CORE_TIMESLICE
    //     UINT16          timeSlice;          /* Remaining time slice */
    // #endif
    LOSCFG_BASE_CORE_TIMESLICE: ?struct {
        timeSlice: t.UINT16 = 0,
    } = if (defines.LOSCFG_BASE_CORE_TIMESLICE)
        .{}
    else
        null,
    // #ifdef LOSCFG_KERNEL_SMP
    //     UINT16          currCpu;            /* CPU core number of this task is running on */
    //     UINT16          lastCpu;            /* CPU core number of this task is running on last time */
    //     UINT32          timerCpu;           /* CPU core number of this task is delayed or pended */
    //     UINT16          cpuAffiMask;        /* CPU affinity mask, support up to 16 cores */
    // #ifdef LOSCFG_KERNEL_SMP_TASK_SYNC
    //     UINT32          syncSignal;         /* Synchronization for signal handling */
    // #endif
    // #ifdef LOSCFG_KERNEL_SMP_LOCKDEP
    //     LockDep         lockDep;
    // #endif
    // #endif

    LOSCFG_KERNEL_SMP: ?struct {
        currCpu: t.UINT16 = 0,
        lastCpu: t.UINT16 = 0,
        timerCpu: t.UINT32 = 0,
        cpuAffiMask: t.UINT16 = 0,
        LOSCFG_KERNEL_SMP_TASK_SYNC: ?struct {
            syncSignal: t.UINT32 = 0,
        } = if (defines.LOSCFG_KERNEL_SMP_TASK_SYNC)
            .{}
        else
            null,
        LOSCFG_KERNEL_SMP_LOCKDEP: ?struct {
            lockDep: lockdep.LockDep = .{},
        } = if (defines.LOSCFG_KERNEL_SMP_LOCKDEP)
            .{}
        else
            null,
    } = if (defines.LOSCFG_KERNEL_SMP)
        .{}
    else
        null,
    // #ifdef LOSCFG_DEBUG_SCHED_STATISTICS
    //     SchedStat       schedStat;          /* Schedule statistics */
    // #endif
    LOSCFG_DEBUG_SCHED_STATISTICS: ?struct {
        schedStat: sched_debug_pri.SchedStat = .{},
    } = if (defines.LOSCFG_DEBUG_SCHED_STATISTICS)
        .{}
    else
        null,
    // #ifdef LOSCFG_KERNEL_PERF
    //     UINTPTR         pc;
    //     UINTPTR         fp;
    // #endif
    LOSCFG_KERNEL_PERF: ?struct {
        pc: t.UINTPTR = 0,
        fp: t.UINTPTR = 0,
    } = if (defines.LOSCFG_KERNEL_PERF)
        .{}
    else
        null,
};

pub var g_taskScheduled: t.UINT32 = 0;

//LITE_OS_SEC_TEXT_MINOR
pub fn LOS_TaskLock() void {
    var intSave: t.UINT32 = 0;
    var losTaskLock: *t.UINT32 = null;

    intSave = hwi.LOS_IntLock();
    losTaskLock = &sched_pri.OsPercpuGet().taskLockCnt;
    losTaskLock.* += 1;
    hwi.LOS_IntRestore(intSave);
}

pub inline fn ArchCurrTaskGet() ?*t.VOID {
    return null;
}
//LITE_OS_SEC_TEXT_MINOR
pub fn LOS_TaskUnlock() !void {
    var intSave: t.UINT32 = 0;
    var losTaskLock: *t.UINT32 = undefined;
    var _percpu: ?*sched_pri.Percpu = null;

    intSave = hwi.LOS_IntLock();

    _percpu = sched_pri.OsPercpuGet();
    if (_percpu == null) {
        return error.percpu_null;
    }
    const percpu = _percpu.?;
    losTaskLock = &percpu.taskLockCnt;
    if (losTaskLock.* > 0) {
        losTaskLock.* -= 1;
        if ((losTaskLock.* == 0) and (percpu.schedFlag == INT_PEND_RESCH) and
            sched_pri.OS_SCHEDULER_ACTIVE() != 0)
        {
            percpu.schedFlag = sched_pri.INT_NO_RESCH;
            hwi.LOS_IntRestore(intSave);
            sched_pri.LOS_Schedule();
            return;
        }
    }

    hwi.LOS_IntRestore(intSave);
}
