--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Page = require('../Page/Page')

local Route = {}

export type Route = typeof(Route) & Wrapper.Unwrappable<Unwrapped>

export type RouteProps = {
  page: Page.Page?,
  name: string?,
  path: string?,
  requires_auth: boolean,
  roles: {string},
}

export type UnwrappedRoute = Wrapper.UnwrappedName & {
  path: string,
  requires_auth: boolean,
}

export type Unwrapped = {
  route: UnwrappedRoute,
  page: Page.UnwrappedPage?,
  roles: {string},
}

export type RouteImpl = Route & RouteProps

function Route:new(o: RouteProps): Route
  return Meta:type(o, self, "Router.Route")
end

function Route:from(page: Page.Page?, name: string?)
  assert(page ~= nil or name ~= nil)
  return Route:new({
    page = page,
    name = name,
    requires_auth = false,
    roles = Meta:array {},
  })
end

function Route:from_page(page: Page.Page, name: string)
  return Route:from(page, name)
end

function Route:from_name(name: string)
  return Route:from(nil, name)
end

function Route:with_path(path: string)
  self.path = path
  return self
end

function Route:with_role(role: string): Route
  local this = self::RouteImpl
  this.roles[#this.roles + 1] = role
  return this
end

function Route:with_auth(requires_auth: boolean): Route
  local this = self::RouteImpl
  this.requires_auth = requires_auth == nil or requires_auth == true
  return this
end

function Route:unwrap_route(): UnwrappedRoute
  local this = self::RouteImpl
  local name = this.name or (this.page::Page.PageImpl).name
  return Meta:append(Wrapper:unwrap_name(name)) {
    path = this.path or name,
    requires_auth = this.requires_auth,
  }
end

function Route:unwrap(): Unwrapped
  local this = self::RouteImpl
  return {
    route = this:unwrap_route(),
    page = this.page and this.page:unwrap_page(),
    roles = this.roles,
  }
end

return Route
