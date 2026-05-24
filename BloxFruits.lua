-- Holy S4arch Hub - Blox Fruits
local player = game.Players.LocalPlayer
local ws = game:GetService("Workspace")
local rp = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui")
if gethui then gui.Parent = gethui() else gui.Parent = game.CoreGui end

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 380)
main.Position = UDim2.new(0.5, -150, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "🔮 HOLY S4ARCH HUB"
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Font = Enum.Font.SciFi
title.TextSize = 18

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 800)

local y = 0
local function btn(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, -10, 0, 32)
    b.Position = UDim2.new(0, 5, 0, y)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SciFi
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    b.MouseButton1Click:Connect(cb)
    y = y + 35
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 40)
    return b
end

local islands = {
    {"🏴 Стартовый", Vector3.new(0, 20, 0)},
    {"🏴 Джунгли", Vector3.new(-1600, 20, 100)},
    {"🏴 Пираты", Vector3.new(-1150, 20, 1550)},
    {"🏴 Пустыня", Vector3.new(1000, 20, -200)},
    {"🏴 Замёрзший", Vector3.new(-1300, 20, -1200)},
    {"🏴 Морской Замок", Vector3.new(-5000, 20, -3500)},
    {"🏴 Тюрьма", Vector3.new(4800, 20, 2300)},
    {"🏴 Небесный", Vector3.new(-4800, 300, -2500)},
    {"🌊 Второе Море", Vector3.new(-800, 20, 3000)},
    {"🌊 Кор. Роз", Vector3.new(-2500, 20, 4500)},
    {"🌊 Кладбище", Vector3.new(-6000, 20, 3000)},
    {"🌊 Особняк", Vector3.new(-12500, 20, 8000)},
    {"🌊 Третье Море", Vector3.new(-12500, 20, 12500)},
    {"🌊 Замок Дракулы", Vector3.new(-15000, 20, 15000)},
}

for i = 1, #islands do
    btn(islands[i][1], function()
        local c = player.Character
        if c then
            local r = c:FindFirstChild("HumanoidRootPart")
            if r then r.CFrame = CFrame.new(islands[i][2] + Vector3.new(0, 10, 0)) end
        end
    end)
end

local farm = false
local fb = btn("⚔️ Фарм: OFF", function(b)
    farm = not farm
    b.Text = farm and "⚔️ Фарм: ON" or "⚔️ Фарм: OFF"
    if farm then
        spawn(function()
            while farm do
                local c = player.Character
                if c then
                    for _, v in ipairs(ws:GetDescendants()) do
                        if v:IsA("Model") and v ~= c then
                            local h = v:FindFirstChild("Humanoid")
                            local r = v:FindFirstChild("HumanoidRootPart")
                            if h and r and h.Health > 0 then
                                pcall(function() rp.Remotes.Combat:FireServer("M1", r.Position) end)
                                for s = 1, 4 do
                                    pcall(function() rp.Remotes.Combat:FireServer("Skill"..s, r.Position) end)
                                end
                            end
                        end
                    end
                end
                wait(0.15)
            end
        end)
    end
end)

btn("🎲 Ролл фрукта", function()
    pcall(function() rp.Remotes.FruitSystem:FireServer("RollFruit") end)
end)

local ar = false
btn("🎰 Авто-ролл: OFF", function(b)
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

btn("🍈 Ближайший фрукт", function()
    local c = player.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local best, near = 9999, nil
    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            local d = (r.Position - v.Handle.Position).Magnitude
            if d < best then best = d; near = v end
        end
    end
    if near then r.CFrame = near.Handle.CFrame + Vector3.new(0, 5, 0) end
end)

btn("✕ Закрыть", function() gui:Destroy() end)

print("✅ Holy S4arch Hub loaded!")
