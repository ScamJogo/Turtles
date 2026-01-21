print("Turtle must be facing North or West for tree to grow with 0 block gap")
print("sapplings go in last slot (16)")

print("Will you be mining 2x2 trees or 1x1?")
Tree_Type = read()

print("Ready?? press enter when ready")
read()

function Drop_off_items()
    for slot = 2, 15 do 
        turtle.select(slot)
        local itemCount = turtle.getItemCount(slot)
        
        if itemCount > 0 then
            turtle.drop()
            print("Ejected " .. itemCount .. " items from slot " .. slot)
        end
    end
    turtle.select(1)
end

function refuel()
    Refuel_Amount = 10
    Return_slot = turtle.getSelectedSlot()
    Fuel_Level = turtle.getFuelLevel()
    if turtle.getFuelLevel() < 250 then
        print("Low fuel: " .. Fuel_Level)
        turtle.select(1)
        turtle.refuel(Refuel_Amount)
        Fuel_Level = turtle.getFuelLevel()
        print("ahhh that's better, Fuel level: " .. Fuel_Level)
    end
    turtle.select(Return_slot)
end

function Get_Sapplings()

    if Tree_Type == "2x2" then

        if turtle.getItemCount(16) < 4 then
            print("Need more sapplings to make another tree")
            print("Fuck it I'll get them my self!")
            Return_slot = turtle.getSelectedSlot()
            turtle.select(16)
            turtle.suckDown(64)
            print("I did it my self you lazy whore")
            turtle.select(Return_slot)
        end
    end

    if Tree_Type == "3x3" then

        if turtle.getItemCount(16) < 9 then
            print("Need more sapplings to make another tree")
            print("Fuck it I'll get them my self!")
            Return_slot = turtle.getSelectedSlot()
            turtle.select(16)
            turtle.suckDown(64)
            print("I did it my self you lazy whore")
            turtle.select(Return_slot)
        end
    end

    if Tree_Type == "1x1" then

        if turtle.getItemCount(16) < 1 then
            print("Need more sapplings to make another tree")
            print("Fuck it I'll get them my self!")
            Return_slot = turtle.getSelectedSlot()
            turtle.select(16)
            turtle.suckDown(64)
            print("I did it my self you lazy whore")
            turtle.select(Return_slot)
        end
    end

end

function Mine_3x3()
    print("Mining 3x3")
end

function Mine_2x2()
    print("Mining 2x2")
    local Blocks_Up = 0 

    refuel()
    Get_Sapplings()

    turtle.dig()
    turtle.forward()
    turtle.dig()

    while turtle.detectUp() do 
        turtle.digUp()
        turtle.dig()
        turtle.up()
        Blocks_Up = Blocks_Up + 1
    end

    turtle.dig()
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    turtle.turnRight()
    turtle.dig()

    while Blocks_Up > 0 do 
        turtle.dig()
        turtle.digDown()
        turtle.down()
        Blocks_Up = Blocks_Up -1
    end

    turtle.dig()
    turtle.select(16)
    turtle.forward()
    turtle.turnRight()
    turtle.place()
    turtle.turnLeft()
    turtle.back()
    turtle.place()
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.place()
    turtle.turnRight()
    turtle.back()
    turtle.place()
    turtle.turnRight()
    turtle.turnRight()
    Drop_off_items()
    turtle.turnLeft()
    turtle.turnLeft()

end

function Mine_1x1()
    local Blocks_Up = 0 
    print("Mining 1x1")

    refuel()
    Get_Sapplings()

    turtle.dig()
    turtle.forward()

    while turtle.detectUp() do 
        turtle.digUp()
        turtle.up()
        Blocks_Up = Blocks_Up + 1
    end

    while Blocks_Up > 0 do 
        turtle.digDown()
        turtle.down()
        Blocks_Up = Blocks_Up -1
    end

    turtle.back()
    turtle.select(16)
    turtle.place()
    turtle.select(1)

    turtle.turnRight()
    turtle.turnRight()
    Drop_off_items()
    turtle.turnLeft()
    turtle.turnLeft()

end

function Tree_Mining()

    if turtle.detect() then
        local success, data = turtle.inspect()
        if data.name == "minecraft:log" or data.name == "minecraft:log2" then
            if Tree_Type == "3x3" then
                Mine_3x3()
            elseif Tree_Type == "2x2" then
                Mine_2x2()
            elseif Tree_Type == "1x1" then
                Mine_1x1()
            end
        end
    else
        print("Starting from scratch")
        if Tree_Type == "3x3" then
            Mine_3x3()
        elseif Tree_Type == "2x2" then
            Mine_2x2()
        elseif Tree_Type == "1x1" then
            Mine_1x1()
        end
    end
    

    while true do
        if turtle.detect() then
            local success, data = turtle.inspect()
            if data.name == "minecraft:log" or data.name == "minecraft:log2" then
                if Tree_Type == "3x3" then
                    Mine_3x3()
                elseif Tree_Type == "2x2" then
                    Mine_2x2()
                elseif Tree_Type == "1x1" then
                    Mine_1x1()
                end
            end
        end
        sleep(1) 
    end
end

Tree_Mining()