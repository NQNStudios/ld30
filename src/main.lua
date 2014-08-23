map = require "map"
spritesheet = require "spritesheet"
config = require "config"

function love.load()
    spriteSheet = spritesheet("data/sheet.png", config.tileWidth, config.tileHeight)
    spriteBatch = love.graphics.newSpriteBatch(spriteSheet.texture)

    tileMap = map(spriteSheet, config.mapWidth, config.mapHeight, config.tileWidth, config.tileHeight, "data/levels/1.txt")
end

function love.update(dt)

end

function love.draw()
    love.graphics.scale(config.scale) -- apply graphics scaling

    spriteBatch:bind()
    spriteBatch:clear()

    tileMap:draw(spriteBatch)

    spriteBatch:unbind()
    love.graphics.draw(spriteBatch)
end
