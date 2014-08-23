tile = require "tile"
color = require "color"

local tiles = { }

tiles["!"] = tile(8, color.blue, false)
tiles["?"] = tile(9, color.orange, false)
tiles[" "] = tile(7, color.none, true)

return tiles
