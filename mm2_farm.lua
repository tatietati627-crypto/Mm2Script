-- Загружаем красивую библиотеку интерфейса для мобильных устройств
local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Window = Library.CreateLib("MM2 Личный Скрипт", "DarkTheme")

-- Создаем вкладку в меню
local MainTab = Window:NewTab("Авто-Фарм")
local Section = MainTab:NewSection("Основные функции")

-- Переменная, которая отвечает за включение и выключение фарма
local FarmEnabled = false

-- Подключаем службы Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

-- Функция безопасного полета
local function flyTo(targetCFrame)
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local speed = 30 -- Скорость полета
    local duration = distance / speed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, {CFrame = targetCFrame}, tweenInfo)
    
    tween:Play()
    tween.Completed:Wait()
end

-- Функция поиска монет
local function getCoin()
    local normalCoins = Workspace:FindFirstChild("NormalCoins", true)
    local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
    local candyContainer = Workspace:FindFirstChild("CandyContainer", true)
    
    local container = normalCoins or coinContainer or candyContainer
    
    if container then
        for _, object in pairs(container:GetChildren()) do
            if object:IsA("BasePart") or object:FindFirstChild("CoinVisual") then
                return object
            end
        end
    end
    return nil
end

-- Кнопка-переключатель (Toggle) в меню
Section:NewToggle("Включить Авто-Фарм монет", "Персонаж начнет собирать монеты", function(state)
    FarmEnabled = state
    
    -- Запускаем фарм в отдельном потоке, чтобы меню не зависало
    if FarmEnabled then
        task.spawn(function()
            while FarmEnabled do
                task.wait(0.3)
                local character = localPlayer.Character
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local targetCoin = getCoin()
                    if targetCoin and FarmEnabled then
                        local targetCFrame = targetCoin.CFrame * CFrame.new(0, 2, 0)
                        flyTo(targetCFrame)
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)
