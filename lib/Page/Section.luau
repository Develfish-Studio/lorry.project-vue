--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Grid = require('../Grid/Grid')
local Toolbar = require('../Toolbar/Toolbar')

local Section = {}

export type Section = typeof(Section) & Wrapper.Unwrappable<Unwrapped>

export type SectionKind =
  | 'widget'
  | 'toolbar'
  | 'fieldset'
  | 'grid'

export type Variable = {
  name: string,
  value: string,
}

export type SectionProps = {
  name: string,
  kind: SectionKind,
  component: Wrapper.Unwrappable<any>?,
  variables: {Variable},
  roles: {string},
}

export type UnwrappedSection = Wrapper.UnwrappedName & {
  kind: SectionKind,
}

export type Unwrapped = {
  section: UnwrappedSection,
  roles: {string},
  component: any,
  variables: {Variable},
}

export type SectionImpl = Section & SectionProps

function Section:new(o: SectionProps): Section
  return Meta:type(o, self, "Page.Section")
end

function Section:from(kind: SectionKind, name: string): Section
  assert(kind ~= nil)
  assert(name ~= nil)
  return Section:new({
    kind = kind,
    name = name,
    variables = Meta:array {},
    roles = Meta:array {}
  })
end

function Section:from_grid(grid: Grid.Grid): Section
  assert(grid ~= nil)
  return Section:new({
    kind = 'grid',
    name = grid.name,
    component = grid,
    variables = Meta:array {},
    roles = Meta:array {}
  })
end

function Section:from_fieldset(fieldset: Fieldset.Fieldset)
  assert(fieldset ~= nil)
  return Section:new({
    kind = 'fieldset',
    name = fieldset.name,
    component = fieldset,
    variables = Meta:array {},
    roles = Meta:array {}
  })
end

function Section:from_widget(widget: Widget.Widget): Section
  assert(widget ~= nil)
  return Section:new({
    kind = 'widget',
    name = widget.name,
    component = widget,
    variables = Meta:array {},
    roles = Meta:array {}
  })
end

function Section:from_toolbar(toolbar: Toolbar.Toolbar): Section
  assert(toolbar ~= nil)
  return Section:new({
    kind = 'toolbar',
    name = toolbar.name,
    component = toolbar,
    variables = Meta:array {},
    roles = Meta:array {}
  })
end

function Section:with_variable(name: string, value: string): Section
  local this = self::SectionImpl
  this.variables[#this.variables + 1] = {
    name = name,
    value = value,
  }
  return this
end

function Section:with_role(role: string): Section
  local this = self::SectionImpl
  this.roles[#this.roles + 1] = role
  return this
end

function Section:unwrap_section(): UnwrappedSection
  local this = self::SectionImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    kind = this.kind,
  }
end

function Section:unwrap()
  return {
    type = 'section',
    requires_auth = self.requires_auth,
    roles = self.roles,
    section = self:unwrap_section(),
    component = self.component:unwrap(),
    variables = self.variables,
  }
end

return Section
