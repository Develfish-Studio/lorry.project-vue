--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local DialogRef = require('../Dialog/Dialog')

local Dialog = {}

export type Dialog = typeof(Dialog) & Wrapper.Unwrappable<Unwrapped>

export type DialogProps = {
  dialog: DialogRef.Dialog,
  bindings: {[string]: any},
}

export type Unwrapped = {
  dialog: DialogRef.Unwrapped,
  bindings: {[string]: any},
}

export type DialogImpl = Dialog & DialogProps

function Dialog:new(o: DialogProps): Dialog
  return Meta:type(o, self, "Action.Dialog")
end

function Dialog:from(dialog: DialogRef.Dialog, bindings: {[string]: any}?): Dialog
  return Dialog:new({
    dialog = dialog,
    bindings = bindings or Meta:table {},
  })
end

function Dialog:unwrap(): Unwrapped
  local this = self::DialogImpl
  return {
    dialog = this.dialog:unwrap(),
    bindings = this.bindings,
  }
end

return Dialog
