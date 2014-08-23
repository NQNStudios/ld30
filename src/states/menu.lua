level = require "states/level"
local function menu()
    local instance = { }

    function instance:update(dt)
    end

    function instance:keypressed(key, isrepeat)
        if key == " " then
            local nextState = level(self.game, 1)

            self.game:setState(nextState)
        end
    end

    function instance:draw(spriteBatch)
        love.graphics.print("Press SPACE to play.", 0, 0)
    end

    return instance
end

return menu
