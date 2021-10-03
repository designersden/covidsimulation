local worldSize, borderSize, innerBorderSize, centerSize, fontSize, personSize, personGap, totalPopulation = 500, 20,15, 60, 18, 14, 18, 700
local maxClassesPerDay = 7
local classWidth, classHeight = 100, 100
local rowsPerRoom, colsPerRoom = 25,25 
local rows, roomsInARow = 5, 10
local rooms = {}
local population  = {}
local classes = {}
local width, height, center, otherSide =
	(worldSize+borderSize*2)*2+centerSize+borderSize*2,
	(worldSize+borderSize*2) +centerSize+borderSize*2,
	worldSize+borderSize*2,
	worldSize+centerSize+borderSize*5

local function RandomizeRooms(totalRooms)
    roomNumbers = {}
    for i = 1, totalRooms do 
        table.insert(roomNumbers, i)        
    end
    for i = 1, table.getn(roomNumbers) do
        local j = math.random(i)
        roomNumbers[i], roomNumbers[j]  = roomNumbers[j], roomNumbers[i]      
    end
    return roomNumbers
end

local function CreateClasses()
    randomRooms = RandomizeRooms(50)
    roomIdx = 1
    for class = 6, 8 do 
        for subject = 1, 6 do 
            for section =1, 2 do
                classCode = "CLS" .. class .. "SUB" .. subject .. "SEC" .. section 
                table.insert(classes, {id=classCode, class=class, subject=subject, section=section, room = rooms[randomRooms[RoomIdx]]})
            end
        end 
    end    
   
end

local function CreatePopulation()
   -- create population    
   for personIdx = 1, totalPopulation do         
        table.insert(population, {id = personIdx, currentX = 0, currentY = 0, currentClass=1, classes = {}})
    end

    for classes = 1, 7 do         
        roomNumbers = RandomizeRooms(table.getn(rooms))
        for personIdx = 1, totalPopulation do 
            table.insert(population[personIdx].classes, {rooms[room]})
        end
    end
    CreateClasses()

    -- thisPerson = 1
    -- for room = 1, table.getn(rooms) do 
    --     for row = 1, 5 do 
    --         for col = 1, 5 do 
    --             aPerson = population[thisPerson]              
    --             table.insert(aPerson.classes, {room = room, row=row, col=col})
    --             thisPerson = thisPerson + 1
    --             if(thisPerson > totalPopulation) then break end
    --         end            
    --         if(thisPerson > totalPopulation) then break end
    --     end
    --     if(thisPerson > totalPopulation) then break end
    -- end  
end

local function CreateChairs(room)
    chairs = {}
    thisChair = room * 100 + 1
    for row = 1, 5 do 
        for col = 1, 5 do 
            table.insert(chairs,{id = thisChair, room = room, row = row, col = col })
            thisChair = thisChair + 1
        end
    end    
    for i = 1, table.getn(chairs) do
        local j = math.random(i)
        chairs[i], chairs[j]  = chairs[j], chairs[i]      
    end
    return chairs
    -- print("shuffle ends")
    -- for chair = 1, table.getn(chairs)   do 
    --     print(chairs[chair].room)
    --     print(chairs[chair].row) 
    --     print(chairs[chair].col)
    -- end
end


local function SetupSimulation()
    -- construct boundry 
    boundry = {x = borderSize, y = borderSize, width=width, height=height}
    --construct rooms
    roomId = 1 
    for row = 1, rows do 
        for room = 1, roomsInARow do
            table.insert(rooms, 
                {   id = roomId , 
                    x = borderSize + (innerBorderSize * room) + (classWidth *  (room -1)), 
                    y = borderSize + (innerBorderSize * (row))  + (classHeight * (row-1)), 
                    width = classWidth,
                    height = classHeight, 
                    chairs = CreateChairs(roomId)
                })
            roomId = roomId + 1
        end
    end   
    CreatePopulation()
    -- setup simulation parameters. 
end


local function DrawClassrooms()
    love.graphics.setColor(0.92, 0.6, 0.6)
	love.graphics.rectangle("fill", boundry.x ,boundry.y , boundry.width, boundry.height)

    love.graphics.setColor(0.6, 0.6, 0.92)
    --Draw classrooms
    for roomIndex = 1, table.getn(rooms) do 
        love.graphics.rectangle ("fill", rooms[roomIndex].x , rooms[roomIndex].y , rooms[roomIndex].width, rooms[roomIndex].height)
    end
end

local function DrawPerson(person, room, xpos, ypos)
    love.graphics.setColor({0,1,0})
    love.graphics.circle("fill", room.x + personGap * xpos, room.y + personGap * ypos, personSize/2) 
end

local function DrawPerson2(person)
    roomIdx = person.classes[1].room 
    room = rooms[roomIdx]
    xpos = person.classes[1].row 
    ypos = person.classes[1].col 
    love.graphics.setColor({0,1,0})    
    love.graphics.circle("fill", room.x + personGap * xpos, room.y + personGap * ypos, personSize/2) 
end


local function DrawPeople()
    --draw person
    -- for room = 1, table.getn(rooms) do 
    --     for row = 1, 5 do 
    --         for col = 1 , 5 do
    --             DrawPerson({}, rooms[room], row,col)
    --         end
    --     end    
    -- end
       for person =1, table.getn(population) do 
            DrawPerson2(population[person])
       end
end


function love.load()
    windowWidth = width + borderSize *  2
    windowHeight = height + borderSize * 2   
    love.window.setMode(windowWidth, windowHeight, {resizable=false})
    love.window.setTitle("Virus spread in Schools - Simulation")
    SetupSimulation()
end 


function love.draw()
   DrawClassrooms()
   --DrawPeople()
end 
