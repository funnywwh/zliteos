const t = @import("./zlos_typedef.zig");
const defines = @import("./zlos_defines.zig");
const lockdep = @import("./zlos_lockdep.zig");
const hwi = @import("./include/zlos_hwi.zig");
const task = @import("../kernel/base/zlos_task.zig");
const syserror = @import("../kernel/zlos_error.zig");
pub extern fn ArchSpinLock(lock: *t.size_t) void;
pub extern fn ArchSpinUnlock(lock: *t.size_t) void;
pub extern fn ArchSpinTrylock(lock: *t.size_t) syserror.SYS_ERROR!t.UINT32;
// #ifdef LOSCFG_KERNEL_SMP_LOCKDEP
pub const SPINLOCK_OWNER_INIT = null;

// #define LOCKDEP_CHECK_IN(lock)  OsLockDepCheckIn(lock)
pub inline fn LOCKDEP_CHECK_IN(lock: SPIN_LOCK_S) void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockDepCheckIn(lock);
    }
}
// #define LOCKDEP_RECORD(lock)    OsLockDepRecord(lock)
pub inline fn LOCKDEP_RECORD(lock: SPIN_LOCK_S) void {
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        lockdep.OsLockDepRecord(lock);
    }
}
// #define LOCKDEP_CHECK_OUT(lock) OsLockDepCheckOut(lock)
pub inline fn LOCKDEP_CHECK_OUT(lock: SPIN_LOCK_S) void {
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

// /**
//  * @ingroup  los_spinlock
//  * Define the structure of spinlock.
//  */
pub const Spinlock = struct {
    //     size_t      rawLock;            /**< raw spinlock */
    rawLock: t.size_t = 0,
    // #ifdef LOSCFG_KERNEL_SMP_LOCKDEP
    //     UINT32      cpuid;              /**< the cpu id when the lock is obtained. It is defined
    //                                          only when LOSCFG_KERNEL_SMP_LOCKDEP is defined. */
    //     VOID        *owner;             /**< the pointer to the lock owner's task control block.
    //                                          It is defined only when LOSCFG_KERNEL_SMP_LOCKDEP is
    //                                          defined. */
    //     const CHAR  *name;              /**< the lock owner's task name. It is defined only when
    //                                          LOSCFG_KERNEL_SMP_LOCKDEP is defined. */
    // #endif
    LOSCFG_KERNEL_SMP_LOCKDEP: ?struct {
        cpuid: t.UINT32 = @as(u32, @bitCast(@as(i32, -1))),
        owner: ?*t.VOID = null,
        name: ?[]const u8 = null,
    } = if (defines.LOSCFG_KERNEL_SMP_LOCKDEP)
        .{}
    else
        null,

    pub inline fn init(lockName: []const u8) Spinlock {
        if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
            return .{
                .rawLock = 0,
                .LOSCFG_KERNEL_SMP_LOCKDEP = .{
                    .owner = SPINLOCK_OWNER_INIT,
                    .name = lockName,
                },
            };
        } else {
            return .{
                .rawLock = 0,
            };
        }
    }
};
pub const SPIN_LOCK_S = Spinlock;
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
pub inline fn LOS_SpinLock(lock: *SPIN_LOCK_S) void {
    // /*
    //  * disable the scheduler, so it won't do schedule until
    //  * scheduler is reenabled. The LOS_TaskUnlock should not
    //  * be directly called along this critic area.
    //  */
    task.LOS_TaskLock();

    LOCKDEP_CHECK_IN(lock);
    ArchSpinLock(&lock.rawLock);
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
// LITE_OS_SEC_ALW_INLINE STATIC INLINE INT32 LOS_SpinTrylock(SPIN_LOCK_S *lock)
// {
//     LOS_TaskLock();

//     LOCKDEP_CHECK_IN(lock);
//     INT32 ret = ArchSpinTrylock(&lock.rawLock);
//     if (ret == LOS_OK) {
//         LOCKDEP_RECORD(lock);
//     }

//     return ret;
// }

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
// LITE_OS_SEC_ALW_INLINE STATIC INLINE VOID LOS_SpinUnlock(SPIN_LOCK_S *lock)
// {
//     LOCKDEP_CHECK_OUT(lock);
//     ArchSpinUnlock(&lock.rawLock);

//     /* restore the scheduler flag */
//     LOS_TaskUnlock();
// }

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
pub inline fn LOS_SpinLockSave(lock: *SPIN_LOCK_S, intSave: *t.UINT32) void {
    intSave.* = hwi.LOS_IntLock();
    hwi.LOS_SpinLock(lock);
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
pub inline fn LOS_SpinUnlockRestore(lock: *SPIN_LOCK_S, intSave: t.UINT32) void {
    Spinlock.LOS_SpinUnlock(lock);
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
pub inline fn LOS_SpinHeld(lock: *SPIN_LOCK_S) t.BOOL {
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
// LITE_OS_SEC_ALW_INLINE STATIC INLINE
pub inline fn LOS_SpinInit(lock: *SPIN_LOCK_S) void {
    lock.rawLock = 0;
    if (defines.LOSCFG_KERNEL_SMP_LOCKDEP) {
        if (lock.LOSCFG_KERNEL_SMP_LOCKDEP) |*v| {
            v.cpuid = -1;
            v.owner = SPINLOCK_OWNER_INIT;
            v.name = "spinlock";
        }
    }
}
