local Wrapper = require('@lorry.project/lib/Wrapper')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type AnyNode =
  & AnyChild

export type Prop = AnyChild & {}

export type Query = AnyChild & {}

export type Section = AnyNode & {}

export type Heading = AnyNode & {}

return {}