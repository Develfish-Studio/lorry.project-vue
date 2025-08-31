local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Prop = {
  __type = 'Prop',
  name = nil,
  structure = nil,
  ts_type = nil,
  is_array = false,
}

function Prop:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Prop:from_type(name: string, ts_type: string)
  return Prop:new({
    name = name,
    ts_type = ts_type or 'string',
  })
end

function Prop:from_structure(name: string, structure: Structure)
  assert(structure ~= nil)
  return Prop:new({
    name = name,
    structure = structure,
  })
end

function Prop:from_structure_array(name: string, structure: Structure)
  assert(structure ~= nil)
  return Prop:new({
    name = name,
    structure = structure,
    is_array = true,
  })
end

function Prop:unwrap()
  return {
    name = self.name,
    structure = self.structure and self.structure:unwrap_structure() or nil,
    ts_type = self.ts_type,
    is_array = self.is_array,
  }
end

return Prop
