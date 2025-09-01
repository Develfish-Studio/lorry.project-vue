local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Item = require('vue/menu/Item')

local Menu = {
  __type = 'Menu',

  Item = Item,

  project = project,
  items = nil,
  requires_auth = false,
  roles = nil,
}

function Menu:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Menu:from(project: Project, name: string, items: table)
  assert(name ~= nil)
  return Menu:new({
    project = project,
    name = name,
    items = items or Meta:array {},
  })
end

function Menu:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Item' then
      self.items[#self.items + 1] = child
    end
  end

  return self
end

function Menu:with_roles(roles: table)
  self.requires_auth = true
  self.roles = roles
  return self
end

function Menu:unwrap_items()
  local items = Meta:array {}

  for _, item in self.items do
    items[#items + 1] = item:unwrap()
  end

  return items
end

function Menu:unwrap_menu()
  local name = self.name
  return {
    requires_auth = self.requires_auth,
    roles = self.roles,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
    items = self:unwrap_items(),
  }
end

function Menu:unwrap()
  return {
    project = self.project:unwrap_project(),
    menu = self:unwrap_menu(),
  }
end

return Menu
