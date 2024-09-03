const std = @import("std");
const t = @import("./zlos_typedef.zig");
const defines = @import("./zlos_defines.zig");
const spinlock = @import("./zlos_spinlock.zig");
pub const MAX_LOCK_DEPTH: usize = 16;

// enum LockDepErrType {
//     LOCKDEP_SUCEESS = 0,
//     LOCKDEP_ERR_DOUBLE_LOCK,
//     LOCKDEP_ERR_DEAD_LOCK,
//     LOCKDEP_ERR_UNLOCK_WITHOUT_LOCK,
//     /* overflow, needs expand */
//     LOCKDEP_ERR_OVERFLOW,
// };

pub const HeldLocks = struct {
    lockPtr: ?*t.VOID = null,
    lockAddr: ?t.VOID = null,
    waitTime: t.UINT64 = 0,
    holdTime: t.UINT64 = 0,
};

pub const LockDep = struct {
    waitLock: ?*t.VOID = null,
    lockDepth: t.INT32 = 0,
    heldLocks: [MAX_LOCK_DEPTH]HeldLocks = std.mem.zeroes([MAX_LOCK_DEPTH]HeldLocks),
};

// /**
//  * @ingroup los_lockdep
//  *
//  * @par Description:
//  * This API is used to check dead lock in spinlock.
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be ensured to be a legal pointer.</li>
//  * </ul>
//  *
//  * @param lock    [IN] point to a SPIN_LOCK_S.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_lockdep.h: the header file that contains the API declaration.</li></ul>
//  * @see
//  * @since Huawei LiteOS V200R003C00
//  */
// extern VOID OsLockDepCheckIn(const SPIN_LOCK_S *lock);
pub fn OsLockDepCheckIn(lock: *spinlock.SPIN_LOCK_S) void {
    _ = lock;
}

// /**
//  * @ingroup los_lockdep
//  *
//  * @par Description:
//  * This API is used to trace when a spinlock locked.
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be ensured to be a legal pointer.</li>
//  * </ul>
//  *
//  * @param lock    [IN] point to a SPIN_LOCK_S.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_lockdep.h: the header file that contains the API declaration.</li></ul>
//  * @see
//  * @since Huawei LiteOS V200R003C00
//  */
// extern VOID OsLockDepRecord(SPIN_LOCK_S *lock);
pub fn OsLockDepRecord(lock: *spinlock.SPIN_LOCK_S) void {
    _ = lock;
}
// /**
//  * @ingroup los_lockdep
//  *
//  * @par Description:
//  * This API is used to trace when a spinlock unlocked.
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be ensured to be a legal pointer.</li>
//  * </ul>
//  *
//  * @param lock  [IN] point to a SPIN_LOCK_S.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_lockdep.h: the header file that contains the API declaration.</li></ul>
//  * @see
//  * @since Huawei LiteOS V200R003C00
//  */
// extern VOID OsLockDepCheckOut(SPIN_LOCK_S *lock);
pub fn OsLockDepCheckOut(lock: *spinlock.SPIN_LOCK_S) void {
    _ = lock;
}
// /**
//  * @ingroup los_lockdep
//  *
//  * @par Description:
//  * This API is used to clear lockdep record of current task.
//  * @attention
//  * <ul>
//  * <li>None.</li>
//  * </ul>
//  *
//  * @param None
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_lockdep.h: the header file that contains the API declaration.</li></ul>
//  * @see
//  * @since Huawei LiteOS V200R003C00
//  */
// extern VOID OsLockdepClearSpinlocks(VOID);
pub fn OsLockdepClearSpinlocks() void {}

// #endif /* LOSCFG_KERNEL_SMP_LOCKDEP */

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif
// #endif /* __cplusplus */
// #endif /* _LOS_LOCKDEP_H */
