local function game(spriteSheet)
    local instance = { }

    instance.spriteSheet = spriteSheet

    function instance:setState(state)
        state.game = self
        self.state = state
    end

    function instance:update(dt)
        if self.state then
            self.state:update(dt)
        end
    end

    function instance:keypressed(key, isrepeat)
        if self.state then
            if self.state.keypressed then
                self.state:keypressed(key, isrepeat)
            end
        end
    end

    function instance:keyreleased(key)
        if self.state then
            if self.state.keyreleased then
                self.state:keyreleased(key)
            end
        end
    end

    function instance:draw(spriteBatch)
        if self.state then
            self.state:draw(spriteBatch)
        end
    end

    return instance
end

return game
