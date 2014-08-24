local map = require "map"
local spritesheet = require "spritesheet"
local config = require "config"
local game = require "game"
local menu = require "states/menu"

function love.load()
    love.keyboard.setKeyRepeat(false)

    spriteSheet = spritesheet("data/sheet.png", config.tileWidth, config.tileHeight)
    spriteBatch = love.graphics.newSpriteBatch(spriteSheet.texture)

    one = game(spriteSheet)
    menuState = menu()

    one:setState(menuState)
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
