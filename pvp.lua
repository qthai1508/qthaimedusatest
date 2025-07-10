
-- 🧱 Load Service
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- 🎨 Tạo GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RezUI"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.7, 0, 0.35, 0)
frame.Size = UDim2.new(0, 280, 0, 320)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 🌈 Viền bảy màu
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
	while true do
		for h = 0, 1, 0.01 do
			uiStroke.Color = Color3.fromHSV(h, 1, 1)
			task.wait()
		end
	end
end)

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- 🏷 Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Text = "👻 Medusa 👻"
title.Position = UDim2.new(0, 0, 0, 5)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.FredokaOne
title.TextSize = 22

-- Tiêu đề phụ --
local subtitle = Instance.new("TextLabel", frame)
subtitle.Text = "Bá Sàn CDVN"
subtitle.Position = UDim2.new(0, 0, 0, 35) -- ngay dưới title chính
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14


-- 📦 Container nút
local buttonContainer = Instance.new("Frame", frame)
buttonContainer.Position = UDim2.new(0, 15, 0, 45)
buttonContainer.Size = UDim2.new(1, -30, 1, -60)
buttonContainer.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", buttonContainer)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)

-- 🔘 Hàm tạo nút
local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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

-- ⚔️ Auto Attack
task.spawn(function()
	while true do
		task.wait(0.1)
		if attacking then
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool then pcall(function() tool:Activate() end) end
		end
	end
end)

-- ⚙️ Config
local rotating = false
local target = nil
local targetType = "Player" -- hoặc "Player"
local radius = 18
local heightOffset = 0
local speed = 3
local angle = 0
local attacking = false
local autoCollect = false

-- 📍 Tìm boss gần
local function getNearestPlayer(maxDist)
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local nearest, closest = nil, maxDist

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local dist = (root.Position - hrp.Position).Magnitude
			if dist < closest then
				nearest, closest = player.Character, dist
			end
		end
	end

	return nearest
end



-- ▶️ Start orbit
local function startOrbit()
	if rotating then return end
	rotating = true
	angle = 0
	target = nil

	RunService:UnbindFromRenderStep("OrbitAroundTarget")
	RunService:BindToRenderStep("OrbitAroundTarget", Enum.RenderPriority.Character.Value, function(dt)
		if not rotating then return end

		-- boss chết → tìm boss mới
		if not target or not target:FindFirstChild("HumanoidRootPart") or (target:FindFirstChild("Humanoid") and target.Humanoid.Health <= 0) then
			target = (targetType == "Player") and getNearestPlayer(100) or getNearestBoss(100)
			if not target then return end
		end

		local center = target.HumanoidRootPart.Position + Vector3.new(0, heightOffset, 0)
		angle += dt * math.pi * 2 * speed

		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius
		local orbitPosition = center + Vector3.new(x, 0, z)

		HumanoidRootPart.CFrame = CFrame.new(orbitPosition, center)
	end)
end

local function stopOrbit()
	rotating = false
	RunService:UnbindFromRenderStep("OrbitAroundTarget")
end

-- Biến để theo dõi trạng thái
local hitboxPlayerEnabled = false

-- Nút bật/tắt hitbox người chơi
local hitboxToggleBtn = createButton("🟥 Bật Hitbox ")
hitboxToggleBtn.Parent = buttonContainer

hitboxToggleBtn.MouseButton1Click:Connect(function()
    hitboxPlayerEnabled = not hitboxPlayerEnabled
    hitboxToggleBtn.Text = hitboxPlayerEnabled and "Tắt Hitbox" or "Bật Hitbox"

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            if char then
                for _, partName in ipairs({ "Head", "HumanoidRootPart", "Torso" }) do
                    local part = char:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        if hitboxPlayerEnabled then
                            part.Size = Vector3.new(15, 15, 15)
                            part.Material = Enum.Material.SmoothPlastic
                            part.Color = Color3.fromRGB(255, 255, 255)
                            part.Transparency = 0.8
                            part.Anchored = false
                            part.CanCollide = false
                        else
                            part.Size = Vector3.new(2, 2, 1)
                            part.Material = Enum.Material.Plastic
                            part.Color = Color3.fromRGB(163, 162, 165)
                            part.Transparency = 0.8
                        end
                    end
                end
            end
        end
    end
end)



-- 🧠 Tạo & gán nút + sự kiện
local autoAttackBtn = createButton("🗡️ Tự đánh khi cầm vũ khí")
autoAttackBtn.Parent = buttonContainer
autoAttackBtn.MouseButton1Click:Connect(function()
	attacking = not attacking
	autoAttackBtn.Text = attacking and "Medusa 👻 " or "Tự đánh khi cầm vũ khí"
end)

local ToggleBossAttack = createButton("🔁 Xoay quanh Player")
ToggleBossAttack.Parent = buttonContainer
ToggleBossAttack.MouseButton1Click:Connect(function()
	if rotating then
		stopOrbit()
		ToggleBossAttack.Text = "🔁 Xoay quanh Player"
	else
		startOrbit()
		if target then
			ToggleBossAttack.Text = "❌ Có mẹ nào ở gần đâu ?"
		else
			ToggleBossAttack.Text = "✅ Đang xoay quanh Player"
		end
	end
end)

-- 📦 Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 📦 Biến quản lý
local espEnabled = false
local espBoxes = {}
local espBeams = {}
local updateConnection = nil
local maxDistance = 100 -- khoảng cách tối đa để vẽ line

-- 🔁 Xóa box & beam cũ
local function clearESP()
	for _, v in pairs(espBoxes) do
		if v then v:Destroy() end
	end
	for _, v in pairs(espBeams) do
		if v.Part then v.Part:Destroy() end
	end
	espBoxes = {}
	espBeams = {}
end

-- 🔁 Tạo ESP mới
local function updateESP()
	clearESP()

	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character.HumanoidRootPart
			local dist = (myRoot.Position - root.Position).Magnitude

			-- 🎯 Vẽ box
			local maxDistance = math.huge
			local box = Instance.new("BoxHandleAdornment")
			box.Adornee = root
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Color3 = Color3.fromRGB(255, 255, 255)
			box.Transparency = 0.5 -- trong suốt bên trong, chỉ là khung
			box.Size = root.Size + Vector3.new(0.5, 0.5, 0.5)
			box.Parent = root
			table.insert(espBoxes, box)

			-- 🎯 Nếu trong khoảng cách thì tạo Beam từ bạn → player
			if dist <= maxDistance then
				local beamPart = Instance.new("Part")
				beamPart.Anchored = true
				beamPart.CanCollide = false
				beamPart.Transparency = 1
				beamPart.Size = Vector3.new(0.2, 0.2, 0.2)
				beamPart.Parent = workspace

				local att0 = Instance.new("Attachment", myRoot)
				local att1 = Instance.new("Attachment", root)

				local beam = Instance.new("Beam")
				beam.Attachment0 = att0
				beam.Attachment1 = att1
				beam.Width0 = 0.1
				beam.Width1 = 0.1
				beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
				beam.FaceCamera = true
				beam.Transparency = NumberSequence.new(0.8)
				beam.Parent = beamPart

				table.insert(espBeams, {Part = beamPart})
			end
		end
	end
end

-- 🔘 Toggle ESP
local function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		updateESP()
		updateConnection = RunService.RenderStepped:Connect(updateESP)
	else
		if updateConnection then updateConnection:Disconnect() updateConnection = nil end
		clearESP()
	end
end


local espBtn = createButton("🟥 Bật ESP Full")
espBtn.Parent = buttonContainer
espBtn.MouseButton1Click:Connect(function()
	toggleESP()
	espBtn.Text = espEnabled and "Tắt ESP Full" or "Bật ESP Full"
end)


-- ⚙️ Biến điều khiển
local showHealth = false
local healthUI = {}

-- 📦 Tạo nút hiển thị máu
local HealthToggleBtn = createButton("📊 Hiển thị máu NPC/Người chơi")
HealthToggleBtn.Parent = buttonContainer
HealthToggleBtn.MouseButton1Click:Connect(function()
	showHealth = not showHealth
	HealthToggleBtn.Text = showHealth and "✅ Đang hiển thị máu..." or "📊 Hiển thị máu NPC/Người chơi"

	if not showHealth then
		-- Xóa thanh máu khi tắt
		for _, gui in pairs(healthUI) do
			if gui and gui.Parent then
				gui:Destroy()
			end
		end
		healthUI = {}
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

-- 🔁 Vòng lặp cập nhật máu
task.spawn(function()
	while task.wait(0.3) do
		if showHealth then
			for _, model in pairs(workspace:GetDescendants()) do
				if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("Head") and model ~= game.Players.LocalPlayer.Character then
					local head, humanoid = model.Head, model.Humanoid

					if not healthUI[model] or not healthUI[model].Parent then
						local bill = Instance.new("BillboardGui", head)
						bill.Name = "HealthBar"
						bill.Size = UDim2.new(4, 0, 0.5, 0)
						bill.StudsOffset = Vector3.new(0, 2.5, 0)
						bill.Adornee = head
						bill.AlwaysOnTop = true

						local bg = Instance.new("Frame", bill)
						bg.Name = "BG"
						bg.Size = UDim2.new(1, 0, 1, 0)
						bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
						bg.BorderSizePixel = 0

						local hpBar = Instance.new("Frame", bg)
						hpBar.Name = "HP"
						hpBar.Size = UDim2.new(1, 0, 1, 0)
						hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
						hpBar.BorderSizePixel = 0

						local hpText = Instance.new("TextLabel", bg)
						hpText.Name = "HPText"
						hpText.Size = UDim2.new(1, 0, 1, 0)
						hpText.BackgroundTransparency = 1
						hpText.TextColor3 = Color3.new(1, 1, 1)
						hpText.TextStrokeTransparency = 0.5
						hpText.TextScaled = true
						hpText.Font = Enum.Font.GothamBold
						hpText.Text = ""

						healthUI[model] = bill
					end

					-- Cập nhật thanh máu
					local barBG = healthUI[model]:FindFirstChild("BG")
					if barBG and barBG:FindFirstChild("HP") and barBG:FindFirstChild("HPText") then
						local currentHP = humanoid.Health
						local maxHP = humanoid.MaxHealth
						local ratio = math.clamp(currentHP / maxHP, 0, 1)

						barBG.HP.Size = UDim2.new(ratio, 0, 1, 0)
						barBG.HPText.Text = string.format("%d / %d", math.floor(currentHP), math.floor(maxHP))
					end
				end
			end
		end
	end
end)
