--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Request = require('../Transport/Request/Request')
local Remote = require('../Transport/Remote')

local Select = {}

export type Select = typeof(Select) & Wrapper.Unwrappable<Unwrapped>

export type Locator = {
  name: string,
  path: string,
  ts_type: string,
}

export type SelectProps = {
  request: Request.Request,
  name: string,
  field_id: Locator?,
  field_name: Locator?,
  field_description: Locator?,
}

export type UnwrappedSelect = Wrapper.UnwrappedName & {
  field_id: Locator?,
  field_name: Locator?,
  field_description: Locator?,
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  select: UnwrappedSelect,
  remote: Remote.UnwrappedRemote,
  request: Request.UnwrappedRequest,
}

export type SelectImpl = Select & SelectProps

function Select:new(o: SelectProps): Select
  return Meta:type(o, self, "Control.Select")
end

function Select:from_request(request: Request.Request, name: string): Select
  assert(request ~= nil)
  assert(name ~= nil)
  return Select:new({
    request = request,
    name = name,
  })
end

function Select:with_field_id(name: string, path: string?, ts_type: string?): Select
  local this = self::SelectImpl
  this.field_id = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Select:with_field_name(name: string, path: string?, ts_type: string?): Select
  local this = self::SelectImpl
  this.field_name = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Select:with_field_description(name: string, path: string?, ts_type: string?): Select
  local this = self::SelectImpl
  this.field_description = {
    name = name,
    path = path or name,
    ts_type = ts_type or 'string'
  }
  return this
end

function Select:unwrap_select(): UnwrappedSelect
  local this = self::SelectImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    field_id = this.field_id or { name = 'id', path = 'id', ts_type = 'string' },
    field_name = this.field_name or { name = 'name', path = 'name', ts_type = 'string' },
    field_description = this.field_description,
  }
end

function Select:unwrap(): Unwrapped
  local this = self::SelectImpl
  local request = this.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    select = this:unwrap_select(),
  }
end

return Select
