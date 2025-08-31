--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Socket = require('../Transport/Socket')

local Root = {}

export type Root = typeof(Root)

export type RootProps = {
  project: Project.Project,
  name: string,
  routers: {string},
  menus: {string},
  sockets: {Socket.Socket},
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  root: Wrapper.UnwrappedName,
  routers: {Wrapper.UnwrappedName},
  menus: {Wrapper.UnwrappedName},
  sockets: {Socket.UnwrappedSocket},
}

export type RootImpl = Root & RootProps & Wrapper.Unwrappable<Unwrapped>

function Root:new(o: RootProps): Root
  return Meta:type(o, self, "Root")
end

function Root:from(project: Project.Project, name: string?): Root
  assert(project ~= nil)
  return Root:new({
    project = project,
    name = name or project.name,
    routers = Meta:array {},
    menus = Meta:array {},
    sockets = Meta:array {},
  })
end

function Root:with_router(name: string): Root
  local this = self::RootImpl
  this.routers[#this.routers + 1] = name
  return this
end

function Root:with_menu(name: string): Root
  local this = self::RootImpl
  this.menus[#this.menus + 1] = name
  return this
end

function Root:with_socket(socket: Socket.Socket): Root
  local this = self::RootImpl
  this.sockets[#this.sockets + 1] = socket
  return this
end

function Root:unwrap_project(): Wrapper.UnwrappedName
  local this = self::RootImpl
  return Wrapper:unwrap_name(this.name)
end

function Root:unwrap_menus(): {Wrapper.UnwrappedName}
  local this = self::RootImpl
  local menus = Meta:array {}
  for _, menu in this.menus do
    menus[#menus + 1] = Wrapper:unwrap_name(menu)
  end
  return menus
end

function Root:unwrap_routers(): {Wrapper.UnwrappedName}
  local this = self::RootImpl
  local routers = Meta:array {}
  for _, router in this.routers do
    routers[#routers + 1] = Wrapper:unwrap_name(router)
  end
  return routers
end

function Root:unwrap_sockets(): {Socket.UnwrappedSocket}
  local this = self::RootImpl
  local sockets = Meta:array {}
  for _, socket in this.sockets do
    sockets[#sockets + 1] = socket:unwrap_socket()
  end
  return sockets
end

function Root:unwrap(): Unwrapped
  local this = self::RootImpl
  return {
    root = Wrapper:unwrap_name(this.name),
    project = this.project:unwrap_project(),
    routers = this:unwrap_routers(),
    menus = this:unwrap_menus(),
    sockets = this:unwrap_sockets(),
  }
end

return Root
