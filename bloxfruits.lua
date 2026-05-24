--// HOLY S4ARCH HUB - BLOX FRUITS
--// Version 2.1 - Fly System
local player = game.Players.LocalPlayer
local ws = game:GetService("Workspace")
local rp = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")

-- Fly переменные
local flying = false
local flySpeed = 50 -- Безопасная скорость (не выше 60)
local flyBodyGyro = nil
local flyBodyVel = nil

-- Функция Fly
local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    if flying then return end
    flying = true
    
    -- BodyGyro для контроля направления
    flyBodyGyro = Instance.new("BodyGyro", hrp)
    flyBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    flyBodyGyro.P = 15000
    flyBodyGyro.CFrame = hrp.CFrame
    
    -- BodyVelocity для движения
    flyBodyVel = Instance.new("BodyVelocity", hrp)
    flyBodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
    
    hum.PlatformStand = true
end

local function stopFly()
    flying = false
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

local function flyTo(targetPos)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    startFly()
    
    -- Летим к цели
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    
    -- Если слишком далеко (>2000), летим быстрее но частями
    if distance > 2000 then
        local direction = (targetPos - startPos).Unit
        local steps = math.ceil(distance / 500)
        for i = 1, steps do
            if not flying then break end
            local nextPos = startPos + direction * (i * 500)
            if i == steps then nextPos = targetPos end
            
            flyBodyGyro.CFrame = CFrame.new(hrp.Position, nextPos)
            flyBodyVel.Velocity = direction * flySpeed
            
            -- Ждём пока долетим до промежуточной точки
            while (hrp.Position - nextPos).Magnitude > 10 and flying do
                flyBodyGyro.CFrame = CFrame.new(hrp.Position, nextPos)
                wait(0.1)
            end
        end
    else
        -- Близко - прямой полёт
        local direction = (targetPos - startPos).Unit
        flyBodyGyro.CFrame = CFrame.new(startPos, targetPos)
        flyBodyVel.Velocity = direction * flySpeed
        
        -- Ждём прибытия
        while (hrp.Position - targetPos).Magnitude > 10 and flying do
            flyBodyGyro.CFrame = CFrame.new(hrp.Position, targetPos)
            wait(0.1)
        end
    end
    
    stopFly()
    
    -- Мягкая посадка
    hrp.Velocity = Vector3.new(0, 0, 0)
end

-- Анти-бан
local function protect(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui); gui.Parent = game.CoreGui
    elseif gethui then gui.Parent = gethui()
    else gui.Parent = game.CoreGui end
end

-- Ключи
local keys = {"xddx-1234-s4archhub", "xddx-5768-s4archhub", "xddx-9013-s4archhub", "xddx-4427-s4archhub"}
local function checkKey(k)
    for i=1,#keys do if k==keys[i] then return true end end
    return false
end

-- Окно ключа
local keyGui = Instance.new("ScreenGui")
protect(keyGui)
local kf = Instance.new("Frame", keyGui)
kf.Size = UDim2.new(0, 350, 0, 200)
kf.Position = UDim2.new(0.5, -175, 0.5, -100)
kf.BackgroundColor3 = Color3.fromRGB(25, 22, 35)
kf.BorderSizePixel = 0

local kt = Instance.new("TextLabel", kf)
kt.Size = UDim2.new(1, 0, 0, 30)
kt.Position = UDim2.new(0, 0, 0, 15)
kt.Text = "🔑 HOLY S4ARCH HUB"
kt.TextColor3 = Color3.fromRGB(200, 150, 255)
kt.Font = Enum.Font.SciFi
kt.TextSize = 20
kt.BackgroundTransparency = 1

local ki = Instance.new("TextBox", kf)
ki.Size = UDim2.new(1, -40, 0, 35)
ki.Position = UDim2.new(0, 20, 0, 60)
ki.PlaceholderText = "xddx-1234-s4archhub"
ki.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ki.Text = ""
ki.TextColor3 = Color3.fromRGB(255, 255, 255)
ki.Font = Enum.Font.SciFi
ki.TextSize = 14
ki.BackgroundColor3 = Color3.fromRGB(40, 35, 50)
ki.BorderSizePixel = 0

local ks = Instance.new("TextLabel", kf)
ks.Size = UDim2.new(1, 0, 0, 20)
ks.Position = UDim2.new(0, 0, 0, 105)
ks.Text = ""
ks.TextColor3 = Color3.fromRGB(255, 100, 100)
ks.Font = Enum.Font.SciFi
ks.TextSize = 12
ks.BackgroundTransparency = 1

local kb = Instance.new("TextButton", kf)
kb.Size = UDim2.new(1, -40, 0, 40)
kb.Position = UDim2.new(0, 20, 0, 135)
kb.Text = "АКТИВИРОВАТЬ"
kb.TextColor3 = Color3.fromRGB(255, 255, 255)
kb.Font = Enum.Font.SciFi
kb.TextSize = 16
kb.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
kb.BorderSizePixel = 0

local granted = false
local function try(k)
    if checkKey(k) then
        ks.Text = "✅ Верно! Загрузка..."
        ks.TextColor3 = Color3.fromRGB(100, 255, 100)
        granted = true
        wait(1)
        keyGui:Destroy()
    else
        ks.Text = "❌ Неверный ключ!"
        ks.TextColor3 = Color3.fromRGB(255, 50, 50)
        ki.Text = ""
    end
end
kb.MouseButton1Click:Connect(function() try(ki.Text) end)
ki.FocusLost:Connect(function(ep) if ep then try(ki.Text) end end)
repeat wait(0.1) until granted or not keyGui.Parent
if not granted then return end

-- Главный GUI
local gui = Instance.new("ScreenGui")
protect(gui)
gui.Name = "HolyS4archHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 750, 0, 480)
main.Position = UDim2.new(0.5, -375, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
main.BorderSizePixel = 0

local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundColor3 = Color3.fromRGB(100, 60, 150)
border.BorderSizePixel = 0
border.ZIndex = 0

local inner = Instance.new("Frame", main)
inner.Size = UDim2.new(1, -4, 1, -4)
inner.Position = UDim2.new(0, 2, 0, 2)
inner.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
inner.BorderSizePixel = 0

local header = Instance.new("Frame", inner)
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
header.BorderSizePixel = 0

local hg = Instance.new("UIGradient", header)
hg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 40, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 70)),
})

local ht = Instance.new("TextLabel", header)
ht.Size = UDim2.new(1, 0, 1, 0)
ht.Text = "🔮 HOLY S4ARCH HUB"
ht.TextColor3 = Color3.fromRGB(255, 255, 255)
ht.Font = Enum.Font.SciFi
ht.TextSize = 22
ht.BackgroundTransparency = 1

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 8)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
close.BorderSizePixel = 0
close.MouseButton1Click:Connect(function()
    stopFly()
    gui:Destroy()
end)

local tabs = {"🌍 Телепорты", "⚔️ Фарм", "🎰 Гача", "📊 Инфо"}
local tabFrames = {}
local tabBtns = {}

local tabBar = Instance.new("Frame", inner)
tabBar.Size = UDim2.new(0, 180, 1, -50)
tabBar.Position = UDim2.new(0, 0, 0, 50)
tabBar.BackgroundColor3 = Color3.fromRGB(22, 20, 30)
tabBar.BorderSizePixel = 0

for i=1,#tabs do
    local tb = Instance.new("TextButton", tabBar)
    tb.Size = UDim2.new(1, -10, 0, 40)
    tb.Position = UDim2.new(0, 5, 0, 10 + (i-1)*45)
    tb.Text = tabs[i]
    tb.TextColor3 = Color3.fromRGB(200, 200, 200)
    tb.Font = Enum.Font.SciFi
    tb.TextSize = 14
    tb.BackgroundColor3 = i==1 and Color3.fromRGB(60, 40, 100) or Color3.fromRGB(35, 30, 45)
    tb.BorderSizePixel = 0
    tabBtns[i] = tb
    
    local tf = Instance.new("ScrollingFrame", inner)
    tf.Size = UDim2.new(1, -190, 1, -60)
    tf.Position = UDim2.new(0, 185, 0, 55)
    tf.BackgroundTransparency = 1
    tf.BorderSizePixel = 0
    tf.ScrollBarThickness = 3
    tf.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 150)
    tf.CanvasSize = UDim2.new(0, 0, 0, 0)
    tf.Visible = (i == 1)
    tabFrames[i] = tf
    
    tb.MouseButton1Click:Connect(function()
        for j=1,#tabs do
            tabFrames[j].Visible = (j == i)
            tabBtns[j].BackgroundColor3 = (j == i) and Color3.fromRGB(60, 40, 100) or Color3.fromRGB(35, 30, 45)
        end
    end)
end

local function addBtn(frame, txt, cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SciFi
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    b.BorderSizePixel = 0
    local uil = frame:FindFirstChild("UIListLayout")
    if not uil then
        uil = Instance.new("UIListLayout", frame)
        uil.Padding = UDim.new(0, 4)
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, (#frame:GetChildren())*40 + 10)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(70, 50, 90) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(40, 35, 55) end)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- ТЕЛЕПОРТЫ (через Fly)
local islands = {
    {"🏴 Стартовый", Vector3.new(0, 50, 0)},
    {"🏴 Джунгли", Vector3.new(-1600, 50, 100)},
    {"🏴 Пираты", Vector3.new(-1150, 50, 1550)},
    {"🏴 Пустыня", Vector3.new(1000, 50, -200)},
    {"🏴 Замёрзший", Vector3.new(-1300, 50, -1200)},
    {"🏴 Морской Замок", Vector3.new(-5000, 50, -3500)},
    {"🏴 Тюрьма", Vector3.new(4800, 50, 2300)},
    {"🏴 Небесный", Vector3.new(-4800, 350, -2500)},
    {"🌊 Второе Море", Vector3.new(-800, 50, 3000)},
    {"🌊 Кор. Роз", Vector3.new(-2500, 50, 4500)},
    {"🌊 Кладбище", Vector3.new(-6000, 50, 3000)},
    {"🌊 Особняк", Vector3.new(-12500, 50, 8000)},
    {"🌊 Третье Море", Vector3.new(-12500, 50, 12500)},
    {"🌊 Замок Дракулы", Vector3.new(-15000, 50, 15000)},
}

for i=1,#islands do
    addBtn(tabFrames[1], islands[i][1], function()
        flyTo(islands[i][2])
    end)
end

addBtn(tabFrames[1], "🍈 Фрукт (Fly)", function()
    local c = player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local best, near = 9999, nil
    for _,v in ipairs(ws:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local d = (hrp.Position - v.Handle.Position).Magnitude
            if d < best then best = d; near = v end
        end
    end
    if near then flyTo(near.Handle.Position + Vector3.new(0, 20, 0)) end
end)

addBtn(tabFrames[1], "🛑 Стоп Fly", function()
    stopFly()
end)

-- ФАРМ (с Fly)
local farm = false
addBtn(tabFrames[2], "⚔️ Старт/Стоп фарм", function(b)
    farm = not farm
    b.Text = farm and "⚔️ Фарм: ON" or "⚔️ Фарм: OFF"
    if farm then
        spawn(function()
            while farm do
                local c = player.Character
                if c then
                    for _,v in ipairs(ws:GetDescendants()) do
                        if v:IsA("Model") and v~=c then
                            local h = v:FindFirstChild("Humanoid")
                            local r = v:FindFirstChild("HumanoidRootPart")
                            if h and r and h.Health > 0 then
                                flyTo(r.Position + Vector3.new(0, 5, 0))
                                wait(0.3)
                                stopFly()
                                pcall(function() rp.Remotes.Combat:FireServer("M1", r.Position) end)
                                for s=1,4 do
                                    pcall(function() rp.Remotes.Combat:FireServer("Skill"..s, r.Position) end)
                                end
                            end
                        end
                    end
                end
                wait(0.2)
            end
            stopFly()
        end)
    else
        stopFly()
    end
end)

-- ГАЧА
addBtn(tabFrames[3], "🎲 Ролл фрукта", function()
    pcall(function() rp.Remotes.FruitSystem:FireServer("RollFruit") end)
end)

local ar = false
addBtn(tabFrames[3], "🎰 Авто-ролл", function(b)
    ar = not ar
    b.Text = ar and "🎰 Авто-ролл: ON" or "🎰 Авто-ролл: OFF"
    if ar then
        spawn(function()
            while ar do
                pcall(function() rp.Remotes.FruitSystem:FireServer("RollFruit") end)
                wait(3)
            end
        end)
    end
end)

-- ИНФО
addBtn(tabFrames[4], "👤 " .. player.Name, function() end)
addBtn(tabFrames[4], "✅ Статус: работает", function() end)
addBtn(tabFrames[4], "✈️ Fly: " .. flySpeed .. " studs/s", function() end)

-- ТЯНКА
local waifu = Instance.new("ImageLabel", inner)
waifu.Size = UDim2.new(0, 170, 0, 300)
waifu.Position = UDim2.new(0, 5, 0, 170)
waifu.BackgroundTransparency = 1
waifu.Image = "rbxassetid://7564334521"
waifu.ScaleType = Enum.ScaleType.Fit

local wname = Instance.new("TextLabel", inner)
wname.Size = UDim2.new(0, 170, 0, 20)
wname.Position = UDim2.new(0, 5, 0, 470)
wname.Text = "Юки ❤️"
wname.TextColor3 = Color3.fromRGB(255, 200, 255)
wname.Font = Enum.Font.SciFi
wname.TextSize = 14
wname.BackgroundTransparency = 1

-- Анти-АФК
spawn(function()
    while gui.Parent do
        wait(180)
        pcall(function() vim:SendKeyEvent(true, Enum.KeyCode.Space, false, nil); wait(0.1); vim:SendKeyEvent(false, Enum.KeyCode.Space, false, nil) end)
    end
end)

print("✅ Holy S4arch Hub v2.1 loaded!")
print("✈️ Fly system active | Speed: " .. flySpeed)
