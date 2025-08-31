--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')
local Remote = require('../Transport/Remote')
local Request = require('../Transport/Request/Request')
local Filter = require('./Filter')
local Sorter = require('./Sorter')
local Prop = require('./Prop')

local Query = {
  Filter = Filter,
  Sorter = Sorter,
  Prop = Prop,
}

export type Query = typeof(Query) & Wrapper.Unwrappable<Unwrapped>

export type QueryProps = {
  request: Request.Request,
  name: string,
  filters: {Filter.Filter},
  sorters: {Sorter.Sorter},
  props: {Prop.Prop},
}

export type UnwrappedQuery = Wrapper.UnwrappedName

export type Unwrapped = {
  query: UnwrappedQuery,
  project: Project.UnwrappedProject,
  remote: Remote.UnwrappedRemote,
  request: Request.UnwrappedRequest,
  filters: {Filter.Unwrapped},
  sorters: {Sorter.Unwrapped},
  props: {Prop.Unwrapped},
}

export type QueryImpl = Query & QueryProps

export type AnyChild =
  | Filter.Filter
  | Sorter.Sorter
  | Prop.Prop

function Query:new(o: QueryProps): Query
  return Meta:type(o, self, "Query")
end

function Query:from_request(request: Request.Request, name: string): Query
  assert(request ~= nil)
  assert(name ~= nil)
  return Query
    :new({
      request = request,
      name = name,
      filters = Meta:array {},
      sorters = Meta:array {},
      props = Meta:array {},
    })
end

function Query:setup(children: {AnyChild}): Query
  local this = self::QueryImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Query:with_child(child: AnyChild): Query
  local this = self::QueryImpl
  local tag = Meta:typeof(child)
  if tag == 'Query.Filter' then
    this.filters[#this.filters + 1] = child::Filter.Filter
  elseif tag == 'Query.Sorter' then
    this.sorters[#this.sorters + 1] = child::Sorter.Sorter
  elseif tag == 'Query.Prop' then
    this.props[#this.props + 1] = child::Prop.Prop
  end
  return this
end

function Query:unwrap_query(): UnwrappedQuery
  local this = self::QueryImpl
  return Wrapper:unwrap_name(this.name)
end

function Query:unwrap(): Unwrapped
  local this = self::QueryImpl
  local request = this.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    remote = request.remote:unwrap_remote(),
    request = request:unwrap_request(),
    query = this:unwrap_query(),
    filters = Wrapper:unwrap_array(this.filters),
    sorters = Wrapper:unwrap_array(this.sorters),
    props = Wrapper:unwrap_array(this.props),
  }
end

return Query
