local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("MinimalAutoClicker") then
    playerGui.MinimalAutoClicker:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinimalAutoClicker"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 90)
mainFrame.Position = UDim2.new(0.5, -100, 0.8, -45)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Auto Clicker"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 14
titleLabel.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.85, 0, 0, 35)
toggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = false
toggleButton.Font = Enum.Font.GothamMedium
toggleButton.Text = "Status: OFF"
toggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
toggleButton.TextSize = 13
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleButton

local autoClickEnabled = false
local clickDelay = 0.05

task.spawn(function()
    while true do
        if autoClickEnabled then
            pcall(function()
                if mouse1click then
                    mouse1click()
                else
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
        task.wait(clickDelay)
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    
    if autoClickEnabled then
        toggleButton.Text = "Status: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        toggleButton.Text = "Status: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        toggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)
