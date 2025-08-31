local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Remote = require('vue/Remote')
local Column = require('vue/grid/Column')
local Handle = require('vue/grid/Handle')

local Grid = {
  __type = 'Grid',

  Column = Column,
  Handle = Handle,

  query = nil,
  name = nil,
  columns = nil,
  handles = nil,
}

function Grid:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Grid:from_query(query: Request, name: string, rules: table)
  assert(query ~= nil, 'Invalid argument for named object: ' .. (name or 'nil'))
  return Grid
    :new({
      query = query,
      name = name,
      columns = Meta:array {},
      handles = Meta:array {},
    })
    :with_rules(rules)
end

function Grid:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Column' then
      self.columns[#self.columns + 1] = child
    elseif child.__type == 'Handle' then
      self.handles[#self.handles + 1] = child
    end
  end

  return self
end

function Grid:unwrap_columns()
  local columns = Meta:array {}
  for _, column in self.columns do
    columns[#columns + 1] = column:unwrap()
  end
  return columns
end

function Grid:unwrap_handles()
  local handles = Meta:array {}
  for _, handle in self.handles do
    handles[#handles + 1] = handle:unwrap()
  end
  return handles
end

function Grid:unwrap_grid()
  local name = self.name or self.request.remote.name
  return {
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Grid:unwrap()
  local query = self.query
  local request = query.request
  local remote = request.remote
  local project = remote.project
  return {
    project = project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    query = query:unwrap_query(),
    grid = self:unwrap_grid(),
    columns = self:unwrap_columns(),
    handles = self:unwrap_handles(),
  }
end

return Grid
