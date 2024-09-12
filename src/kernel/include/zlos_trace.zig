const std = @import("std");
const t = @import("../zlos_typedef.zig");
const defines = @import("../zlos_defines.zig");
const task = @import("../base/zlos_task.zig");
const zlos_error = @import("../zlos_error.zig");
const LOS_ERRNO_OS_ERROR = zlos_error.LOS_ERRNO_OS_ERROR;
const LOS_MOD_TRACE = zlos_error.LOS_MOUDLE_ID.LOS_MOD_TRACE;
// #ifdef LOSCFG_TRACE_CONTROL_AGENT

// //
//  * @ingroup los_trace
//  * Trace Control agent task's priority.
//  */
// #define LOSCFG_TRACE_TASK_PRIORITY                              2
pub const LOSCFG_TRACE_TASK_PRIORITY = 2;
// #endif

// #define LOSCFG_TRACE_OBJ_MAX_NAME_SIZE                          LOS_TASK_NAMELEN
pub const LOSCFG_TRACE_OBJ_MAX_NAME_SIZE = task.LOS_TASK_NAMELEN;

// //
//  * @ingroup los_trace
//  * Trace records the max number of objects(kernel object, like tasks). if set to 0, trace will not record any object.
//  */
// #define LOSCFG_TRACE_OBJ_MAX_NUM                                0 // LOSCFG_BASE_CORE_TSK_LIMIT
pub const LOSCFG_TRACE_OBJ_MAX_NUM = 0;
// //
//  * @ingroup los_trace
//  * Trace tlv encode buffer size, the buffer is used to encode one piece raw frame to tlv message in online mode.
//  */
// #define LOSCFG_TRACE_TLV_BUF_SIZE                               100
pub const LOSCFG_TRACE_TLV_BUF_SIZE = 100;
// //
//  * @ingroup los_trace
//  * Trace error code: init trace failed.
//  *
//  * Value: 0x02001400
//  *
//  * Solution: Follow the trace State Machine.
//  */
// #define LOS_ERRNO_TRACE_ERROR_STATUS               LOS_ERRNO_OS_ERROR(LOS_MOD_TRACE, 0x00)
pub const LOS_ERRNO_TRACE_ERROR_STATUS = LOS_ERRNO_OS_ERROR(zlos_error.LOS_MOUDLE_ID.LOS_MOD_TRACE, 0x00);
// //
//  * @ingroup los_trace
//  * Trace error code: Insufficient memory for trace buf init.
//  *
//  * Value: 0x02001401
//  *
//  * Solution: Expand the configured system memory or decrease the value defined by LOS_TRACE_BUFFER_SIZE.
//  */
// #define LOS_ERRNO_TRACE_NO_MEMORY                  LOS_ERRNO_OS_ERROR(LOS_MOD_TRACE, 0x01)
pub const LOS_ERRNO_TRACE_NO_MEMORY = LOS_ERRNO_OS_ERROR(LOS_MOD_TRACE, 0x01);

// //
//  * @ingroup los_trace
//  * Trace error code: Insufficient memory for trace struct.
//  *
//  * Value: 0x02001402
//  *
//  * Solution: Increase trace buffer's size.
//  */
// #define LOS_ERRNO_TRACE_BUF_TOO_SMALL              LOS_ERRNO_OS_ERROR(LOS_MOD_TRACE, 0x02)
pub const LOS_ERRNO_TRACE_BUF_TOO_SMALL = LOS_ERRNO_OS_ERROR(LOS_MOD_TRACE, 0x02);

// //
//  * @ingroup los_trace
//  * Trace state.
//  */
pub const TraceState = enum(u32) {
    TRACE_UNINIT = 0, //< trace isn't inited */
    TRACE_INITED, //< trace is inited but not started yet */
    TRACE_STARTED, //< trace is started and system is tracing */
    TRACE_STOPED, //< trace is stopped */
};

// //
//  * @ingroup los_trace
//  * Trace mask is used to filter events in runtime. Each mask keep only one unique bit to 1, and user can define own
//  * module's trace mask.
//  */
// pub const LOS_TRACE_MASK = enum(u32) {
pub const TRACE_SYS_FLAG: t.UINT32 = 0x10;
pub const TRACE_HWI_FLAG: t.UINT32 = 0x20;
pub const TRACE_TASK_FLAG: t.UINT32 = 0x40;
pub const TRACE_SWTMR_FLAG: t.UINT32 = 0x80;
pub const TRACE_MEM_FLAG: t.UINT32 = 0x100;
pub const TRACE_QUE_FLAG: t.UINT32 = 0x200;
pub const TRACE_EVENT_FLAG: t.UINT32 = 0x400;
pub const TRACE_SEM_FLAG: t.UINT32 = 0x800;
pub const TRACE_MUX_FLAG: t.UINT32 = 0x1000;

pub const TRACE_MAX_FLAG: t.UINT32 = 0x80000000;
pub const TRACE_USER_DEFAULT_FLAG: t.UINT32 = 0xFFFFFFF0;
// };

// //
//  * @ingroup los_trace
//  * Trace event type which indicate the exactly happend events, user can define own module's event type like
//  * TRACE_#MODULE#_FLAG | NUMBER.
//  *                   28                     4
//  *    0 0 0 0 0 0 0 0 X X X X X X X X 0 0 0 0 0 0
//  *    |                                   |     |
//  *             trace_module_flag           number
//  *
//  */
pub const LOS_TRACE_TYPE = enum(u32) {
    // 0x10~0x1F */
    SYS_ERROR = TRACE_SYS_FLAG | 0,
    SYS_START = TRACE_SYS_FLAG | 1,
    SYS_STOP = TRACE_SYS_FLAG | 2,

    // 0x20~0x2F */
    HWI_CREATE = TRACE_HWI_FLAG | 0,
    HWI_CREATE_SHARE = TRACE_HWI_FLAG | 1,
    HWI_DELETE = TRACE_HWI_FLAG | 2,
    HWI_DELETE_SHARE = TRACE_HWI_FLAG | 3,
    HWI_RESPONSE_IN = TRACE_HWI_FLAG | 4,
    HWI_RESPONSE_OUT = TRACE_HWI_FLAG | 5,
    HWI_ENABLE = TRACE_HWI_FLAG | 6,
    HWI_DISABLE = TRACE_HWI_FLAG | 7,
    HWI_TRIGGER = TRACE_HWI_FLAG | 8,
    HWI_SETPRI = TRACE_HWI_FLAG | 9,
    HWI_CLEAR = TRACE_HWI_FLAG | 10,
    HWI_SETAFFINITY = TRACE_HWI_FLAG | 11,
    HWI_SENDIPI = TRACE_HWI_FLAG | 12,

    // 0x40~0x4F */
    TASK_CREATE = TRACE_TASK_FLAG | 0,
    TASK_PRIOSET = TRACE_TASK_FLAG | 1,
    TASK_DELETE = TRACE_TASK_FLAG | 2,
    TASK_SUSPEND = TRACE_TASK_FLAG | 3,
    TASK_RESUME = TRACE_TASK_FLAG | 4,
    TASK_SWITCH = TRACE_TASK_FLAG | 5,
    TASK_SIGNAL = TRACE_TASK_FLAG | 6,

    // 0x80~0x8F */
    SWTMR_CREATE = TRACE_SWTMR_FLAG | 0,
    SWTMR_DELETE = TRACE_SWTMR_FLAG | 1,
    SWTMR_START = TRACE_SWTMR_FLAG | 2,
    SWTMR_STOP = TRACE_SWTMR_FLAG | 3,
    SWTMR_EXPIRED = TRACE_SWTMR_FLAG | 4,

    // 0x100~0x10F */
    MEM_ALLOC = TRACE_MEM_FLAG | 0,
    MEM_ALLOC_ALIGN = TRACE_MEM_FLAG | 1,
    MEM_REALLOC = TRACE_MEM_FLAG | 2,
    MEM_FREE = TRACE_MEM_FLAG | 3,
    MEM_INFO_REQ = TRACE_MEM_FLAG | 4,
    MEM_INFO = TRACE_MEM_FLAG | 5,

    // 0x200~0x20F */
    QUEUE_CREATE = TRACE_QUE_FLAG | 0,
    QUEUE_DELETE = TRACE_QUE_FLAG | 1,
    QUEUE_RW = TRACE_QUE_FLAG | 2,

    // 0x400~0x40F */
    EVENT_CREATE = TRACE_EVENT_FLAG | 0,
    EVENT_DELETE = TRACE_EVENT_FLAG | 1,
    EVENT_READ = TRACE_EVENT_FLAG | 2,
    EVENT_WRITE = TRACE_EVENT_FLAG | 3,
    EVENT_CLEAR = TRACE_EVENT_FLAG | 4,

    // 0x800~0x80F */
    SEM_CREATE = TRACE_SEM_FLAG | 0,
    SEM_DELETE = TRACE_SEM_FLAG | 1,
    SEM_PEND = TRACE_SEM_FLAG | 2,
    SEM_POST = TRACE_SEM_FLAG | 3,

    // 0x1000~0x100F */
    MUX_CREATE = TRACE_MUX_FLAG | 0,
    MUX_DELETE = TRACE_MUX_FLAG | 1,
    MUX_PEND = TRACE_MUX_FLAG | 2,
    MUX_POST = TRACE_MUX_FLAG | 3,
};

// //
//  * @ingroup los_trace
//  * struct to store the trace config information.
//  */
pub const TraceBaseHeaderInfo = struct {
    bigLittleEndian: t.UINT32 = 0, //< big little endian flag */
    clockFreq: t.UINT32 = 0, //< system clock frequency */
    version: t.UINT32 = 0, //< trace version */
};

// //
//  * @ingroup los_trace
//  * struct to store the event infomation
//  */
pub const TraceEventFrame = struct {
    eventType: t.UINT32 = 0, //< event type */
    curTask: t.UINT32 = 0, //< current running task */
    curTime: t.UINT64 = 0, //< current timestamp */
    identity: t.UINTPTR = 0, //< subject of the event description */
    LOSCFG_TRACE_FRAME_CORE_MSG: ?struct {
        core: struct {
            cpuId: u8 = 0, //< cpuid */
            hwiActive: u4 = 0, //< whether is in hwi response */
            taskLockCnt: u4 = 0, //< task lock count */
            paramCount: u4 = 0, //< event frame params' number */
            reserves: u12 = 0, //< reserves */
        } = .{},
        LOSCFG_TRACE_FRAME_EVENT_COUNT: ?struct {
            eventCount: t.UINT32 = 0, //< the sequence of happend events */
        } = if (defines.LOSCFG_TRACE_FRAME_EVENT_COUNT > 0) .{} else null,

        LOSCFG_TRACE_FRAME_MAX_PARAMS: ?struct {
            params: [defines.LOSCFG_TRACE_FRAME_MAX_PARAMS]t.UINTPTR = .{}, //< event frame's params */
        } = if (defines.LOSCFG_TRACE_FRAME_MAX_PARAMS) .{} else null,
    } = if (defines.LOSCFG_TRACE_FRAME_CORE_MSG) .{} else null,
};

// //
//  * @ingroup los_trace
//  * struct to store the kernel obj information, we defined task as kernel obj in this system.
//  */
pub const ObjData = struct {
    id: t.UINT32 = 0, //< kernel obj's id */
    prio: t.UINT32 = 0, //< kernel obj's priority */
    name: [LOSCFG_TRACE_OBJ_MAX_NAME_SIZE]t.CHAR = .{}, //< kernel obj's name */
};

// //
//  * @ingroup los_trace
//  * struct to store the trace data.
//  */
pub const OfflineHead = struct {
    baseInfo: TraceBaseHeaderInfo = .{}, //< basic info, include bigLittleEndian flag, system clock freq */
    totalLen: t.UINT16 = 0, //< trace data's total length */
    objSize: t.UINT16 = 0, //< sizeof #ObjData */
    frameSize: t.UINT16 = 0, //< sizeof #TraceEventFrame */
    objOffset: t.UINT16 = 0, //< the offset of the first obj data to record beginning */
    frameOffset: t.UINT16 = 0, //< the offset of the first event frame data to record beginning */
};

// //
//  * @ingroup  los_trace
//  * @brief Define the type of trace hardware interrupt filter hook function.
//  *
//  * @par Description:
//  * User can register fliter function by LOS_TraceHwiFilterHookReg to filter hardware interrupt events. Return true if
//  * user don't need trace the certain number.
//  *
//  * @attention
//  * None.
//  *
//  * @param hwiNum        [IN] Type #UINT32. The hardware interrupt number.
//  * @retval #TRUE        0x00000001: Not record the certain number.
//  * @retval #FALSE       0x00000000: Need record the certain number.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @since Huawei LiteOS V200R005C00
//  */
// typedef BOOL (*TRACE_HWI_FILTER_HOOK)(UINT32 hwiNum);
pub const TRACE_HWI_FILTER_HOOK = *const fn (hwiNum: t.UINT32) t.BOOL;
// typedef VOID (*TRACE_EVENT_HOOK)(UINT32 eventType, UINTPTR identity, const UINTPTR *params, UINT16 paramCount);
pub const TRACE_EVENT_HOOK = *const fn (eventType: t.UINT32, identity: t.UINTPTR, params: *t.UINTPTR, paramCount: t.UINT16) void;
// extern TRACE_EVENT_HOOK g_traceEventHook;
pub extern var g_traceEventHook: TRACE_EVENT_HOOK;

// //
//  * @ingroup los_trace
//  * Trace event params:
//  1. Configure the macro without parameters so as not to record events of this type;
//  2. Configure the macro at least with one parameter to record this type of event;
//  3. User can delete unnecessary parameters which defined in corresponding marco;
//  * @attention
//  * <ul>
//  * <li>The first param is treat as key, keep at least this param if you want trace this event.</li>
//  * <li>All parameters were treated as UINTPTR.</li>
//  * </ul>
//  * eg. Trace a event as:
//  * #define TASK_PRIOSET_PARAMS(taskId, taskStatus, oldPrio, newPrio) taskId, taskStatus, oldPrio, newPrio
//  * eg. Not Trace a event as:
//  * #define TASK_PRIOSET_PARAMS(taskId, taskStatus, oldPrio, newPrio)
//  * eg. Trace only you need parmas as:
//  * #define TASK_PRIOSET_PARAMS(taskId, taskStatus, oldPrio, newPrio) taskId
//  */
// #define TASK_SWITCH_PARAMS(taskId, oldPriority, oldTaskStatus, newPriority, newTaskStatus) \
//     taskId, oldPriority, oldTaskStatus, newPriority, newTaskStatus
// #define TASK_PRIOSET_PARAMS(taskId, taskStatus, oldPrio, newPrio) taskId, taskStatus, oldPrio, newPrio
// #define TASK_CREATE_PARAMS(taskId, taskStatus, prio)     taskId, taskStatus, prio
// #define TASK_DELETE_PARAMS(taskId, taskStatus, usrStack) taskId, taskStatus, usrStack
// #define TASK_SUSPEND_PARAMS(taskId, taskStatus, runTaskId) taskId, taskStatus, runTaskId
// #define TASK_RESUME_PARAMS(taskId, taskStatus, prio)     taskId, taskStatus, prio
// #define TASK_SIGNAL_PARAMS(taskId, signal, schedFlag)    // taskId, signal, schedFlag

// #define SWTMR_START_PARAMS(swtmrId, mode, overrun, interval, expiry)  swtmrId, mode, overrun, interval, expiry
// #define SWTMR_DELETE_PARAMS(swtmrId)                                  swtmrId
// #define SWTMR_EXPIRED_PARAMS(swtmrId)                                 swtmrId
// #define SWTMR_STOP_PARAMS(swtmrId)                                    swtmrId
// #define SWTMR_CREATE_PARAMS(swtmrId)                                  swtmrId

// #define HWI_CREATE_PARAMS(hwiNum, hwiPrio, hwiMode, hwiHandler) hwiNum, hwiPrio, hwiMode, hwiHandler
// #define HWI_CREATE_SHARE_PARAMS(hwiNum, pDevId, ret)    hwiNum, pDevId, ret
// #define HWI_DELETE_PARAMS(hwiNum)                       hwiNum
// #define HWI_DELETE_SHARE_PARAMS(hwiNum, pDevId, ret)    hwiNum, pDevId, ret
// #define HWI_RESPONSE_IN_PARAMS(hwiNum)                  hwiNum
// #define HWI_RESPONSE_OUT_PARAMS(hwiNum)                 hwiNum
// #define HWI_ENABLE_PARAMS(hwiNum)                       hwiNum
// #define HWI_DISABLE_PARAMS(hwiNum)                      hwiNum
// #define HWI_TRIGGER_PARAMS(hwiNum)                      hwiNum
// #define HWI_SETPRI_PARAMS(hwiNum, priority)             hwiNum, priority
// #define HWI_CLEAR_PARAMS(hwiNum)                        hwiNum
// #define HWI_SETAFFINITY_PARAMS(hwiNum, cpuMask)         hwiNum, cpuMask
// #define HWI_SENDIPI_PARAMS(hwiNum, cpuMask)             hwiNum, cpuMask

// #define EVENT_CREATE_PARAMS(eventCB)                    eventCB
// #define EVENT_DELETE_PARAMS(eventCB, delRetCode)        eventCB, delRetCode
// #define EVENT_READ_PARAMS(eventCB, eventId, mask, mode, timeout) \
//     eventCB, eventId, mask, mode, timeout
// #define EVENT_WRITE_PARAMS(eventCB, eventId, events)    eventCB, eventId, events
// #define EVENT_CLEAR_PARAMS(eventCB, eventId, events)    eventCB, eventId, events

// #define QUEUE_CREATE_PARAMS(queueId, queueSz, itemSz, queueAddr, memType) \
//     queueId, queueSz, itemSz, queueAddr, memType
// #define QUEUE_DELETE_PARAMS(queueId, state, readable)   queueId, state, readable
// #define QUEUE_RW_PARAMS(queueId, queueSize, bufSize, operateType, readable, writeable, timeout) \
//     queueId, queueSize, bufSize, operateType, readable, writeable, timeout

// #define SEM_CREATE_PARAMS(semId, type, count)           semId, type, count
// #define SEM_DELETE_PARAMS(semId, delRetCode)            semId, delRetCode
// #define SEM_PEND_PARAMS(semId, count, timeout)          semId, count, timeout
// #define SEM_POST_PARAMS(semId, type, count)             semId, type, count

// #define MUX_CREATE_PARAMS(muxId)                        muxId
// #define MUX_DELETE_PARAMS(muxId, state, count, owner)   muxId, state, count, owner
// #define MUX_PEND_PARAMS(muxId, count, owner, timeout)   muxId, count, owner, timeout
// #define MUX_POST_PARAMS(muxId, count, owner)            muxId, count, owner

// #define MEM_ALLOC_PARAMS(pool, ptr, size)                   pool, ptr, size
// #define MEM_ALLOC_ALIGN_PARAMS(pool, ptr, size, boundary)   pool, ptr, size, boundary
// #define MEM_REALLOC_PARAMS(pool, ptr, size)                 pool, ptr, size
// #define MEM_FREE_PARAMS(pool, ptr)                          pool, ptr
// #define MEM_INFO_REQ_PARAMS(pool)                           pool
// #define MEM_INFO_PARAMS(pool, usedSize, freeSize)           pool, usedSize, freeSize

// #define SYS_ERROR_PARAMS(errno)                         errno

// #ifdef LOSCFG_KERNEL_TRACE

// //
//  * @ingroup los_trace
//  * @brief Trace static code stub.
//  *
//  * @par Description:
//  * This API is used to instrument trace code stub in source code, to track events.
//  * @attention
//  * None.
//  *
//  * @param TYPE           [IN] Type #LOS_TRACE_TYPE. The event type.
//  * @param IDENTITY       [IN] Type #UINTPTR. The subject of this event description.
//  * @param ...            [IN] Type #UINTPTR. This piece of event's params.
//  * @retval None.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @since Huawei LiteOS V200R005C00
//  */
// #define LOS_TRACE(TYPE, IDENTITY, ...)                                             \
//     do {                                                                           \
//         LOS_PERF(TYPE);                                                            \
//         UINTPTR _inner[] = {0, TYPE##_PARAMS((UINTPTR)IDENTITY, ##__VA_ARGS__)};   \
//         UINTPTR _n = sizeof(_inner) / sizeof(UINTPTR);                             \
//         if ((_n > 1) && (g_traceEventHook != NULL)) {                              \
//             g_traceEventHook(TYPE, _inner[1], _n > 2 ? &_inner[2] : NULL, _n - 2); \
//         }                                                                          \
//     } while (0)
// #else
// #define LOS_TRACE(TYPE, ...)   LOS_PERF(TYPE)
// #endif

pub inline fn LOS_TRACE(TYPE: t.UINT32, IDENTITY: t.UINT32, ...) void {
    _ = TYPE;
    _ = IDENTITY;
}

// #ifdef LOSCFG_KERNEL_TRACE

// //
//  * @ingroup los_trace
//  * @brief Trace static easier user-defined code stub.
//  *
//  * @par Description:
//  * This API is used to instrument user-defined trace code stub in source code, to track events simply.
//  * @attention
//  * None.
//  *
//  * @param TYPE           [IN] Type #UINT32. The event type, only low 4 bits take effect.
//  * @param IDENTITY       [IN] Type #UINTPTR. The subject of this event description.
//  * @param ...            [IN] Type #UINTPTR. This piece of event's params.
//  * @retval None.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @since Huawei LiteOS V200R005C00
//  */
// #define LOS_TRACE_EASY(TYPE, IDENTITY, ...)                                                                          \
//     do {                                                                                                             \
//         UINTPTR _inner[] = {0, ##__VA_ARGS__};                                                                       \
//         UINTPTR _n = sizeof(_inner) / sizeof(UINTPTR);                                                               \
//         if (g_traceEventHook != NULL) {                                                                              \
//             g_traceEventHook(TRACE_USER_DEFAULT_FLAG | TYPE, (UINTPTR)IDENTITY, _n > 1 ? &_inner[1] : NULL, _n - 1); \
//         }                                                                                                            \
//     } while (0)
// #else
// #define LOS_TRACE_EASY(...)
// #endif
pub inline fn LOS_TRACE_EASY(TYPE: t.UINT32, IDENTITY: t.UINT32, ...) void {
    _ = TYPE;
    _ = IDENTITY;
}

// //
//  * @ingroup los_trace
//  * @brief Intialize the trace when the system startup.
//  *
//  * @par Description:
//  * This API is used to intilize the trace for system level.
//  * @attention
//  * <ul>
//  * <li>This API can be called only after the memory is initialized. Otherwise, the Trace Init will be fail.</li>
//  * </ul>
//  *
//  * @param buf        [IN] Type #VOID *. The ptr is trace buffer address, if ptr is NULL, system will malloc a new one in
//  *                                  trace offline mode.
//  * @param size       [IN] Type #UINT32. The trace buffer's size.
//  *
//  * @retval #LOS_ERRNO_TRACE_ERROR_STATUS        0x02001400: The trace status is not TRACE_UNINIT.
//  * @retval #LOS_ERRNO_TRACE_NO_MEMORY           0x02001401: The memory is not enough for initilize.
//  * @retval #LOS_ERRNO_TRACE_BUF_TOO_SMALL       0x02001402: Trace buf size not enough.
//  * @retval #LOS_ERRNO_TSK_TCB_UNAVAILABLE       0x02000211: No free task control block is available.
//  * @retval #LOS_ERRNO_TSK_MP_SYNC_RESOURCE      0x02000225: Mp sync resource create failed
//  * @retval #LOS_OK                              0x00000000: The intialization is successful.
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceInit
//  * @since Huawei LiteOS V200R005C00
//  */
// extern UINT32 LOS_TraceInit(VOID *buf, UINT32 size);
pub extern fn LOS_TraceInit(buf: *t.VOID, size: t.UINT32) t.UINT32;
// //
//  * @ingroup los_trace
//  * @brief Start trace.
//  *
//  * @par Description:
//  * This API is used to start trace.
//  * @attention
//  * <ul>
//  * <li>Start trace</li>
//  * </ul>
//  *
//  * @param  None.
//  * @retval #LOS_ERRNO_TRACE_ERROR_STATUS        0x02001400: Trace start failed.
//  * @retval #LOS_OK                              0x00000000: Trace start success.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceStart
//  * @since Huawei LiteOS V200R005C00
//  */
// extern UINT32 LOS_TraceStart(VOID);
pub extern fn LOS_TraceStart() t.UINT32;

// //
//  * @ingroup los_trace
//  * @brief Stop trace sample.
//  *
//  * @par Description:
//  * This API is used to start trace sample.
//  * @attention
//  * <ul>
//  * <li>Stop trace sample</li>
//  * </ul>
//  *
//  * @param  None.
//  * @retval #None.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceStop
//  * @since Huawei LiteOS V200R005C00
//  */
// extern VOID LOS_TraceStop(VOID);
pub extern fn LOS_TraceStop() void;

// //
//  * @ingroup los_trace
//  * @brief Clear the trace buf.
//  *
//  * @par Description:
//  * Clear the event frames in trace buf only at offline mode.
//  * @attention
//  * <ul>
//  * <li>This API can be called only after that trace buffer has been established.</li>
//  * Otherwise, the trace will be failed.</li>
//  * </ul>
//  *
//  * @param  None.
//  * @retval #NA
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceReset
//  * @since Huawei LiteOS V200R005C00
//  */
// extern VOID LOS_TraceReset(VOID);
pub extern fn LOS_TraceReset() void;
// //
//  * @ingroup los_trace
//  * @brief Set trace event mask.
//  *
//  * @par Description:
//  * Set trace event mask.
//  * @attention
//  * <ul>
//  * <li>Set trace event filter mask.</li>
//  * <li>The Default mask is (TRACE_HWI_FLAG | TRACE_TASK_FLAG), stands for switch on task and hwi events.</li>
//  * <li>Customize mask according to the type defined in enum LOS_TRACE_MASK to switch on corresponding module's
//  * trace.</li>
//  * <li>The system's trace mask will be overrode by the input parameter.</li>
//  * </ul>
//  *
//  * @param  mask [IN] Type #UINT32. The mask used to filter events of LOS_TRACE_MASK.
//  * @retval #NA.
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceEventMaskSet
//  * @since Huawei LiteOS V200R005C00
//  */
// extern VOID LOS_TraceEventMaskSet(UINT32 mask);
pub extern fn LOS_TraceEventMaskSet(mask: t.UINT32) void;
// //
//  * @ingroup los_trace
//  * @brief Offline trace buffer display.
//  *
//  * @par Description:
//  * Display trace buf data only at offline mode.
//  * @attention
//  * <ul>
//  * <li>This API can be called only after that trace stopped. Otherwise the trace dump will be failed.</li>
//  * <li>Trace data will be send to pipeline when user set toClient = TRUE. Otherwise it will be formatted and printed
//  * out.</li>
//  * </ul>
//  *
//  * @param toClient           [IN] Type #BOOL. Whether send trace data to Client through pipeline.
//  * @retval #NA
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceRecordDump
//  * @since Huawei LiteOS V200R005C00
//  */
// extern VOID LOS_TraceRecordDump(BOOL toClient);
pub extern fn LOS_TraceRecordDump(toClient: t.BOOL) void;

// //
//  * @ingroup los_trace
//  * @brief Offline trace buffer export.
//  *
//  * @par Description:
//  * Return the trace buf only at offline mode.
//  * @attention
//  * <ul>
//  * <li>This API can be called only after that trace buffer has been established. </li>
//  * <li>The return buffer's address is a critical resource, user can only ready.</li>
//  * </ul>
//  *
//  * @param NA
//  * @retval #OfflineHead*   The trace buffer's address, analyze this buffer according to the structure of
//  * OfflineHead.
//  *
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceRecordGet
//  * @since Huawei LiteOS V200R005C00
//  */
// extern OfflineHead *LOS_TraceRecordGet(VOID);
pub extern fn LOS_TraceRecordGet() *OfflineHead;
// //
//  * @ingroup los_trace
//  * @brief Hwi num fliter hook.
//  *
//  * @par Description:
//  * Hwi fliter function.
//  * @attention
//  * <ul>
//  * <li>Filter the hwi events by hwi num</li>
//  * </ul>
//  *
//  * @param  hook [IN] Type #TRACE_HWI_FILTER_HOOK. The user defined hook for hwi num filter,
//  *                             the hook should return true if you don't want trace this hwi num.
//  * @retval #None
//  * @par Dependency:
//  * <ul><li>los_trace.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_TraceHwiFilterHookReg
//  * @since Huawei LiteOS V200R005C00
//  */
// extern VOID LOS_TraceHwiFilterHookReg(TRACE_HWI_FILTER_HOOK hook);
pub extern fn LOS_TraceHwiFilterHookReg(hook: TRACE_HWI_FILTER_HOOK) void;
