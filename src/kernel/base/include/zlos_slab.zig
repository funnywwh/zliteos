const std = @import("std");
const t = @import("../../../kernel/zlos_typedef.zig");
const defines = @import("../../../kernel/zlos_defines.zig");
const memstat = @import("./zlos_memstat.zig");

// number of slab class */
// #define SLAB_MEM_COUNT              4
pub const SLAB_MEM_COUNT = 4;
// step size of each class */
// #define SLAB_MEM_CALSS_STEP_SIZE    0x10U
pub const SLAB_MEM_CALSS_STEP_SIZE = 0x10;
// max slab block size */
// #define SLAB_MEM_MAX_SIZE           (SLAB_MEM_CALSS_STEP_SIZE << (SLAB_MEM_COUNT - 1))
pub const SLAB_MEM_MAX_SIZE = (SLAB_MEM_CALSS_STEP_SIZE << (SLAB_MEM_COUNT - 1));

pub const LosSlabStatus = struct {
    totalSize: t.UINT32 = 0,
    usedSize: t.UINT32 = 0,
    freeSize: t.UINT32 = 0,
    allocCount: t.UINT32 = 0,
    freeCount: t.UINT32 = 0,
};

pub const OsSlabBlockNode = struct {
    magic: t.UINT16 = 0,
    blkSz: t.UINT8 = 0,
    recordId: t.UINT8 = 0,
    // #define OS_SLAB_BLOCK_HEAD_GET(ptr)                ((OsSlabBlockNode *)(VOID *)((UINT8 *)(ptr) - \
    //                                                       sizeof(OsSlabBlockNode)))
    pub inline fn headGet(ptr: *t.VOID) *OsSlabBlockNode {
        const ret: *OsSlabBlockNode = @ptrFromInt(@intFromPtr(ptr) - @sizeOf(OsSlabBlockNode));
        return ret;
    }
    // #define OS_SLAB_BLOCK_MAGIC_SET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic = (UINT16)OS_SLAB_MAGIC)
    pub inline fn setMagic(this: *@This(), magic: t.UINT16) void {
        this.magic = magic;
    }
    // #define OS_SLAB_BLOCK_MAGIC_GET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic)
    pub inline fn getMagic(this: @This()) t.UINT16 {
        return this.magic;
    }
    // #define OS_SLAB_BLOCK_SIZE_SET(slabNode, size)     (((OsSlabBlockNode *)(slabNode))->blkSz = (UINT8)(size))
    pub inline fn setSize(this: @This(), size: t.UINT8) void {
        this.blkSz = size;
    }
    // #define OS_SLAB_BLOCK_SIZE_GET(slabNode)           (((OsSlabBlockNode *)(slabNode))->blkSz)
    pub inline fn getSize(this: @This()) t.UINT8 {
        return this.blkSz;
    }
    // #define OS_SLAB_BLOCK_ID_SET(slabNode, id)         (((OsSlabBlockNode *)(slabNode))->recordId = (id))
    pub inline fn setId(this: @This(), id: t.UINT8) void {
        this.recordId = id;
    }
    // #define OS_SLAB_BLOCK_ID_GET(slabNode)             (((OsSlabBlockNode *)(slabNode))->recordId)
    pub inline fn getId(this: @This()) t.UINT8 {
        return this.recordId;
    }
    // #define OS_ALLOC_FROM_SLAB_CHECK(slabNode)         (((OsSlabBlockNode *)(slabNode))->magic == (UINT16)OS_SLAB_MAGIC)
    pub inline fn check(this: @This()) !void {
        if (this.magic != OS_SLAB_MAGIC) {
            return error.os_slab_block_magic;
        }
    }
};

pub const AtomicBitset = packed struct {
    numBits: u32 = 0,
    pub fn words(this: *@This()) [*]t.UINT32 {
        const ptr: [*]u8 = @ptrCast(@constCast(this));

        const data = ptr + @sizeOf(@This());
        return @ptrCast(@alignCast(data));
    }
};

test "AtomicBitset" {
    try std.testing.expect(@sizeOf(AtomicBitset) == 4);
    std.testing.log_level = .debug;
    const ptr = try std.testing.allocator.alignedAlloc(u8, @alignOf(AtomicBitset), 1024);
    defer std.testing.allocator.free(ptr);
    var set: *AtomicBitset = @ptrCast(ptr);
    const words = set.words();
    std.log.debug("works[1]:{}", .{words[1]});
}
pub const OsSlabAllocator = struct {
    itemSz: t.UINT32 = 0,
    dataChunks: ?*t.UINT8 = 0,
    bitset: ?*AtomicBitset = null,
};

// #ifdef LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE
pub const OsSlabMemAllocator = struct {
    next: ?*OsSlabAllocator = null,
    slabAlloc: ?*OsSlabAllocator = null,
};
// #endif

pub const OsSlabMem = struct {
    blkSz: t.UINT32 = 0,
    blkCnt: t.UINT32 = 0,
    blkUsedCnt: t.UINT32 = 0,
    // #ifdef LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE
    //     allocatorCnt:t.UINT32 = 0,
    //     OsSlabMemAllocator *bucket;
    // #else
    //     OsSlabAllocator *alloc;
    // #endif
    LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE: ?struct {
        allocatorCnt: t.UINT32 = 0,
        bucket: *?OsSlabMemAllocator = null,
    } = if (defines.LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE) .{} else null,
};

pub const LosSlabControlHeader = struct {
    // #ifdef LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE
    //     OsSlabAllocator *allocatorBucket;
    // #endif
    LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE: ?struct {
        allocatorBucket: ?*OsSlabAllocator = null,
    } = if (defines.LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE) .{} else null,
    slabClass: [SLAB_MEM_COUNT]OsSlabMem = .{},
};

// #ifdef LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE
// #define SLAB_MEM_DFEAULT_BUCKET_CNT                1
// #endif
pub const SLAB_MEM_DFEAULT_BUCKET_CNT = 1;

// #define LOW_BITS_MASK                              31U
pub const LOW_BITS_MASK = 31;
// #define OS_SLAB_MAGIC                              0xdede
pub const OS_SLAB_MAGIC = 0xdede;

// #define OS_SLAB_BLOCK_HEAD_GET(ptr)                ((OsSlabBlockNode *)(VOID *)((UINT8 *)(ptr) - \
//                                                       sizeof(OsSlabBlockNode)))

// #define OS_SLAB_BLOCK_MAGIC_SET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic = (UINT16)OS_SLAB_MAGIC)
// #define OS_SLAB_BLOCK_MAGIC_GET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic)
// #define OS_SLAB_BLOCK_SIZE_SET(slabNode, size)     (((OsSlabBlockNode *)(slabNode))->blkSz = (UINT8)(size))
// #define OS_SLAB_BLOCK_SIZE_GET(slabNode)           (((OsSlabBlockNode *)(slabNode))->blkSz)
// #define OS_SLAB_BLOCK_ID_SET(slabNode, id)         (((OsSlabBlockNode *)(slabNode))->recordId = (id))
// #define OS_SLAB_BLOCK_ID_GET(slabNode)             (((OsSlabBlockNode *)(slabNode))->recordId)
// #define OS_ALLOC_FROM_SLAB_CHECK(slabNode)         (((OsSlabBlockNode *)(slabNode))->magic == (UINT16)OS_SLAB_MAGIC)
// #define ATOMIC_BITSET_SZ(numbits)                  (sizeof(struct AtomicBitset) + \
//                                                       ((numbits) + LOW_BITS_MASK) / 8) // 8, byte alignment */
// #define OS_SLAB_LOG2(value)                        ((UINT32)(32 - CLZ(value) - 1)) // get highest bit one position */
// #define OS_SLAB_CLASS_LEVEL_GET(size) \
//         (OS_SLAB_LOG2((size - 1) >> (OS_SLAB_LOG2(SLAB_MEM_CALSS_STEP_SIZE - 1))))

// extern OsSlabAllocator *OsSlabAllocatorNew(VOID *pool, UINT32 itemSz, UINT32 itemAlign, UINT32 numItems);
// extern VOID OsSlabAllocatorDestroy(VOID *pool, OsSlabAllocator *allocator);
// extern VOID *OsSlabAllocatorAlloc(OsSlabAllocator *allocator);
// extern BOOL OsSlabAllocatorFree(OsSlabAllocator *allocator, VOID* ptr);
// extern BOOL OsSlabAllocatorEmpty(const OsSlabAllocator *allocator);
// extern VOID OsSlabAllocatorGetSlabInfo(const OsSlabAllocator *allocator, UINT32 *itemSize,
//     UINT32 *itemCnt, UINT32 *curUsage);
// extern BOOL OsSlabAllocatorCheck(const OsSlabAllocator *allocator, const VOID *ptr);
// extern VOID OsSlabMemInit(VOID *pool, UINT32 size);
// extern VOID OsSlabMemDeinit(VOID *pool);
// extern VOID *OsSlabMemAlloc(VOID *pool, UINT32 sz);
// extern BOOL OsSlabMemFree(VOID *pool, VOID *ptr);
// extern UINT32 OsSlabMemCheck(const VOID *pool, const VOID *ptr);
// extern UINT32 OsSlabStatisticsGet(const VOID *pool, LosSlabStatus *status);
// extern UINT32 OsSlabGetMaxFreeBlkSize(const VOID *pool);
// extern VOID *OsSlabCtrlHdrGet(const VOID *pool);

// #else // !LOSCFG_KERNEL_MEM_SLAB_EXTENTION */

// STATIC INLINE VOID OsSlabMemInit(VOID *pool, UINT32 size)
// {
// }

// STATIC INLINE VOID OsSlabMemDeinit(VOID *pool)
// {
// }

// STATIC INLINE VOID *OsSlabMemAlloc(VOID *pool, UINT32 size)
// {
//     return NULL;
// }

// STATIC INLINE BOOL OsSlabMemFree(VOID *pool, VOID *ptr)
// {
//     return FALSE;
// }

// pub inline fn OsSlabMemCheck(const VOID *pool, const VOID *ptr)t.UINT32
// {
//     return (UINT32)-1;
// }

// #ifdef LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE
// #define SLAB_MEM_DFEAULT_BUCKET_CNT                1
// #endif

// #define LOW_BITS_MASK                              31U
// #define OS_SLAB_MAGIC                              0xdede
// #define OS_SLAB_BLOCK_HEAD_GET(ptr)                ((OsSlabBlockNode *)(VOID *)((UINT8 *)(ptr) - \
//                                                       sizeof(OsSlabBlockNode)))
// #define OS_SLAB_BLOCK_MAGIC_SET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic = (UINT16)OS_SLAB_MAGIC)
// #define OS_SLAB_BLOCK_MAGIC_GET(slabNode)          (((OsSlabBlockNode *)(slabNode))->magic)
// #define OS_SLAB_BLOCK_SIZE_SET(slabNode, size)     (((OsSlabBlockNode *)(slabNode))->blkSz = (UINT8)(size))
// #define OS_SLAB_BLOCK_SIZE_GET(slabNode)           (((OsSlabBlockNode *)(slabNode))->blkSz)
// #define OS_SLAB_BLOCK_ID_SET(slabNode, id)         (((OsSlabBlockNode *)(slabNode))->recordId = (id))
// #define OS_SLAB_BLOCK_ID_GET(slabNode)             (((OsSlabBlockNode *)(slabNode))->recordId)
// #define OS_ALLOC_FROM_SLAB_CHECK(slabNode)         (((OsSlabBlockNode *)(slabNode))->magic == (UINT16)OS_SLAB_MAGIC)
// #define ATOMIC_BITSET_SZ(numbits)                  (sizeof(struct AtomicBitset) + \
//                                                       ((numbits) + LOW_BITS_MASK) / 8) // 8, byte alignment */
// #define OS_SLAB_LOG2(value)                        ((UINT32)(32 - CLZ(value) - 1)) // get highest bit one position */
// #define OS_SLAB_CLASS_LEVEL_GET(size) \
//         (OS_SLAB_LOG2((size - 1) >> (OS_SLAB_LOG2(SLAB_MEM_CALSS_STEP_SIZE - 1))))

// extern OsSlabAllocator *OsSlabAllocatorNew(VOID *pool, UINT32 itemSz, UINT32 itemAlign, UINT32 numItems);
// extern VOID OsSlabAllocatorDestroy(VOID *pool, OsSlabAllocator *allocator);
// extern VOID *OsSlabAllocatorAlloc(OsSlabAllocator *allocator);
// extern BOOL OsSlabAllocatorFree(OsSlabAllocator *allocator, VOID* ptr);
// extern BOOL OsSlabAllocatorEmpty(const OsSlabAllocator *allocator);
// extern VOID OsSlabAllocatorGetSlabInfo(const OsSlabAllocator *allocator, UINT32 *itemSize,
//     UINT32 *itemCnt, UINT32 *curUsage);
// extern BOOL OsSlabAllocatorCheck(const OsSlabAllocator *allocator, const VOID *ptr);
// extern VOID OsSlabMemInit(VOID *pool, UINT32 size);
// extern VOID OsSlabMemDeinit(VOID *pool);
// extern VOID *OsSlabMemAlloc(VOID *pool, UINT32 sz);
// extern BOOL OsSlabMemFree(VOID *pool, VOID *ptr);
// extern UINT32 OsSlabMemCheck(const VOID *pool, const VOID *ptr);
// extern UINT32 OsSlabStatisticsGet(const VOID *pool, LosSlabStatus *status);
// extern UINT32 OsSlabGetMaxFreeBlkSize(const VOID *pool);
// extern VOID *OsSlabCtrlHdrGet(const VOID *pool);

// #else // !LOSCFG_KERNEL_MEM_SLAB_EXTENTION */

// STATIC INLINE VOID OsSlabMemInit(VOID *pool, UINT32 size)
// {
// }

// STATIC INLINE VOID OsSlabMemDeinit(VOID *pool)
// {
// }

// STATIC INLINE VOID *OsSlabMemAlloc(VOID *pool, UINT32 size)
// {
//     return NULL;
// }

// STATIC INLINE BOOL OsSlabMemFree(VOID *pool, VOID *ptr)
// {
//     return FALSE;
// }

// STATIC INLINE UINT32 OsSlabMemCheck(const VOID *pool, const VOID *ptr)
// {
//     return (UINT32)-1;
// }
