--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Structure = require('../Structure/Structure')
local DialogTypes = require('./DialogTypes')

local Prop = {}

export type Prop = typeof(Prop) & DialogTypes.Prop & Wrapper.Unwrappable<Unwrapped>

export type PropProps = {
  name: string,
  structure: Structure.Structure?,
  ts_type: string?,
  is_array: boolean?,
  is_optional: boolean?,
}

export type Unwrapped = DialogTypes.UnwrappedChild & {
  name: string,
  structure: Structure.UnwrappedStructure?,
  ts_type: string?,
  is_array: boolean,
  is_optional: boolean,
}

export type PropImpl = Prop & PropProps

function Prop:new(o: PropProps): Prop
  return Meta:type(o, self, "Dialog.Prop")
end

function Prop:from_type(name: string, ts_type: string?): Prop
  assert(name ~= nil)
  return Prop:new({
    name = name,
    ts_type = ts_type,
  })
end

function Prop:from_structure(name: string, structure: Structure.Structure): Prop
  assert(name ~= nil)
  assert(structure ~= nil)
  return Prop:new({
    name = name,
    structure = structure,
  })
end

function Prop:from_structure_array(name: string, structure: Structure.Structure): Prop
  assert(name ~= nil)
  assert(structure ~= nil)
  return Prop:new({
    name = name,
    structure = structure,
    is_array = true,
  })
end

function Prop:with_optional(is_optional: boolean?): Prop
  local this = self::PropImpl
  this.is_optional = is_optional == nil or is_optional == true
  return this
end

function Prop:with_array(is_array: boolean?): Prop
  local this = self::PropImpl
  this.is_array = is_array == nil or is_array == true
  return this
end

function Prop:unwrap(): Unwrapped
  local this = self::PropImpl
  return {
    name = this.name,
    structure = this.structure and this.structure:unwrap_structure(),
    ts_type = this.ts_type,
    is_array = this.is_array or false,
    is_optional = this.is_optional or false,
  }
end

return Prop
