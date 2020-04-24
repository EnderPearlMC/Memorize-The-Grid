
io.stdout:setvbuf("no")

if arg[#arg] == "-debug" then require("mobdebug").start() end

local json = require "json"

-- variables

local state = "menu"

local music = love.audio.newSource("assets/maintheme.mp3", "stream")

local breakSound = love.audio.newSource("assets/break.wav", "static")
local moveSound = love.audio.newSource("assets/move.wav", "static")
local winSound = love.audio.newSource("assets/win.wav", "static")
local lostSound = love.audio.newSource("assets/lost.wav", "static")

local font = love.graphics.newFont('assets/font.ttf', 100)
local font2 = love.graphics.newFont('assets/font.ttf', 50)
local font3 = love.graphics.newFont('assets/font.ttf', 20)
local font4 = love.graphics.newFont('assets/font.ttf', 30)

local escText = love.graphics.newText(font4, "Press escape to quit")

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

--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
--  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}

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
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 3, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(levels, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})

--
-- MEMORISE MENU
--

local memoriseChrono = 10

local memoriseText = love.graphics.newText(font2, "Mémoriser : ")

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
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2 , 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})
table.insert(map, {
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 4, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 3}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 3, 0}, {1, 1, 3, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 2, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}},
  {{1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}, {1, 1, 0, 0}}
})


local images = {}

table.insert(images, love.graphics.newImage("assets/tile1.png"))
table.insert(images, love.graphics.newImage("assets/tile2.png"))
table.insert(images, love.graphics.newImage("assets/tile3.png"))
table.insert(images, love.graphics.newImage("assets/tile4.png"))

local TILE_SIZE = 70

-- PLAYER

local player = {}

player.row = 5
player.col = 5
player.level = 3
player.image = love.graphics.newImage('assets/player.png')
player.moneyText = love.graphics.newText(font2, "0$")
-- camera

local camera = {}

camera.x = 0
camera.y = 0

--
-- WON MENU
--

local wonTitleText = love.graphics.newText(font, "GAGNÉ !")
local wonTitleY = -50
local wonMenuAnimationOver = false
local wonContinueText = love.graphics.newText(font2, "Press space to continue")

--
-- LOST MENU
--

local lostTitleText = love.graphics.newText(font, "PERDU :-(")
local lostTitleY = -50
local lostMenuAnimationOver = false
local lostContinueText = love.graphics.newText(font2, "Press space to try again")

--
-- POPUPS
--
popups = {}
one_popup_show = false

table.insert(popups, {texts = {
  love.graphics.newText(font3, "Maintenant, mémorisez"),
  love.graphics.newText(font3, "les blocs rouges pour les"),
  love.graphics.newText(font3, "reproduire après.")
}, shown = false})
table.insert(popups, {texts = {
  love.graphics.newText(font3, "Déplacez-vous avec les"),
  love.graphics.newText(font3, "flèches du clavier."),
  love.graphics.newText(font3, "Marcher dans la direction"),
  love.graphics.newText(font3, "des blocs pour les bouger.")
}, shown = false})
table.insert(popups, {texts = {
  love.graphics.newText(font3, "Continue sur cette"),
  love.graphics.newText(font3, "lancée ! Un nouvel"),
  love.graphics.newText(font3, "élement sera disponible"),
  love.graphics.newText(font3, "dans le prochain niveau.")
}, shown = false})
table.insert(popups, {texts = {
  love.graphics.newText(font3, "Il y a maintenant des murs."),
  love.graphics.newText(font3, "Vous ne pouvez pas pousser"),
  love.graphics.newText(font3, "de blocs dessus. Bonne chance !")
}, shown = false})
table.insert(popups, {texts = {
  love.graphics.newText(font3, "Il y a maintenant des minerais."),
  love.graphics.newText(font3, "Pour les casser, entourez-les"),
  love.graphics.newText(font3, "de blocs rouges ! (8 blocs)")
}, shown = false})

--
-- FILES
--

local fileContent = {
  money = 0,
  currentLevel = 1
}

function WriteFile(path, data)
  local file = io.open(path, "w")
  file:write(data)
  file:close()
end

function ReadFile(path)
  local file = io.open(path, "r")
  local temp = file:read("*line")
  file:close()
  return temp
end

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
  
  music:play()
  music:setLooping(true)
  
  if not love.filesystem.getInfo("game.json") then
    WriteFile('game.json', json.stringify(fileContent))
  end

  fileContent = json.parse(ReadFile("game.json"))
  
end

function love.update(dt)
  
  dt = math.min(dt, 1/60)
  
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
  
  -- set player money
  local valueMoneyText = fileContent.money .. "$"
  player.moneyText = love.graphics.newText(font2, valueMoneyText)
  
  -- MOVE CAMERA
  
  if one_popup_show == false then
    if state == "game" or state == "memorise" then
      camera.x = ((player.row - player.col) * TILE_SIZE / 2) - love.graphics.getWidth() / 2.3
      camera.y = ((player.row + player.col) * TILE_SIZE / 4) - love.graphics.getHeight() / 2.3
    
      -- MAKE PLAYER FALL
    
      if map[fileContent.currentLevel][player.row][player.col][player.level - 1] == 0 then
          player.level = player.level - 1
      end
      
    end
  
    if state == "memorise" then
      memoriseChrono = memoriseChrono - dt
      local memoriseTextValue = "Mémoriser : "..math.floor(memoriseChrono).."s"
      memoriseText = love.graphics.newText(font2, memoriseTextValue)
      
      if memoriseChrono <= 0 then
        state = "game"
        if fileContent.currentLevel == 1 then
          popups[2].shown = true
          memoriseChrono = 10
          timeLeftChrono = 120
        end
        if fileContent.currentLevel == 2 then
          memoriseChrono = 10
          timeLeftChrono = 120
          popups[3].shown = true
        end
        if fileContent.currentLevel == 3 then
          memoriseChrono = 17
          timeLeftChrono = 120
          popups[4].shown = true
        end
        if fileContent.currentLevel == 4 then
          memoriseChrono = 20
          timeLeftChrono = 200
        end
        if fileContent.currentLevel == 5 then
          memoriseChrono = 20
          timeLeftChrono = 200
        end
        if fileContent.currentLevel == 6 then
          memoriseChrono = 25
          timeLeftChrono = 220
          popups[5].shown = true
        end
      end
      
    end
    
    if state == "game" then
      if equals(map[fileContent.currentLevel], levels[fileContent.currentLevel], false) then
        state = "won"
        fileContent.money = fileContent.money + 20
        WriteFile("game.json", json.stringify(fileContent))
        winSound:play()
      end
      
      timeLeftChrono = timeLeftChrono - dt
      local timeLeftTextValue = "Temps restant : "..math.floor(timeLeftChrono).."s"
      timeLeftText = love.graphics.newText(font2, timeLeftTextValue)
      
      if timeLeftChrono <= 0 then
        state = "lost"
        fileContent.money = fileContent.money - 10
        WriteFile("game.json", json.stringify(fileContent))
        lostSound:play()
      end
      
    end
    
    if state == "won" then
      if wonTitleY < love.graphics.getWidth() / 6 and wonMenuAnimationOver == false then
        wonTitleY = wonTitleY + 1000 * dt
      else
        wonMenuAnimationOver = true
      end
    end
    
    if state == "lost" then
      if lostTitleY < love.graphics.getWidth() / 6 and lostMenuAnimationOver == false then
        lostTitleY = lostTitleY + 1000 * dt
      else
        lostMenuAnimationOver = true
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
    if not popups[1].shown and not popups[3].shown and not popups[4].shown then
      DrawMap(levels[fileContent.currentLevel], false)
      love.graphics.draw(memoriseText, 10, 10)
    end
  end
  if state == "game" then
    DrawMap(map[fileContent.currentLevel], true)
    love.graphics.draw(timeLeftText, 10, 10)
  end
  if state == "won" then
    DrawMap(map[fileContent.currentLevel], false)
    if wonMenuAnimationOver then
      love.graphics.draw(wonTitleText, love.graphics.getWidth() / 4, love.graphics.getWidth() / 6)
      love.graphics.draw(wonContinueText, love.graphics.getWidth() / 4, love.graphics.getWidth() / 3)
    else
      love.graphics.draw(wonTitleText, love.graphics.getWidth() / 4, wonTitleY)
    end
  end
  if state == "lost" then
    DrawMap(map[fileContent.currentLevel], false)
    if lostMenuAnimationOver then
      love.graphics.draw(lostTitleText, love.graphics.getWidth() / 4, love.graphics.getWidth() / 6)
      love.graphics.draw(lostContinueText, love.graphics.getWidth() / 4, love.graphics.getWidth() / 3)
    else
      love.graphics.draw(lostTitleText, love.graphics.getWidth() / 4, lostTitleY)
    end
  end
  
  if one_popup_show then
    for i=1,#popups do
      if popups[i].shown then
        for j=1,#popups[i].texts do
          love.graphics.draw(popups[i].texts[j], love.graphics.getWidth() / 2 - popups[i].texts[j]:getWidth() / 2, love.graphics.getHeight() / 3 + j * 30)
        end
        local continue = love.graphics.newText(font4, "Press space to continue")
        love.graphics.draw(continue, love.graphics.getWidth() / 2 - continue:getWidth() / 2, love.graphics.getHeight() / 3 + #popups[i].texts * 30 + 50)
      end
    end
  end
  
  love.graphics.draw(player.moneyText, love.graphics.getWidth() - player.moneyText:getWidth() - 10, 5)
  love.graphics.draw(escText, love.graphics.getWidth() - escText:getWidth() - 10, love.graphics.getHeight() - escText:getHeight() - 5)
  
end

function love.keypressed(key)
  
  if key == "escape" then
    love.event.quit()
  end
  
  if one_popup_show == false then
    if state == "menu" then
      if key == "space" then
        state = "help"
      end
      
    elseif state == "help" then
      if key == "space" then
        state = "memorise"
        camera.x = ((player.row - player.col) * TILE_SIZE / 2) - love.graphics.getWidth() / 2.3
        camera.y = ((player.row + player.col) * TILE_SIZE / 4) - love.graphics.getHeight() / 2.3
        if fileContent.currentLevel == 1 then
          popups[1].shown = true
        end
      end
      
    elseif state == "game" then
      if key == "left" then
        if player.row > 1 then
          if map[fileContent.currentLevel][player.row - 1][player.col][player.level] == 0 then
            player.row = player.row - 1
          elseif player.row > 3 then
            if map[fileContent.currentLevel][player.row - 1][player.col][player.level] == 2 and map[fileContent.currentLevel][player.row - 2][player.col][player.level] ~= 3 then
              player.row = player.row - 1
              if map[fileContent.currentLevel][player.row - 1][player.col][player.level] == 2 and map[fileContent.currentLevel][player.row - 1][player.col][player.level] ~= 3 then
                if player.row > 3 then
                  if map[fileContent.currentLevel][player.row - 2][player.col][player.level] == 2 or map[fileContent.currentLevel][player.row - 2][player.col][player.level] == 3 then
                    player.row = player.row + 1
                  else
                    moveSound:play()
                    map[fileContent.currentLevel][player.row - 2][player.col][player.level] = 2
                    map[fileContent.currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.row = player.row + 1
                end
              else
                moveSound:play()
                map[fileContent.currentLevel][player.row - 1][player.col][player.level] = 2
                map[fileContent.currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "right" then
        if player.row < #map[fileContent.currentLevel] then
          if map[fileContent.currentLevel][player.row + 1][player.col][player.level] == 0 then
            player.row = player.row + 1
          elseif player.row < #map[fileContent.currentLevel] - 2 then
            if map[fileContent.currentLevel][player.row + 1][player.col][player.level] == 2 and map[fileContent.currentLevel][player.row + 2][player.col][player.level] ~= 3 then
              player.row = player.row + 1
              if map[fileContent.currentLevel][player.row + 1][player.col][player.level] == 2 and map[fileContent.currentLevel][player.row + 1][player.col][player.level] ~= 3 then
                if player.row < #map[fileContent.currentLevel] - 2 then
                  if map[fileContent.currentLevel][player.row + 2][player.col][player.level] == 2 or map[fileContent.currentLevel][player.row + 2][player.col][player.level] == 3 then
                    player.row = player.row - 1
                  else
                    moveSound:play()
                    map[fileContent.currentLevel][player.row + 2][player.col][player.level] = 2
                    map[fileContent.currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.row = player.row - 1
                end
              else
                moveSound:play()
                map[fileContent.currentLevel][player.row + 1][player.col][player.level] = 2
                map[fileContent.currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "up" then
        if player.col > 1 then
          if map[fileContent.currentLevel][player.row][player.col - 1][player.level] == 0 then
            player.col = player.col - 1
          elseif player.col > 3 then
            if map[fileContent.currentLevel][player.row][player.col - 1][player.level] == 2 and map[fileContent.currentLevel][player.row][player.col - 2][player.level] ~= 3  then
              player.col = player.col - 1
              if map[fileContent.currentLevel][player.row][player.col - 1][player.level] == 2 and map[fileContent.currentLevel][player.row][player.col - 1][player.level] ~= 3  then
                if player.col > 3 then
                  if map[fileContent.currentLevel][player.row][player.col - 2][player.level] == 2 or map[fileContent.currentLevel][player.row][player.col - 2][player.level] == 3  then
                    player.col = player.col + 1
                  else
                    moveSound:play()
                    map[fileContent.currentLevel][player.row][player.col - 2][player.level] = 2
                    map[fileContent.currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.col = player.col + 1
                end
              else
                moveSound:play()
                map[fileContent.currentLevel][player.row ][player.col - 1][player.level] = 2
                map[fileContent.currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
      if key == "down" then
        if player.col < #map[fileContent.currentLevel][player.col] then
          if map[fileContent.currentLevel][player.row][player.col + 1][player.level] == 0 then
            player.col = player.col + 1
          elseif player.col < #map[fileContent.currentLevel][player.col] - 2 then
            if map[fileContent.currentLevel][player.row][player.col + 1][player.level] == 2 and map[fileContent.currentLevel][player.row][player.col + 2][player.level] ~= 3  then
              player.col = player.col + 1
              if map[fileContent.currentLevel][player.row][player.col + 1][player.level] == 2 and map[fileContent.currentLevel][player.row][player.col + 1][player.level] ~= 3  then
                if player.col < #map[fileContent.currentLevel][player.col] - 2 then
                  if map[fileContent.currentLevel][player.row][player.col + 2][player.level] == 2 or map[fileContent.currentLevel][player.row][player.col + 2][player.level] == 3  then
                    player.col = player.col - 1
                  else
                    moveSound:play()
                    map[fileContent.currentLevel][player.row][player.col + 2][player.level] = 2
                    map[fileContent.currentLevel][player.row][player.col][player.level] = 0
                  end
                else
                  player.col = player.col - 1
                end
              else
                moveSound:play()
                map[fileContent.currentLevel][player.row ][player.col + 1][player.level] = 2
                map[fileContent.currentLevel][player.row][player.col][player.level] = 0
              end
            end
          end
        end
      end
    
    elseif state == "won" then
    
      if key == "space" then
        wonTitleY = -50
        wonMenuAnimationOver = false
        player.row = 5
        player.col = 5
        camera.x = ((player.row - player.col) * TILE_SIZE / 2) - love.graphics.getWidth() / 2.3
        camera.y = ((player.row + player.col) * TILE_SIZE / 4) - love.graphics.getHeight() / 2.3
        fileContent.currentLevel = fileContent.currentLevel + 1
        if fileContent.currentLevel == 2 then
          memoriseChrono = 10
          timeLeftChrono = 120
        end
        if fileContent.currentLevel == 3 then
          memoriseChrono = 17
          timeLeftChrono = 120
        end
        if fileContent.currentLevel == 4 or fileContent.currentLevel == 5 then
          memoriseChrono = 20
          timeLeftChrono = 200
        end
        if fileContent.currentLevel == 6 then
          memoriseChrono = 25
          timeLeftChrono = 220
        end
        WriteFile("game.json", json.stringify(fileContent))
        state = "memorise"
      end
      
    elseif state == "lost" then
    
      if key == "space" then
        lostTitleY = -50
        lostMenuAnimationOver = false
        player.row = 5
        player.col = 5
        camera.x = ((player.row - player.col) * TILE_SIZE / 2) - love.graphics.getWidth() / 2.3
        camera.y = ((player.row + player.col) * TILE_SIZE / 4) - love.graphics.getHeight() / 2.3
        if fileContent.currentLevel == 1 or fileContent.currentLevel == 2 then
          memoriseChrono = 10
          timeLeftChrono = 120
        end
        if fileContent.currentLevel == 3 then
          memoriseChrono = 15
          timeLeftChrono = 150
        end
        if fileContent.currentLevel == 4 then
          memoriseChrono = 20
          timeLeftChrono = 200
        end
        if fileContent.currentLevel == 5 then
          memoriseChrono = 20
          timeLeftChrono = 200
        end
        if fileContent.currentLevel == 6 then
          memoriseChrono = 25
          timeLeftChrono = 220
        end
        WriteFile("game.json", json.stringify(fileContent))
        state = "memorise"
      end
    
    end
    
  else
    
    for i=1,#popups do
      if popups[i].shown then
        if key == "space" then
          popups[i].shown = false
        end
      end
    end 
    
  end
    
end