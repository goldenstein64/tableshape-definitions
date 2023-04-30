# tableshape Definitions

Definitions files for [leafo/tableshape](https://github.com/leafo/tableshape) 2.6.0 to use with [LuaLS/lua-language-server](https://github.com/LuaLS/lua-language-server). The annotations have been manually written directly from the [source code](https://github.com/leafo/tableshape) to be parsable by the LSP.

## Usage

For manual installation, add these settings to your `settings.json` file.

```jsonc
// settings.json
{
  "Lua.workspace.library": [
    // path to wherever this repo was cloned to
    "path/to/this/repo",

    // this library uses luassert as a dependency
    // if you don't use luassert in your project, ignore this
    "${3rd}/luassert"
  ]
}
```

For a more detailed description of how to install a library of definition files, see the LSP's [wiki](https://github.com/sumneko/lua-language-server/wiki/Libraries).

## Types

The types provided by this library are, exhaustively:

* Classes, given as `tableshape.[CLASS NAME]`. Every class is listed below:

| Name                                 | Module Source           |
| ------------------------------------ | ----------------------- |
| `luassert` (extended)                | `tableshape.luassert`   |
| `tableshape`                         | `tableshape.init`       |
| `tableshape.FailedTransform`         | `tableshape.init`       |
| `tableshape.CanCheckShape`           | `tableshape.init`       |
| `tableshape.BaseType`                | `tableshape.init`       |
| `tableshape.BaseType.Class`          | `tableshape.init`       |
| `tableshape.TransformNode`           | `tableshape.init`       |
| `tableshape.SequenceNode`            | `tableshape.init`       |
| `tableshape.FirstOfNode`             | `tableshape.init`       |
| `tableshape.DescribeNode`            | `tableshape.init`       |
| `tableshape.AnnotateNode.Options`    | `tableshape.init`       |
| `tableshape.AnnotateNode`            | `tableshape.init`       |
| `tableshape.TaggedType.Options`      | `tableshape.init`       |
| `tableshape.TaggedType`              | `tableshape.init`       |
| `tableshape.TagScopeType`            | `tableshape.init`       |
| `tableshape.OptionalType`            | `tableshape.init`       |
| `tableshape.AnyType`                 | `tableshape.init`       |
| `tableshape.Type.Options`            | `tableshape.init`       |
| `tableshape.Type`                    | `tableshape.init`       |
| `tableshape.ArrayType`               | `tableshape.init`       |
| `tableshape.OneOf`                   | `tableshape.init`       |
| `tableshape.AllOf`                   | `tableshape.init`       |
| `tableshape.ArrayOf.Options`         | `tableshape.init`       |
| `tableshape.ArrayOf`                 | `tableshape.init`       |
| `tableshape.ArrayContains.Options`   | `tableshape.init`       |
| `tableshape.ArrayContains`           | `tableshape.init`       |
| `tableshape.MapOf`                   | `tableshape.init`       |
| `tableshape.Shape.Options`           | `tableshape.init`       |
| `tableshape.Shape`                   | `tableshape.init`       |
| `tableshape.Partial`                 | `tableshape.init`       |
| `tableshape.Pattern.Options`         | `tableshape.init`       |
| `tableshape.Pattern`                 | `tableshape.init`       |
| `tableshape.Literal`                 | `tableshape.init`       |
| `tableshape.Custom`                  | `tableshape.init`       |
| `tableshape.Equivalent`              | `tableshape.init`       |
| `tableshape.Range`                   | `tableshape.init`       |
| `tableshape.Proxy`                   | `tableshape.init`       |
| `tableshape.AssertType`              | `tableshape.init`       |
| `tableshape.NotType`                 | `tableshape.init`       |
| `tableshape.CloneType`               | `tableshape.init`       |
| `tableshape.MetatableIsType.Options` | `tableshape.init`       |
| `tableshape.MetatableIsType`         | `tableshape.init`       |
| `tableshape.types`                   | `tableshape.init`       |
| `tableshape.IntegerType`             | `tableshape.init`       |
| `tableshape.moonscript`              | `tableshape.moonscript` |
| `tableshape.moonscript.ClassType`    | `tableshape.moonscript` |
| `tableshape.moonscript.InstanceType` | `tableshape.moonscript` |
| `tableshape.moonscript.InstanceOf`   | `tableshape.moonscript` |
| `tableshape.moonscript.SubclassOf`   | `tableshape.moonscript` |

* Aliases, given as `tableshape.[ALIAS NAME]`. Every alias is listed below:

| Name                                  | Module Source     |
| ------------------------------------- | ----------------- |
| `tableshape.State`                    | `tableshape.init` |
| `tableshape.DescribeTable`            | `tableshape.init` |
| `tableshape.AnnotateNode.FormatError` | `tableshape.init` |
| `tableshape.CanCoerceLiteral`         | `tableshape.init` |
