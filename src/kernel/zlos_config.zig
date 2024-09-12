const t = @import("./zlos_typedef.zig");
const defines = @import("./zlos_defines.zig");
const target = @import("../targets/target.zig");
// #ifdef LOSCFG_LIB_CONFIGURABLE
// extern UINT32 g_osSysClock;
// extern UINT32 g_tickPerSecond;
// extern UINT32 g_taskLimit;
// extern UINT32 g_taskMinStkSize;
// extern UINT32 g_taskIdleStkSize;
// extern UINT32 g_taskDfltStkSize;
// extern UINT32 g_taskSwtmrStkSize;
// extern UINT32 g_swtmrLimit;
// extern UINT32 g_semLimit;
// extern UINT32 g_muxLimit;
// extern UINT32 g_queueLimit;
// extern UINT32 g_timeSliceTimeOut;

// extern BOOL    g_nxEnabled;
// extern UINTPTR g_dlNxHeapBase;
// extern UINT32  g_dlNxHeapSize;

// #define LOS_GET_NX_CFG()              (g_nxEnabled)
// #define LOS_SET_NX_CFG(value)         (g_nxEnabled = (value))
// #define LOS_GET_DL_NX_HEAP_BASE()     (g_dlNxHeapBase)
// #define LOS_SET_DL_NX_HEAP_BASE(addr) (g_dlNxHeapBase = (addr))
// #define LOS_GET_DL_NX_HEAP_SIZE()     (g_dlNxHeapSize)
// #define LOS_SET_DL_NX_HEAP_SIZE(size) (g_dlNxHeapSize = (size))

// #define OS_SYS_CLOCK                      g_osSysClock
// #define KERNEL_TICK_PER_SECOND            g_tickPerSecond
// #define KERNEL_TSK_LIMIT                  g_taskLimit
// #define KERNEL_TSK_MIN_STACK_SIZE         g_taskMinStkSize
// #define KERNEL_TSK_DEFAULT_STACK_SIZE     g_taskDfltStkSize
// #define KERNEL_TSK_IDLE_STACK_SIZE        g_taskIdleStkSize
// #define KERNEL_TSK_SWTMR_STACK_SIZE       g_taskSwtmrStkSize
// #define KERNEL_SWTMR_LIMIT                g_swtmrLimit
// #define KERNEL_SEM_LIMIT                  g_semLimit
// #define KERNEL_MUX_LIMIT                  g_muxLimit
// #define KERNEL_QUEUE_LIMIT                g_queueLimit
// #define KERNEL_TIMESLICE_TIMEOUT          g_timeSliceTimeOut

// #else /* LOSCFG_LIB_CONFIGURABLE */

// #ifdef LOSCFG_KERNEL_NX
// #define LOS_GET_NX_CFG() true
// #define LOS_SET_NX_CFG(value)
// #define LOS_GET_DL_NX_HEAP_BASE() LOS_DL_HEAP_BASE
// #define LOS_SET_DL_NX_HEAP_BASE(addr)
// #define LOS_GET_DL_NX_HEAP_SIZE() LOS_DL_HEAP_SIZE
// #define LOS_SET_DL_NX_HEAP_SIZE(size)
// #else /* LOSCFG_KERNEL_NX */
// #define LOS_GET_NX_CFG() false
// #define LOS_SET_NX_CFG(value)
// #define LOS_GET_DL_NX_HEAP_BASE() NULL
// #define LOS_SET_DL_NX_HEAP_BASE(addr)
// #define LOS_GET_DL_NX_HEAP_SIZE() 0
// #define LOS_SET_DL_NX_HEAP_SIZE(size)
// #endif /* LOSCFG_KERNEL_NX */

// #define KERNEL_TICK_PER_SECOND            LOSCFG_BASE_CORE_TICK_PER_SECOND
// #define KERNEL_TSK_LIMIT                  LOSCFG_BASE_CORE_TSK_LIMIT
// #define KERNEL_TSK_MIN_STACK_SIZE         LOSCFG_BASE_CORE_TSK_MIN_STACK_SIZE
// #define KERNEL_TSK_DEFAULT_STACK_SIZE     LOSCFG_BASE_CORE_TSK_DEFAULT_STACK_SIZE
// #define KERNEL_TSK_IDLE_STACK_SIZE        LOSCFG_BASE_CORE_TSK_IDLE_STACK_SIZE
// #define KERNEL_TSK_SWTMR_STACK_SIZE       LOSCFG_BASE_CORE_TSK_SWTMR_STACK_SIZE
// #define KERNEL_SWTMR_LIMIT                LOSCFG_BASE_CORE_SWTMR_LIMIT
// #define KERNEL_SEM_LIMIT                  LOSCFG_BASE_IPC_SEM_LIMIT
// #define KERNEL_MUX_LIMIT                  LOSCFG_BASE_IPC_MUX_LIMIT
// #define KERNEL_QUEUE_LIMIT                LOSCFG_BASE_IPC_QUEUE_LIMIT
// #define KERNEL_TIMESLICE_TIMEOUT          LOSCFG_BASE_CORE_TIMESLICE_TIMEOUT

pub const LOSCFG_BASE_CORE_TIMESLICE_TIMEOUT = 2;
pub const LOSCFG_BASE_CORE_TICK_PER_SECOND = 1000;
pub const OS_SYS_CLOCK = target.clock.get_bus_clk();
// #endif /* LOSCFG_LIB_CONFIGURABLE */

// /**
//  * system sections start and end address
//  */
pub extern var __int_stack_start: t.CHAR;
pub extern var __int_stack_end: t.CHAR;
pub extern var __rodata_start: t.CHAR;
pub extern var __rodata_end: t.CHAR;
pub extern var __bss_start: t.CHAR;
pub extern var __bss_end: t.CHAR;
pub extern var __text_start: t.CHAR;
pub extern var __text_end: t.CHAR;
pub extern var __ram_data_start: t.CHAR;
pub extern var __ram_data_end: t.CHAR;
pub extern var __exc_heap_start: t.CHAR;
pub extern var __exc_heap_end: t.CHAR;
pub extern var __heap_start: t.CHAR;
pub extern var __init_array_start__: t.CHAR;
pub extern var __init_array_end__: t.CHAR;

// /****************************** System clock module configuration ****************************/
// /**
//  * @ingroup los_config
//  * System clock (unit: HZ)
//  */
// #ifndef OS_SYS_CLOCK
// #define OS_SYS_CLOCK (get_bus_clk())
// #endif
// /**
//  * @ingroup los_config
//  * time timer clock (unit: HZ)
//  */
// #ifndef OS_TIME_TIMER_CLOCK
// #define OS_TIME_TIMER_CLOCK OS_SYS_CLOCK
// #endif

// /**
//  * limit addr range when search for  'func local(frame pointer)' or 'func name'
//  */
// #ifndef OS_SYS_FUNC_ADDR_START
// #define OS_SYS_FUNC_ADDR_START ((UINTPTR)&__int_stack_start)
// #endif
// #ifndef OS_SYS_FUNC_ADDR_END
// #define OS_SYS_FUNC_ADDR_END g_sys_mem_addr_end
// #endif

// /**
//  * @ingroup los_config
//  * Microseconds of adjtime in one second
//  */
// #ifndef LOSCFG_BASE_CORE_ADJ_PER_SECOND
// #define LOSCFG_BASE_CORE_ADJ_PER_SECOND 500
// #endif

// /**
//  * @ingroup los_config
//  * Sched clck interval
//  */
// #define SCHED_CLOCK_INTETRVAL_TICKS 100

// /****************************** Interrupt module configuration ****************************/
// /**
//  * @ingroup los_hwi
//  * The macro is the binary point value that decides the maximum preemption level
//  * when LOSCFG_ARCH_INTERRUPT_PREEMPTION is defined. If preemption supported, the
//  * config value is [0, 1, 2, 3, 4, 5, 6], to the corresponding preemption level value
//  * is [128, 64, 32, 16, 8, 4, 2].
//  */
// #ifdef LOSCFG_ARCH_INTERRUPT_PREEMPTION
// #ifndef MAX_BINARY_POINT_VALUE
// #define MAX_BINARY_POINT_VALUE  4
// #endif
// #endif

// /****************************** Swtmr module configuration ********************************/
// #ifdef LOSCFG_BASE_IPC_QUEUE
// /**
//  * @ingroup los_swtmr
//  * Max number of software timers ID
//  *
//  * 0xFFFF: max number of all software timers
//  */
// #ifndef OS_SWTMR_MAX_TIMERID
// #define OS_SWTMR_MAX_TIMERID ((0xFFFF / KERNEL_SWTMR_LIMIT) * KERNEL_SWTMR_LIMIT)
// #endif
// /**
//  * @ingroup los_swtmr
//  * Maximum size of a software timer queue. The default value of LOSCFG_BASE_CORE_SWTMR_LIMIT is 16.
//  */
// #ifndef OS_SWTMR_HANDLE_QUEUE_SIZE
// #define OS_SWTMR_HANDLE_QUEUE_SIZE KERNEL_SWTMR_LIMIT
// #endif
// #endif

// /****************************** Memory module configuration **************************/
// /**
//  * @ingroup los_memory
//  * Starting address of the system memory
//  */
// #ifndef OS_SYS_MEM_ADDR
// #define OS_SYS_MEM_ADDR          (&__heap_start)
// #endif

// /**
//  * @ingroup los_dynload
//  * Size of Dynload heap in bytes (1MB = 0x100000 Bytes)
//  * Starting address of dynload heap
//  */
pub const LOSCFG_KERNLE_DYN_HEAPSIZE = 0;
pub const SYS_MEM_END = 0;
pub const LOS_DL_HEAP_SIZE = if (defines.LOSCFG_KERNEL_NX and defines.LOSCFG_KERNEL_DYNLOAD)
    LOSCFG_KERNLE_DYN_HEAPSIZE * 0x100000
else
    0;
pub const LOS_DL_HEAP_BASE = if (defines.LOSCFG_KERNEL_NX and defines.LOSCFG_KERNEL_DYNLOAD)
    SYS_MEM_END - LOS_DL_HEAP_SIZE
else
    0;

// #define LOS_DL_HEAP_SIZE  (LOSCFG_KERNLE_DYN_HEAPSIZE * 0x100000)
// #define LOS_DL_HEAP_BASE  (SYS_MEM_END - LOS_DL_HEAP_SIZE)
// #else
// #define LOS_DL_HEAP_SIZE   0
// #define LOS_DL_HEAP_BASE   0
// #endif

// /**
//  * @ingroup los_memory
//  * Memory size
//  */
// #ifndef OS_SYS_MEM_SIZE
// #define OS_SYS_MEM_SIZE ((g_sys_mem_addr_end) - \
//                          ((LOS_DL_HEAP_SIZE  + ((UINTPTR)&__heap_start) + (64 - 1)) & ~(64 - 1)))
// #endif

// /****************************** fw Interface configuration **************************/
// /**
//  * @ingroup los_config
//  * The core number is one in non-SMP architecture.
//  */
// #ifdef LOSCFG_KERNEL_SMP
// #define LOSCFG_KERNEL_CORE_NUM                          LOSCFG_KERNEL_SMP_CORE_NUM
// #else
// #define LOSCFG_KERNEL_CORE_NUM                          1
// #endif

pub const LOSCFG_KERNEL_SMP_CORE_NUM = 2;
pub const LOSCFG_BASE_CORE_TSK_LIMIT = 16;

pub const LOSCFG_KERNEL_CORE_NUM = if (defines.LOSCFG_KERNEL_SMP) LOSCFG_KERNEL_SMP_CORE_NUM else 1;

// #define LOSCFG_KERNEL_CPU_MASK                          ((1 << LOSCFG_KERNEL_CORE_NUM) - 1)

// /****************************** trace module configuration **************************/
// /**
//  * @ingroup los_trace
//  * It's the total size of trace buffer. Its unit is char.
//  */
// #ifdef LOSCFG_KERNEL_TRACE
// #ifdef LOSCFG_RECORDER_MODE_OFFLINE
// #define LOS_TRACE_BUFFER_SIZE                           LOSCFG_TRACE_BUFFER_SIZE
// #else
// #define LOS_TRACE_BUFFER_SIZE 0
// #endif
// #endif

// /****************************** perf module configuration **************************/
// /**
//  * @ingroup los_perf
//  * It's the total size of perf buffer. It's in the unit of char
//  */
// #ifdef LOSCFG_KERNEL_PERF
// #define LOS_PERF_BUFFER_SIZE                           2048
// #endif

// /**
//  * Version number
//  */
// #define _T(x)                                   x
// #define HW_LITEOS_SYSNAME                       "Huawei LiteOS"
// #define HW_LITEOS_SEP                           " "
// #define _V(v)                                   _T(HW_LITEOS_SYSNAME)_T(HW_LITEOS_SEP)_T(v)

// #define HW_LITEOS_VERSION                       "V200R005C20B053"
// #define HW_LITEOS_VER                           _V(HW_LITEOS_VERSION"-SMP")

// /**
//  * The Version number of Public
//  */
// #define MAJ_V                                   5
// #define MIN_V                                   1
// #define REL_V                                   0

// /**
//  * The release candidate version number
//  */
// #define EXTRA_V                                 0

// #define VERSION_NUM(a, b, c)                    (((a) << 16) | ((b) << 8) | (c))
// #define HW_LITEOS_OPEN_VERSION_NUM              VERSION_NUM(MAJ_V, MIN_V, REL_V)

// #define STRINGIFY_1(x)                          #x
// #define STRINGIFY(x)                            STRINGIFY_1(x)

// #define HW_LITEOS_OPEN_VERSION_STRING           STRINGIFY(MAJ_V) "." STRINGIFY(MIN_V) "." STRINGIFY(REL_V)
// #if (EXTRA_V != 0)
// #define HW_LITEOS_KERNEL_VERSION_STRING         HW_LITEOS_OPEN_VERSION_STRING "-rc" STRINGIFY(EXTRA_V)
// #else
// #define HW_LITEOS_KERNEL_VERSION_STRING         HW_LITEOS_OPEN_VERSION_STRING
// #endif

// extern VOID OsStart(VOID);
// extern UINT32 OsMain(VOID);
// extern VOID *OsGetMainTask(VOID);
// extern VOID OsSetMainTask(VOID);

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif /* __cplusplus */
// #endif /* __cplusplus */

// #endif /* _LOS_CONFIG_H */

pub fn LOS_SET_NX_CFG(value: t.BOOL) void {
    _ = value;
}

pub fn LOS_SET_DL_NX_HEAP_BASE(addr: t.UINTPTR) void {
    _ = addr;
}

pub fn LOS_SET_DL_NX_HEAP_SIZE(size: t.size_t) void {
    _ = size;
}

pub const LOSCFG_HWI_PRIO_LIMIT = 32;
pub const LOSCFG_PLATFORM_HWI_LIMIT = 256;
