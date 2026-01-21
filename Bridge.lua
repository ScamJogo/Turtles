print ("How long do you want the bride")
Len = read()
Distance = 0 
Current_Slot = 0

function Change_Slot()
    
    if turtle.getItemCount(Current_Slot) < 1 then
        Current_Slot = Current_Slot + 1
        turtle.select(Current_Slot)
    end

end

function Bridge()
    while Distance < Len do
        Change_Slot()
        turtle.placeDown()
        turtle.forward()
        Distance = Distance + 1
    end
end

Bridge()