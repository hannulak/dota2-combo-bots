local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

function M.Think(database_table, algorithms_implementation)
  local result = {}

  for algorithm, desires in pairs(database_table) do
    if algorithms_implementation[algorithm] == nil then
      goto continue end

    local desire_index = functions.ternary(
      algorithms_implementation[algorithm](),
      1,
      2)

    for key, value in pairs(desires) do
      if result[key] ~= nil then
        result[key] = result[key] + functions.PercentToDesire(value[desire_index])
      else
        result[key] = functions.PercentToDesire(value[desire_index])
      end
    end
    ::continue::
  end

  return result
end

return M
