local Wrapper = require('@lorry.project/lib/Wrapper')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>

export type Toolbar = AnyChild & {}

export type Widget = AnyChild & {}

export type Fieldset = AnyChild & {}

export type Grid = AnyChild & {}

return {}