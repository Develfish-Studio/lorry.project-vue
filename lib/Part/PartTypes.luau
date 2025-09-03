local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')

export type UnwrappedChild = {}

export type AnyChild =
  & Wrapper.Unwrappable<UnwrappedChild>
  & Project.IHaveName

export type Toolbar = AnyChild & {}

export type Widget = AnyChild & {}

export type Fieldset = AnyChild & {}

export type Grid = AnyChild & {}

return {}