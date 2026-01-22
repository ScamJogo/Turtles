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
    turtle.up()
end

function Move_Down()
    Local_Y = Local_Y - 1
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

function Spiral()
    TurnLeft() -- Face -Z
    print("step 1") 
   while Local_Z > -Area / 2 +1 do 
        Move_Forward()
    end

    TurnRight() -- Face +X
    print("step 2")
    while Local_X < Area -1 do
        Move_Forward()
    end

    TurnRight() -- Face +Z
    print("step 3")
    while Local_Z < Area -1 do
        Move_Forward()
    end

    TurnRight() -- Face -X
    print("step 4")
    while Local_X > -Area +2 do
        Move_Forward()
    end

    TurnRight() -- Face -Z
    print("step 5")
    while Local_Z > -Area / 2 +1 do
        Move_Forward()
    end

    Laps = Laps + 1 
end

function DigArea()
    
end


Spiral()