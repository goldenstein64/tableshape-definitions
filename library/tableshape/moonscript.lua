---@meta
---contains validation types specific to MoonScript

local moonscript = {}

---matches a value that is a MoonScript class
---@class tableshape.moonscript.ClassType : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that is an instance of a MoonScript class
---@class tableshape.moonscript.InstanceType : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that is an instance of the given MoonScript class
---@class tableshape.moonscript.InstanceOf : tableshape.BaseType
---@field class_identifier string | table -- the class the value should be an instance of
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that is a subclass of the given MoonScript class
---@class tableshape.moonscript.SubclassOf : tableshape.BaseType
---@field class_identifier string | table -- the class the value should be a subclass of
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@type tableshape.moonscript.ClassType
moonscript.class_type = {}

---@type tableshape.moonscript.InstanceType
moonscript.instance_type = {}

---matches a value that is an instance of the given MoonScript class
---@param class_identifier string | table -- can be the class' name or a class object
---@return tableshape.moonscript.InstanceOf
function moonscript.instance_of(class_identifier) end

---matches a value that is a subclass of the given MoonScript class
---@param class_identifier string | table -- can be the class' name or a class object
---@return tableshape.moonscript.SubclassOf
function moonscript.subclass_of(class_identifier) end

return moonscript
