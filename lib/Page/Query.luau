--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local QueryRef = require('../Query/Query')
local PageTypes = require('./PageTypes')

local Query = {}

export type Query = typeof(Query) & PageTypes.AnyChild & Wrapper.Unwrappable<Unwrapped>

export type QueryProps = {
  query: QueryRef.Query,
  bindings: {[string]: any},
}

export type Unwrapped = PageTypes.UnwrappedChild & {
  query: QueryRef.Unwrapped,
  bindings: {[string]: any},
}

export type QueryImpl = Query & QueryProps

function Query:new(o: QueryProps): Query
  return Meta:type(o, self, "Page.Query")
end

function Query:from(query, bindings: {[string]: any}?): Query
  return Query:new({
    query = query,
    bindings = bindings or Meta:table {},
  })
end

function Query:unwrap(): Unwrapped
  local this = self::QueryImpl
  return {
    query = this.query:unwrap(),
    bindings = this.bindings,
  }
end

return Query
