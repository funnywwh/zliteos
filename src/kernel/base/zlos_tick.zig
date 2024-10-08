const syserr = @import("../zlos_error.zig");
const t = @import("../zlos_typedef.zig");
// LITE_OS_SEC_BSS volatile UINT64 g_tickCount[LOSCFG_KERNEL_CORE_NUM] = {0};
// LITE_OS_SEC_DATA_INIT
pub var g_sysClock: t.UINT32 = 0;
// LITE_OS_SEC_DATA_INIT
pub var g_tickPerSecond: t.UINT32 = 0;
// LITE_OS_SEC_BSS DOUBLE g_cycle2NsScale;

// /* spinlock for task module */
// LITE_OS_SEC_BSS SPIN_LOCK_INIT(g_tickSpin);

// #ifdef LOSCFG_KERNEL_TICKLESS
// STATIC WAKEUPFROMINTHOOK g_tickWakeupHook = NULL;
// #endif

// /*
//  * Description : Tick interruption handler
//  */
// LITE_OS_SEC_TEXT VOID OsTickHandler(VOID)
// {
//     UINT32 intSave;

//     TICK_LOCK(intSave);
//     g_tickCount[ArchCurrCpuid()]++;
//     TICK_UNLOCK(intSave);

// #ifdef LOSCFG_KERNEL_TICKLESS
//     if (g_tickWakeupHook != NULL) {
//         g_tickWakeupHook(LOS_TICK_INT_FLAG);
//     }
// #endif

// #ifdef LOSCFG_BASE_CORE_TIMESLICE
//     OsTimesliceCheck();
// #endif

//     OsTaskScan(); /* task timeout scan */

// #ifdef LOSCFG_BASE_CORE_SWTMR
//     OsSwtmrScan();
// #endif
// }

// LITE_OS_SEC_TEXT_INIT UINT32 OsTickInit(UINT32 systemClock, UINT32 tickPerSecond)
// {
//     if ((systemClock == 0) ||
//         (tickPerSecond == 0) ||
//         (tickPerSecond > systemClock)) {
//         return LOS_ERRNO_TICK_CFG_INVALID;
//     }
//     HalClockInit();

//     return LOS_OK;
// }

extern fn HalClockStart() syserr.SYS_ERROR!void;
// LITE_OS_SEC_TEXT_INIT
pub fn OsTickStart() !void {
    try HalClockStart();
}

// LITE_OS_SEC_TEXT_MINOR UINT64 LOS_TickCountGet(VOID)
// {
//     UINT32 intSave;
//     UINT64 tick;

//     /*
//      * use core0's tick as system's timeline,
//      * the tick needs to be atomic.
//      */
//     TICK_LOCK(intSave);
//     tick = g_tickCount[0];
//     TICK_UNLOCK(intSave);

//     return tick;
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_CyclePerTickGet(VOID)
// {
//     return g_sysClock / KERNEL_TICK_PER_SECOND;
// }

// LITE_OS_SEC_TEXT_MINOR VOID LOS_GetCpuCycle(UINT32 *highCnt, UINT32 *lowCnt)
// {
//     UINT64 cycle;

//     if ((highCnt == NULL) || (lowCnt == NULL)) {
//         return;
//     }
//     cycle = HalClockGetCycles();

//     /* get the high 32 bits */
//     *highCnt = (UINT32)(cycle >> 32);
//     /* get the low 32 bits */
//     *lowCnt = (UINT32)(cycle & 0xFFFFFFFFULL);
// }

// LITE_OS_SEC_TEXT_MINOR UINT64 LOS_CurrNanosec(VOID)
// {
//     UINT64 nanos;

//     nanos = HalClockGetCycles() * (OS_SYS_NS_PER_SECOND / OS_SYS_NS_PER_MS) / (g_sysClock / OS_SYS_NS_PER_MS);
//     return nanos;
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_MS2Tick(UINT32 millisec)
// {
//     UINT64 delaySec;

//     if (millisec == UINT32_MAX) {
//         return UINT32_MAX;
//     }

//     delaySec = (UINT64)millisec * KERNEL_TICK_PER_SECOND;
//     return (UINT32)((delaySec + OS_SYS_MS_PER_SECOND - 1) / OS_SYS_MS_PER_SECOND);
// }

// LITE_OS_SEC_TEXT_MINOR UINT32 LOS_Tick2MS(UINT32 tick)
// {
//     return (UINT32)(((UINT64)tick * OS_SYS_MS_PER_SECOND) / KERNEL_TICK_PER_SECOND);
// }

// LITE_OS_SEC_TEXT_MINOR VOID LOS_Udelay(UINT32 usecs)
// {
//     HalDelayUs(usecs);
// }

// LITE_OS_SEC_TEXT_MINOR VOID LOS_Mdelay(UINT32 msecs)
// {
//     UINT32 delayUs = (UINT32_MAX / OS_SYS_US_PER_MS) * OS_SYS_US_PER_MS;

//     while (msecs > UINT32_MAX / OS_SYS_US_PER_MS) {
//         HalDelayUs(delayUs);
//         msecs -= (UINT32_MAX / OS_SYS_US_PER_MS);
//     }
//     HalDelayUs(msecs * OS_SYS_US_PER_MS);
// }

// #ifdef LOSCFG_KERNEL_TICKLESS
// LITE_OS_SEC_TEXT_MINOR VOID LOS_IntTickWakeupHookReg(WAKEUPFROMINTHOOK hook)
// {
//     g_tickWakeupHook = hook;
// }
// #endif

// #ifdef __cplusplus
// #if __cplusplus
// }
// #endif /* __cplusplus */
// #endif /* __cplusplus */

pub fn SET_SYS_CLOCK(clk: t.UINT32) void {
    g_sysClock = clk;
}
