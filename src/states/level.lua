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
        -- short circuit the more expensive movement handling if either block has no movement inputs
        self.blocks[color.blue]:update(dt)
        self.blocks[color.orange]:update(dt)

        if self.blocks[color.blue].active and self.blocks[color.orange].active then
            -- move both at once in equal amounts
            local dx1, dy1 = self.blocks[color.blue]:checkMove(dt, self)
            local dx2, dy2 = self.blocks[color.orange]:checkMove(dt, self)

            local d1 = math.max(math.abs(dx1), math.abs(dy1))
            local d2 = math.max(math.abs(dx2), math.abs(dy2))

            print("d1: " .. d1)
            print("d2: " .. d2)

            local d = math.min(d1, d2)

            -- if either distance is larger than the other, normalize it and scale to match so movement is synchronized
            if d1 > d then
                if d1 > 0 then
                    print("first value: " .. dx1)
                    dx1 = dx1 / d1
                    dx1 = dx1 * d
                    print("second value: " .. dx1)
                end

                if d1 > 0 then
                    print("first value: " .. dx1)
                    dy1 = dy1 / d1
                    dy1 = dy1 * d
                    print("second value: " .. dx1)
                end
            end

            if d2 > d then
                print("here")
                if d2 > 0 then
                    print("first value: " .. dx1)
                    dx2 = dx2 / d2
                    dx2 = dx2 * d
                    print("second value: " .. dx1)
                end

                if d2 > 0 then
                    print("first value: " .. dx1)
                    dy2 = dy2 / d2
                    dy2 = dy2 * d
                    print("second value: " .. dx1)
                end
            end

            self.blocks[color.blue]:move(dx1, dy1, self)
            self.blocks[color.orange]:move(dx2, dy2, self)
        end

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
