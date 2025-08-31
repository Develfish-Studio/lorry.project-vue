--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')

local Docker = {}

export type Docker = typeof(Docker)

export type DockerProps = {
  project: Project.Project,
  filename: string?,
  namespace: string?,
  version: string?,
  images: {string},
}

export type UnwrappedDocker = {
  filename: string,
  namespace: string,
  version: string,
  images: {string}
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  docker: UnwrappedDocker,
}

export type DockerImpl = Docker & DockerProps

function Docker:new(o: DockerProps): Docker
  return Meta:type(o, self, "Docker")
end

function Docker:from(project: Project.Project, images: {string}?): Docker
  return Docker:new({
    project = project,
    images = images or Meta:array {},
  })
end

function Docker:with_namespace(namespace: string): Docker
  local this = self::DockerImpl
  this.namespace = namespace
  return this
end

function Docker:with_version(version: string): Docker
  local this = self::DockerImpl
  this.version = version
  return this
end

function Docker:with_filename(filename: string): Docker
  local this = self::DockerImpl
  this.filename = filename
  return this
end

function Docker:with_image(image: string): Docker
  local this = self::DockerImpl
  this.images[#this.images + 1] = image
  return this
end

function Docker:unwrap_docker(): UnwrappedDocker
  local this = self::DockerImpl
  return {
    filename = this.filename or 'Dockerfile',
    namespace = this.namespace or this.project.name,
    version = this.version or '1.0.0',
    images = this.images
  }
end

function Docker:unwrap(): Unwrapped
  local this = self::DockerImpl
  return {
    project = this.project:unwrap_project(),
    docker = this:unwrap_docker(),
  }
end

return Docker
