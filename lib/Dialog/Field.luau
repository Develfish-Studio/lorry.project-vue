--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')
local Control = require('../Control/Control')
local Select = require('../Control/Select')
local Search = require('../Control/Search')
local EditorJS = require('../Control/EditorJS')
local UploadS3 = require('../Control/UploadS3')

local Field = {}

export type FieldKind =
  | 'Text'
  | 'Number'
  | 'Toggle'
  | 'Control.Select'
  | 'Control.Search'
  | 'Control.UploadS3'
  | 'Control.EditorJS'

export type Field = typeof(Field) & Wrapper.Unwrappable<Unwrapped>

export type FieldProps = {
  kind: FieldKind,
  control: Control.AnyEditableControl?,
  name: string?,
  value: string?,
  ts_type: string?,
  expression: string?,
}

export type UnwrappedField = Wrapper.UnwrappedName & {
  kind: FieldKind,
  ts_type: string,
  value: string?,
  expression: string?,
}

export type Unwrapped = {
  field: UnwrappedField,
  control: Control.UnwrappedEditable?
}

export type FieldImpl = Field & FieldProps

function Field:new(o: FieldProps): Field
  return Meta:type(o, self, "Dialog.Field")
end

function Field:from_select(control: Select.Select, name: string?): Field
  assert(control ~= nil)
  return Field:new({
    kind = 'Control.Select',
    control = control,
  })
end

function Field:from_search(control: Search.Search, name: string?): Field
  assert(control ~= nil)
  return Field:new({
    kind = 'Control.Search',
    control = control,
    name = name,
  })
end

function Field:from_upload_s3(control: UploadS3.UploadS3, name: string?): Field
  assert(control ~= nil)
  return Field:new({
    kind = 'Control.UploadS3',
    control = control,
    name = name,
  })
end

function Field:from_editor_js(control: EditorJS.EditorJS, name: string?): Field
  assert(control ~= nil)
  return Field:new({
    kind = 'Control.EditorJS',
    control = control,
    name = name,
  })
end

function Field:from_text(name: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'Text',
    name = name,
  })
end

function Field:from_number(name: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'Number',
    name = name,
    ts_type = 'number'
  })
end

function Field:from_toggle(name: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'Toggle',
    name = name,
    ts_type = 'boolean',
  })
end

function Field:with_value(value: string?): Field
  local this = self::FieldImpl
  this.value = value
  return this
end

function Field:with_ts_type(ts_type: string?): Field
  local this = self::FieldImpl
  this.ts_type = ts_type
  return this
end

function Field:with_expression(expression: string?): Field
  local this = self::FieldImpl
  this.expression = expression
  return this
end

function Field:unwrap_control(): Control.UnwrappedEditable?
  local this = self::FieldImpl
  if this.control ~= nil then
    local control = this.control
    local tag = Meta:typeof(control)
    if tag == 'Control.Select' then
      return (control::Select.Select):unwrap_select()
    elseif tag == 'Control.Search' then
      return (control::Search.Search):unwrap_search()
    elseif tag == 'Control.UploadS3' then
      return (control::UploadS3.UploadS3):unwrap_upload()
    elseif tag == 'Control.EditorJS' then
      return (control::EditorJS.EditorJS):unwrap_editor()
    end
  end
  return nil
end

function Field:unwrap_field(): UnwrappedField
  local this = self::FieldImpl
  local name = this.name or (assert(this.control)::Project.IHaveName):get_name()
  return Meta:append(Wrapper:unwrap_name(name)) {
    kind = this.kind,
    ts_type = this.ts_type or 'string',
    value = this.value,
    expression = this.expression,
  }
end

function Field:unwrap(): Unwrapped
  local this = self::FieldImpl
  return {
    field = this:unwrap_field(),
    control = this:unwrap_control(),
  }
end

return Field
