--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Project = require('@lorry.project/lib/Project')
local Field = require('./Field')
local Query = require('../Query/Query')
local Request = require('../Transport/Request/Request')
local Remote = require('../Transport/Remote')

local Fieldset = {
  Field = Field,
}

export type Fieldset = typeof(Fieldset) & Wrapper.Unwrappable<Unwrapped>

export type FieldsetProps = {
  query: Query.Query,
  name: string,
  fields: {Field.Field},
}

export type UnwrappedFieldset = Wrapper.UnwrappedName

export type Unwrapped = {
  project: Project.UnwrappedProject,
  fieldset: UnwrappedFieldset,
  query: Query.UnwrappedQuery,
  fields: {Field.Unwrapped},
}

export type FieldsetImpl = Fieldset & FieldsetProps

export type AnyChild =
  | Field.Field

function Fieldset:new(o: FieldsetProps): Fieldset
  return Meta:type(o, self, "Fieldset")
end

function Fieldset:from_query(query: Query.Query, name: string): Fieldset
  assert(query ~= nil)
  assert(name ~= nil)
  return Fieldset
    :new({
      query = query,
      name = name,
      fields = Meta:array {},
    })
end

function Fieldset:setup(children: {AnyChild}): Fieldset
  local this = self::FieldsetImpl
  for _, child in children do
    this:with_child(child)
  end
  return this
end

function Fieldset:with_child(child: AnyChild): Fieldset
  local this = self::FieldsetImpl
  local tag = Meta:typeof(child)
  if tag == 'Fieldset.Field' then
    this.fields[#this.fields + 1] = child::Field.Field
  end
  return this
end


function Fieldset:unwrap_fieldset(): UnwrappedFieldset
  local this = self::FieldsetImpl
  return Wrapper:unwrap_name(this.name)
end

function Fieldset:unwrap(): Unwrapped
  local this = self::FieldsetImpl
  local query = this.query::Query.QueryImpl
  local request = query.request::Request.RequestImpl
  local remote = request.remote::Remote.RemoteImpl
  return {
    project = remote.project:unwrap_project(),
    query = query:unwrap_query(),
    fieldset = this:unwrap_fieldset(),
    fields = Wrapper:unwrap_array(this.fields),
  }
end

return Fieldset
