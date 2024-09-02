const t = @import("../zlos_typedef.zig");
const defines = @import("../zlos_defines.zig");
const trace = @import("../zlos_trace.zig");
const trace_pri = @import("../externed/zlos_trace_pri.zig");
// LITE_OS_SEC_BSS
pub var g_osSysClock: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_semLimit: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_muxLimit: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_queueLimit: t.UINT32 = 0;

// LITE_OS_SEC_BSS
pub var g_swtmrLimit: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_taskLimit: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_minusOneTickPerSecond: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_taskMinStkSize: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_taskIdleStkSize: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_taskSwtmrStkSize: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_taskDfltStkSize: t.UINT32 = 0;
// LITE_OS_SEC_BSS
pub var g_timeSliceTimeOut: t.UINT32 = 0;

// LITE_OS_SEC_DATA
pub var g_nxEnabled: t.BOOL = t.FALSE;
// LITE_OS_SEC_BSS
pub var g_dlNxHeapBase: t.UINTPTR = 0;
// LITE_OS_SEC_BSS
pub var g_dlNxHeapSize: t.UINT32 = 0;
// #endif

pub var LOSCFG_KERNEL_TRACE: ?struct {
    g_traceEventHook: ?trace.TRACE_EVENT_HOOK = null,
    g_traceDumpHook: ?trace_pri.TRACE_DUMP_HOOK = null,
} = if (defines.LOSCFG_KERNEL_TRACE)
    .{}
else
    null;
// TRACE_EVENT_HOOK g_traceEventHook = NULL;
// TRACE_DUMP_HOOK g_traceDumpHook = NULL;
// #endif

// #ifdef LOSCFG_KERNEL_LMS
// LMS_INIT_HOOK g_lmsMemInitHook = NULL;
// LMS_FUNC_HOOK g_lmsMallocHook = NULL;
// LMS_FUNC_HOOK g_lmsFreeHook = NULL;
// #endif
// LITE_OS_SEC_TEXT UINTPTR LOS_Align(UINTPTR addr, UINT32 boundary)
// {
//     return (addr + boundary - 1) & ~((UINTPTR)(boundary - 1));
// }

// LITE_OS_SEC_TEXT_MINOR VOID LOS_Msleep(UINT32 msecs)
// {
//     UINT32 interval;

//     if (msecs == 0) {
//         interval = 0; /* The value 0 indicates direct scheduling. */
//     } else {
//         interval = LOS_MS2Tick(msecs);
//         if (interval < UINT32_MAX) {
//             interval += 1; /* Add a tick to compensate for the inaccurate tick count. */
//         }
//     }

//     (VOID)LOS_TaskDelay(interval);
// }

// VOID OsDumpMemByte(size_t length, UINTPTR addr)
// {
//     size_t dataLen;
//     UINTPTR *alignAddr = NULL;
//     UINT32 count = 0;

//     dataLen = ALIGN(length, sizeof(UINTPTR));
//     alignAddr = (UINTPTR *)TRUNCATE(addr, sizeof(UINTPTR));
//     if ((dataLen == 0) || (alignAddr == NULL)) {
//         return;
//     }
//     while (dataLen) {
//         if (IS_ALIGNED(count, sizeof(CHAR *))) {
//             PRINTK("\n 0x%lx :", alignAddr);
// #ifdef LOSCFG_SHELL_EXCINFO_DUMP
//             WriteExcInfoToBuf("\n 0x%lx :", alignAddr);
// #endif
//         }
// #ifdef __LP64__
//         PRINTK("%0+16lx ", *alignAddr);
// #else
//         PRINTK("%0+8lx ", *alignAddr);
// #endif
// #ifdef LOSCFG_SHELL_EXCINFO_DUMP
// #ifdef __LP64__
//         WriteExcInfoToBuf("0x%0+16x ", *alignAddr);
// #else
//         WriteExcInfoToBuf("0x%0+8x ", *alignAddr);
// #endif
// #endif
//         alignAddr++;
//         dataLen -= sizeof(CHAR *);
//         count++;
//     }
//     PRINTK("\n");
// #ifdef LOSCFG_SHELL_EXCINFO_DUMP
//     WriteExcInfoToBuf("\n");
// #endif

//     return;
// }

// #if defined(LOSCFG_DEBUG_SEMAPHORE) || defined(LOSCFG_DEBUG_MUTEX) || defined(LOSCFG_DEBUG_QUEUE)
// VOID OsArraySort(UINT32 *sortArray, UINT32 start, UINT32 end,
//                  const SortParam *sortParam, OsCompareFunc compareFunc)
// {
//     UINT32 left = start;
//     UINT32 right = end;
//     UINT32 idx = start;
//     UINT32 pivot = sortArray[start];

//     while (left < right) {
//         while ((left < right) && (sortArray[right] < sortParam->ctrlBlockCnt) && (pivot < sortParam->ctrlBlockCnt) &&
//                compareFunc(sortParam, sortArray[right], pivot)) {
//             right--;
//         }

//         if (left < right) {
//             sortArray[left] = sortArray[right];
//             idx = right;
//             left++;
//         }

//         while ((left < right) && (sortArray[left] < sortParam->ctrlBlockCnt) && (pivot < sortParam->ctrlBlockCnt) &&
//                compareFunc(sortParam, pivot, sortArray[left])) {
//             left++;
//         }

//         if (left < right) {
//             sortArray[right] = sortArray[left];
//             idx = left;
//             right--;
//         }
//     }

//     sortArray[idx] = pivot;

//     if (start < idx) {
//         OsArraySort(sortArray, start, idx - 1, sortParam, compareFunc);
//     }
//     if (idx < end) {
//         OsArraySort(sortArray, idx + 1, end, sortParam, compareFunc);
//     }
// }
// #endif

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif
// #endif /* __cplusplus */
