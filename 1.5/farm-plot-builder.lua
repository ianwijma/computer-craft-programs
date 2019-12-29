-- Computercraft shorthands
t = turtle
 
-- Check fuel level
if t.getFuelLevel() < 1000 then
    error("Make sure there is atleast 1000 fuel")
end
 
-- Setup direction
direction = ...
if not string.match(direction, "left") and not string.match(direction, "right") then
    error("Missing argument 'left' or 'right'")
end
 
 
-- checks slots
sideChestSlot = 1
soilChestSlot = 2
 
-- place slots
sideSlot = 5
soilSlot = 6
 
-- cache slots
sideCacheSlot = 9
soilCacheSlot = 10
 
-- Slot functions
function emptySlot( slotNr, minimum )
    return t.getItemCount( slotNr ) <= minimum
end
 
function fillSlot( chestSlot, targetSlot, cacheSlot )  
    -- get items needed for target slot
    local itemsNeeded = 64 - t.getItemCount( targetSlot )
 
    -- transfer from cache
    if t.getItemCount( cacheSlot ) > 0 then
        t.select( cacheSlot )
        t.transferTo( targetSlot )
    end
 
    -- refuel cache if empty
    if t.getItemCount( cacheSlot ) == 0 then
         -- place target check
        t.select( chestSlot )
        t.place()
 
        -- get items from chest
        t.select( cacheSlot )
        t.suck( itemsNeeded )
 
        -- pick up the chest
        t.select( chestSlot )
        t.dig()
    end
 
    -- transfer from cache
    t.select( cacheSlot )
    t.transferTo( targetSlot )
   
end
 
-- Place sides
function placeSide( length )
    for i=1, length
    do
        -- Check if we have blocks
        if emptySlot( sideSlot, 3 ) then
            fillSlot( sideChestSlot, sideSlot, sideCacheSlot )
        end
 
        -- place blocks
        t.select( sideSlot )
        t.placeUp()
        t.placeDown()
       
        -- Check which direction  to go
        if i == length then
            if direction == "left" then
                t.turnLeft()
            elseif direction == "right" then
                t.turnRight()
            end
        end
 
        -- Place middle block
        t.forward()
        placeSideBehind()
       
    end
end
 
function placeSideBehind()
    -- Select sides slot
    t.select( sideSlot )
 
    -- turn around
    t.turnLeft()
    t.turnLeft()
    t.place()
    t.turnLeft()
    t.turnLeft()
end
 
-- Please the top
function placeTop( turnLeft )
    -- wheck if we have enought
    if emptySlot( soilSlot, 23 ) then
        fillSlot( soilChestSlot, soilSlot, soilCacheSlot )
    end
   
    -- select soil
    t.select(soilSlot)
 
    -- to forward untill we can't do any further
    while not t.detect() do
        t.placeUp()
        t.forward()
    end
 
    -- Please the last block
    t.placeUp()
 
    -- turn
    if turnLeft then
        t.turnLeft()
    else
        t.turnRight()
    end
 
    -- check if we can do another lane
    if t.detect() then
        t.dig()
        t.forward()
        t.forward()
        placeSideBehind()
        return -- done!
    else
        t.forward()
    end
 
    -- turn
    if turnLeft then
        t.turnLeft()
    else
        t.turnRight()
    end
 
    -- run again
    placeTop( not turnLeft )
 
end
 
-- Run the program
    -- Correct posistion
t.up()
t.forward()
-- Place the sides
placeSide(25)
placeSide(24)
placeSide(24)
placeSide(23)
 
-- Place the top
placeTop( direction == "left" )