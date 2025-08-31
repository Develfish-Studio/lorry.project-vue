local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Column = {
  __type = 'Column',
  kind = nil,
  name = nil,
  path = nil,
  symbol = nil,
  template = nil,
  variables = nil,
}

function Column:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Column:from_path(name: string, path: string)
  return Column:new({
    kind = 'path',
    name = name,
    path = path or name,
    variables = Meta:array {},
  })
end

function Column:from_template(name: string, template: string)
  return Column:new({
    kind = 'template',
    name = name,
    template = template,
    variables = Meta:array {},
  })
end

function Column:from_symbol(name: string, symbol: Symbol, path: string)
  return Column:new({
    kind = 'symbol',
    name = name,
    symbol = symbol,
    path = path,
    variables = Meta:array {},
  })
end

function Column:with_variable(name: string, value: string)
  self.variables[#self.variables + 1] = {
    name = name,
    value = value,
  }
  return self
end

function Column:unwrap_symbol()
  if self.symbol == nil then
    return nil
  end
  return self.symbol:unwrap_symbol()
end

function Column:unwrap_column()
  local name = self.name
  return {
    kind = self.kind,
    path = self.path,
    template = self.template,
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
    column = self:unwrap_column(),
    symbol = self:unwrap_symbol(),
    variables = self.variables,
  }
end

return Column
