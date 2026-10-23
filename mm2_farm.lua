-- Удаляем старое меню, если оно было, чтобы не плодились кнопки
if game:GetService("CoreGui"):FindFirstChild("MyMm2FarmUI") then
    game:GetService("CoreGui").MyMm2FarmUI:Destroy()
end

-- Создаем интерфейс прямо через движок Roblox (это сработает везде!)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "MyMm2FarmUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Настройки кнопки на экране
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0) -- Кнопка будет слева вверху экрана
ToggleButton.Size = UDim2.new(0, 160, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "ФАРМ: ВЫКЛ"
ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextSize = 18.000

UICorner.Parent = ToggleButton

-- Логика фарма
local FarmEnabled = false
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

local function flyTo(targetCFrame)
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local duration = distance / 25
    local tween = TweenService:Create(rootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local function getCoin()
    local container = Workspace:FindFirstChild("NormalCoins", true) or Workspace:FindFirstChild("CoinContainer", true) or Workspace:FindFirstChild("CandyContainer", true)
    if container then
        for _, object in pairs(container:GetChildren()) do
            if object:IsA("BasePart") or object:FindFirstChild("CoinVisual") then
                return object
            end
        end
    end
    return nil
end

-- Нажатие на кнопку
ToggleButton.MouseButton1Click:Connect(function()
    FarmEnabled = not FarmEnabled
    if FarmEnabled then
        ToggleButton.Text = "ФАРМ: ВКЛ"
        ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        task.spawn(function()
            while FarmEnabled do
                task.wait(0.3)
                local character = localPlayer.Character
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local targetCoin = getCoin()
                    if targetCoin and FarmEnabled then
                        flyTo(targetCoin.CFrame * CFrame.new(0, 2, 0))
                        task.wait(0.1)
                    end
                end
            end
        end)
    else
        ToggleButton.Text = "ФАРМ: ВЫКЛ"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
