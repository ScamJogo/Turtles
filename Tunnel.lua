
function Tunnel()
    turtle.dig()
    turtle.forward()
    turtle.digUp()
    turtle.digDown()

    turtle.turnLeft()
    turtle.dig()

    turtle.turnRight()
    turtle.turnRight()
    turtle.dig()
    turtle.turnLeft()
end


function Main()

    while true do 
        Tunnel()
    end

end

Main()