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

function Return_To_Start()
    local half = math.floor(Area / 2)
    if Local_X == half and Local_Z == half then
        while Direction ~= "-X" do
            TurnRight()
            if Direction == "-X" then
                break
            end
        end

        while Current_X > 0 do
            Move_Forward()
        end

        TurnRight()
        TurnRight()
        Move_Down()
        Move_Down()
        Move_Down()

        Current_Depth = Current_Depth + 3
    end 
end

function Spiral()
    while Current_Depth < Depth do 
        TurnLeft() -- Face -Z
        print("step 1") 
        while Local_Z > -Area / 2 + 1 + Laps do 
            Move_Forward()
        end

        TurnRight() -- Face +X
        print("step 2")
        while Local_X < Area - 1 - Laps do
            Move_Forward()
        end

        TurnRight() -- Face +Z
        print("step 3")
        while Local_Z < Area - 3 - Laps do
            Move_Forward()
        end

        TurnRight() -- Face -X
        print("step 4")
        while Local_X > 0 + Laps do
            Move_Forward()
        end

        TurnRight() -- Face -Z
        print("step 5")
        while Local_Z > 0 do
            Move_Forward()
        end

        TurnRight()
        Move_Forward()

        Laps = Laps + 1 
    end
end

function DigArea()
    
end


Spiral()