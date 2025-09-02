--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local Query = require('../Query/Query')
local DialogTypes = require('./DialogTypes')

local Execution = {}

export type Execution = typeof(Execution) & DialogTypes.Execution & Wrapper.Unwrappable<Unwrapped>

export type Bindings = {[string]: any}

export type ExecutionProps = {
  query: Query.Query,
  bindings: Bindings,
}

export type Unwrapped =  DialogTypes.UnwrappedChild & {
  query: Query.Unwrapped,
  bindings: Bindings,
}

export type ExecutionImpl = Execution & ExecutionProps

function Execution:new(o: ExecutionProps): Execution
  return Meta:type(o, self, "Dialog.Execution")
end

function Execution:from(query, bindings: Bindings?): Execution
  return Execution:new({
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
