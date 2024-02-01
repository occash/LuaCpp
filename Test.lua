local ffi = require 'ffi'

ffi.cdef[[
    typedef struct
    {
        char __padding[4];
    } Test;
    void Test_new(void *) asm("??0Test@@QEAA@XZ");
    void Test_delete(void *) asm("??1Test@@QEAA@XZ");
    int Test_add(int, int) asm("?add@Test@@SAHHH@Z");
    void Test_test(const void *) asm("?test@Test@@QEBAXXZ");
    int Test_value(const void *) asm("?value@Test@@QEBAHXZ");
    void Test_setValue(void *, int) asm("?setValue@Test@@QEAAXH@Z");
]]

local Test_ffi = ffi.load('LuaCpp.dll') 

local Test_methods = {
    add = Test_ffi.Test_add,
    test = Test_ffi.Test_test,
    value = Test_ffi.Test_value,
    setValue = Test_ffi.Test_setValue
}
local Test_getters = {}
local Test_setters = {
    value = Test_ffi.Test_setValue
}
local Test_mt = {
    __new = function(cls)
        local self = ffi.new(cls)
        Test_ffi.Test_new(self);
        return self
    end,
    __gc = Test_ffi.Test_delete,
    __index = Test_methods,
    __newindex = function(self, key, value)
        Test_setters[key](self, value)
    end
}
local Test = ffi.metatype('Test', Test_mt)

return Test
