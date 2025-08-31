local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Query = {
  __type = 'Query',
  query = nil,
  bindings = nil,
}

function Query:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Query:from(query, bindings: table)
  return Query:new({
    query = query,
    bindings = bindings or Meta:table {},
  })
end

function Query:unwrap()
  return {
    query = self.query:unwrap(),
    bindings = self.bindings,
  }
end

return Query
