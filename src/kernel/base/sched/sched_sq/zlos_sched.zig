const t = @import("../../../zlos_typedef.zig");
const task = @import("../../../base/zlos_task.zig");
// VOID OsSchedResched(VOID)
// {
//     LosTaskCB *runTask = NULL;
//     LosTaskCB *newTask = NULL;

//     LOS_ASSERT(LOS_SpinHeld(&g_taskSpin));

//     if (!OsPreemptableInSched()) {
//         return;
//     }

//     runTask = OsCurrTaskGet();
//     newTask = OsGetTopTask();

//     /* always be able to get one task */
//     LOS_ASSERT(newTask != NULL);

//     newTask.taskStatus &= ~OS_TASK_STATUS_READY;

//     if (runTask == newTask) {
//         return;
//     }

//     runTask.taskStatus &= ~OS_TASK_STATUS_RUNNING;
//     newTask.taskStatus |= OS_TASK_STATUS_RUNNING;

// #ifdef LOSCFG_KERNEL_SMP
//     /* mask new running task's owner processor */
//     runTask.currCpu = OS_TASK_INVALID_CPUID;
//     newTask.currCpu = ArchCurrCpuid();
// #endif

//     OsTaskTimeUpdateHook(runTask.taskId, LOS_TickCountGet());

// #ifdef LOSCFG_KERNEL_CPUP
//     OsTaskCycleEndStart(newTask);
// #endif

// #ifdef LOSCFG_BASE_CORE_TSK_MONITOR
//     OsTaskSwitchCheck(runTask, newTask);
// #endif

//     LOS_TRACE(TASK_SWITCH, newTask.taskId, runTask.priority, runTask.taskStatus, newTask.priority,
//         newTask.taskStatus);

// #ifdef LOSCFG_DEBUG_SCHED_STATISTICS
//     OsSchedStatistics(runTask, newTask);
// #endif

// #ifdef LOSCFG_BASE_CORE_TIMESLICE
//     if (newTask.timeSlice == 0) {
//         newTask.timeSlice = KERNEL_TIMESLICE_TIMEOUT;
//     }
// #endif

//     OsCurrTaskSet((VOID*)newTask);

//     /* do the task context switch */
//     OsTaskSchedule(newTask, runTask);
// }

// VOID OsSchedPreempt(VOID)
// {
//     LosTaskCB *runTask = NULL;
//     UINT32 intSave;

//     if (!OsPreemptable()) {
//         return;
//     }

//     SCHEDULER_LOCK(intSave);

//     /* add run task back to ready queue */
//     runTask = OsCurrTaskGet();
//     runTask.taskStatus |= OS_TASK_STATUS_READY;

// #ifdef LOSCFG_BASE_CORE_TIMESLICE
//     if (runTask.timeSlice == 0) {
//         OsPriQueueEnqueue(&runTask.pendList, runTask.priority);
//     } else {
// #endif
//         OsPriQueueEnqueueHead(&runTask.pendList, runTask.priority);
// #ifdef LOSCFG_BASE_CORE_TIMESLICE
//     }
// #endif

//     /* reschedule to new thread */
//     OsSchedResched();

//     SCHEDULER_UNLOCK(intSave);
// }

// #ifdef LOSCFG_BASE_CORE_TIMESLICE
// LITE_OS_SEC_TEXT
pub fn OsTimesliceCheck() void {
    const _runTask = task.OsCurrTaskGet();
    if (_runTask) |runTask| {
        if (runTask.timeSlice != 0) {
            runTask.timeSlice -= 1;
            if (runTask.timeSlice == 0) {
                LOS_Schedule();
            }
        }
    }
}
// #endif
