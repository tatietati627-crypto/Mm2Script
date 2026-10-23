-- MM2 Halloween Farm - свой скрипт
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MyMM2Farm"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Кнопка открытия
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 90, 0, 35)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Text = "MM2 Farm"
openBtn.Parent = gui

-- Окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 280)
frame.Position = UDim2.new(0.5, -115, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Visible = false
frame.Parent = gui

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Функция кнопок
local function makeToggle(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text .. " : OFF"
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- === АВТОФАРМ КОНФЕТ ===
-- ВАЖНО: имя объекта "Candy" может отличаться в текущем обновлении.
-- Если не работает - открой эксплорер Delta и найди точное имя.
local candyFarmRunning = false

makeToggle("Автофарм конфет", 10, function(on)
    candyFarmRunning = on
    if not on then return end
    
    task.spawn(function()
        while candyFarmRunning do
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(0.5)
                continue
            end
            
            local root = char.HumanoidRootPart
            local found = false
            
            -- Ищем конфеты по имени "Candy" (поменяй если не работает)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("candy") then
                    root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    found = true
                    task.wait(0.15)
                    break
                end
            end
            
            if not found then
                task.wait(0.5)
            end
        end
    end)
end)

-- === СКОРОСТЬ ===
makeToggle("Скорость x3", 50, function(on)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = on and 48 or 16
    end
end)

-- === РЕСЕТ ПОСЛЕ СБОРА ===
makeToggle("Ресет (сброс)", 90, function(on)
    if on and player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end)

-- === УБИТЬ МАРДЕРА ===
-- Проверяет нож (Knife) у игроков. В MM2 у мардера есть Knife.
makeToggle("Убить мардера", 130, function(on)
    if not on then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hasKnife = p.Character:FindFirstChild("Knife")
            if hasKnife then
                char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                task.wait(0.1)
            end
        end
    end
end)
