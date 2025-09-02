--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')
local Query = require('../Query/Query')
local Request = require('../Transport/Request/Request')
local Remote = require('../Transport/Remote')
local Filter = require('./Filter')
local Sorter = require('./Sorter')
local Handle = require('./Handle')
local Column = require('./Column')
local ToolbarTypes = require('./ToolbarTypes')

local Toolbar = {
  Filter = Filter,
  Sorter = Sorter,
  Handle = Handle,
  Column = Column,
}

export type Toolbar = typeof(Toolbar)

export type ToolbarProps = {
  query: Query.Query,
  name: string,
  columns: {ToolbarTypes.Column},
  filters: {ToolbarTypes.Filter},
  sorters: {ToolbarTypes.Sorter},
  handles: {ToolbarTypes.Handle},
}

export type UnwrappedToolbar = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  remote: Remote.UnwrappedRemote,
  request: Request.UnwrappedRequest,
  query: Query.UnwrappedQuery,
  toolbar: UnwrappedToolbar,
  filters: {ToolbarTypes.UnwrappedChild},
  sorters: {ToolbarTypes.UnwrappedChild},
  handles: {ToolbarTypes.UnwrappedChild},
  columns: {ToolbarTypes.UnwrappedChild},
}

export type ToolbarImpl = Toolbar & ToolbarProps

function Toolbar:new(o): Toolbar
  return Meta:type(o, self, "Toolbar")
end

function Toolbar:from_query(query: Query.Query, name: string): Toolbar
  assert(query ~= nil)
  assert(name ~= nil)
  return Toolbar
    :new({
      query = query,
      name = name,
      filters = Meta:array {},
      sorters = Meta:array {},
      handles = Meta:array {},
      columns = Meta:array {},
    })
end

function Toolbar:setup(children: {ToolbarTypes.AnyChild}): Toolbar
  local this = self::ToolbarImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Toolbar:with_child(child: ToolbarTypes.AnyChild): Toolbar
  local this = self::ToolbarImpl
  local tag = Meta:typeof(child)
  if tag == 'Toolbar.Filter' then
    this.filters[#this.filters + 1] = child::Filter.Filter
  elseif tag == 'Toolbar.Sorter' then
    this.sorters[#this.sorters + 1] = child::Sorter.Sorter
  elseif tag == 'Toolbar.Handle' then
    this.handles[#this.handles + 1] = child::Handle.Handle
  elseif tag == 'Toolbar.Column' then
    this.columns[#this.columns + 1] = child::Column.Column
  end
  return this
end

function Toolbar:unwrap_toolbar(): UnwrappedToolbar
  local this = self::ToolbarImpl
  return Wrapper:unwrap_name(this.name)
end

function Toolbar:unwrap(): Unwrapped
  local this = self::ToolbarImpl
  local query = this.query::Query.QueryImpl
  local request = query.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  local project = remote.project
  return {
    project = project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    query = query:unwrap_query(),
    toolbar = this:unwrap_toolbar(),
    filters = Wrapper:unwrap_array(this.filters),
    sorters = Wrapper:unwrap_array(this.sorters),
    handles = Wrapper:unwrap_array(this.handles),
    columns = Wrapper:unwrap_array(this.columns),
  }
end

return Toolbar
