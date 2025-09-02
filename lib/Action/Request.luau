--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local TransportRequest = require('../Transport/Request/Request')
local ActionTypes = require('./ActionTypes')

local Request = {}

export type Request = typeof(Request) & ActionTypes.Request & Wrapper.Unwrappable<Unwrapped>

export type RequestProps = {
  request: TransportRequest.Request,
  bindings: {[string]: any},
}

export type Unwrapped = ActionTypes.UnwrappedChild & {
  request: TransportRequest.Unwrapped,
  bindings: {[string]: any},
}

export type RequestImpl = Request & RequestProps

function Request:new(o: RequestProps): Request
  return Meta:type(o, self, "Action.Request")
end

function Request:from(request, bindings: {[string]: any}?): Request
  return Request:new({
    request = request,
    bindings = bindings or Meta:table {},
  })
end

function Request:unwrap(): Unwrapped
  local this = self::RequestImpl
  return {
    request = this.request:unwrap(),
    bindings = this.bindings,
  }
end

return Request
