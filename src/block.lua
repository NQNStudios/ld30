local config = require "config"
local color = require "color"
local rectangle = require "rectangle"

local function block(spriteSheet, map, blockColor, x, y, speed)
    local instance = { }

    instance.spriteSheet = spriteSheet
    instance.map = map

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

    -- this function isn't strictly necessary but avoids unnecessary processing every frame (if the block isn't moving)
    function instance:update(dt)
        self.active = false

        for key, value in pairs(self.keys) do
            if (love.keyboard.isDown(value)) then
                self.active = true
            end
        end
    end

    function instance:checkMove(dt, level)
        local dx = 0
        local dy = 0

        if love.keyboard.isDown(self.keys.leftKey) then
            dx = -self.speed * dt
        elseif love.keyboard.isDown(self.keys.rightKey) then
            dx = self.speed * dt
        elseif love.keyboard.isDown(self.keys.upKey) then
            dy = -self.speed * dt
        elseif love.keyboard.isDown(self.keys.downKey) then
            dy = self.speed * dt
        end

        x, y, w, h = self:getPixelBounds()
        x = x + dx
        y = y + dy

        right = x + w
        bottom = y + h

        -- collide with walls
        local justBonked = false

        for c = 0, level.wallCount - 1 do
            local wx = level.walls[c].x
            local wy = level.walls[c].y
            local ww = level.walls[c].w
            local wh = level.walls[c].h
            
            if rectangle.intersects(x, y, w, h, wx, wy, ww, wh) then
                if not self.bonked then
                    level.game.sounds.bonk:play()
                    self.bonked = true
                end
                
                justBonked = true

                wright = wx + ww
                wbottom = wy + wh

                if dx < 0 then
                    -- check to the left
                    if x < wright then
                        x = wright
                    end
                elseif dx > 0 then
                    -- check to the right
                    if right > wx then
                        x = wx - ww
                    end
                end

                if dy < 0 then
                    -- check up
                    if y < wbottom then
                        y = wbottom
                    end
                elseif dy > 0 then
                    -- check down
                    if bottom > wy then
                        y = wy - wh
                    end
                end

                break -- don't keep checking collisions after one has been handled already
            end
        end

        if not justBonked then
            self.bonked = false
        end

        dx = x - self.x
        dy = y - self.y

        return dx, dy
    end

    instance.bonked = false

    function instance:move(dx, dy)
        self.x = self.x + dx 
        self.y = self.y + dy
    end

    function instance:draw(spriteBatch)
        spriteBatch:add(self.spriteSheet:getQuad(self.index), self.x, self.y)
    end

    function instance:getPixelBounds()
        local padX = config.blockPadding.x
        local padY = config.blockPadding.y

        return self.x - padX, self.y - padY, config.tileWidth - 2 * padX, config.tileHeight - 2 * padY
    end

    return instance
end

return block
