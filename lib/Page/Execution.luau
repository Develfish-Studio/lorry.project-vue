--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Query = require('../Query/Query')

local Execution = {}

export type Execution = typeof(Execution) & Wrapper.Unwrappable<Unwrapped>

export type ExecutionProps = {
  query: Query.Query,
  bindings: {[string]: any},
}

export type Unwrapped = {
  query: Query.Unwrapped,
  bindings: {[string]: any},
}

export type ExecutionImpl = Execution & ExecutionProps

function Execution:new(o: ExecutionProps): Execution
  return Meta:type(o, self, "Page.Execution")
end

function Execution:from(query, bindings: {[string]: any}): Execution
  return Query:new({
    query = query,
    bindings = bindings or Meta:table {},
  })
end

function Execution:unwrap(): Unwrapped
  local this = self::ExecutionImpl
  return {
    query = this.query:unwrap(),
    bindings = this.bindings,
  }
end

return Query
