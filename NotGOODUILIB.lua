local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local IS_STUDIO = RunService:IsStudio()
local Player = Players.LocalPlayer

-- UI Elements
local Converted = {
	["_UI"] = Instance.new("ScreenGui"),
	["_Contents"] = Instance.new("Frame"),
	["_Bar"] = Instance.new("Frame"),
	["_Line"] = Instance.new("Frame"),
	["_UICorner"] = Instance.new("UICorner"),
	["_TextLabel"] = Instance.new("TextLabel"),
	["_UICorner1"] = Instance.new("UICorner"),
	["_Categories"] = Instance.new("Frame"),
	["_Line1"] = Instance.new("Frame"),
	["_UICorner2"] = Instance.new("UICorner"),
	["_List"] = Instance.new("Frame"),
	["_UIListLayout"] = Instance.new("UIListLayout"),
	["_UICorner3"] = Instance.new("UICorner"),
	["_Slider"] = Instance.new("Frame"),
	["_UICorner4"] = Instance.new("UICorner"),
	["_TextLabel1"] = Instance.new("TextLabel"),
	["_Toggle"] = Instance.new("TextButton"),
	["_UICorner5"] = Instance.new("UICorner"),
}

-- Properties
Converted["_UI"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_UI"].Name = "UI"
Converted["_UI"].Parent = Player:WaitForChild("PlayerGui")

Converted["_Contents"].BackgroundColor3 = Color3.fromRGB(48, 48, 48)
Converted["_Contents"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Contents"].BorderSizePixel = 0
Converted["_Contents"].Position = UDim2.new(0.347, 0, 0.238, 0)
Converted["_Contents"].Size = UDim2.new(0, 351, 0, 267)
Converted["_Contents"].Name = "Contents"
Converted["_Contents"].Parent = Converted["_UI"]

Converted["_Bar"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Converted["_Bar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar"].BorderSizePixel = 0
Converted["_Bar"].Position = UDim2.new(0, 0, 0, 0)
Converted["_Bar"].Size = UDim2.new(0, 351, 0, 21)
Converted["_Bar"].Name = "Bar"
Converted["_Bar"].Parent = Converted["_Contents"]

Converted["_Line"].BackgroundColor3 = Color3.fromRGB(42, 42, 42)
Converted["_Line"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Line"].BorderSizePixel = 0
Converted["_Line"].Position = UDim2.new(0, 0, 1, 0)
Converted["_Line"].Size = UDim2.new(0, 351, 0, -2)
Converted["_Line"].Name = "Line"
Converted["_Line"].Parent = Converted["_Bar"]

Converted["_UICorner"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner"].Parent = Converted["_Line"]

Converted["_TextLabel"].Font = Enum.Font.GothamBold
Converted["_TextLabel"].Text = "UI Library"
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextTransparency = 0.11
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Size = UDim2.new(0, 85, 0, 20)
Converted["_TextLabel"].Parent = Converted["_Bar"]

Converted["_UICorner1"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner1"].Parent = Converted["_Bar"]

Converted["_Categories"].BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Converted["_Categories"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Categories"].BorderSizePixel = 0
Converted["_Categories"].Position = UDim2.new(0, 0, 0.082, 0)
Converted["_Categories"].Size = UDim2.new(0, 85, 0, 245)
Converted["_Categories"].Name = "Categories"
Converted["_Categories"].Parent = Converted["_Contents"]

Converted["_Line1"].BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Converted["_Line1"].BackgroundTransparency = 1
Converted["_Line1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Line1"].BorderSizePixel = 0
Converted["_Line1"].Position = UDim2.new(1, 0, 0, 0)
Converted["_Line1"].Size = UDim2.new(0, 1, 0, 245)
Converted["_Line1"].Name = "Line"
Converted["_Line1"].Parent = Converted["_Categories"]

Converted["_UICorner2"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner2"].Parent = Converted["_Line1"]

Converted["_List"].BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Converted["_List"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_List"].BorderSizePixel = 0
Converted["_List"].Position = UDim2.new(0, 0, 0, 0)
Converted["_List"].Size = UDim2.new(0, 100, 0, 246)
Converted["_List"].Name = "List"
Converted["_List"].Parent = Converted["_Categories"]

Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout"].Parent = Converted["_List"]

Converted["_UICorner3"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner3"].Parent = Converted["_Categories"]

Converted["_Slider"].BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Converted["_Slider"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Slider"].BorderSizePixel = 0
Converted["_Slider"].Position = UDim2.new(0.310, 0, 0.112, 0)
Converted["_Slider"].Size = UDim2.new(0, 231, 0, 19)
Converted["_Slider"].Name = "Slider"
Converted["_Slider"].Parent = Converted["_Contents"]

Converted["_UICorner4"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner4"].Parent = Converted["_Slider"]

Converted["_TextLabel1"].Font = Enum.Font.GothamBold
Converted["_TextLabel1"].Text = "1/100"
Converted["_TextLabel1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].TextSize = 14
Converted["_TextLabel1"].TextTransparency = 0.01
Converted["_TextLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].BackgroundTransparency = 1
Converted["_TextLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel1"].BorderSizePixel = 0
Converted["_TextLabel1"].Position = UDim2.new(0.065, 0, 0, 0)
Converted["_TextLabel1"].Size = UDim2.new(0, 200, 0, 19)
Converted["_TextLabel1"].Parent = Converted["_Slider"]

Converted["_Toggle"].Font = Enum.Font.GothamBold
Converted["_Toggle"].Text = "Toggle"
Converted["_Toggle"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle"].TextSize = 14
Converted["_Toggle"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle"].BackgroundTransparency = 1
Converted["_Toggle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle"].BorderSizePixel = 0
Converted["_Toggle"].Position = UDim2.new(0.310, 0, 0.239, 0)
Converted["_Toggle"].Size = UDim2.new(0, 231, 0, 17)
Converted["_Toggle"].Name = "Toggle"
Converted["_Toggle"].Parent = Converted["_Contents"]

Converted["_UICorner5"].CornerRadius = UDim.new(0, 4)
Converted["_UICorner5"].Parent = Converted["_Toggle"]

-- UI Library Code
local Lib = {}; Lib.__index = Lib

local Category = {}; do
    Category.__index = Category

    function Category.new()
        local self = setmetatable({}, Category)
        self.Frame = Converted["_Contents"]:Clone()
        return self
    end
end

function Lib.new()
    local self = setmetatable({}, Lib)
    self.ScreenGui = Converted["_UI"]:Clone()
    self.Categories = {}
    return self
end

function Lib:AddCategory(name)
    local category = Category.new()
    table.insert(self.Categories, category)
    category.Frame.Parent = self.ScreenGui
    return category
end

local UILibrary = Lib.new()
local MainCategory = UILibrary:AddCategory("Main")

-- Toggle functionality
Converted["_Toggle"].MouseButton1Click:Connect(function()
    local toggleState = Converted["_Toggle"].BackgroundColor3 == Color3.fromRGB(255, 255, 255)
    if toggleState then
        Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    else
        Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Slider functionality
local function UpdateSlider(input)
    local size = Converted["_Slider"].AbsoluteSize.X
    local position = math.clamp((input.Position.X - Converted["_Slider"].AbsolutePosition.X) / size, 0, 1)
    Converted["_TextLabel1"].Text = math.floor(position * 100 + 0.5) .. "/100"
end

Converted["_Slider"].InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UpdateSlider(input)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                input = nil
            end
        end)
    end
end)

Converted["_Slider"].InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if input then
            UpdateSlider(input)
        end
    end
end)

-- Display UI
Converted["_UI"].Parent = Player:WaitForChild("PlayerGui")

return UILibrary
