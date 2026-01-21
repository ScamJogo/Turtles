print("How long do you want the bridge")

local len = tonumber(read())
if not len or len <= 0 then
    print("Length must be a positive number.")
    return
end

local distance = 0
local current_slot = 1
turtle.select(current_slot)

local function ensure_slot_has_blocks()
    -- Walk slots until we find one with items; stop if we pass slot 16.
    while turtle.getItemCount(current_slot) == 0 do
        current_slot = current_slot + 1
        if current_slot > 16 then
            return false
        end
        turtle.select(current_slot)
    end
    return true
end

local function place_block_below()
    if turtle.placeDown() then
        return true
    end

    -- If placeDown failed because a block is already there, treat that as success.
    return turtle.detectDown()
end

local function bridge()
    while distance < len do
        print(string.format("Progress: %d / %d", distance, len))

        if not ensure_slot_has_blocks() then
            print(string.format("Out of blocks at %d / %d", distance, len))
            return
        end

        if not place_block_below() then
            print(string.format("Could not place block at %d / %d", distance, len))
            return
        end

        if not turtle.forward() then
            print(string.format("Path blocked after %d blocks; stopping.", distance))
            return
        end

        distance = distance + 1
    end
end

bridge()
