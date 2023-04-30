---@meta
---the core validation feature set of this library

---the core validation feature set of this library
---@class tableshape
local tableshape = {
	---represents a type that failed to transform its value
	---@type tableshape.FailedTransform
	FailedTransform = {},

	VERSION = "", ---@type string
}

---represents a type that failed to transform its value
---@class tableshape.FailedTransform
tableshape.FailedTransform = {}

---@class tableshape.CanCheckShape
---@field check_value fun(self: tableshape.CanCheckShape, val: any): boolean

---determines whether `val` matches `shape`. Equivalent to `shape(val)` for
---`tableshape` types.
---@param val any -- any value
---@param shape tableshape.CanCheckShape -- typically a `tableshape` type, but can be any value with a `check_value` method
---@return true | tableshape.State | nil success, string? err -- `true` if `value` matches `shape`, `false, error` otherwise
function tableshape.check_shape(val, shape) end

---determines whether `value` is a type created with `tableshape`
---@param val any
---@return boolean
function tableshape.is_type(val) end

---represents any saved values or tags from the transformation process
---@alias tableshape.State table

---This is the base class that all types must inherit from.
---Implementing types must provide the following methods:
---
---* `_transform: (self, value, state) -> (value, state)`
---  * Transform the value and state. No mutation must happen, return copies of
---    values if they change. On failure return `FailedTransform,
---    "error message"`. Ensure that even on error no mutations happen to
---    `state` or `value`.
---
---* `_describe: (self) -> string`
---  * Return a string describing what the type should expect to get. This is
---    used to generate error messages for complex types that bail out of value
---    specific error messages due to complexity.
---
---This is the base class that all types must inherit from.
---Implementing types must provide the following methods:
---
---* `_transform: (self, value, state) -> (value, state)`
---  * Transform the value and state. No mutation must happen, return copies of
---    values if they change. On failure return `FailedTransform,
---    "error message"`. Ensure that even on error no mutations happen to
---    `state` or `value`.
---
---* `_describe: (self) -> string`
---  * Return a string describing what the type should expect to get. This is
---    used to generate error messages for complex types that bail out of value
---    specific error messages due to complexity.
---
---`BaseType` supplies the following metamethods:
---
---* `/` - transform the value with a function of type `(value) -> value`
---* `%` - transform the value with a function of type `(value, state) -> value`
---* `*` - intersect this type with another type
---* `+` - union this type with another type
---* unary `-` - turn this type into its complement
---
---@class tableshape.BaseType
---Transform the value and state. No mutation must happen, return copies of
---values if they change. On failure return `FailedTransform, "error message"`.
---Ensure that even on error no mutations happen to `state` or `value`.
---@field _transform fun(self: tableshape.BaseType, val: any, state: tableshape.State): (any, tableshape.State)
---Return a string describing what the type should expect to get. This is used
---to generate error messages for complex types that bail out of value specific
---error messages due to complexity.
---@field _describe fun(self: tableshape.BaseType): string
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local BaseType = {}

---This is the base class that all types must inherit from.
---Implementing types must provide the following methods:
---
---* `_transform: (self, value, state) -> (value, state)`
---  * Transform the value and state. No mutation must happen, return copies of
---    values if they change. On failure return `FailedTransform,
---    "error message"`. Ensure that even on error no mutations happen to
---    `state` or `value`.
---
---* `_describe: (self) -> string`
---  * Return a string describing what the type should expect to get. This is
---    used to generate error messages for complex types that bail out of value
---    specific error messages due to complexity.
---
---`BaseType` supplies the following metamethods:
---
---* `/` - transform the value with a function of type `(value) -> value`
---* `%` - transform the value with a function of type `(value, state) -> value`
---* `*` - intersect this type with another type
---* `+` - union this type with another type
---* unary `-` - turn this type into its complement
---@class tableshape.BaseType.Class
---@overload fun(opts?: any): tableshape.BaseType
local BaseTypeClass = {}

tableshape.BaseType = BaseTypeClass

---detects if `val` is an *instance* of base type
function BaseTypeClass:is_base_type(val) end

---test if `value` matches type, returns `true` on success. If `state` is used,
---then the `state` object is returned instead
---@param val any
---@param state tableshape.State?
---@return tableshape.State | true | nil state_or_value
---@return string? err
function BaseType:check_value(val, state) end

---tests if `value` matches type, returns `value` on success. If `state` is
---used, then the `state` object is returned as a second value
---@param val any
---@param state tableshape.State?
---@return any | nil val
---@return tableshape.State | string | nil state_or_err
function BaseType:transform(val, state) end

BaseType.repair = BaseType.transform

-- TODO: figure out what BaseType:on_repair is supposed to do

---returns a function that does something complicated?
function BaseType:on_repair(fn) end

---gives this type the ability to be `nil`
---@return tableshape.OptionalType
function BaseType:is_optional() end

-- TODO: figure out what the table handler in `BaseType:describe` is

---@alias tableshape.DescribeTable table

---give this type the following description if it fails
---@param description string | tableshape.DescribeTable
---@return tableshape.DescribeNode
function BaseType:describe(description) end

-- TODO: figure out what BaseType:tag is

---creates a new or cloned state and updates it with the `name` tag, which
---holds the transformation of its value from validation. If `name` is
---postfixed with `[]`, the tag will hold an array of all the values it was
---transformed through.
---@return tableshape.TaggedType
function BaseType:tag(name) end

---the result of transforming another type with a type function using the `/`
---or `%` operator
---
---Its constructor takes a type `node` and a type function `t_fn`.
---
---If `t_fn` is a function, it will get called with `node`'s value after
---transformation, possibly with `state` as its second argument if transformed
---with `%`. if `t_fn` is not a function `t_fn` gets returned in place of the
---transformed value.
---@class tableshape.TransformNode : tableshape.BaseType
---@field with_state true? -- whether the `state` is passed to the type function
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---the result of intersecting a type with another type using the `*` operator
---
---Its constructor takes a tuple of types. The value gets transformed by each
---type in sequence, and the result is returned.
---@class tableshape.SequenceNode : tableshape.BaseType
---the list of types the value gets transformed over
---@field sequence tableshape.BaseType[]
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---the result of unioning a type with another type using the `+` operator
---
---Its constructor takes a tuple of types. The value gets transformed by each
---type in the list, returning the result of the first type that succeeds.
---@class tableshape.FirstOfNode : tableshape.BaseType
---the list of types the value is tested against
---@field options tableshape.BaseType[]
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---alters the description of a node in its error message
---@class tableshape.DescribeNode : tableshape.BaseType
---@field node tableshape.BaseType
---@field err_handler fun(): string
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@alias tableshape.AnnotateNode.FormatError fun(self: tableshape.AnnotateNode, val: any, err: string): string

---the `opts` argument passed into the `AnnotateNode` constructor
---@class tableshape.AnnotateNode.Options
---@field format_error tableshape.AnnotateNode.FormatError

---annotates failures with the value that failed
---@class tableshape.AnnotateNode : tableshape.BaseType
---@field base_type tableshape.BaseType
---@field format_error tableshape.AnnotateNode.FormatError
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---the `opts` argument passed into the `TaggedType` constructor
---@class tableshape.TaggedType.Options
---@field tag any -- must be a truthy value

---creates a new or cloned `state` and updates it with the tag given in its
---`opts` table, stored under `tag_name`
---
---If `opts.tag` is a `function`, it gets called with a cloned state and a
---value.
---
---If `opts.tag` is any other truthy value, it's used as a key that stores the
---`value` in the new state. If `tag_array` is true, the `value` is pushed into
---an array at that key, creating one if it doesn't exist.
---@class tableshape.TaggedType : tableshape.BaseType
---@field base_type tableshape.BaseType -- the type getting tagged
---@field tag_name any -- the value extracted from `opts.tag`
---@field tag_array true?
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local TaggedType = {}

---creates a new or cloned `state` and updates it with the `tag_name` property
---@see tableshape.TaggedType
---@param state tableshape.State
---@param val any
function TaggedType:update_state(state, val) end

---creates a new or cloned `state` and updates it with the `tag_name` property
---the second argument is a scope generated by the `tableshape.TagScopeType`.
---@see tableshape.TaggedType
---@see tableshape.TagScopeType
---@param state tableshape.State
---@param scope any
---@param val any
function TaggedType:update_state(state, scope, val) end

---creates a new scoped state for the type this wraps. The scoped state
---is `nil` by default and can be altered by deriving from this class and
---overriding the `create_scope_state` method.
---
---> Since this is a MoonScript class, it should be derived in MoonScript or
---> using a library like [muun](https://github.com/megagrump/muun).
---
---If `opts.tag` is a `function`, it gets called with the cloned state, the
---scoped state, and the value. Otherwise, the scoped state is what gets stored
---in the tag value.
---@class tableshape.TagScopeType : tableshape.TaggedType
---@field tag_name? any
---@field tag_type? type
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local TagScopeType = {}

---generates a new scoped state from `state` and returns it. It returns `nil`
---by default and can be altered by deriving from this class and overriding
---this method.
---
---> Since this is a MoonScript class, it should be derived in MoonScript or
---> using a library like [muun](https://github.com/megagrump/muun).
---@param state tableshape.State
---@return any scope
function TagScopeType:create_scope_state(state) end

---matches `nil` or its enclosing type
---@class tableshape.OptionalType : tableshape.BaseType
---@field base_type tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches anything
---@class tableshape.AnyType : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.Type.Options
---@field length? number | tableshape.BaseType

---@class tableshape.Type : tableshape.BaseType
---@field length_type tableshape.BaseType
---@field t type
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local Type = {}

---matches a value with this type and the given length, which can be a range
---@param left number
---@param right number
---@return tableshape.Range
---@overload fun(self: self, left: string, right: string): tableshape.Range
function Type:length(left, right) end

---matches an array of anything
---@class tableshape.ArrayType : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches any of the given values or types
---@class tableshape.OneOf : tableshape.BaseType
---@field options any[]
---If `options` is an array of numbers and/or strings, `options_hash` is a set
---generated to speed up the typechecking process.
---@field options_hash { [any]: true? }?
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches all of the given types
---@class tableshape.AllOf : tableshape.BaseType
---@field types tableshape.BaseType[] -- all the types to check against
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.ArrayOf.Options
---@field keep_nils? boolean
---@field length? number | tableshape.BaseType

---matches an array where all of its elements are the given value or type
---@class tableshape.ArrayOf : tableshape.BaseType
---@field expected any
---@field keep_nils boolean?
---@field length_type tableshape.BaseType?
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.ArrayContains.Options
---@field short_circuit? boolean
---@field keep_nils? boolean

---matches a table where its array contains the given value or type
---@class tableshape.ArrayContains : tableshape.BaseType
---@field contains any
---@field short_circuit boolean?
---@field keep_nils boolean?
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a table where all its key-value pairs match a pair of types
---@class tableshape.MapOf : tableshape.BaseType
---@field expected_key tableshape.BaseType
---@field expected_value tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.Shape.Options
---mutually exclusive from the `open` option
---@field extra_fields? tableshape.BaseType
---mutually exclusive from the `extra_fields` option
---@field open? boolean
---@field check_all? boolean

---matches a table where all of its keys match the corresponding types
---@class tableshape.Shape : tableshape.BaseType
---@field shape table -- the fields to check against
---@field open boolean -- whether the type ignores extra keys
---@field check_all boolean -- whether the type should fail on first key mismatch
---@field extra_fields_type? tableshape.BaseType --
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local Shape = {}

---allows the shape type to ignore extra keys
---@return tableshape.Shape open_shape
function Shape:is_open() end

---matches a table where all of its keys match the corresponding types,
---allowing extraneous keys
---@class tableshape.Partial : tableshape.Shape
---@field open true -- whether the type ignores extra keys
---@field is_open nil -- errors on call
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.Pattern.Options
---@field coerce tableshape.BaseType | any

---matches a string with the following pattern
---@class tableshape.Pattern : tableshape.BaseType
---@field pattern string
---@field coerce tableshape.BaseType | any
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that passes an equality check with this type
---@class tableshape.Literal : tableshape.BaseType
---@field value any -- the value to compare against
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that satisfies this custom predicate
---@class tableshape.Custom : tableshape.BaseType
---@field fn fun(val: any, state: tableshape.State): (pass: any?, err: string?)
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that passes this type's equivalency check. Default is
---equality or, for tables, field equality.
---@class tableshape.Equivalent : tableshape.BaseType
---@field val any
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType
local Equivalent = {}

---determines whether these two values are equivalent. Default is equality or,
---for tables, field equality. This function can be overridden.
---@param a any
---@param b any
---@return boolean
function Equivalent:values_equivalent(a, b) end

---matches a value within the range of this type's left and right values
---@class tableshape.Range : tableshape.BaseType
---@field left any
---@field right any
---the value must match this type before attempting comparison
---@field value_type tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value with the returned type of this proxy's function
---@class tableshape.Proxy : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value with the given type, erroring if it doesn't match
---@class tableshape.AssertType : tableshape.BaseType
---the function that does the assertion
---@field assert fun(val: any, reason: string)
---@field base_type tableshape.BaseType -- the type to check against
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches a value that doesn't match the given type
---@class tableshape.NotType : tableshape.BaseType
---@field base_type tableshape.BaseType -- the type not to check against
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---matches primitives and tables, sending a shallow copy of that value to
---future types
---@class tableshape.CloneType : tableshape.BaseType
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@class tableshape.MetatableIsType.Options
---@field allow_metatable_update? boolean

---matches a value whose metatable matches this type
---@class tableshape.MetatableIsType : tableshape.BaseType
---@field metatable_type tableshape.BaseType
---whether a new metatable can be assigned to the value via a transform
---@field allow_metatable_update boolean
---@overload fun(unknown): (boolean, err: string?)
---@operator div(function): tableshape.TransformNode
---@operator mod(function): tableshape.TransformNode
---@operator mul(tableshape.CanCoerceLiteral): tableshape.SequenceNode
---@operator add(tableshape.CanCoerceLiteral): tableshape.FirstOfNode
---@operator unm: tableshape.NotType

---@alias tableshape.CanCoerceLiteral
---| number
---| string
---| boolean
---| tableshape.BaseType

---a collection of validation types
---@class tableshape.types
local types = {}
tableshape.types = types

---@type tableshape.AnyType
types.any = {}

---matches a string
---@type tableshape.Type
types.string = {}

---matches a number
---@type tableshape.Type
types.number = {}

---matches a function
---@type tableshape.Type
types.func = {}

types["function"] = types.func

---matches the values `true` or `false`
---@type tableshape.Type
types.boolean = {}

---matches a userdata
---@type tableshape.Type
types.userdata = {}

---matches the value `nil`
---@type tableshape.Type
types.null = {}

types["nil"] = types.null

---matches a table
---@type tableshape.Type
types.table = {}

---@type tableshape.ArrayType
types.array = {}

---@type tableshape.CloneType
types.clone = {}

---matches an integer
---@class tableshape.IntegerType : tableshape.Pattern
types.integer = {}

---matches any of the given values or types
---@param options any[]
---@return tableshape.OneOf
function types.one_of(options) end

---matches all of the given types
---@param types tableshape.BaseType[]
---@return tableshape.AllOf
---@diagnostic disable-next-line: redefined-local
function types.all_of(types) end

---matches a table where all of its keys match the corresponding types
---@param shape table
---@param opts? tableshape.Shape.Options
---@return tableshape.Shape
function types.shape(shape, opts) end

---matches a table where all of its keys match the corresponding types,
---allowing extraneous keys
---@param shape table
---@param opts? tableshape.Shape.Options
---@return tableshape.Partial
function types.partial(shape, opts) end

---matches a string with the following pattern
---@param pattern string
---@param opts? tableshape.Pattern.Options
---@return tableshape.Pattern
function types.pattern(pattern, opts) end

---matches an array where all of its elements are the given value or type
---@param expected any
---@param opts? tableshape.ArrayOf.Options
---@return tableshape.ArrayOf
function types.array_of(expected, opts) end

---matches a table where its array contains the given value or type
---@param contains any
---@param opts? tableshape.ArrayContains.Options
---@return tableshape.ArrayContains
function types.array_contains(contains, opts) end

---matches a table where all its key-value pairs match a pair of types
---@param expected_key tableshape.CanCoerceLiteral
---@param expected_value tableshape.CanCoerceLiteral
---@return tableshape.MapOf
function types.map_of(expected_key, expected_value) end

---matches a value that passes an equality check with this type
---@param val any
---@return tableshape.Literal
function types.literal(val) end

---matches a value within the range of this type's left and right values
---
---errors if `left > right`
---@param left any
---@param right any
---@return tableshape.Range
function types.range(left, right) end

---matches a value that passes this type's equivalency check. Default is
---equality or, for tables, field equality.
---@param val any
---@return tableshape.Equivalent
function types.equivalent(val) end

---matches a value that satisfies this custom predicate
---@param fn fun(val: any, state: tableshape.State): (pass: any?, err: string?)
---@return tableshape.Custom
function types.custom(fn) end

---creates a new scoped state for the type this wraps. The scoped state
---is `nil` by default and can be altered by deriving from this class and
---overriding the `create_scope_state` method.
---
---> Since this is a MoonScript class, it should be derived in MoonScript or
---> using a library like [muun](https://github.com/megagrump/muun).
---
---If `opts.tag` is a `function`, it gets called with the cloned state, the
---scoped state, and the value. Otherwise, the scoped state is what gets stored
---in the tag value.
---@param base_type tableshape.BaseType
---@param opts? tableshape.TaggedType.Options
---@return tableshape.TagScopeType
function types.scope(base_type, opts) end

---matches a value with the returned type of this proxy's function
---@param fn fun(): tableshape.BaseType
---@return tableshape.Proxy
function types.proxy(fn) end

---matches a value with the given type, erroring if it doesn't match
---@param base_type tableshape.BaseType
---@return tableshape.AssertType
function types.assert(base_type) end

---annotates failures with the value that failed
---@param base_type tableshape.CanCoerceLiteral
---@param opts? tableshape.AnnotateNode.Options
---@return tableshape.AnnotateNode
function types.annotate(base_type, opts) end

---matches a value whose metatable matches this type
---@param metatable_type any
---@param opts? tableshape.MetatableIsType.Options
---@return tableshape.MetatableIsType
function types.metatable_is(metatable_type, opts) end

return tableshape
