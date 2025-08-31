--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Field = require('./Field')

local Structure = {
  Field = Field
}

export type Structure = typeof(Structure) & Field.Structure & Wrapper.Unwrappable<Unwrapped>

export type StructureKind =
  | 'simple'
  | 'object'
  | 'array'

export type StructureProps = {
  project: Project.Project,
  kind: StructureKind,
  name: string,
  ts_type: string?,
  nested: Structure?,
  required: boolean?,
  fields: {Field.Field},
}

export type UnwrappedStructure = Wrapper.UnwrappedName & {
  ts_type: string?,
  nested: {Unwrapped}?,
  required: boolean,
  fields: {Field.Unwrapped}?,
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  structure: UnwrappedStructure,
}

export type StructureImpl = Structure & StructureProps

export type AnyChild =
  | Field.Field

function Structure:new(o: StructureProps): Structure
  return Meta:type(o, self, "Structure")
end

function Structure:from_object(project: Project.Project, name: string, ts_type: string?, nested: Structure?): Structure
  assert(project ~= nil)
  assert(name ~= nil)
  return Structure:new({
    project = project,
    name = name,
    kind = 'object',
    ts_type = ts_type,
    nested = nested,
    fields = Meta:array {},
  })
end

function Structure:from_array(project: Project.Project, name: string, ts_type: string?, nested: Structure?)
  assert(project ~= nil)
  assert(name ~= nil)
  return Structure:new({
    project = project,
    name = name,
    kind = 'array',
    ts_type = ts_type,
    nested = nested,
    fields = Meta:array {},
  })
end

function Structure:setup(children: {AnyChild}): Structure
  local this = self::StructureImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Structure:with_child(child: AnyChild): Structure
  local this = self::StructureImpl
  local tag = Meta:typeof(child)
  if tag == 'Structure.Field' then
    this.fields[#this.fields + 1] = child::Field.Field
  end
  return this
end

function Structure:with_required(required: boolean)
  if required == nil then
    required = true
  end
  self.required = required
  return self
end

function Structure:unwrap_structure(): UnwrappedStructure
  local this = self::StructureImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    kind = this.kind,
    ts_type = this.ts_type,
    nested = this.nested and this.nested:unwrap(),
    required = this.required or false,
    fields = Wrapper:unwrap_array_or_nil(this.fields),
  }
end

function Structure:unwrap()
  return {
    project = self.project:unwrap_project(),
    structure = self:unwrap_structure(),
  }
end

return Structure
