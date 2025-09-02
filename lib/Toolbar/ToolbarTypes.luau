local Wrapper = require('@lorry.project/lib/Wrapper')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type Column = AnyChild & {}

export type Filter = AnyChild & {}

export type Handle = AnyChild & {}

export type Sorter = AnyChild & {}

return {}