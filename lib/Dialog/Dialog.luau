--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Prop = require('./Prop')
local Execution = require('./Execution')
local Field = require('./Field')
local Call = require('./Call')

local Dialog = {
  Prop = Prop,
  Execution = Execution,
  Field = Field,
  Call = Call,
}

export type Dialog = typeof(Dialog) & Wrapper.Unwrappable<Unwrapped>

export type DialogProps = {
  project: Project.Project,
  name: string,
  props: {Prop.Prop},
  queries: {Execution.Execution},
  fields: {Field.Field},
  calls: {Call.Call},
}

export type UnwrappedDialog = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  dialog: UnwrappedDialog,
  props: {Prop.Unwrapped},
  fields: {Field.Unwrapped},
  queries: {Execution.Unwrapped},
  calls: {submit: Call.Unwrapped?}
}

export type AnyChild =
  | Prop.Prop
  | Execution.Execution
  | Field.Field
  | Call.Call

export type DialogImpl = Dialog & DialogProps

function Dialog:new(o: DialogProps): Dialog
  return Meta:type(o, self, "Dialog")
end

function Dialog:from(project: Project.Project, name: string): Dialog
  assert(project ~= nil)
  assert(name ~= nil)
  return Dialog:new({
    project = project,
    name = name,
    props = Meta:array {},
    fields = Meta:array {},
    calls = Meta:array {},
    queries = Meta:array {},
  })
end

function Dialog:setup(children: {AnyChild}): Dialog
  local this = self::DialogImpl
  for _, child in children do
    this:with_child(child::AnyChild)
  end
  return this
end

function Dialog:with_child(child: AnyChild): Dialog
  local this = self::DialogImpl
  local tag = Meta:typeof(child)
  if tag == 'Dialog.Call' then
    this.calls[#this.calls + 1] = child::Call.Call
  elseif tag == 'Dialog.Field' then
    this.fields[#this.fields + 1] = child::Field.Field
  elseif tag == 'Dialog.Execution' then
    this.queries[#this.queries + 1] = child::Execution.Execution
  elseif tag == 'Dialog.Prop' then
    this.props[#this.props + 1] = child::Prop.Prop
  end
  return this
end

function Dialog:unwrap_calls(): {submit: Call.Unwrapped?}
  local calls = Meta:table {
    submit = nil,
  }
  for _, call in self.calls do
    if call.kind == 'submit' then
      calls.submit = call:unwrap()
    end
  end
  return calls
end

function Dialog:unwrap_dialog(): UnwrappedDialog
  local this = self::DialogImpl
  return Wrapper:unwrap_name(this.name)
end

function Dialog:unwrap(): Unwrapped
  local this = self::DialogImpl
  return {
    project = this.project:unwrap_project(),
    dialog = this:unwrap_dialog(),
    props = Wrapper:unwrap_array(this.props),
    fields = Wrapper:unwrap_array(this.fields),
    queries = Wrapper:unwrap_array(this.queries),
    calls = this:unwrap_calls(),
  }
end

return Dialog
