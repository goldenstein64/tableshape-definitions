---@meta
---installs luassert assertion and formatter for tableshape types

---@class luassert
local luassert = require("luassert")

---Asserts that the value matches the given `tableshape` type
---@param input any
---@param expected tableshape.BaseType
function luassert.shape(input, expected) end

return true
