--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local PartTypes = require('./Part/PartTypes')

local Widget = {}

export type Widget = typeof(Widget) & PartTypes.Fieldset & Wrapper.Unwrappable<Unwrapped>

export type WidgetProps = {
  project: Project.Project,
  name: string,
}

export type UnwrappedWidget = Wrapper.UnwrappedName

export type Unwrapped = PartTypes.UnwrappedChild & {
  project: Project.UnwrappedProject,
  widget: UnwrappedWidget
}

export type WidgetImpl = Widget & WidgetProps

function Widget:new(o: WidgetProps): Widget
  return Meta:type(o, self, "Widget")
end

function Widget:from(project: Project.Project, name: string): Widget
  assert(project ~= nil)
  assert(name ~= nil)
  return Widget:new({
    project = project,
    name = name,
  })
end

function Widget:unwrap_widget(): UnwrappedWidget
  local this = self::WidgetImpl
  return Wrapper:unwrap_name(this.name)
end

function Widget:unwrap(): Unwrapped
  local this = self::WidgetImpl
  return {
    project = this.project:unwrap_project(),
    widget = this:unwrap_widget(),
  }
end

function Widget:get_name(): string
  local this = self::WidgetImpl
  return this.name
end

return Widget
