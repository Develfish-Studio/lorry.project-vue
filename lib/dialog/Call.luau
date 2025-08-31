local Meta = require('core/Meta')
local case = require('core/util/string/case')
local Request = require('vue/Request')

local Call = {
  __type = 'Call',
  request = nil,
  kind = nil,
  expression = nil,
  bindings = nil,
}

function Call:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Call:from_submit(request: Request, bindings: table)
  assert(request ~= nil)
  return Call:new({
    kind = 'submit',
    request = request,
    bindings = bindings or Meta:table {},
  })
end

function Call:unwrap_call()
  return {
    kind = self.kind,
    expression = self.expression,
  }
end

function Call:unwrap()
  return {
    call = self:unwrap_call(),
    request = self.request:unwrap(),
    bindings = self.bindings,
  }
end

return Call
