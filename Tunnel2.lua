-- Tunnel2: mines a 1x1 tunnel, tracks local coords, and veins-mine any ore it sees.

-- Coordinate system (local):
--  start position = (0,0,0), facing +X (down-tunnel). +Y is up, +Z is to the right of +X (clockwise when looking down).

-- State
local X, Y, Z = 0, 0, 0
local Dir = "+X"

local function dir_vec(d)
    if d == "+X" then return 1, 0 end
    if d == "-X" then return -1, 0 end
    if d == "+Z" then return 0, 1 end
    return 0, -1 -- "-Z"
end

-- Movement helpers (keep coords in sync)
local function face(target)
    while Dir ~= target do
        turtle.turnRight()
        if     Dir == "+X" then Dir = "+Z"
        elseif Dir == "+Z" then Dir = "-X"
        elseif Dir == "-X" then Dir = "-Z"
        else                   Dir = "+X" end
    end
end

local function move_forward()
    while not turtle.forward() do
        if turtle.detect() then turtle.dig() else turtle.attack() end
        sleep(0.1)
    end
    local dx, dz = dir_vec(Dir)
    X, Z = X + dx, Z + dz
end

local function move_up()
    while not turtle.up() do
        if turtle.detectUp() then turtle.digUp() else turtle.attackUp() end
        sleep(0.1)
    end
    Y = Y + 1
end

local function move_down()
    while not turtle.down() do
        if turtle.detectDown() then turtle.digDown() else turtle.attackDown() end
        sleep(0.1)
    end
    Y = Y - 1
end

-- Pathing to an absolute local coordinate (Manhattan)
local function move_to(tx, ty, tz)
    if Y < ty then for _ = Y + 1, ty do move_up() end
    elseif Y > ty then for _ = ty + 1, Y do move_down() end end

    if X < tx then face("+X"); for _ = X + 1, tx do move_forward() end
    elseif X > tx then face("-X"); for _ = tx + 1, X do move_forward() end end

    if Z < tz then face("+Z"); for _ = Z + 1, tz do move_forward() end
    elseif Z > tz then face("-Z"); for _ = tz + 1, Z do move_forward() end end
end

-- Ore tracking
local ore_queue = {}
local ore_seen = {} -- key "x,y,z" -> true

local function key(x, y, z) return table.concat({x, y, z}, ",") end

local function record_ore(name, x, y, z)
    local k = key(x, y, z)
    if not ore_seen[k] then
        ore_seen[k] = true
        table.insert(ore_queue, {x = x, y = y, z = z, name = name})
        print(string.format("Found ore: %s at (%d,%d,%d)", name or "unknown", x, y, z))
    end
end

local function has_ore_tag(data)
    if not data or not data.tags then return false end
    for tag, v in pairs(data.tags) do
        if v and tag:find("ore") then return true end
    end
    return false
end

-- Scan all 6 sides, add ore coordinates to queue; preserve facing.
local function scan_adjacent_for_ore()
    -- front
    local ok, data = turtle.inspect()
    if ok and has_ore_tag(data) then
        local dx, dz = dir_vec(Dir)
        record_ore(data.name, X + dx, Y, Z + dz)
    end
    -- right, back, left
    for i = 1, 3 do
        turtle.turnRight()
        if     Dir == "+X" then Dir = "+Z"
        elseif Dir == "+Z" then Dir = "-X"
        elseif Dir == "-X" then Dir = "-Z"
        else                   Dir = "+X" end

        ok, data = turtle.inspect()
        if ok and has_ore_tag(data) then
            local dx, dz = dir_vec(Dir)
            record_ore(data.name, X + dx, Y, Z + dz)
        end
    end
    -- restore facing after 3 rights -> net turnLeft
    turtle.turnRight()
    if     Dir == "+X" then Dir = "+Z"
    elseif Dir == "+Z" then Dir = "-X"
    elseif Dir == "-X" then Dir = "-Z"
    else                   Dir = "+X" end

    -- up/down
    ok, data = turtle.inspectUp()
    if ok and has_ore_tag(data) then record_ore(data.name, X, Y + 1, Z) end
    ok, data = turtle.inspectDown()
    if ok and has_ore_tag(data) then record_ore(data.name, X, Y - 1, Z) end
end

-- Mine all queued ore (vein style), then return to a saved position/orientation.
local function mine_ore_cluster(return_pos)
    while #ore_queue > 0 do
        local t = table.remove(ore_queue)
        move_to(t.x, t.y, t.z)
        turtle.dig() -- block should be in front
        scan_adjacent_for_ore()
    end
    move_to(return_pos.x, return_pos.y, return_pos.z)
    face(return_pos.dir)
end

-- Core tunnel step: dig 1 forward tile, clear up/down and side bumps.
local function tunnel_step()
    turtle.dig()
    move_forward()
    turtle.digUp()
    turtle.digDown()
    -- optional: widen? currently 1x1 tunnel.
end

local function main()
    while true do
        local ret = {x = X, y = Y, z = Z, dir = Dir}
        scan_adjacent_for_ore()
        if #ore_queue > 0 then
            mine_ore_cluster(ret)
        end
        tunnel_step()
    end
end

main()
