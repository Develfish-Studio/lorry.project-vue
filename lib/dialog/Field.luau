local Meta = require('core/Meta')
local case = require('core/util/string/case')

local Field = {
  __type = 'Field',
  kind = nil,
  control = nil,
  name = nil,
  value = nil,
  ts_type = 'string',
  expression = nil,
}

function Field:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Field:from_select(control: Select, name: string)
  return Field:new({
    kind = 'Select',
    control = control,
    name = name,
  })
end

function Field:from_text(name: string)
  return Field:new({
    kind = 'Text',
    name = name,
  })
end

function Field:from_number(name: string)
  return Field:new({
    kind = 'Number',
    name = name,
    ts_type = 'number'
  })
end

function Field:from_toggle(name: string)
  return Field:new({
    kind = 'Toggle',
    name = name,
    ts_type = 'boolean',
  })
end

function Field:from_upload_s3(control: UploadS3, name: string)
  return Field:new({
    kind = 'UploadS3',
    control = control,
    name = name,
  })
end

function Field:from_editor_js(control: EditorJS, name: string)
  return Field:new({
    kind = 'EditorJS',
    control = control,
    name = name,
  })
end

function Field:with_value(value: string)
  self.value = value
  return self
end

function Field:with_ts_type(ts_type: string)
  self.ts_type = ts_type
  return self
end

function Field:with_expression(expression: string)
  self.expression = expression
  return self
end

function Field:unwrap_control()
  if self.control == nil then
    return nil
  elseif self.control.__type == 'Select' then
    return self.control:unwrap_select()
  elseif self.control.__type == 'Search' then
    return self.control:unwrap_search()
  elseif self.control.__type == 'UploadS3' then
    return self.control:unwrap_upload()
  elseif self.control.__type == 'EditorJS' then
    return self.control:unwrap_editor()
  end
  return nil
end

function Field:unwrap_field()
  local name = self.name or self.control.name
  return {
    ts_type = self.ts_type,
    value = self.value,
    expression = self.expression,
    kind = self.kind,
    name = name,
    snake_name = name,
    camel_name = case.snakeToCamel(name),
    pascal_name = case.snakeToPascal(name),
    kebab_name = case.snakeToKebab(name),
    title_name = case.snakeToTitle(name),
  }
end

function Field:unwrap()
  return {
    field = self:unwrap_field(),
    control = self:unwrap_control(),
  }
end

return Field
