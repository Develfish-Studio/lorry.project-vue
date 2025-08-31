local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Field = {
  __type = 'Field',
  kind = nil,
  name = nil,
  path = nil,
  symbol = nil,
  template = nil,
}

function Field:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Field:from_path(name: string, path: string)
  return Field:new({
    kind = 'path',
    name = name,
    path = path or name,
  })
end

function Field:from_template(name: string, template: string)
  return Field:new({
    kind = 'template',
    name = name,
    template = template,
  })
end

function Field:from_symbol(name: string, symbol: Symbol, path: string)
  return Field:new({
    kind = 'symbol',
    name = name,
    symbol = symbol,
    path = path,
  })
end

function Field:unwrap_symbol()
  if self.symbol == nil then
    return nil
  end
  return self.symbol:unwrap_symbol()
end

function Field:unwrap_field()
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

function Field:unwrap()
  return {
    field = self:unwrap_field(),
    symbol = self:unwrap_symbol(),
  }
end

return Field
