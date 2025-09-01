--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')

local Prop = require('./Prop')
local Fetch = require('./Fetch')
local Dialog = require('./Dialog')
local Request = require('./Request')

local Action = {
  Prop = Prop,
  Fetch = Fetch,
  Dialog = Dialog,
  Request = Request,
}

export type Action = typeof(Action) & Wrapper.Unwrappable<Unwrapped>

export type ActionProps = {
  project: Project.Project,
  request: Request.Request?,
  dialog: Dialog.Dialog?,
  name: string,
  props: {Prop.Prop},
  fetchers: {Fetch.Fetch},
}

export type UnwrappedAction = Wrapper.UnwrappedName & {
  props: {Prop.Unwrapped},
}

export type Unwrapped = {
  action: UnwrappedAction,
  request: Request.Unwrapped?,
  dialog: Dialog.Unwrapped?,
}

export type ActionImpl = Action & ActionProps

export type AnyChild =
  | Prop.Prop
  | Fetch.Fetch
  | Request.Request
  | Dialog.Dialog

function Action:new(o: ActionProps): Action
  return Meta:type(o, self, "Action")
end

function Action:from(project: Project.Project, name: string): Action
  assert(project ~= nil)
  assert(name ~= nil)
  return Action:new({
    project = project,
    name = name,
    props = Meta:array {},
    fetchers = Meta:array {},
  })
end

function Action:setup(children: {any}): Action
  local this = self::ActionImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Action:with_child(child: any): Action
  local this = self::ActionImpl
  local tag = Meta:typeof(child)
  if tag == 'Action.Prop' then
    this.props[#this.props + 1] = child
  elseif tag == 'Action.Fetch' then
    this.fetchers[#this.fetchers + 1] = child
  elseif tag == 'Action.Request' then
    this.request = child
  elseif tag == 'Action.Dialog' then
    this.dialog = child
  end
  return this
end

function Action:unwrap_action(): UnwrappedAction
  local this = self::ActionImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    props = Wrapper:unwrap_array(this.props),
  }
end

function Action:unwrap(): Unwrapped
  local this = self::ActionImpl
  return {
    project = this.project:unwrap_project(),
    request = this.request and this.request:unwrap(),
    dialog = this.dialog and this.dialog:unwrap(),
    fetchers = Wrapper:unwrap_array(this.fetchers),
    action = this:unwrap_action()
  }
end

return Action
