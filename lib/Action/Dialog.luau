local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Dialog = {
  __type = 'Dialog',
  dialog = nil,
  bindings = nil,
}

function Dialog:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Dialog:from(dialog, bindings: table)
  return Dialog:new({
    dialog = dialog,
    bindings = bindings or Meta:table {},
  })
end

function Dialog:unwrap()
  return {
    dialog = self.dialog:unwrap(),
    bindings = self.bindings,
  }
end

return Dialog
