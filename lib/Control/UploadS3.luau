--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Project = require('@lorry.project/lib/Project')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Request = require('../Transport/Request/Request')
local Remote = require('../Transport/Remote')

local UploadS3 = {}

export type UploadS3 = typeof(UploadS3) & Wrapper.Unwrappable<Unwrapped>

export type UploadS3Props = {
  request: Request.Request,
  name: string,
  accept: string?,
  bucket: string?,
  directory: string?,
  check_content_type: boolean?,
  check_content_length: boolean?,
}

export type UnwrappedUpload = Wrapper.UnwrappedName & {
  accept: string?,
  bucket: string?,
  directory: string?,
  check_content_type: boolean,
  check_content_length: boolean,
}

export type Unwrapped = {
  project: Project.UnwrappedProject,
  request: Request.UnwrappedRequest,
  upload: UnwrappedUpload,
}

export type UploadS3Impl = UploadS3 & UploadS3Props

function UploadS3:new(o: UploadS3Props): UploadS3
  return Meta:type(o, self, "Control.UploadS3")
end

function UploadS3:from_request(request: Request.Request, name: string): UploadS3
  assert(request ~= nil)
  assert(name ~= nil)
  return UploadS3:new({
    request = request,
    name = name,
  })
end

function UploadS3:with_accept(accept: string?): UploadS3
  local this = self::UploadS3Impl
  this.accept = accept
  return this
end

function UploadS3:with_bucket(bucket: string?): UploadS3
  local this = self::UploadS3Impl
  this.bucket = bucket
  return this
end

function UploadS3:with_directory(directory: string?): UploadS3
  local this = self::UploadS3Impl
  this.directory = directory
  return this
end

function UploadS3:with_check_content_type(check_content_type: boolean?): UploadS3
  local this = self::UploadS3Impl
  this.check_content_type = check_content_type == nil or check_content_type == true
  return this
end

function UploadS3:with_check_content_length(check_content_length: boolean): UploadS3
  local this = self::UploadS3Impl
  this.check_content_length = check_content_length == nil or check_content_length == true
  return this
end

function UploadS3:unwrap_upload(): UnwrappedUpload
  local this = self::UploadS3Impl
  local unwrapped_name = Wrapper:unwrap_name(this.name)
  return Meta:append(unwrapped_name) {
    accept = this.accept,
    directory = this.directory,
    bucket = this.bucket or unwrapped_name.kebab_name,
    check_content_length = this.check_content_length or false,
    check_content_type = this.check_content_type or false,
  }
end

function UploadS3:unwrap(): Unwrapped
  local this = self::UploadS3Impl
  local request = this.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    remote = remote:unwrap_remote(),
    request = request:unwrap_request(),
    upload = this:unwrap_upload(),
  }
end

return UploadS3
