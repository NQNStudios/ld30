local config = { }

config.scale = 4
config.tileWidth = 8
config.tileHeight = 8

config.mapWidth = 20
config.mapHeight = 15

config.blockPadding = {
    x = 0,
    y = 0
}

config.normalSpeed = 60

config.victoryForgiveness = 2
config.victoryOverlap = (config.tileWidth - config.victoryForgiveness) * (config.tileHeight - config.victoryForgiveness)

config.debug = false

return config
