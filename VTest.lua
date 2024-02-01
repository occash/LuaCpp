local ffi = require 'ffi'

ffi.cdef[[
    typedef void (*VTest_test_ptr)(void *);
    typedef struct
    {
        VTest_test_ptr VTest_test;
    } VTest_vft;
    typedef struct
    {
        VTest_vft *VTest_vftable;
        char __padding[4];
    } VTest;
    const VTest_vft VTest_vftable asm("??_7VTest@@6B@");
    void VTest_VTest(void *) asm("??0VTest@@QEAA@XZ");
    void VTest_call(void *) asm("?call@VTest@@SAXPEAV1@@Z");
]]

local VTest_ffi = ffi.load('LuaCpp.dll') 

_g = 3

local VTest_vftable = ffi.new('VTest_vft')
VTest_vftable.VTest_test = function(self)
    print("Hello");
    
end
local VTest_methods = {
    test = function(self) self.VTest_vftable.VTest_test(self) end,
    call = VTest_ffi.VTest_call
}
local VTest_mt = {
    __new = function(cls)
        local self = ffi.new(cls)
        VTest_ffi.VTest_VTest(self)
        self.VTest_vftable = VTest_vftable
        return self
    end,
    __index = VTest_methods,
    __metatable = VTest_methods
}
local VTest = ffi.metatype('VTest', VTest_mt)

return VTest
