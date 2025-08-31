--!strict

local Meta = require('@lorry.utils/lib/Meta')
local URI = require('@lorry.utils/lib/URI')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Remote = require('./Remote')

local Socket = {}

export type Socket = typeof(Socket) & Wrapper.Unwrappable<Unwrapped>

export type SocketProps = {
  project: Project.Project,
  name: string,
  base_url: string,
}

export type UnwrappedSocket = Wrapper.UnwrappedName & {
  base_url: string,
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  socket: UnwrappedSocket
}

export type SocketImpl = Socket & SocketProps

function Socket:new(o: SocketProps): Socket
  return Meta:type(o, self, "View.Socket")
end

function Socket:from(project: Project.Project, name: string, base_url: string): Socket
  assert(project ~= nil)
  assert(name ~= nil)
  assert(base_url ~= nil)
  return Socket:new({
    project = project,
    name = name,
    base_url = base_url
  })
end

function Socket:from_remote(remote: Remote.Remote, path: string, name: string?): Socket
  assert(remote ~= nil)
  local remote_impl = remote::Remote.RemoteImpl
  return Socket:new({
    project = remote_impl.project,
    name = name or remote_impl.name,
    base_url = URI
      :parse(remote_impl.base_url)
      :override_schema({ http = 'ws', https = 'wss' })
      :resolve(path)
      :format()
  })
end

function Socket:unwrap_socket(): UnwrappedSocket
  local this = self::SocketImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    base_url = this.base_url,
  }
end

function Socket:unwrap(): Unwrapped
  local this = self::SocketImpl
  return {
    project = this.project.unwrap_project(),
    socket = this:unwrap_socket(),
  }
end

return Socket
