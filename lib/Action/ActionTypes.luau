local Wrapper = require('@lorry.project/lib/Wrapper')

export type Unwrapped = {}

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type Dialog = AnyChild & {}

export type Fetch = AnyChild & {}

export type Prop = AnyChild & {}

export type Request = AnyChild & {}

export type Action =
  & Wrapper.Unwrappable<Unwrapped>

return {}