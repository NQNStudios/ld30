local rectangle = { }

function rectangle.intersects(x1, y1, w1, h1, x2, y2, w2, h2)
    return (math.abs(x1 - x2) * 2 < (w1 + w2)) and
            (math.abs(y1 - y2) * 2 < (h1 + h2))
end

function rectangle.intersection(x1, y1, w1, h1, x2, y2, w2, h2)
    right1 = x1 + w1
    right2 = x2 + w2
    bottom1 = y1 + h1
    bottom2 = y2 + h2

    x3 = math.max(x1, x2)
    right3 = math.min(right1, right2)

    if right3 <= x3 then
        return nil
    else
        y3 = math.max(y1, y2)
        bottom3 = math.min(bottom1, bottom2)

        if bottom3 <= y3 then
            return nil
        else
            w3 = right3 - x3
            h3 = bottom3 - y3
            return x3, y3, w3, h3
        end
    end
end

function rectangle.area(x, y, w, h)
    return w * h
end

return rectangle
