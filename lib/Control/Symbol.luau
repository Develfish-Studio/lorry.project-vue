--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Symbol = {}

export type Symbol = typeof(Symbol) & Wrapper.Unwrappable<Unwrapped>

export type Variable = {
  name: string,
  value: string,
  ts_type: string?
}

export type Import = {
  name: string,
  aliases: {string},
}

export type SymbolProps = {
  project: Project.Project,
  name: string,
  label: string?,
  image: string?,
  icon: string?,
  route: string?,
  decoration: string?,
  variables: {Variable},
  imports: {Import},
}

export type UnwrappedSymbol = Wrapper.UnwrappedName

export type UnwrappedConfig = {
  label: string?,
  image: string?,
  icon: string?,
  route: string?,
  decoration: string?,
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  symbol: UnwrappedSymbol,
  config: UnwrappedConfig,
  variables: {Variable},
  imports: {Import},
}

export type SymbolImpl =
  & Symbol
  & SymbolProps
  & Project.IHaveProject
  & Project.IHaveName

function Symbol:new(o): Symbol
  return Meta:type(o, self, "Control.Symbol")
end

function Symbol:from(project: Project.Project, name: string): Symbol
  assert(project ~= nil)
  assert(name ~= nil)
  return Symbol:new({
    project = project,
    name = name,
    variables = Meta:array {},
    imports = Meta:array {},
  })
end

function Symbol:with_label(label: string): Symbol
  local this = self::SymbolImpl
  this.label = label
  return this
end

function Symbol:with_icon(icon: string): Symbol
  local this = self::SymbolImpl
  this.icon = icon
  return this
end

function Symbol:with_image(image: string): Symbol
  local this = self::SymbolImpl
  this.image = image
  return this
end

function Symbol:with_route(route: string): Symbol
  local this = self::SymbolImpl
  this.route = route
  return this
end

function Symbol:with_decoration(decoration: string): Symbol
  local this = self::SymbolImpl
  this.decoration = decoration
  return this
end

function Symbol:with_variable(name: string, value: any, ts_type: string?): Symbol
  local this = self::SymbolImpl
  this.variables[#this.variables + 1] = {
    name = name,
    value = value,
    type = ts_type,
  }
  return this
end

function Symbol:with_record(name: string, value: {[string]: any}): Symbol
  local this = self::SymbolImpl
  return this:with_variable(name, value, 'Record<string, any>')
end

function Symbol:with_import(name: string, aliases: {string}): Symbol
  local this = self::SymbolImpl
  this.imports[#this.imports + 1] = {
    name = name,
    aliases = aliases,
  }
  return this
end

function Symbol:unwrap_symbol(): UnwrappedSymbol
  local this = self::SymbolImpl
  return Wrapper:unwrap_name(this.name)
end

function Symbol:unwrap_config(): UnwrappedConfig
  local this = self::SymbolImpl
  return {
    label = this.label,
    icon = this.icon,
    image = this.image,
    route = this.route,
    decoration = this.decoration,
  }
end

function Symbol:unwrap(): Unwrapped
  local this = self::SymbolImpl
  return {
    project = this.project:unwrap_project(),
    symbol = this:unwrap_symbol(),
    config = this:unwrap_config(),
    variables = this.variables,
    imports = this.imports,
  }
end

function Symbol:get_project(): Project.Project
  local this = self::SymbolImpl
  return this.project
end

function Symbol:get_name(): string
  local this = self::SymbolImpl
  return this.name
end

return Symbol
