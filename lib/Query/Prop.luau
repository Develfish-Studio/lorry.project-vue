--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Prop = {}

export type Prop = typeof(Prop) & Wrapper.Unwrappable<Unwrapped>

export type PropProps = {
  name: string,
  ts_type: string?,
}

export type Unwrapped = Wrapper.UnwrappedName & {
  ts_type: string,
}

export type PropImpl = Prop & PropProps

function Prop:new(o: PropProps): Prop
  return Meta:type(o, self, "Query.Prop")
end

function Prop:from(name: string, ts_type: string?): Prop
  assert(name ~= nil)
  return Prop:new({
    name = name,
    ts_type = ts_type,
  })
end

function Prop:unwrap(): Unwrapped
  local this = self::PropImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    ts_type = this.ts_type or 'string',
  }
end

return Prop
