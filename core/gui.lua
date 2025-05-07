local M = {}

function M.Init(Modules)
    local Config, State, Ai = Modules.Config, Modules.State, Modules.Ai
    local Player = game:GetService("Players").LocalPlayer
    local Gui = Player:WaitForChild("PlayerGui", 5)
    local MainMenu = Gui:FindFirstChild("MainMenu")
    local SideFrame = MainMenu and MainMenu:FindFirstChild("SideFrame")
    if not SideFrame then return warn("SideFrame not found. Aborting UI injection.") end
    if SideFrame:FindFirstChild("AiFrame") then return warn("Chess AI toggle UI already injected.") end

    local Frame = Instance.new("Frame", SideFrame)
    Frame.Name, Frame.AnchorPoint, Frame.Size, Frame.LayoutOrder = "AiFrame", Vector2.new(0, .45), UDim2.new(1,0,0.045,0), 99
    Frame.BackgroundColor3 = Config.COLORS.Off.Background

    local function applyStyle(On)
        local Style = On and Config.COLORS.On or Config.COLORS.Off
        Frame.BackgroundColor3 = Style.Background
        Icon.ImageColor3 = Style.Icon
        Label.Text, Label.TextColor3 = On and "AI: ON" or "AI: OFF", Style.Text
    end

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness, Stroke.Color = 1.6, Color3.fromRGB(255,170,0)

    local Icon = Instance.new("ImageLabel", Frame)
    Icon.Name, Icon.Image, Icon.AnchorPoint = "Icon", Config.ICON_IMAGE, Vector2.new(.5,.5)
    Icon.Position, Icon.Size, Icon.BackgroundTransparency = UDim2.new(.22,0,.5,0), UDim2.new(.18,0,.18,0), 1
    Icon.ImageTransparency = .18
    Instance.new("UIAspectRatioConstraint", Icon).AspectRatio = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Text, Label.AnchorPoint = "AI: OFF", Vector2.new(.5,.5)
    Label.Position, Label.Size = UDim2.new(.65,0,.5,0), UDim2.new(.55,0,.65,0)
    Label.FontFace = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.Regular)
    Label.TextSize, Label.TextScaled, Label.BackgroundTransparency = 14, true, 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Button = Instance.new("TextButton", Frame)
    Button.Size, Button.BackgroundTransparency, Button.AutoButtonColor = UDim2.new(1,0,1,0), 1, false
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)
    local BtnStroke = Instance.new("UIStroke", Button)
    BtnStroke.Thickness, BtnStroke.Color = 1.6, Color3.fromRGB(255,170,0)

    Button.MouseButton1Down:Connect(function()
        State.AiRunning = not State.AiRunning
        applyStyle(State.AiRunning)
        if State.AiRunning and not State.AiLoaded then
            Ai.Start(Modules)
            State.AiLoaded = true
        end
    end)

    print("[LOG]: GUI loaded.")
end

return M
