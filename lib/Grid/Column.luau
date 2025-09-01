--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Symbol = require('../Control/Symbol')

local Column = {}

export type Column = typeof(Column) & Wrapper.Unwrappable<Unwrapped>

export type ColumnKind =
  | 'path'
  | 'template'
  | 'symbol'

export type Variable = {
  name: string,
  value: string,
}

export type ColumnProps = {
  kind: ColumnKind,
  name: string,
  path: string?,
  symbol: Symbol.Symbol?,
  template: string?,
  variables: {Variable},
}

export type UnwrappedColumn = Wrapper.UnwrappedName & {
  kind: ColumnKind,
  path: string?,
  template: string?,
}

export type Unwrapped = {
  column: UnwrappedColumn,
  symbol: Symbol.UnwrappedSymbol?,
  variables: {Variable}
}

export type ColumnImpl = Column & ColumnProps

function Column:new(o: ColumnProps): Column
  return Meta:type(o, self, "Grid.Column")
end

function Column:from_path(name: string, path: string): Column
  assert(name ~= nil)
  assert(path ~= nil)
  return Column:new({
    kind = 'path',
    name = name,
    path = path or name,
    variables = Meta:array {},
  })
end

function Column:from_template(name: string, template: string): Column
  assert(name ~= nil)
  assert(template ~= nil)
  return Column:new({
    kind = 'template',
    name = name,
    template = template,
    variables = Meta:array {},
  })
end

function Column:from_symbol(name: string, symbol: Symbol.Symbol, path: string?): Column
  assert(name ~= nil)
  assert(symbol ~= nil)
  return Column:new({
    kind = 'symbol',
    name = name,
    symbol = symbol,
    path = path,
    variables = Meta:array {},
  })
end

function Column:with_variable(name: string, value: string): Column
  local this = self::ColumnImpl
  this.variables[#this.variables + 1] = {
    name = name,
    value = value,
  }
  return this
end

function Column:unwrap_column(): UnwrappedColumn
  local this = self::ColumnImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    kind = this.kind,
    path = this.path,
    template = this.template,
  }
end

function Column:unwrap(): Unwrapped
  local this = self::ColumnImpl
  return {
    column = this:unwrap_column(),
    symbol = this.symbol and this.symbol:unwrap_symbol(),
    variables = this.variables,
  }
end

return Column
