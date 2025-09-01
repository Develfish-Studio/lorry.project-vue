--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')

local Select = require('../Control/Select')
local Search = require('../Control/Search')

local Filter = {}

export type Filter = typeof(Filter) & Wrapper.Unwrappable<Unwrapped>

export type FilterKind =
  | 'select'
  | 'search'

export type Control = Select.Select | Search.Search

export type FilterProps = {
  kind: FilterKind,
  control: Control,
  name: string?,
}

export type UnwrappedFilter = Wrapper.UnwrappedName & {
  kind: FilterKind
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  filter: UnwrappedFilter,
  control: Search.UnwrappedSearch | Select.UnwrappedSelect
}

export type FilterImpl = Filter & FilterProps

function Filter:new(o: FilterProps): Filter
  return Meta:type(o, self, "Toolbar.Filter")
end

function Filter:from_select(control: Select.Select, name: string?): Filter
  assert(control ~= nil)
  return Filter:new({
    kind = 'select',
    control = control,
    name = name,
  })
end

function Filter:from_search(control: Search.Search, name: string?): Filter
  assert(control ~= nil)
  return Filter:new({
    kind = 'search',
    control = control,
    name = name,
  })
end

function Filter:unwrap_filter(): UnwrappedFilter
  local this = self::FilterImpl
  return Meta:append(Wrapper:unwrap_name(this.name or (this.control::Project.IHaveName):get_name())) {
    kind = this.kind,
  }
end

function Filter:unwrap_control(): Select.UnwrappedSelect | Search.UnwrappedSearch
  local this = self::FilterImpl
  if this.kind == 'select' then
    return (this.control::Select.Select):unwrap_select()
  elseif this.kind == 'search' then
    return (this.control::Search.Search):unwrap_search()
  else
    error("Unsupported control:" .. this.kind)
  end
end

function Filter:unwrap(): Unwrapped
  local this = self::FilterImpl
  local control = this.control::Project.IHaveProject
  local project = control.get_project(this.control)
  return {
    project = project:unwrap_project(),
    filter = this:unwrap_filter(),
    control = this:unwrap_control(),
  }
end

return Filter
