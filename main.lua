
io.stdout:setvbuf("no")

if arg[#arg] == "-debug" then require("mobdebug").start() end


-- variables

local state = "menu"

--
local font = love.graphics.newFont('assets/font.ttf', 100)
local font2 = love.graphics.newFont('assets/font.ttf', 50)
local font3 = love.graphics.newFont('assets/font.ttf', 20)

--
-- FOR MENU !!!
--

local titleText = love.graphics.newText(font, "MEMORIZE")
local titleText2 = love.graphics.newText(font, "THE GRID")
local subtitleText = love.graphics.newText(font2, "Press space to continue")

--
-- FOR HELP !!!
--
local helpTitleText = love.graphics.newText(font, "HELP")
local helpTexts = {}
table.insert(helpTexts, love.graphics.newText(font3, "Vous devez mémorisez un dessin"))
table.insert(helpTexts, love.graphics.newText(font3, "réalisé sur une grille et, vous"))
table.insert(helpTexts, love.graphics.newText(font3, "allez devoir le reproduire sur"))
table.insert(helpTexts, love.graphics.newText(font3, "une map. Cependant, vous devrai"))
table.insert(helpTexts, love.graphics.newText(font3, "déplacer des blocs. Certain se"))
table.insert(helpTexts, love.graphics.newText(font3, "déplacent en les poussants mais"))
table.insert(helpTexts, love.graphics.newText(font3, "d'autres doivent être bougés à l'aide"))
table.insert(helpTexts, love.graphics.newText(font3, "de quelque chose."))
table.insert(helpTexts, love.graphics.newText(font2, "Press space to start"))

--
-- LEVELS
--

local currentLevel = 1

local levels = {}
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})

--
-- MEMORISE MENU
--

local memoriseChrono = 10

local memoriseText = love.graphics.newText(font2, "Mémorisez : ")

--
-- GAME
--

local timeLeftChrono = 120
local timeLeftText = love.graphics.newText(font2, "Temps restant : ")

local map = {}
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})



local images = {}

table.insert(images, love.graphics.newImage("assets/tile1.png"))
table.insert(images, love.graphics.newImage("assets/tile2.png"))

local TILE_SIZE = 70

-- PLAYER

local player = {}

player.row = 5
player.col = 5
player.level = 3
player.image = love.graphics.newImage('assets/player.png')

-- camera

local camera = {}

camera.x = 0
camera.y = 0

--
-- POPUPS
--
popups = {}
one_popup_show = false

table.insert(popups, {texts = {
  love.graphics.newText(font3, "Déplacez-vous avec les"),
  love.graphics.newText(font3, "flèches du clavier."),
  love.graphics.newText(font3, "Marcher dans la direction"),
  love.graphics.newText(font3, "des blocs pour les bouger."),
}, shown = false})

-- functions
function DrawMap(m, drawPlayer)
  for row=1,#m do
    for col=1,#m[row] do
      for level=1,#m[row][col] do
        
        local tile = m[row][col][level]
        local x = (row - col) * TILE_SIZE / 2
        local y = ((row + col) * TILE_SIZE / 4) - level * TILE_SIZE / 2
        
        if tile > 0 then
          love.graphics.draw(images[tile], x - camera.x, y - camera.y, 0, TILE_SIZE / images[tile]:getWidth(), TILE_SIZE / images[tile]:getHeight())
        end
        
        if drawPlayer then
          if player.row == row and player.col == col and player.level == level then
            love.graphics.draw(player.image, x - camera.x + 10, y - camera.y, 0, (TILE_SIZE - 20) / player.image:getWidth(), TILE_SIZE / player.image:              getHeight())
          end
        end
        
      end
    end
  end
end


-- JE SAIS QUE J'AI COPIE CA SUR INTERNET MAIS C'EST PAS IMPORTANT
-- (Sert à comparer deux tableaux si ils sont égals)
function equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

function love.load()
  
  love.window.setMode(1280, 720, {fullscreen = true, minwidth=400, minheight=300})
  love.window.setTitle("Memorise The Grid")
  
end

function love.update(dt)
  
  -- set if one poup is shown
  local nbrPopupsShown = 0
  for i=1,#popups do
    if popups[i].shown then
      nbrPopupsShown = nbrPopupsShown + 1
    end
  end
  if nbrPopupsShown > 0 then
    one_popup_show = true
  else
    one_popup_show = false
  end
  
  -- MOVE CAMERA
  
  if one_popup_show == false then
    if state == "game" or state == "memorise" then
      camera.x = ((player.row - player.col) * TILE_SIZE / 2) - love.graphics.getWidth() / 2.3
      camera.y = ((player.row + player.col) * TILE_SIZE / 4) - love.graphics.getHeight() / 2.3
    
      -- MAKE PLAYER FALL
    
      if map[currentLevel][player.row][player.col][player.level - 1] == 0 then
          player.level = player.level - 1
      end
      
    end
  
    if state == "memorise" then
      memoriseChrono = memoriseChrono - dt
      local memoriseTextValue = "Mémoriser : "..math.floor(memoriseChrono).."s"
      memoriseText = love.graphics.newText(font2, memoriseTextValue)
      
      if memoriseChrono < 0 then
        state = "game"
        if currentLevel == 1 then
          popups[1].shown = true
        end
      end
      
    end
    
    if state == "game" then
      if equals(map[currentLevel], levels[currentLevel], false) then
        state = "won"
      end
      
      timeLeftChrono = timeLeftChrono - dt
      local timeLeftTextValue = "Temps restant : "..math.floor(timeLeftChrono).."s"
      timeLeftText = love.graphics.newText(font2, timeLeftTextValue)
      
      if timeLeftChrono < 0 then
        state = "lost"
      end
      
    end
  end
  
end

function love.draw()
  
  if state == "menu" then
    love.graphics.draw(titleText, love.graphics.getWidth() / 4, love.graphics.getHeight() / 3)
    love.graphics.draw(titleText2, love.graphics.getWidth() / 4, love.graphics.getHeight() / 2.2)
    love.graphics.draw(subtitleText, love.graphics.getWidth() / 4, love.graphics.getHeight() / 1.5)
  end
  if state == "help" then
    love.graphics.draw(helpTitleText, love.graphics.getWidth() / 4, love.graphics.getHeight() / 6)
    for i=1,#helpTexts do
      love.graphics.draw(helpTexts[i], love.graphics.getWidth() / 4, love.graphics.getHeight() / 3.5 + i * 30)
    end
  end
  if state == "memorise" then
    DrawMap(levels[currentLevel], false)
    love.graphics.draw(memoriseText, 10, 10)
  end
  if state == "game" then
    DrawMap(map[currentLevel], true)
    love.graphics.draw(timeLeftText, 10, 10)
  end
  if state == "won" then
    DrawMap(map[currentLevel], false)
  end
  
  if one_popup_show then
    for i=1,#popups do
      if popups[i].shown then
        for j=1,#popups[i].texts do
          love.graphics.draw(popups[i].texts[j], 0, 0 + j * 30)
        end
      end
    end
  end
  
end

function love.keypressed(key)
  
  if one_popup_show == false then
    if state == "menu" then
      if key == "space" then
        state = "help"
      end
      
    elseif state == "help" then
      if key == "space" then
        state = "memorise"
      end
      
    elseif state == "game" then
      if key == "left" then
        if player.row > 1 then
          if map[currentLevel][player.row - 1][player.col][player.level] == 0 then
            player.row = player.row - 1
          end
          if player.row > 3 then
            if map[currentLevel][player.row - 1][player.col][player.level] == 2 then
              player.row = player.row - 1
              if map[currentLevel][player.row - 1][player.col][player.level] == 2 then
                if player.row > 3 then
                  if map[currentLevel][player.row - 2][player.col][player.level] == 2 then
                    player.row = player.row + 1
                  else
                    map[currentLevel][player.row - 2][player.col][player.level] = 2
                    map[currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.row = player.row + 1
                end
              else
                map[currentLevel][player.row - 1][player.col][player.level] = 2
                map[currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "right" then
        if player.row < #map[currentLevel] then
          if map[currentLevel][player.row + 1][player.col][player.level] == 0 then
            player.row = player.row + 1
          end
          if player.row < #map[currentLevel] - 2 then
            if map[currentLevel][player.row + 1][player.col][player.level] == 2 then
              player.row = player.row + 1
              if map[currentLevel][player.row + 1][player.col][player.level] == 2 then
                if player.row < #map[currentLevel] - 2 then
                  if map[currentLevel][player.row + 2][player.col][player.level] == 2 then
                    player.row = player.row - 1
                  else
                    map[currentLevel][player.row + 2][player.col][player.level] = 2
                    map[currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.row = player.row - 1
                end
              else
                map[currentLevel][player.row + 1][player.col][player.level] = 2
                map[currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "up" then
        if player.col > 1 then
          if map[currentLevel][player.row][player.col - 1][player.level] == 0 then
            player.col = player.col - 1
          end
          if player.col > 3 then
            if map[currentLevel][player.row][player.col - 1][player.level] == 2 then
              player.col = player.col - 1
              if map[currentLevel][player.row][player.col - 1][player.level] == 2 then
                if player.col > 3 then
                  if map[currentLevel][player.row][player.col - 2][player.level] == 2 then
                    player.col = player.col + 1
                  else
                    map[currentLevel][player.row][player.col - 2][player.level] = 2
                    map[currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.col = player.col + 1
                end
              else
                map[currentLevel][player.row ][player.col - 1][player.level] = 2
                map[currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "down" then
        if player.col < #map[currentLevel][player.col] then
          if map[currentLevel][player.row][player.col + 1][player.level] == 0 then
            player.col = player.col + 1
          end
          if player.col < #map[currentLevel][player.col] - 2 then
            if map[currentLevel][player.row][player.col + 1][player.level] == 2 then
              player.col = player.col + 1
              if map[currentLevel][player.row][player.col + 1][player.level] == 2 then
                if player.col < #map[currentLevel][player.col] - 2 then
                  if map[currentLevel][player.row][player.col + 2][player.level] == 2 then
                    player.col = player.col - 1
                  else
                    map[currentLevel][player.row][player.col + 2][player.level] = 2
                    map[currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.col = player.col - 1
                end
              else
                map[currentLevel][player.row ][player.col + 1][player.level] = 2
                map[currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      
    end
    
  end
    
end