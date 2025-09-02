--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local PageTypes = require('./PageTypes')

local Prop = {}

export type Prop = typeof(Prop) & PageTypes.AnyChild & Wrapper.Unwrappable<Unwrapped>

export type PropSource =
  | 'route'

export type PropProps = {
  source: PropSource,
  name: string,
  ts_type: string?,
}

export type Unwrapped = PageTypes.UnwrappedChild & {
  source: PropSource,
  name: string,
  ts_type: string,
}

export type PropImpl = Prop & PropProps

function Prop:new(o: PropProps): Prop
  return Meta:type(o, self, "Page.Prop")
end

function Prop:from(source: PropSource, name: string, ts_type: string?): Prop
  assert(source ~= nil)
  assert(name ~= nil)
  return Prop:new({
    source = source,
    name = name,
    ts_type = ts_type,
  })
end

function Prop:from_route(name: string, ts_type: string?): Prop
  return Prop:from('route', name, ts_type)
end

function Prop:unwrap(): Unwrapped
  local this = self::PropImpl
  return {
    source = this.source,
    name = this.name,
    ts_type = this.ts_type or 'string',
  }
end

return Prop
