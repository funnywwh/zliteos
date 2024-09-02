const t = @import("../../../../../kernel/zlos_typedef.zig");
const defines = @import("../../../../../kernel/zlos_defines.zig");
pub fn ArchCurrCpuid() t.UINT32 {
    if (defines.LOSCFG_KERNEL_SMP) {
        //TODO:
        return 1;
    } else {
        return 0;
    }
}
