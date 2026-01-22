print("How wide do you want the area?")
Area = tonumber(read())

print("How deep do you want the area")

Depth = tonumber(read())

Local_X = 0 
Local_Y = 0
Local_Z = 0 

Direction = "+X"
Dig = true
Laps = 0 
Current_Depth = 0 
local half = nil -- computed after Area is read

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

function Move_Forward()

    print("My local cords are", "X", Local_X, "Y", Local_Y, "Z", Local_Z)
    if Direction =="+X" then
        Local_X = Local_X + 1
        DigUpDown()
        turtle.forward()
        DigUpDown()

    elseif Direction =="-X" then
        Local_X = Local_X - 1 
        DigUpDown()
        turtle.forward()
        DigUpDown()

    elseif Direction =="+Z" then
        Local_Z = Local_Z + 1 
        DigUpDown()
        turtle.forward()
        DigUpDown()

    elseif Direction =="-Z" then
        Local_Z = Local_Z - 1 
        DigUpDown()
        turtle.forward()
        DigUpDown()
    end
end

function Move_Up()
    Local_Y = Local_Y + 1
    turtle.digUp()
    turtle.up()
end

function Move_Down()
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
    -- go back to the original starting corner (-half, -half), face +X, then drop 3
    Move_To(-half, -half)
    Face("+X")
    Move_Down()
    Move_Down()
    Move_Down()
    Current_Depth = Current_Depth + 3
end

function Spiral()
    half = math.floor(Area / 2)

    -- Start on the top-left corner of the area (an edge position).
    Move_To(-half, -half)
    Face("+X")

    while Current_Depth < Depth do
        Laps = 0
        while true do
            local span = Area - 1 - (Laps * 2)
            if span <= 0 then break end

            -- Top edge (+X)
            for _ = 1, span do Move_Forward() end
            TurnRight() -- +Z

            -- Right edge (+Z)
            for _ = 1, span do Move_Forward() end
            TurnRight() -- -X

            -- Bottom edge (-X)
            for _ = 1, span do Move_Forward() end
            TurnRight() -- -Z

            -- Left edge (-Z) back to corner
            for _ = 1, span do Move_Forward() end
            TurnRight() -- face +X again at starting corner of this ring

            Laps = Laps + 1
            if Laps > half then break end

            -- Step one block inward (diagonal) to start next inner ring.
            Move_Forward()      -- +X
            TurnRight()         -- +Z
            Move_Forward()      -- +Z
            TurnLeft()          -- back to +X
        end

        -- Finished this depth layer; return to start corner and go down 3.
        Return_To_Start()

        -- Reposition to start corner for next layer.
        Move_To(-half, -half)
        Face("+X")
    end
end

function DigArea()
    
end


Spiral()
