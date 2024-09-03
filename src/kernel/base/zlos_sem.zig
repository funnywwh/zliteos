const syserr = @import("../zlos_error.zig");
const t = @import("../zlos_typedef.zig");
// LITE_OS_SEC_DATA_INIT STATIC LOS_DL_LIST g_unusedSemList;
// LITE_OS_SEC_BSS LosSemCB *g_allSem = NULL;

// STATIC_INLINE VOID OsSemNodeRecycle(LosSemCB *semNode)
// {
//     semNode->semStat = LOS_UNUSED;
//     LOS_ListTailInsert(&g_unusedSemList, &semNode->semList);
// }

// LITE_OS_SEC_TEXT_INIT
pub fn OsSemInit() syserr.SYS_ERROR!void {
    // LosSemCB *semNode = NULL;
    // UINT16 index; // support at most 65536 semaphores

    // /* system resident memory, don't free */
    // g_allSem = (LosSemCB *)LOS_MemAlloc(m_aucSysMem0, (KERNEL_SEM_LIMIT * sizeof(LosSemCB)));
    // if (g_allSem == NULL) {
    //     return LOS_ERRNO_SEM_NO_MEMORY;
    // }

    // LOS_ListInit(&g_unusedSemList);

    // for (index = 0; index < KERNEL_SEM_LIMIT; index++) {
    //     semNode = ((LosSemCB *)g_allSem) + index;
    //     semNode->semId = (UINT32)index;
    //     OsSemNodeRecycle(semNode);
    // }

    // if (OsSemDbgInitHook() != LOS_OK) {
    //     return LOS_ERRNO_SEM_NO_MEMORY;
    // }
    // return LOS_OK;
}

// LITE_OS_SEC_TEXT_INIT STATIC UINT32 OsSemCreate(UINT16 count, UINT8 type, UINT32 *semHandle)
// {
//     UINT32 intSave;
//     LosSemCB *semCreated = NULL;
//     LOS_DL_LIST *unusedSem = NULL;

//     if (semHandle == NULL) {
//         return LOS_ERRNO_SEM_PTR_NULL;
//     }

//     SCHEDULER_LOCK(intSave);

//     if (LOS_ListEmpty(&g_unusedSemList)) {
//         SCHEDULER_UNLOCK(intSave);
//         OsSemInfoGetFullDataHook();
//         OS_RETURN_ERROR(LOS_ERRNO_SEM_ALL_BUSY);
//     }

//     unusedSem = LOS_DL_LIST_FIRST(&g_unusedSemList);
//     LOS_ListDelete(unusedSem);
//     semCreated = GET_SEM_LIST(unusedSem);
//     semCreated->semStat = LOS_USED;
//     semCreated->semType = type;
//     semCreated->semCount = count;
//     LOS_ListInit(&semCreated->semList);
//     *semHandle = semCreated->semId;

//     OsSemDbgUpdateHook(semCreated->semId, OsCurrTaskGet()->taskEntry, count);

//     SCHEDULER_UNLOCK(intSave);

//     LOS_TRACE(SEM_CREATE, semCreated->semId, type, count);
//     return LOS_OK;
// }

// LITE_OS_SEC_TEXT_INIT UINT32 LOS_SemCreate(UINT16 count, UINT32 *semHandle)
// {
//     if (count > LOS_SEM_COUNT_MAX) {
//         return LOS_ERRNO_SEM_OVERFLOW;
//     }
//     return OsSemCreate(count, OS_SEM_COUNTING, semHandle);
// }

// LITE_OS_SEC_TEXT_INIT UINT32 LOS_BinarySemCreate(UINT16 count, UINT32 *semHandle)
// {
//     if (count > OS_SEM_BINARY_COUNT_MAX) {
//         return LOS_ERRNO_SEM_OVERFLOW;
//     }
//     return OsSemCreate(count, OS_SEM_BINARY, semHandle);
// }

// STATIC_INLINE UINT32 OsSemStateVerify(UINT32 semId, const LosSemCB *semNode)
// {
// #ifndef LOSCFG_RESOURCE_ID_NOT_USE_HIGH_BITS
//     if ((semNode->semStat == LOS_UNUSED) || (semNode->semId != semId)) {
// #else
//     if (semNode->semStat == LOS_UNUSED) {
// #endif
//         return LOS_ERRNO_SEM_INVALID;
//     }
//     return LOS_OK;
// }

// STATIC UINT32 OsSemGetCBWithCheck(UINT32 semHandle, LosSemCB **semCB)
// {
//     if (GET_SEM_INDEX(semHandle) >= (UINT32)KERNEL_SEM_LIMIT) {
//         return LOS_ERRNO_SEM_INVALID;
//     }

//     *semCB = GET_SEM(semHandle);
//     return LOS_OK;
// }

// LITE_OS_SEC_TEXT_INIT UINT32 LOS_SemDelete(UINT32 semHandle)
// {
//     UINT32 intSave;
//     LosSemCB *semDeleted = NULL;
//     UINT32 ret;

//     ret = OsSemGetCBWithCheck(semHandle, &semDeleted);
//     if (ret != LOS_OK) {
//         return ret;
//     }

//     SCHEDULER_LOCK(intSave);

//     ret = OsSemStateVerify(semHandle, semDeleted);
//     if (ret != LOS_OK) {
//         goto OUT;
//     }

//     if (!LOS_ListEmpty(&semDeleted->semList)) {
//         ret = LOS_ERRNO_SEM_PENDED;
//         goto OUT;
//     }

// #ifndef LOSCFG_RESOURCE_ID_NOT_USE_HIGH_BITS
//     semDeleted->semId = SET_SEM_ID(GET_SEM_COUNT(semDeleted->semId) + 1, GET_SEM_INDEX(semDeleted->semId));
// #endif
//     OsSemNodeRecycle(semDeleted);

//     OsSemDbgUpdateHook(semDeleted->semId, NULL, 0);

// OUT:
//     SCHEDULER_UNLOCK(intSave);

//     LOS_TRACE(SEM_DELETE, semHandle, ret);
//     return ret;
// }

// LITE_OS_SEC_TEXT UINT32 LOS_SemPend(UINT32 semHandle, UINT32 timeout)
// {
//     UINT32 intSave;
//     LosSemCB *semPended = NULL;
//     UINT32 ret;
//     LosTaskCB *runTask = NULL;

//     ret = OsSemGetCBWithCheck(semHandle, &semPended);
//     if (ret != LOS_OK) {
//         return ret;
//     }

//     LOS_TRACE(SEM_PEND, semHandle, semPended->semCount, timeout);

//     if (OS_INT_ACTIVE) {
//         return LOS_ERRNO_SEM_PEND_INTERR;
//     }

//     runTask = OsCurrTaskGet();
//     if (runTask->taskFlags & OS_TASK_FLAG_SYSTEM) {
//         PRINT_DEBUG("Warning: DO NOT recommend to use %s in system tasks.\n", __FUNCTION__);
//     }

//     if (!OsPreemptable()) {
//         return LOS_ERRNO_SEM_PEND_IN_LOCK;
//     }

//     SCHEDULER_LOCK(intSave);

//     ret = OsSemStateVerify(semHandle, semPended);
//     if (ret != LOS_OK) {
//         goto OUT;
//     }

//     /* Update the operate time, no matter the actual Pend success or not */
//     OsSemDbgTimeUpdateHook(semHandle);

//     if (semPended->semCount > 0) {
//         semPended->semCount--;
//         goto OUT;
//     } else if (!timeout) {
//         ret = LOS_ERRNO_SEM_UNAVAILABLE;
//         goto OUT;
//     }

//     runTask->taskSem = (VOID *)semPended;
//     OsTaskWait(&semPended->semList, OS_TASK_STATUS_PEND, timeout);

//     /*
//      * it will immediately do the scheduling, so there's no need to release the
//      * task spinlock. when this task's been rescheduled, it will be holding the spinlock.
//      */
//     OsSchedResched();

//     SCHEDULER_UNLOCK(intSave);
//     SCHEDULER_LOCK(intSave);

//     if (runTask->taskStatus & OS_TASK_STATUS_TIMEOUT) {
//         runTask->taskStatus &= ~OS_TASK_STATUS_TIMEOUT;
//         ret = LOS_ERRNO_SEM_TIMEOUT;
//         goto OUT;
//     }

// OUT:
//     SCHEDULER_UNLOCK(intSave);
//     return ret;
// }

// LITE_OS_SEC_TEXT UINT32 LOS_SemPost(UINT32 semHandle)
// {
//     UINT32 intSave;
//     LosSemCB *semPosted = NULL;
//     LosTaskCB *resumedTask = NULL;
//     UINT16 maxCount;
//     UINT32 ret;

//     ret = OsSemGetCBWithCheck(semHandle, &semPosted);
//     if (ret != LOS_OK) {
//         return ret;
//     }

//     LOS_TRACE(SEM_POST, semHandle, semPosted->semType, semPosted->semCount);

//     SCHEDULER_LOCK(intSave);

//     ret = OsSemStateVerify(semHandle, semPosted);
//     if (ret != LOS_OK) {
//         goto OUT;
//     }

//     /* Update the operate time, no matter the actual Post success or not */
//     OsSemDbgTimeUpdateHook(semHandle);

//     maxCount = (semPosted->semType == OS_SEM_COUNTING) ? LOS_SEM_COUNT_MAX : OS_SEM_BINARY_COUNT_MAX;
//     if (semPosted->semCount >= maxCount) {
//         ret = LOS_ERRNO_SEM_OVERFLOW;
//         goto OUT;
//     }
//     if (!LOS_ListEmpty(&semPosted->semList)) {
//         resumedTask = OS_TCB_FROM_PENDLIST(LOS_DL_LIST_FIRST(&(semPosted->semList)));
//         resumedTask->taskSem = NULL;
//         OsTaskWake(resumedTask, OS_TASK_STATUS_PEND);

//         SCHEDULER_UNLOCK(intSave);
//         LOS_MpSchedule(OS_MP_CPU_ALL);
//         LOS_Schedule();
//         return LOS_OK;
//     } else {
//         semPosted->semCount++;
//     }

// OUT:
//     SCHEDULER_UNLOCK(intSave);
//     return ret;
// }

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif
// #endif /* __cplusplus */
