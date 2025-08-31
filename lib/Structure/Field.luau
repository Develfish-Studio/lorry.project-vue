--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Field = {}

export type Field = typeof(Field) & Wrapper.Unwrappable<Unwrapped>

export type FieldKind =
  | 'field'
  | 'object'
  | 'array'

export type Structure = Wrapper.Unwrappable<any>

export type FieldProps = {
  kind: FieldKind,
  name: string,
  ts_type: string?, -- typescript type
  nested: Structure?, -- nested structure if ts_type is not defined
  required: boolean?,
  fallback_value: any?,
  fields: {Field},
}

export type Unwrapped = {
    name: string,
    kind: string,
    ts_type: string?,
    nested: any?,
    required: boolean,
    fallback_value: any?,
    fields: {Unwrapped}?,
}

export type FieldImpl = Field & FieldProps

export type AnyChild =
  | Field

function Field:new(o: FieldProps): Field
  return Meta:type(o, self, "Structure.Field")
end

function Field:from_field(name: string, ts_type: string): Field
  assert(name ~= nil)
  assert(ts_type ~= nil)
  return Field:new({
    kind = 'field',
    name = name,
    ts_type = ts_type,
    fields = Meta:array {}
  })
end

function Field:from_array(name: string, ts_type: string?, nested: Structure?): Field
  assert(name ~= nil)
  assert(ts_type ~= nil or nested ~= nil)
  return Field:new({
    name = name,
    kind = 'array',
    ts_type = ts_type,
    nested = nested,
    fields = Meta:array {},
  })
end

function Field:from_object(name: string, ts_type: string?, nested: Structure?): Field
  assert(name ~= nil)
  assert(ts_type ~= nil or nested ~= nil)
  return Field:new({
    name = name,
    kind = 'object',
    ts_type = ts_type,
    nested = nested,
    fields = Meta:array {},
  })
end

function Field:from_any(name: string): Field
  return Field:from_field(name, 'any')
end

function Field:from_unknown(name: string): Field
  return Field:from_field(name, 'unknown')
end

function Field:from_string(name: string): Field
  return Field:from_field(name, 'string')
end

function Field:from_number(name: string): Field
  return Field:from_field(name, 'number')
end

function Field:from_boolean(name: string): Field
  return Field:from_field(name, 'boolean')
end

function Field:from_structure(name: string, nested: Structure): Field
  return Field:from_object(name, nil, nested)
end

function Field:setup(children: {AnyChild}): Field
  local this = self::FieldImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Field:with_child(child: AnyChild): Field
  local this = self::FieldImpl
  local tag = Meta:typeof(child)
  if tag == 'Structure.Field' then
    this.fields[#this.fields + 1] = child::Field
  end
  return this
end

function Field:with_fallback_value(fallback_value: string): Field
  local this = self::FieldImpl
  this.fallback_value = fallback_value
  return this
end

function Field:with_ts_type(ts_type: string): Field
  local this = self::FieldImpl
  this.ts_type = ts_type
  return this
end

function Field:with_required(required: boolean?): Field
  local this = self::FieldImpl
  this.required = required == nil or required == true
  return this
end

function Field:unwrap(): Unwrapped
  local this = self::FieldImpl
  return {
    name = this.name,
    kind = this.kind,
    ts_type = this.ts_type,
    required = this.required or false,
    fallback_value = this.fallback_value,
    fields = Wrapper:unwrap_array_or_nil(this.fields),
    nested = this.nested and this.nested:unwrap(),
  }
end

return Field
