const defines = @import("./zlos_defines.zig");
pub fn OS_STRING(x: []const u8) []const u8 {
    return x;
}
pub const X_STRING = OS_STRING;

pub const UINT8 = u8;
pub const UINT16 = u16;
pub const UINT32 = u32;
pub const INT8 = i8;
pub const INT16 = i16;
pub const INT32 = i32;
pub const FLOAT = f32;
pub const DOUBLE = f64;
pub const CHAR = i8;

pub const UINT64 = u64;
pub const INT64 = i64;
pub const UINTPTR = usize;
pub const INTPTR = isize;
pub const ssize_t = isize;
pub const size_t = usize;

pub const BOOL = bool;
pub const AARCHPTR = UINTPTR;
// typedef volatile INT32     Atomic;
pub const Atomic = INT32;
// typedef volatile INT64     Atomic64;
pub const Atomic64 = INT64;

pub const VOID = void;
// #define STATIC             static

pub const TRUE = true;
pub const FALSE = false;

pub const NULL = null;

pub const YES = true;
pub const NO = false;

// #define OS_NULL_BYTE       ((UINT8)0xFF)
pub const OS_NULL_BYTE = @as(UINT8, 0xFFFF);
// #define OS_NULL_SHORT      ((UINT16)0xFFFF)
pub const OS_NULL_SHORT = @as(UINT16, 0xFFFFFFFF);
// #define OS_NULL_INT        ((UINT32)0xFFFFFFFF)
pub const OS_NULL_INT = @as(UINT32, 0xFFFFFFFF);

pub const LOS_OK = 0;
pub const LOS_NOK = 1;
pub const LOS_USED = 1;
pub const LOS_UNUSED = 0;
pub const OS_FAIL = 1;
pub const OS_ERROR = @as(UINT32, -1);
pub const OS_INVALID = @as(UINT32, -1);

// #ifndef LOS_LABEL_DEFN
// #define LOS_LABEL_DEFN(label) label
// #endif
pub inline fn LOS_LABEL_DEFN(label: []const u8) []const u8 {
    return label;
}

pub const LOSARC_ALIGNMENT = 0;

pub const LOSARC_P2ALIGNMENT = if (defines.LOSCFG_AARCH64) 3 else 2;

// /* Give a type or object explicit minimum alignment */
// #if !defined(LOSBLD_ATTRIB_ALIGN)
// #define LOSBLD_ATTRIB_ALIGN(__align__) __attribute__((aligned(__align__)))
// #endif

// /* Assign a defined variable to a specific section */
// #if !defined(LOSBLD_ATTRIB_SECTION)
// #define LOSBLD_ATTRIB_SECTION(__sect__) __attribute__((section(__sect__)))
// #endif

// /*
//  * Tell the compiler not to throw away a variable or function. Only known
//  * available on 3.3.2 or above. Old version's didn't throw them away,
//  * but using the unused attribute should stop warnings.
//  */
// #define LOSBLD_ATTRIB_USED __attribute__((used))
