Print_Statments = true

function Start_Up()
    if fs.exists("turtle_state") then
        loadProgress()
    else
        print("Platform size?")
        Platform_size = read()
        Platform_size = tonumber(Platform_size)

        print("What is my direction? n,e,s,w? this needs to be lower case" )
        Direction = read()
        print("would you like my location to be 0,0? y/n")
        Starting_Cords_0_0 = read()

        if Starting_Cords_0_0 == "n" then
            print("what is my X cord")
            Starting_X_Cord = read()

            print("what is my Y cord")
            Starting_Y_Cord = read()

            print("what is my Z cord")
            Starting_Z_Cord = read()
        else
            Starting_X_Cord = 0
            Starting_Y_Cord = 0 
            Starting_Z_Cord = 0 
        end

        print("Do you need a fuel location? y/n")

        Fuel_Location = read()

        if Fuel_Location =="y" then
            print("What are your refuel cords?")

            print("what is my fuel X cord")
            Fuel_X_Cord = read()

            print("what is my fuel Y cord")
            Fuel_Y_Cord = read()

            print("what is my fuel Z cord")
            Fuel_Z_Cord = read()
        end

        Current_X = Starting_X_Cord
        Current_Y = Starting_Y_Cord
        Current_Z = Starting_Z_Cord

        Continue_X = 0 
        Continue_Y = 0 
        Continue_Z = 0 

        Starting_X_Cord = tonumber(Starting_X_Cord)
        Starting_Y_Cord = tonumber(Starting_Y_Cord)
        Starting_Z_Cord = tonumber(Starting_Z_Cord)

        Current_X = tonumber(Current_X)
        Current_Y = tonumber(Current_Y)
        Current_Z = tonumber(Current_Z)

        Fuel_X_Cord = tonumber(Fuel_X_Cord)
        Fuel_Y_Cord = tonumber(Fuel_Y_Cord)
        Fuel_Z_Cord = tonumber(Fuel_Z_Cord)

        Slot = 2

    end  
end

function Refuel()
    if turtle.getFuelLevel() < 1000 then
        Current_Slot = turtle.getSelectedSlot()
        turtle.select(1)
        turtle.refuel(5)
        if turtle.getItemCount(1) < 5 then
            Go_To_Cord(Fuel_X_Cord, Fuel_Y_Cord, Fuel_Z_Cord)
            turtle.select(1)
            turtle.suckDown(64)
            Go_To_Cord(Starting_X_Cord, Starting_Y_Cord, Starting_Z_Cord)
        end
        turtle.select(Current_Slot)
    end
    saveProgress()
end

function Go_To_Cord(Target_X, Target_Y, Target_Z)

    Starting_Direction = Direction

    if Current_X < Target_X then
        if Direction == "n" then
            TurnRight()
        end

        if Direction == "s" then
            TurnLeft()
        end

        if Direction == "w" then
            TurnRight()
            TurnRight()
        end

        while Current_X < Target_X do
            Move_Forward()
        end
    end


    if Current_X > Target_X then
        if Direction == "n" then
            TurnLeft()
        end 

        if Direction == "e" then
            TurnLeft()
            TurnLeft()
        end

        if Direction == "s" then
            TurnRight()
        end

        while Current_X > Target_X do
            Move_Forward()
        end
    end

    if Current_Z < Target_Z then
        if Direction == "n" then
            TurnRight()
            TurnRight()
        end

        if Direction == "e" then
            TurnRight()
        end 

        if Direction == "w" then
            TurnLeft()
        end
            
        while Current_Z < Target_Z do
            Move_Forward()
        end
    end

    if Current_Z > Target_Z then
        if Direction == "s" then
            TurnRight()
            TurnRight()
        end

        if Direction == "e" then
            TurnLeft()
        end

        if Direction == "w" then
            TurnRight()
        end

        while Current_Z > Target_Z do
            Move_Forward()
        end
    end

    while Current_Y < Target_Y do
        Move_Up()
    end

    while Current_Y > Target_Y do
        Move_Down()
    end

    while Direction ~= Starting_Direction do 
        TurnLeft()
    end
        
end

function Move_Forward()
    Refuel()
    if Direction == "n" then
        if turtle.detect() == false then
            Current_Z = Current_Z - 1
            turtle.forward()
        end

    elseif Direction == "s" then
        if turtle.detect() == false then
            Current_Z = Current_Z + 1
            turtle.forward()
        end

    elseif Direction == "e" then
        if turtle.detect() == false then
            Current_X = Current_X + 1
            turtle.forward()
        end

    elseif Direction == "w" then
        if turtle.detect() == false then
            Current_X = Current_X - 1
            turtle.forward()
        end
    end

    saveProgress()

    if Print_Statments == true then
        print("X: " .. Current_X .. ", Y: " .. Current_Y .. ", Z: " .. Current_Z.. ", Direction: " .. Direction)
    end
end

function Move_Up()
    Current_Y=Current_Y + 1
    if Print_Statments == true then
        print("Y: ".. Current_Y)
    end
    turtle.up()
    saveProgress()
end

function Move_Down()
    Current_Y=Current_Y - 1
    if Print_Statments == true then
        print("Y: ".. Current_Y)
    end
    turtle.down()
    saveProgress()
end

function TurnLeft()
    if Direction == "n" then
        Direction = "w"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnLeft()
        return
    end

    if Direction == "e" then
        Direction = "n"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnLeft()
        return
    end

    if Direction == "s" then
        Direction = "e"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnLeft()
        return
    end

    if Direction == "w" then
        Direction = "s"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnLeft()
        return
    end
    saveProgress()
end

function TurnRight()
    if Direction == "n" then
        Direction = "e"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnRight()
        return
    end

    if Direction == "e" then
        Direction = "s"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnRight()
        return
    end

    if Direction == "s" then
        Direction = "w"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnRight()
        return
    end

    if Direction == "w" then
        Direction = "n"
        if Print_Statments == true then
            print(Direction)
        end
        turtle.turnRight()
        return
    end
    saveProgress()
end

function Return_To_Chest()
    print("Returning to chest")
end

function Pickup_blocks()
    Inventory_Slot = 2
    turtle.select(Inventory_Slot)
    while turtle.getItemCount(16) <1 do
        turtle.suckDown(64)
        Inventory_Slot = Inventory_Slot + 1
    end
end

function Place_Block()
    while turtle.getItemCount(Slot) < 1 do
        Slot = Slot + 1
        if Slot > 16 then 
            print("Need more blocks")
            print("Need to save current location and direction as a target")

            Continue_Direction = Direction

            Continue_X = Current_X
            Continue_Y = Current_Y
            Continue_Z = Current_Z
            print(Continue_X, Continue_Y, Continue_Z)

            Go_To_Cord(Starting_X_Cord, Starting_Y_Cord, Starting_Z_Cord)
            Pickup_blocks()

            print(Continue_X, Continue_Y, Continue_Z)
            Go_To_Cord(Continue_X, Continue_Y, Continue_Z)

            while Direction ~= Continue_Direction do 
                TurnRight()
            end

            Slot = 2
        end
    end

    if Slot < 17 then
        turtle.select(Slot)
        turtle.placeDown()
        saveProgress()
    end
end

function generatePlatformCoords(startX, startY, startZ, size)
    local coords = {}
    for x = startX, startX + size - 1 do
        for z = startZ, startZ + size - 1 do
            table.insert(coords, {x = x, y = startY, z = z})
        end
    end
    print(coords)
    return coords
end

function saveProgress(coords, currentIndex)
    local state = {
        coords = coords,
        currentIndex = currentIndex
    }
    local file = fs.open("turtle_progress", "w")
    file.write(textutils.serialize(state))
    file.close()
end

function loadProgress()
    if fs.exists("turtle_progress") then
        local file = fs.open("turtle_progress", "r")
        local state = textutils.unserialize(file.readAll())
        file.close()
        return state.coords, state.currentIndex
    else
        print("No saved progress found, starting fresh.")
        return nil, nil
    end
end

function buildPlatformFromCoords(coords, startIndex)
    for i = startIndex, #coords do
        local coord = coords[i]
        Go_To_Cord(coord.x, coord.y, coord.z)
        Place_Block()
        saveProgress(coords, i)
    end
    print("Platform complete!")
end

Starting_X_Cord = 0
Starting_Y_Cord = 0
Starting_Z_Cord = 0 
Platform_size = 15

local coords = generatePlatformCoords(Starting_X_Cord, Starting_Y_Cord, Starting_Z_Cord, Platform_size)

function printCoords(coords)
    for i, coord in ipairs(coords) do
        print(string.format("Block %d: x = %d, y = %d, z = %d", i, coord.x, coord.y, coord.z))
    end
end

printCoords(coords)

