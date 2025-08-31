local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Fetch = {
  __type = 'Fetch',
  request = nil,
  name = nil,
  bindings = nil,
}

function Fetch:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Fetch:from(request, name: string, bindings: table)
  return Fetch:new({
    request = request,
    name = name,
    bindings = bindings or Meta:table {},
  })
end

function Fetch:unwrap()
  return {
    request = self.request:unwrap(),
    name = self.name,
    bindings = self.bindings,
  }
end

return Fetch
