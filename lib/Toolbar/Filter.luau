local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Select = require('vue/control/Select')
local Search = require('vue/control/Search')

local Filter = {
  __type = 'Filter',
  kind = nil,
  project = nil,
  control = nil,
  name = nil,
}

function Filter:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Filter:from_select(control: Select, name: string)
  assert(control ~= nil, 'Invalid argument for named object: ' .. (name or 'nil'))
  return Filter:new({
    kind = 'select',
    project = control.project,
    control = control,
    name = name,
  })
end

function Filter:from_search(control: Search, name: string)
  assert(control ~= nil, 'Invalid argument for named object: ' .. (name or 'nil'))
  return Filter:new({
    kind = 'search',
    project = control.project,
    control = control,
    name = name,
  })
end

function Filter:unwrap_filter()
  local name = self.name or self.control.name
  return {
    kind = self.kind,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Filter:unwrap_control()
  if self.kind == 'select' then
    return self.control:unwrap_select()
  elseif self.kind == 'search' then
    return self.control:unwrap_search()
  end
  return nil
end

function Filter:unwrap()
  return {
    project = self.project:unwrap_project(),
    filter = self:unwrap_filter(),
    control = self:unwrap_control(),
  }
end

return Filter
