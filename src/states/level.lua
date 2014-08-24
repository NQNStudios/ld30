local map = require "map"
local config = require "config"
local block = require "block"
local color = require "color"

local function levelstate(game, level)
    local instance = { }

    instance.level = level

    instance.map = map(game.spriteSheet, config.mapWidth, config.mapHeight, config.tileWidth, config.tileHeight, "data/levels/level" .. level .. ".txt")

    instance.blocks = { }

    local blueX = instance.map.points[color.blue].x1 * config.tileWidth
    local blueY = instance.map.points[color.blue].y1 * config.tileHeight
    instance.blocks[color.blue] = block(game.spriteSheet, instance.map, color.blue, blueX, blueY, config.normalSpeed)

    local orangeX = instance.map.points[color.orange].x1 * config.tileWidth
    local orangeY = instance.map.points[color.orange].y1 * config.tileHeight
    instance.blocks[color.orange] = block(game.spriteSheet, instance.map, color.orange, orangeX, orangeY, config.normalSpeed)

    -- Link the two blocks together
    instance.blocks[color.blue].otherBlock = instance.blocks[color.orange]
    instance.blocks[color.orange].otherBlock = instance.blocks[color.blue]

    function instance:update(dt)
        self.blocks[color.blue]:update(dt)
        self.blocks[color.orange]:update(dt)
    end

    function instance:keypressed(key, isrepeat)
        if config.debug then
            if key == "right" then
                local nextState = levelstate(game, self.level + 1)

                game:setState(nextState)
            elseif key == "left" then
                local nextState = levelstate(game, self.level - 1)

                game:setState(nextState)
            end
        end
    end

    function instance:draw(spriteBatch)
        self.map:draw(spriteBatch)

        self.blocks[color.blue]:draw(spriteBatch)
        self.blocks[color.orange]:draw(spriteBatch)
    end

    return instance
end

return levelstate
