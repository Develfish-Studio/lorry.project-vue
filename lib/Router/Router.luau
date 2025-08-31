--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local View = require('../View/View')
local Route = require('./Route')

local Router = {
  Route = Route,
}

export type Router = typeof(Router) & Wrapper.Unwrappable<Unwrapped>

export type RouterProps = {
  view: View.View,
  name: string,
  routes: {Route.Route},
}

export type UnwrappedRouter = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  view: View.UnwrappedView,
  router: UnwrappedRouter,
  routes: {Route.Unwrapped},
}

export type RouterImpl = Router & RouterProps

export type AnyChild =
  | Route.Route

function Router:new(o: RouterProps): Router
  return Meta:type(o, self, "Router")
end

function Router:from_view(view: View.View, name: string)
  assert(view ~= nil)
  assert(name ~= nil)
  return Router:new({
    view = view,
    name = name,
    routes = Meta:array {},
  })
end

function Router:setup(children: {AnyChild}): Router
  local this = self::RouterImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Router:with_child(child: AnyChild): Router
  local this = self::RouterImpl
  local tag = Meta:typeof(child)
  if tag == 'Router.Route' then
    this.routes[#this.routes + 1] = child::Route.Route
  end
  return this
end

function Router:unwrap_router(): UnwrappedRouter
  local this = self::RouterImpl
  return Wrapper:unwrap_name(this.name)
end

function Router:unwrap(): Unwrapped
  local this = self::RouterImpl
  local view = this.view::View.ViewImpl
  return {
    project = view.project:unwrap_project(),
    view = view:unwrap_view(),
    router = this:unwrap_router(),
    routes = Wrapper:unwrap_array(this.routes)
  }
end

return Router
