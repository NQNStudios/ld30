local function spritesheet(texture, tileWidth, tileHeight)
    local instance = { }

    instance.texture = love.graphics.newImage(texture)
    instance.textureWidth = instance.texture:getWidth()
    instance.textureHeight = instance.texture:getHeight()

    instance.tileWidth = tileWidth
    instance.tileHeight = tileHeight

    instance.width = instance.texture:getWidth() / (tileWidth + 2) -- account for padding
    instance.height = instance.texture:getHeight() / (tileHeight + 2)

    instance.quads = { }

    function instance:getQuadAt(x, y)
        x = 1 + (self.tileWidth + 2) * x
        y = 1 + (self.tileHeight + 2) * y

        local width = self.tileWidth
        local height = self.tileHeight

        return love.graphics.newQuad(x, y, width, height, self.textureWidth, self.textureHeight)
    end

    function instance:getQuad(index)
        if instance.quads[index] then
            return instance.quads[index] -- if previously used, return the saved copy
        end

        local x = math.floor(index % self.width)
        local y = math.floor(index / self.width)

        local quad = self:getQuadAt(x, y)

        instance.quads[index] = quad

        return quad
    end

    return instance
end

return spritesheet
