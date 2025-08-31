local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Field = require('vue/fieldset/Field')

local Fieldset = {
  __type = 'Fieldset',

  Field = Field,

  query = nil,
  name = nil,
  fields = nil,
}

function Fieldset:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Fieldset:from_query(query: Query, name: string, rules: table)
  assert(query ~= nil)
  return Fieldset
    :new({
      query = query,
      name = name,
      fields = Meta:array {},
    })
    :with_rules(rules)
end

function Fieldset:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Field' then
      self.fields[#self.fields + 1] = child
    end
  end

  return self
end

function Fieldset:unwrap_fields()
  local fields = Meta:array {}
  for _, field in self.fields do
    fields[#fields + 1] = field:unwrap()
  end
  return fields
end

function Fieldset:unwrap_fieldset()
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

function Fieldset:unwrap()
  return {
    project = self.query.request.remote.project:unwrap_project(),
    query = self.query:unwrap_query(),
    fieldset = self:unwrap_fieldset(),
    fields = self:unwrap_fields(),
  }
end

return Fieldset
