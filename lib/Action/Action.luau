local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Project = require('vue/Project')
local Prop = require('vue/action/Prop')
local Fetch = require('vue/action/Fetch')
local Dialog = require('vue/action/Dialog')
local Request = require('vue/action/Request')

local Action = {
  __type = 'Action',

  Prop = Prop,
  Fetch = Fetch,
  Dialog = Dialog,
  Request = Request,

  project = nil,
  request = nil,
  dialog = nil,
  name = nil,
  props = nil,
  fetchers = nil,
}

function Action:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Action:from(project: Project, name: string)
  assert(project ~= nil)
  return Action:new({
    project = project,
    name = name,
    props = Meta:array {},
    fetchers = Meta:array {},
  })
end

function Action:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Prop' then
      self.props[#self.props + 1] = child
    elseif child.__type == 'Fetch' then
      self.fetchers[#self.fetchers + 1] = child
    elseif child.__type == 'Request' then
      self.request = child
    elseif child.__type == 'Dialog' then
      self.dialog = child
    end
  end

  return self
end

function Action:unwrap_action()
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

function Action:unwrap_request()
  if self.request == nil then
    return nil
  end
  return self.request:unwrap()
end

function Action:unwrap_dialog()
  if self.dialog == nil then
    return nil
  end
  return self.dialog:unwrap()
end

function Action:unwrap_fetchers()
  local fetchers = Meta:array {}
  for _, child in self.fetchers do
    fetchers[#fetchers + 1] = child:unwrap()
  end
  return fetchers
end

function Action:unwrap_props()
  local props = Meta:array {}
  for _, child in self.props do
    props[#props + 1] = child:unwrap()
  end
  return props
end

function Action:unwrap()
  return {
    project = self.project:unwrap_project(),
    request = self:unwrap_request(),
    dialog = self:unwrap_dialog(),
    fetchers = self:unwrap_fetchers(),
    props = self:unwrap_props(),
    action = self:unwrap_action()
  }
end

return Action
