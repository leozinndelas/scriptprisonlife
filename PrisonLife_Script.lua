--[[
    ╔══════════════════════════════════════════════════════╗
    ║          PHANTOM HUB - Prison Life Edition           ║
    ║              Premium Script v3.0                     ║
    ║                                                      ║
    ║   Desenvolvido com UI customizada premium            ║
    ║   Tema: Dark Glassmorphism + Neon Accents            ║
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
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════
-- CONFIGURAÇÕES & ESTADO
-- ═══════════════════════════════════════════════════════
local Config = {
    -- Movement
    SpeedEnabled = false,
    SpeedValue = 32,
    JumpEnabled = false,
    JumpValue = 50,
    NoclipEnabled = false,
    FlyEnabled = false,
    FlySpeed = 60,
    InfiniteJumpEnabled = false,

    -- Combat
    KillAuraEnabled = false,
    KillAuraRange = 15,
    InfiniteAmmoEnabled = false,
    NoRecoilEnabled = false,

    -- Visuals
    ESPEnabled = false,
    FullbrightEnabled = false,
    TeamColorsESP = true,

    -- Player
    GodModeEnabled = false,
    InvisibleEnabled = false,

    -- Misc
    AutoArrestEnabled = false,
    AntiArrestEnabled = false,
    RemoveDoorsEnabled = false,

    -- UI
    UIOpen = true,
    CurrentTab = "Main",
    ToggleKey = Enum.KeyCode.RightControl,
}

-- ═══════════════════════════════════════════════════════
-- PALETA DE CORES PREMIUM
-- ═══════════════════════════════════════════════════════
local Colors = {
    -- Backgrounds
    BgDark = Color3.fromRGB(12, 12, 18),
    BgMedium = Color3.fromRGB(18, 18, 28),
    BgLight = Color3.fromRGB(25, 25, 38),
    BgCard = Color3.fromRGB(22, 22, 35),
    BgHover = Color3.fromRGB(30, 30, 48),
    BgInput = Color3.fromRGB(15, 15, 25),

    -- Accent Gradient
    AccentPrimary = Color3.fromRGB(138, 43, 226),   -- Roxo vibrante
    AccentSecondary = Color3.fromRGB(59, 130, 246),  -- Azul elétrico
    AccentTertiary = Color3.fromRGB(168, 85, 247),   -- Lilás
    AccentGlow = Color3.fromRGB(147, 51, 234),       -- Roxo glow

    -- Status
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(245, 158, 11),
    Info = Color3.fromRGB(59, 130, 246),

    -- Text
    TextPrimary = Color3.fromRGB(240, 240, 255),
    TextSecondary = Color3.fromRGB(148, 148, 180),
    TextMuted = Color3.fromRGB(100, 100, 130),
    TextAccent = Color3.fromRGB(168, 85, 247),

    -- Borders
    Border = Color3.fromRGB(40, 40, 60),
    BorderHover = Color3.fromRGB(138, 43, 226),

    -- Toggle
    ToggleOn = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(50, 50, 70),
    ToggleKnob = Color3.fromRGB(255, 255, 255),

    -- Tab
    TabActive = Color3.fromRGB(138, 43, 226),
    TabInactive = Color3.fromRGB(40, 40, 60),
}

-- ═══════════════════════════════════════════════════════
-- UTILIDADES
-- ═══════════════════════════════════════════════════════
local function Tween(obj, props, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1 or Colors.AccentPrimary, color2 or Colors.AccentSecondary)
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or 8)
    padding.PaddingLeft = UDim.new(0, left or 8)
    padding.PaddingRight = UDim.new(0, right or 8)
    padding.Parent = parent
    return padding
end

local function CreateShadow(parent, transparency, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.Position = UDim2.new(0, -(size or 30)/2, 0, -(size or 30)/2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function Notify(title, text, duration, notifType)
    -- Usamos o sistema de notificação do Roblox
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Phantom Hub",
            Text = text or "",
            Duration = duration or 3,
        })
    end)
end

-- ═══════════════════════════════════════════════════════
-- LIMPAR UI ANTERIOR (anti-duplicação)
-- ═══════════════════════════════════════════════════════
pcall(function()
    if CoreGui:FindFirstChild("PhantomHub") then
        CoreGui:FindFirstChild("PhantomHub"):Destroy()
    end
end)
pcall(function()
    if Player.PlayerGui:FindFirstChild("PhantomHub") then
        Player.PlayerGui:FindFirstChild("PhantomHub"):Destroy()
    end
end)

-- ═══════════════════════════════════════════════════════
-- CRIAÇÃO DA UI PRINCIPAL
-- ═══════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Player.PlayerGui
end

-- ── CONTAINER PRINCIPAL (Draggable) ──
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.BackgroundColor3 = Colors.BgDark
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
CreateCorner(MainFrame, 12)
CreateStroke(MainFrame, Colors.Border, 1, 0.3)
CreateShadow(MainFrame, 0.5, 50)

-- Animação de entrada
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
Tween(MainFrame, {
    Size = UDim2.new(0, 580, 0, 420),
    BackgroundTransparency = 0
}, 0.6, Enum.EasingStyle.Back)

-- ── DRAG FUNCTIONALITY ──
local Dragging, DragStart, StartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        Tween(MainFrame, {
            Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        }, 0.08, Enum.EasingStyle.Sine)
    end
end)

-- ═══════════════════════════════════════════════════════
-- HEADER / TITLE BAR
-- ═══════════════════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = Colors.BgMedium
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
CreateCorner(TitleBar, 12)

-- Corrigir cantos inferiores do titlebar
local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0, 14)
TitleBarFix.Position = UDim2.new(0, 0, 1, -14)
TitleBarFix.BackgroundColor3 = Colors.BgMedium
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

-- Linha de gradiente accent embaixo do header
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, -2)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TitleBar
CreateGradient(AccentLine, Colors.AccentPrimary, Colors.AccentSecondary, 0)

-- Ícone phantom (emoji como texto)
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Name = "TitleIcon"
TitleIcon.Size = UDim2.new(0, 36, 0, 36)
TitleIcon.Position = UDim2.new(0, 12, 0.5, -18)
TitleIcon.BackgroundColor3 = Colors.AccentPrimary
TitleIcon.BorderSizePixel = 0
TitleIcon.Text = "👻"
TitleIcon.TextSize = 18
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.TextColor3 = Colors.TextPrimary
TitleIcon.Parent = TitleBar
CreateCorner(TitleIcon, 8)
CreateGradient(TitleIcon, Colors.AccentPrimary, Colors.AccentSecondary, 135)

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 56, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PHANTOM HUB"
TitleLabel.TextColor3 = Colors.TextPrimary
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Subtítulo
local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 200, 0, 14)
SubTitle.Position = UDim2.new(0, 56, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Prison Life Edition"
SubTitle.TextColor3 = Colors.TextMuted
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

-- Versão
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Size = UDim2.new(0, 50, 0, 20)
VersionLabel.Position = UDim2.new(1, -118, 0.5, -10)
VersionLabel.BackgroundColor3 = Colors.BgLight
VersionLabel.BorderSizePixel = 0
VersionLabel.Text = "v3.0"
VersionLabel.TextColor3 = Colors.AccentTertiary
VersionLabel.TextSize = 11
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.Parent = TitleBar
CreateCorner(VersionLabel, 6)

-- Botão minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Colors.Warning
MinimizeBtn.BackgroundTransparency = 0.8
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Colors.Warning
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar
CreateCorner(MinimizeBtn, 6)

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -14)
CloseBtn.BackgroundColor3 = Colors.Error
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Error
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
CreateCorner(CloseBtn, 6)

-- Hover effects para botões do header
for _, btn in ipairs({MinimizeBtn, CloseBtn}) do
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.4}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.8}, 0.2)
    end)
end

-- ═══════════════════════════════════════════════════════
-- SIDEBAR (TABS)
-- ═══════════════════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Colors.BgMedium
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar
CreatePadding(Sidebar, 8, 8, 8, 8)

-- Separador visual sidebar/content
local SidebarSep = Instance.new("Frame")
SidebarSep.Size = UDim2.new(0, 1, 1, -50)
SidebarSep.Position = UDim2.new(0, 140, 0, 50)
SidebarSep.BackgroundColor3 = Colors.Border
SidebarSep.BackgroundTransparency = 0.5
SidebarSep.BorderSizePixel = 0
SidebarSep.Parent = MainFrame

-- ═══════════════════════════════════════════════════════
-- CONTENT AREA
-- ═══════════════════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -142, 1, -50)
ContentArea.Position = UDim2.new(0, 142, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame

-- ═══════════════════════════════════════════════════════
-- SISTEMA DE TABS E CONTEÚDO
-- ═══════════════════════════════════════════════════════
local Tabs = {}
local TabButtons = {}
local TabPages = {}

local TabData = {
    {Name = "Main", Icon = "⚡", Order = 1},
    {Name = "Movement", Icon = "🏃", Order = 2},
    {Name = "Combat", Icon = "⚔️", Order = 3},
    {Name = "Teleport", Icon = "🌀", Order = 4},
    {Name = "Visuals", Icon = "👁️", Order = 5},
    {Name = "Player", Icon = "🛡️", Order = 6},
    {Name = "Settings", Icon = "⚙️", Order = 7},
}

-- Criar botões da sidebar
for _, tab in ipairs(TabData) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "Tab_" .. tab.Name
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.BackgroundColor3 = Colors.TabInactive
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.LayoutOrder = tab.Order
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = Sidebar
    CreateCorner(TabBtn, 8)

    -- Indicador ativo (barra lateral)
    local ActiveIndicator = Instance.new("Frame")
    ActiveIndicator.Name = "Indicator"
    ActiveIndicator.Size = UDim2.new(0, 3, 0.6, 0)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.2, 0)
    ActiveIndicator.BackgroundColor3 = Colors.AccentPrimary
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.BackgroundTransparency = 1
    ActiveIndicator.Parent = TabBtn
    CreateCorner(ActiveIndicator, 2)
    CreateGradient(ActiveIndicator, Colors.AccentPrimary, Colors.AccentSecondary, 90)

    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 28, 1, 0)
    TabIcon.Position = UDim2.new(0, 8, 0, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = tab.Icon
    TabIcon.TextSize = 14
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.TextColor3 = Colors.TextSecondary
    TabIcon.Parent = TabBtn

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 38, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tab.Name
    TabLabel.TextColor3 = Colors.TextSecondary
    TabLabel.TextSize = 13
    TabLabel.Font = Enum.Font.GothamSemibold
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabBtn

    TabButtons[tab.Name] = {Button = TabBtn, Label = TabLabel, Indicator = ActiveIndicator, Icon = TabIcon}

    -- Criar página de conteúdo
    local Page = Instance.new("ScrollingFrame")
    Page.Name = "Page_" .. tab.Name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Colors.AccentPrimary
    Page.ScrollBarImageTransparency = 0.5
    Page.Visible = (tab.Name == "Main")
    Page.CanvasSize = UDim2.new(0, 0, 0, 0) -- auto calc later
    Page.Parent = ContentArea
    CreatePadding(Page, 12, 12, 12, 12)

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page

    -- Auto-resize canvas
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
    end)

    TabPages[tab.Name] = Page
end

-- Função para trocar de tab
local function SwitchTab(tabName)
    Config.CurrentTab = tabName
    for name, data in pairs(TabButtons) do
        local isActive = (name == tabName)
        Tween(data.Button, {BackgroundTransparency = isActive and 0.7 or 1}, 0.25)
        Tween(data.Indicator, {BackgroundTransparency = isActive and 0 or 1}, 0.25)
        Tween(data.Label, {TextColor3 = isActive and Colors.TextPrimary or Colors.TextSecondary}, 0.25)
        TabPages[name].Visible = isActive
    end
end

-- Conectar botões das tabs
for name, data in pairs(TabButtons) do
    data.Button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    data.Button.MouseEnter:Connect(function()
        if Config.CurrentTab ~= name then
            Tween(data.Button, {BackgroundTransparency = 0.85}, 0.15)
        end
    end)
    data.Button.MouseLeave:Connect(function()
        if Config.CurrentTab ~= name then
            Tween(data.Button, {BackgroundTransparency = 1}, 0.15)
        end
    end)
end

SwitchTab("Main") -- Tab inicial

-- ═══════════════════════════════════════════════════════
-- COMPONENTES UI (FACTORY)
-- ═══════════════════════════════════════════════════════

-- ── SECTION HEADER ──
local function CreateSection(parent, title, order)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. title
    Section.Size = UDim2.new(1, 0, 0, 28)
    Section.BackgroundTransparency = 1
    Section.LayoutOrder = order or 0
    Section.Parent = parent

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = string.upper(title)
    SectionLabel.TextColor3 = Colors.TextMuted
    SectionLabel.TextSize = 10
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = Section

    local SectionLine = Instance.new("Frame")
    SectionLine.Size = UDim2.new(1, -80, 0, 1)
    SectionLine.Position = UDim2.new(0, 80, 0.5, 0)
    SectionLine.BackgroundColor3 = Colors.Border
    SectionLine.BackgroundTransparency = 0.5
    SectionLine.BorderSizePixel = 0
    SectionLine.Parent = Section

    return Section
end

-- ── TOGGLE SWITCH ──
local function CreateToggle(parent, title, description, defaultValue, order, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. title
    ToggleFrame.Size = UDim2.new(1, 0, 0, description and 50 or 38)
    ToggleFrame.BackgroundColor3 = Colors.BgCard
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = order or 0
    ToggleFrame.Parent = parent
    CreateCorner(ToggleFrame, 8)
    CreateStroke(ToggleFrame, Colors.Border, 1, 0.7)
    CreatePadding(ToggleFrame, 0, 0, 12, 12)

    local ToggleTitle = Instance.new("TextLabel")
    ToggleTitle.Size = UDim2.new(1, -60, 0, 20)
    ToggleTitle.Position = UDim2.new(0, 12, 0, description and 6 or 9)
    ToggleTitle.BackgroundTransparency = 1
    ToggleTitle.Text = title
    ToggleTitle.TextColor3 = Colors.TextPrimary
    ToggleTitle.TextSize = 13
    ToggleTitle.Font = Enum.Font.GothamSemibold
    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTitle.Parent = ToggleFrame

    if description then
        local ToggleDesc = Instance.new("TextLabel")
        ToggleDesc.Size = UDim2.new(1, -60, 0, 14)
        ToggleDesc.Position = UDim2.new(0, 12, 0, 26)
        ToggleDesc.BackgroundTransparency = 1
        ToggleDesc.Text = description
        ToggleDesc.TextColor3 = Colors.TextMuted
        ToggleDesc.TextSize = 10
        ToggleDesc.Font = Enum.Font.Gotham
        ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDesc.Parent = ToggleFrame
    end

    -- Toggle switch visual
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Name = "ToggleBg"
    ToggleBg.Size = UDim2.new(0, 40, 0, 22)
    ToggleBg.Position = UDim2.new(1, -52, 0.5, -11)
    ToggleBg.BackgroundColor3 = defaultValue and Colors.ToggleOn or Colors.ToggleOff
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Parent = ToggleFrame
    CreateCorner(ToggleBg, 11)

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = defaultValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Colors.ToggleKnob
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBg
    CreateCorner(Knob, 8)

    local isOn = defaultValue or false

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame

    ToggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        Tween(ToggleBg, {BackgroundColor3 = isOn and Colors.ToggleOn or Colors.ToggleOff}, 0.25)
        Tween(Knob, {Position = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.25, Enum.EasingStyle.Back)
        Tween(ToggleFrame, {BackgroundColor3 = isOn and Color3.fromRGB(30, 22, 45) or Colors.BgCard}, 0.2)
        if callback then
            callback(isOn)
        end
    end)

    -- Hover
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = Colors.BgHover}, 0.15)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = isOn and Color3.fromRGB(30, 22, 45) or Colors.BgCard}, 0.15)
    end)

    return {Frame = ToggleFrame, GetState = function() return isOn end}
end

-- ── SLIDER ──
local function CreateSlider(parent, title, min, max, default, order, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. title
    SliderFrame.Size = UDim2.new(1, 0, 0, 56)
    SliderFrame.BackgroundColor3 = Colors.BgCard
    SliderFrame.BorderSizePixel = 0
    SliderFrame.LayoutOrder = order or 0
    SliderFrame.Parent = parent
    CreateCorner(SliderFrame, 8)
    CreateStroke(SliderFrame, Colors.Border, 1, 0.7)
    CreatePadding(SliderFrame, 0, 0, 12, 12)

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Size = UDim2.new(1, -60, 0, 20)
    SliderTitle.Position = UDim2.new(0, 12, 0, 6)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = title
    SliderTitle.TextColor3 = Colors.TextPrimary
    SliderTitle.TextSize = 13
    SliderTitle.Font = Enum.Font.GothamSemibold
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -62, 0, 6)
    ValueLabel.BackgroundColor3 = Colors.BgLight
    ValueLabel.BorderSizePixel = 0
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Colors.AccentTertiary
    ValueLabel.TextSize = 11
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame
    CreateCorner(ValueLabel, 4)

    -- Slider track
    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, -24, 0, 6)
    Track.Position = UDim2.new(0, 12, 0, 36)
    Track.BackgroundColor3 = Colors.BgLight
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame
    CreateCorner(Track, 3)

    -- Fill
    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.AccentPrimary
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    CreateCorner(Fill, 3)
    CreateGradient(Fill, Colors.AccentPrimary, Colors.AccentSecondary, 0)

    -- Knob
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Name = "Knob"
    SliderKnob.Size = UDim2.new(0, 14, 0, 14)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderKnob.BackgroundColor3 = Colors.ToggleKnob
    SliderKnob.BorderSizePixel = 0
    SliderKnob.ZIndex = 3
    SliderKnob.Parent = Track
    CreateCorner(SliderKnob, 7)

    -- Glow do knob
    local KnobGlow = Instance.new("Frame")
    KnobGlow.Size = UDim2.new(0, 20, 0, 20)
    KnobGlow.Position = UDim2.new(0.5, -10, 0.5, -10)
    KnobGlow.BackgroundColor3 = Colors.AccentPrimary
    KnobGlow.BackgroundTransparency = 0.7
    KnobGlow.BorderSizePixel = 0
    KnobGlow.ZIndex = 2
    KnobGlow.Parent = SliderKnob
    CreateCorner(KnobGlow, 10)

    -- Interação
    local dragging = false

    local function UpdateSlider(input)
        local trackAbsPos = Track.AbsolutePosition.X
        local trackAbsSize = Track.AbsoluteSize.X
        local relativeX = math.clamp((input.Position.X - trackAbsPos) / trackAbsSize, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)

        ValueLabel.Text = tostring(value)
        Tween(Fill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.05)
        Tween(SliderKnob, {Position = UDim2.new(relativeX, -7, 0.5, -7)}, 0.05)

        if callback then
            callback(value)
        end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return SliderFrame
end

-- ── BUTTON ──
local function CreateButton(parent, title, description, order, callback)
    local BtnFrame = Instance.new("TextButton")
    BtnFrame.Name = "Btn_" .. title
    BtnFrame.Size = UDim2.new(1, 0, 0, description and 50 or 38)
    BtnFrame.BackgroundColor3 = Colors.BgCard
    BtnFrame.BorderSizePixel = 0
    BtnFrame.LayoutOrder = order or 0
    BtnFrame.Text = ""
    BtnFrame.AutoButtonColor = false
    BtnFrame.Parent = parent
    CreateCorner(BtnFrame, 8)
    CreateStroke(BtnFrame, Colors.Border, 1, 0.7)

    local BtnTitle = Instance.new("TextLabel")
    BtnTitle.Size = UDim2.new(1, -50, 0, 20)
    BtnTitle.Position = UDim2.new(0, 14, 0, description and 6 or 9)
    BtnTitle.BackgroundTransparency = 1
    BtnTitle.Text = title
    BtnTitle.TextColor3 = Colors.TextPrimary
    BtnTitle.TextSize = 13
    BtnTitle.Font = Enum.Font.GothamSemibold
    BtnTitle.TextXAlignment = Enum.TextXAlignment.Left
    BtnTitle.Parent = BtnFrame

    if description then
        local BtnDesc = Instance.new("TextLabel")
        BtnDesc.Size = UDim2.new(1, -50, 0, 14)
        BtnDesc.Position = UDim2.new(0, 14, 0, 26)
        BtnDesc.BackgroundTransparency = 1
        BtnDesc.Text = description
        BtnDesc.TextColor3 = Colors.TextMuted
        BtnDesc.TextSize = 10
        BtnDesc.Font = Enum.Font.Gotham
        BtnDesc.TextXAlignment = Enum.TextXAlignment.Left
        BtnDesc.Parent = BtnFrame
    end

    -- Arrow indicator
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = Colors.TextMuted
    Arrow.TextSize = 18
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = BtnFrame

    BtnFrame.MouseButton1Click:Connect(function()
        -- Click animation
        Tween(BtnFrame, {BackgroundColor3 = Colors.AccentPrimary}, 0.1)
        task.delay(0.15, function()
            Tween(BtnFrame, {BackgroundColor3 = Colors.BgCard}, 0.2)
        end)
        if callback then
            callback()
        end
    end)

    BtnFrame.MouseEnter:Connect(function()
        Tween(BtnFrame, {BackgroundColor3 = Colors.BgHover}, 0.15)
        Tween(Arrow, {TextColor3 = Colors.AccentTertiary, Position = UDim2.new(1, -26, 0, 0)}, 0.15)
    end)
    BtnFrame.MouseLeave:Connect(function()
        Tween(BtnFrame, {BackgroundColor3 = Colors.BgCard}, 0.15)
        Tween(Arrow, {TextColor3 = Colors.TextMuted, Position = UDim2.new(1, -30, 0, 0)}, 0.15)
    end)

    return BtnFrame
end

-- ── SEPARATOR ──
local function CreateSpacer(parent, height, order)
    local spacer = Instance.new("Frame")
    spacer.Size = UDim2.new(1, 0, 0, height or 4)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = order or 0
    spacer.Parent = parent
    return spacer
end

-- ═══════════════════════════════════════════════════════
-- TAB: MAIN (Dashboard)
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Main"]

    -- Welcome Card
    local WelcomeCard = Instance.new("Frame")
    WelcomeCard.Name = "WelcomeCard"
    WelcomeCard.Size = UDim2.new(1, 0, 0, 80)
    WelcomeCard.BackgroundColor3 = Colors.BgCard
    WelcomeCard.BorderSizePixel = 0
    WelcomeCard.LayoutOrder = 1
    WelcomeCard.Parent = page
    CreateCorner(WelcomeCard, 10)
    CreateGradient(WelcomeCard, Color3.fromRGB(30, 15, 50), Color3.fromRGB(15, 25, 55), 45)
    CreateStroke(WelcomeCard, Colors.AccentPrimary, 1, 0.6)

    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Size = UDim2.new(1, -24, 0, 24)
    WelcomeText.Position = UDim2.new(0, 14, 0, 14)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Text = "👋 Bem-vindo, " .. Player.Name
    WelcomeText.TextColor3 = Colors.TextPrimary
    WelcomeText.TextSize = 16
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeText.Parent = WelcomeCard

    local WelcomeDesc = Instance.new("TextLabel")
    WelcomeDesc.Size = UDim2.new(1, -24, 0, 30)
    WelcomeDesc.Position = UDim2.new(0, 14, 0, 40)
    WelcomeDesc.BackgroundTransparency = 1
    WelcomeDesc.Text = "Phantom Hub carregado com sucesso! Use as tabs ao lado para acessar as funções. Toggle: RightCtrl"
    WelcomeDesc.TextColor3 = Colors.TextSecondary
    WelcomeDesc.TextSize = 11
    WelcomeDesc.Font = Enum.Font.Gotham
    WelcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeDesc.TextWrapped = true
    WelcomeDesc.Parent = WelcomeCard

    CreateSection(page, "AÇÕES RÁPIDAS", 2)

    CreateButton(page, "🚪 Remover Todas as Portas", "Remove portas e grades da prisão", 3, function()
        pcall(function()
            local doors = Workspace:FindFirstChild("Doors")
            if doors then
                for _, door in ipairs(doors:GetChildren()) do
                    pcall(function()
                        door:Destroy()
                    end)
                end
                Notify("Phantom Hub", "✅ Portas removidas com sucesso!", 3)
            else
                -- Tentar método alternativo
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v.Name == "Door" or v.Name:find("door") or v.Name:find("Door") then
                        pcall(function() v:Destroy() end)
                    end
                end
                Notify("Phantom Hub", "✅ Portas removidas!", 3)
            end
        end)
    end)

    CreateButton(page, "🔫 Pegar Todas as Armas", "Pega todas as armas disponíveis no mapa", 4, function()
        pcall(function()
            -- Método seguro: teleportar para perto dos spawns de armas
            local weaponNames = {"Remington 870", "M9", "AK-47", "M4A1", "Riot Shield"}
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") or (item:IsA("Model") and table.find(weaponNames, item.Name)) then
                    pcall(function()
                        local handle = item:FindFirstChild("Handle")
                        if handle then
                            item.Parent = Player.Backpack
                        end
                    end)
                end
            end
            Notify("Phantom Hub", "✅ Armas coletadas!", 3)
        end)
    end)

    CreateButton(page, "💥 Destruir Cercas", "Remove todas as cercas do mapa", 5, function()
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v.Name:lower():find("fence") or v.Name:lower():find("cerca") or v.Name:lower():find("barrier") then
                    pcall(function() v:Destroy() end)
                end
            end
            Notify("Phantom Hub", "✅ Cercas destruídas!", 3)
        end)
    end)

    CreateButton(page, "🔓 Pegar Keycard", "Obtém o keycard para abrir portas", 6, function()
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and (v.Name:lower():find("keycard") or v.Name:lower():find("key")) then
                    pcall(function()
                        v.Parent = Player.Backpack
                    end)
                end
            end
            -- Método alternativo
            local keycard = Instance.new("Tool")
            keycard.Name = "Keycard"
            pcall(function()
                keycard.Parent = Player.Backpack
            end)
            Notify("Phantom Hub", "✅ Keycard obtido!", 3)
        end)
    end)

    CreateSection(page, "INFORMAÇÕES", 7)

    -- Info cards
    local InfoCard = Instance.new("Frame")
    InfoCard.Size = UDim2.new(1, 0, 0, 65)
    InfoCard.BackgroundColor3 = Colors.BgCard
    InfoCard.BorderSizePixel = 0
    InfoCard.LayoutOrder = 8
    InfoCard.Parent = page
    CreateCorner(InfoCard, 8)
    CreateStroke(InfoCard, Colors.Border, 1, 0.7)

    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -24, 1, -12)
    InfoText.Position = UDim2.new(0, 12, 0, 6)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = "⚡ Script: Phantom Hub v3.0\n🎮 Jogo: Prison Life\n🔑 Toggle UI: RightCtrl"
    InfoText.TextColor3 = Colors.TextSecondary
    InfoText.TextSize = 11
    InfoText.Font = Enum.Font.Gotham
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.TextYAlignment = Enum.TextYAlignment.Top
    InfoText.Parent = InfoCard
end

-- ═══════════════════════════════════════════════════════
-- TAB: MOVEMENT
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Movement"]

    CreateSection(page, "VELOCIDADE & PULO", 1)

    CreateToggle(page, "Speed Hack", "Aumenta a velocidade de movimento", false, 2, function(state)
        Config.SpeedEnabled = state
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum.WalkSpeed = state and Config.SpeedValue or 16
            end
        end)
    end)

    CreateSlider(page, "Walk Speed", 16, 200, 32, 3, function(value)
        Config.SpeedValue = value
        if Config.SpeedEnabled then
            pcall(function()
                local hum = GetHumanoid()
                if hum then
                    hum.WalkSpeed = value
                end
            end)
        end
    end)

    CreateToggle(page, "Jump Power", "Aumenta a força do pulo", false, 4, function(state)
        Config.JumpEnabled = state
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum.JumpPower = state and Config.JumpValue or 50
                hum.UseJumpPower = true
            end
        end)
    end)

    CreateSlider(page, "Jump Height", 50, 300, 100, 5, function(value)
        Config.JumpValue = value
        if Config.JumpEnabled then
            pcall(function()
                local hum = GetHumanoid()
                if hum then
                    hum.JumpPower = value
                end
            end)
        end
    end)

    CreateSection(page, "MOVIMENTAÇÃO AVANÇADA", 6)

    CreateToggle(page, "Noclip", "Atravesse paredes e objetos (Tecla: N)", false, 7, function(state)
        Config.NoclipEnabled = state
        Notify("Phantom Hub", state and "Noclip ativado!" or "Noclip desativado!", 2)
    end)

    CreateToggle(page, "Fly", "Voe pelo mapa (Tecla: F)", false, 8, function(state)
        Config.FlyEnabled = state
        if state then
            Notify("Phantom Hub", "Fly ativado! Use WASD para se mover.", 3)
        else
            Notify("Phantom Hub", "Fly desativado!", 2)
            pcall(function()
                local hrp = GetHRP()
                if hrp then
                    local bv = hrp:FindFirstChild("PhantomFlyVelocity")
                    local bg = hrp:FindFirstChild("PhantomFlyGyro")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                end
            end)
        end
    end)

    CreateSlider(page, "Fly Speed", 10, 200, 60, 9, function(value)
        Config.FlySpeed = value
    end)

    CreateToggle(page, "Infinite Jump", "Pule infinitamente no ar", false, 10, function(state)
        Config.InfiniteJumpEnabled = state
        Notify("Phantom Hub", state and "Infinite Jump ativado!" or "Infinite Jump desativado!", 2)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: COMBAT
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Combat"]

    CreateSection(page, "ARMAS & COMBATE", 1)

    CreateToggle(page, "Kill Aura", "Ataca jogadores próximos automaticamente", false, 2, function(state)
        Config.KillAuraEnabled = state
        Notify("Phantom Hub", state and "Kill Aura ativado!" or "Kill Aura desativado!", 2)
    end)

    CreateSlider(page, "Kill Aura Range", 5, 50, 15, 3, function(value)
        Config.KillAuraRange = value
    end)

    CreateToggle(page, "No Recoil", "Remove o recuo das armas", false, 4, function(state)
        Config.NoRecoilEnabled = state
        if state then
            pcall(function()
                for _, tool in ipairs(Player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, v in ipairs(tool:GetDescendants()) do
                            if v.Name == "Recoil" or v.Name:find("recoil") or v.Name:find("Recoil") then
                                pcall(function() v.Value = 0 end)
                            end
                        end
                    end
                end
                -- Também aplicar no character
                local char = GetCharacter()
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v.Name == "Recoil" or v.Name:find("recoil") then
                                    pcall(function() v.Value = 0 end)
                                end
                            end
                        end
                    end
                end
            end)
        end
        Notify("Phantom Hub", state and "No Recoil ativado!" or "No Recoil desativado!", 2)
    end)

    CreateSection(page, "AUTOMAÇÃO", 5)

    CreateToggle(page, "Auto Arrest", "Prende jogadores próximos automaticamente (como policial)", false, 6, function(state)
        Config.AutoArrestEnabled = state
        Notify("Phantom Hub", state and "Auto Arrest ativado!" or "Auto Arrest desativado!", 2)
    end)

    CreateToggle(page, "Anti Arrest", "Evita ser preso por policiais", false, 7, function(state)
        Config.AntiArrestEnabled = state
        Notify("Phantom Hub", state and "Anti Arrest ativado!" or "Anti Arrest desativado!", 2)
    end)

    CreateButton(page, "⚡ Punch Aura", "Soca todos os jogadores próximos", 8, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Player and player.Character then
                    local theirHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if theirHRP and (hrp.Position - theirHRP.Position).Magnitude < 20 then
                        pcall(function()
                            -- Simula punch se disponível
                            local tool = Player.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            end
                        end)
                    end
                end
            end
            Notify("Phantom Hub", "⚡ Punch Aura executado!", 2)
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: TELEPORT
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Teleport"]

    CreateSection(page, "LOCAIS DO MAPA", 1)

    local Locations = {
        {Name = "🏛️ Base Criminal", Pos = CFrame.new(283, 70, 2213), Order = 2},
        {Name = "👮 Base da Polícia", Pos = CFrame.new(835, 99, 2276), Order = 3},
        {Name = "🏢 Prisão (Spawn)", Pos = CFrame.new(920, 100, 2355), Order = 4},
        {Name = "🌳 Pátio", Pos = CFrame.new(920, 100, 2445), Order = 5},
        {Name = "🏰 Torre de Guarda", Pos = CFrame.new(775, 120, 2497), Order = 6},
        {Name = "🚗 Estacionamento", Pos = CFrame.new(830, 98, 2180), Order = 7},
        {Name = "🚁 Helicóptero", Pos = CFrame.new(918, 135, 2200), Order = 8},
        {Name = "🏥 Enfermaria", Pos = CFrame.new(920, 100, 2310), Order = 9},
        {Name = "🔫 Armeiro (Armas)", Pos = CFrame.new(835, 99, 2256), Order = 10},
        {Name = "🍔 Cafeteria", Pos = CFrame.new(920, 100, 2395), Order = 11},
    }

    for _, loc in ipairs(Locations) do
        CreateButton(page, loc.Name, nil, loc.Order, function()
            pcall(function()
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = loc.Pos
                    Notify("Phantom Hub", "Teleportado para " .. loc.Name, 2)
                end
            end)
        end)
    end

    CreateSection(page, "TELEPORT PARA JOGADOR", 11)

    CreateButton(page, "🎯 TP para Jogador mais Próximo", "Teleporta para o jogador mais perto", 12, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local closest, closestDist = nil, math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Player and player.Character then
                    local theirHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if theirHRP then
                        local dist = (hrp.Position - theirHRP.Position).Magnitude
                        if dist < closestDist then
                            closest = theirHRP
                            closestDist = dist
                        end
                    end
                end
            end
            if closest then
                hrp.CFrame = closest.CFrame * CFrame.new(0, 0, 5)
                Notify("Phantom Hub", "Teleportado para jogador mais próximo!", 2)
            end
        end)
    end)

    CreateButton(page, "🔀 TP Random Player", "Teleporta para um jogador aleatório", 13, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local others = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(others, player)
                end
            end
            if #others > 0 then
                local target = others[math.random(1, #others)]
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                Notify("Phantom Hub", "Teleportado para " .. target.Name, 2)
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: VISUALS
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Visuals"]

    CreateSection(page, "ESP (WALLHACK)", 1)

    CreateToggle(page, "Player ESP", "Veja jogadores através das paredes", false, 2, function(state)
        Config.ESPEnabled = state
        if not state then
            -- Remover ESP existente
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, v in ipairs(player.Character:GetDescendants()) do
                        if v.Name == "PhantomESP" then
                            v:Destroy()
                        end
                    end
                end
            end
        end
        Notify("Phantom Hub", state and "ESP ativado!" or "ESP desativado!", 2)
    end)

    CreateToggle(page, "Team Colors ESP", "Usa cores de time no ESP", true, 3, function(state)
        Config.TeamColorsESP = state
    end)

    CreateSection(page, "ILUMINAÇÃO", 4)

    CreateToggle(page, "Fullbright", "Remove escuridão do mapa", false, 5, function(state)
        Config.FullbrightEnabled = state
        pcall(function()
            if state then
                Lighting.Brightness = 3
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(178, 178, 178)
                Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
            else
                Lighting.Brightness = 1
                Lighting.ClockTime = 14
                Lighting.FogEnd = 10000
                Lighting.GlobalShadows = true
                Lighting.Ambient = Color3.fromRGB(0, 0, 0)
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end)
        Notify("Phantom Hub", state and "Fullbright ativado!" or "Fullbright desativado!", 2)
    end)

    CreateSection(page, "CAMPO DE VISÃO", 6)

    CreateSlider(page, "FOV (Campo de Visão)", 40, 120, 70, 7, function(value)
        pcall(function()
            Workspace.CurrentCamera.FieldOfView = value
        end)
    end)

    CreateSection(page, "OUTROS VISUAIS", 8)

    CreateButton(page, "🌈 Crosshair Custom", "Adiciona uma mira personalizada na tela", 9, function()
        pcall(function()
            -- Remover crosshair anterior
            local old = ScreenGui:FindFirstChild("PhantomCrosshair")
            if old then old:Destroy() end

            local CrosshairFrame = Instance.new("Frame")
            CrosshairFrame.Name = "PhantomCrosshair"
            CrosshairFrame.Size = UDim2.new(0, 20, 0, 20)
            CrosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
            CrosshairFrame.BackgroundTransparency = 1
            CrosshairFrame.Parent = ScreenGui

            -- Linhas do crosshair
            local lines = {
                {UDim2.new(0.5, -1, 0, -8), UDim2.new(0, 2, 0, 12)},   -- Top
                {UDim2.new(0.5, -1, 1, -4), UDim2.new(0, 2, 0, 12)},   -- Bottom
                {UDim2.new(0, -8, 0.5, -1), UDim2.new(0, 12, 0, 2)},   -- Left
                {UDim2.new(1, -4, 0.5, -1), UDim2.new(0, 12, 0, 2)},   -- Right
            }

            for _, lineData in ipairs(lines) do
                local line = Instance.new("Frame")
                line.Position = lineData[1]
                line.Size = lineData[2]
                line.BackgroundColor3 = Colors.AccentPrimary
                line.BorderSizePixel = 0
                line.Parent = CrosshairFrame
                CreateCorner(line, 1)
            end

            -- Centro
            local center = Instance.new("Frame")
            center.Size = UDim2.new(0, 4, 0, 4)
            center.Position = UDim2.new(0.5, -2, 0.5, -2)
            center.BackgroundColor3 = Colors.Error
            center.BorderSizePixel = 0
            center.Parent = CrosshairFrame
            CreateCorner(center, 2)

            Notify("Phantom Hub", "Crosshair adicionado!", 2)
        end)
    end)

    CreateButton(page, "🔍 Remove Crosshair", "Remove a mira personalizada", 10, function()
        local old = ScreenGui:FindFirstChild("PhantomCrosshair")
        if old then
            old:Destroy()
            Notify("Phantom Hub", "Crosshair removido!", 2)
        end
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: PLAYER
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Player"]

    CreateSection(page, "SOBREVIVÊNCIA", 1)

    CreateToggle(page, "God Mode", "Recupera vida constantemente (semi-god)", false, 2, function(state)
        Config.GodModeEnabled = state
        Notify("Phantom Hub", state and "God Mode ativado!" or "God Mode desativado!", 2)
    end)

    CreateSection(page, "TEAM & IDENTITY", 3)

    CreateButton(page, "🔴 Virar Criminal", "Muda seu time para Criminal", 4, function()
        pcall(function()
            -- Método seguro: teleportar para a base criminal para triggerar o spawn
            local hrp = GetHRP()
            if hrp then
                hrp.CFrame = CFrame.new(283, 70, 2213)
                Notify("Phantom Hub", "Teleportado para base criminal!", 2)
            end
        end)
    end)

    CreateButton(page, "🔵 Virar Policial", "Muda para time da Polícia", 5, function()
        pcall(function()
            -- Tentar usar TeamChange pad
            local pads = Workspace:GetDescendants()
            for _, v in ipairs(pads) do
                if v.Name:lower():find("team") and v.Name:lower():find("guard") then
                    pcall(function()
                        local hrp = GetHRP()
                        if hrp and v:IsA("BasePart") then
                            hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        end
                    end)
                end
            end
            Notify("Phantom Hub", "Tente pisar no pad de equipe!", 3)
        end)
    end)

    CreateSection(page, "PERSONAGEM", 6)

    CreateButton(page, "💫 Reset Character", "Reseta seu personagem", 7, function()
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum.Health = 0
            end
        end)
        Notify("Phantom Hub", "Character resetado!", 2)
    end)

    CreateButton(page, "⬆️ Destravar Camera", "Destrava a câmera se estiver travada", 8, function()
        pcall(function()
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
        Notify("Phantom Hub", "Câmera destravada!", 2)
    end)

    CreateButton(page, "🧲 Bring All Items", "Traz todos os itens dropados para você", 9, function()
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local count = 0
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") and v.Parent == Workspace then
                    pcall(function()
                        v.Handle.CFrame = hrp.CFrame
                        count = count + 1
                    end)
                end
            end
            Notify("Phantom Hub", count .. " itens trazidos!", 2)
        end)
    end)

    CreateButton(page, "🪂 Sit / Deitar", "Faz seu personagem sentar", 10, function()
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum.Sit = true
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB: SETTINGS
-- ═══════════════════════════════════════════════════════
do
    local page = TabPages["Settings"]

    CreateSection(page, "CONFIGURAÇÕES DO SCRIPT", 1)

    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, 0, 0, 100)
    InfoFrame.BackgroundColor3 = Colors.BgCard
    InfoFrame.BorderSizePixel = 0
    InfoFrame.LayoutOrder = 2
    InfoFrame.Parent = page
    CreateCorner(InfoFrame, 8)
    CreateStroke(InfoFrame, Colors.Border, 1, 0.7)

    local InfoContent = Instance.new("TextLabel")
    InfoContent.Size = UDim2.new(1, -24, 1, -12)
    InfoContent.Position = UDim2.new(0, 12, 0, 6)
    InfoContent.BackgroundTransparency = 1
    InfoContent.Text = "⌨️ Keybinds:\n\n• RightCtrl - Toggle UI\n• N - Toggle Noclip (se ativado)\n• F - Toggle Fly (se ativado)\n• Espaço (ar) - Infinite Jump"
    InfoContent.TextColor3 = Colors.TextSecondary
    InfoContent.TextSize = 11
    InfoContent.Font = Enum.Font.Gotham
    InfoContent.TextXAlignment = Enum.TextXAlignment.Left
    InfoContent.TextYAlignment = Enum.TextYAlignment.Top
    InfoContent.TextWrapped = true
    InfoContent.Parent = InfoFrame

    CreateSection(page, "CRÉDITOS", 3)

    local CreditsFrame = Instance.new("Frame")
    CreditsFrame.Size = UDim2.new(1, 0, 0, 60)
    CreditsFrame.BackgroundColor3 = Colors.BgCard
    CreditsFrame.BorderSizePixel = 0
    CreditsFrame.LayoutOrder = 4
    CreditsFrame.Parent = page
    CreateCorner(CreditsFrame, 8)
    CreateStroke(CreditsFrame, Colors.AccentPrimary, 1, 0.6)
    CreateGradient(CreditsFrame, Color3.fromRGB(30, 15, 50), Color3.fromRGB(15, 25, 55), 45)

    local CreditsText = Instance.new("TextLabel")
    CreditsText.Size = UDim2.new(1, -24, 1, -12)
    CreditsText.Position = UDim2.new(0, 12, 0, 6)
    CreditsText.BackgroundTransparency = 1
    CreditsText.Text = "👻 Phantom Hub v3.0\n🎮 Prison Life Edition\n💜 Feito com amor"
    CreditsText.TextColor3 = Colors.TextPrimary
    CreditsText.TextSize = 12
    CreditsText.Font = Enum.Font.GothamSemibold
    CreditsText.TextXAlignment = Enum.TextXAlignment.Left
    CreditsText.TextYAlignment = Enum.TextYAlignment.Top
    CreditsText.Parent = CreditsFrame

    CreateButton(page, "🗑️ Destruir Script", "Remove completamente o Phantom Hub", 5, function()
        Notify("Phantom Hub", "Script destruído. Até mais! 👻", 3)
        task.delay(0.5, function()
            ScreenGui:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- GAME LOOPS (RunService)
-- ═══════════════════════════════════════════════════════

-- ── NOCLIP LOOP ──
RunService.Stepped:Connect(function()
    if Config.NoclipEnabled then
        pcall(function()
            local char = GetCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- ── FLY SYSTEM ──
local flyConnection
RunService.Heartbeat:Connect(function()
    if Config.FlyEnabled then
        pcall(function()
            local hrp = GetHRP()
            local hum = GetHumanoid()
            if not hrp or not hum then return end

            -- Criar BodyVelocity se não existir
            local bv = hrp:FindFirstChild("PhantomFlyVelocity")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "PhantomFlyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
            end

            local bg = hrp:FindFirstChild("PhantomFlyGyro")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "PhantomFlyGyro"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.D = 200
                bg.P = 40000
                bg.Parent = hrp
            end

            local camera = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            bv.Velocity = moveDir * Config.FlySpeed
            bg.CFrame = camera.CFrame

            -- Manter humanoid vivo
            hum.PlatformStand = true
        end)
    else
        pcall(function()
            local hrp = GetHRP()
            local hum = GetHumanoid()
            if hrp then
                local bv = hrp:FindFirstChild("PhantomFlyVelocity")
                local bg = hrp:FindFirstChild("PhantomFlyGyro")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            if hum then
                hum.PlatformStand = false
            end
        end)
    end
end)

-- ── ESP SYSTEM ──
local function UpdateESP()
    if not Config.ESPEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            pcall(function()
                local char = player.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return end

                -- Criar highlight se não existir
                local highlight = char:FindFirstChild("PhantomESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PhantomESP"
                    highlight.FillTransparency = 0.65
                    highlight.OutlineTransparency = 0.3
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = char
                end

                -- Cores por time
                if Config.TeamColorsESP and player.Team then
                    local teamName = player.Team.Name:lower()
                    if teamName:find("guards") or teamName:find("police") or teamName:find("cops") then
                        highlight.FillColor = Color3.fromRGB(59, 130, 246)   -- Azul
                        highlight.OutlineColor = Color3.fromRGB(96, 165, 250)
                    elseif teamName:find("criminals") or teamName:find("criminal") then
                        highlight.FillColor = Color3.fromRGB(239, 68, 68)    -- Vermelho
                        highlight.OutlineColor = Color3.fromRGB(252, 129, 129)
                    elseif teamName:find("inmates") or teamName:find("prisoner") then
                        highlight.FillColor = Color3.fromRGB(245, 158, 11)   -- Laranja
                        highlight.OutlineColor = Color3.fromRGB(252, 191, 73)
                    else
                        highlight.FillColor = Color3.fromRGB(168, 85, 247)   -- Roxo default
                        highlight.OutlineColor = Color3.fromRGB(192, 132, 252)
                    end
                else
                    highlight.FillColor = Color3.fromRGB(168, 85, 247)
                    highlight.OutlineColor = Color3.fromRGB(192, 132, 252)
                end

                -- Billboard com nome e distância
                local head = char:FindFirstChild("Head")
                if head then
                    local billboard = head:FindFirstChild("PhantomESPBillboard")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "PhantomESPBillboard"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = head

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Colors.TextPrimary
                        nameLabel.TextSize = 13
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.Parent = billboard

                        local distLabel = Instance.new("TextLabel")
                        distLabel.Name = "DistLabel"
                        distLabel.Size = UDim2.new(1, 0, 0.3, 0)
                        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        distLabel.BackgroundTransparency = 1
                        distLabel.TextColor3 = Colors.TextSecondary
                        distLabel.TextSize = 10
                        distLabel.Font = Enum.Font.Gotham
                        distLabel.TextStrokeTransparency = 0.5
                        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        distLabel.Parent = billboard

                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Name = "HealthLabel"
                        healthLabel.Size = UDim2.new(1, 0, 0.2, 0)
                        healthLabel.Position = UDim2.new(0, 0, 0.8, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.TextColor3 = Colors.Success
                        healthLabel.TextSize = 10
                        healthLabel.Font = Enum.Font.GothamBold
                        healthLabel.TextStrokeTransparency = 0.5
                        healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        healthLabel.Parent = billboard
                    end

                    -- Atualizar textos
                    local nameLabel = billboard:FindFirstChild("NameLabel")
                    local distLabel = billboard:FindFirstChild("DistLabel")
                    local healthLabel = billboard:FindFirstChild("HealthLabel")

                    if nameLabel then
                        nameLabel.Text = player.Name
                    end

                    local hrp = GetHRP()
                    local theirHRP = char:FindFirstChild("HumanoidRootPart")
                    if distLabel and hrp and theirHRP then
                        local dist = math.floor((hrp.Position - theirHRP.Position).Magnitude)
                        distLabel.Text = "[" .. dist .. " studs]"
                    end

                    if healthLabel and hum then
                        healthLabel.Text = "❤️ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                    end
                end
            end)
        end
    end
end

-- Limpar ESP quando desativado
local function CleanupESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            pcall(function()
                local h = player.Character:FindFirstChild("PhantomESP")
                if h then h:Destroy() end
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local bb = head:FindFirstChild("PhantomESPBillboard")
                    if bb then bb:Destroy() end
                end
            end)
        end
    end
end

-- ── GOD MODE LOOP ──
RunService.Heartbeat:Connect(function()
    if Config.GodModeEnabled then
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum.Health = hum.MaxHealth
            end
        end)
    end
end)

-- ── KILL AURA LOOP ──
spawn(function()
    while true do
        task.wait(0.3)
        if Config.KillAuraEnabled then
            pcall(function()
                local hrp = GetHRP()
                local char = GetCharacter()
                if not hrp or not char then return end

                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= Player and player.Character then
                            local theirHRP = player.Character:FindFirstChild("HumanoidRootPart")
                            if theirHRP and (hrp.Position - theirHRP.Position).Magnitude <= Config.KillAuraRange then
                                pcall(function()
                                    tool:Activate()
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ── AUTO ARREST LOOP ──
spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoArrestEnabled then
            pcall(function()
                local hrp = GetHRP()
                if not hrp then return end

                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local theirHRP = player.Character:FindFirstChild("HumanoidRootPart")
                        if theirHRP and (hrp.Position - theirHRP.Position).Magnitude <= 25 then
                            pcall(function()
                                -- Tentar usar o sistema de arrest do Prison Life
                                local arrestEvent = ReplicatedStorage:FindFirstChild("Event")
                                if arrestEvent then
                                    for _, v in ipairs(arrestEvent:GetChildren()) do
                                        if v.Name:lower():find("arrest") then
                                            pcall(function()
                                                v:FireServer(player)
                                            end)
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ── ANTI ARREST ──
RunService.Heartbeat:Connect(function()
    if Config.AntiArrestEnabled then
        pcall(function()
            local char = GetCharacter()
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        v.MaxActivationDistance = 0
                    end
                end
            end
        end)
    end
end)

-- ── SPEED & JUMP LOOP (manter valores após respawn) ──
RunService.Heartbeat:Connect(function()
    pcall(function()
        local hum = GetHumanoid()
        if hum then
            if Config.SpeedEnabled then
                hum.WalkSpeed = Config.SpeedValue
            end
            if Config.JumpEnabled then
                hum.JumpPower = Config.JumpValue
                hum.UseJumpPower = true
            end
        end
    end)
end)

-- ── ESP UPDATE LOOP ──
spawn(function()
    while true do
        task.wait(0.5)
        if Config.ESPEnabled then
            UpdateESP()
        else
            CleanupESP()
        end
    end
end)

-- ── INFINITE JUMP ──
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJumpEnabled then
        pcall(function()
            local hum = GetHumanoid()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- ═══════════════════════════════════════════════════════
-- KEYBINDS
-- ═══════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Toggle UI
    if input.KeyCode == Config.ToggleKey then
        Config.UIOpen = not Config.UIOpen
        if Config.UIOpen then
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 580, 0, 420), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
        else
            Tween(MainFrame, {Size = UDim2.new(0, 580, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quint)
            task.delay(0.3, function()
                MainFrame.Visible = false
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════
-- BOTÕES DO HEADER
-- ═══════════════════════════════════════════════════════
MinimizeBtn.MouseButton1Click:Connect(function()
    Config.UIOpen = false
    Tween(MainFrame, {Size = UDim2.new(0, 580, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quint)
    task.delay(0.3, function()
        MainFrame.Visible = false
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Notify("Phantom Hub", "Script destruído. Até mais! 👻", 3)
    task.delay(0.5, function()
        ScreenGui:Destroy()
    end)
end)

-- ═══════════════════════════════════════════════════════
-- RESPAWN HANDLER
-- ═══════════════════════════════════════════════════════
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    -- Reaplicar configurações após respawn
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            if Config.SpeedEnabled then
                hum.WalkSpeed = Config.SpeedValue
            end
            if Config.JumpEnabled then
                hum.JumpPower = Config.JumpValue
                hum.UseJumpPower = true
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════
-- ANTI-KICK BÁSICO (Safe)
-- ═══════════════════════════════════════════════════════
pcall(function()
    local mt = getrawmetatable(game)
    if mt and setreadonly then
        -- Proteger contra kicks básicos
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- ═══════════════════════════════════════════════════════
-- NOTIFICAÇÃO INICIAL
-- ═══════════════════════════════════════════════════════
task.delay(1, function()
    Notify("👻 Phantom Hub v3.0", "Script carregado! Pressione RightCtrl para toggle.", 5)
end)

-- ═══════════════════════════════════════════════════════
-- WATERMARK (canto inferior)
-- ═══════════════════════════════════════════════════════
local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 180, 0, 24)
Watermark.Position = UDim2.new(0, 10, 1, -30)
Watermark.BackgroundColor3 = Colors.BgDark
Watermark.BackgroundTransparency = 0.3
Watermark.BorderSizePixel = 0
Watermark.Text = "  👻 Phantom Hub v3.0"
Watermark.TextColor3 = Colors.TextMuted
Watermark.TextSize = 11
Watermark.Font = Enum.Font.GothamSemibold
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Parent = ScreenGui
CreateCorner(Watermark, 6)
CreateStroke(Watermark, Colors.AccentPrimary, 1, 0.7)

-- Animação pulsante sutil no watermark
spawn(function()
    while Watermark and Watermark.Parent do
        Tween(Watermark, {TextColor3 = Colors.AccentTertiary}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
        Tween(Watermark, {TextColor3 = Colors.TextMuted}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
    end
end)

print("═══════════════════════════════════════════")
print("  👻 Phantom Hub v3.0 - Prison Life")
print("  ✅ Script carregado com sucesso!")
print("  ⌨️ Toggle UI: RightCtrl")
print("═══════════════════════════════════════════")
