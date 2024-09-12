const t = @import("../../zlos_typedef.zig");
const defines = @import("../../zlos_defines.zig");
const lockdep = @import("../../zlos_lockdep.zig");
const hwi = @import("../../include/zlos_hwi.zig");
const task = @import("../../base/zlos_task.zig");
const spinlock = @import("../../zlos_spinlock.zig");
// #ifdef LOSCFG_KERNEL_SMP_LOCKDEP
pub const SPINLOCK_OWNER_INIT = null;

// #define LOCKDEP_CHECK_IN(lock)  OsLockDepCheckIn(lock)
pub inline fn LOCKDEP_CHECK_IN(lock: *spinlock.SPIN_LOCK_S) void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockDepCheckIn(lock);
    }
}
// #define LOCKDEP_RECORD(lock)    OsLockDepRecord(lock)
pub inline fn LOCKDEP_RECORD(lock: *spinlock.SPIN_LOCK_S) void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockDepRecord(lock);
    }
}
// #define LOCKDEP_CHECK_OUT(lock) OsLockDepCheckOut(lock)
pub inline fn LOCKDEP_CHECK_OUT(lock: *spinlock.SPIN_LOCK_S) void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockDepCheckOut(lock);
    }
}
// #define LOCKDEP_CLEAR_LOCKS()   OsLockdepClearSpinlocks()
pub inline fn LOCKDEP_CLEAR_LOCKS() void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockdepClearSpinlocks();
    }
}
// #define SPIN_LOCK_INITIALIZER(lockName) \
// {                                       \
//     .rawLock    = 0U,                   \
//     .cpuid      = (UINT32)(-1),         \
//     .owner      = SPINLOCK_OWNER_INIT,  \
//     .name       = #lockName,            \
// }
// #else
// #define LOCKDEP_CHECK_IN(lock)
// #define LOCKDEP_RECORD(lock)
// #define LOCKDEP_CHECK_OUT(lock)
// #define LOCKDEP_CLEAR_LOCKS()
// #define SPIN_LOCK_INITIALIZER(lockName) \
// {                                       \
//     .rawLock    = 0U,                   \
// }
// #endif

pub inline fn SPIN_LOCK_INITIALIZER(lockName: []const u8) spinlock.SPIN_LOCK_S {
    return spinlock.SPIN_LOCK_S.init(lockName);
}
// /**
//  * @ingroup  los_spinlock
//  * <ul>
//  * <li>This macro is used to define the input parameter lock as a spinlock, and initialize the
//  *     spinlock statically.</li>
//  * <li>This macro has no return value.</li>
//  * <li>Note that the input parameter lock does not need to be defined before calling this macro.
//  *     Otherwise, the variable lock is repeatedly defined.</li>
//  * <li>On Non-SMP (UP) mode, this macro has no effect.</li>
//  * <li>The spinlock is advised to protect operation that take a short time. Otherwise, the overall system
//  *     performance may be affected because the thread exits the waiting loop only after the spinlock is
//  *     obtained. For time-consuming operation, the mutex lock can be used instead of spinlock.</li>
//  * </ul>
//  */
// #define SPIN_LOCK_INIT(lock)  SPIN_LOCK_S lock = SPIN_LOCK_INITIALIZER(lock)
pub inline fn SPIN_LOCK_INIT(lockName: []const u8) spinlock.SPIN_LOCK_S {
    return SPIN_LOCK_INITIALIZER(lockName);
}
// /**
//  * @ingroup  los_spinlock
//  * Define the structure of spinlock.
//  */
// struct Spinlock {
//     size_t      rawLock;            /**< raw spinlock */
// #ifdef LOSCFG_KERNEL_SMP_LOCKDEP
//     UINT32      cpuid;              /**< the cpu id when the lock is obtained. It is defined
//                                          only when LOSCFG_KERNEL_SMP_LOCKDEP is defined. */
//     VOID        *owner;             /**< the pointer to the lock owner's task control block.
//                                          It is defined only when LOSCFG_KERNEL_SMP_LOCKDEP is
//                                          defined. */
//     const CHAR  *name;              /**< the lock owner's task name. It is defined only when
//                                          LOSCFG_KERNEL_SMP_LOCKDEP is defined. */
// #endif
// };

// #ifdef LOSCFG_KERNEL_SMP
// /**
//  * @ingroup  los_spinlock
//  * @brief Lock the spinlock.
//  *
//  * @par Description:
//  * This API is used to lock the spinlock. If the spinlock has been obtained by another thread,
//  * the thread will wait cyclically until it can lock the spinlock successfully.
//  *
//  * @attention
//  * <ul>
//  * <li>The spinlock must be initialized before it is used. It should be initialized by #LOS_SpinInit
//  *     or #SPIN_LOCK_INIT.</li>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>A spinlock can not be locked for multiple times in a task. Otherwise, a deadlock occurs.</li>
//  * <li>If the spinlock will be used in both task and interrupt, using #LOS_SpinLockSave instead of
//  *     this API.</li>
//  * <li>On Non-SMP (UP) mode, this function has no effect.</li>
//  * </ul>
//  *
//  * @param  lock [IN] Type #SPIN_LOCK_S The pointer to spinlock.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_SpinTrylock | LOS_SpinLockSave | LOS_SpinUnlock | SPIN_LOCK_INIT | LOS_SpinInit
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinLock(lock: *spinlock.SPIN_LOCK_S) void {
    //     /*
    //      * disable the scheduler, so it won't do schedule until
    //      * scheduler is reenabled. The LOS_TaskUnlock should not
    //      * be directly called along this critic area.
    //      */
    task.LOS_TaskLock();

    LOCKDEP_CHECK_IN(lock);
    spinlock.ArchSpinLock(&lock.rawLock);
    LOCKDEP_RECORD(lock);
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Trying to lock the spinlock.
//  *
//  * @par Description:
//  * This API is used to try to lock the spinlock. If the spinlock has been obtained by another thread,
//  * this API will not waiting for the lock's owner to release the spinlock and return the failure directly.
//  *
//  * @attention
//  * <ul>
//  * <li>The spinlock must be initialized before it is used. It should be initialized by #LOS_SpinInit
//  *     or #SPIN_LOCK_INIT.</li>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>A spinlock can not be locked for multiple times in a task. Otherwise, a deadlock occurs.</li>
//  * <li>On Non-SMP (UP) mode, this function has no effect.</li>
//  * </ul>
//  *
//  * @param  lock [IN] Type #SPIN_LOCK_S The pointer to spinlock.
//  *
//  * @retval #LOS_OK   Got the spinlock.
//  * @retval #LOS_NOK  Failed to get the spinlock.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_SpinLock | LOS_SpinLockSave | LOS_SpinUnlock | SPIN_LOCK_INIT | LOS_SpinInit
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinTrylock(lock: *spinlock.SPIN_LOCK_S) !void {
    task.LOS_TaskLock();

    LOCKDEP_CHECK_IN(lock);
    try spinlock.ArchSpinTrylock(&lock.rawLock);
    LOCKDEP_RECORD(lock);
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Unlock the spinlock.
//  *
//  * @par Description:
//  * This API is used to unlock the spin lock.
//  *
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>On Non-SMP (UP) mode, this function has no effect. </li>
//  * </ul>
//  *
//  * @param  lock [IN] Type #SPIN_LOCK_S The pointer to spinlock.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_SpinLock | LOS_SpinTrylock | LOS_SpinLockSave | LOS_SpinUnlockRestore
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinUnlock(lock: *spinlock.SPIN_LOCK_S) !void {
    LOCKDEP_CHECK_OUT(lock);
    try spinlock.ArchSpinUnlock(&lock.rawLock);

    // restore the scheduler flag */
    try task.LOS_TaskUnlock();
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Lock the spinlock and disable all interrupts.
//  *
//  * @par Description:
//  * This API is used to lock the spinlock and disable all interrupts before locking. After
//  * the interrupts are disabled, this API executes exactly the same as #LOS_SpinLock.
//  * @attention
//  * <ul>
//  * <li>The spinlock must be initialized before it is used. It should be initialized by
//  *     #LOS_SpinInit or #SPIN_LOCK_INIT.</li>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>A spinlock can not be locked for multiple times in a task. Otherwise, a deadlock
// *      occurs.</li>
//  * <li>On Non-SMP (UP) mode, this function only disables all interrupts.</li>
//  * </ul>
//  *
//  * @param  lock     [IN]    Type #SPIN_LOCK_S The pointer to spinlock.
//  * @param  intSave  [OUT]   Type #UINT32 The pointer is used to save the interrupt flag
//  *                                       before all interrupts are disabled. It will be
//  *                                       used by #LOS_SpinUnlockRestore.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_SpinLock | LOS_SpinTrylock | LOS_SpinUnlockRestore
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinLockSave(lock: *spinlock.SPIN_LOCK_S, intSave: *t.UINT32) void {
    intSave.* = hwi.LOS_IntLock();
    LOS_SpinLock(lock);
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Unlock the spinlock and restore the interrupt flag.
//  *
//  * @par Description:
//  * This API is used to unlock the spinlock and restore the interrupts by restoring the interrupt flag.
//  * This API can be called only after calling #LOS_SpinLockSave, and the input parameter value should
//  * be the parameter returned by #LOS_SpinLockSave.
//  *
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>On Non-SMP (UP) mode, this function only restore interrupt flag.</li>
//  * </ul>
//  *
//  * @param  lock     [IN]    Type #SPIN_LOCK_S The pointer to spinlock.
//  * @param  intSave  [IN]    Type #UINT32 The interrupt flag need to be restored.
//  *
//  * @retval None.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @see LOS_SpinUnlock | LOS_SpinLockSave
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinUnlockRestore(lock: *spinlock.SPIN_LOCK_S, intSave: t.UINT32) !void {
    try LOS_SpinUnlock(lock);
    hwi.LOS_IntRestore(intSave);
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Check if holding the spinlock.
//  *
//  * @par Description:
//  * This API is used to check if the spinlock is held or not.
//  *
//  * @attention
//  * <ul>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>On Non-SMP (UP) mode, this function always returns #TRUE.</li>
//  * </ul>
//  *
//  * @param  lock     [IN]    Type #SPIN_LOCK_S The pointer to spinlock.
//  *
//  * @retval #TRUE   The spinlock is held.
//  * @retval #FALSE  The spinlock is not held.
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinHeld(lock: *spinlock.SPIN_LOCK_S) t.BOOL {
    return (lock.rawLock != 0);
}

// /**
//  * @ingroup  los_spinlock
//  * @brief Spinlock dynamic initialization.
//  *
//  * @par Description:
//  * This API is used to initialize a spinlock dynamically.
//  *
//  * @attention
//  * <ul>
//  * <li>The spinlock is advised to protect operation that take a short time. Otherwise, the overall system
//  *     performance may be affected because the thread exits the waiting loop only after the spinlock is
//  *     obtained. For time-consuming operation, the mutex lock can be used instead of spinlock.</li>
//  * <li>The parameter passed in should be a legal pointer.</li>
//  * <li>On Non-SMP (UP) mode, this function has no effect.</li>
//  * </ul>
//  *
//  * @param  lock     [IN/OUT]    Type #SPIN_LOCK_S The pointer to spinlock need to be initialized.
//  *
//  * @retval None.
//  *
//  * @par Dependency:
//  * <ul><li>los_spinlock.h: the header file that contains the API declaration.</li></ul>
//  * @since Huawei LiteOS V200R003C00
//  */
// LITE_OS_SEC_ALW_INLINE STATIC
pub inline fn LOS_SpinInit(lock: *spinlock.SPIN_LOCK_S) void {
    lock.* = lock.init("spinlock");
}
