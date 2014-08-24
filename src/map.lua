local tiles = require "tiles"
local config = require "config"

local function map(spriteSheet, width, height, tileWidth, tileHeight, file)
    local instance = { }

    instance.spriteSheet = spriteSheet

    instance.width = width
    instance.height = height

    instance.tileWidth = tileWidth
    instance.tileHeight = tileHeight

    instance.tiles = { }
    instance.points = { }

    local row = 0
    for line in love.filesystem.lines(file) do
        -- parse tiles
        if row < instance.height then
            instance.tiles[row] = { }

            local col = 0
            for c = 1, string.len(line) do
                local char = line:sub(c, c)

                instance.tiles[row][col] = tiles[char]

                col = col + 1
            end
        else
            -- parse special locations
            t = { }
            local k = 1
            for n in string.gmatch(line, "%S+") do
                t[k] = n

                k = k + 1
            end

            local row2 = row - instance.height

            if row2 == 0 then
                instance.points[color.blue] = { }

                -- t[1] = blue
                instance.points[color.blue].x1 = tonumber(t[2])
                instance.points[color.blue].y1 = tonumber(t[3])
                -- t[4] is spacing
                instance.points[color.blue].x2 = tonumber(t[5])
                instance.points[color.blue].y2 = tonumber(t[6])
            elseif row2 == 1 then
                instance.points[color.orange] = { }

                -- t[1] = orange
                instance.points[color.orange].x1 = tonumber(t[2])
                instance.points[color.orange].y1 = tonumber(t[3])
                -- t[4] is nothing
                instance.points[color.orange].x2 = tonumber(t[5])
                instance.points[color.orange].y2 = tonumber(t[6])
            end
        end

        row = row + 1
    end

    function instance:draw(spriteBatch)
        for y = 0, self.height - 1 do
            for x = 0, self.width - 1 do
                local tile = self.tiles[y][x]

                local index = tile.index

                spriteBatch:add(spriteSheet:getQuad(index), x * self.tileWidth, y * self.tileHeight)
            end
        end
    end

    function instance:getPixelBounds(tileX, tileY)
        return tileX * config.tileWidth, tileY * config.tileHeight, config.tileWidth, config.tileHeight
    end

    return instance
end

return map
