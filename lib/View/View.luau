--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Socket = require('../Transport/Socket')
local Subscription = require('../Transport/Subscription')

local View = {
  Socket = Socket,
  Subscription = Subscription,
}

export type View = typeof(View)

export type ViewProps = {
  project: Project.Project,
  name: string,
  sockets: {Socket.Socket},
  subscriptions: {Subscription.Subscription},
}

export type UnwrappedView = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  view: UnwrappedView,
  sockets: {Socket.Unwrapped},
  subscriptions: {Subscription.Unwrapped},
}

export type ViewImpl = View & ViewProps

export type AnyChild =
  | Socket.Socket
  | Subscription.Subscription

function View:new(o: ViewProps): View
  return Meta:type(o, self, "View")
end

function View:from(project: Project.Project, name: string): View
  assert(project ~= nil)
  assert(name ~= nil)
  return View:new({
    project = project,
    name = name,
    sockets = Meta:array {},
    subscriptions = Meta:array {},
  })
end

function View:setup(children: {AnyChild}): View
  local this = self::ViewImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function View:with_child(child: AnyChild): View
  local this = self::ViewImpl
  local tag = Meta:typeof(child)
  if tag == 'Transport.Socket' then
    this.sockets[#this.sockets + 1] = child::Socket.Socket
  elseif tag == 'Transport.Subscription' then
    this.subscriptions[#this.subscriptions + 1] = child::Subscription.Subscription
  end
  return this
end

function View:unwrap_view(): UnwrappedView
  local this = self::ViewImpl
  return Wrapper:unwrap_name(this.name)
end

function View:unwrap(): Unwrapped
  local this = self::ViewImpl
  return {
    project = this.project:unwrap_project(),
    view = this:unwrap_view(),
    sockets = Wrapper:unwrap_array(this.sockets),
    subscriptions = Wrapper:unwrap_array(this.subscriptions),
  }
end

return View
