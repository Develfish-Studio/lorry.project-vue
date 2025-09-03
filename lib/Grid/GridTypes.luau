local Wrapper = require('@lorry.project/lib/Wrapper')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type Column = AnyChild & {}

export type Handle = AnyChild & {}

return {}