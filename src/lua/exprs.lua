local freeze = require 'freeze'

_ENV = freeze.frozen(_ENV)

local exprs = {}

exprs.expr_metatable = {}

function exprs.expr_metatable.__tostring(expr)
    return 'expr ' .. exprs.represent(expr)
end

function exprs.represent(expr)
    if type(expr) == 'string' then
        return string.format('%q', expr)
    elseif type(expr) == 'table' then
        local output = '{'
        local need_separator = false

        for i, v in ipairs(expr) do
            if need_separator then
                output = output .. ', '
            end

            output = output .. exprs.represent(v)

            need_separator = true
        end

        output = output .. '}'

        return output
    else
        return tostring(expr)
    end
end

function exprs.expr(input)
    if type(input) == 'table' then
        local expr = {}
        setmetatable(expr, exprs.expr_metatable)

        for i, v in ipairs(input) do
            expr[i] = exprs.expr(v)
        end

        return expr
    else
        return input
    end
end

return exprs