repeat task.wait() until game:IsLoaded()
task.wait(1)
local TweenService = game:GetService("TweenService")

-- ✅ Key thật và link
local trueKey = "medusazz"
-- 📦 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GetKeyUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true
gui.Parent = gethui and gethui() or game:GetService("CoreGui")

-- 🌫️ Nền mờ
local blur = Instance.new("Frame", gui)
blur.Size = UDim2.new(1, 0, 1, 0)
blur.BackgroundColor3 = Color3.new(0, 0, 0)
blur.BackgroundTransparency = 1
blur.ZIndex = 0

-- 🧱 Main (ban đầu ẩn)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Visible = false
main.ZIndex = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = Color3.new(1, 1, 1)

-- Các thành phần con
local function createElement(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	inst.Parent = parent
	return inst
end

-- ❌ Nút đóng
local closeBtn = createElement("TextButton", {
	Text = "✖", Size = UDim2.new(0, 25, 0, 25),
	Position = UDim2.new(1, -30, 0, 5),
	Font = Enum.Font.Gotham, TextSize = 18, TextColor3 = Color3.new(1,1,1),
	BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0,
	Visible = false, ZIndex = 3
}, main)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", closeBtn).Color = Color3.new(1,1,1)

-- 🧾 Tiêu đề
local title = createElement("TextLabel", {
	Text = "GET KEY", Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.new(0, 0, 0, 10), Font = Enum.Font.GothamSemibold,
	TextSize = 20, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1,
	Visible = false, ZIndex = 2
}, main)
Instance.new("UIStroke", title).Color = Color3.new(1,1,1)

-- 🔡 Ô nhập key
local input = createElement("TextBox", {
	PlaceholderText = "Nhập Key Ở Đây", Text = "", Size = UDim2.new(0.85, 0, 0, 35),
	Position = UDim2.new(0.075, 0, 0, 60), Font = Enum.Font.GothamSemibold,
	TextSize = 16, TextColor3 = Color3.new(1,1,1), ClearTextOnFocus = false,
	BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0,
	Visible = false, ZIndex = 2
}, main)
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", input).Color = Color3.new(1,1,1)

-- ⚠️ Cảnh báo
local warnLabel = createElement("TextLabel", {
	Text = "", TextColor3 = Color3.fromRGB(255, 0, 0),
	Font = Enum.Font.GothamSemibold, TextSize = 14,
	Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 100),
	BackgroundTransparency = 1, Visible = false, ZIndex = 2
}, main)

-- 🗝️ Nút check key
local checkBtn = createElement("TextButton", {
	Text = "CHECK KEY", Size = UDim2.new(0.5, 0, 0, 30),
	Position = UDim2.new(0.25, 0, 0, 130), Font = Enum.Font.GothamSemibold,
	TextSize = 16, TextColor3 = Color3.new(1,1,1),
	BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0,
	Visible = false, ZIndex = 2
}, main)
Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", checkBtn).Color = Color3.new(1,1,1)

-- 🌟 Hiệu ứng xuất hiện nền và bảng
TweenService:Create(blur, TweenInfo.new(3), {BackgroundTransparency = 0.4}):Play()
task.delay(3, function()
	main.Visible = true
	TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0, 400, 0, 220)
	}):Play()

	-- Hiện từng phần tử
	task.wait(0.3)
	title.Visible = true
	task.wait(0.2)
	input.Visible = true
	task.wait(0.2)
	checkBtn.Visible = true
	task.wait(0.2)
	linkBtn.Visible = true
	task.wait(0.2)
	warnLabel.Visible = true
	closeBtn.Visible = true
end)

-- 🗝️ Check Key
checkBtn.MouseButton1Click:Connect(function()
    if input.Text == trueKey then
        warnLabel.Text = "✅ Key Chính Xác!"
        warnLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        task.wait(0.5)

        -- Thu nhỏ GUI + làm mờ nền
        TweenService:Create(main, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(blur, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()

        task.wait(0.4)
        gui:Destroy()

        -- Tải script tool
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/qthai1508/qthaimedusatest/refs/heads/main/Scriptdemo.lua"))()
        end)

        if not success then
            game.Players.LocalPlayer:Kick("Lỗi tải script, hãy liên hệ Admin.")
        end
    else
        warnLabel.Text = "❌ Sai Key rồi bro ơi!"
        warnLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ❌ Đóng
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(blur, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	task.wait(0.35)
	gui:Destroy()
end)

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = game.Players.LocalPlayer
local Rep = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local WS = game:GetService("Workspace")


-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/LongThanhTz12/GUI-LIBARY-SCRIPT/refs/heads/main/guilibaryscript"))()

-- Create Main Window
local Window = Fluent:CreateWindow({
    Title = "Medusa 👻 | Link Fb: https://www.facebook.com/qthai1508",
    SubTitle = "by qthai",
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 320),
    MinimizeKey = Enum.KeyCode.F1
})

-- Tab --
local Tabs = {
    Info = Window:AddTab({ Title = "Tab Info", Icon = "info" }),
    Farming = Window:AddTab({ Title = "Tab Farm Lv", Icon = "leaf" }),
    Setting = Window:AddTab({ Title = "Tab Setting", Icon = "settings" }),
    ChoiDo = Window:AddTab({ Title = "Tab Chơi Đồ", Icon = "rocket" }),
    Pvp = Window:AddTab({ Title = "Tab PvP", Icon = "sword" }),
    FarmTien = Window:AddTab({ Title = "Farm Tiền", Icon = "axe" })
}
local FarmWoodTab = Tabs.FarmTien

-- Tab Info
local function createLinkButton(tab, title, url)
    tab:AddButton({
        Title = title,
        Description = "Nhấn để sao chép link",
        Callback = function()
            setclipboard(url)
            Fluent:Notify({
                Title = "✅ Đã sao chép!",
                Content = title .. " đã được sao chép vào clipboard.",
                Duration = 3
            })
        end
    })
end

Tabs.Info:AddParagraph({
    Title = "⚠️ LƯU Ý",
    Content = "Nhấn phím F1 để ẩn / hiện giao diện Fluent UI.",
})

createLinkButton(Tabs.Info, "📎 Facebook", "https://www.facebook.com/qthai1508")

-- Tab Farming
local a = Tabs.Farming:AddButton({
	Title = "Chọn Vũ Khí",
	Description = "Vũ Khí Hiện Tại : None",
	Callback = function()
		local weaponButtons = {}
		
		for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			table.insert(weaponButtons, {
				Title = v.Name,
				Callback = function()
					AttackWeapon = v.Name
					print("Vũ khí đã chọn: " .. v.Name)
				end
			})
		end

		-- Thêm nút thoát
		table.insert(weaponButtons, {
			Title = "❌ Thoát",
			Callback = function()
				print("Đã thoát chọn vũ khí.")
			end
		})

		Window:Dialog({
			Title = "Chọn Vũ Khí",
			Content = "Chọn một vũ khí:",
			Buttons = weaponButtons
		})
	end
})

spawn(function()
	while wait(1) do
		if AttackWeapon then
			a:SetDesc("Vũ Khí Hiện Tại : " .. AttackWeapon)
		end
	end
end)


-- Toggle AutoFarm Giang Ho 1 & 2

local Toggle2 = Tabs.Farming:AddToggle("AutoGiangHo2", {
    Title = "Auto Farm Boss",
    Default = false
})

Toggle2:OnChanged(function(Value)
    AutoFarmGiangho2 = Value
    if Value then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/qthai1508/qthaimedusatest/refs/heads/main/boss.lua"))()
        end)
    end
end)


local UIS = game:GetService("UserInputService")
local RepStorage = game:GetService("ReplicatedStorage")
local KnitInventoryRE = RepStorage:WaitForChild("KnitPackages")["_Index"]["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RE.updateInventory

-- Trang bị vũ khí
function EquipWeapon(ToolSe)
	if not _G.NotAutoEquip and ToolSe then
		local Backpack = game.Players.LocalPlayer.Backpack
		local Character = game.Players.LocalPlayer.Character
		local Tool = Backpack:FindFirstChild(ToolSe)
		if Tool then
			wait(0.1)
			Character.Humanoid:EquipTool(Tool)
		end
	end
end

-- 📦 Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- 🧍 Nhân vật
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

-- ✅ Đảm bảo biến AutoFarmGiangho đã được khởi tạo
local AutoFarmGiangho = false
local DisableALLautogiangho = false
local AttackWeapon = "Phong Lợn"
local Speed = 75


-- ⚔️ Trang bị vũ khí
function EquipWeapon(name)
	local Backpack = LocalPlayer.Backpack
	if Backpack:FindFirstChild(name) then
		Backpack[name].Parent = Character
	end
end

-- 📦 Nhặt vật phẩm
local function TryPickup()
	for _, drop in pairs(workspace.CityNPCs.Drop:GetChildren()) do
		local prompt = drop:FindFirstChildWhichIsA("ProximityPrompt")
		if prompt and (drop.Position - Root.Position).Magnitude <= 15 then
			fireproximityprompt(prompt)
			task.wait(0.05)
		end
	end
end


-- 🌀 Bay mượt tới vị trí
function TweenTo(position)
	local dist = (Root.Position - position).Magnitude
	if dist > 2 then
		local tweenInfo = TweenInfo.new(dist / Speed, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(Root, tweenInfo, {CFrame = CFrame.new(position)})
		tween:Play()
		tween.Completed:Wait()
	end
end

-- 📍 Tìm quái gần nhất
function GetNearestEnemy()
	local nearest, shortest = nil, math.huge
	for _, v in pairs(workspace.CityNPCs.NPCs:GetChildren()) do
		if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
			local dist = (v.HumanoidRootPart.Position - Root.Position).Magnitude
			if dist < shortest then
				shortest = dist
				nearest = v
			end
		end
	end
	return nearest
end

Tabs.Farming:AddToggle("AutoGiangHo", {
	Title = "Auto Farm Quái (Beta còn lỗi)",
	Default = false,
	Callback = function(Value)
		AutoFarmGiangho = Value
	end
})


-- 🧠 Farm quái lơ lửng, an toàn
spawn(function()
	while task.wait() do
		if not AutoFarmGiangho or DisableALLautogiangho then continue end
		if (Vector3.new(871, 29, -1423) - Root.Position).Magnitude > 5000 then continue end

		local target = GetNearestEnemy()
		if target then
			local floatPos = target.HumanoidRootPart.Position + Vector3.new(0, 9, 0)
			TweenTo(floatPos)

			while AutoFarmGiangho and not DisableALLautogiangho do
				if not target:FindFirstChild("HumanoidRootPart") or not target:FindFirstChild("Humanoid") then break end
				if target.Humanoid.Health <= 0 then break end

				pcall(function()
					local targetPos = target.HumanoidRootPart.Position + Vector3.new(0, 9, 0)
					Root.CFrame = CFrame.new(targetPos, target.HumanoidRootPart.Position)

					-- Equip + Tấn công
					if not Character:FindFirstChild(AttackWeapon) then
						EquipWeapon(AttackWeapon)
					end
					VirtualUser:CaptureController()
					VirtualUser:Button1Down(Vector2.new(1280, 672))
					TryPickup()
				end)
				task.wait()
			end

			-- ✅ Sau khi giết xong: đứng yên tại chỗ 1.5s rồi mới bay tiếp
			local stayPos = Root.Position
			for i = 1, 15 do
				if not AutoFarmGiangho then break end
				Root.CFrame = CFrame.new(stayPos)
				TryPickup()
				task.wait(0.1)
			end
		end
	end
end)


-- 🔁 Giữ chuột tấn công
spawn(function()
	while task.wait() do
		if AutoFarmGiangho and not DisableALLautogiangho then
			VirtualUser:CaptureController()
			VirtualUser:Button1Down(Vector2.new(1280, 672))
		end
	end
end)

-- 🔘 Prompt thủ công
local PickupRange = 15 -- ⚙️ Tầm nhặt vật phẩm (tính theo đơn vị stud)

function TryPickup()
	for _, drop in pairs(workspace.CityNPCs.Drop:GetChildren()) do
		local prompt = drop:FindFirstChildWhichIsA("ProximityPrompt")
		if prompt and Root and (drop.Position - Root.Position).Magnitude <= PickupRange then
			fireproximityprompt(prompt)
			wait(0.05)
		end
	end
end


-- Tab Fps --
local fpsLabel -- Để lưu label hiển thị FPS
local fpsConnection -- Kết nối cập nhật FPS

Tabs.Setting:AddToggle("ShowFPS", {
    Title = "🎯 Hiện FPS",
    Default = false,
    Callback = function(state)
        if state then
            -- Tạo FPS Label
            local gui = Instance.new("ScreenGui", game.CoreGui)
            gui.Name = "FPSDisplay"

            fpsLabel = Instance.new("TextLabel", gui)
            fpsLabel.Size = UDim2.new(0, 100, 0, 30)
            fpsLabel.Position = UDim2.new(1, -110, 0, 10)
            fpsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextSize = 18
            fpsLabel.Text = "FPS: ..."
            fpsLabel.BorderSizePixel = 0
            fpsLabel.BackgroundTransparency = 0.2
            fpsLabel.Font = Enum.Font.SourceSansBold

            -- Hàm cập nhật FPS
            local lastUpdate = tick()
            local frames = 0

            fpsConnection = game:GetService("RunService").RenderStepped:Connect(function()
                frames += 1
                local now = tick()
                if now - lastUpdate >= 1 then
                    local fps = math.floor(frames / (now - lastUpdate))
                    fpsLabel.Text = "FPS: " .. fps
                    lastUpdate = now
                    frames = 0
                end
            end)
        else
            if fpsConnection then
                fpsConnection:Disconnect()
                fpsConnection = nil
            end
            if fpsLabel then
                fpsLabel:Destroy()
                fpsLabel = nil
            end
            local oldGui = game.CoreGui:FindFirstChild("FPSDisplay")
            if oldGui then oldGui:Destroy() end
        end
    end
})


Tabs.Setting:AddButton({
    Title = "⚡ Tăng FPS",
    Description = "Giảm chất lượng đồ họa xuống mức thấp nhất",
    Callback = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Fluent:Notify({
            Title = "⚡ FPS Boost!",
            Content = "Đã giảm chất lượng đồ họa xuống mức thấp nhất để tăng FPS.",
            Duration = 4
        })
    end
})

Tabs.Setting:AddButton({
    Title = "📶 Tối Ưu Ping",
    Description = "Ẩn hiệu ứng + giảm tải mạng client",
    Callback = function()
        -- Tắt Light và ParticleEmitter
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Light") or v:IsA("Trail") then
                v.Enabled = false
            end
        end

        -- Tắt Shadows và giảm chất lượng Terrain (nếu có)
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterReflectance = 0
        end

        settings().Rendering.ReloadAssets = true

        Fluent:Notify({
            Title = "📶 Ping Optimization",
            Content = "Đã ẩn hiệu ứng và giảm tải để tối ưu ping.",
            Duration = 4
        })
    end
})


-- Tab Chơi Đồ
Tabs.ChoiDo:AddButton({
    Title = "✈️ Bay Bay",
    Description = "Chạy script bay",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

Tabs.ChoiDo:AddToggle("HitboxRucRo", {
    Title = "🌟 Hitbox",
    Default = false,
    Callback = function(state)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local char = p.Character
                if char then
                    for _, partName in ipairs({ "Head", "HumanoidRootPart", "Torso" }) do
                        local part = char:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            if state then
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
                                part.Transparency = 0
                            end
                        end
                    end
                end
            end
        end
    end
})

local Lighting = game:GetService("Lighting")
local RainbowEffect = false
local RainbowBlur = nil
local RainbowColor = nil

Tabs.ChoiDo:AddToggle("ToggleRainbowEffect", {
    Title = "🌈 Ảo giác cầu vồng",
    Default = false,
    Description = "Hiệu ứng 7 sắc cầu vồng trên màn hình"
}):OnChanged(function(Value)
    RainbowEffect = Value

    if not Value then
        -- Xoá hiệu ứng nếu có
        if RainbowBlur then
            RainbowBlur:Destroy()
            RainbowBlur = nil
        end
        if RainbowColor then
            RainbowColor:Destroy()
            RainbowColor = nil
        end
    end
end)

-- Hiệu ứng đổi màu liên tục
task.spawn(function()
    local hue = 0
    while true do
        task.wait(0.1)

        if RainbowEffect then
            -- Tạo Blur nếu chưa có
            if not RainbowBlur then
                RainbowBlur = Instance.new("BlurEffect")
                RainbowBlur.Size = 8 -- hoặc 12 tuỳ bạn
                RainbowBlur.Name = "RainbowBlur"
                RainbowBlur.Parent = Lighting
            end

            -- Tạo ColorCorrection nếu chưa có
            if not RainbowColor then
                RainbowColor = Instance.new("ColorCorrectionEffect")
                RainbowColor.Name = "RainbowColor"
                RainbowColor.Saturation = 1
                RainbowColor.Contrast = 0.2
                RainbowColor.Parent = Lighting
            end

            -- Đổi màu cầu vồng liên tục
            hue = (hue + 3) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)
            RainbowColor.TintColor = color
        end
    end
end)

local Toggle3 = Tabs.Pvp:AddToggle("Script PvP", {
    Title = "Script PvP",
    Default = false 
})

Toggle3:OnChanged(function(Value)
    if Value then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/qthai1508/qthaimedusatest/blob/main/pvp.lua"))()
        end)
    end
end)

--// ========================== TIỆN ÍCH CHUNG ================================
--- ANTI AFK 20 PHÚT
spawn(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
	end)
end)

---------------------------------------------------------------------------------------
----Job Gỗ---
--// ========================== CHỨC NĂNG FRAM GỖ ==========================
local toolName       = "Rìu"
-- Flags
local runningAxeLoop = false

--// Hàm mua Rìu khi hết
local function PurchaseAxe()
	local invGui = player:WaitForChild("PlayerGui")
		:WaitForChild("Inventory")
		:WaitForChild("MainFrame")
		:WaitForChild("Container")
		:WaitForChild("Main")
		:WaitForChild("ToolList")
		:WaitForChild("ScrollingFrame")
	local hasAxe = invGui:FindFirstChild(toolName)
	if not hasAxe then
		local shopService = Rep:WaitForChild("KnitPackages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("ShopService")
			:WaitForChild("RE")
			:WaitForChild("buyItem")
		shopService:FireServer(toolName, 99)
		task.wait(1)
	end
end

--// Hàm Request tool từ server (nếu thiếu)
local function RequestToolFromServer()
	local invService = Rep:WaitForChild("KnitPackages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("InventoryService")
		:WaitForChild("RE")
		:WaitForChild("updateInventory")
	invService:FireServer("eue", toolName)
end

--// Check & equip, mua nếu hết
local function CheckAndEquipAxe()
	local char      = player.Character
	local backpack  = player:FindFirstChild("Backpack")
	local humanoid  = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and humanoid and backpack) then return end

	local currentTool    = char:FindFirstChildOfClass("Tool")
	local axeInBackpack  = backpack:FindFirstChild(toolName)

	if (not currentTool or currentTool.Name ~= toolName) and not axeInBackpack then
		RequestToolFromServer()
		task.wait(0.5)
		axeInBackpack = backpack:FindFirstChild(toolName)

		if not axeInBackpack then
			PurchaseAxe()
			axeInBackpack = backpack:FindFirstChild(toolName)
		end
	end

	if axeInBackpack then
		humanoid:EquipTool(axeInBackpack)
	end
end

--// Auto-equip loop
local function StartAutoEquipLoop()
	if runningAxeLoop then return end
	runningAxeLoop = true
	task.spawn(function()
		while _G.AutoEquipAxe do
			CheckAndEquipAxe()
			task.wait(0.1)
		end
		runningAxeLoop = false
	end)
end

--// Arrow Minigame Helpers
local rotationToKey = { [0]=Enum.KeyCode.Right, [90]=Enum.KeyCode.Down, [180]=Enum.KeyCode.Left, [270]=Enum.KeyCode.Up }
local function normalizeRotation(rot)
	return (math.floor((rot % 360) / 90 + 0.5) * 90) % 360
end
local function doArrowSequence()
	local gui       = player:WaitForChild("PlayerGui")
	local arrowGui  = gui:WaitForChild("ArrowMinigame")
	local listFrame = arrowGui:WaitForChild("Arrow"):WaitForChild("List")

	for i = 1, 5 do
		local frame = listFrame:FindFirstChild(tostring(i))
		local img   = frame and frame:FindFirstChild("ImageLabel")
		if img then
			local rot = normalizeRotation(img.Rotation)
			local key = rotationToKey[rot]
			if key then
				VIM:SendKeyEvent(true, key, false, game)
				task.wait(0.05)
				VIM:SendKeyEvent(false, key, false, game)
				task.wait(0.1)
			end
		end
	end

	task.wait(3)
	VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	task.wait(0.05)
	VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local arrowWatcherConn, runningArrow = nil, false
local function setupArrowWatcher()
	if runningArrow then return end
	runningArrow = true
	local gui      = player:WaitForChild("PlayerGui")
	local arrowGui = gui:WaitForChild("ArrowMinigame")

	if arrowGui.Enabled then doArrowSequence() end
	arrowWatcherConn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if _G.AutoArrowMinigame and arrowGui.Enabled then
			doArrowSequence()
		end
	end)
end

local function disconnectArrowWatcher()
	if arrowWatcherConn then
		arrowWatcherConn:Disconnect()
		arrowWatcherConn = nil
	end
	runningArrow = false
end

--// Chop & Sell Helpers
local isSelling, isCutting, chopSellLoopRunning = false, false, false
local chopSellDisconnect

local function holdKey(keyCode, duration, prompt)
	local startTime = tick()
	while tick() - startTime < duration do
		-- kiểm tra prompt còn tồn tại
		if prompt then
			local ok = prompt.Parent and prompt:IsDescendantOf(game)
			if ok and prompt:IsA("ProximityPrompt") then
				if not prompt.Enabled then ok = false end
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp and prompt.MaxActivationDistance then
					local part = prompt.Parent:IsA("BasePart") and prompt.Parent
						or prompt:FindFirstAncestorWhichIsA("BasePart")
					if part and (hrp.Position - part.Position).Magnitude > (prompt.MaxActivationDistance + 2) then
						ok = false
					end
				end
			else
				ok = false
			end
			if not ok then break end
		end
		VIM:SendKeyEvent(true, keyCode, false, game)
		task.wait(0.1)
	end
	VIM:SendKeyEvent(false, keyCode, false, game)
end

local function waitForArrowMinigameFinish()
	if not _G.AutoArrowMinigame then return end
	local gui      = player:FindFirstChild("PlayerGui")
	local arrowGui = gui and gui:FindFirstChild("ArrowMinigame")
	if not arrowGui then return end

	local start = tick()
	while not arrowGui.Enabled and tick() - start < 5 do task.wait(0.05) end
	if not arrowGui.Enabled then return end

	local finished = false
	local conn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not arrowGui.Enabled then finished = true end
	end)

	local finishStart = tick()
	while arrowGui.Enabled and not finished and tick() - finishStart < 10 do
		task.wait(0.05)
	end
	conn:Disconnect()
end

local function getChopSellRefs()
	local ok, refs = pcall(function()
		local gui    = player:WaitForChild("PlayerGui")
		local Trees  = WS:WaitForChild("Lumberjack"):WaitForChild("Trees")
		local Sell   = WS:WaitForChild("Lumberjack"):WaitForChild("Sell"):WaitForChild("Part")
		local char   = player.Character or player.CharacterAdded:Wait()
		local hrp    = char:WaitForChild("HumanoidRootPart")
		local label  = gui:WaitForChild("TopbarStandard")
			.Holders.Left.logCount.IconButton.Menu
			.IconSpot.Contents.IconLabelContainer:WaitForChild("IconLabel")
		return { Trees = Trees, SellPart = Sell, HRP = hrp, label = label }
	end)
	return ok and refs or nil
end

local recentlyChopped     = {}
local RECENTLY_TIMEOUT    = 60
local function cleanupRecentlyChopped()
	local now = tick()
	for tree, t in pairs(recentlyChopped) do
		if now - t > RECENTLY_TIMEOUT then
			recentlyChopped[tree] = nil
		end
	end
end

local function chopTreesLoop(refs)
	isCutting = true
	while _G.AutoChopSell and not isSelling do
		local found = false
		for _, tree in ipairs(refs.Trees:GetChildren()) do
			if not _G.AutoChopSell or isSelling then break end
			local last = recentlyChopped[tree]
			if last and tick() - last < RECENTLY_TIMEOUT then
				continue
			end
			local prompt = tree:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled then
				local part = prompt.Parent:IsA("BasePart") and prompt.Parent
					or prompt:FindFirstAncestorWhichIsA("BasePart")
				if part then
					refs.HRP.CFrame = part.CFrame + Vector3.new(0, 3, 0)
					task.wait(0.5)
					holdKey(Enum.KeyCode.F, prompt.HoldDuration or 1.5, prompt)
					waitForArrowMinigameFinish()
					task.wait(0.5)
					recentlyChopped[tree] = tick()
					cleanupRecentlyChopped()
					found = true
					break
				end
			end
		end
		if not found then task.wait(0.5) end
	end
	isCutting = false
end

local function startChopSellLoop()
	if chopSellLoopRunning then return end
	chopSellLoopRunning = true

	task.spawn(function()
		local refs = getChopSellRefs()
		if not refs then chopSellLoopRunning = false return end

		local labelConn
		labelConn = refs.label:GetPropertyChangedSignal("Text"):Connect(function()
			if isSelling or not _G.AutoChopSell then return end
			local count = tonumber(string.match(refs.label.Text, "Số lượng gỗ đã nhặt:%s*(%d+)"))
			if count and count >= 15 then
				isSelling = true
				refs.HRP.CFrame = refs.SellPart.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.5)
				local prompt = refs.SellPart:FindFirstChildWhichIsA("ProximityPrompt", true)
				if prompt and prompt.Enabled then
					holdKey(Enum.KeyCode.E, prompt.HoldDuration or 1.5, prompt)
				end
				task.wait(1)
				isSelling = false
				if not isCutting and _G.AutoChopSell then
					task.delay(0.5, function() chopTreesLoop(refs) end)
				end
			end
		end)

		chopSellDisconnect = function()
			if labelConn then labelConn:Disconnect() end
			chopSellLoopRunning = false
		end

		task.delay(1, function()
			if _G.AutoChopSell then chopTreesLoop(refs) end
		end)

		while _G.AutoChopSell do task.wait(1) end
		if chopSellDisconnect then chopSellDisconnect() end
	end)
end

local function stopChopSellLoop()
	_G.AutoChopSell = false
	isSelling, isCutting, chopSellLoopRunning = false, false, false
	if chopSellDisconnect then chopSellDisconnect() end
end

Tabs.FarmTien:AddParagraph({
	Title = "Hướng dẫn Farm Gỗ",
	Content = "Vào khu vực farm gỗ , bật auto farm lên , rồi ok bú đi -)"
})


--// Toggle Auto Arrow Minigame
Tabs.FarmTien:AddToggle("FullWoodFarm", {
    Title = "🪓 Auto Farm Gỗ Full",
    Default = false,
    Callback = function(state)
        -- Bật cả 3 chức năng phụ
        _G.AutoEquipAxe = state
        _G.AutoArrowMinigame = state
        _G.AutoChopSell = state

        if state then
            StartAutoEquipLoop()
            setupArrowWatcher()
            startChopSellLoop()
        else
            disconnectArrowWatcher()
            stopChopSellLoop()
        end
    end
})

---------------------------------------------------------------------------------
--------------------------- GIAO HÀNG--------------------------------------------
-- ⚙️ Cấu hình
local isAutoDeliver = false
local autoDeliverThread = nil
local Speed = 60 -- tốc độ bay (stud/giây)

-- 📦 Dịch vụ
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = Character:WaitForChild("HumanoidRootPart")

-- 🌀 Hàm bay mượt đến vị trí
local function TweenTo(pos)
	local dist = (rootPart.Position - pos).Magnitude
	if dist > 2 then
		local info = TweenInfo.new(dist / Speed, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(rootPart, info, {
			CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
		})
		tween:Play()
		tween.Completed:Wait()
	end
end

-- 🔘 Tương tác ProximityPrompt gần nhất
local function pressNearestPrompt(maxDistance)
	local closestPrompt, shortest = nil, maxDistance or 10
	for _, prompt in Workspace:GetDescendants() do
		if prompt:IsA("ProximityPrompt") and prompt.Enabled then
			local adornee = prompt.Parent
			if adornee:IsA("BasePart") and adornee:IsDescendantOf(Workspace.GrabDelivery) then
				local dist = (rootPart.Position - adornee.Position).Magnitude
				if dist < shortest then
					shortest = dist
					closestPrompt = prompt
				end
			end
		end
	end
	if closestPrompt then
		closestPrompt.HoldDuration = 0
		fireproximityprompt(closestPrompt)
		print("✅ Đã tương tác prompt:", closestPrompt:GetFullName())
		return true
	end
	warn("⚠️ Không tìm thấy prompt để tương tác")
	return false
end

-- 🔍 Tìm đúng điểm giao hàng (tìm part có con tên GrabEnd_)
local function findGrabEndPart(DeliveryPoints)
	for _, part in DeliveryPoints:GetDescendants() do
		if part:IsA("BasePart") then
			for _, child in part:GetChildren() do
				if typeof(child.Name) == "string" and string.match(child.Name, "^GrabEnd_") then
					return part
				end
			end
		end
	end
	return nil
end

-- 🚚 Chức năng giao hàng tự động
local function autoDeliverFunc()
	while isAutoDeliver do
		task.wait(2)

		local GrabDelivery = Workspace:FindFirstChild("GrabDelivery")
		if not GrabDelivery then warn("⛔ Không tìm thấy GrabDelivery") continue end

		local Box = GrabDelivery:FindFirstChild("Box")
		local DeliveryPoints = GrabDelivery:FindFirstChild("DeliveryPoints")
		if not (Box and DeliveryPoints) then warn("⛔ Thiếu Box hoặc DeliveryPoints") continue end

		local startPart = Box:FindFirstChild("Start")
		if not startPart then warn("⛔ Không tìm thấy điểm Start") continue end

		-- 🛫 1. Bay đến nhận hàng
		print("🛫 Bay đến nhận hàng...")
		TweenTo(startPart.Position)
		task.wait(1)

		-- 📦 2. Nhận hàng
		print("📦 Nhận hàng...")
		local got = pressNearestPrompt(15)
		if not got then warn("⛔ Không nhận được hàng") continue end
		task.wait(1.5)

		-- 🚀 3. Bay đến giao hàng
		local deliveryPart = findGrabEndPart(DeliveryPoints)
		if deliveryPart then
			print("📍 Điểm giao:", deliveryPart:GetFullName(), deliveryPart.Position)
			print("🚚 Bay đến giao hàng...")
			TweenTo(deliveryPart.Position)
			task.wait(0.5)

			-- ✅ 4. Giao hàng
			print("✅ Giao hàng...")
			task.wait(0.3)
			local success = pressNearestPrompt(25)
			if not success then
				warn("❌ Không tương tác được prompt giao hàng")
			end
			task.wait(2)
		else
			warn("⛔ Không tìm thấy điểm GrabEnd_ để giao.")
		end
	end

	-- 🔁 Kết thúc vòng lặp
	autoDeliverThread = nil
end

-- 🧾 Ghi chú hiển thị dưới toggle
Tabs.FarmTien:AddParagraph({
	Title = "Hướng dẫn Giao Hàng",
	Content = "Giao hàng còn đang fix ae không nên dùng nhé , lúc được lúc không ráng chờ xíuu"
})

-- 🔘 Nút bật/tắt Auto Giao
local autoDeliverToggle = Tabs.FarmTien:AddToggle("AutoDeliverToggle", {
	Title = "🚚 Auto Giao Hàng (Beta còn lỗi)",
	Default = false
}):OnChanged(function(state)
	isAutoDeliver = state
	if isAutoDeliver and not autoDeliverThread then
		autoDeliverThread = task.spawn(autoDeliverFunc)
	end
end)




