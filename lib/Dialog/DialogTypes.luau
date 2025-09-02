local Wrapper = require('@lorry.project/lib/Wrapper')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type Prop = AnyChild & {}

export type Execution = AnyChild & {}

export type Call = AnyChild & {}

export type Field = AnyChild & {}

return {}