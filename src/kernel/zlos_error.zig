const t = @import("./zlos_typedef.zig");
pub const SYS_ERROR = error{};

// /**
//  * @ingroup los_errno
//  * OS error code flag. It is a 24-bit unsigned integer. Its value is 0x000000U.
//  */
// #define LOS_ERRNO_OS_ID (0x00U << 16)
pub const LOS_ERRNO_OS_ID: t.UINT32 = (0x00 << 16);
// /**
//  * @ingroup los_errno
//  * Define the error level as informative. It is a 32-bit unsigned integer. Its value is 0x00000000U.
//  */
// #define LOS_ERRTYPE_NORMAL (0x00U << 24)
pub const LOS_ERRTYPE_NORMAL: t.UINT32 = (0x00 << 24);

// /**
//  * @ingroup los_errno
//  * Define the error level as warning. It is a 32-bit unsigned integer. Its value is 0x01000000U.
//  */
// #define LOS_ERRTYPE_WARN (0x01U << 24)
pub const LOS_ERRTYPE_WARN: t.UINT32 = (0x01 << 24);
// /**
//  * @ingroup los_errno
//  * Define the error level as critical. It is a 32-bit unsigned integer. Its value is 0x02000000U.
//  */
// #define LOS_ERRTYPE_ERROR (0x02U << 24)
pub const LOS_ERRTYPE_ERROR: t.UINT32 = (0x02 << 24);
// /**
//  * @ingroup los_errno
//  * Define the error level as fatal. It is a 32-bit unsigned integer. Its value is 0x03000000U.
//  */
// #define LOS_ERRTYPE_FATAL (0x03U << 24)
pub const LOS_ERRTYPE_FATAL: t.UINT32 = (0x03 << 24);
// /**
//  * @ingroup los_errno
//  * Define fatal OS errors. It is a 32-bit unsigned integer error code.
//  * <ul>
//  * <li>24-31 bits indicate the error level, here is #LOS_ERRTYPE_FATAL.</li>
//  * <li>16-23 bits indicate the os error code flag, here is #LOS_ERRNO_OS_ID.</li>
//  * <li>8-15 bits indicate the module which the error code belongs to. It is specified by MID.</li>
//  * <li>0-7 bits indicate the error code number. It is specified by ERRNO.</li>
//  * </ul>
//  */
// #define LOS_ERRNO_OS_FATAL(MID, ERRNO) \
//     (LOS_ERRTYPE_FATAL | LOS_ERRNO_OS_ID | ((UINT32)(MID) << 8) | ((UINT32)(ERRNO)))

pub inline fn LOS_ERRNO_OS_FATAL(MID: t.UINT32, ERRNO: t.UINT32) t.UINT32 {
    return (LOS_ERRTYPE_FATAL | LOS_ERRNO_OS_ID | ((MID) << 8) | ((ERRNO)));
}
// /**
//  * @ingroup los_errno
//  * Define critical OS errors. It is a 32-bit unsigned integer error code.
//  * <ul>
//  * <li>24-31 bits indicate the error level, here is #LOS_ERRTYPE_ERROR.</li>
//  * <li>16-23 bits indicate the os error code flag, here is #LOS_ERRNO_OS_ID.</li>
//  * <li>8-15 bits indicate the module which the error code belongs to. It is specified by MID.</li>
//  * <li>0-7 bits indicate the error code number. It is specified by ERRNO.</li>
//  * </ul>
//  */
// #define LOS_ERRNO_OS_ERROR(MID, ERRNO) \
//     (LOS_ERRTYPE_ERROR | LOS_ERRNO_OS_ID | ((UINT32)(MID) << 8) | ((UINT32)(ERRNO)))
pub inline fn LOS_ERRNO_OS_ERROR(MID: t.UINT32, ERRNO: t.UINT32) t.UINT32 {
    return (LOS_ERRTYPE_ERROR | LOS_ERRNO_OS_ID | ((MID) << 8) | ((ERRNO)));
}
// /**
//  * @ingroup los_errno
//  * Define warning OS errors. It is a 32-bit unsigned integer error code.
//  * <ul>
//  * <li>24-31 bits indicate the error level, here is #LOS_ERRTYPE_WARN.</li>
//  * <li>16-23 bits indicate the os error code flag, here is #LOS_ERRNO_OS_ID.</li>
//  * <li>8-15 bits indicate the module which the error code belongs to. It is specified by MID.</li>
//  * <li>0-7 bits indicate the error code number. It is specified by ERRNO.</li>
//  * </ul>
//  */
// #define LOS_ERRNO_OS_WARN(MID, ERRNO) \
//     (LOS_ERRTYPE_WARN | LOS_ERRNO_OS_ID | ((UINT32)(MID) << 8) | ((UINT32)(ERRNO)))
pub inline fn LOS_ERRNO_OS_WARN(MID: t.UINT32, ERRNO: t.UINT32) t.UINT32 {
    return (LOS_ERRTYPE_WARN | LOS_ERRNO_OS_ID | ((MID) << 8) | ((ERRNO)));
}
// /**
//  * @ingroup los_errno
//  * Define informative OS errors. It is a 32-bit unsigned integer error code.
//  * <ul>
//  * <li>24-31 bits indicate the error level, here is #LOS_ERRTYPE_NORMAL.</li>
//  * <li>16-23 bits indicate the os error code flag, here is #LOS_ERRNO_OS_ID.</li>
//  * <li>8-15 bits indicate the module which the error code belongs to. It is specified by MID.</li>
//  * <li>0-7 bits indicate the error code number. It is specified by ERRNO.</li>
//  * </ul>
//  */
// #define LOS_ERRNO_OS_NORMAL(MID, ERRNO) \
//     (LOS_ERRTYPE_NORMAL | LOS_ERRNO_OS_ID | ((UINT32)(MID) << 8) | ((UINT32)(ERRNO)))
pub inline fn LOS_ERRNO_OS_NORMAL(MID: t.UINT32, ERRNO: t.UINT32) t.UINT32 {
    return (LOS_ERRTYPE_NORMAL | LOS_ERRNO_OS_ID | ((MID) << 8) | ((ERRNO)));
}

// /**
//  * @ingroup los_errno
//  * Define the ID of each module in kernel. The ID is used in error code.
//  */
pub const LOS_MOUDLE_ID = struct {
    pub const LOS_MOD_SYS = 0x0; // System ID. Its value is 0x0. */
    pub const LOS_MOD_MEM = 0x1; // Dynamic memory module ID. Its value is 0x1. */
    pub const LOS_MOD_TSK = 0x2; // Task module ID. Its value is 0x2. */
    pub const LOS_MOD_SWTMR = 0x3; // Software timer module ID. Its value is 0x3. */
    pub const LOS_MOD_TICK = 0x4; // Tick module ID. Its value is 0x4. */
    pub const LOS_MOD_MSG = 0x5; // Message module ID. Its value is 0x5. */
    pub const LOS_MOD_QUE = 0x6; // Queue module ID. Its value is 0x6. */
    pub const LOS_MOD_SEM = 0x7; // Semaphore module ID. Its value is 0x7. */
    pub const LOS_MOD_MBOX = 0x8; // Static memory module ID. Its value is 0x8. */
    pub const LOS_MOD_HWI = 0x9; // Hardware interrupt module ID. Its value is 0x9. */
    pub const LOS_MOD_HWWDG = 0xa; // Hardware watchdog module ID. Its value is 0xa. */
    pub const LOS_MOD_CACHE = 0xb; // Cache module ID. Its value is 0xb. */
    pub const LOS_MOD_HWTMR = 0xc; // Hardware timer module ID. Its value is 0xc. */
    pub const LOS_MOD_MMU = 0xd; // MMU module ID. Its value is 0xd. */
    pub const LOS_MOD_LOG = 0xe; // Log module ID. Its value is 0xe. */
    pub const LOS_MOD_ERR = 0xf; // Error handling module ID. Its value is 0xf. */
    pub const LOS_MOD_EXC = 0x10; // Exception handling module ID. Its value is 0x10. */
    pub const LOS_MOD_CSTK = 0x11; // This module ID is reserved. Its value is 0x11. */
    pub const LOS_MOD_MPU = 0x12; // MPU module ID. Its value is 0x12. */
    pub const LOS_MOD_NMHWI = 0x13; // NMI module ID. It is reserved. Its value is 0x13. */
    pub const LOS_MOD_TRACE = 0x14; // Trace module ID. Its value is 0x14. */
    pub const LOS_MOD_KNLSTAT = 0x15; // This module ID is reserved. Its value is 0x15. */
    pub const LOS_MOD_EVTTIME = 0x16; // This module ID is reserved. Its value is 0x16. */
    pub const LOS_MOD_THRDCPUP = 0x17; // This module ID is reserved. Its value is 0x17. */
    pub const LOS_MOD_IPC = 0x18; // This module ID is reserved. Its value is 0x18. */
    pub const LOS_MOD_STKMON = 0x19; // This module ID is reserved. Its value is 0x19. */
    pub const LOS_MOD_TIMER = 0x1a; // This module ID is reserved. Its value is 0x1a. */
    pub const LOS_MOD_RESLEAKMON = 0x1b; // This module ID is reserved. Its value is 0x1b. */
    pub const LOS_MOD_EVENT = 0x1c; // event module ID. Its value is 0x1c. */
    pub const LOS_MOD_MUX = 0x1d; // mutex module ID. Its value is 0x1d. */
    pub const LOS_MOD_CPUP = 0x1e; // CPU usage module ID. Its value is 0x1e. */
    pub const LOS_MOD_FPB = 0x1f; // FPB module ID. Its value is 0x1f. */
    pub const LOS_MOD_PERF = 0x20; // Perf module ID. Its value is 0x20. */
    pub const LOS_MOD_SHELL = 0x31; // shell module ID. Its value is 0x31. */
    pub const LOS_MOD_DRIVER = 0x41; // driver module ID. Its value is 0x41. */
    pub const LOS_MOD_BUTT = 0x42; // It is end flag of this enumeration. */
};
