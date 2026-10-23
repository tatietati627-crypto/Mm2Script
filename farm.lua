-- MM2 Candy Fly Farm - финальная версия с GUI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Ждём PlayerGui, чтобы GUI точно появился
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

-- Удаляем старое окно, если есть
local old = playerGui:FindFirstChild("MM2FarmGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2FarmGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Главная панель
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 340)
main.Position = UDim2.new(0.5, -130, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Анимация появления
main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 260, 0, 340)
}):Play()

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.Text = "Candy Fly Farm"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Переменные
local flying = false
local candyName = "Candies"
local flySpeed = 23

-- Функция кнопок
local function makeButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Text = text .. "  OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. "  " .. (state and "ON" or "OFF")
        -- Анимация нажатия
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(40, 40, 50)
        }):Play()
        callback(state)
    end)
end

-- Fly Farm
makeButton("Fly Farm Candies", 50, function(on)
    flying = on
    if not on then return end
    task.spawn(function()
        while flying do
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(0.3) continue
            end
            local root = char.HumanoidRootPart
            local target = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == candyName then
                    target = obj break
                end
            end
            if target then
                local dir = (target.Position - root.Position).Unit
                root.Velocity = dir * flySpeed
                task.wait(0.1)
            else
                task.wait(0.4)
            end
        end
    end)
end)

-- WalkSpeed
makeButton("WalkSpeed 23", 95, function(on)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = on and 23 or 16
    end
end)

-- Hip Height
makeButton("Hip Height -1.5", 140, function(on)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.HipHeight = on and -1.5 or 0
    end
end)

-- Reset
makeButton("Reset Character", 185, function(on)
    if on and player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end)

-- Защита от падения
task.spawn(function()
    while true do
        task.wait(0.5)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            if root.Position.Y < -100 then
                root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z)
            end
        end
    end
end)
