--[[
    If you do 'steal' this starting script please give me credits as I spent 5 minutes of my day working on this <3333333
]]

local base_url = "https://raw.githubusercontent.com/xxpwnxxx420lord/Wuno/refs/heads/main/games/"
local url = base_url .. tostring(game.PlaceId)..".lua"
local success, response = pcall(function()
    return game:HttpGet(url)
end)

if success and response and response ~= "" then
    local func, err = loadstring(response)
    if func then
        func()  -- work NOW! 
        setclipboard("https://discord.gg/HwHHvdh5Ef")
    elseif game.PlaceId == 91867617264223 then
        loadstring(game:HttpGet("https://github.com/xxpwnxxx420lord/Wuno/blob/main/games/126884695634066.lua?raw=true",true))()
    else
        setclipboard("https://discord.gg/HwHHvdh5Ef")
        game.Players.LocalPlayer:Kick("Currently, there is no universal script available. If this is a bug, please visit our support channel at Discord (copied in your clipboard) for assistance with supported games. The link has been copied to your clipboard for your convenience.")
    end
end
