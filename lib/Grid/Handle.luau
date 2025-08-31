local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Action = require('vue/Action')

local Handle = {
  __type = 'Handle',
  name = nil,
  icon = nil,
  expression = nil,
  on_success = nil,
  on_failure = nil,
}

function Handle:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Handle:from(action: Action, name: string)
  assert(name ~= nil)
  return Handle:new({
    action = action,
    name = name,
    on_success = Meta:array {},
    on_failure = Meta:array {},
  })
end

function Handle:with_icon(icon: string)
  self.icon = icon
  return self
end

function Handle:with_expression(expression: string)
  self.expression = expression
  return self
end

function Handle:with_on_success(event: string, data)
  self.on_success[#self.on_success + 1] = {
    event = event,
    data = data
  }
  return self
end

function Handle:with_on_failure(event: string, data)
  self.on_failure[#self.on_failure + 1] = {
    event = event,
    data = data
  }
  return self
end

function Handle:unwrap_handle()
  local name = self.name or self.action.name
  return {
    expression = self.expression,
    icon = self.icon,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Handle:unwrap()
  return {
    handle = self:unwrap_handle(),
    action = self.action:unwrap_action(),
    on_failure = self.on_failure,
    on_success = self.on_success,
  }
end

return Handle
