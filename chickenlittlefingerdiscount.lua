local WiiUI = {

	Tabs  = {},
	Flags = {},

	Fonts = {
		Bold	 = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		Medium	 = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Regular  = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	},

	-- Every colour in the UI comes from here, so you can re-theme in one place
	Theme = {
		Accent      = Color3.fromRGB(89, 83, 255),
		AccentLight = Color3.fromRGB(140, 135, 255),
		AccentDark  = Color3.fromRGB(62, 57, 205),
		Surface     = Color3.fromRGB(20, 19, 36),
		SurfaceHigh = Color3.fromRGB(30, 29, 54),
		Outline     = Color3.fromRGB(56, 54, 104),
		Text        = Color3.fromRGB(255, 255, 255),
		TextDim     = Color3.fromRGB(215, 215, 215),
		TextMuted   = Color3.fromRGB(158, 158, 184)
	}
}

-- // Services

local UserInputService = game:GetService("UserInputService")
local TweenService 	   = game:GetService("TweenService")
local HttpService	   = game:GetService("HttpService")
local RunService	   = game:GetService("RunService")
local Players		   = game:GetService("Players")

-- // Variables

local Spring = RunService:IsStudio() and require(workspace.spr) or loadstring(game:HttpGet("https://raw.githubusercontent.com/Forexium/Yon/refs/heads/main/Hoax.luau"))()
local Player = Players.LocalPlayer
local Mouse  = Player:GetMouse()
local Theme  = WiiUI.Theme

local White = Color3.fromRGB(255, 255, 255)

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

-- // Helpers \\ --

local function createInstance(className, properties)
	local instance = Instance.new(className)
	local parent = properties.Parent

	for k, v in pairs(properties) do
		if typeof(k) ~= "string" or k == "Parent" then
			continue
		end

		instance[k] = v
	end

	instance.Parent = parent
	return instance
end

local function addCorner(parent, radius)
	return createInstance("UICorner", {
		Parent = parent,
		CornerRadius = UDim.new(0, radius)
	})
end

local function addStroke(parent, color, transparency, thickness)
	return createInstance("UIStroke", {
		Parent = parent,
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		LineJoinMode = Enum.LineJoinMode.Round,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
end

local function addGradient(parent, from, to, rotation, transparency)
	return createInstance("UIGradient", {
		Parent = parent,
		Rotation = rotation or 0,
		Color = ColorSequence.new(from, to),
		Transparency = transparency or NumberSequence.new(0)
	})
end

-- Soft drop shadow made from stacked, expanding rounded frames (no image assets needed)
local function addShadow(parent, radius, layers, spread, yOffset)
	local Holder = createInstance("Frame", {
		Name = "Shadow",
		Parent = parent,
		Position = UDim2.fromOffset(0, yOffset or 4),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 0
	})

	for i = layers, 1, -1 do
		local Grow = i * spread
		local Layer = createInstance("Frame", {
			Name = "Layer",
			Parent = Holder,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, Grow * 2, 1, Grow * 2),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.935,
			BorderSizePixel = 0,
			ZIndex = 0
		})
		addCorner(Layer, radius + Grow)
	end

	return Holder
end

-- Click ripple, clipped to the button's rounded corners
local function Ripple(Button, Color)
	local Clip = Button:FindFirstChild("RippleClip")

	if not Clip then
		Clip = createInstance("CanvasGroup", {
			Name = "RippleClip",
			Parent = Button,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2
		})
		addCorner(Clip, 4)
	end

	local X = math.clamp(Mouse.X - Button.AbsolutePosition.X, 0, Button.AbsoluteSize.X)
	local Y = math.clamp(Mouse.Y - Button.AbsolutePosition.Y, 0, Button.AbsoluteSize.Y)
	local Diameter = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2.4

	local Circle = createInstance("Frame", {
		Name = "Ripple",
		Parent = Clip,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(X, Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Color or White,
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		ZIndex = 2
	})
	addCorner(Circle, 999)

	TweenService:Create(Circle, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(Diameter, Diameter),
		BackgroundTransparency = 1
	}):Play()

	task.delay(0.6, function()
		Circle:Destroy()
	end)
end

local function CleanEnum(item)
	return (tostring(item):gsub("^Enum%.%a+%.", ""))
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
		if InputPos and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = input.Position - InputPos
			Spring.target(UI, 1, 7, {
				Position = UDim2.new(UIPos.X.Scale, UIPos.X.Offset + Delta.X, UIPos.Y.Scale, UIPos.Y.Offset + Delta.Y)
			})
		end
	end))

end

-- // Root GUI \\ --

local Container = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or gethui()

local OldGui = Container:FindFirstChild("WiiUI")
if OldGui then
	OldGui:Destroy()
end

local ScreenGui = createInstance("ScreenGui", {
	Name = "WiiUI",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	Parent = Container
})

-- Show / hide with a small scale animation
local MainScale
local UIVisible = true

function WiiUI:ToggleVisibility(State)
	if State == nil then
		State = not UIVisible
	end
	UIVisible = State

	if State then
		ScreenGui.Enabled = true
		if MainScale then
			Spring.target(MainScale, 0.75, 9, { Scale = 1 })
		end
	elseif MainScale then
		Spring.target(MainScale, 1, 12, { Scale = 0.92 })
		task.delay(0.14, function()
			if not UIVisible then
				ScreenGui.Enabled = false
			end
		end)
	else
		ScreenGui.Enabled = false
	end
end

table.insert(Wii_Inputs, UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.LeftControl and not gpe then
		WiiUI:ToggleVisibility()
	end
end))

-- // Mobile toggle button \\ --

task.spawn(function()
	if not UserInputService.TouchEnabled then
		return
	end

	local OldMobile = Container:FindFirstChild("MobileButton")
	if OldMobile then
		OldMobile:Destroy()
	end

	local MobileGui = createInstance("ScreenGui", {
		Name = "MobileButton",
		ResetOnSpawn = false,
		DisplayOrder = 1001,
		Parent = Container
	})

	local Button = createInstance("TextButton", {
		Name = "HelloButton",
		Size = UDim2.fromOffset(40, 40),
		Position = UDim2.new(0.5, -20, 0, 12),
		BackgroundColor3 = Theme.Accent,
		AutoButtonColor = false,
		Text = "YON",
		TextColor3 = Theme.Text,
		TextSize = 16,
		FontFace = WiiUI.Fonts.Bold,
		BorderSizePixel = 0,
		Parent = MobileGui
	})

	addCorner(Button, 20)
	addStroke(Button, Theme.AccentLight, 0.25, 1)
	addGradient(Button, White, Color3.fromRGB(170, 168, 235), 90)
	addShadow(Button, 20, 4, 3, 3)

	local dragging = false
	local dragStart
	local startPos
	local moved = false
	local activeTouch

	table.insert(Wii_Inputs, Button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			activeTouch = input
			dragStart = input.Position
			startPos = Button.Position
		end
	end))

	table.insert(Wii_Inputs, UserInputService.InputChanged:Connect(function(input)
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
	end))

	table.insert(Wii_Inputs, UserInputService.InputEnded:Connect(function(input)
		if input == activeTouch then
			if not moved then
				WiiUI:ToggleVisibility()
			end

			dragging = false
			activeTouch = nil
		end
	end))
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

	-- Anchored at the centre so the show/hide scale animation grows from the middle.
	-- The offsets (+340, +263) put the window exactly where the old top-left position did.
	local Main = createInstance("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.329, 340, 0.236, 263),
		Size = UDim2.new(0, 679, 0, 526),
		Parent = ScreenGui,
		BackgroundColor3 = White,
		BorderSizePixel = 0,
		ZIndex = 1
	})

	getgenv().WiiLib = Main

	Drag(Main)

	MainScale = createInstance("UIScale", {
		Parent = Main,
		Scale = UIVisible and 1 or 0.92
	})

	addCorner(Main, 8)
	addShadow(Main, 8, 7, 4, 6)

	-- Deep background with a faint purple lift at the top
	addGradient(Main, Color3.fromRGB(22, 21, 42), Color3.fromRGB(8, 8, 13), 90)

	-- Slowly rotating accent sheen around the window edge
	local MainStroke = addStroke(Main, White, 0, 1)
	local MainStrokeGrad = createInstance("UIGradient", {
		Parent = MainStroke,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.AccentLight),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(48, 46, 92)),
			ColorSequenceKeypoint.new(1, Theme.AccentLight)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.1),
			NumberSequenceKeypoint.new(0.5, 0.7),
			NumberSequenceKeypoint.new(1, 0.1)
		})
	})

	local Sheen
	Sheen = RunService.Heartbeat:Connect(function()
		if ScreenGui.Enabled then
			MainStrokeGrad.Rotation = (os.clock() * 40) % 360
		end
	end)
	table.insert(Wii_Inputs, Sheen)
	Main.Destroying:Connect(function()
		Sheen:Disconnect()
	end)

	-- Header band (fades out downward)
	local Header = createInstance("Frame", {
		Name = "Header",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 50),
		Parent = Main,
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 1
	})
	addCorner(Header, 8)
	addGradient(Header, White, White, 90, NumberSequence.new(0.84, 1))

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
		TextColor3 = Theme.Text,
		BackgroundColor3 = White,
		TextSize = 24,
		BorderSizePixel = 0,
		ZIndex = 1
	})

	addGradient(Title, White, Color3.fromRGB(176, 172, 255), 0)

	-- Small hint on the right of the header (desktop only)
	if not UserInputService.TouchEnabled then
		local Hint = createInstance("Frame", {
			Name = "Hint",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -13, 0, 25),
			Size = UDim2.new(0, 0, 0, 22),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = Main,
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			ZIndex = 1
		})

		addCorner(Hint, 11)
		addStroke(Hint, Theme.Outline, 0.35, 1)

		createInstance("UIPadding", {
			Parent = Hint,
			PaddingLeft = UDim.new(0, 9),
			PaddingRight = UDim.new(0, 10)
		})

		createInstance("UIListLayout", {
			Parent = Hint,
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local Dot = createInstance("Frame", {
			Name = "Dot",
			Size = UDim2.fromOffset(6, 6),
			Parent = Hint,
			BackgroundColor3 = Theme.AccentLight,
			BorderSizePixel = 0,
			LayoutOrder = 0,
			ZIndex = 1
		})
		addCorner(Dot, 3)

		TweenService:Create(Dot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			BackgroundTransparency = 0.7
		}):Play()

		createInstance("TextLabel", {
			Name = "HintText",
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = Hint,
			BackgroundTransparency = 1,
			FontFace = WiiUI.Fonts.Medium,
			Text = "Left Ctrl toggles the menu",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextMuted,
			TextSize = 13,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			ZIndex = 1
		})
	end

	local Divider = createInstance("Frame", {
		Name = "Divider",
		Position = UDim2.new(0, 0, 0, 50),
		Size = UDim2.new(0, 679, 0, 1),
		Parent = Main,
		BackgroundColor3 = White,
		BorderSizePixel = 0,
		ZIndex = 1
	})

	local DivConstraint = createInstance("UISizeConstraint", {
		Parent = Divider,
		MaxSize = Vector2.new(math.huge, 1),
		MinSize = Vector2.new(0, 1)
	})

	createInstance("UIGradient", {
		Parent = Divider,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.AccentLight),
			ColorSequenceKeypoint.new(0.5, Theme.Accent),
			ColorSequenceKeypoint.new(1, Theme.AccentDark)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(0.6, 0.35),
			NumberSequenceKeypoint.new(1, 0.9)
		})
	})

	-- Soft glow just under the divider
	local DivGlow = createInstance("Frame", {
		Name = "DivGlow",
		Position = UDim2.new(0, 0, 0, 51),
		Size = UDim2.new(1, 0, 0, 16),
		Parent = Main,
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 1
	})
	addGradient(DivGlow, White, White, 90, NumberSequence.new(0.9, 1))

	local TabHolder = createInstance("Frame", {
		Name = "TabHolder",
		Position = UDim2.new(0, 13, 0, 51),
		Size = UDim2.new(1, -13, 0, 49),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = White,
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
			BackgroundTransparency = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			LayoutOrder = Index or 0,
			AutoButtonColor = false,
			ZIndex = 1
		})

		addCorner(Tab, 6)
		addGradient(Tab, White, Color3.fromRGB(186, 186, 226), 90)

		local TabStroke = addStroke(Tab, Theme.Outline, 0.35, 1)

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
			TextColor3 = Theme.TextMuted,
			BackgroundColor3 = White,
			TextSize = 15,
			BorderSizePixel = 0,
			ZIndex = 1
		})

		local TabPadding = createInstance("UIPadding", {
			Parent = Tab,
			PaddingLeft = UDim.new(0, 9),
			PaddingRight = UDim.new(0, 9)
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
			BackgroundColor3 = White,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Theme.Accent,
			ScrollBarImageTransparency = 0.25,
			Visible = false,
			ZIndex = 1
		})

		-- Content slides up into place when a tab opens
		local CanvasPad = createInstance("UIPadding", {
			Parent = Canvas,
			PaddingTop = UDim.new(0, 0)
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
				BackgroundColor3 = Enabled and Theme.Accent or Theme.Surface,
			})

			Spring.target(TabStroke, 1, 3, {
				Color = Enabled and Theme.AccentLight or Theme.Outline,
				Transparency = Enabled and 0.1 or 0.35
			})

			Spring.target(TabTitle, 1, 3, {
				TextColor3 = Enabled and Theme.Text or Theme.TextMuted
			})

			if Enabled and not TabSettings.Enabled then
				CanvasPad.PaddingTop = UDim.new(0, 10)
				TweenService:Create(CanvasPad, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					PaddingTop = UDim.new(0, 0)
				}):Play()
			end

			Canvas.Visible 		=  Enabled
			TabSettings.Enabled = Enabled
		end

		table.insert(Wii_Inputs, Tab.MouseEnter:Connect(function()
			if TabSettings.Enabled then return end
			Spring.target(Tab, 1, 4, { BackgroundColor3 = Theme.SurfaceHigh })
			Spring.target(TabTitle, 1, 4, { TextColor3 = Theme.TextDim })
			Spring.target(TabStroke, 1, 4, { Color = Theme.Accent })
		end))

		table.insert(Wii_Inputs, Tab.MouseLeave:Connect(function()
			if TabSettings.Enabled then return end
			Spring.target(Tab, 1, 4, { BackgroundColor3 = Theme.Surface })
			Spring.target(TabTitle, 1, 4, { TextColor3 = Theme.TextMuted })
			Spring.target(TabStroke, 1, 4, { Color = Theme.Outline })
		end))

		table.insert(Wii_Inputs, Tab.MouseButton1Down:Connect(function()
			if TabSettings.Enabled then return end

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
			Options = Options or {}

			local Settings = {
				Type = "Toggle",
				Name = Title,
				Value = Options.Default or false,
				Callback = Options.Callback or function() end
			}

			WiiUI.Flags[Title] = Settings

			local Hovering = false

			local Toggle = createInstance("ImageButton", {
				Name = "Toggle",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 150, 0, 26),
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local CheckBox = createInstance("Frame", {
				Name = "CheckBox",
				Position = UDim2.new(0, 0, 0.500, 0),
				Size = UDim2.new(0, 23, 0, 23),
				Parent = Toggle,
				BackgroundTransparency = 0,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Theme.SurfaceHigh,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(CheckBox, 6)
			addGradient(CheckBox, White, Color3.fromRGB(190, 190, 220), 90)

			local BoxStroke = addStroke(CheckBox, Theme.Outline, 0.2, 1)

			local Check = createInstance("ImageLabel", {
				Name = "Check",
				Position = UDim2.new(0.500, 0, 0.500, 0),
				Size = UDim2.new(0, 9, 0, 9),
				Parent = CheckBox,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 1,
				BackgroundColor3 = White,
				ImageColor3 = White,
				Image = "rbxassetid://10709790644",
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Toggle_Padding = createInstance("UIPadding", {
				Parent = Toggle,
				PaddingLeft = UDim.new(0, 1)
			})

			local function Refresh()
				local On = Settings.Value

				Spring.target(Check, 0.6, 7, {
					ImageTransparency = On and 0 or 1,
					Size = On and UDim2.fromOffset(17, 17) or UDim2.fromOffset(9, 9)
				})
				Spring.target(CheckBox, 1, 3, {
					BackgroundColor3 = On and Theme.Accent or (Hovering and Theme.Surface or Theme.SurfaceHigh)
				})
				Spring.target(BoxStroke, 1, 3, {
					Color = On and Theme.AccentLight or (Hovering and Theme.Accent or Theme.Outline),
					Transparency = On and 0 or 0.2
				})
				Spring.target(TpggleTitle, 1, 3, {
					TextColor3 = (On or Hovering) and Theme.Text or Theme.TextDim
				})
			end

			function Settings:Set(Value)
				Settings.Value = Value
				Refresh()
				Settings.Callback(Value)
			end

			table.insert(Wii_Inputs, Toggle.MouseEnter:Connect(function()
				Hovering = true
				Refresh()
			end))

			table.insert(Wii_Inputs, Toggle.MouseLeave:Connect(function()
				Hovering = false
				Refresh()
			end))

			table.insert(Wii_Inputs, Toggle.MouseButton1Down:Connect(function()
				Settings:Set(not Settings.Value)
			end))

			Settings:Set(Settings.Value)

			return Settings
		end

		function TabSettings:Bind(Title, Options)
			Options = Options or {}

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
				BackgroundColor3 = White,
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
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local KeyBox = createInstance("Frame", {
				Name = "KeyBox",
				Position = UDim2.new(1.000, 0.000, 0.500, 0.000),
				Size = UDim2.new(0.000, 1.000, 0.000, 23.000),
				Parent = Keybind,
				BackgroundTransparency = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Theme.SurfaceHigh,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(KeyBox, 6)
			addGradient(KeyBox, White, Color3.fromRGB(190, 190, 220), 90)

			local BoxStroke = addStroke(KeyBox, Theme.Outline, 0.2, 1)

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
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
				TextSize = 15,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			createInstance("UIPadding", {
				Parent = KeyBox,
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
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
				BackgroundColor3 = White,
				ImageColor3 = White,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Listening = false
			local Hovering = false

			local function Refresh()
				Spring.target(BoxStroke, 1, 4, {
					Color = Listening and Theme.AccentLight or (Hovering and Theme.Accent or Theme.Outline),
					Transparency = Listening and 0 or 0.2
				})
				Spring.target(KeyBox, 1, 4, {
					BackgroundColor3 = Listening and Theme.Accent or Theme.SurfaceHigh
				})
				Spring.target(SelectedBind, 1, 4, {
					TextColor3 = Listening and Theme.Text or Theme.TextDim
				})
			end

			function Settings:Set(Value)
				Listening = false
				Settings.Value = Value
				SelectedBind.Text = Value
				Refresh()
			end

			table.insert(Wii_Inputs, TouchArea.MouseEnter:Connect(function()
				Hovering = true
				Refresh()
			end))

			table.insert(Wii_Inputs, TouchArea.MouseLeave:Connect(function()
				Hovering = false
				Refresh()
			end))

			table.insert(Wii_Inputs, TouchArea.MouseButton1Down:Connect(function()
				if Listening then
					Settings:Set(Settings.Value)
					return
				end

				Listening = true
				SelectedBind.Text = "..."
				Refresh()
			end))

			table.insert(Wii_Inputs, UserInputService.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				local Type = input.UserInputType
				if Type == Enum.UserInputType.Keyboard or Type == Enum.UserInputType.Gamepad1 then
					local Key = CleanEnum(input.KeyCode)

					if Listening then
						if Key == "Escape" then
							Settings:Set(Settings.Value)
						elseif Key == "Backspace" then
							Settings:Set("None")
						else
							Settings:Set(Key)
						end
					elseif Key == Settings.Value then
						Settings.Callback(Key)
					end
				elseif Type == Enum.UserInputType.MouseButton1 or Type == Enum.UserInputType.MouseButton2 or Type == Enum.UserInputType.MouseButton3 then
					local Name = CleanEnum(Type)
					if Listening then
						Settings:Set(Name)
					elseif Name == Settings.Value then
						Settings.Callback(Name)
					end
				end
			end))

			return Settings
		end

		function TabSettings:Slider(Title, Options)
			Options = Options or {}

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

			local Hovering = false
			local Dragging = false

			local Slider = createInstance("ImageButton", {
				Name = "Slider",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Slider,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				Name = "SliderVal",
				Size = UDim2.new(0, 35, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = tostring(Settings.Value),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.AccentLight,
				PlaceholderText = '',
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
				BackgroundColor3 = White,
				ClearTextOnFocus = false,
				LayoutOrder = 1,
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local SliderTitle = createInstance("TextLabel", {
				Name = "SliderTitle",
				Size = UDim2.new(0, 105, 0, 17),
				Parent = Top,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Title,
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
				TextSize = 17,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Bottom = createInstance("Frame", {
				Name = "Bottom",
				Size = UDim2.new(1, 0, 0, 26),
				Parent = Slider,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 317, 0, 23),
				Parent = Bottom,
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.Surface,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(SliderBack, 6)

			local BackStroke = addStroke(SliderBack, Theme.Outline, 0.2, 1)

			local SliderMain = createInstance("Frame", {
				Name = "SliderMain",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 235, 0, 23),
				Parent = SliderBack,
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(SliderMain, 6)
			addGradient(SliderMain, Theme.AccentDark, Theme.AccentLight, 0)

			-- Handle on the end of the fill
			local Knob = createInstance("Frame", {
				Name = "Knob",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -4, 0.5, 0),
				Size = UDim2.fromOffset(3, 13),
				Parent = SliderMain,
				BackgroundColor3 = White,
				BackgroundTransparency = 0.25,
				BorderSizePixel = 0,
				ZIndex = 1
			})
			addCorner(Knob, 2)

			local SliderPad = createInstance("UIPadding", {
				Parent = Slider,
				PaddingLeft = UDim.new(0, 1)
			})

			local function Refresh()
				local Active = Hovering or Dragging

				Spring.target(BackStroke, 1, 4, {
					Color = Active and Theme.Accent or Theme.Outline,
					Transparency = Active and 0 or 0.2
				})
				Spring.target(Knob, 1, 5, {
					BackgroundTransparency = Dragging and 0 or 0.25,
					Size = Dragging and UDim2.fromOffset(3, 17) or UDim2.fromOffset(3, 13)
				})
				Spring.target(SliderTitle, 1, 4, {
					TextColor3 = Active and Theme.Text or Theme.TextDim
				})
			end

			function Settings:Visible(Value)
				Slider.Visible = Value
			end

			-- Number of decimals shown / kept, taken from the step
			local Decimals = 0
			if Settings.Step < 1 then
				local Fraction = string.match(tostring(Settings.Step), "%.(%d+)")
				Decimals = Fraction and #Fraction or 0
			end
			local Rounding = math.max(Decimals, 2)

			-- Snap any number to the nearest step, returns the snapped value and its 0-1 position
			local function Snap(Value)
				local Min, Max, Step = Settings.Min, Settings.Max, Settings.Step
				local Range = Max - Min

				Value = math.clamp(Value, Min, Max)

				if Range <= 0 or Step <= 0 then
					return Value, 0
				end

				local Steps = Range / Step
				local Alpha = math.clamp(math.floor((Value - Min) / Range * Steps + 0.5) / Steps, 0, 1)

				return tonumber(string.format("%." .. Rounding .. "f", Min + Range * Alpha)), Alpha
			end

			function Settings:Set(Value)
				local Snapped, Alpha = Snap(tonumber(Value) or Settings.Value)

				Settings.Value = Snapped

				Spring.target(SliderMain, 1, 6, {
					Size = UDim2.fromScale(Alpha, 1)
				})

				if Snapped == math.floor(Snapped) then
					SliderVal.Text = tostring(Snapped)
				else
					SliderVal.Text = string.format("%." .. Decimals .. "f", Snapped)
				end

				pcall(Settings.Callback, Settings.Value)
			end

			table.insert(Wii_Inputs, SliderVal.Focused:Connect(function()
				Spring.target(SliderVal, 1, 5, { TextColor3 = Theme.Text })
			end))

			table.insert(Wii_Inputs, SliderVal.FocusLost:Connect(function()
				Spring.target(SliderVal, 1, 5, { TextColor3 = Theme.AccentLight })

				local toNum = tonumber(SliderVal.Text)
				if toNum then
					Settings:Set(toNum)
				else
					SliderVal.Text = tostring(Settings.Value)
				end
			end))

			local Connection
			local function StopDragging()
				if Connection then
					Connection:Disconnect()
					Connection = nil
				end
				if Dragging then
					Dragging = false
					Refresh()
				end
			end

			table.insert(Wii_Inputs, UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					StopDragging()
				end
			end))

			Settings:Set(Settings.Value)

			table.insert(Wii_Inputs, Slider.MouseEnter:Connect(function()
				Hovering = true
				Refresh()
			end))

			table.insert(Wii_Inputs, Slider.MouseLeave:Connect(function()
				Hovering = false
				Refresh()
			end))

			table.insert(Wii_Inputs, Slider.MouseButton1Down:Connect(function()
				if Connection then
					Connection:Disconnect()
				end

				Dragging = true
				Refresh()

				Connection = RunService.Heartbeat:Connect(function()
					local MouseX = UserInputService:GetMouseLocation().X
					local Alpha = math.clamp((MouseX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
					local Target = Settings.Min + (Settings.Max - Settings.Min) * Alpha

					-- Only fire the callback when the value actually changes
					if Snap(Target) ~= Settings.Value then
						Settings:Set(Target)
					end
				end)
			end))

			return Settings
		end

		function TabSettings:Dropdown(Title, Options)
			Options = Options or {}

			local Settings = {
				Type = "Dropdown",
				Name = Title,
				Value = Options.Default or "None",
				List = Options.List or {},
				Callback = Options.Callback or function() end,
			}

			WiiUI.Flags[Title] = Settings

			local Opened = false
			local Hovering = false
			local CloseToken = 0

			local Dropdown = createInstance("ImageButton", {
				Name = "Dropdown",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				BackgroundColor3 = White,
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
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
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
				BackgroundColor3 = White,
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
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.Surface,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(DropdownBG, 6)

			local DropStroke = addStroke(DropdownBG, Theme.Outline, 0.2, 1)

			local Arrow = createInstance("ImageLabel", {
				Name = "Arrow",
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 23, 0, 23),
				Parent = DropdownBG,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = White,
				ImageColor3 = Theme.TextMuted,
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
				Text = tostring(Settings.Value),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
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
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Theme.Accent,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ClipsDescendants = true,
				BackgroundColor3 = Color3.fromRGB(14, 13, 28),
				BorderSizePixel = 0,
				ZIndex = 5
			})

			addCorner(OptionHolder, 6)
			addStroke(OptionHolder, Theme.Accent, 0.45, 1)

			local OptionLayout = createInstance("UIListLayout", {
				Parent = OptionHolder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local function RefreshHeader()
				Spring.target(Arrow, 1, 5, {
					Rotation = Opened and 180 or 0
				})
				Spring.target(DropStroke, 1, 4, {
					Color = (Opened or Hovering) and Theme.Accent or Theme.Outline,
					Transparency = (Opened or Hovering) and 0 or 0.2
				})
				Spring.target(DropdownTitle, 1, 4, {
					TextColor3 = (Opened or Hovering) and Theme.Text or Theme.TextDim
				})
			end

			function Settings:Open()
				if Opened then return end

				CloseToken += 1
				Opened = true

				for _, v in OptionHolder:GetChildren() do
					if v:IsA("GuiObject") then
						v:Destroy()
					end
				end

				local List

				if typeof(Settings.List) == "function" then
					List = Settings.List()
				else
					List = Settings.List
				end

				for i, v in List do
					local Selected = (v == Settings.Value)

					local Option = createInstance("ImageButton", {
						Name = "Option",
						Size = UDim2.new(1, 0, 0, 22),
						Parent = OptionHolder,
						BackgroundTransparency = 1,
						BackgroundColor3 = Theme.Accent,
						BorderSizePixel = 0,
						AutoButtonColor = false,
						LayoutOrder = i,
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
						Text = tostring(v),
						AutomaticSize = Enum.AutomaticSize.X,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Selected and Theme.Text or Theme.TextDim,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 15,
						BorderSizePixel = 0,
						ZIndex = 7
					})

					-- Marker for the currently selected option
					if Selected then
						local Marker = createInstance("Frame", {
							Name = "Marker",
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 3, 0.5, 0),
							Size = UDim2.fromOffset(2, 12),
							Parent = Option,
							BackgroundColor3 = Theme.AccentLight,
							BorderSizePixel = 0,
							ZIndex = 7
						})
						addCorner(Marker, 1)
					end

					local CanHover = true

					table.insert(Wii_Inputs, Option.MouseButton1Down:Connect(function()
						CanHover = false
						Option.BackgroundTransparency = 0.5
						Settings:Set(v)
						Settings:Close()
					end))

					table.insert(Wii_Inputs, Option.MouseEnter:Connect(function()
						if not CanHover then return end
						Spring.target(Option, 1, 6, { BackgroundTransparency = 0.7 })
						Spring.target(OptionText, 1, 6, { TextColor3 = Theme.Text })
					end))

					table.insert(Wii_Inputs, Option.MouseLeave:Connect(function()
						if not CanHover then return end
						Spring.target(Option, 1, 6, { BackgroundTransparency = 1 })
						Spring.target(OptionText, 1, 6, { TextColor3 = Selected and Theme.Text or Theme.TextDim })
					end))
				end

				OptionHolder.Size = UDim2.fromOffset(265, 0)
				OptionHolder.Visible = true
				TweenService:Create(OptionHolder, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(265, 78)
				}):Play()

				RefreshHeader()
			end

			function Settings:Close()
				if not Opened then return end

				Opened = false
				CloseToken += 1
				local Token = CloseToken

				local Tween = TweenService:Create(OptionHolder, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.fromOffset(265, 0)
				})
				Tween.Completed:Connect(function()
					if Token == CloseToken then
						OptionHolder.Visible = false
					end
				end)
				Tween:Play()

				RefreshHeader()
			end

			function Settings:Set(Value)
				Settings.Callback(Value)
				Settings.Value = Value
				ValueText.Text = tostring(Value)
			end

			Settings.Callback(Settings.Value)

			table.insert(Wii_Inputs, Dropdown.MouseEnter:Connect(function()
				Hovering = true
				RefreshHeader()
			end))

			table.insert(Wii_Inputs, Dropdown.MouseLeave:Connect(function()
				Hovering = false
				RefreshHeader()
			end))

			table.insert(Wii_Inputs, Dropdown.MouseButton1Down:Connect(function()
				if Opened then
					Settings:Close()
				else
					Settings:Open()
				end
			end))

			return Settings
		end

		function TabSettings:Textbox(Title, Options)
			Options = Options or {}

			local Settings = {
				Value = Options.Default or "",
				Callback = Options.Callback or function() end,
			}

			local TextBox = createInstance("Frame", {
				Name = "TextBox",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 393, 0, 52),
				Parent = Canvas,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Top = createInstance("Frame", {
				Name = "Top",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 26),
				Parent = TextBox,
				BackgroundTransparency = 1,
				BackgroundColor3 = White,
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
				TextColor3 = Theme.TextDim,
				BackgroundColor3 = White,
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
				BackgroundColor3 = White,
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
				BackgroundTransparency = 0,
				BackgroundColor3 = Theme.Surface,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			addCorner(TextboxBackground, 6)

			local BoxStroke = addStroke(TextboxBackground, Theme.Outline, 0.2, 1)

			local Icon = createInstance("ImageLabel", {
				Name = "Icon",
				Position = UDim2.new(0.985, 0, 0.500, 0),
				Size = UDim2.new(0, 16, 0, 16),
				Parent = TextboxBackground,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = White,
				ImageColor3 = Theme.TextMuted,
				Image = "rbxassetid://108341418673566",
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local ValueText = createInstance("TextBox", {
				Name = "ValueText",
				Position = UDim2.new(0, 10, 0.500, 0),
				Size = UDim2.new(0, 214, 0, 17),
				Parent = TextboxBackground,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = WiiUI.Fonts.SemiBold,
				Text = Settings.Value,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Theme.TextDim,
				PlaceholderText = 'Enter Text',
				PlaceholderColor3 = Color3.fromRGB(130, 130, 156),
				BackgroundColor3 = White,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				TextSize = 15,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local TextboxPad = createInstance("UIPadding", {
				Parent = TextBox,
				PaddingLeft = UDim.new(0, 1)
			})

			function Settings:Set(Value)
				Settings.Value = Value
				ValueText.Text = Value
			end

			table.insert(Wii_Inputs, ValueText.Focused:Connect(function()
				Spring.target(BoxStroke, 1, 5, { Color = Theme.AccentLight, Transparency = 0 })
				Spring.target(Icon, 1, 5, { ImageColor3 = Theme.AccentLight })
				Spring.target(TextboxTitle, 1, 5, { TextColor3 = Theme.Text })
				Spring.target(ValueText, 1, 5, { TextColor3 = Theme.Text })
			end))

			table.insert(Wii_Inputs, ValueText.FocusLost:Connect(function()
				Spring.target(BoxStroke, 1, 5, { Color = Theme.Outline, Transparency = 0.2 })
				Spring.target(Icon, 1, 5, { ImageColor3 = Theme.TextMuted })
				Spring.target(TextboxTitle, 1, 5, { TextColor3 = Theme.TextDim })
				Spring.target(ValueText, 1, 5, { TextColor3 = Theme.TextDim })

				Settings.Value = ValueText.Text
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
				BackgroundColor3 = White,
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
				Options = Options or {}

				local ButtonSettings = {
					Callback = Options.Callback or function() end
				}

				local Hovering = false
				local Pressed = false

				local Button = createInstance("ImageButton", {
					Name = "Button",
					Position = UDim2.new(0, 0, 0.500, 0),
					Size = UDim2.new(0, 127, 0, 23),
					Parent = ButtonList,
					BackgroundTransparency = 0.4,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 1
				})

				addCorner(Button, 6)
				addGradient(Button, White, Color3.fromRGB(176, 176, 226), 90)

				local ButtonStroke = addStroke(Button, Theme.AccentLight, 0.55, 1)

				local ButtonScale = createInstance("UIScale", {
					Parent = Button,
					Scale = 1
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
					TextColor3 = Theme.TextDim,
					BackgroundColor3 = White,
					TextSize = 15,
					BorderSizePixel = 0,
					ZIndex = 1
				})

				local function Refresh()
					Spring.stop(Button); Spring.stop(ButtonTitle); Spring.stop(ButtonStroke)

					Spring.target(Button, 1, 4, {
						BackgroundTransparency = Pressed and 0.05 or (Hovering and 0.22 or 0.4)
					})
					Spring.target(ButtonStroke, 1, 4, {
						Transparency = (Pressed or Hovering) and 0.1 or 0.55
					})
					Spring.target(ButtonTitle, 1, 4, {
						TextColor3 = (Pressed or Hovering) and Theme.Text or Theme.TextDim
					})
					Spring.target(ButtonScale, 1, 8, {
						Scale = Pressed and 0.96 or 1
					})
				end

				table.insert(Wii_Inputs, Button.MouseEnter:Connect(function()
					Hovering = true
					Refresh()
				end))

				table.insert(Wii_Inputs, Button.MouseLeave:Connect(function()
					Hovering = false
					Pressed = false
					Refresh()
				end))

				table.insert(Wii_Inputs, Button.MouseButton1Down:Connect(function()
					Pressed = true
					Refresh()
					Ripple(Button, White)
					ButtonSettings.Callback()
				end))

				table.insert(Wii_Inputs, Button.MouseButton1Up:Connect(function()
					Pressed = false
					Refresh()
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
				BackgroundColor3 = White,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local Div = createInstance("Frame", {
				Name = "Div",
				Position = UDim2.new(1, 0, 0.500, 0),
				Size = UDim2.new(1, 0, 0, 1),
				Parent = DivHolder,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = White,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			local DivConstraint = createInstance("UISizeConstraint", {
				Parent = Div,
				MaxSize = Vector2.new(math.huge, 1),
				MinSize = Vector2.new(0, 1)
			})

			-- Fades out toward the right edge
			createInstance("UIGradient", {
				Parent = Div,
				Color = ColorSequence.new(Theme.Outline, Color3.fromRGB(40, 40, 60)),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})

			return Divider
		end

		return TabSettings
	end

	return Window
end

return WiiUI
