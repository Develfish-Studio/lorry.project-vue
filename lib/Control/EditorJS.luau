--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local ControlTypes = require('./ControlTypes')

local EditorJS = {}

export type EditorJS = typeof(EditorJS) & ControlTypes.EditorJS & Wrapper.Unwrappable<Unwrapped>

export type EditorJSProps = {
  project: Project.Project,
  name: string,
  tools: {string}
}

export type UnwrappedEditor = Wrapper.UnwrappedName

export type Unwrapped = ControlTypes.UnwrappedEditable & {
  project: Project.UnwrappedProject,
  editor: UnwrappedEditor,
  tools: {string},
}

export type EditorJSImpl =
  & EditorJS
  & EditorJSProps
  & Project.IHaveProject
  & Project.IHaveName

function EditorJS:new(o: EditorJSProps): EditorJS
  return Meta:type(o, self, "Control.EditorJS")
end

function EditorJS:from(project: Project.Project, name: string)
  assert(project ~= nil)
  assert(name ~= nil)
  return EditorJS:new({
    project = project,
    name = name,
    tools = Meta:array {}
  })
end

function EditorJS:with_tool(tool: string): EditorJS
  local this = self::EditorJSImpl
  this.tools[#this.tools + 1] = tool
  return this
end

function EditorJS:unwrap_editor(): UnwrappedEditor
  local this = self::EditorJSImpl
  return Wrapper:unwrap_name(this.name)
end

function EditorJS:unwrap(): Unwrapped
  local this = self::EditorJSImpl
  return {
    project = this.project:unwrap_project(),
    editor = this:unwrap_editor(),
    tools = this.tools,
  }
end

function EditorJS:get_project(): Project.Project
  local this = self::EditorJSImpl
  return this.project
end

function EditorJS:get_name(): string
  local this = self::EditorJSImpl
  return this.name
end

return EditorJS
