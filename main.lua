function love.load()

    --THIS IS HOW I ADD LIBRARIES

    anim8 = require 'libraries/anim8'
    sti = require 'libraries/sti'
    camera = require 'libraries/camera'

    --gameMap variable
    gameMap = sti("maps/TestMap.lua")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --cam variable
    cam=camera()


    player = {}
    player.x = 200
    player.y = 200
    player.speed = 3
    --player.sprite = love.graphics.newImage('sprites/parrot.png')
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2)

    love.window.setMode(800, 600, {resizable=true, vsync=1, minwidth=400, minheight=300})

    player.anim = player.animations.left

    --background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)

    local isMoving = false

    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("a")then 
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    --quit game
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- 
    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    --left side border of window
    if cam.x < w/2 then
        cam.x = w/2
    end

    --top border of window
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    --right side border of window
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    
    --bottom border of windowa
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
    cam:attach()
        --gameMap:draw()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        gameMap:drawLayer(gameMap.layers["Tile Layer 2"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 7, nil, 6, 9)
        -- 6 and 9 because half of height and width of the sprite
    cam:detach()
    love.graphics.print(player.x .. '\n' .. player.y , 10, 10)
end

