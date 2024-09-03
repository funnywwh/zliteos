const std = @import("std");
const t = @import("../zlos_typedef.zig");
const task = @import("../base/zlos_task.zig");
const config = @import("../zlos_config.zig");
const cpu = @import("../../arch/arm/cortex_a_r/include/arch/cpu.zig");
const task_pri = @import("../base/zlos_task_pri.zig");
const defines = @import("../zlos_defines.zig");
const misc = @import("../base/zlos_misc.zig");
const tick = @import("../base/zlos_tick.zig");
const sem = @import("../base/zlos_sem.zig");
const spinlock = @import("../zlos_spinlock.zig");
var g_mainTask: [config.LOSCFG_KERNEL_CORE_NUM]task.LosTaskCB = undefined;

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

extern var g_taskSpin: spinlock.SPIN_LOCK_S;
//LITE_OS_SEC_TEXT_INIT
pub fn OsStart() !void {
    var taskCB: ?*task.LosTaskCB = null;
    const cpuid = cpu.ArchCurrCpuid();

    tick.OsTickStart();

    spinlock.LOS_SpinLock(&spinlock.g_taskSpin);
    taskCB = OsGetTopTask();

    if (defines.LOSCFG_KERNEL_SMP) {
        // /*
        //  * attention: current cpu needs to be set, in case first task deletion
        //  * may fail because this flag mismatch with the real current cpu.
        //  */
        taskCB.currCpu = @truncate(cpuid);
    }
    OS_SCHEDULER_SET(cpuid);

    PRINTK("cpu %u entering scheduler\n", cpuid);

    taskCB.taskStatus = OS_TASK_STATUS_RUNNING;

    task_pri.OsStartToRun(taskCB);
}

// //LITE_OS_SEC_TEXT_INIT
// fn OsIpcInit()!void
// {
//     const ret = t.LOS_OK;
// if(defines.LOSCFG_BASE_IPC_SEM)
//     ret = sem.OsSemInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Sem init err.\n");
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_BASE_IPC_MUX
//     ret = OsMuxInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Mux init err.\n");
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_BASE_IPC_QUEUE
//     ret = OsQueueInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Que init err.\n");
//         return ret;
//     }
// #endif
//     return ret;
// }

// #ifdef LOSCFG_PLATFORM_OSAPPINIT
// STATIC UINT32 OsAppTaskCreate(VOID)
// {
//     UINT32 taskId;
//     TSK_INIT_PARAM_S appTask;

//     (VOID)memset_s(&appTask, sizeof(TSK_INIT_PARAM_S), 0, sizeof(TSK_INIT_PARAM_S));
//     appTask.pfnTaskEntry = (TSK_ENTRY_FUNC)app_init;
//     appTask.uwStackSize = LOSCFG_BASE_CORE_TSK_DEFAULT_STACK_SIZE;
//     appTask.pcName = "app_Task";
//     appTask.usTaskPrio = LOSCFG_BASE_CORE_TSK_DEFAULT_PRIO;
//     appTask.uwResved = LOS_TASK_STATUS_DETACHED;
// #ifdef LOSCFG_KERNEL_SMP
//     appTask.usCpuAffiMask = CPUID_TO_AFFI_MASK(ArchCurrCpuid());
// #endif
//     return LOS_TaskCreate(&taskId, &appTask);
// }

// UINT32 OsAppInit(VOID)
// {
//     UINT32 ret;
// #ifdef LOSCFG_FS_VFS
//     los_vfs_init();
// #endif

// #ifdef LOSCFG_COMPAT_LINUX

// #ifdef LOSCFG_COMPAT_LINUX_HRTIMER
//     ret = HrtimersInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("HrtimersInit error\n");
//         return ret;
//     }
// #endif
// #ifdef LOSCFG_BASE_CORE_SWTMR
//     g_pstSystemWq = create_workqueue("system_wq");
// #endif

// #endif

//     ret = OsAppTaskCreate();
//     PRINTK("OsAppInit\n");
//     if (ret != LOS_OK) {
//         return ret;
//     }

// #ifdef LOSCFG_KERNEL_TICKLESS
//     LOS_TicklessEnable();
// #endif
//     return 0;
// }
// #endif /* LOSCFG_PLATFORM_OSAPPINIT */

// LITE_OS_SEC_TEXT_INIT UINT32 OsMain(VOID)
// {
//     UINT32 ret;

// #ifdef LOSCFG_EXC_INTERACTION
//     ret = OsMemExcInteractionInit((UINTPTR)&__exc_heap_start);
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_KERNEL_LMS
//     OsLmsInit();
// #endif

//     ret = OsMemSystemInit((UINTPTR)OS_SYS_MEM_ADDR);
//     if (ret != LOS_OK) {
//         PRINT_ERR("Mem init err.\n");
//         return ret;
//     }

//     OsRegister();

// #ifdef LOSCFG_SHELL_LK
//     OsLkLoggerInit(NULL);
// #endif

// #ifdef LOSCFG_SHELL_DMESG
//     ret = OsDmesgInit();
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

//     OsHwiInit();

//     ArchExcInit();

// #if defined(LOSCFG_KERNEL_TICKLESS) && !defined(LOSCFG_KERNEL_POWER_MGR)
//     OsLowpowerInit(NULL);
// #endif

//     ret = OsTickInit(GET_SYS_CLOCK(), LOSCFG_BASE_CORE_TICK_PER_SECOND);
//     if (ret != LOS_OK) {
//         PRINT_ERR("Tick init err.\n");
//         return ret;
//     }

// #if defined(LOSCFG_DRIVERS_UART) || defined(LOSCFG_DRIVERS_SIMPLE_UART)
//     uart_init();
// #ifdef LOSCFG_SHELL
//     uart_hwiCreate();
// #endif /* LOSCFG_SHELL */
// #endif /* LOSCFG_DRIVERS_SIMPLE_UART */

//     ret = OsTaskInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Task init err.\n");
//         return ret;
//     }

// #ifdef LOSCFG_KERNEL_TRACE
//     ret = LOS_TraceInit(NULL, LOS_TRACE_BUFFER_SIZE);
//     if (ret != LOS_OK) {
//         PRINT_ERR("Trace init err.\n");
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_BASE_CORE_TSK_MONITOR
//     OsTaskMonInit();
// #endif

//     ret = OsIpcInit();
//     if (ret != LOS_OK) {
//         return ret;
//     }

//     /*
//      * CPUP should be inited before first task creation which depends on the semaphore
//      * when LOSCFG_KERNEL_SMP_TASK_SYNC is enabled. So don't change this init sequence
//      * if not necessary. The sequence should be like this:
//      * 1. OsIpcInit
//      * 2. OsCpupInit . has first task creation
//      * 3. other inits have task creation
//      */
// #ifdef LOSCFG_KERNEL_CPUP
//     ret = OsCpupInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Cpup init err.\n");
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_BASE_CORE_SWTMR
//     ret = OsSwtmrInit();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Swtmr init err.\n");
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_KERNEL_SMP
//     (VOID)OsMpInit();
// #endif

// #ifdef LOSCFG_KERNEL_DYNLOAD
//     ret = OsDynloadInit();
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

//     ret = OsIdleTaskCreate();
//     if (ret != LOS_OK) {
//         PRINT_ERR("Create idle task err.\n");
//         return ret;
//     }

// #ifdef LOSCFG_KERNEL_RUNSTOP
//     ret = OsWowWriteFlashTaskCreate();
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_KERNEL_INTERMIT
//     ret = OsIntermitDaemonStart();
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_DRIVERS_BASE
//     ret = OsDriverBaseInit();
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #ifdef LOSCFG_COMPAT_LINUX
//     (VOID)do_initCalls(LEVEL_ARCH);
// #endif
// #endif

// #ifdef LOSCFG_KERNEL_PERF
//     ret = LOS_PerfInit(NULL, LOS_PERF_BUFFER_SIZE);
//     if (ret != LOS_OK) {
//         return ret;
//     }
// #endif

// #ifdef LOSCFG_PLATFORM_OSAPPINIT
//     ret = OsAppInit();
// #else /* LOSCFG_TEST */
//     ret = OsTestInit();
// #endif
//     if (ret != LOS_OK) {
//         return ret;
//     }

//     return LOS_OK;
// }
