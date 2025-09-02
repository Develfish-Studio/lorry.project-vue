--!strict

local Meta = require('@lorry.utils/lib/Meta')
local Wrapper = require('@lorry.project/lib/Wrapper')
local ToolbarTypes = require('./ToolbarTypes')

local Column = {}

export type Column = typeof(Column) & ToolbarTypes.Column & Wrapper.Unwrappable<Unwrapped>

export type ColumnProps = {
  name: string,
  ts_type: string?,
}

export type UnwrappedColumn = Wrapper.UnwrappedName & {
  ts_type: string,
}

export type Unwrapped = ToolbarTypes.UnwrappedChild & {
  column: UnwrappedColumn
}

export type ColumnImpl = Column & ColumnProps

function Column:new(o: ColumnProps): Column
  return Meta:type(o, self, "Toolbar.Column")
end

function Column:from(name: string, ts_type: string?): Column
  assert(name ~= nil)
  return Column:new({
    name = name,
    ts_type= ts_type,
  })
end

function Column:unwrap_column(): UnwrappedColumn
  local this = self::ColumnImpl
  return Meta:append(Wrapper:unwrap_name(this.name)) {
    ts_type = self.ts_type,
  }
end

function Column:unwrap(): Unwrapped
  local this = self::ColumnImpl
  return {
    column = this:unwrap_column()
  }
end

return Column
