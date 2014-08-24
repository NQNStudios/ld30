tile = require "tile"
color = require "color"

local tiles = { }

tiles["1"] = tile(8, color.blue, false) -- blue path
tiles["!"] = tile(16, color.blue, false) -- blue exit

tiles["/"] = tile(9, color.orange, false) -- orange path
tiles["?"] = tile(17, color.orange, false) -- orange exit

tiles[" "] = tile(2, color.none, true) -- wall

tiles["a"] = tile(3, color.none, true) -- A wall (ha)
tiles["e"] = tile(4, color.none, true) -- E wall
tiles["m"] = tile(5, color.none, true) -- M wall
tiles["n"] = tile(6, color.none, true) -- N wall
tiles["o"] = tile(7, color.none, true) -- O wall

tiles["O"] = tile(10, color.none, true) -- colorful O wall
tiles["r"] = tile(11, color.none, true) -- R wall
tiles["s"] = tile(12, color.none, true) -- S wall
tiles["t"] = tile(13, color.none, true) -- T wall
tiles["u"] = tile(14, color.none, true) -- U wall
tiles["v"] = tile(15, color.none, true) -- V wall

tiles["y"] = tile(18, color.none, true) -- Y wall
tiles["-"] = tile(19, color.none, true) -- - wall

tiles["W"] = tile(33, color.none, true)
tiles["A"] = tile(40, color.none, true)
tiles["S"] = tile(41, color.none, true)
tiles["D"] = tile(42, color.none, true)

tiles["^"] = tile(38, color.none, true)
tiles["<"] = tile(45, color.none, true)
tiles["V"] = tile(46, color.none, true)
tiles[">"] = tile(47, color.none, true)

return tiles
