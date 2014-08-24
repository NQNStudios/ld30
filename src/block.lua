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

    function instance:update(dt)
        self.active = false

        for key, value in pairs(self.keys) do
            if (love.keyboard.isDown(value)) then
                self.active = true
            end
        end

        if self.otherBlock then
            if self.otherBlock.active then

                function checkHorizontal(direction)
                    local tileX = self.x / config.tileWidth
                    tileX = tileX + direction

                    local tileY = self.y / config.tileHeight

                    tileX = math.floor(tileX + 0.5)

                    local upperY = math.floor(tileY)
                    local lowerY = math.ceil(tileY)

                    local upperTile = self.map.tiles[tileX][upperY]
                    local lowerTile = self.map.tiles[tileX][lowerY]

                    if upperTile.solid then
                        tx, ty, tw, th = self.map:getPixelBounds(tileX, upperY)
                        bx, by, bw, bh = self:getPixelBounds()

                        if rectangle.intersects(tx, ty, tw, th, bx, by, bw, bh) then
                            self.x = (tileX - direction) * config.tileWidth
                            self.active = false
                        end
                    end

                    if lowerTile.solid then
                        tx, ty, tw, th = self.map:getPixelBounds(tileX, lowerY)
                        bx, by, bw, bh = self:getPixelBounds()

                        if rectangle.intersects(tx, ty, tw, th, bx, by, bw, bh) then
                            self.x = (tileX - direction) * config.tileWidth
                            self.active = false
                        end
                    end
                end

                function checkVertical(direction)
                    local tileX = self.x / config.tileWidth

                    local tileY = self.y / config.tileHeight
                    tileY = tileY + direction

                    tileY = math.floor(tileY + 0.5)

                    local leftX = math.floor(tileX)
                    local rightX = math.ceil(tileX)

                    local leftTile = self.map.tiles[leftX][tileY]
                    local rightTile = self.map.tiles[rightX][tileY]

                    if leftTile.solid then
                        -- check for collision with the left tile
                        tx, ty, tw, th = self.map:getPixelBounds(leftX, tileY)
                        bx, by, bw, bh = self:getPixelBounds()

                        if (rectangle.intersects(tx, ty, tw, th, bx, by, bw, bh)) then
                            self.y = (tileY - direction) * config.tileHeight
                            self.active = false
                        end
                    end

                    if rightTile.solid then
                        tx, ty, tw, th = self.map:getPixelBounds(leftX, tileY)
                        bx, by, bw, bh = self:getPixelBounds()

                        if (rectangle.intersects(tx, ty, tw, th, bx, by, bw, bh)) then
                            self.y = (tileY - direction) * config.tileHeight
                            self.active = false
                        end
                    end
                end

                -- TODO actually collide with walls and change color when crossing worlds
                if love.keyboard.isDown(self.keys.leftKey) then
                    self.x = self.x - self.speed * dt

                    checkHorizontal(-1)
                elseif love.keyboard.isDown(self.keys.rightKey) then
                    self.x = self.x + self.speed * dt

                    checkHorizontal(1)
                elseif love.keyboard.isDown(self.keys.upKey) then
                    self.y = self.y - self.speed * dt

                    checkVertical(-1)
                elseif love.keyboard.isDown(self.keys.downKey) then
                    self.y = self.y + self.speed * dt

                    checkVertical(1)
                end

            end
        end
    end

    function instance:draw(spriteBatch)
        spriteBatch:add(self.spriteSheet:getQuad(self.index), self.x, self.y)
    end

    function instance:getPixelBounds()
        return self.x, self.x, config.tileWidth, config.tileHeight
    end

    return instance
end

return block
