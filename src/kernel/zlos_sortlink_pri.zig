const t = @import("./zlos_typedef.zig");
const defines = @import("./zlos_defines.zig");
const list = @import("./zlos_list.zig");
// /*
//  * Sortlink Rollnum Structure:
//  *   ------------------------------------------
//  *  | 31 | 30 | 29 |.......| 4 | 3 | 2 | 1 | 0 |
//  *   ------------------------------------------
//  *  |<-High Bits->|<---------Low Bits--------->|
//  *
//  *  Low Bits  : circles
//  *  High Bits : sortlink index
//  */
// #ifndef LOSCFG_BASE_CORE_USE_SINGLE_LIST
// #ifndef LOSCFG_BASE_CORE_USE_MULTI_LIST
// #error "NO SORTLIST TYPE SELECTED"
// #endif
// #endif

// #ifdef LOSCFG_BASE_CORE_USE_SINGLE_LIST

// #define OS_TSK_SORTLINK_LOGLEN  0U
// #define OS_TSK_SORTLINK_LEN     1U
// #define OS_TSK_MAX_ROLLNUM      0xFFFFFFFEU
// #define OS_TSK_LOW_BITS_MASK    0xFFFFFFFFU

// #define SORTLINK_CURSOR_UPDATE(CURSOR)
// #define SORTLINK_LISTOBJ_GET(LISTOBJ, SORTLINK)  (LISTOBJ = SORTLINK->sortLink)

// #define ROLLNUM_SUB(NUM1, NUM2)         NUM1 = (ROLLNUM(NUM1) - ROLLNUM(NUM2))
// #define ROLLNUM_ADD(NUM1, NUM2)         NUM1 = (ROLLNUM(NUM1) + ROLLNUM(NUM2))
// #define ROLLNUM_DEC(NUM)                NUM = ((NUM) - 1)
// #define ROLLNUM(NUM)                    (NUM)

// #define SET_SORTLIST_VALUE(sortList, value) (((SortLinkList *)(sortList))->idxRollNum = (value))

// #else

// #define OS_TSK_HIGH_BITS       3U
// #define OS_TSK_LOW_BITS        (32U - OS_TSK_HIGH_BITS)
// #define OS_TSK_SORTLINK_LOGLEN OS_TSK_HIGH_BITS
// #define OS_TSK_SORTLINK_LEN    (1U << OS_TSK_SORTLINK_LOGLEN)
// #define OS_TSK_SORTLINK_MASK   (OS_TSK_SORTLINK_LEN - 1U)
// #define OS_TSK_MAX_ROLLNUM     (0xFFFFFFFFU - OS_TSK_SORTLINK_LEN)
// #define OS_TSK_HIGH_BITS_MASK  (OS_TSK_SORTLINK_MASK << OS_TSK_LOW_BITS)
// #define OS_TSK_LOW_BITS_MASK   (~OS_TSK_HIGH_BITS_MASK)

// #define SORTLINK_CURSOR_UPDATE(CURSOR)          ((CURSOR) = ((CURSOR) + 1) & OS_TSK_SORTLINK_MASK)
// #define SORTLINK_LISTOBJ_GET(LISTOBJ, SORTLINK) ((LISTOBJ) = (SORTLINK)->sortLink + (SORTLINK)->cursor)

// #define EVALUATE_L(NUM, VALUE) NUM = (((NUM) & OS_TSK_HIGH_BITS_MASK) | (VALUE))

// #define EVALUATE_H(NUM, VALUE) NUM = (((NUM) & OS_TSK_LOW_BITS_MASK) | ((VALUE) << OS_TSK_LOW_BITS))

// #define ROLLNUM_SUB(NUM1, NUM2)                 \
//     NUM1 = (((NUM1) & OS_TSK_HIGH_BITS_MASK) |  \
//     (ROLLNUM(NUM1) - ROLLNUM(NUM2)))

// #define ROLLNUM_ADD(NUM1, NUM2)                 \
//     NUM1 = (((NUM1) & OS_TSK_HIGH_BITS_MASK) |  \
//     (ROLLNUM(NUM1) + ROLLNUM(NUM2)))

// #define ROLLNUM_DEC(NUM) NUM = ((NUM) - 1)

// #define ROLLNUM(NUM) ((NUM) & OS_TSK_LOW_BITS_MASK)

// #define SORT_INDEX(NUM) ((NUM) >> OS_TSK_LOW_BITS)

// #define SET_SORTLIST_VALUE(sortList, value) (((SortLinkList *)(sortList))->idxRollNum = (value))

// #endif

pub const SortLinkList = struct {
    sortLinkNode: list.LOS_DL_LIST = .{},
    idxRollNum: t.UINT32 = 0,
};

pub const SortLinkAttribute = struct {
    sortLink: ?*list.LOS_DL_LIST = null,
    cursor: t.UINT16 = 0,
    reserved: t.UINT16 = 0,
};

// extern UINT32 OsSortLinkInit(SortLinkAttribute *sortLinkHeader);
// extern VOID OsAdd2SortLink(const SortLinkAttribute *sortLinkHeader, SortLinkList *sortList);
// extern VOID OsDeleteSortLink(const SortLinkAttribute *sortLinkHeader, SortLinkList *sortList);
// extern UINT32 OsSortLinkGetNextExpireTime(const SortLinkAttribute *sortLinkHeader);
// extern UINT32 OsSortLinkGetTargetExpireTime(const SortLinkAttribute *sortLinkHeader,
//                                             const SortLinkList *targetSortList);
// extern VOID OsSortLinkUpdateExpireTime(UINT32 sleepTicks, SortLinkAttribute *sortLinkHeader);

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif /* __cplusplus */
// #endif /* __cplusplus */

// #endif /* _LOS_SORTLINK_PRI_H */
