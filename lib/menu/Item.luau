local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Router = require('vue/Router')

local Item = {
  __type = 'Item',
  router = nil,
  route = nil,
  name = nil,
  font_icon = nil,
  items = nil,
}

function Item:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Item:from(router: Router, route: Router.Route, name: string)
  assert(router ~= nil)
  assert(route ~= nil)
  return Item:new({
    router = router,
    route = route,
    name = name,
    items = Meta:array {},
  })
end

function Item:from_route(router: Router, route: Router.Route, name: string, font_icon: string)
  return Item:from(router, route, name, font_icon)
end

function Item:from_name(name: string)
  return Item:from(nil, nil, name)
end

function Item:with_rules(children: table)
  children = children or {}

  for _, child in children do
    if child.__type == 'Item' then
      self.items[#self.items + 1] = child
    end
  end

  return self
end

function Item:with_font_icon(font_icon: string)
  self.font_icon = font_icon
  return self
end

function Item:with_route(route: Route)
  self.route = route
  return self
end

function Item:with_name(name: string)
  self.name = name
  return self
end

function Item:unwrap_items()
  local items = Meta:array {}

  for item in self.items do
    items[#items + 1] = item:unwrap()
  end

  return items
end

function Item:unwrap_item()
  local name = self.name or self.route.page.name
  return {
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
    font_icon = self.font_icon,
    items = self:unwrap_items()
  }
end

function Item:unwrap()
  local route = self.route:unwrap_route()
  local router_path = self.router and ('/' .. self.router.name) or ''

  return {
    item = self:unwrap_item(),
    route = route,
    to = router_path .. '/' .. route.path
  }
end

return Item
