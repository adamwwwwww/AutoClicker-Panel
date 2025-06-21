
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoClickGUI"

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 260, 0, 140)
panel.Position = UDim2.new(0.5, -130, 0.5, -70)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 0
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Visible = true
panel.ClipsDescendants = true

-- ظل خفيف للبانل
local shadow = Instance.new("ImageLabel", panel)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5054950715" -- ظل جميل
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ZIndex = 0

-- العنوان (اسمك)
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Auto Clicker - k2ta"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(120, 255, 180)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2

-- زر الإغلاق الصغير
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = true
closeBtn.ZIndex = 3

closeBtn.MouseEnter:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)
closeBtn.MouseLeave:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- زر التشغيل
local startButton = Instance.new("TextButton", panel)
startButton.Size = UDim2.new(0.9, 0, 0.3, 0)
startButton.Position = UDim2.new(0.05, 0, 0.4, 0)
startButton.Text = "تشغيل الضغط"
startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 20
startButton.AutoButtonColor = true
startButton.ZIndex = 2

startButton.MouseEnter:Connect(function()
	startButton.BackgroundColor3 = Color3.fromRGB(80, 230, 80)
end)
startButton.MouseLeave:Connect(function()
	startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
end)

-- زر الإيقاف
local stopButton = Instance.new("TextButton", panel)
stopButton.Size = UDim2.new(0.9, 0, 0.3, 0)
stopButton.Position = UDim2.new(0.05, 0, 0.75, 0)
stopButton.Text = "إيقاف الضغط"
stopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 20
stopButton.AutoButtonColor = true
stopButton.ZIndex = 2

stopButton.MouseEnter:Connect(function()
	stopButton.BackgroundColor3 = Color3.fromRGB(230, 80, 80)
end)
stopButton.MouseLeave:Connect(function()
	stopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- المتغير اللي يتحكم بالتشغيل
local autoClicking = false

-- دالة الضغط التلقائي (تحتاج exploit لتنفيذ mouse1click فعلي)
local function autoClick()
	while autoClicking do
		local mouse = player:GetMouse()
		mouse1click() -- تمثيل، يحتاج exploit
		wait(0.1)
	end
end

startButton.MouseButton1Click:Connect(function()
	if not autoClicking then
		autoClicking = true
		coroutine.wrap(autoClick)()
	end
end)

stopButton.MouseButton1Click:Connect(function()
	autoClicking = false
end)

-- إخفاء وإظهار الـ GUI بزر Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		gui.Enabled = not gui.Enabled
	end
end)

-- إضافة خاصية سحب البانل بحرية
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

panel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

panel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
