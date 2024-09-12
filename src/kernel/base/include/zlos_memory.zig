const t = @import("../../../kernel/zlos_typedef.zig");
const defines = @import("../../../kernel/zlos_defines.zig");
const memstat = @import("./zlos_memstat.zig");
const slab = @import("./zlos_slab.zig");
const spinlock = @import("../../zlos_spinlock.zig");
// #if defined(LOSCFG_KERNEL_MEM_BESTFIT)
pub extern const g_memSpin: spinlock.Spinlock;
pub const LosHeapStatus = struct {
    totalUsedSize: t.UINT32 = 0,
    totalFreeSize: t.UINT32 = 0,
    maxFreeNodeSize: t.UINT32 = 0,
    usedNodeNum: t.UINT32 = 0,
    freeNodeNum: t.UINT32 = 0,
    // #ifdef LOSCFG_MEM_TASK_STAT
    //     UINT32 usageWaterLine;
    // #endif
    LOSCFG_MEM_TASK_STAT: ?struct {
        usageWaterLine: t.UINT32 = 0,
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,
};

pub const LosHeapNode = struct {
    prev: ?*LosHeapNode = null,
    // #ifdef LOSCFG_MEM_TASK_STAT
    //     UINT32 taskId;
    // #endif
    LOSCFG_MEM_TASK_STAT: ?struct {
        taskId: t.UINT32 = 0,
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,
    size: t.UINT32 = 30,
    used: t.UINT32 = 1,
    _align: t.UINT32 = 1,
    //   data:[0]t.UINT8
    data: [0]t.UINT8,
};
pub const LosHeapManager = if (defines.LOSCFG_KERNEL_MEM_BESTFIT_LITTLE) struct {
    head: ?*LosHeapNode = null,
    tail: ?*LosHeapNode = null,
    size: t.UINT32 = 0,

    // #ifdef LOSCFG_MEM_TASK_STAT
    //     Memstat stat;
    // #endif
    LOSCFG_MEM_TASK_STAT: ?struct {
        stat: memstat.Memstat = .{},
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,
    // #ifdef LOSCFG_MEM_MUL_POOL
    //     VOID *nextPool;
    // #endif
    LOSCFG_MEM_MUL_POOL: ?struct {
        nextPool: ?*t.VOID = null,
    } = if (defines.LOSCFG_MEM_MUL_POOL) .{} else null,
    // #ifdef LOSCFG_KERNEL_MEM_SLAB_EXTENTION
    //     struct LosSlabControlHeader slabCtrlHdr;
    // #endif

    LOSCFG_KERNEL_MEM_SLAB_EXTENTION: ?struct {
        slabCtrlHdr: slab.LosSlabControlHeader = .{},
    } = if (defines.LOSCFG_KERNEL_MEM_SLAB_EXTENTION) .{} else null,
} else struct {
    pool: ?*t.VOID = null, // Starting address of a memory pool */
    poolSize: t.UINT32 = 0, // Memory pool size */

    LOSCFG_MEM_TASK_STAT: ?struct {
        stat: memstat.Memstat = .{},
    } = if (defines.LOSCFG_MEM_TASK_STAT) .{} else null,
    LOSCFG_MEM_MUL_POOL: ?struct {
        nextPool: ?*t.VOID = null,
    } = if (defines.LOSCFG_MEM_MUL_POOL) .{} else null,

    LOSCFG_KERNEL_MEM_SLAB_EXTENTION: ?struct {
        slabCtrlHdr: slab.LosSlabControlHeader = .{},
    } = if (defines.LOSCFG_KERNEL_MEM_SLAB_EXTENTION) .{} else null,
};
pub const LosMemPoolInfo = LosHeapManager;

// #define IS_ALIGNED(value, alignSize) ((((UINTPTR)(value)) & ((UINTPTR)((alignSize) - 1))) == 0)

// // spinlock for mem module, only available on SMP mode */
// extern SPIN_LOCK_S g_memSpin;
// #define MEM_LOCK(state)       LOS_SpinLockSave(&g_memSpin, &(state))
pub fn MEM_LOCK(state: *t.UINT32) void {
    spinlock.LOS_SpinLockSave(&g_memSpin, state);
}
// #define MEM_UNLOCK(state)     LOS_SpinUnlockRestore(&g_memSpin, (state))

// extern UINTPTR g_sys_mem_addr_end;
// extern UINT32 OsMemSystemInit(UINTPTR memStart);

// // SLAB extention needs memory algorithms provide following internal apis */
// #ifdef LOSCFG_KERNEL_MEM_SLAB_EXTENTION
// extern VOID* OsMemAlloc(VOID *pool, UINT32 size);
// extern UINT32 OsMemFree(VOID *pool, const VOID *ptr);
// #endif // LOSCFG_KERNEL_MEM_SLAB_EXTENTION */

pub inline fn OsMemMulPoolInit(pool: *t.VOID, size: t.UINT32) !void {
    _ = pool;
    _ = size;
}

// pub inline fn OsMemMulPoolDeinit(pool:?*t.VOID)!void
// {
// }
// pub inline fn OsMemMulPoolHeadGet()?*t.VOID{
//     return;
// }
