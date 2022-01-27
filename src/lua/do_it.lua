deboog = require 'deboog'
-- deboog.enable = true

reducing = require 'reducing'
expr = (require 'exprs').expr

local function not_(e)
    if e[1] == 'true' then
        return expr {'false'}
    elseif e[1] == 'false' then
        return expr {'true'}
    else
        return e
    end
end

print(reducing.reduce({['not'] = not_}, expr {'not', {'not', {'not', {'false'}}}}))