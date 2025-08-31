--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Selector = {}

export type Selector = typeof(Selector) & Wrapper.Unwrappable<Unwrapped>

export type Filter = {
  type: string,
  value: string,
}

export type SelectorProps = {
  headers: {[string]: Filter},
  properties: {[string]: Filter},
}

export type Unwrapped = SelectorProps

export type SelectorImpl = Selector & SelectorProps

function Selector:new(o: SelectorProps): Selector
  return Meta:type(o, self, "Transport.Selector")
end

function Selector:from(): Selector
  return Selector:new({
    headers = Meta:table {},
    properties = Meta:table {},
  })
end

function Selector:from_header(name: string, value: string, type: string?): Selector
  return Selector
    :from()
    :with_header(name, value, type)
end

function Selector:from_property(name: string, value: string, type: string?): Selector
  return Selector
    :from()
    :with_property(name, value, type)
end

function Selector:with_header(name: string, value: string, type: string?): Selector
  local this = self::SelectorImpl
  this.headers[name] = {
    type = type or 'EQUAL',
    value = value,
  }
  return this
end

function Selector:with_property(name: string, value: string, type: string?): Selector
  local this = self::SelectorImpl
  this.properties[name] = {
    type = type or 'EQUAL',
    value = value,
  }
  return this
end

function Selector:unwrap(): Unwrapped
  local this = self::SelectorImpl
  return {
    headers = this.headers,
    properties = this.properties,
  }
end

return Selector
