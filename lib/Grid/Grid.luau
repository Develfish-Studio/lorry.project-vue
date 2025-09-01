--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Query = require('../Query/Query')
local Column = require('./Column')
local Handle = require('./Handle')

local Grid = {
  Column = Column,
  Handle = Handle,
}

export type Grid = typeof(Grid)

export type GridProps = {
  query: Query.Query,
  name: string,
  columns: {Column.Column},
  handles: {Handle.Handle},
}

export type UnwrappedGrid = Wrapper.UnwrappedName

export type Unwrapped = {
  grid: UnwrappedGrid,
}

export type GridImpl = Grid & GridProps

export type AnyChild =
  | Column.Column
  | Handle.Handle

function Grid:new(o: GridProps): Grid
  return Meta:type(o, self, "Grid")
end

function Grid:from_query(query: Query.Query, name: string): Grid
  assert(query ~= nil)
  return Grid
    :new({
      query = query,
      name = name,
      columns = Meta:array {},
      handles = Meta:array {},
    })
end

function Grid:setup(children: {AnyChild}): Grid
  local this = self::GridImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Grid:with_child(child: AnyChild): Grid
  local this = self::GridImpl
  local tag = Meta:typeof(child)
  if tag == 'Grid.Column' then
    this.columns[#this.columns + 1] = child::Column.Column
  elseif tag == 'Grid.Handle' then
    this.handles[#this.handles + 1] = child::Handle.Handle
  end
  return this
end

function Grid:unwrap_grid(): UnwrappedGrid
  local this = self::GridImpl
  local name = this.name or (this.query::Query.QueryImpl).name
  return Wrapper:unwrap_name(name)
end

function Grid:unwrap(): Unwrapped
  local this = self::GridImpl
  local query = self.query
  local request = query.request
  local remote = request.remote
  local project = remote.project
  return {
    project = project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    query = query:unwrap_query(),
    grid = this:unwrap_grid(),
    columns = Wrapper:unwrap_array(this.columns),
    handles = Wrapper:unwrap_array(this.handles),
  }
end

return Grid
