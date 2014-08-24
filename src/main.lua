local map = require "map"
local spritesheet = require "spritesheet"
local config = require "config"
local game = require "game"
local levelstate = require "states/level"

function love.load()
    local tiles = require "tiles"
    local idx = tiles["e"].index
    local x = idx % 8
    local y = math.floor(idx / 8)

    print(idx)
    print(x)
    print(y)

    love.keyboard.setKeyRepeat(false)

    love.graphics.setDefaultFilter("nearest")

    spriteSheet = spritesheet("data/sheet.png", config.tileWidth, config.tileHeight)
    spriteBatch = love.graphics.newSpriteBatch(spriteSheet.texture)

    one = game(spriteSheet)

    one:setState(levelstate(one, 1)) -- just start at the first level
end

function love.update(dt)
    one:update(dt)
end

function love.keypressed(key, isrepeat)
    one:keypressed(key, isrepeat)
end

function love.keyreleased(key)
    one:keyreleased(key)
end

function love.draw()
    love.graphics.scale(config.scale) -- apply graphics scaling

    spriteBatch:bind()
    spriteBatch:clear()

    one:draw(spriteBatch)

    spriteBatch:unbind()
    love.graphics.draw(spriteBatch)
end
