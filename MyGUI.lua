local WiiUI = {
	
	Tabs  = {},
	Flags = {},

	Fonts = {
		Bold	 = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		Medium	 = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Regular  = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	}
}

-- // Services

local UserInputService = game:GetService("UserInputService")
local TweenService 	   = game:GetService("TweenService")
local HttpService	   = game:GetService("HttpService")
local RunService	   = game:GetService("RunService")
local Players		   = game:GetService("Players")

-- // Variables

local Spring = RunService:IsStudio() and require(workspace.spr) or loadstring(game:HttpGet("https://raw.githubusercontent.com/vFishyTurtle/WiiPrivate/refs/heads/main/spr"))()
local Player = Players.LocalPlayer

if Wii_Inputs then
	for _, v in Wii_Inputs do
		v:Disconnect()
	end
end
getgenv().Wii_Inputs = {}

-- // Make Folders \\ --

if not isfolder("WiiV2") then
	makefolder("WiiV2")
	makefolder("WiiV2//Configs")
end

if not isfolder("WiiV2//Configs") then
	makefolder("WiiV2//Configs")
end

-- //

function createInstance(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		if typeof(k) ~= 'string' then
			continue
		end

		instance[k] = v
	end
	return instance
end
	
local function Drag(UI)
	local InputPos
	local UIPos
	
	table.insert(Wii_Inputs, UI.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			InputPos = input.Position
			UIPos = UI.Position
		end
	end))
	
	table.insert(Wii_Inputs, UI.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			InputPos = nil
			UIPos = nil
		end
	end))
	
	table.insert(Wii_Inputs, UserInputService.InputChanged:Connect(function(input)
		if InputPos and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local Delta = input.Position - InputPos
			Spring.target(UI, 1, 7, {
				Position = UDim2.new(UIPos.X.Scale, UIPos.X.Offset + Delta.X, UIPos.Y.Scale, UIPos.Y.Offset + Delta.Y)
			})
		end
	end))
	
end

local ScreenGui = Instance.new("ScreenGui", RunService:IsStudio() and Player.PlayerGui or gethui())
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

table.insert(Wii_Inputs, UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.LeftControl and not gpe then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end))

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

task.spawn(function()
    if not UserInputService.TouchEnabled then
        return
    end

	local MobileGui = Instance.new("ScreenGui")
	MobileGui.Name = "MobileButton"
	MobileGui.ResetOnSpawn = false
	MobileGui.DisplayOrder = 1001
	MobileGui.Parent = gethui()

    local Button = Instance.new("TextButton")
    Button.Name = "HelloButton"
    Button.Size = UDim2.fromOffset(40, 40)
    Button.Position = UDim2.new(0.5, -20, 0, 12)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = "YON"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.Parent = MobileGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Button

    local dragging = false
    local dragStart
    local startPos
    local moved = false
    local activeTouch

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            activeTouch = input
            dragStart = input.Position
            startPos = Button.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == activeTouch then
            local delta = input.Position - dragStart

            if delta.Magnitude > 8 then
                moved = true
            end

            Button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == activeTouch then
            if not moved then
                ScreenGui.Enabled = not ScreenGui.Enabled
            end

            dragging = false
            activeTouch = nil
        end
    end)
end)

local Locked = true

function WiiUI:Unlock(val)
	if val == "kjsdkljnsdfkljng830812380245l.msdnhfg019735ksdg815" then
		Locked = false
	end
end

function WiiUI:Window()
	local Window = {}
	
	if Locked then
		return
	end

	if WiiLib then
		WiiLib:Destroy()
		getgenv().WiiLib = nil
	end
	
	local Main = createInstance("Frame", {
		Name = "Main",
		Position = UDim2.new(0.329, 0, 0.236, 0),
		Size = UDim2.new(0, 679, 0, 526),
		Parent = ScreenGui,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	getgenv().WiiLib = Main

	Drag(Main)
	
	local MainCorner = createInstance("UICorner", {
		Parent = Main,
		CornerRadius = UDim.new(0, 4)
	})

	local Title = createInstance("TextLabel", {
		Name = "Title",
		Position = UDim2.new(0, 13, 0, 0),
		Size = UDim2.new(0, 199, 0, 50),
		Parent = Main,
		BackgroundTransparency = 1,
		FontFace = WiiUI.Fonts.Bold,
		Text = 'Yon Private',
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 24,
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local Divider = createInstance("Frame", {
		Name = "Divider",
		Position = UDim2.new(0, 0, 0, 50),
		Size = UDim2.new(0, 679, 0, 1),
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(89, 83, 255),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local DivConstraint = createInstance("UISizeConstraint", {
		Parent = Divider,
		MaxSize = Vector2.new(math.huge, 1),
		MinSize = Vector2.new(0, 1)
	})
	
	local TabHolder = createInstance("Frame", {
		Name = "TabHolder",
		Position = UDim2.new(0, 13, 0, 51),
		Size = UDim2.new(1, -13, 0, 49),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local TabLayout = createInstance("UIListLayout", {
		Parent = TabHolder,
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	function Window:Tab(Title, Index)
		
		local TabSettings = {
			Enabled = false
		}
		
		table.insert(WiiUI.Tabs, TabSettings)
		
		local Tab = createInstance("ImageButton", {
			Name = "Tab",
			Position = UDim2.new(0.019, 0, 0.124, 0),
			Size = UDim2.new(0, 0, 0, 27),
			Parent = TabHolder,
			BackgroundTransparency = 0.5,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(89, 83, 255),
			BorderSizePixel = 0,
			LayoutOrder = Index or 0,
			AutoButtonColor = false,
			ZIndex = 1
		})

		local TabCorner = createInstance("UICorner", {
			Parent = Tab,
			CornerRadius = UDim.new(0, 4)
		})

		local TabTitle = createInstance("TextLabel", {
			Name = "TabTitle",
			Position = UDim2.new(0, 0, 0.500, 0),
			Size = UDim2.new(0, 0, 0, 17),
			Parent = Tab,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			FontFace = WiiUI.Fonts.Bold,
			Text = Title,
			AutomaticSize = Enum.AutomaticSize.X,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Color3.fromRGB(225, 225, 225),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 15,
			BorderSizePixel = 0,
			ZIndex = 1
		})

		local TabPadding = createInstance("UIPadding", {
			Parent = Tab,
			PaddingLeft = UDim.new(0, 7),
			PaddingRight = UDim.new(0, 7)
		})
		
		local Canvas = createInstance("ScrollingFrame", {
			Name = "Canvas",
			Position = UDim2.new(0, 13, 0, 100),
			Size = UDim2.new(1, -13, 1, -100),
			Parent = Main,
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ClipsDescendants = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Color3.fromRGB(89, 83, 255),
			Visible = false,
			ZIndex = 1
		})
		
		local UIListLayout = createInstance("UIListLayout", {
			Parent = Canvas,
			Padding = UDim.new(0, 5),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		function TabSettings:Set(Enabled)
			
			Spring.target(Tab, 1, 3, {
				BackgroundTransparency = Enabled and 0 or .5,
			})
			
			Spring.target(TabTitle, 1, 3, {
				TextColor3 = Enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(225, 225, 225)
			})
			
			Canvas.Visible 		=  Enabled
			TabSettings.Enabled = Enabled
		end
		
		table.insert(Wii_Inputs, Tab.MouseButton1Down:Connect(function()
			for _, v in WiiUI.Tabs do
				if v.Enabled then
					v:Set(false)
				end
			end
			TabSettings:Set(true)
		end))
		
		if #WiiUI.Tabs == 2 then
			TabSettings:Set(true)
		end
		
		function TabSettings:Toggle(Title, Options)
			
			local Settings = {
				Type = "Toggle",
				Name = Title,
				Value = Options.Default or false,
				Callback = Options.Callback or function() end
			}
			
			WiiUI.Flags[Title] = Settings

			local Toggle = createInstance("ImageButton", {
				Name = "Toggle",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 150, 0, 26),
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ZIndex = 1
			})

			local TpggleTitle = createInstance("TextLabel", {
				Name = "TpggleTitle",
				Position = UDim2.new(0, 38, 0.500, 0),
				Size = UDim2.new(0, 0, 0, 17),
				Parent = Toggle,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local CheckBox = createInstance("Frame", {
				Name = "CheckBox",
				Position = UDim2.new(0, 0, 0.500, 0),
				Size = UDim2.new(0, 23, 0, 23),
				Parent = Toggle,
				BackgroundTransparency = 0.7,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local BoxCorner = createInstance("UICorner", {
				Parent = CheckBox,
				CornerRadius = UDim.new(0, 4)
			})

			local BoxStroke = createInstance("UIStroke", {
				Parent = CheckBox,
				Color = Color3.fromRGB(89, 83, 255),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Round,
				Transparency = 0
			})

			local StrokeGrad = createInstance("UIGradient", {
				Parent = BoxStroke,
				Rotation = -125,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				}),
				Offset = Vector2.new(1, 1)
			})

			local Check = createInstance("ImageLabel", {
				Name = "Check",
				Position = UDim2.new(0.500, 0, 0.500, 0),
				Size = UDim2.new(0, 17, 0, 17),
				Parent = CheckBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "rbxassetid://10709790644",
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Toggle_Padding = createInstance("UIPadding", {
				Parent = Toggle,
				PaddingLeft = UDim.new(0, 1)
			})
			
			function Settings:Set(Value)
				Spring.target(Check, 1, 3, {
					ImageTransparency = Value and 0 or 1
				})
				Spring.target(CheckBox, 1, 3, {
					BackgroundTransparency = Value and 0.5 or 0.7
				})
				Spring.target(StrokeGrad, 1, 3, {
					Offset = Value and Vector2.new(-1, -1) or Vector2.new(1, 1)
				})
				Spring.target(TpggleTitle, 1, 3, {
					TextColor3 = Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(215, 215, 215)
				})
				
				Settings.Callback(Value)
				Settings.Value = Value
			end
			
			table.insert(Wii_Inputs, Toggle.MouseButton1Down:Connect(function()
				Settings:Set(not Settings.Value)
			end))
			
			Settings:Set(Settings.Value)
			
			return Settings
		end
		
		function TabSettings:Bind(Title, Options)

			local Settings = {
				Type = "Keybind",
				Name = Title,
				Value = Options.Default or 'None',
				Callback = Options.Callback or function() end
			}

			WiiUI.Flags[Title] = Settings

			local Keybind = createInstance("Frame", {
				Name = "Keybind",
				Position = UDim2.new(0.000, 0.000, 0.309, 0.000),
				Size = UDim2.new(0.000, 319.000, 0.000, 26.000),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local BindTitle = createInstance("TextLabel", {
				Name = "BindTitle",
				Position = UDim2.new(0.000, 1.000, 0.500, 0.000),
				Size = UDim2.new(0.000, 0.000, 0.000, 17.000),
				Parent = Keybind,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local KeyBox = createInstance("Frame", {
				Name = "KeyBox",
				Position = UDim2.new(1.000, 0.000, 0.500, 0.000),
				Size = UDim2.new(0.000, 1.000, 0.000, 23.000),
				Parent = Keybind,
				BackgroundTransparency = 0.5,
				AnchorPoint = Vector2.new(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local BoxCorner = createInstance("UICorner", {
				Parent = KeyBox,
				CornerRadius = UDim.new(0, 4)
			})

			local BoxStroke = createInstance("UIStroke", {
				Parent = KeyBox,
				Color = Color3.fromRGB(89, 83, 255),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Round,
				Transparency = 0
			})

			local StrokeGrad = createInstance("UIGradient", {
				Parent = BoxStroke,
				Rotation = -125,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				}),
				Offset = Vector2.new(1, 1)
			})

			local SelectedBind = createInstance("TextLabel", {
				Name = "SelectedBind",
				Position = UDim2.new(0.000, 0.000, 0.500, 0.000),
				Size = UDim2.new(0.000, 1.000, 1.000, 0.000),
				Parent = KeyBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Settings.Value,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 15,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			createInstance("UIPadding", {
				Parent = KeyBox,
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6)
			})

			createInstance("UIPadding", {
				Parent = Keybind,
				PaddingLeft = UDim.new(0, 1)
			})

			local TouchArea = createInstance("ImageButton", {
				Name = "TouchArea",
				Position = UDim2.new(0.503, 0.000, 0.000, 0.000),
				Size = UDim2.new(0.000, 158.000, 0.000, 26.000),
				Parent = Keybind,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Listening = false
			function Settings:Set(Value: string)
				Listening = false
				Settings.Value = Value
				SelectedBind.Text = Value
				Spring.target(StrokeGrad, 1, 3, {
					Offset = Vector2.new(1, 1)
				})
			end

			table.insert(Wii_Inputs, TouchArea.MouseButton1Down:Connect(function()
				Listening = true
				Spring.target(StrokeGrad, 1, 3, {
					Offset = Vector2.new(-1, -1)
				})
			end))

			table.insert(Wii_Inputs, UserInputService.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				local Type = input.UserInputType
				if Type == Enum.UserInputType.Keyboard or Type == Enum.UserInputType.Gamepad1 then
					local Key = tostring(input.KeyCode)
					Key = Key:gsub("Enum.KeyCode.", "")

					if Listening then
						if Key == "Backspace" then
							Settings:Set("None")
							return
						end
						Settings:Set(Key)
					elseif Key == Settings.Value then
						Settings.Callback(Key)
					end
				elseif Type == Enum.UserInputType.MouseButton1 or Type == Enum.UserInputType.MouseButton2 or Type == Enum.UserInputType.MouseButton3 then
					Type = tostring(Type):gsub("Enum.UserInputType", "")
					if Listening then
						Settings:Set(Type)
					elseif Type == Settings.Value then
						Settings.Callback(Type)
					end
				end
			end))
		end

		function TabSettings:Slider(Title, Options)
			
			local Settings = {
				Type 	 = "Slider",
				Name 	 = Title,
				Min 	 = Options.Min or 0,
				Max		 = Options.Max or 100,
				Step 	 = Options.Step or 1,
				Value 	 = Options.Default or 0,
				Callback = Options.Callback or function() end
			}
			
			WiiUI.Flags[Title] = Settings

			local Slider = createInstance("ImageButton", {
				Name = "Slider",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ZIndex = 1
			})

			createInstance("UIListLayout", {
				Parent = Slider,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local Top = createInstance("Frame", {
				Name = "Top",
				Position = UDim2.new(0.616, 0, 0.154, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Slider,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			createInstance("UIListLayout", {
				Parent = Top,
				Padding = UDim.new(0, 20),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local SliderVal = createInstance("TextBox", {
				Name = "Top",
				Position = UDim2.new(0.318, 1, 0.500, 0),
				Size = UDim2.new(0, 35, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = tostring(Settings.Value),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				PlaceholderText = '',
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				LayoutOrder = 1,
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local SliderTitle = createInstance("TextLabel", {
				Name = "SliderTitle",
				Position = UDim2.new(0, 1, 0.327, 0),
				Size = UDim2.new(0, 105, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Bottom = createInstance("Frame", {
				Name = "Bottom",
				Position = UDim2.new(0.616, 0, 0.154, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Slider,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			createInstance("UIListLayout", {
				Parent = Bottom,
				Padding = UDim.new(0, 20),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local SliderBack = createInstance("Frame", {
				Name = "SliderBack",
				Position = UDim2.new(0, 0, 0.058, 0),
				Size = UDim2.new(0, 317, 0, 23),
				Parent = Bottom,
				BackgroundTransparency = 0.6499999761581421,
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local SliderMain = createInstance("Frame", {
				Name = "SliderMain",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 235, 0, 23),
				Parent = SliderBack,
				BackgroundTransparency = 0.65,
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local SliderPad = createInstance("UIPadding", {
				Parent = Slider,
				PaddingLeft = UDim.new(0, 1)
			})
			
			function Settings:Visible(Value)
				Slider.Visible = Value
			end
			
			table.insert(Wii_Inputs, SliderVal.FocusLost:Connect(function()
				local toNum; pcall(function() toNum = tonumber(SliderVal.Text) end)
				if toNum then
					Settings:Set(math.clamp(SliderVal.Text, Settings.Min, Settings.Max))
				else
					SliderVal.Text = tostring(Settings.Value)
				end
			end))

			local PercentVal = Settings.Value

			if math.abs(Settings.Min) ~= Settings.Min then
				PercentVal = Settings.Value + math.abs(Settings.Min)
			elseif Settings.Min ~= 0 then
				PercentVal = Settings.Value - math.abs(Settings.Min)
			end

			local Percent = (PercentVal/(Settings.Max-Settings.Min));

			local decimalPlaces = 0

			if Settings.Step < 1 then
				decimalPlaces = string.match(tostring(Settings.Step), "%.(%d+)") and #string.match(tostring(Settings.Step), "%.(%d+)") or 0
			end

			local Connection;
			table.insert(Wii_Inputs, UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if(Connection) then
						Connection:Disconnect();
						Connection = nil;
					end;
				end;
			end))

			function Settings:Set(Value)
				if math.abs(Settings.Min) ~= Settings.Min then
					Value = Value + math.abs(Settings.Min)
				elseif Settings.Min ~= 0 then
					Value = Value - math.abs(Settings.Min)
				end

				local Percent = (Value/(Settings.Max-Settings.Min));
				local Steps = (Settings.Max - Settings.Min) / Settings.Step
				local NearestStep = math.floor(Percent * Steps + 0.5) / Steps

				Settings.Value = Settings.Min + (Settings.Max - Settings.Min) * NearestStep

				Spring.target(SliderMain, 1, 6, {
					Size = UDim2.fromScale(NearestStep, 1)
				})

				local decimalPlaces = 0
				if Settings.Step < 1 then
					decimalPlaces = string.match(tostring(Settings.Step), "%.(%d+)") and #string.match(tostring(Settings.Step), "%.(%d+)") or 0
				end

				Settings.Value = tonumber(string.format("%.2f", Settings.Value))
				if Settings.Value == math.floor(Settings.Value) then
					SliderVal.Text = tostring(Settings.Value)
				else
					SliderVal.Text = string.format("%."..decimalPlaces.."f", Settings.Value)
				end

				pcall(Settings.Callback, Settings.Value) 
			end

			Settings:Set(Settings.Value)

			table.insert(Wii_Inputs, Slider.MouseButton1Down:Connect(function()
				if(Connection) then
					Connection:Disconnect();
				end;

				Connection = RunService.Heartbeat:Connect(function()
					local Mouse = UserInputService:GetMouseLocation();
					Percent = math.clamp((Mouse.X - SliderBack.AbsolutePosition.X) / (SliderBack.AbsoluteSize.X), 0, 1);

					local Steps = (Settings.Max - Settings.Min) / Settings.Step
					local NearestStep = math.floor(Percent * Steps + 0.5) / Steps

					Settings.Value = Settings.Min + (Settings.Max - Settings.Min) * NearestStep

					Settings:Set(Settings.Value)
				end)
			end))
			return Settings
		end
		
		function TabSettings:Dropdown(Title, Options)
			local Settings = {
				Type = "Dropdown",
				Name = Title,
				Value = Options.Default or "None",
				List = Options.List or {},
				Callback = Options.Callback or function() end,
			}
			
			WiiUI.Flags[Title] = Settings

			local Dropdown = createInstance("ImageButton", {
				Name = "Dropdown",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ZIndex = 1
			})

			local Top = createInstance("Frame", {
				Name = "Top",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Dropdown,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local DropdownTitle = createInstance("TextLabel", {
				Name = "DropdownTitle",
				Position = UDim2.new(0, 1, 0.500, 0),
				Size = UDim2.new(0, 105, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Bottom = createInstance("Frame", {
				Name = "Bottom",
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Dropdown,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local BottomLayout = createInstance("UIListLayout", {
				Parent = Bottom,
				Padding = UDim.new(0, 20),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local DropdownBG = createInstance("Frame", {
				Name = "DropdownBG",
				Position = UDim2.new(0, 0, 0.058, 0),
				Size = UDim2.new(0, 264, 0, 23),
				Parent = Bottom,
				BackgroundTransparency = 0.6499999761581421,
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Arrow = createInstance("ImageLabel", {
				Name = "Arrow",
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 23, 0, 23),
				Parent = DropdownBG,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "rbxassetid://6034818372",
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local ValueText = createInstance("TextLabel", {
				Name = "ValueText",
				Position = UDim2.new(0, 10, 0.500, 0),
				Size = UDim2.new(0, 0, 0, 17),
				Parent = DropdownBG,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Settings.Value,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 15,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local DropdownPad = createInstance("UIPadding", {
				Parent = Dropdown,
				PaddingLeft = UDim.new(0, 1)
			})

			local OptionHolder = createInstance("ScrollingFrame", {
				Name = "OptionHolder",
				Position = UDim2.new(-0.003, 0, 1.096, 0),
				Size = UDim2.new(0, 265, 0, 78),
				Parent = Dropdown,
				Visible = false,
				ScrollBarThickness = 0,
				ClipsDescendants = true,
				BackgroundColor3 = Color3.fromRGB(15, 14, 44),
				BorderSizePixel = 0,
				ZIndex = 5
			})
			
			local OptionLayout = createInstance("UIListLayout", {
				Parent = OptionHolder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			local Opened = false
			
			function Settings:Open()
				OptionHolder.Visible = true
				
				for _, v in OptionHolder:GetChildren() do
					if v:IsA("UIListLayout") then
						continue
					end
					v:Destroy()	
				end

				local List

				if typeof(Settings.List) == "function" then
					List = Settings.List()
				else
					List = Settings.List
				end

				for i, v in List do
					local Option = createInstance("ImageButton", {
						Name = "Option",
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 0, 22),
						Parent = OptionHolder,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(74, 69, 213),
						BorderSizePixel = 0,
						AutoButtonColor = false,
						ZIndex = 6
					})

					local OptionText = createInstance("TextLabel", {
						Name = "OptionText",
						Position = UDim2.new(0.004, 10, 0.500, 0),
						Size = UDim2.new(0, 254, 0, 17),
						Parent = Option,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						FontFace = WiiUI.Fonts.SemiBold,
						Text = v,
						AutomaticSize = Enum.AutomaticSize.X,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(215, 215, 215),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 15,
						BorderSizePixel = 0,
						ZIndex = 7
					})

					local CanHover = true

					table.insert(Wii_Inputs, Option.MouseButton1Down:Connect(function()
						CanHover = false
						Option.BackgroundTransparency = 0.5
						Settings.Callback(v)
						ValueText.Text = v
						Settings.Value = v
						local Tween = TweenService:Create(OptionHolder, TweenInfo.new(0.15), {Size = UDim2.fromOffset(265, 0)})
						Tween.Completed:Connect(function()
							Opened = false
							OptionHolder.Visible = false
						end)
						Tween:Play()
					end))

					table.insert(Wii_Inputs, Option.MouseEnter:Connect(function()
						if not CanHover then return end
						Option.BackgroundTransparency = 0.5
					end))

					table.insert(Wii_Inputs, Option.MouseLeave:Connect(function()
						if not CanHover then return end
						Option.BackgroundTransparency = 1
					end))

					TweenService:Create(OptionHolder, TweenInfo.new(0.15), {Size = UDim2.fromOffset(265, 78)}):Play()
				end
			end
				
			function Settings:Set(Value)
				Settings.Callback(Value)
				Settings.Value = Value
				ValueText.Text = Value
			end
			
			Settings.Callback(Settings.Value)
			
			table.insert(Wii_Inputs, Dropdown.MouseButton1Down:Connect(function()
				if Opened then
					TweenService:Create(OptionHolder, TweenInfo.new(0.15), {Size = UDim2.fromOffset(265, 0)}):Play()
				else
					Settings:Open()
				end
				Opened = not Opened
			end))

			return Settings
		end
		
		function TabSettings:Textbox(Title, Options)
			local Settings = {
				Callback = Options.Callback or function() end,
			}
			
			local TextBox = createInstance("Frame", {
				Name = "TextBox",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Top = createInstance("Frame", {
				Name = "Top",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = TextBox,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local TextboxTitle = createInstance("TextLabel", {
				Name = "TextboxTitle",
				Position = UDim2.new(0, 1, 0.500, 0),
				Size = UDim2.new(0, 105, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Bottom = createInstance("Frame", {
				Name = "Bottom",
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = TextBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local BottomLayout = createInstance("UIListLayout", {
				Parent = Bottom,
				Padding = UDim.new(0, 20),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local TextboxBackground = createInstance("Frame", {
				Name = "TextboxBackground",
				Position = UDim2.new(0, 0, 0.058, 0),
				Size = UDim2.new(0, 264, 0, 23),
				Parent = Bottom,
				BackgroundTransparency = 0.65,
				BackgroundColor3 = Color3.fromRGB(89, 83, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Icon = createInstance("ImageLabel", {
				Name = "Icon",
				Position = UDim2.new(0.985, 0, 0.500, 0),
				Size = UDim2.new(0, 16, 0, 16),
				Parent = TextboxBackground,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "rbxassetid://108341418673566",
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local ValueText = createInstance("TextBox", {
				Name = "TextboxBackground",
				Position = UDim2.new(0, 10, 0.500, 0),
				Size = UDim2.new(0, 214, 0, 17),
				Parent = TextboxBackground,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = '',
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(215, 215, 215),
				PlaceholderText = 'Enter Text',
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClearTextOnFocus = false,
				TextSize = 15,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local TextboxPad = createInstance("UIPadding", {
				Parent = TextBox,
				PaddingLeft = UDim.new(0, 1)
			})
			
			table.insert(Wii_Inputs, ValueText.FocusLost:Connect(function()
				Settings.Callback(ValueText.Text)
			end))

			return Settings
		end
		
		function TabSettings:ButtonList()
			local Settings = {}
			
			local ButtonList = createInstance("Frame", {
				Name = "ButtonList",
				Position = UDim2.new(0, 0, 0.279, 0),
				Size = UDim2.new(0, 265, 0, 26),
				Parent = Canvas,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})
			
			local ListPad = createInstance("UIPadding", {
				Parent = ButtonList,
				PaddingLeft = UDim.new(0, 1)
			})

			local UIListLayout = createInstance("UIListLayout", {
				Parent = ButtonList,
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function Settings:Button(Title, Options)
				local ButtonSettings = {
					Callback = Options.Callback or function() end
				}
				
				local Button = createInstance("ImageButton", {
					Name = "Button",
					Position = UDim2.new(0, 0, 0.500, 0),
					Size = UDim2.new(0, 127, 0, 23),
					Parent = ButtonList,
					BackgroundTransparency = 0.5,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Color3.fromRGB(89, 83, 255),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 1
				})

				local BoxCorner = createInstance("UICorner", {
					Parent = Button,
					CornerRadius = UDim.new(0, 4)
				})

				local ButtonTitle = createInstance("TextLabel", {
					Name = "ButtonTitle",
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Parent = Button,
					BackgroundTransparency = 1,
					FontFace = WiiUI.Fonts.SemiBold,
					Text = Title,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(215, 215, 215),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 15,
					BorderSizePixel = 0,
					ZIndex = 1
				})
				
				table.insert(Wii_Inputs, Button.MouseButton1Down:Connect(function()
					ButtonSettings.Callback()
					Spring.stop(Button); Spring.stop(ButtonTitle)
					Spring.target(Button, 1, 3, {
						BackgroundTransparency = .2
					})
					Spring.target(ButtonTitle, 1, 3, {
						TextColor3 = Color3.fromRGB(255, 255, 255)
					})
				end))
				
				table.insert(Wii_Inputs, Button.MouseButton1Up:Connect(function()
					Spring.stop(Button); Spring.stop(ButtonTitle)
					Spring.target(Button, 1, 3, {
						BackgroundTransparency = .5
					})
					Spring.target(ButtonTitle, 1, 3, {
						TextColor3 = Color3.fromRGB(215, 215, 215)
					})
				end))
				
				return ButtonSettings
			end
			
			return Settings
		end
		
		function TabSettings:Divider()
			
			local Divider = {}
			
			local DivHolder = createInstance("Frame", {
				Name = "DivHolder",
				Position = UDim2.new(0, 0, 0.113, 0),
				Size = UDim2.new(0.7, 0, 0, 25),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Div = createInstance("Frame", {
				Name = "Div",
				Position = UDim2.new(1, 0, 0.500, 0),
				Size = UDim2.new(1, 0, 0, 1),
				Parent = DivHolder,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local DivConstraint = createInstance("UISizeConstraint", {
				Parent = Div,
				MaxSize = Vector2.new(math.huge, 1),
				MinSize = Vector2.new(0, 1)
			})

			return Divider
		end
		
		return TabSettings
	end
	
	return Window
end

return WiiUI
