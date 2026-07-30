--[[
    ╔══════════════════════════════════════════════════════╗
    ║          PHANTOM HUB - Prison Life Edition           ║
    ║              Premium Script v4.0                     ║
    ║          Criado por: leoozinmqs                      ║
    ╚══════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════════════
local Config = {
    SpeedEnabled = false, SpeedValue = 32,
    JumpEnabled = false, JumpValue = 50,
    NoclipEnabled = false,
    FlyEnabled = false, FlySpeed = 60,
    InfiniteJumpEnabled = false,
    KillAuraEnabled = false, KillAuraRange = 15,
    NoRecoilEnabled = false,
    ESPEnabled = false, FullbrightEnabled = false, TeamColorsESP = true,
    GodModeEnabled = false, InvisibleEnabled = false,
    AutoArrestEnabled = false, AntiArrestEnabled = false,
    AnnoyEnabled = false, SpinEnabled = false,
    UIOpen = true,
}

-- ═══════════════════════════════════════════════════════
-- CORES
-- ═══════════════════════════════════════════════════════
local C = {
    BgDark = Color3.fromRGB(12, 12, 18),
    BgMed = Color3.fromRGB(18, 18, 28),
    BgCard = Color3.fromRGB(22, 22, 35),
    BgHover = Color3.fromRGB(30, 30, 48),
    Accent = Color3.fromRGB(138, 43, 226),
    Accent2 = Color3.fromRGB(59, 130, 246),
    Accent3 = Color3.fromRGB(168, 85, 247),
    Green = Color3.fromRGB(34, 197, 94),
    Red = Color3.fromRGB(239, 68, 68),
    Yellow = Color3.fromRGB(245, 158, 11),
    Text = Color3.fromRGB(240, 240, 255),
    TextDim = Color3.fromRGB(148, 148, 180),
    TextMuted = Color3.fromRGB(100, 100, 130),
    Border = Color3.fromRGB(40, 40, 60),
    ToggleOff = Color3.fromRGB(50, 50, 70),
}

-- ═══════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════
local function Tween(obj, props, dur)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quint), props):Play()
    end)
end

local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p
end

local function Stroke(p, col)
    local s = Instance.new("UIStroke"); s.Color = col or C.Border; s.Thickness = 1; s.Transparency = 0.6; s.Parent = p
end

local function GetChar() return Player.Character end
local function GetHum() local c = GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function GetHRP() local c = GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end

local function Notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "👻 Phantom Hub", Text = text, Duration = 3})
    end)
end

-- Verifica se um Tool pertence a algum jogador
local function IsPlayerTool(item)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character and item:IsDescendantOf(pl.Character) then return true end
        if pl:FindFirstChild("Backpack") and item:IsDescendantOf(pl.Backpack) then return true end
    end
    return false
end

-- ═══════════════════════════════════════════════════════
-- LIMPAR ANTERIOR
-- ═══════════════════════════════════════════════════════
pcall(function() CoreGui:FindFirstChild("PhantomHub"):Destroy() end)
pcall(function() Player.PlayerGui:FindFirstChild("PhantomHub"):Destroy() end)

-- ═══════════════════════════════════════════════════════
-- SCREENGUI
-- ═══════════════════════════════════════════════════════
local Gui = Instance.new("ScreenGui")
Gui.Name = "PhantomHub"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false
pcall(function() Gui.Parent = CoreGui end)
if not Gui.Parent then Gui.Parent = Player.PlayerGui end

task.wait()

-- ═══════════════════════════════════════════════════════
-- MAIN FRAME
-- ═══════════════════════════════════════════════════════
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 570, 0, 410)
Main.Position = UDim2.new(0.5, -285, 0.5, -205)
Main.BackgroundColor3 = C.BgDark
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
Corner(Main, 12)
Stroke(Main, C.Border)

task.wait()

-- ═══════════════════════════════════════════════════════
-- TITLEBAR + DRAG
-- ═══════════════════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = C.BgMed
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Corner(TitleBar, 12)

local Fix = Instance.new("Frame")
Fix.Size = UDim2.new(1, 0, 0, 12)
Fix.Position = UDim2.new(0, 0, 1, -12)
Fix.BackgroundColor3 = C.BgMed
Fix.BorderSizePixel = 0
Fix.Parent = TitleBar

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 1, -2)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = C.Accent
Line.Parent = TitleBar
local g = Instance.new("UIGradient")
g.Color = ColorSequence.new(C.Accent, C.Accent2)
g.Parent = Line

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👻 PHANTOM HUB v4.0  •  by leoozinmqs"
Title.TextColor3 = C.Text
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = C.Red
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.Red
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Corner(CloseBtn, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.BackgroundColor3 = C.Yellow
MinBtn.BackgroundTransparency = 0.8
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = C.Yellow
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TitleBar
Corner(MinBtn, 6)

-- DRAG
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

task.wait()

-- ═══════════════════════════════════════════════════════
-- SIDEBAR + CONTENT
-- ═══════════════════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = C.BgMed
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 3)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 6)
SidePad.PaddingLeft = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)
SidePad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -132, 1, -46)
Content.Position = UDim2.new(0, 132, 0, 46)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

task.wait()

-- ═══════════════════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════════════════
local TabPages = {}
local TabBtns = {}
local CurrentTab = "Main"

local TabList = {
    {"Main", "⚡", 1}, {"Movement", "🏃", 2}, {"Combat", "⚔️", 3},
    {"Teleport", "🌀", 4}, {"Visuals", "👁️", 5}, {"Player", "🛡️", 6},
    {"Troll", "😈", 7}, {"Credits", "💜", 8},
}

for _, td in ipairs(TabList) do
    local name, icon, order = td[1], td[2], td[3]

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = C.BgCard
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = " " .. icon .. " " .. name
    btn.TextColor3 = C.TextDim
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn, 7)

    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Accent
    page.Visible = (name == "Main")
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    TabPages[name] = page
    TabBtns[name] = btn
end

local function SwitchTab(tabName)
    CurrentTab = tabName
    for name, btn in pairs(TabBtns) do
        local active = (name == tabName)
        btn.BackgroundTransparency = active and 0.6 or 1
        btn.BackgroundColor3 = active and C.Accent or C.BgCard
        btn.TextColor3 = active and C.Text or C.TextDim
        TabPages[name].Visible = active
    end
end

for name, btn in pairs(TabBtns) do
    btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

SwitchTab("Main")
task.wait()

-- ═══════════════════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════════════════
local function MakeLabel(parent, text, ord)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = "  " .. string.upper(text)
    l.TextColor3 = C.TextMuted
    l.TextSize = 10
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = ord or 0
    l.Parent = parent
end

local function MakeToggle(parent, title, desc, default, ord, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, desc and 46 or 34)
    f.BackgroundColor3 = C.BgCard
    f.BorderSizePixel = 0
    f.LayoutOrder = ord or 0
    f.Parent = parent
    Corner(f, 7)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -56, 0, 18)
    t.Position = UDim2.new(0, 10, 0, desc and 5 or 8)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = C.Text
    t.TextSize = 12
    t.Font = Enum.Font.GothamSemibold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = f

    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -56, 0, 12)
        d.Position = UDim2.new(0, 10, 0, 24)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = C.TextMuted
        d.TextSize = 9
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = f
    end

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 36, 0, 20)
    bg.Position = UDim2.new(1, -46, 0.5, -10)
    bg.BackgroundColor3 = default and C.Accent or C.ToggleOff
    bg.BorderSizePixel = 0
    bg.Parent = f
    Corner(bg, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = C.Text
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Corner(knob, 7)

    local on = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        on = not on
        Tween(bg, {BackgroundColor3 = on and C.Accent or C.ToggleOff}, 0.2)
        Tween(knob, {Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2)
        if cb then cb(on) end
    end)
    return f
end

local function MakeSlider(parent, title, min, max, default, ord, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = C.BgCard
    f.BorderSizePixel = 0
    f.LayoutOrder = ord or 0
    f.Parent = parent
    Corner(f, 7)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -60, 0, 18)
    t.Position = UDim2.new(0, 10, 0, 4)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = C.Text
    t.TextSize = 12
    t.Font = Enum.Font.GothamSemibold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = f

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0, 40, 0, 16)
    val.Position = UDim2.new(1, -50, 0, 5)
    val.BackgroundColor3 = C.BgDark
    val.BorderSizePixel = 0
    val.Text = tostring(default)
    val.TextColor3 = C.Accent3
    val.TextSize = 10
    val.Font = Enum.Font.GothamBold
    val.Parent = f
    Corner(val, 4)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 32)
    track.BackgroundColor3 = C.ToggleOff
    track.BorderSizePixel = 0
    track.Parent = f
    Corner(track, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Corner(fill, 3)

    local sliding = false
    local function Update(input)
        local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * rel)
        val.Text = tostring(v)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        if cb then cb(v) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
end

local function MakeButton(parent, title, desc, ord, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, desc and 44 or 32)
    btn.BackgroundColor3 = C.BgCard
    btn.BorderSizePixel = 0
    btn.LayoutOrder = ord or 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent
    Corner(btn, 7)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 18)
    t.Position = UDim2.new(0, 10, 0, desc and 4 or 7)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = C.Text
    t.TextSize = 12
    t.Font = Enum.Font.GothamSemibold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = btn

    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -20, 0, 12)
        d.Position = UDim2.new(0, 10, 0, 23)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = C.TextMuted
        d.TextSize = 9
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = btn
    end

    btn.MouseButton1Click:Connect(function()
        Tween(btn, {BackgroundColor3 = C.Accent}, 0.1)
        task.delay(0.15, function() Tween(btn, {BackgroundColor3 = C.BgCard}, 0.2) end)
        if cb then cb() end
    end)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = C.BgHover}, 0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = C.BgCard}, 0.15) end)
end

-- ═══════════════════════════════════════════════════════
-- PAGE: MAIN
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Main"]

    local w = Instance.new("Frame")
    w.Size = UDim2.new(1, 0, 0, 55)
    w.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    w.BorderSizePixel = 0
    w.LayoutOrder = 1
    w.Parent = p
    Corner(w, 8)
    Stroke(w, C.Accent)

    local wt = Instance.new("TextLabel")
    wt.Size = UDim2.new(1, -20, 1, 0)
    wt.Position = UDim2.new(0, 12, 0, 0)
    wt.BackgroundTransparency = 1
    wt.Text = "👋 Bem-vindo, " .. Player.Name .. "\nPhantom Hub v4.0 | by leoozinmqs | Toggle: RightCtrl"
    wt.TextColor3 = C.Text
    wt.TextSize = 11
    wt.Font = Enum.Font.GothamSemibold
    wt.TextXAlignment = Enum.TextXAlignment.Left
    wt.TextWrapped = true
    wt.Parent = w

    MakeLabel(p, "Ações Rápidas", 2)

    MakeButton(p, "🚪 Remover Todas as Portas", "Remove portas e grades da prisão", 3, function()
        pcall(function()
            -- Método 1: pasta Doors
            local doors = Workspace:FindFirstChild("Doors")
            if doors then
                for _, d in ipairs(doors:GetChildren()) do pcall(function() d:Destroy() end) end
            end
            -- Método 2: busca por nome
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        Notify("✅ Portas removidas!")
    end)

    MakeButton(p, "🔫 Pegar Armas do Mapa", "TP ao armeiro + coleta armas livres", 4, function()
        pcall(function()
            -- TP para o armeiro
            local hrp = GetHRP()
            if hrp then hrp.CFrame = CFrame.new(835, 99, 2256) end
            task.wait(0.5)
            -- Coleta SOMENTE armas que NÃO pertencem a nenhum jogador
            local count = 0
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") and not IsPlayerTool(item) then
                    pcall(function()
                        item.Parent = Player.Backpack
                        count = count + 1
                    end)
                end
            end
            Notify("✅ " .. count .. " armas coletadas!")
        end)
    end)

    MakeButton(p, "🔓 Pegar Keycard", "Busca keycards no mapa (não rouba de players)", 5, function()
        pcall(function()
            local found = false
            -- Buscar keycard em todo o workspace (exceto jogadores)
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and v.Name:lower():find("key") and not IsPlayerTool(v) then
                    pcall(function()
                        v.Parent = Player.Backpack
                        found = true
                    end)
                end
            end
            if not found then
                -- TP para onde policiais spawnam (keycard fica lá)
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(835, 99, 2276)
                    Notify("⚠️ Nenhum keycard livre. TP para base policial!")
                end
            else
                Notify("✅ Keycard pego!")
            end
        end)
    end)

    MakeButton(p, "💥 Destruir Cercas", "Remove cercas e barreiras", 6, function()
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("fence") or v.Name:lower():find("barrier") or v.Name:lower():find("barbed")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        Notify("✅ Cercas destruídas!")
    end)

    MakeButton(p, "🧹 Limpar Laser/Alarmes", "Remove lasers e alarmes da prisão", 7, function()
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v.Name:lower():find("laser") or v.Name:lower():find("alarm") or v.Name:lower():find("sensor") then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        Notify("✅ Lasers/Alarmes removidos!")
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: MOVEMENT
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Movement"]
    MakeLabel(p, "Velocidade & Pulo", 1)

    MakeToggle(p, "Speed Hack", "Aumenta velocidade de movimento", false, 2, function(on)
        Config.SpeedEnabled = on
        if not on then pcall(function() local h = GetHum(); if h then h.WalkSpeed = 16 end end) end
    end)
    MakeSlider(p, "Walk Speed", 16, 200, 32, 3, function(v)
        Config.SpeedValue = v
        if Config.SpeedEnabled then pcall(function() local h = GetHum(); if h then h.WalkSpeed = v end end) end
    end)

    MakeToggle(p, "Jump Power", "Aumenta força do pulo", false, 4, function(on)
        Config.JumpEnabled = on
        if not on then pcall(function() local h = GetHum(); if h then h.JumpPower = 50 end end) end
    end)
    MakeSlider(p, "Jump Height", 50, 300, 100, 5, function(v)
        Config.JumpValue = v
        if Config.JumpEnabled then pcall(function() local h = GetHum(); if h then h.JumpPower = v end end) end
    end)

    MakeLabel(p, "Movimento Avançado", 6)

    MakeToggle(p, "Noclip", "Atravesse paredes (roda todo frame)", false, 7, function(on)
        Config.NoclipEnabled = on
        Notify(on and "✅ Noclip ON" or "❌ Noclip OFF")
    end)

    MakeToggle(p, "Fly", "Voe pelo mapa (WASD + Space/Shift)", false, 8, function(on)
        Config.FlyEnabled = on
        if not on then
            pcall(function()
                local hrp = GetHRP()
                if hrp then
                    local bv = hrp:FindFirstChild("PhantomFly"); if bv then bv:Destroy() end
                    local bg = hrp:FindFirstChild("PhantomGyro"); if bg then bg:Destroy() end
                end
                local h = GetHum(); if h then h.PlatformStand = false end
            end)
        end
        Notify(on and "✅ Fly ON - WASD para mover" or "❌ Fly OFF")
    end)
    MakeSlider(p, "Fly Speed", 10, 200, 60, 9, function(v) Config.FlySpeed = v end)

    MakeToggle(p, "Infinite Jump", "Pule infinitamente no ar", false, 10, function(on)
        Config.InfiniteJumpEnabled = on
        Notify(on and "✅ Infinite Jump ON" or "❌ Infinite Jump OFF")
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: COMBAT
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Combat"]
    MakeLabel(p, "Ataque", 1)

    MakeToggle(p, "Kill Aura", "Usa sua arma equipada em quem estiver perto", false, 2, function(on)
        Config.KillAuraEnabled = on
        Notify(on and "✅ Kill Aura ON - Equipe uma arma!" or "❌ Kill Aura OFF")
    end)
    MakeSlider(p, "Kill Aura Range", 5, 50, 15, 3, function(v) Config.KillAuraRange = v end)

    MakeToggle(p, "No Recoil", "Remove recuo das armas", false, 4, function(on)
        Config.NoRecoilEnabled = on
        if on then
            pcall(function()
                -- Aplicar em todas as ferramentas
                local function removeRecoil(container)
                    for _, tool in ipairs(container:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v:IsA("NumberValue") and v.Name:lower():find("recoil") then
                                    pcall(function() v.Value = 0 end)
                                end
                            end
                        end
                    end
                end
                removeRecoil(Player.Backpack)
                local c = GetChar(); if c then removeRecoil(c) end
            end)
        end
        Notify(on and "✅ No Recoil ON" or "❌ No Recoil OFF")
    end)

    MakeLabel(p, "Automação Policial", 5)

    MakeToggle(p, "Auto Arrest", "Prende criminais próximos automaticamente", false, 6, function(on)
        Config.AutoArrestEnabled = on
        Notify(on and "✅ Auto Arrest ON" or "❌ Auto Arrest OFF")
    end)

    MakeToggle(p, "Anti Arrest", "Impede que te prendam", false, 7, function(on)
        Config.AntiArrestEnabled = on
        Notify(on and "✅ Anti Arrest ON" or "❌ Anti Arrest OFF")
    end)

    MakeLabel(p, "Ações", 8)

    MakeButton(p, "⚡ Punch Aura", "Soca todos os jogadores próximos", 9, function()
        pcall(function()
            local hrp = GetHRP()
            local char = GetChar()
            if not hrp or not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= Player and pl.Character then
                        local th = pl.Character:FindFirstChild("HumanoidRootPart")
                        if th and (hrp.Position - th.Position).Magnitude <= 20 then
                            pcall(function() tool:Activate() end)
                        end
                    end
                end
            end
        end)
        Notify("⚡ Punch!")
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: TELEPORT
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Teleport"]
    MakeLabel(p, "Locais do Mapa", 1)

    local locs = {
        {"🏛️ Base Criminal", CFrame.new(283, 70, 2213)},
        {"👮 Base da Polícia", CFrame.new(835, 99, 2276)},
        {"🏢 Prisão (Spawn)", CFrame.new(920, 100, 2355)},
        {"🌳 Pátio", CFrame.new(920, 100, 2445)},
        {"🏰 Torre de Guarda", CFrame.new(775, 120, 2497)},
        {"🚗 Estacionamento", CFrame.new(830, 98, 2180)},
        {"🚁 Helicóptero", CFrame.new(918, 135, 2200)},
        {"🏥 Enfermaria", CFrame.new(920, 100, 2310)},
        {"🔫 Armeiro (Armas)", CFrame.new(835, 99, 2256)},
        {"🍔 Cafeteria", CFrame.new(920, 100, 2395)},
    }
    for i, loc in ipairs(locs) do
        MakeButton(p, loc[1], nil, i + 1, function()
            pcall(function()
                local hrp = GetHRP(); if hrp then hrp.CFrame = loc[2] end
            end)
            Notify("🌀 " .. loc[1])
        end)
    end

    MakeLabel(p, "Teleport para Jogador", 13)

    MakeButton(p, "🎯 TP Jogador Mais Próximo", nil, 14, function()
        pcall(function()
            local hrp = GetHRP(); if not hrp then return end
            local closest, dist = nil, math.huge
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local th = pl.Character:FindFirstChild("HumanoidRootPart")
                    if th then local d = (hrp.Position - th.Position).Magnitude; if d < dist then closest = th; dist = d end end
                end
            end
            if closest then hrp.CFrame = closest.CFrame * CFrame.new(0, 0, 5); Notify("🎯 TP!") end
        end)
    end)

    MakeButton(p, "🔀 TP Jogador Aleatório", nil, 15, function()
        pcall(function()
            local hrp = GetHRP(); if not hrp then return end
            local others = {}
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(others, pl)
                end
            end
            if #others > 0 then
                local t = others[math.random(1, #others)]
                hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                Notify("🔀 TP para " .. t.Name)
            end
        end)
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: VISUALS
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Visuals"]
    MakeLabel(p, "ESP (Wallhack)", 1)

    MakeToggle(p, "Player ESP", "Veja jogadores através das paredes", false, 2, function(on)
        Config.ESPEnabled = on
        if not on then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl.Character then
                    pcall(function()
                        local h = pl.Character:FindFirstChild("PhantomESP"); if h then h:Destroy() end
                        local head = pl.Character:FindFirstChild("Head")
                        if head then local b = head:FindFirstChild("ESPBB"); if b then b:Destroy() end end
                    end)
                end
            end
        end
        Notify(on and "✅ ESP ON" or "❌ ESP OFF")
    end)

    MakeToggle(p, "Team Colors ESP", "Cores por time", true, 3, function(on) Config.TeamColorsESP = on end)

    MakeLabel(p, "Iluminação", 4)

    MakeToggle(p, "Fullbright", "Remove escuridão", false, 5, function(on)
        Config.FullbrightEnabled = on
        pcall(function()
            if on then
                Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false; Lighting.Ambient = Color3.fromRGB(178, 178, 178)
            else
                Lighting.Brightness = 1; Lighting.ClockTime = 14; Lighting.FogEnd = 10000
                Lighting.GlobalShadows = true; Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            end
        end)
        Notify(on and "✅ Fullbright ON" or "❌ Fullbright OFF")
    end)

    MakeLabel(p, "Câmera", 6)
    MakeSlider(p, "FOV", 40, 120, 70, 7, function(v)
        pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: PLAYER
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Player"]
    MakeLabel(p, "Sobrevivência", 1)

    MakeToggle(p, "God Mode", "Vida sempre no máximo", false, 2, function(on)
        Config.GodModeEnabled = on
        Notify(on and "✅ God Mode ON" or "❌ God Mode OFF")
    end)

    MakeToggle(p, "Invisible", "Torna seu personagem invisível", false, 3, function(on)
        Config.InvisibleEnabled = on
        pcall(function()
            local char = GetChar()
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = on and 1 or 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = on and 1 or 0
                end
            end
            -- Manter cabeça visível se quiser, ou esconder tudo
            local face = char:FindFirstChild("Head") and char.Head:FindFirstChild("face")
            if face then face.Transparency = on and 1 or 0 end
        end)
        Notify(on and "✅ Invisível ON" or "❌ Invisível OFF")
    end)

    MakeLabel(p, "Time & Identidade", 4)

    MakeButton(p, "🔴 TP Base Criminal", "Teleporta pra virar criminal", 5, function()
        pcall(function() local hrp = GetHRP(); if hrp then hrp.CFrame = CFrame.new(283, 70, 2213) end end)
        Notify("🔴 TP base criminal!")
    end)

    MakeButton(p, "🔵 TP Base Policial", "Teleporta pra virar guarda", 6, function()
        pcall(function() local hrp = GetHRP(); if hrp then hrp.CFrame = CFrame.new(835, 99, 2276) end end)
        Notify("🔵 TP base policial!")
    end)

    MakeLabel(p, "Personagem", 7)

    MakeButton(p, "💫 Reset Character", "Mata seu personagem", 8, function()
        pcall(function() local h = GetHum(); if h then h.Health = 0 end end)
    end)

    MakeButton(p, "⬆️ Destravar Câmera", nil, 9, function()
        pcall(function() Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
        Notify("📸 Câmera livre!")
    end)

    MakeButton(p, "🧲 Trazer Items Dropados", "Traz items soltos no chão pra você", 10, function()
        pcall(function()
            local hrp = GetHRP(); if not hrp then return end
            local count = 0
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and not IsPlayerTool(v) then
                    pcall(function()
                        if v:FindFirstChild("Handle") then
                            v.Handle.CFrame = hrp.CFrame
                            count = count + 1
                        end
                    end)
                end
            end
            Notify("🧲 " .. count .. " items trazidos!")
        end)
    end)

    MakeButton(p, "🪑 Sentar / Levantar", "Faz seu char sentar ou levantar", 11, function()
        pcall(function()
            local h = GetHum()
            if h then h.Sit = not h.Sit end
        end)
    end)

    MakeButton(p, "🔒 Freeze Posição", "Congela seu personagem no lugar", 12, function()
        pcall(function()
            local hrp = GetHRP()
            if hrp then
                if hrp.Anchored then
                    hrp.Anchored = false
                    Notify("🔓 Descongelado!")
                else
                    hrp.Anchored = true
                    Notify("🔒 Congelado!")
                end
            end
        end)
    end)

    MakeButton(p, "🏋️ Tamanho Grande", "Aumenta seu personagem", 13, function()
        pcall(function()
            local char = GetChar()
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local bodyScale = {
                    "BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"
                }
                for _, scaleName in ipairs(bodyScale) do
                    local s = hum:FindFirstChild(scaleName)
                    if s then
                        s.Value = s.Value > 1.5 and 1 or 2.5
                    end
                end
                Notify("🏋️ Tamanho alternado!")
            end
        end)
    end)

    MakeButton(p, "💨 Smoke Trail", "Adiciona/remove rastro de fumaça", 14, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local trail = hrp:FindFirstChild("PhantomSmoke")
            if trail then
                trail:Destroy()
                Notify("💨 Smoke removido!")
            else
                local smoke = Instance.new("Smoke")
                smoke.Name = "PhantomSmoke"
                smoke.Color = Color3.fromRGB(138, 43, 226)
                smoke.Opacity = 0.3
                smoke.Size = 2
                smoke.RiseVelocity = 3
                smoke.Parent = hrp
                Notify("💨 Smoke ativado!")
            end
        end)
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: TROLL 😈
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Troll"]
    MakeLabel(p, "Troll Ativo", 1)

    MakeToggle(p, "Annoy Mode", "Segue o jogador mais próximo sem parar", false, 2, function(on)
        Config.AnnoyEnabled = on
        Notify(on and "😈 Annoy ON - Seguindo!" or "❌ Annoy OFF")
    end)

    MakeToggle(p, "Spin Mode", "Gira seu personagem sem parar", false, 3, function(on)
        Config.SpinEnabled = on
        Notify(on and "🌀 Spin ON" or "❌ Spin OFF")
    end)

    MakeLabel(p, "Ações de Troll", 4)

    MakeButton(p, "🌪️ Fling Jogadores", "Arremessa jogadores próximos pra longe", 5, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local th = pl.Character:FindFirstChild("HumanoidRootPart")
                    if th and (hrp.Position - th.Position).Magnitude <= 30 then
                        pcall(function()
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = Vector3.new(math.random(-200, 200), 150, math.random(-200, 200))
                            bv.Parent = th
                            game:GetService("Debris"):AddItem(bv, 0.5)
                        end)
                    end
                end
            end
        end)
        Notify("🌪️ Fling!")
    end)

    MakeButton(p, "🎆 Spam Pular", "Pula sem parar por 5 segundos", 6, function()
        task.spawn(function()
            local endTime = tick() + 5
            while tick() < endTime do
                pcall(function()
                    local h = GetHum()
                    if h then h.Jump = true end
                end)
                task.wait(0.1)
            end
        end)
        Notify("🎆 Pulando!")
    end)

    MakeButton(p, "💃 Emote Spam", "Spama emotes (se disponível)", 7, function()
        pcall(function()
            local char = GetChar()
            local hum = GetHum()
            if hum then
                task.spawn(function()
                    for i = 1, 10 do
                        pcall(function()
                            hum.Sit = true
                            task.wait(0.2)
                            hum.Sit = false
                            task.wait(0.2)
                        end)
                    end
                end)
            end
        end)
        Notify("💃 Emote spam!")
    end)

    MakeButton(p, "📢 Spam Chat", "Envia mensagem no chat", 8, function()
        pcall(function()
            local msg = "👻 Phantom Hub by leoozinmqs"
            -- Tenta usar o sistema de chat
            local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatRemote then
                local sayMsg = chatRemote:FindFirstChild("SayMessageRequest")
                if sayMsg then
                    task.spawn(function()
                        for i = 1, 3 do
                            pcall(function() sayMsg:FireServer(msg, "All") end)
                            task.wait(1)
                        end
                    end)
                end
            end
        end)
        Notify("📢 Chat enviado!")
    end)

    MakeButton(p, "🔊 Boombox (Som)", "Toca um som no seu personagem", 9, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local old = hrp:FindFirstChild("PhantomSound")
            if old then old:Destroy(); Notify("🔇 Som parado!"); return end
            local s = Instance.new("Sound")
            s.Name = "PhantomSound"
            s.SoundId = "rbxassetid://5410086218"
            s.Volume = 3
            s.Looped = true
            s.Parent = hrp
            s:Play()
            Notify("🔊 Som tocando!")
        end)
    end)

    MakeButton(p, "🏗️ Spawnar Blocos", "Cria blocos ao seu redor", 10, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            for i = 1, 10 do
                pcall(function()
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(4, 4, 4)
                    part.Position = hrp.Position + Vector3.new(math.random(-15, 15), math.random(5, 20), math.random(-15, 15))
                    part.BrickColor = BrickColor.new("Really red")
                    part.Material = Enum.Material.Neon
                    part.Anchored = false
                    part.Parent = Workspace
                    game:GetService("Debris"):AddItem(part, 10)
                end)
            end
        end)
        Notify("🏗️ Blocos spawnados!")
    end)

    MakeButton(p, "🎯 TP Atrás do Inimigo", "Teleporta atrás do jogador mais próximo", 11, function()
        pcall(function()
            local hrp = GetHRP(); if not hrp then return end
            local closest, dist = nil, math.huge
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local th = pl.Character:FindFirstChild("HumanoidRootPart")
                    if th then
                        local d = (hrp.Position - th.Position).Magnitude
                        if d < dist then closest = th; dist = d end
                    end
                end
            end
            if closest then
                -- TP para ATRÁS do jogador
                hrp.CFrame = closest.CFrame * CFrame.new(0, 0, 4)
                Notify("🎯 Teleportado atrás!")
            end
        end)
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- PAGE: CREDITS 💜
-- ═══════════════════════════════════════════════════════
do
    local p = TabPages["Credits"]

    -- Card principal
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 130)
    card.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    card.BorderSizePixel = 0
    card.LayoutOrder = 1
    card.Parent = p
    Corner(card, 10)
    Stroke(card, C.Accent)

    local credText = Instance.new("TextLabel")
    credText.Size = UDim2.new(1, -24, 1, -12)
    credText.Position = UDim2.new(0, 12, 0, 6)
    credText.BackgroundTransparency = 1
    credText.Text = "👻 PHANTOM HUB v4.0\n\n🎮 Jogo: Prison Life\n👤 Criador: leoozinmqs\n💜 Feito com amor\n\n⌨️ Toggle UI: RightCtrl\n📌 Minimizar = Botão flutuante"
    credText.TextColor3 = C.Text
    credText.TextSize = 12
    credText.Font = Enum.Font.GothamSemibold
    credText.TextXAlignment = Enum.TextXAlignment.Left
    credText.TextYAlignment = Enum.TextYAlignment.Top
    credText.TextWrapped = true
    credText.Parent = card

    MakeLabel(p, "Keybinds", 2)

    local kb = Instance.new("Frame")
    kb.Size = UDim2.new(1, 0, 0, 70)
    kb.BackgroundColor3 = C.BgCard
    kb.BorderSizePixel = 0
    kb.LayoutOrder = 3
    kb.Parent = p
    Corner(kb, 8)

    local kbText = Instance.new("TextLabel")
    kbText.Size = UDim2.new(1, -24, 1, -12)
    kbText.Position = UDim2.new(0, 12, 0, 6)
    kbText.BackgroundTransparency = 1
    kbText.Text = "• RightCtrl → Toggle Menu\n• Espaço (no ar) → Infinite Jump\n• WASD + Space/Shift → Controle do Fly"
    kbText.TextColor3 = C.TextDim
    kbText.TextSize = 11
    kbText.Font = Enum.Font.Gotham
    kbText.TextXAlignment = Enum.TextXAlignment.Left
    kbText.TextYAlignment = Enum.TextYAlignment.Top
    kbText.TextWrapped = true
    kbText.Parent = kb

    MakeButton(p, "🗑️ Destruir Script", "Remove o Phantom Hub completamente", 4, function()
        Notify("👻 Até mais!")
        task.delay(0.3, function() Gui:Destroy() end)
    end)
end

task.wait()

-- ═══════════════════════════════════════════════════════
-- GAME LOOPS
-- ═══════════════════════════════════════════════════════

-- ▶ NOCLIP: PRECISA rodar todo frame (Stepped) para funcionar
RunService.Stepped:Connect(function()
    if not Config.NoclipEnabled then return end
    if not Gui.Parent then return end
    pcall(function()
        local char = GetChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

-- ▶ SPEED, JUMP, GOD, ANTI-ARREST (loop lento 0.1s)
task.spawn(function()
    while task.wait(0.1) do
        if not Gui.Parent then break end
        pcall(function()
            local hum = GetHum()
            if not hum then return end
            if Config.SpeedEnabled then hum.WalkSpeed = Config.SpeedValue end
            if Config.JumpEnabled then hum.JumpPower = Config.JumpValue; hum.UseJumpPower = true end
            if Config.GodModeEnabled then hum.Health = hum.MaxHealth end
        end)
        if Config.AntiArrestEnabled then
            pcall(function()
                local char = GetChar()
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("ClickDetector") then v.MaxActivationDistance = 0 end
                    end
                end
            end)
        end
    end
end)

-- ▶ FLY (Heartbeat - precisa ser smooth)
RunService.Heartbeat:Connect(function()
    if not Config.FlyEnabled then return end
    if not Gui.Parent then return end
    pcall(function()
        local hrp = GetHRP()
        local hum = GetHum()
        if not hrp or not hum then return end

        local bv = hrp:FindFirstChild("PhantomFly")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "PhantomFly"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
        local bg = hrp:FindFirstChild("PhantomGyro")
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.Name = "PhantomGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.D = 200; bg.P = 40000
            bg.Parent = hrp
        end

        local cam = Workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * Config.FlySpeed or Vector3.zero
        bg.CFrame = cam.CFrame
        hum.PlatformStand = true
    end)
end)

-- ▶ KILL AURA (loop 0.3s - rápido o suficiente)
task.spawn(function()
    while task.wait(0.3) do
        if not Gui.Parent then break end
        if not Config.KillAuraEnabled then continue end
        pcall(function()
            local hrp = GetHRP()
            local char = GetChar()
            if not hrp or not char then return end

            -- Pegar QUALQUER tool equipada (arma, faca, etc)
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool then return end

            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local theirHRP = pl.Character:FindFirstChild("HumanoidRootPart")
                    if theirHRP and (hrp.Position - theirHRP.Position).Magnitude <= Config.KillAuraRange then
                        -- Olhar pro alvo e ativar a arma
                        pcall(function()
                            hrp.CFrame = CFrame.lookAt(hrp.Position, theirHRP.Position)
                            tool:Activate()
                        end)
                        task.wait(0.05)
                    end
                end
            end
        end)
    end
end)

-- ▶ AUTO ARREST
task.spawn(function()
    while task.wait(0.8) do
        if not Gui.Parent then break end
        if not Config.AutoArrestEnabled then continue end
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local th = pl.Character:FindFirstChild("HumanoidRootPart")
                    if th and (hrp.Position - th.Position).Magnitude <= 25 then
                        -- Método 1: Buscar Remote de arrest
                        pcall(function()
                            local ev = ReplicatedStorage:FindFirstChild("Event")
                            if ev then
                                for _, v in ipairs(ev:GetChildren()) do
                                    if v.Name:lower():find("arrest") then
                                        pcall(function() v:FireServer(pl) end)
                                    end
                                end
                            end
                        end)
                        -- Método 2: Clicar no ClickDetector
                        pcall(function()
                            local cd = pl.Character:FindFirstChildOfClass("ClickDetector")
                            if cd then
                                fireclickdetector(cd)
                            end
                        end)
                    end
                end
            end
        end)
    end
end)

-- ▶ ESP
task.spawn(function()
    while task.wait(1.5) do
        if not Gui.Parent then break end
        if not Config.ESPEnabled then continue end
        pcall(function()
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl == Player or not pl.Character then continue end
                local char = pl.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then continue end

                local hl = char:FindFirstChild("PhantomESP")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "PhantomESP"
                    hl.FillTransparency = 0.65
                    hl.OutlineTransparency = 0.3
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                end

                if Config.TeamColorsESP and pl.Team then
                    local tn = pl.Team.Name:lower()
                    if tn:find("guard") or tn:find("police") then
                        hl.FillColor = Color3.fromRGB(59, 130, 246)
                        hl.OutlineColor = Color3.fromRGB(96, 165, 250)
                    elseif tn:find("criminal") then
                        hl.FillColor = Color3.fromRGB(239, 68, 68)
                        hl.OutlineColor = Color3.fromRGB(252, 129, 129)
                    elseif tn:find("inmate") or tn:find("prisoner") then
                        hl.FillColor = Color3.fromRGB(245, 158, 11)
                        hl.OutlineColor = Color3.fromRGB(252, 191, 73)
                    else
                        hl.FillColor = C.Accent3; hl.OutlineColor = C.Accent
                    end
                else
                    hl.FillColor = C.Accent3; hl.OutlineColor = C.Accent
                end

                local head = char:FindFirstChild("Head")
                if head then
                    local bb = head:FindFirstChild("ESPBB")
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = "ESPBB"; bb.Size = UDim2.new(0, 150, 0, 40)
                        bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = head
                        local nl = Instance.new("TextLabel")
                        nl.Name = "N"; nl.Size = UDim2.new(1, 0, 0.5, 0); nl.BackgroundTransparency = 1
                        nl.TextColor3 = C.Text; nl.TextSize = 13; nl.Font = Enum.Font.GothamBold
                        nl.TextStrokeTransparency = 0.5; nl.Parent = bb
                        local dl = Instance.new("TextLabel")
                        dl.Name = "D"; dl.Size = UDim2.new(1, 0, 0.5, 0); dl.Position = UDim2.new(0, 0, 0.5, 0)
                        dl.BackgroundTransparency = 1; dl.TextColor3 = C.TextDim; dl.TextSize = 10
                        dl.Font = Enum.Font.Gotham; dl.TextStrokeTransparency = 0.5; dl.Parent = bb
                    end
                    local nl = bb:FindFirstChild("N"); local dl = bb:FindFirstChild("D")
                    if nl then nl.Text = pl.Name end
                    local myHRP = GetHRP(); local theirHRP = char:FindFirstChild("HumanoidRootPart")
                    if dl and myHRP and theirHRP then
                        dl.Text = math.floor((myHRP.Position - theirHRP.Position).Magnitude) .. "m | ❤️" .. math.floor(hum.Health)
                    end
                end
            end
        end)
    end
end)

-- ▶ ANNOY MODE (segue jogador mais próximo)
task.spawn(function()
    while task.wait(0.2) do
        if not Gui.Parent then break end
        if not Config.AnnoyEnabled then continue end
        pcall(function()
            local hrp = GetHRP(); if not hrp then return end
            local closest, dist = nil, math.huge
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character then
                    local th = pl.Character:FindFirstChild("HumanoidRootPart")
                    if th then
                        local d = (hrp.Position - th.Position).Magnitude
                        if d < dist then closest = th; dist = d end
                    end
                end
            end
            if closest then
                hrp.CFrame = closest.CFrame * CFrame.new(0, 0, 2)
            end
        end)
    end
end)

-- ▶ SPIN MODE
task.spawn(function()
    while task.wait(0.03) do
        if not Gui.Parent then break end
        if not Config.SpinEnabled then continue end
        pcall(function()
            local hrp = GetHRP()
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0)
            end
        end)
    end
end)

-- ▶ INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJumpEnabled then
        pcall(function() local h = GetHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    end
end)

-- ═══════════════════════════════════════════════════════
-- BOTÃO FLUTUANTE
-- ═══════════════════════════════════════════════════════
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 44, 0, 44)
FloatBtn.Position = UDim2.new(0, 14, 0.5, -22)
FloatBtn.BackgroundColor3 = C.Accent
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "👻"
FloatBtn.TextSize = 20
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextColor3 = C.Text
FloatBtn.AutoButtonColor = false
FloatBtn.Visible = false
FloatBtn.Parent = Gui
Corner(FloatBtn, 22)
Stroke(FloatBtn, C.Accent)

local fDrag, fDS, fSP
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        fDrag = true; fDS = input.Position; fSP = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then fDrag = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if fDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - fDS
        FloatBtn.Position = UDim2.new(fSP.X.Scale, fSP.X.Offset + d.X, fSP.Y.Scale, fSP.Y.Offset + d.Y)
    end
end)

FloatBtn.MouseEnter:Connect(function() Tween(FloatBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.2) end)
FloatBtn.MouseLeave:Connect(function() Tween(FloatBtn, {Size = UDim2.new(0, 44, 0, 44)}, 0.2) end)

local function ShowUI() Config.UIOpen = true; Main.Visible = true; FloatBtn.Visible = false end
local function HideUI() Config.UIOpen = false; Main.Visible = false; FloatBtn.Visible = true end

FloatBtn.MouseButton1Click:Connect(ShowUI)

-- ═══════════════════════════════════════════════════════
-- KEYBINDS & HEADER
-- ═══════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Config.UIOpen then HideUI() else ShowUI() end
    end
end)

MinBtn.MouseButton1Click:Connect(HideUI)
CloseBtn.MouseButton1Click:Connect(function()
    Notify("👻 Até mais!"); task.delay(0.3, function() Gui:Destroy() end)
end)

-- ═══════════════════════════════════════════════════════
-- RESPAWN HANDLER
-- ═══════════════════════════════════════════════════════
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if Config.SpeedEnabled then hum.WalkSpeed = Config.SpeedValue end
        if Config.JumpEnabled then hum.JumpPower = Config.JumpValue; hum.UseJumpPower = true end
    end)
end)

-- ═══════════════════════════════════════════════════════
-- WATERMARK
-- ═══════════════════════════════════════════════════════
local wm = Instance.new("TextLabel")
wm.Size = UDim2.new(0, 185, 0, 22)
wm.Position = UDim2.new(0, 8, 1, -28)
wm.BackgroundColor3 = C.BgDark
wm.BackgroundTransparency = 0.3
wm.BorderSizePixel = 0
wm.Text = "  👻 Phantom Hub v4.0 • leoozinmqs"
wm.TextColor3 = C.TextMuted
wm.TextSize = 10
wm.Font = Enum.Font.GothamSemibold
wm.TextXAlignment = Enum.TextXAlignment.Left
wm.Parent = Gui
Corner(wm, 5)

-- ═══════════════════════════════════════════════════════
-- PRONTO
-- ═══════════════════════════════════════════════════════
Notify("Script carregado! RightCtrl = Toggle")
print("👻 Phantom Hub v4.0 by leoozinmqs - Loaded!")
