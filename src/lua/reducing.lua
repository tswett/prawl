local freeze = require 'freeze'

_ENV = freeze.frozen(_ENV)

local reducing = {}

local deboog = require 'deboog'
local exprs = require 'exprs'

function reducing.length(t)
    return #t
end

function reducing.reduce(functions, expr)
    deboog.print('reduce: entering, expr is ' .. tostring(expr))
    deboog.indent_level = deboog.indent_level + 1

    local intermediate = {}

    for i, v in ipairs(expr) do
        if i == 1 then
            intermediate[1] = expr[1]
        else
            intermediate[i] = reducing.reduce(functions, expr[i])
        end
    end

    deboog.print('reduce: intermediate is ' .. exprs.represent(intermediate))

    local head = intermediate[1]
    local result

    deboog.print('reduce: head is ' .. head)

    if functions[head] then
        deboog.print('reduce: recognized a function name')

        local parameters = table.move(intermediate, 2, #intermediate, 1, {}) -- all but the first element of intermediate
        deboog.print('reduce: parameters is ' .. exprs.represent(parameters))

        local call_result = functions[head](table.unpack(parameters))
        deboog.print('reduce: function result is ' .. tostring(call_result))

        result = reducing.reduce(functions, call_result)
    else
        deboog.print('reduce: did not recognize a function name')

        result = exprs.expr(intermediate)
    end

    deboog.indent_level = deboog.indent_level - 1
    deboog.print('reduce: exiting, result is ' .. tostring(result))

    return result
end

return reducing