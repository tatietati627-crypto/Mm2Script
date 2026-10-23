-- ====================================================================
-- МОЙ ЛИЧНЫЙ СКРИПТ АВТО-ФАРМА ДЛЯ MURDER MYSTERY 2
-- ====================================================================

-- 1. Подключаем системные службы Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

-- 2. Функция для плавного и безопасного полета к монете (защита от бана)
local function flyTo(targetCFrame)
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local speed = 25 -- Безопасная скорость перемещения
    local duration = distance / speed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, {CFrame = targetCFrame}, tweenInfo)
    
    tween:Play()
    tween.Completed:Wait() -- Скрипт ждет, пока персонаж долетит до точки
end

-- 3. Функция поиска монет или конфет на карте раунда
local function getCoin()
    -- Проверяем все возможные папки, куда MM2 может спрятать монеты
    local normalCoins = Workspace:FindFirstChild("NormalCoins", true)
    local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
    local candyContainer = Workspace:FindFirstChild("CandyContainer", true)
    
    local container = normalCoins or coinContainer or candyContainer
    
    if container then
        for _, object in pairs(container:GetChildren()) do
            -- Проверяем, что объект живой и его можно подобрать
            if object:IsA("BasePart") or object:FindFirstChild("CoinVisual") then
                return object
            end
        end
    end
    return nil
end

-- 4. Главный мотор скрипта — бесконечный цикл фарма
print("[Мой Скрипт]: Авто-фарм успешно активирован!")

while true do
    task.wait(0.5) -- Небольшая пауза, чтобы Delta не зависала и не вылетала
    
    local character = localPlayer.Character
    -- Проверяем, жив ли наш персонаж
    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        
        local targetCoin = getCoin()
        if targetCoin then
            -- Приподнимаем точку над монетой на 2 ступени, чтобы не застревать в текстурах пола
            local targetCFrame = targetCoin.CFrame * CFrame.new(0, 2, 0)
            
            -- Летим к цели
            flyTo(targetCFrame)
            task.wait(0.1) -- Даем игре время засчитать подбор монеты
        end
    end
end
