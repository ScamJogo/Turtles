print("How wide do you want the area?")
Area = tonumber(read())

print("How deep do you want the area")

Depth = tonumber(read())

local half = math.floor(Area / 2)
local start_x = -half   -- starting on the south edge center (north is +X)
local start_z = 0

Local_X = start_x
Local_Y = 0
Local_Z = start_z

Direction = "+X"
Dig = true
Laps = 0 
Current_Depth = 0 

function DigUpDown()
    if Dig == true then
        if turtle.detect() then
            turtle.dig()
        end

        if turtle.detectUp() then
            turtle.digUp()
        end

        if turtle.detectDown() then
            turtle.digDown()
        end
    end
end

-- Keep the turtle fueled using items in slot 1. Refuel if below 250.
local function ensure_fuel()
    local level = turtle.getFuelLevel()
    if level == "unlimited" or level == nil then return true end
    if level >= 250 then return true end

    local prev = turtle.getSelectedSlot()
    turtle.select(1)
    local count = turtle.getItemCount(1)
    if count > 0 then
        turtle.refuel(math.min(8, count))
    end
    turtle.select(prev)

    level = turtle.getFuelLevel()
    if level == "unlimited" or level >= 250 then
        return true
    else
        print("Low fuel: add fuel to slot 1.")
        return false
    end
end

function Move_Forward()

    local function forward_with_clear()
        if not ensure_fuel() then return false end
        local attempts = 0
        while true do
            DigUpDown() -- clear around before moving
            if turtle.forward() then
                DigUpDown() -- clear gravel that may fall after moving
                return true
            end

            -- blocked: try to clear and retry
            if turtle.detect() then
                turtle.dig()
            else
                turtle.attack()
            end

            attempts = attempts + 1
            if attempts > 20 then
                print("Blocked: can't move forward after repeated attempts.")
                return false
            end
            sleep(0.2) -- let falling blocks settle
        end
    end

    print("My local cords are", "X", Local_X, "Y", Local_Y, "Z", Local_Z)
    if Direction =="+X" then
        if forward_with_clear() then
            Local_X = Local_X + 1
        end

    elseif Direction =="-X" then
        if forward_with_clear() then
            Local_X = Local_X - 1 
        end

    elseif Direction =="+Z" then
        if forward_with_clear() then
            Local_Z = Local_Z + 1 
        end

    elseif Direction =="-Z" then
        if forward_with_clear() then
            Local_Z = Local_Z - 1 
        end
    end
end

function Move_Up()
    if not ensure_fuel() then return end
    Local_Y = Local_Y + 1
    turtle.digUp()
    turtle.up()
end

function Move_Down()
    if not ensure_fuel() then return end
    Local_Y = Local_Y - 1
    turtle.digDown()
    turtle.down()
end

function TurnRight()
    print("Turning right", Direction)
    if Direction == "+X" then
        Direction = "+Z"
        turtle.turnRight()
    elseif Direction == "+Z" then
        Direction = "-X"
        turtle.turnRight()
    elseif Direction == "-X" then
        Direction = "-Z"
        turtle.turnRight()
    elseif Direction == "-Z" then
        Direction = "+X"
        turtle.turnRight()
    end
end

function TurnLeft()
    print("Turning left", Direction)
    if Direction == "+X" then
        Direction = "-Z"
        turtle.turnLeft()
    elseif Direction == "-Z" then
        Direction = "-X"
        turtle.turnLeft()
    elseif Direction == "-X" then
        Direction = "+Z"
        turtle.turnLeft()
    elseif Direction == "+Z" then
        Direction = "+X"
        turtle.turnLeft()
    end
end

-- Face a specific heading (+X, -X, +Z, -Z)
local function Face(dir)
    while Direction ~= dir do
        TurnRight()
    end
end

-- Move (digging) to an absolute local X/Z coordinate.
local function Move_To(target_x, target_z)
    if Local_X < target_x then
        Face("+X")
        while Local_X < target_x do Move_Forward() end
    elseif Local_X > target_x then
        Face("-X")
        while Local_X > target_x do Move_Forward() end
    end

    if Local_Z < target_z then
        Face("+Z")
        while Local_Z < target_z do Move_Forward() end
    elseif Local_Z > target_z then
        Face("-Z")
        while Local_Z > target_z do Move_Forward() end
    end
end

function Return_To_Start()
    -- go back to the original starting edge center, face +X, then drop 3
    Move_To(start_x, start_z)
    Face("+X")
    Move_Down()
    Move_Down()
    Move_Down()
    Current_Depth = Current_Depth + 3
end

function Spiral()
    -- Ensure starting orientation/position
    Move_To(start_x, start_z)
    Face("+Z") -- face along the south wall toward +Z (east)

    while Current_Depth < Depth do
        Laps = 0
        while true do
            local minX = -half + Laps
            local maxX =  half - Laps
            local minZ = -half + Laps
            local maxZ =  half - Laps

            if minX > maxX or minZ > maxZ then break end

            -- start of ring: south-edge center of current box
            Move_To(minX, start_z)

            -- South edge, eastward to SE corner
            Move_To(minX, maxZ)
            -- East edge, northward
            Move_To(maxX, maxZ)
            -- North edge, westward
            Move_To(maxX, minZ)
            -- West edge, southward back toward start line
            Move_To(minX, minZ)
            -- Return along south edge center line to starting spot of this ring
            Move_To(minX, start_z)

            Laps = Laps + 1
            -- Step inward to the next ring's south-edge center
            Move_To(-half + Laps, start_z)
        end

        -- Finished this depth layer; return to starting edge center and go down 3.
        Return_To_Start()

        -- Reposition to start edge center for next layer.
        Move_To(start_x, start_z)
        Face("+Z")
    end
end

function DigArea()
    
end


Spiral()
