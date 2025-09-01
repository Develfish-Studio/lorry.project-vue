--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Heading = {}

export type Heading = typeof(Heading) & Wrapper.Unwrappable<Unwrapped>

export type HeadingTag = 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6'

export type HeadingProps = {
  name: string,
  tag: HeadingTag?,
  roles: {string},
}

export type UnwrappedHeading = Wrapper.UnwrappedName & {
  tag: HeadingTag?,
}

export type Unwrapped = {
  type: string,
  heading: UnwrappedHeading,
  roles: {string}
}

export type HeadingImpl = Heading & HeadingProps

function Heading:new(o: HeadingProps): Heading
  return Meta:type(o, self, "Page.Heading")
end

function Heading:from(name: string, tag: HeadingTag?): Heading
  return Heading:new({
    name = name,
    tag = tag,
    roles = Meta:array {}
  })
end

function Heading:with_role(role: string): Heading
  local this = self::HeadingImpl
  this.roles[#this.roles + 1] = role
  return this
end

function Heading:unwrap_heading(): UnwrappedHeading
  local this = self::HeadingImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    tag = this.tag,
  }
end

function Heading:unwrap(): Unwrapped
  local this = self::HeadingImpl
  return {
    type = Meta:typeof(this),
    heading = this:unwrap_heading(),
    roles = this.roles,
  }
end

return Heading
