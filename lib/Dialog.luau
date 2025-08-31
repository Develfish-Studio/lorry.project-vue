local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Project = require('vue/Project')
local Request = require('vue/Request')
local Prop = require('vue/dialog/Prop')
local Field = require('vue/dialog/Field')
local Call = require('vue/dialog/Call')
local Query = require('vue/dialog/Query')

local Dialog = {
  __type = 'Dialog',

  Prop = Prop,
  Field = Field,
  Call = Call,
  Query = Query,

  name = nil,
  props = nil,
  fields = nil,
  calls = nil,
  queries = nil,
}

function Dialog:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Dialog:from(project: Project, name: string)
  assert(project ~= nil)
  assert(name ~= nil)
  return Dialog:new({
    project = project,
    name = name,
    props = Meta:array {},
    fields = Meta:array {},
    calls = Meta:array {},
    queries = Meta:array {},
  })
end

function Dialog:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Field' then
      self.fields[#self.fields + 1] = child
    elseif child.__type == 'Call' then
      self.calls[#self.calls + 1] = child
    elseif child.__type == 'Query' then
      self.queries[#self.queries + 1] = child
    elseif child.__type == 'Prop' then
      self.props[#self.props + 1] = child
    end
  end

  return self
end

function Dialog:unwrap_fields()
  local fields = Meta:array {}
  for _, field in self.fields do
    fields[#fields + 1] = field:unwrap()
  end
  return fields
end

function Dialog:unwrap_calls()
  local calls = Meta:table {
    submit = nil,
  }
  for _, call in self.calls do
    if call.kind == 'submit' then
      calls.submit = call:unwrap()
    end
  end
  return calls
end

function Dialog:unwrap_dialog()
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

function Dialog:unwrap_queries()
  local queries = Meta:array {}
  for _, child in self.queries do
    queries[#queries + 1] = child:unwrap()
  end
  return queries
end

function Dialog:unwrap_props()
  local props = Meta:array {}
  for _, child in self.props do
    props[#props + 1] = child:unwrap()
  end
  return props
end

function Dialog:unwrap()
  return {
    project = self.project:unwrap_project(),
    dialog = self:unwrap_dialog(),
    props = self:unwrap_props(),
    fields = self:unwrap_fields(),
    calls = self:unwrap_calls(),
  }
end

return Dialog
