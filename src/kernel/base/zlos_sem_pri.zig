const syserr = @import("../zlos_error.zig");
const t = @import("../zlos_typedef.zig");
const list = @import("../zlos_list.zig");
// /* Semaphore control structure. */
pub const LosSemCB = struct {
    semStat: t.UINT8 = 0, //\* Semaphore state, enum LosSemState */
    semType: t.UINT8 = 0, //\* Semaphore Type, enum LosSemType */
    semCount: t.UINT16 = 0, //\* number of available semaphores */
    semId: t.UINT32 = 0, //\* Semaphore control structure ID, COUNT(UINT16)|INDEX(UINT16) */
    semList: list.LOS_DL_LIST = .{}, //\* List of tasks that are waiting on a semaphore */
};

// //\* Semaphore type */

pub const OS_SEM_COUNTING = 0; //\* The semaphore is a counting semaphore which max count is LOS_SEM_COUNT_MAX */
pub const OS_SEM_BINARY = 1; //\* The semaphore is a binary semaphore which max count is OS_SEM_BINARY_COUNT_MAX */

// //\* Max count of binary semaphores */
pub const OS_SEM_BINARY_COUNT_MAX = 1;

// //\*  Semaphore information control block */
// extern LosSemCB *g_allSem;

// #define GET_SEM_LIST(ptr)                   LOS_DL_LIST_ENTRY(ptr, LosSemCB, semList)

// #ifndef LOSCFG_RESOURCE_ID_NOT_USE_HIGH_BITS

// //\* COUNT | INDEX  split bit */
// #define SEM_SPLIT_BIT                       16
// #define SET_SEM_ID(count, semId)            (((count) << SEM_SPLIT_BIT) | (semId))
// #define GET_SEM_INDEX(semId)                ((semId) & ((1U << SEM_SPLIT_BIT) - 1))
// #define GET_SEM_COUNT(semId)                ((semId) >> SEM_SPLIT_BIT)
// #else
// #define GET_SEM_INDEX(semId)                (semId)
// #endif

// #define GET_SEM(semId)                      (((LosSemCB *)g_allSem) + GET_SEM_INDEX(semId))

// //\* This API is used to create a semaphore control structure according to the initial number of available semaphores
//  * specified by count and return the ID of this semaphore control structure. */
// extern UINT32 OsSemInit(VOID);

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif //\* __cplusplus */
// #endif //\* __cplusplus */

// #endif //\* _LOS_SEM_PRI_H */
