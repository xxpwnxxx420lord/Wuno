---@diagnostic disable: undefined-global

-- Variables --

local roflex = {}


-- Local functions --

local function running()
    return roflex_ran
end

local function delete(instance: Instance, delay: number) -- Going to be used later on coming with updates.
    if not delay or type(delay) ~= "number" then
        delay = 0
    end

    assert(instance ~= nil, "Param. must be existant!")
    assert(typeof(instance) == "Instance", "Param. must be of-type Instance!")

    task.delay(delay, function()
        instance:Destroy()
    end)
end

local function deliver(text: string)
    if not text then
        return
    end

    local message = Instance.new("Message", workspace)

    message.Text = text
    delete(message, 2)
end


-- Actual framework functions --

roflex.launch = function()
    if not running() then
        getgenv().roflex_ran = true
    end
end

roflex.add = function(parent: Instance, name: string, class: string, properties: table)
    if running() then
        local newInstance = Instance.new(class, parent) do
            newInstance.Name = name
        end

        if properties then
            if class == "TextButton" or class == "ImageButton" and properties["Callback"] then
                newInstance.MouseButton1Click:Connect(properties["Callback"])
            end

            if class == "TextBox" then
                if properties["Callback"] then
                    newInstance.FocusLost:Connect(function(released)
                        if released then
                            properties["Callback"]()
                        end
                    end)
                end
            end

            for key, value in properties do
                if key ~= "Callback" then
                    newInstance[key] = value
                end
            end
        end

        return newInstance
    else
        deliver("Roflex must be initialized before declaring interfaces!")
    end
end

roflex.remove = function(instance: Instance, delay: number)
    delete(instance, delay)
end

return roflex
