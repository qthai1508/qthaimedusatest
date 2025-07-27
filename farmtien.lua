@@ -1,83 +1 @@
--// GUI ANTI-AFK NHỎ GỌN BY Medusa
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AntiAFK_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Active = true
Frame.Draggable = true

-- Toggle Button
local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0, 180, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.Text = "🔄 BẬT ANTI-AFK"
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 16
Toggle.BorderSizePixel = 0

-- Close Button
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 180, 0, 30)
Close.Position = UDim2.new(0, 10, 0, 60)
Close.Text = "❌ Ẩn Menu"
Close.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 16
Close.BorderSizePixel = 0

-- Mở lại Menu Button
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0, 350)
OpenBtn.Text = "📂 MỞ MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 14
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false

-- Logic bật/tắt
local AntiAFKEnabled = false
local Connection

Toggle.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    if AntiAFKEnabled then
        Toggle.Text = "✅ ĐÃ BẬT ANTI-AFK"
        Connection = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.5)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            print("💤 ANTI-AFK hoạt động!")
        end)
    else
        Toggle.Text = "🔄 BẬT ANTI-AFK"
        if Connection then Connection:Disconnect() end
    end
end)

-- Ẩn menu
Close.MouseButton1Click:Connect(function()
    Frame.Visible = false
    OpenBtn.Visible = true
end)

-- Hiện menu
OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    OpenBtn.Visible = false
end)
