local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Column = {
  __type = 'Column',
  name = nil,
  ts_type = nil,
}

function Column:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Column:from(name: string, ts_type: string)
  assert(name ~= nil)
  return Column:new({
    name = name,
    ts_type= ts_type,
  })
end

function Column:unwrap_column()
  local name = self.name or self.action.name
  return {
    ts_type = self.ts_type,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Column:unwrap()
  return {
    column = self:unwrap_column()
  }
end

return Column
