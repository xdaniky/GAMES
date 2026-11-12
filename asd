-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window with "Tap Simulator" Subtitle
local Window = Rayfield:CreateWindow({
   Name = "xdaniky | Auto Clicker",
   LoadingTitle = "Loading Tap Simulator...",
   LoadingSubtitle = "Tap Simulator",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "TapSimulatorConfig"
   },
   KeySystem = false,
})

-- Create Tabs
local ClickerTab = Window:CreateTab("Auto Click", "mouse-pointer")
local FarmTab = Window:CreateTab("Egg Farm", "egg")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Variables
getgenv().AutoClicking = false
getgenv().AutoTeleport = false
getgenv().AutoHatch = false
local ClickDelay = 0.1
local clientSequenceCounter = 2

-- 1. Auto Click Function (Tap Service)
local function SendTap()
    local success, err = pcall(function()
        local remoteFolder = ReplicatedStorage:WaitForChild("RemoteServices", 5)
        local tapService = remoteFolder and remoteFolder:WaitForChild("TapService", 5)
        local reFolder = tapService and tapService:WaitForChild("RE", 5)
        local tapEvent = reFolder and reFolder:WaitForChild("TapRequested", 5)
        
        if tapEvent then
            clientSequenceCounter = clientSequenceCounter + 1
            tapEvent:FireServer({
                ClientSequence = clientSequenceCounter,
                Auto = false,
                Source = "screen"
            })
        end
    end)
end

task.spawn(function()
    while true do
        if getgenv().AutoClicking then
            SendTap()
            task.wait(ClickDelay)
        else
            task.wait(0.1)
        end
    end
end)

-- 2. Teleport Loop Function
task.spawn(function()
    while true do
        if getgenv().AutoTeleport then
            pcall(function()
                local eggPart = Workspace.Eggs.Heaven["2"]
                local character = LocalPlayer.Character
                if eggPart and character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- 3. Auto Hatch Function
task.spawn(function()
    while true do
        if getgenv().AutoHatch then
            pcall(function()
                local buyEggRemote = ReplicatedStorage:FindFirstChild("RemoteServices") 
                    and ReplicatedStorage.RemoteServices:FindFirstChild("EggService") 
                    and ReplicatedStorage.RemoteServices.EggService:FindFirstChild("RE") 
                    and ReryptedStorage.RemoteServices.EggService.RE:FindFirstChild("BuyEgg")

                if buyEggRemote then
                    buyEggRemote:FireServer("Heaven", 1)
                end
            end)
        end
        task.wait(0.3)
    end
end)

-- UI COMPONENTS --
-- Tab 1: Auto Clicker
ClickerTab:CreateToggle({
   Name = "Auto Click",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      getgenv().AutoClicking = Value
   end,
})

ClickerTab:CreateSlider({
   Name = "Click Delay (Seconds)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "ClickDelaySlider",
   Callback = function(Value)
      ClickDelay = Value
   end,
})

-- Tab 2: Egg Farm
FarmTab:CreateToggle({
   Name = "Auto Teleport to Heaven Egg",
   CurrentValue = false,
   Flag = "AutoTeleportToggle",
   Callback = function(Value)
      getgenv().AutoTeleport = Value
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Hatch Heaven Egg",
   CurrentValue = false,
   Flag = "AutoHatchToggle",
   Callback = function(Value)
      getgenv().AutoHatch = Value
   end,
})

-- Tab 3: Settings
SettingsTab:CreateButton({
   Name = "Toggle UI (Open/Close)",
   Callback = function()
      Rayfield:ToggleUI()
   end,
})

-- Initial Notification
Rayfield:Notify({
   Title = "Tap Simulator Loaded",
   Content = "UI & All features are ready to use!",
   Duration = 3,
})
