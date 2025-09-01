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
  name: string?,
  severity: string?,
  require_selection: boolean?,
  on_success: {Message},
  on_failure: {Message},
  bindings: {[string]: string},
}

export type UnwrappedHandle = Wrapper.UnwrappedName & {
  severity: string?,
  require_selection: boolean?,
  bindings: {[string]: string},
}

export type Unwrapped = {
  handle: UnwrappedHandle,
  action: Action.UnwrappedAction,
  on_success: {Message},
  on_failure: {Message},
}

export type HandleImpl = Handle & HandleProps

function Handle:new(o: HandleProps): Handle
  return Meta:type(o, self, "Toolbar.Handle")
end

function Handle:from(action: Action.Action, name: string?): Handle
  assert(action ~= nil)
  return Handle:new({
    action = action,
    name = name,
    bindings = Meta:table {},
    on_success = Meta:array {},
    on_failure = Meta:array {},
  })
end

function Handle:with_selection(require_selection: boolean): Handle
  local this = self::HandleImpl
  this.require_selection = require_selection
  return this
end

function Handle:with_severity(severity: string): Handle
  local this = self::HandleImpl
  this.severity = severity
  return this
end

function Handle:with_on_success(event: string, data): Handle
  local this = self::HandleImpl
  this.on_success[#this.on_success + 1] = {
    event = event,
    data = data
  }
  return this
end

function Handle:with_on_failure(event: string, data): Handle
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
    require_selection = this.require_selection,
    severity = this.severity,
    bindings = this.bindings,
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
