local function tile(index, color, solid)
    local instance = { }

    instance.index = index
    instance.color = color
    instance.solid = solid

    return instance
end

return tile
