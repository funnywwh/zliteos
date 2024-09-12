const t = @import("../../../zlos_typedef.zig");
const task = @import("../../../base/zlos_task.zig");
const spinlock = @import("../../../zlos_spinlock.zig");
const memory = @import("../../../../kernel/include/zlos_memory.zig");
const printf = @import("../../../../kernel/include/zlos_printf.zig");
const slab = @import("../../../base/include/zlos_slab.zig");
const defines = @import("../../../zlos_defines.zig");
// #define ALIGNE(sz)                            (((sz) + HEAP_ALIGN - 1) & (~(HEAP_ALIGN - 1)))
pub fn ALIGNE(sz: t.size_t) usize {
    return @alignOf(sz);
}
// #define OS_MEM_ALIGN(value, align)            (((UINT32)(UINTPTR)(value) + (UINT32)((align) - 1)) & \
//    (~(UINT32)((align) - 1)))
pub const OS_MEM_ALIGN = ALIGNE;

// #define OS_MEM_ALIGN_FLAG                     0x80000000
pub const OS_MEM_ALIGN_FLAG = 0x80000000;
// #define OS_MEM_SET_ALIGN_FLAG(align)          ((align) = ((align) | OS_MEM_ALIGN_FLAG))
pub fn OS_MEM_SET_ALIGN_FLAG(_align: usize) usize {
    return _align | OS_MEM_ALIGN_FLAG;
}
// #define OS_MEM_GET_ALIGN_FLAG(align)          ((align) & OS_MEM_ALIGN_FLAG)
// #define OS_MEM_GET_ALIGN_GAPSIZE(align)       ((align) & (~OS_MEM_ALIGN_FLAG))

pub const LosHeapStatus = struct {
    totalUsedSize: t.UINT32 = 0,
    totalFreeSize: t.UINT32 = 0,
    maxFreeNodeSize: t.UINT32 = 0,
    usedNodeNum: t.UINT32 = 0,
    freeNodeNum: t.UINT32 = 0,
    LOSCFG_MEM_TASK_STAT: ?struct {
        usageWaterLine: t.UINT32 = 0,
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,
};

pub const LosHeapNode = struct {
    prev: ?*LosHeapNode = null,
    LOSCFG_MEM_TASK_STAT: ?struct {
        taskId: t.UINT32 = 0,
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,

    size: t.UINT32 = 30,
    used: t.UINT32 = 1,
    _align: t.UINT32 = 1,
    data: [0]t.UINT8 = .{},
};

pub extern fn OsHeapInit(pool: *t.VOID, size: t.UINT32) t.BOOL;
pub extern fn OsHeapAlloc(pool: *t.VOID, size: t.UINT32) *t.VOID;
pub extern fn OsHeapAllocAlign(pool: *t.VOID, size: t.UINT32, boundary: t.UINT32) *t.VOID;
pub extern fn OsHeapFree(pool: *t.VOID, ptr: *t.VOID) t.BOOL;
pub extern fn OsHeapStatisticsGet(pool: *t.VOID, status: *LosHeapStatus) t.UINT32;
pub extern fn OsHeapIntegrityCheck(heap: *memory.LosHeapManager) t.UINT32;

// #define POOL_ADDR_ALIGNSIZE 64
pub const POOL_ADDR_ALIGNSIZE: t.UINT32 = 64;
pub var g_MALLOC_HOOK: ?memory.MALLOC_HOOK = null;
// LITE_OS_SEC_BSS  SPIN_LOCK_INIT(g_memSpin);
pub const g_memSpin: spinlock.Spinlock = spinlock.Spinlock.init("g_memSpin");

// UINT8 *m_aucSysMem0 = (UINT8 *)NULL;
pub const m_aucSysMem0: ?*t.UINT8 = null;

// UINT8 *m_aucSysMem1 = (UINT8 *)NULL;
pub const m_aucSysMem1: ?*t.UINT8 = null;

// __attribute__((section(".data.init"))) UINTPTR g_sys_mem_addr_end;
pub extern var g_sys_mem_addr_end: t.UINTPTR;

// #ifdef LOSCFG_EXC_INTERACTION
// __attribute__((section(".data.init"))) UINTPTR g_excInteractMemSize = 0;
pub var g_excInteractMemSize: t.UINTPTR = 0;
// #endif

pub fn IS_ALIGNED(v: anytype, alignSize: usize) bool {
    if (@alignOf(v) == alignSize) {
        return true;
    }
    return false;
}
// LITE_OS_SEC_TEXT_INIT
pub fn LOS_MemInit(pool: ?*t.VOID, size: t.UINT32) !void {
    var intSave: t.UINT32 = 0;

    if ((pool == null) || (size <= @sizeOf(memory.LosHeapManager))) {
        return error.invalid_param;
    }

    if (!IS_ALIGNED(size, memory.OS_MEM_ALIGN_SIZE) || !IS_ALIGNED(pool, memory.OS_MEM_ALIGN_SIZE)) {
        printf.PRINT_WARN("pool [%p, %p) size 0x%x should be aligned with OS_MEM_ALIGN_SIZE\n", pool, pool + size, size);
        size = memory.OS_MEM_ALIGN(size, memory.OS_MEM_ALIGN_SIZE) - memory.OS_MEM_ALIGN_SIZE;
    }

    memory.MEM_LOCK(&intSave);
    defer {
        memory.MEM_UNLOCK(intSave);
    }
    try memory.OsMemMulPoolInit(pool, size);

    if (OsHeapInit(pool, size) == t.FALSE) {
        try memory.OsMemMulPoolDeinit(pool);
    }

    slab.OsSlabMemInit(pool, size);

    // LOS_TRACE(MEM_INFO_REQ, pool);
    // return ret;
}

// #ifdef LOSCFG_EXC_INTERACTION
// LITE_OS_SEC_TEXT_INIT UINT32 OsMemExcInteractionInit(UINTPTR memStart)
// {
//     UINT32 ret;
//     m_aucSysMem0 = (UINT8 *)memStart;
//     g_excInteractMemSize = EXC_INTERACT_MEM_SIZE;
//     ret = LOS_MemInit(m_aucSysMem0, g_excInteractMemSize);
//     PRINT_INFO("LiteOS kernel exc interaction memory address:%p,size:0x%x\n", m_aucSysMem0, g_excInteractMemSize);
//     return ret;
// }
// #endif

// /*
//  * Description : Initialize Dynamic Memory pool
//  * Return      : LOS_OK on success or error code on failure
//  */
// LITE_OS_SEC_TEXT_INIT UINT32 OsMemSystemInit(UINTPTR memStart)
// {
//     UINT32 ret;
//     UINT32 memSize;

//     m_aucSysMem1 = (UINT8 *)memStart;
//     memSize = OS_SYS_MEM_SIZE;
//     ret = LOS_MemInit((VOID *)m_aucSysMem1, memSize);
// #ifndef LOSCFG_EXC_INTERACTION
//     m_aucSysMem0 = m_aucSysMem1;
// #endif
//     return ret;
// }

// /*
//  * Description : print heap information
//  * Input       : pool --- Pointer to the manager, to distinguish heap
//  */
// VOID OsMemInfoPrint(const VOID *pool)
// {
//     struct LosHeapManager *heapMan = (struct LosHeapManager *)pool;
//     LosHeapStatus status = {0};

//     if (OsHeapStatisticsGet(heapMan, &status) == LOS_NOK) {
//         return;
//     }

//     PRINT_INFO("pool addr    pool size    used size    free size    max free    alloc Count    free Count\n");
//     PRINT_INFO("0x%-8x   0x%-8x   0x%-8x    0x%-8x   0x%-8x   0x%-8x     0x%-8x\n",
//                pool, heapMan->size, status.totalUsedSize, status.totalFreeSize, status.maxFreeNodeSize,
//                status.usedNodeNum, status.freeNodeNum);
// }

// LITE_OS_SEC_TEXT VOID *LOS_MemAlloc(VOID *pool, UINT32 size)
// {
//     VOID *ptr = NULL;
//     UINT32 intSave;

//     if ((pool == NULL) || (size == 0)) {
//         return ptr;
//     }

//     MEM_LOCK(intSave);

//     ptr = OsSlabMemAlloc(pool, size);
//     if (ptr == NULL) {
//         ptr = OsHeapAlloc(pool, size);
//     }

//     MEM_UNLOCK(intSave);

//     LOS_TRACE(MEM_ALLOC, pool, (UINTPTR)ptr, size);
//     return ptr;
// }

// LITE_OS_SEC_TEXT VOID *LOS_MemAllocAlign(VOID *pool, UINT32 size, UINT32 boundary)
// {
//     VOID *ptr = NULL;
//     UINT32 intSave;

//     MEM_LOCK(intSave);
//     ptr = OsHeapAllocAlign(pool, size, boundary);
//     MEM_UNLOCK(intSave);

//     LOS_TRACE(MEM_ALLOC_ALIGN, pool, (UINTPTR)ptr, size, boundary);
//     return ptr;
// }

// VOID *LOS_MemRealloc(VOID *pool, VOID *ptr, UINT32 size)
// {
//     VOID *retPtr = NULL;
//     VOID *freePtr = NULL;
//     UINT32 intSave;
//     struct LosHeapNode *node = NULL;
//     UINT32 cpySize;
//     UINT32 gapSize;
//     errno_t rc;

//     /* Zero-size requests are treated as free. */
//     if ((ptr != NULL) && (size == 0)) {
//         if (LOS_MemFree(pool, ptr) != LOS_OK) {
//             PRINT_ERR("LOS_MemFree error, pool[%p], pPtr[%p]\n", pool, ptr);
//         }
//     } else if (ptr == NULL) { // Requests with NULL pointers are treated as malloc.
//         retPtr = LOS_MemAlloc(pool, size);
//     } else {
//         MEM_LOCK(intSave);

//         UINT32 oldSize = OsSlabMemCheck(pool, ptr);
//         if (oldSize != (UINT32)(-1)) {
//             cpySize = (size > oldSize) ? oldSize : size;
//         } else {
//             /* find the real ptr through gap size */
//             gapSize = *((UINTPTR *)((UINTPTR)ptr - sizeof(UINTPTR)));
//             if (OS_MEM_GET_ALIGN_FLAG(gapSize)) {
//                 MEM_UNLOCK(intSave);
//                 return NULL;
//             }

//             node = ((struct LosHeapNode *)ptr) - 1;
//             cpySize = (size > (node->size)) ? (node->size) : size;
//         }

//         MEM_UNLOCK(intSave);

//         retPtr = LOS_MemAlloc(pool, size);
//         if (retPtr != NULL) {
//             rc = memcpy_s(retPtr, size, ptr, cpySize);
//             if (rc == EOK) {
//                 freePtr = ptr;
//             } else {
//                 freePtr = retPtr;
//                 retPtr = NULL;
//             }

//             if (LOS_MemFree(pool, freePtr) != LOS_OK) {
//                 PRINT_ERR("LOS_MemFree error, pool[%p], ptr[%p]\n", pool, freePtr);
//             }
//         }
//     }

//     LOS_TRACE(MEM_REALLOC, pool, (UINTPTR)ptr, size);
//     return retPtr;
// }

// LITE_OS_SEC_TEXT UINT32 LOS_MemFree(VOID *pool, VOID *mem)
// {
//     BOOL ret = FALSE;
//     UINT32 intSave;

//     if ((pool == NULL) || (mem == NULL)) {
//         return LOS_NOK;
//     }

//     MEM_LOCK(intSave);

//     ret = OsSlabMemFree(pool, mem);
//     if (ret != TRUE) {
//         ret = OsHeapFree(pool, mem);
//     }

//     MEM_UNLOCK(intSave);

//     LOS_TRACE(MEM_FREE, pool, (UINTPTR)mem);
//     return (ret == TRUE ? LOS_OK : LOS_NOK);
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_MemInfoGet(VOID *pool, LOS_MEM_POOL_STATUS *status)
// {
//     LosHeapStatus heapStatus;
//     UINT32 err;
//     UINT32 intSave;

//     if ((pool == NULL) || (status == NULL)) {
//         return LOS_NOK;
//     }

//     MEM_LOCK(intSave);

//     err = OsHeapStatisticsGet(pool, &heapStatus);
//     if (err != LOS_OK) {
//         MEM_UNLOCK(intSave);
//         return LOS_NOK;
//     }

//     status->uwTotalUsedSize   = heapStatus.totalUsedSize;
//     status->uwTotalFreeSize   = heapStatus.totalFreeSize;
//     status->uwMaxFreeNodeSize = heapStatus.maxFreeNodeSize;
//     status->uwUsedNodeNum  = heapStatus.usedNodeNum;
//     status->uwFreeNodeNum  = heapStatus.freeNodeNum;

// #ifdef LOSCFG_MEM_TASK_STAT
//     status->uwUsageWaterLine = heapStatus.usageWaterLine;
// #endif

//     MEM_UNLOCK(intSave);
//     return LOS_OK;
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_MemTotalUsedGet(VOID *pool)
// {
//     LosHeapStatus heapStatus;
//     UINT32 err;
//     UINT32 intSave;

//     if (pool == NULL) {
//         return OS_NULL_INT;
//     }

//     MEM_LOCK(intSave);
//     err = OsHeapStatisticsGet(pool, &heapStatus);
//     MEM_UNLOCK(intSave);

//     if (err != LOS_OK) {
//         return OS_NULL_INT;
//     }

//     return heapStatus.totalUsedSize;
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_MemPoolSizeGet(const VOID *pool)
// {
//     struct LosHeapManager *heapManager = NULL;

//     if (pool == NULL) {
//         return OS_NULL_INT;
//     }

//     heapManager = (struct LosHeapManager *)pool;
//     return heapManager->size;
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_MemIntegrityCheck(VOID *pool)
// {
//     UINT32 intSave;
//     UINT32 ret;

//     if (pool == NULL) {
//         return OS_NULL_INT;
//     }

//     MEM_LOCK(intSave);
//     ret = OsHeapIntegrityCheck(pool);
//     MEM_UNLOCK(intSave);

//     return ret;
// }

// VOID OsMemIntegrityMultiCheck(VOID)
// {
//     if (LOS_MemIntegrityCheck(m_aucSysMem1) == LOS_OK) {
//         PRINTK("system memcheck over, all passed!\n");
// #ifdef LOSCFG_SHELL_EXCINFO_DUMP
//         WriteExcInfoToBuf("system memcheck over, all passed!\n");
// #endif
//     }
// #ifdef LOSCFG_EXC_INTERACTION
//     if (LOS_MemIntegrityCheck(m_aucSysMem0) == LOS_OK) {
//         PRINTK("exc interaction memcheck over, all passed!\n");
// #ifdef LOSCFG_SHELL_EXCINFO_DUMP
//         WriteExcInfoToBuf("exc interaction memcheck over, all passed!\n");
// #endif
//     }
// #endif
// }
