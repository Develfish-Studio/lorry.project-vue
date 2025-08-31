--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')

local Remote = {}

export type Remote = typeof(Remote) & Wrapper.Unwrappable<Unwrapped>

export type RemoteProps = {
  project: Project.Project,
  name: string,
  base_url: string,
}

export type UnwrappedRemote = Wrapper.UnwrappedName & {
  base_url: string
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  remote: UnwrappedRemote
}

export type RemoteImpl = Remote & RemoteProps

function Remote:new(o: RemoteProps): Remote
  return Meta:type(o, self, "Remote")
end

function Remote:from(project: Project.Project, name: string, base_url: string): Remote
  assert(project ~= nil)
  assert(name ~= nil)
  assert(base_url ~= nil)
  return Remote:new({
    project = project,
    name = name,
    base_url = base_url
  })
end

function Remote:unwrap_remote(): UnwrappedRemote
  local this = self::RemoteImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    base_url = this.base_url,
  }
end

function Remote:unwrap(): Unwrapped
  local this = self::RemoteImpl
  return {
    project = this.project:unwrap_project(),
    remote = this:unwrap_remote(),
  }
end

return Remote
