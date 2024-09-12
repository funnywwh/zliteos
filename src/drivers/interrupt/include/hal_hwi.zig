const std = @import("std");
const t = @import("../../../kernel/zlos_typedef.zig");
const task = @import("../../../kernel/base/zlos_task.zig");
const target = @import("../../../targets/target.zig");
const cpu = target.cpu;
const defines = @import("../../../kernel/zlos_defines.zig");
const _error = @import("../../../kernel/zlos_error.zig");
const config = @import("../../../kernel/zlos_config.zig");

// #if defined(LOSCFG_CORTEX_M_NVIC)
// #define OS_USER_HWI_MIN                 15
// #else
// #define OS_USER_HWI_MIN                 0
// #endif
pub const OS_USER_HWI_MIN = if (defines.LOSCFG_CORTEX_M_NVIC) 15 else 0;
// #if defined(LOSCFG_PLATFORM_HIFIVE1_REV1_B01)
// #define OS_USER_HWI_MAX                 (OS_HWI_MAX_NUM - 1)
// #else
// #define OS_USER_HWI_MAX                 (LOSCFG_PLATFORM_HWI_LIMIT - 1)
// #endif
pub const OS_USER_HWI_MAX = if (defines.LOSCFG_PLATFORM_HIFIVE1_REV1_B01) (target.interrupt.OS_HWI_MAX_NUM - 1) else (config.LOSCFG_PLATFORM_HWI_LIMIT - 1);

// #define HWI_NUM_VALID(num)              (((num) >= OS_USER_HWI_MIN) && ((num) <= OS_USER_HWI_MAX))
pub inline fn HWI_NUM_VALID(num: t.UINT32) bool {
    return (((num) >= OS_USER_HWI_MIN) and ((num) <= OS_USER_HWI_MAX));
}
// extern VOID ArchIrqInit(VOID);
pub extern fn ArchIrqInit() void;
// extern VOID HalIrqInitPercpu(VOID);
pub extern fn HalIrqInitPercpu() void;
// extern UINT32 ArchIrqMask(UINT32 vector);
pub extern fn ArchIrqMask(vector: t.UINT32) t.UINT32;
// extern UINT32 ArchIrqUnmask(UINT32 vector);
pub extern fn ArchIrqUnmask(vector: t.UINT32) t.UINT32;
// extern UINT32 ArchIrqPending(UINT32 vector);
pub extern fn ArchIrqPending(vector: t.UINT32) t.UINT32;
// extern UINT32 ArchIrqClear(UINT32 vector);
pub extern fn ArchIrqClear(vector: t.UINT32) t.UINT32;
// extern CHAR *HalIrqVersion(VOID);
pub extern fn HalIrqVersion() []const u8;
// extern UINT32 HalCurIrqGet(VOID);
pub extern fn HalCurIrqGet() t.UINT32;
// extern UINT32 HalIrqSetPrio(UINT32 vector, UINT8 priority);
pub extern fn HalIrqSetPrio(vector: t.UINT32, priority: t.UINT8) t.UINT32;
// #ifdef LOSCFG_KERNEL_SMP
// extern UINT32 HalIrqSendIpi(UINT32 target, UINT32 ipi);
pub extern fn HalIrqSendIpi(target: t.UINT32, ipi: t.UINT32) t.UINT32;
// extern UINT32 HalIrqSetAffinity(UINT32 vector, UINT32 cpuMask);
pub extern fn HalIrqSetAffinity(vector: t.UINT32, cpuMask: t.UINT32) t.UINT32;
// #endif
