-- Playdate Runner

-- Thanks https://github.com/Whitebrim/AnimatedSprite for AnimatedSprite
import 'AnimatedSprite.lua'

local gfx <const> = playdate.graphics  -- common in playdate games, makes code cleaner

-- create player
-- make sure to update sprite from level 1-1 example
local imageTable <const> = gfx.imagetable.new("img/player-table-16-32")
local player <const> = AnimatedSprite.new(imageTable)

-- create projectile that player shoots
local projectileImage <const> = gfx.image.new(5, 5, gfx.kColorBlack)
local projectileSprite <const> = gfx.sprite.new(projectileImage)
local isProjectileFired = false

-- create ground obstacles player jumps over
local groundObstacleImage <const> = gfx.image.new(20, 30, gfx.kColorBlack)
local groundObstacleCount <const> = 5  -- amount of obstacles in each "round"
local baseGroundObstacleSpeed <const> = -2  -- obstacles are moving left, so this is negative
local maxGroundObstacleSpeed <const> = -5
local groundObstacles = {}  -- holds all obstacles, we do this because we need to keep track of multiple obstacles
local groundObstacleXValues = {}
local addedGroundObstacleSpeed = 0

local falling = false -- refers to player
local score = 0
local highestScore = 0

-- better scheme for tracking gamestate
-- 0 for normal gameplay, 1 for pause, 2 for loss
local playing <const>, paused <const>, lost <const> = 0, 1, 2
local gameState = playing

function drawBase ()
    -- create ground
    local groundImage <const> = gfx.image.new(400, 5, gfx.kColorBlack)
    local groundSprite <const> = gfx.sprite.new(groundImage)

    -- add player sprite to screen
    player:moveTo(30, 160)
    -- these should probably not be constant values - if you hold your arms out you'll collide with something faster
    player:setCollideRect(0, 0, 16, 27)
    player:add()
    player:playAnimation()

    -- add projectile to screen (not shown yet)
    projectileSprite:setCollideRect(0, 0, projectileSprite:getSize())
    projectileSprite:moveTo(-2, -2)

    -- add ground to screen
    groundSprite:moveTo(200, 180)
    groundSprite:add()
end

function createObstacles ()
    local baseX = 400; -- this is the edge of the playdate screen, but it could be something else
    
    for i = 1, groundObstacleCount, 1 do
        -- generate x coords for obstacles
        groundObstacleXValues[i] = math.random(baseX, baseX + 50)
        baseX = baseX + 175

        -- create obstacle if not exist
        if groundObstacles[i] == nil then
            groundObstacles[i] = gfx.sprite.new(groundObstacleImage)
            groundObstacles[i]:setCollideRect(0, 0, groundObstacles[i]:getSize())
        end

        -- move to starting position (can be used to reposition)
        groundObstacles[i]:moveTo(groundObstacleXValues[i], 160)
        -- groundObstacles[i]:add()
    end
end

function reset ()
    score = 0
    addedGroundObstacleSpeed = 0
    isProjectileFired = false
    projectileSprite:remove()
    createObstacles()
    player:playAnimation()
    gameState = playing
end

function togglePause()
    if gameState == playing then
        gameState = paused
        player:stopAnimation()
    elseif gameState == paused then
        gameState = playing
        player:playAnimation()
    end
end

drawBase()
createObstacles()
function playdate.update ()
    -- if the game is lost, then continuously print the game over message
    if gameState == lost then
        -- stop the player animation
        player:stopAnimation()

        -- update the highscore if necessary
        if score > highestScore then
            highestScore = score
        end

        -- print the gameover text
        gfx.drawText("YOU LOSER!", 200, 60)
        gfx.drawText("(B to reset)", 200, 80)
        
        -- allow the player to restart
        if playdate.buttonIsPressed(playdate.kButtonB) then
            reset()
        end

        return -- so that nothing below is executed (no pausing/unpausing during gameover screen)
    end

    -- toggle the paused state
    if playdate.buttonJustPressed(playdate.kButtonB) then
        togglePause()
    end

    -- don't do anything if the game is paused 
    if gameState == paused then 
        return  -- so that nothing below is executed
    end


    -- since two of the three gameStates are covered above (lost and paused), 
    -- by this point gameState must be playing
    

    -- Check that player is on the ground before jumping, this prevents mid air jumps
    if playdate.buttonIsPressed(playdate.kButtonUp) and falling == false then
        player:moveBy(0, -4)
        -- it's not realistic to jump off the screen
        if player.y < 90 then
            falling = true
        end
    else
        falling = true
        if player.y < 160 then
            player:moveBy(0, 2)
        else
            falling = false
        end
    end

    -- cant fire a projectile if you just did or if you are in the air
    if playdate.buttonIsPressed(playdate.kButtonA) and isProjectileFired == false and falling == false then
        projectileSprite:moveTo(45, 150)
        projectileSprite:add()
        isProjectileFired = true
    end

    -- refresh screen
    gfx.sprite.update()

    gfx.drawText(score, 5, 5)
    gfx.drawText("High score: ", 5, 25)
    gfx.drawText(highestScore, 95, 25)
    gfx.drawText("Like the game? Join Programming Club today!", 30, 185)
    gfx.drawText("https://discord.gg/Pvv2Eu8FrF", 80, 210)

    -- obstacle movement and collision detection
    for i, obstacleSprite in pairs(groundObstacles) do
        -- move the obstacles towards the player
        obstacleSprite:moveBy(baseGroundObstacleSpeed + addedGroundObstacleSpeed, 0)

        -- if the obstacle is onscreen, render it
        if obstacleSprite.x >= -7 and obstacleSprite.x <= 407 then
            obstacleSprite:add()
        -- otherwise, remove it
        elseif obstacleSprite.x <= -7 then
            obstacleSprite:remove()
        end

        -- check if the player has hit an obstacle
        if #player:overlappingSprites() > 0 then
            gameState = lost
        end

        -- check if the player has completed a round (last obstacle in 
        -- round has gone offscreen) and update points/obstacle
        if groundObstacles[groundObstacleCount].x <= 0 then
            createObstacles()
            score += 1
            -- obstacles will come at player faster as game progresses
            if (baseGroundObstacleSpeed + addedGroundObstacleSpeed > maxGroundObstacleSpeed) then
                addedGroundObstacleSpeed = addedGroundObstacleSpeed + -0.2
            end
        end
    end

    -- player can only lose if they hit an obstacle, so the game
    -- should check to end only after the collision check
    if gameState == lost then 
        return -- (all gameover logic handled above)
    end

    -- move the projectile
    if isProjectileFired == true then
        projectileSprite:moveBy(3, -3)
        if projectileSprite.x > 400 or projectileSprite.y < 0 then
            projectileSprite:remove()
            isProjectileFired = false
        end
    end
end
