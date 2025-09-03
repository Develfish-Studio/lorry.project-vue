--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Prop = require('./Prop')
local Query = require('./Query')
local Heading = require('./Heading')
local Section = require('./Section')
local PageTypes = require('./PageTypes')

local Page = {
  Prop = Prop,
  Query = Query,
  Heading = Heading,
  Section = Section,
}

export type Page = typeof(Page) & Wrapper.Unwrappable<Unwrapped>

export type Layout = {
  flex: boolean
}

export type PageProps = {
  project: Project.Project,
  name: string,
  children: {PageTypes.AnyNode},
  queries: {PageTypes.Query},
  props: {PageTypes.Prop},
  layout: Layout,
}

export type UnwrappedPage = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  page: UnwrappedPage,
  children: {PageTypes.UnwrappedChild},
  queries: {PageTypes.UnwrappedChild},
  props: {PageTypes.UnwrappedChild},
  layout: Layout,
}

export type PageImpl = Page & PageProps

function Page:new(o: PageProps): Page
  return Meta:type(o, self, "Page")
end

function Page:from(project: Project.Project, name: string): Page
  assert(name ~= nil)
  return Page:new({
    project = project,
    name = name,
    children = Meta:array {},
    queries = Meta:array {},
    props = Meta:array {},
    layout = {
      flex = false,
    }
  })
end

function Page:with_flex(flex: boolean?): Page
  local this = self::PageImpl
  this.layout.flex = flex == nil or flex == true
  return this
end

function Page:setup(children: {PageTypes.AnyChild}): Page
  local this = self::PageImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Page:with_child(child: PageTypes.AnyChild): Page
  local this = self::PageImpl
  local tag = Meta:typeof(child)
  if tag == 'Page.Heading' then
    this.children[#this.children + 1] = child::PageTypes.Heading
  elseif tag == 'Page.Section' then
    this.children[#this.children + 1] = child::PageTypes.Section
  elseif tag == 'Page.Query' then
    this.queries[#this.queries + 1] = child::PageTypes.Query
  elseif tag == 'Page.Prop' then
    this.props[#this.props + 1] = child::PageTypes.Prop
  end
  return this
end

function Page:unwrap_page(): UnwrappedPage
  local this = self::PageImpl
  return Wrapper:unwrap_name(this.name)
end

function Page:unwrap(): Unwrapped
  local this = self::PageImpl
  return {
    project = this.project:unwrap_project(),
    page = this:unwrap_page(),
    children = Wrapper:unwrap_array(this.children),
    queries = Wrapper:unwrap_array(this.queries),
    props = Wrapper:unwrap_array(this.props),
    layout = this.layout,
  }
end

return Page
