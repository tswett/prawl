local freeze = require 'freeze'

_ENV = freeze.frozen(_ENV)

local deboog = {}

deboog.indent_level = 0

function deboog.print(message)
    if deboog.enable then
        local indentation = ''
        for x = 1, deboog.indent_level do
            indentation = indentation .. '  '
        end

        print(indentation .. message)
    end
end

function deboog.footest()
    return 'foo'
end

return deboog