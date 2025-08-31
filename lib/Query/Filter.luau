--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Filter = {}

export type Filter = typeof(Filter) & Wrapper.Unwrappable<Unwrapped>

export type FilterProps = {
  name: string,
  path: string?,
  ts_type: string?,
  initial_value: string?,
}

export type UnwrappedFilter = Wrapper.UnwrappedName & {
  path: string,
  ts_type: string,
  initial_value: string?,
}

export type Unwrapped = {
  filter: UnwrappedFilter
}

export type FilterImpl = Filter & FilterProps

function Filter:new(o: FilterProps): Filter
  return Meta:type(o, self, "Query.Filter")
end

function Filter:from(name: string, path: string?, ts_type: string?): Filter
  return Filter:new({
    name = name,
    path = path,
    ts_type = ts_type,
  })
end

function Filter:with_initial_value(initial_value: string)
  local this = self::FilterImpl
  this.initial_value = initial_value
  return this
end

function Filter:unwrap_filter(): UnwrappedFilter
  local this = self::FilterImpl
  local unwrapped_name = Wrapper:unwrap_name(this.name)
  return Meta:append(unwrapped_name) {
    initial_value = this.initial_value,
    path = this.path or unwrapped_name.camel_name,
    ts_type = this.ts_type or 'string',
  }
end

function Filter:unwrap(): Unwrapped
  local this = self::FilterImpl
  return {
    filter = this:unwrap_filter(),
  }
end

return Filter
