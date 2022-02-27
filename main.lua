-- Chuck Norris Joke Bot configuration file (v1.0)
-- Makes a hook into the Chuck Norris Joke API: https://api.chucknorris.io/
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local discordia = require('discordia')
local Discord = discordia.Client()

local json = require('json')
local coro = require("coro-http")
local settings = require('settings')

local function StrSplit(msg)
    local args = {}
    for arg in msg:gmatch('([^%s]+)') do
        args[#args + 1] = arg
    end
    return args
end

Discord:on('ready', function()
    local Server = Discord:getGuild(settings.discord_server_id)
    if (Server) then
        Discord:info('Ready: ' .. Discord.user.tag)
    end
end)

local function HTTP_GET(URL)
    local _, body = coro.request('GET', URL)
    return json.parse(body)
end

local function FindCategory(picked)
    for i = 1, #settings.categories do
        local category = settings.categories[i]
        if (picked == category) then
            return category
        end
    end
    return false
end

local concat = table.concat
Discord:on('messageCreate', function(msg)

    if (not msg.author or msg.author.id == Discord.user.id or msg.author.bot) then
        return
    end

    local args = StrSplit(msg.content)
    if (args[1] == settings.command) then
        if (args[2] == 'categories') then
            local body = concat(settings.categories, '\n')
            msg:reply('<@!' .. msg.member.id .. '>\n' .. body)
        elseif (args[2]) then
            local category = FindCategory(args[2])
            if (category) then
                local body = HTTP_GET('https://api.chucknorris.io/jokes/random?category=' .. category)
                msg:reply('<@!' .. msg.member.id .. '>, ' .. body.value)
            else
                msg:reply('<@!' .. msg.member.id .. '>, Invalid category. Type `' .. args[1] .. ' categories` for a list')
            end
        else
            local body = HTTP_GET('https://api.chucknorris.io/jokes/random')
            msg:reply('<@!' .. msg.member.id .. '>, ' .. body.value)
        end
    end
end)

Discord:run('Bot ' .. settings.token())
Discord:setGame('Joke Bot')