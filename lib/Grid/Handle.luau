--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Action = require('../Action/Action')

local Handle = {}

export type Handle = typeof(Handle) & Wrapper.Unwrappable<Unwrapped>

export type Message = {
  event: string,
  data: any
}

export type HandleProps = {
  action: Action.Action,
  name: string,
  icon: string?,
  expression: string?,
  on_success: {Message},
  on_failure: {Message},
}

export type UnwrappedHandle = Wrapper.UnwrappedName & {
  icon: string?,
  expression: string?,
}

export type Unwrapped = {
  handle: UnwrappedHandle,
  action: Action.UnwrappedAction
}

export type HandleImpl = Handle & HandleProps

function Handle:new(o: HandleProps): Handle
  return Meta:type(o, self, "Grid.Handle")
end

function Handle:from(action: Action.Action, name: string): Handle
  assert(name ~= nil)
  return Handle:new({
    action = action,
    name = name,
    on_success = Meta:array {},
    on_failure = Meta:array {}
  })
end

function Handle:with_icon(icon: string): Handle
  local this = self::HandleImpl
  this.icon = icon
  return this
end

function Handle:with_expression(expression: string): Handle
  local this = self::HandleImpl
  this.expression = expression
  return this
end

function Handle:with_on_success(event: string, data)
  local this = self::HandleImpl
  this.on_success[#this.on_success + 1] = {
    event = event,
    data = data
  }
  return this
end

function Handle:with_on_failure(event: string, data)
  local this = self::HandleImpl
  this.on_failure[#this.on_failure + 1] = {
    event = event,
    data = data
  }
  return this
end

function Handle:unwrap_handle(): UnwrappedHandle
  local this = self::HandleImpl
  local name = this.name or (assert(this.action)::Action.ActionImpl).name
  return Meta:append(Wrapper:unwrap_name(name)) {
    expression = this.expression,
    icon = this.icon,
  }
end

function Handle:unwrap(): Unwrapped
  local this = self::HandleImpl
  return {
    handle = this:unwrap_handle(),
    action = this.action:unwrap_action(),
    on_failure = this.on_failure,
    on_success = this.on_success,
  }
end

return Handle
