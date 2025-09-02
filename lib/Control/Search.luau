--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Request = require('../Transport/Request/Request')
local Remote = require('../Transport/Remote')
local ControlTypes = require('./ControlTypes')

local Search = {}

export type Search = typeof(Search) & ControlTypes.Search & Wrapper.Unwrappable<Unwrapped>

export type Locator = {
  name: string,
  path: string,
  ts_type: string,
}

export type SearchProps = {
  request: Request.Request,
  name: string,
  field_id: Locator?,
  field_name: Locator?,
  field_description: Locator?,
}

export type UnwrappedSearch = Wrapper.UnwrappedName & {
  field_id: Locator?,
  field_name: Locator?,
  field_description: Locator?,
}

export type Unwrapped = ControlTypes.UnwrappedEditable & {
  project: Project.UnwrappedProject,
  search: UnwrappedSearch,
  remote: Remote.UnwrappedRemote,
  request: Request.UnwrappedRequest,
}

export type SearchImpl =
  & Search
  & SearchProps
  & Project.IHaveProject
  & Project.IHaveName

function Search:new(o: SearchProps): Search
  return Meta:type(o, self, "Control.Search")
end

function Search:from_request(request: Request.Request, name: string): Search
  assert(request ~= nil)
  assert(name ~= nil)
  return Search:new({
    request = request,
    name = name,
  })
end

function Search:with_field_id(name: string, path: string?, ts_type: string?): Search
  local this = self::SearchImpl
  this.field_id = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Search:with_field_name(name: string, path: string?, ts_type: string?): Search
  local this = self::SearchImpl
  this.field_name = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Search:with_field_description(name: string, path: string?, ts_type: string?): Search
  local this = self::SearchImpl
  this.field_description = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Search:unwrap_search(): UnwrappedSearch
  local this = self::SearchImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    field_id = this.field_id or { name = 'id', path = 'id', ts_type = 'string' },
    field_name = this.field_name or { name = 'name', path = 'name', ts_type = 'string' },
    field_description = this.field_description,
  }
end

function Search:unwrap(): Unwrapped
  local this = self::SearchImpl
  local request = this.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    search = this:unwrap_search(),
  }
end

function Search:get_project(): Project.Project
  local this = self::SearchImpl
  local request = this.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return remote.project
end

function Search:get_name(): string
  local this = self::SearchImpl
  return this.name
end

return Search
