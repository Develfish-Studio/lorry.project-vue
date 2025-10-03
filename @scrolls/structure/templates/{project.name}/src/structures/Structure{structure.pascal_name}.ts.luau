function visit_root(structure)
  local imports = {}

  local declaration = 'type Structure' .. structure.pascal_name
  local definition = visit_structure(imports, structure)

  local imports_string = ''
  if #imports > 0 then
    for _, name in imports do
      imports_string = imports_string .. 'import { type ' .. name .. ' } from "./'.. name .. '"' .. '\n'
    end
    imports_string = imports_string .. '\n'
  end

  return imports_string .. 'export ' .. declaration .. ' = ' .. definition
end

function visit_structure(imports: table, node)
  if node.kind == 'array' then
    return visit_array(0, imports, node)
  elseif node.kind == 'object' then
    return visit_object(0, imports, node)
  else
    return visit_type(0, imports, node)
  end
end

function visit_type(level: number, imports: table, node)
  if node.ts_type ~= nil then
    return node.ts_type
  else
    return 'unknown'
  end
end

function visit_array(level: number, imports: table, node)
  if node.ts_type ~= nil then
    return node.ts_type .. '[]'
  elseif node.nested ~= nil then
    local nested_name = 'Structure' .. node.nested.structure.pascal_name
    imports[#imports + 1] = nested_name
    return nested_name .. '[]'
  else
    return 'Array<' .. visit_object(level, imports, node) .. '>'
  end
end

function visit_object(level: number, imports: table, node)
  if node.ts_type ~= nil then
    return node.ts_type
  elseif node.nested ~= nil then
    local nested_name = 'Structure' .. node.nested.structure.pascal_name
    imports[#imports + 1] = nested_name
    return nested_name
  else
    local lines = {}

    local bracket_intendation = string.rep('  ', level)
    local intendation = string.rep('  ', level + 1)
    for _, f in node.fields do
      local line = nil
      local declaration = intendation .. f.name .. (f.required == true and '' or '?')
      if f.kind == 'array' then
        definition = visit_array(level + 1, imports, f)
      elseif f.kind == 'object' then
        definition = visit_object(level + 1, imports, f)
      else
        definition = visit_type(level + 1, imports, f)
      end
      lines[#lines + 1] = declaration .. ': ' .. definition
    end

    return '{\n' .. table.concat(lines, '\n') .. '\n' .. bracket_intendation .. '}'
  end
end

template:println(visit_root(structure))
