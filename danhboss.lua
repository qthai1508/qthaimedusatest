repeat task.wait() until game:IsLoaded()

-- 📦 Load Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🧍 LocalPlayer setup
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ⚙️ State
local attacking = false
local rotating = false
local showHealth = false
local lockAim = false
local selectedBoss = nil
local currentTarget = nil
local movingToOrbit = false
local angle = 0
local orbitTween = nil

-- 📍 Tìm boss gần nhất
local function getClosestBoss()
	local closest = nil
	local shortest = math.huge
	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= Character then
			local dist = (HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude
			if dist < shortest then
				shortest = dist
				closest = model
			end
		end
	end
	return closest
end

local centerPosition = Vector3.new(-2572, 277, -1375)
local radius =20
local speed = 2.9
local heightOffset = 5

local function moveToOrbit()
	if not HumanoidRootPart or movingToOrbit then return end
	movingToOrbit = true

	local direction = (HumanoidRootPart.Position - centerPosition)
	direction = Vector3.new(direction.X, 0, direction.Z).Unit
	if direction.Magnitude == 0 then direction = Vector3.new(1, 0, 0) end

	local destination = centerPosition + direction * radius + Vector3.new(0, heightOffset, 0)

	local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = CFrame.new(destination, centerPosition)
	})
	tween:Play()
	tween.Completed:Connect(function()
		angle = math.atan2(direction.Z, direction.X)
		rotating = true
		movingToOrbit = false
	end)
end

-- 🔁 Xoay quanh
RunService.RenderStepped:Connect(function(dt)
	if rotating and HumanoidRootPart then
		angle += (math.rad(360) / speed) * dt
		local offsetX = math.cos(angle) * radius
		local offsetZ = math.sin(angle) * radius
		local targetPosition = centerPosition + Vector3.new(offsetX, heightOffset, offsetZ)

		if orbitTween then orbitTween:Cancel() end
		orbitTween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			CFrame = CFrame.new(targetPosition, centerPosition)
		})
		orbitTween:Play()
	end
end)

-- 🗡️ Tự đánh
coroutine.wrap(function()
	while true do
		task.wait(0.1)
		if attacking then
			local tool = Character and Character:FindFirstChildOfClass("Tool")
			if tool then pcall(function() tool:Activate() end) end
		end
	end
end)()

-- 🎨 Giao diện GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.7, 0, 0.35, 0)
frame.Size = UDim2.new(0, 300, 0, 330)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 🌈 Viền rainbow
coroutine.wrap(function()
	while true do
		for h = 0, 1, 0.01 do
			uiStroke.Color = Color3.fromHSV(h, 1, 1)
			task.wait()
		end
	end
end)()

local title = Instance.new("TextLabel", frame)
title.Text = "👻Thai Medusa👻"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 22

local subtitle = Instance.new("TextLabel", frame)
subtitle.Text = "Tuyệt Đối Không Dùng Phóng Lợn !"
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14

local buttonContainer = Instance.new("Frame", frame)
buttonContainer.Position = UDim2.new(0, 15, 0, 60)
buttonContainer.Size = UDim2.new(1, -30, 1, -70)
buttonContainer.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", buttonContainer)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.BackgroundTransparency = 0.2
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Thickness = 1.2
	stroke.Color = Color3.fromRGB(200, 200, 200)
	return btn
end

local autoAttackBtn = createButton("🗡️ Tự đánh khi cầm vũ khí")
autoAttackBtn.Parent = buttonContainer
autoAttackBtn.MouseButton1Click:Connect(function()
	attacking = not attacking
	autoAttackBtn.Text = attacking and "✅ Đang Tự đánh" or "🗡️ Tự đánh khi cầm vũ khí"
end)

local toggleOrbitBtn = createButton("🔁 Xoay quanh")
toggleOrbitBtn.Parent = buttonContainer
toggleOrbitBtn.MouseButton1Click:Connect(function()
	if rotating then
		rotating = false
		if orbitTween then orbitTween:Cancel() orbitTween = nil end
		toggleOrbitBtn.Text = "🔁 Xoay quanh"
	else
		moveToOrbit()
		toggleOrbitBtn.Text = "✅ Đang xoay quanh"
	end
end)

local healthBtn = createButton("📊 Hiển thị máu Boss")
healthBtn.Parent = buttonContainer
healthBtn.MouseButton1Click:Connect(function()
	showHealth = not showHealth
	healthBtn.Text = showHealth and "✅ Đang hiển thị máu" or "📊 Hiển thị máu Boss"
end)

local lockAimBtn = createButton("🎯 Ghim Tâm Vào Boss")
lockAimBtn.Parent = buttonContainer
lockAimBtn.MouseButton1Click:Connect(function()
	lockAim = not lockAim
	lockAimBtn.Text = lockAim and "✅ Đang Ghim Tâm" or "🎯 Ghim Tâm Vào Boss"
	if lockAim then
		selectedBoss = getClosestBoss()
		if selectedBoss and selectedBoss:FindFirstChild("HumanoidRootPart") then
			currentTarget = selectedBoss
		else
			lockAim = false
			lockAimBtn.Text = "🎯 Ghim Tâm Vào Boss"
		end
	else
		currentTarget = nil
	end
end)

local autoPickup = false
local pickupBtn = createButton("🎁 Tự nhặt vật phẩm rơi")
pickupBtn.Parent = buttonContainer
pickupBtn.MouseButton1Click:Connect(function()
	autoPickup = not autoPickup
	pickupBtn.Text = autoPickup and "✅ Đang tự nhặt vật phẩm" or "🎁 Tự nhặt vật phẩm rơi"
end)

-- 🔁 Theo dõi vật phẩm trong Workspace
task.spawn(function()
	while true do
		if autoPickup then
			for _, drop in ipairs(workspace:GetDescendants()) do
				if drop:IsA("BasePart") and drop:FindFirstChildOfClass("ProximityPrompt") then
					local prompt = drop:FindFirstChildOfClass("ProximityPrompt")
					if (HumanoidRootPart.Position - drop.Position).Magnitude < 50 then
						fireproximityprompt(prompt)
						task.wait(0.1)
					end
				end
			end
		end
		task.wait(0.3)
	end
end)

-- 🩸 Cập nhật máu boss (giảm lag)
local bossHpLabel = Instance.new("TextLabel", gui)
bossHpLabel.Size = UDim2.new(0, 400, 0, 30)
bossHpLabel.Position = UDim2.new(0.5, -200, 0, 10)
bossHpLabel.BackgroundTransparency = 0.3
bossHpLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bossHpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bossHpLabel.Font = Enum.Font.GothamBold
bossHpLabel.TextSize = 18
bossHpLabel.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", bossHpLabel).CornerRadius = UDim.new(0, 6)

coroutine.wrap(function()
	while true do
		if showHealth and currentTarget and currentTarget:FindFirstChild("Humanoid") then
			local hp = math.floor(currentTarget.Humanoid.Health)
			local max = math.floor(currentTarget.Humanoid.MaxHealth)
			bossHpLabel.Text = " " .. currentTarget.Name .. ": " .. hp .. " / " .. max
		elseif not showHealth then
			bossHpLabel.Text = ""
		end
		task.wait(0.5)
	end
end)()

-- 🎯 Lock Aim tự cập nhật boss mới
RunService.RenderStepped:Connect(function()
	if not lockAim then return end

	if not currentTarget or not currentTarget:IsDescendantOf(workspace) or not currentTarget:FindFirstChild("HumanoidRootPart") then
		local nextBoss = getClosestBoss()
		if nextBoss then
			currentTarget = nextBoss
			selectedBoss = nextBoss
		else
			return
		end
	end

	local humanoid = currentTarget:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		task.spawn(function()
			repeat task.wait() until not currentTarget:IsDescendantOf(workspace)
			local newBoss
			repeat
				newBoss = getClosestBoss()
				task.wait(0.3)
			until newBoss and newBoss:FindFirstChild("Humanoid") and newBoss.Humanoid.Health > 0
			currentTarget = newBoss
			selectedBoss = newBoss
		end)
	end

	if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
		local npcPos = currentTarget.HumanoidRootPart.Position
		local currentPos = HumanoidRootPart.Position
		local lookAt = CFrame.new(currentPos, npcPos)
		local _, y = lookAt:ToEulerAnglesYXZ()
		HumanoidRootPart.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, y, 0)
	end
end)

-- ❌ Nút đóng GUI
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "✖"
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
