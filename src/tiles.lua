tile = require "tile"

local tiles = { }

tiles["#"] = tile(0, false)
tiles["3"] = tile(1, false)
tiles[" "] = tile(7, true)

return tiles
