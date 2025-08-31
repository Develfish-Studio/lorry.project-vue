--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')
local Structure = require('../../Structure/Structure')
local Remote = require('../Remote')
local Prop = require('./Prop')

local Request = {
  Prop = Prop,
}

export type Request = typeof(Request) & Wrapper.Unwrappable<Unwrapped>

export type RequestProps = {
  remote: Remote.Remote,
  name: string,
  method: string,
  path: string,
  body: any?,
  query: {}?,
  structure: Structure.Structure?,
  props: {Prop.Prop},
}

export type UnwrappedRequest = Wrapper.UnwrappedName & {
  method: string,
  path: string,
  body: any?,
  query: {}?,
  structure: Structure.Unwrapped?,
  props: {Prop.Unwrapped},
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  remote: Remote.UnwrappedRemote,
  request: UnwrappedRequest
}

export type RequestImpl = Request & RequestProps

export type AnyChild =
  | Prop.Prop

function Request:new(o: RequestProps): Request
  return Meta:type(o, self, "Transport.Request")
end

function Request:from(remote: Remote.Remote, name: string, method: string, path: string): Request
  assert(remote ~= nil)
  assert(name ~= nil)
  assert(method ~= nil)
  assert(path ~= nil)
  return Request:new({
    remote = remote,
    name = name,
    method = method,
    path = path,
    query = Meta:table {},
    props = Meta:array {},
  })
end

function Request:from_get(remote: Remote.Remote, name: string, path: string): Request
  return Request:from(remote, name, 'GET', path)
end

function Request:from_post(remote: Remote.Remote, name: string, path: string): Request
  return Request:from(remote, name, 'POST', path)
end

function Request:from_put(remote: Remote.Remote, name: string, path: string): Request
  return Request:from(remote, name, 'PUT', path)
end

function Request:from_patch(remote: Remote.Remote, name: string, path: string): Request
  return Request:from(remote, name, 'PATCH', path)
end

function Request:from_delete(remote: Remote.Remote, name: string, path: string): Request
  return Request:from(remote, name, 'DELETE', path)
end

function Request:with_name(name: string): Request
  local this = self::RequestImpl
  this.name = name
  return this
end

function Request:with_method(method: string): Request
  local this = self::RequestImpl
  this.method = method
  return this
end

function Request:with_body(body: any?): Request
  local this = self::RequestImpl
  this.body = body
  return this
end

function Request:with_query(query: {}?): Request
  local this = self::RequestImpl
  this.query = query
  return this
end

function Request:with_structure(structure: Structure.Structure): Request
  local this = self::RequestImpl
  this.structure = structure
  return this
end

function Request:setup(children: {AnyChild}): Request
  local this = self::RequestImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Request:with_child(child: AnyChild): Request
  local this = self::RequestImpl
  local tag = Meta:typeof(child)
  if tag == 'Transport.Request.Prop' then
    this.props[#this.props + 1] = child::Prop.Prop
  end
  return this
end

function Request:unwrap_request(): UnwrappedRequest
  local this = self::RequestImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    method = self.method,
    path = self.path,
    body = self.body,
    query = self.query,
    structure = self.structure and self.structure:unwrap_structure(),
    props = Wrapper:unwrap_array(self.props)
  }
end

function Request:unwrap(): Unwrapped
  local this = self::RequestImpl
  local remote = this.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = this:unwrap_request(),
  }
end

return Request
