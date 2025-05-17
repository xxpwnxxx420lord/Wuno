local base_url = "https://raw.githubusercontent.com/xxpwnxxx420lord/Wuno/games/"
local url = base_url .. tostring(game.PlaceId)
local success, response = pcall(function()
    return game:HttpGet(url)
end)
if success and response and response ~= "" then
    local func, err = loadstring(response)
    if func then
        local ok, result = pcall(func)
        if not ok then
            warn("Error running the loaded script: ".. tostring(result))
        end
    else
        warn("Failed to load script: " .. tostring(err))
    end
else
    warn("Failed to fetch script from URL or empty response")
end
