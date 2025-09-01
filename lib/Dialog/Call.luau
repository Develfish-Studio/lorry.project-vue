--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Request = require('../Transport/Request/Request')

local Call = {}

export type Call = typeof(Call) & Wrapper.Unwrappable<Unwrapped>

export type CallKind =
  | 'submit'

export type CallProps = {
  kind: CallKind,
  request: Request.Request,
  expression: string?,
  bindings: {[string]: any},
}

export type UnwrappedCall = {
  kind: string,
  expression: string?
}

export type Unwrapped = {
  call: UnwrappedCall,
  request: Request.Unwrapped,
  bindings: {[string]: any},
}

export type CallImpl = Call & CallProps

function Call:new(o: CallProps): Call
  return Meta:type(o, self, "Dialog.Call")
end

function Call:from_submit(request: Request.Request, bindings: {[string]: any}?): Call
  assert(request ~= nil)
  return Call:new({
    kind = 'submit',
    request = request,
    bindings = bindings or Meta:table {},
  })
end

function Call:unwrap_call(): UnwrappedCall
  local this = self::CallImpl
  return {
    kind = this.kind,
    expression = this.expression,
  }
end

function Call:unwrap(): Unwrapped
  local this = self::CallImpl
  return {
    call = this:unwrap_call(),
    request = this.request:unwrap(),
    bindings = this.bindings,
  }
end

return Call
