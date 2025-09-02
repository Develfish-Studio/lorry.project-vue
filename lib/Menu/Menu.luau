--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Item = require('./Item')

local Menu = {
  Item = Item,
}

export type Menu = typeof(Menu) & Wrapper.Unwrappable<Unwrapped>

export type MenuProps = {
  project: Project.Project,
  name: string,
  items: {Item.Item},
  requires_auth: boolean?,
  roles: {string},
}

export type UnwrappedMenu = Wrapper.UnwrappedName & {
  requires_auth: boolean,
  roles: {string},
  items: {Item.Unwrapped}
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  menu: UnwrappedMenu,
}

export type MenuImpl = Menu & MenuProps

export type AnyChild = Item.Item

function Menu:new(o: MenuProps): Menu
  return Meta:type(o, self, "Menu")
end

function Menu:from(project: Project.Project, name: string): Menu
  assert(project ~= nil)
  assert(name ~= nil)
  return Menu:new({
    project = project,
    name = name,
    items = Meta:array {},
    roles = Meta:array {},
  })
end

function Menu:setup(children: {AnyChild}): Menu
  local this = self::MenuImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Menu:with_child(child: AnyChild): Menu
  local this = self::MenuImpl
  local tag = Meta:typeof(child)
  if tag == 'Menu.Item' then
    this.items[#this.items + 1] = child::Item.Item
  end
  return this
end

function Menu:with_role(role: string): Menu
  local this = self::MenuImpl
  this.requires_auth = true
  this.roles[#this.roles + 1] = role
  return this
end

function Menu:unwrap_menu(): UnwrappedMenu
  local this = self::MenuImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    requires_auth = self.requires_auth,
    roles = this.roles,
    items = Wrapper:unwrap_array(this.items),
  }
end

function Menu:unwrap(): Unwrapped
  local this = self::MenuImpl
  return {
    project = this.project:unwrap_project(),
    menu = this:unwrap_menu(),
  }
end

return Menu
