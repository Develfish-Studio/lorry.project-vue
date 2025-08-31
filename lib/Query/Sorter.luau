--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Sorter = {}

export type Sorter = typeof(Sorter) & Wrapper.Unwrappable<Unwrapped>

export type SorterProps = {
  name: string,
  path: string,
  initial_value: string?,
}

export type UnwrappedSorter = Wrapper.UnwrappedName & {
  path: string,
  initial_value: string?,
}

export type Unwrapped = {
  sorter: UnwrappedSorter
}

export type SorterImpl = Sorter & SorterProps

function Sorter:new(o: SorterProps): Sorter
  return Meta:type(o, self, "Query.Sorter")
end

function Sorter:from(name: string, path: string, initial_value: string?): Sorter
  return Sorter:new({
    name = name,
    path = path,
    initial_value = initial_value,
  })
end

function Sorter:unwrap_sorter(): UnwrappedSorter
  local this = self::SorterImpl
  local unwrapped_name = Wrapper:unwrap_name(this.name)
  return Meta:append(unwrapped_name) {
    initial_value = this.initial_value,
    path = this.path or unwrapped_name.camel_name,
  }
end

function Sorter:unwrap(): Unwrapped
  local this = self::SorterImpl
  return {
    sorter = this:unwrap_sorter(),
  }
end

return Sorter
