--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Router = require('../Router/Router')
local Route = require('../Router/Route')
local Page = require('../Page/Page')

local Item = {}

export type Item = typeof(Item) & Wrapper.Unwrappable<Unwrapped>

export type ItemProps = {
  router: Router.Router,
  route: Route.Route,
  name: string?,
  font_icon: string?,
  items: {Item},
}

export type UnwrappedItem = Wrapper.UnwrappedName

export type Unwrapped = {
  item: UnwrappedItem,
  route: Route.UnwrappedRoute,
  to: string,
}

export type ItemImpl = Item & ItemProps

export type AnyChild = Item

function Item:new(o: ItemProps): Item
  return Meta:type(o, self, "Menu.Item")
end

function Item:from(router: Router.Router, route: Route.Route, name: string?): Item
  assert(router ~= nil)
  assert(route ~= nil)
  return Item:new({
    router = router,
    route = route,
    name = name,
    items = Meta:array {},
  })
end

function Item:from_route(router: Router.Router, route: Route.Route): Item
  return Item:from(router, route)
end

function Item:setup(children: {AnyChild}): Item
  local this = self::ItemImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Item:with_child(child: AnyChild): Item
  local this = self::ItemImpl
  local tag = Meta:typeof(child)
  if tag == 'Menu.Item' then
    this.items[#this.items + 1] = child::Item
  end
  return this
end

function Item:with_font_icon(font_icon: string?)
  local this = self::ItemImpl
  this.font_icon = font_icon
  return this
end

function Item:with_route(route: Route.Route)
  local this = self::ItemImpl
  this.route = route
  return this
end

function Item:with_name(name: string): Item
  local this = self::ItemImpl
  this.name = name
  return this
end

function Item:unwrap_items()
  local items = Meta:array {}

  for item in self.items do
    items[#items + 1] = item:unwrap()
  end

  return items
end

function Item:unwrap_item(): UnwrappedItem
  local this = self::ItemImpl
  local route = this.route::Route.RouteImpl
  local page = route.page::Page.PageImpl
  return Meta:append(Wrapper:unwrap_name(this.name or page.name)) {
    font_icon = this.font_icon,
    items = Wrapper:unwrap_array(this.items)
  }
end

function Item:unwrap(): Unwrapped
  local this = self::ItemImpl
  local route = this.route:unwrap_route()
  local router = this.router::Router.RouterImpl
  local router_path = this.router and ('/' .. router.name) or ''

  return {
    item = this:unwrap_item(),
    route = route,
    to = router_path .. '/' .. route.path
  }
end

return Item
