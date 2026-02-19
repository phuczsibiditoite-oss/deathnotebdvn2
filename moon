--[[ 
    DEATH NOTE: ULTIMATE VIEW & KILL EDITION
    - Phím tắt: Right Control để ẩn/hiện menu.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if gethui():FindFirstChild("DeathNote_Ultimate_View") then
    gethui():FindFirstChild("DeathNote_Ultimate_View"):Destroy()
end

-- --- GIAO DIỆN ---
local Gui = Instance.new("ScreenGui")
Gui.Name = "DeathNote_Ultimate_View"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 480) -- Tăng chiều cao để đủ chỗ cho nút mới
Main.Position = UDim2.new(0.5, -160, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Background = Instance.new("ImageLabel")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundTransparency = 1
Background.Image = "rbxassetid://23640821" 
Background.ScaleType = Enum.ScaleType.Stretch
Background.ZIndex = 1
Background.Parent = Main

local Cover = Instance.new("Frame")
Cover.Size = UDim2.new(0.87, 0, 0.60, 0)
Cover.Position = UDim2.new(0.06, 0, 0.25, 0)
Cover.BackgroundColor3 = Color3.fromRGB(0,0,0)
Cover.BorderSizePixel = 0
Cover.ZIndex = 2
Cover.Parent = Main

-- --- UI TƯƠNG TÁC ---
local Box = Instance.new("TextBox")
Box.Size = UDim2.new(0.7, 0, 0, 35)
Box.Position = UDim2.new(0.15, 0, 0.4, 0)
Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Box.TextColor3 = Color3.fromRGB(0, 0, 0)
Box.PlaceholderText = "Tên Mục Tiêu"
Box.Text = ""
Box.Font = Enum.Font.Fantasy
Box.TextSize = 18
Box.ZIndex = 3
Box.Parent = Main
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.45, 0, 0, 40)
ExecuteBtn.Position = UDim2.new(0.275, 0, 0.6, 0)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0) 
ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
ExecuteBtn.Text = "GIẾT"
ExecuteBtn.Font = Enum.Font.Fantasy
ExecuteBtn.TextSize = 22
ExecuteBtn.ZIndex = 3
ExecuteBtn.Parent = Main
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ExecuteBtn).Color = Color3.new(1, 1, 1)

-- NÚT VIEW MỤC TIÊU
local ViewBtn = Instance.new("TextButton")
ViewBtn.Size = UDim2.new(0.45, 0, 0, 30)
ViewBtn.Position = UDim2.new(0.275, 0, 0.72, 0)
ViewBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 50) 
ViewBtn.TextColor3 = Color3.new(1, 1, 1)
ViewBtn.Text = "VIEW: OFF"
ViewBtn.Font = Enum.Font.Fantasy
ViewBtn.TextSize = 16
ViewBtn.ZIndex = 3
ViewBtn.Parent = Main
Instance.new("UICorner", ViewBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ViewBtn).Color = Color3.new(0.6, 0.6, 0.6)

local CooldownBack = Instance.new("Frame")
CooldownBack.Size = UDim2.new(0.45, 0, 0, 4)
CooldownBack.Position = UDim2.new(0.275, 0, 0.69, 0)
CooldownBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CooldownBack.Visible = false
CooldownBack.ZIndex = 3
CooldownBack.Parent = Main

local CooldownBar = Instance.new("Frame")
CooldownBar.Size = UDim2.new(1, 0, 1, 0)
CooldownBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CooldownBar.BorderSizePixel = 0
CooldownBar.Parent = CooldownBack

-- --- LOGIC ---
local targetPart = nil
local active = false
local onCooldown = false
local viewing = false

-- Auto-fill 3+ ký tự
Box:GetPropertyChangedSignal("Text"):Connect(function()
    local text = Box.Text
    if #text < 5 then return end
    local search = text:sub(1,1) == "@" and text:sub(2) or text
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #search) == search:lower() or p.DisplayName:lower():sub(1, #search) == search:lower() then
            if Box:IsFocused() then
                Box.Text = p.Name
                Box.CursorPosition = #Box.Text + 1
                break
            end
        end
    end
end)

local function UseTimeBall()
    local char = LocalPlayer.Character
    local tool = LocalPlayer.Backpack:FindFirstChild("Time_Ball") or (char and char:FindFirstChild("Time_Ball"))
    if tool then
        tool.Parent = char
        task.wait(0.05)
        tool:Activate()
        return true
    end
    return false
end

-- Xử lý nút GIẾT
ExecuteBtn.MouseButton1Click:Connect(function()
    if onCooldown then return end
    
    if not UseTimeBall() then
        ExecuteBtn.Text = "Cần Bơm"
        ExecuteBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1)
        ExecuteBtn.Text = "GIẾT"
        ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
        return
    end

    local targetPlayer = Players:FindFirstChild(Box.Text)
    if targetPlayer and targetPlayer.Character then
        targetPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        active = true
    end

    onCooldown = true
    ExecuteBtn.Text = "ĐANG GIẾT..."
    ExecuteBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    CooldownBack.Visible = true
    CooldownBar.Size = UDim2.new(1, 0, 1, 0)

    TweenService:Create(CooldownBar, TweenInfo.new(8, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(8, function()
        onCooldown = false
        active = false
        targetPart = nil
        ExecuteBtn.Text = "GIẾT"
        ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
        CooldownBack.Visible = false
    end)
end)

-- Xử lý nút VIEW
ViewBtn.MouseButton1Click:Connect(function()
    viewing = not viewing
    if viewing then
        local targetPlayer = Players:FindFirstChild(Box.Text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = targetPlayer.Character.Humanoid
            ViewBtn.Text = "VIEW: ON"
            ViewBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            viewing = false
            ViewBtn.Text = "KHÔNG THẤY"
            task.wait(1)
            ViewBtn.Text = "VIEW: OFF"
        end
    else
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        ViewBtn.Text = "VIEW: OFF"
        ViewBtn.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- Vòng lặp Truy đuổi & Check Camera
RunService.Stepped:Connect(function()
    -- Cập nhật View nếu người đó còn sống
    if viewing then
        local targetPlayer = Players:FindFirstChild(Box.Text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = targetPlayer.Character.Humanoid
        else
            viewing = false
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            ViewBtn.Text = "VIEW: OFF"
            ViewBtn.TextColor3 = Color3.new(1, 1, 1)
        end
    end

    if active and targetPart then
        pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", 10000) end)
        for _, v in ipairs(Workspace:GetChildren()) do
            if v.Name == "TimeBomb" and v:IsA("BasePart") then
                v.CanCollide = false
                local direction = (targetPart.Position - v.Position).Unit
                local distance = (targetPart.Position - v.Position).Magnitude
                if distance > 2 then
                    v.Velocity = direction * 500 -- Tăng tốc độ bay nhẹ
                    v.CFrame = CFrame.new(v.Position, targetPart.Position)
                else
                    v.Velocity = Vector3.new(0, 0, 0)
                    v.CFrame = targetPart.CFrame
                end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if i.KeyCode == Enum.KeyCode.RightControl and not gp then
        Main.Visible = not Main.Visible
    end
end)
