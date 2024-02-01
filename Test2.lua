local ffi = require 'ffi'
local Test = require 'Test'

ffi.cdef[[
    typedef struct
    {
        char __padding0[4];
        double health;
        char __padding1[8];
    } Test2;
    void Test2_new(void *) asm("??0Test2@@QEAA@XZ");
    void Test2_delete(void *) asm("??1Test2@@QEAA@XZ");
    bool Test2_check(const void *, const Test *) asm("?check@Test2@@QEBA_NAEBVTest@@@Z");
]]

local Test2_ffi = ffi.load('LuaCpp.dll') 

local Test2_methods = {
    add = Test2_ffi.Test_add,
    test = Test2_ffi.Test_test,
    value = Test2_ffi.Test_value,
    setValue = Test2_ffi.Test_setValue,
    check = Test2_ffi.Test2_check
}
local Test2_setters = {
    value = Test2_ffi.Test_setValue
}
local Test2_mt = {
    __new = function(cls)
        local self = ffi.new(cls)
        Test2_ffi.Test2_new(self);
        return self
    end,
    __gc = Test2_ffi.Test2_delete,
    __index = Test2_methods,
    __newindex = function(self, key, value)
        Test2_setters[key](self, value)
    end
}
local Test2 = ffi.metatype('Test2', Test2_mt)

return Test2
