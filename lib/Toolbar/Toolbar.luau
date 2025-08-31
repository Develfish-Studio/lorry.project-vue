local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Project = require('vue/Project')
local Filter = require('vue/toolbar/Filter')
local Sorter = require('vue/toolbar/Sorter')
local Handle = require('vue/toolbar/Handle')
local Column = require('vue/toolbar/Column')

local Toolbar = {
  __type = 'Toolbar',

  Filter = Filter,
  Sorter = Sorter,
  Handle = Handle,
  Column = Column,

  query = nil,
  name = nil,
  columns = nil,
  filters = nil,
  sorters = nil,
  handles = nil,
}

function Toolbar:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Toolbar:from_query(query: Query, name: string, rules: table)
  assert(query ~= nil, 'Invalid argument for named object: ' .. (name or 'nil'))
  return Toolbar
    :new({
      query = query,
      name = name,
      filters = Meta:array {},
      sorters = Meta:array {},
      handles = Meta:array {},
      columns = Meta:array {},
    })
    :with_rules(rules)
end

function Toolbar:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Filter' then
      self.filters[#self.filters + 1] = child
    elseif child.__type == 'Sorter' then
      self.sorters[#self.sorters + 1] = child
    elseif child.__type == 'Handle' then
      self.handles[#self.handles + 1] = child
    elseif child.__type == 'Column' then
      self.columns[#self.columns + 1] = child
    end
  end

  return self
end

function Toolbar:unwrap_filters()
  local filters = Meta:array {}
  for _, filter in self.filters do
    filters[#filters + 1] = filter:unwrap()
  end
  return filters
end

function Toolbar:unwrap_sorters()
  local sorters = Meta:array {}
  for _, sorter in self.sorters do
    sorters[#sorters + 1] = sorter:unwrap()
  end
  return sorters
end

function Toolbar:unwrap_handles()
  local handles = Meta:array {}
  for _, handle in self.handles do
    handles[#handles + 1] = handle:unwrap()
  end
  return handles
end

function Toolbar:unwrap_columns()
  local columns = Meta:array {}
  for _, column in self.columns do
    columns[#columns + 1] = column:unwrap()
  end
  return columns
end

function Toolbar:unwrap_toolbar()
  local name = self.name
  return {
    name = name,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Toolbar:unwrap()
  local query = self.query
  local request = query.request
  local remote = request.remote
  local project = remote.project
  return {
    project = project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    query = query:unwrap_query(),
    toolbar = self:unwrap_toolbar(),
    filters = self:unwrap_filters(),
    sorters = self:unwrap_sorters(),
    handles = self:unwrap_handles(),
    columns = self:unwrap_columns(),
  }
end

return Toolbar
