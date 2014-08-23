color = require "color"

local function block(spriteSheet, blockColor, x, y, speed)
    local instance = { }

    instance.spriteSheet = spriteSheet
    instance.color = blockColor
    instance.x = x
    instance.y = y
    instance.speed = speed

    instance.active = false

    instance.keys = { }

    -- on initialization, make sure the block has an index and assign it controls
    if instance.color == color.blue then
        instance.index = 0
        
        instance.keys.upKey = "w"
        instance.keys.leftKey = "a"
        instance.keys.downKey = "s"
        instance.keys.rightKey = "d"
    elseif instance.color == color.orange then
        instance.index = 1

        instance.keys.upKey = "up"
        instance.keys.leftKey = "left"
        instance.keys.downKey = "down"
        instance.keys.rightKey = "right"
    end

    function instance:update(dt)
        self.active = false

        for key, value in pairs(self.keys) do
            if (love.keyboard.isDown(value)) then
                self.active = true
                -- TODO account for running into walls (possible exploit
            end
        end

        if self.otherBlock then
            if self.otherBlock.active then

                -- TODO actually collide with walls and change color when crossing worlds
                if love.keyboard.isDown(self.keys.leftKey) then
                    self.x = self.x - self.speed * dt
                elseif love.keyboard.isDown(self.keys.rightKey) then
                    self.x = self.x + self.speed * dt
                elseif love.keyboard.isDown(self.keys.upKey) then
                    self.y = self.y - self.speed * dt
                elseif love.keyboard.isDown(self.keys.downKey) then
                    self.y = self.y + self.speed * dt
                end

            end
        end
    end

    function instance:draw(spriteBatch)
        spriteBatch:add(self.spriteSheet:getQuad(self.index), self.x, self.y)
    end

    return instance
end

return block
