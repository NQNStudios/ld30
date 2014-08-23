tiles = require("tiles")

local function map(spriteSheet, width, height, tileWidth, tileHeight, file)
    -- TODO use file to load a map
    
    local instance = { }

    instance.spriteSheet = spriteSheet

    instance.width = width
    instance.height = height

    instance.tileWidth = tileWidth
    instance.tileHeight = tileHeight

    instance.tiles = { }

    local row = 0
    for line in love.filesystem.lines(file) do
        instance.tiles[row] = { }

        local col = 0
        for c = 1, string.len(line) do
            local char = line:sub(c, c)

            instance.tiles[row][col] = tiles[char]

            col = col + 1
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

    return instance
end

return map
