--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Symbol = require('../Control/Symbol')

local Field = {}

export type Field = typeof(Field) & Wrapper.Unwrappable<Unwrapped>

export type FieldKind =
  | 'path'
  | 'template'
  | 'symbol'

export type FieldProps = {
  kind: FieldKind,
  name: string,
  path: string?,
  symbol: Symbol.Symbol?,
  template: string?,
}

export type UnwrappedField = Wrapper.UnwrappedName & {
  kind: FieldKind,
  path: string?,
  template: string?,
}

export type Unwrapped = {
  field: UnwrappedField,
  symbol: Symbol.UnwrappedSymbol?,
}

export type FieldImpl = Field & FieldProps

function Field:new(o: FieldProps): Field
  return Meta:type(o, self, "Fieldset.Field")
end

function Field:from_path(name: string, path: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'path',
    name = name,
    path = path,
  })
end

function Field:from_template(name: string, template: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'template',
    name = name,
    template = template,
  })
end

function Field:from_symbol(name: string, symbol: Symbol.Symbol, path: string): Field
  assert(name ~= nil)
  return Field:new({
    kind = 'symbol',
    name = name,
    symbol = symbol,
    path = path,
  })
end

function Field:unwrap_field(): UnwrappedField
  local this = self::FieldImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    kind = this.kind,
    path = this.path,
    template = this.template,
  }
end

function Field:unwrap(): Unwrapped
  local this = self::FieldImpl
  return {
    field = this:unwrap_field(),
    symbol = this.symbol and this.symbol:unwrap_symbol(),
  }
end

return Field
