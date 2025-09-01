--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Request = require('../Transport/Request/Request')

local Fetch = {}

export type Fetch = typeof(Fetch) & Wrapper.Unwrappable<Unwrapped>

export type FetchProps = {
  request: Request.Request,
  name: string,
  bindings: {[string]: any},
}

export type Unwrapped = {
  request: Request.Unwrapped,
  name: string,
  bindings: {[string]: any},
}

export type FetchImpl = Fetch & FetchProps

function Fetch:new(o: FetchProps): Fetch
  return Meta:type(o, self, "Action.Fetch")
end

function Fetch:from(request, name: string, bindings: {[string]: any}?): Fetch
  return Fetch:new({
    request = request,
    name = name,
    bindings = bindings or Meta:table {},
  })
end

function Fetch:unwrap(): Unwrapped
  local this = self::FetchImpl
  return {
    request = this.request:unwrap(),
    name = this.name,
    bindings = this.bindings,
  }
end

return Fetch
