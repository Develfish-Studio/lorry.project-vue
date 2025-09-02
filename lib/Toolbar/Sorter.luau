--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local ToolbarTypes = require('./ToolbarTypes')

local Sorter = {}

export type Sorter = typeof(Sorter) & ToolbarTypes.Sorter & Wrapper.Unwrappable<Unwrapped>

export type SorterProps = {
  name: string,
}

export type UnwrappedSorter = Wrapper.UnwrappedName

export type Unwrapped = ToolbarTypes.UnwrappedChild & {
  sorter: UnwrappedSorter
}

export type SorterImpl = Sorter & SorterProps

function Sorter:new(o: SorterProps): Sorter
  return Meta:type(o, self, "Toolbar.Sorter")
end

function Sorter:from(name: string): Sorter
  assert(name ~= nil)
  return Sorter:new({
    name = name,
  })
end

function Sorter:unwrap_sorter(): UnwrappedSorter
  local this = self::SorterImpl
  return Wrapper:unwrap_name(this.name)
end

function Sorter:unwrap(): Unwrapped
  local this = self::SorterImpl
  return {
    sorter = this:unwrap_sorter(),
  }
end

return Sorter
