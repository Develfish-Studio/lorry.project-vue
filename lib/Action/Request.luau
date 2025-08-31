local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Request = {
  __type = 'Request',
  request = nil,
  bindings = nil,
}

function Request:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Request:from(request, bindings: table)
  return Request:new({
    request = request,
    bindings = bindings or Meta:table {},
  })
end

function Request:unwrap()
  return {
    request = self.request:unwrap(),
    bindings = self.bindings,
  }
end

return Request
