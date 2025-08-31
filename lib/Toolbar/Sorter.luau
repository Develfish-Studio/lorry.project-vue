local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Sorter = {
  __type = 'Sorter',
  name = nil,
}

function Sorter:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Sorter:from(name: string)
  assert(name ~= nil)
  return Sorter:new({
    name = name,
  })
end

function Sorter:unwrap_sorter()
  local name = self.name
  return {
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Sorter:unwrap()
  return {
    sorter = self:unwrap_sorter(),
  }
end

return Sorter
