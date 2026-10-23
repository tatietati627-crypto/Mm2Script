-- MM2 Candy Farm - Fly version
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MM2FlyFarm"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Кнопка
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 35)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Text = "MM2 Fly"
openBtn.Parent = gui

-- Окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 330)
frame.Position = UDim2.new(0.5, -,125, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

 ylocal title = Instance)
.new("TextLabel")
title.Size = UDim2.new(1, 0, 0,    30)
 btntitle.BackgroundColor3 = Color3.Back.fromRGB(35, 35, 35)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Candy Fly Farm"
title.Parent = frame

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Кнопки
local function makeToggle(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 32)
    btn.Position = UDim2.new(0, 10, 0groundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text .. " : OFF"
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

-- ПЕРЕМЕННЫЕ
local flying = false
local candyName = "Candies"
local flySpeed = 23

-- ЛЕТАЮЩИЙ ФАРМ
makeToggle("Fly Farm Candies", 40, function(on)
    flying = on
    if not on then return end

    task.spawn(function()
        while flying do
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(0.3)
                continue
            end

            local root = char.HumanoidRootPart
            local target = nil
            
            -- Ищем Candies
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == candyName then
                    target = obj
                    break
                end
            end

            if target then
                -- ЛЕТИМ К ЦЕЛИ (без телепорта, плавно)
                local direction = (target.Position - root.Position).Unit
                root.Velocity = direction * flySpeed
                task.wait(0.1)
            else
                task.wait(0.4)
            end
        end
    end)
end)

-- СКОРОСТЬ (для ходьбы, если летать не надо)
makeToggle("WalkSpeed 23", 80, function(on)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = on and 23 or 16
    end
end)

-- HIP HEIGHT (лечь под пол)
makeToggle("Hip Height -1.5", 120, function(on)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.HipHeight = on and -1.5 or 0
    end
end)

-- РЕСЕТ
makeToggle("Reset", 160, function(on)
    if on and player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end)

-- ЗАЩИТА ОТ ПАДЕНИЯ
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
