local TweenService = game:GetService("TweenService")

local Loader = Instance.new("ScreenGui")
local Loader_2 = Instance.new("Frame")
local Text = Instance.new("TextLabel")
local Blur = Instance.new("BlurEffect")

Loader.Name = "Loader"
Loader.Parent = gethui()
Loader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Loader_2.Name = "Loader"
Loader_2.Parent = Loader
Loader_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Loader_2.BackgroundTransparency = 1.000
Loader_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Loader_2.BorderSizePixel = 0
Loader_2.Position = UDim2.new(0.5, -220, 0.5, -58)
Loader_2.Size = UDim2.new(0, 440, 0, 117)

Text.Name = "Text"
Text.Parent = Loader_2
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.BackgroundTransparency = 1.000
Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
Text.BorderSizePixel = 0
Text.Position = UDim2.new(0.5, -100, 0.5, -25)
Text.Size = UDim2.new(0, 200, 0, 50)
Text.Font = Enum.Font.GothamBold
Text.Text = "Yon Hub"
Text.TextColor3 = Color3.fromRGB(0, 255, 17)
Text.TextScaled = true
Text.TextSize = 14.000
Text.TextWrapped = true

Blur.Parent = game:GetService("Workspace").CurrentCamera
Blur.Size = 24

local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 2)
local textGoals = {TextTransparency = 1}
local textTween = TweenService:Create(Text, tweenInfo, textGoals)

local blurGoals = {Size = 0}
local blurTween = TweenService:Create(Blur, tweenInfo, blurGoals)

textTween:Play()
blurTween:Play()

local function fadeOut()
    local fadeOutInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local fadeOutGoals = {BackgroundTransparency = 1}
    local loaderTween = TweenService:Create(Loader_2, fadeOutInfo, fadeOutGoals)
    local textFadeOutGoals = {TextTransparency = 1}
    local textFadeOutTween = TweenService:Create(Text, fadeOutInfo, textFadeOutGoals)

    loaderTween:Play()
    textFadeOutTween:Play()

    textFadeOutTween.Completed:Connect(function()
        Loader:Destroy()
        Blur:Destroy()
    end)
end

task.delay(3, fadeOut)
