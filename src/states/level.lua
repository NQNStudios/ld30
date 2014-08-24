local rectangle = require "rectangle"
local map = require "map"
local config = require "config"
local block = require "block"
local color = require "color"

local function levelstate(game, level)
    local instance = { }

    instance.level = level

    function instance:nextLevel()
        local nextState = levelstate(game, self.level + 1)
        game:setState(nextState)
    end

    function instance:resetLevel()
        local nextState = levelstate(game, self.level)
        game:setState(nextState)
    end

    instance.map = map(game.spriteSheet, config.mapWidth, config.mapHeight, config.tileWidth, config.tileHeight, "data/levels/level" .. level .. ".txt")

    instance.walls = { }

    local c = 0
    for x = 0, instance.map.width - 1 do
        for y = 0, instance.map.height - 1 do
            if instance.map.tiles[y][x].solid then
                -- retrieve the wall rectangles
                instance.walls[c] = { }
                instance.walls[c].x, instance.walls[c].y, instance.walls[c].w, instance.walls[c].h = instance.map:getPixelBounds(x, y)

                c = c + 1
            end
        end
    end

    function instance:exit(color)
        local ex = instance.map.points[color].x2 * config.tileWidth
        local ey = instance.map.points[color].y2 * config.tileHeight
        local ew = config.tileWidth
        local eh = config.tileHeight
        return ex, ey, ew, eh
    end

    instance.wallCount = c

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
        self.blocks[color.blue]:update(dt, self)
        self.blocks[color.orange]:update(dt, self)

        -- check for victory
        bx, by, bw, bh = self.blocks[color.blue]:getPixelBounds()
        ox, oy, ow, oh = self.blocks[color.orange]:getPixelBounds()

        if rectangle.intersects(bx, by, bw, bh, self:exit(color.blue)) and
                rectangle.intersects(ox, oy, ow, oh, self:exit(color.orange)) then

            ix1, iy1, iw1, ih1 = rectangle.intersection(bx, by, bw, bh, self:exit(color.blue))
            ix2, iy2, iw2, ih2 = rectangle.intersection(ox, oy, ow, oh, self:exit(color.orange))

            a1 = rectangle.area(ix1, iy1, iw1, ih1)
            a2 = rectangle.area(ix2, iy2, iw2, ih2)

            if a1 >= config.victoryOverlap and a2 >= config.victoryOverlap then
                -- it's victory!
                self:nextLevel()
            end
        end
    end

    function instance:keypressed(key, isrepeat)
        -- allow level reset with the R key
        if key == "r" then
            self:resetLevel()
        end

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
