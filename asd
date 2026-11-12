-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "xdaniky | Tap Simulator",
   LoadingTitle = "Loading Tap Simulator...",
   LoadingSubtitle = "Heaven Egg Automation",
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
getgenv().HeavenFarm = false -- 1 Tombol untuk Teleport + Hatch sekaligus
local ClickDelay = 0.1
local clientSequenceCounter = 2

-- 1. Auto Click Function (Tap Service)
local function SendTap()
    pcall(function()
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

-- 2. Combined Auto Teleport & Hatch Loop (Heaven Egg)
task.spawn(function()
    while true do
        if getgenv().HeavenFarm then
            pcall(function()
                -- A. Teleport to Heaven Egg part "2"
                local eggPart = Workspace.Eggs.Heaven["2"]
                local character = LocalPlayer.Character
                if eggPart and character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                end

                -- B. Try firing Egg Purchase Remote
                local remoteFolder = ReplicatedStorage:FindFirstChild("RemoteServices")
                if remoteFolder then
                    -- Cek berbagai kemungkinan nama folder/remote untuk Egg
                    local eggService = remoteFolder:FindFirstChild("EggService") or remoteFolder:FindFirstChild("Eggs")
                    if eggService then
                        local re = eggService:FindFirstChild("RE") or eggService:FindFirstChild("Remote") or eggService
                        for _, child in ipairs(re:GetChildren()) do
                            if child:IsA("RemoteEvent") then
                                -- Fire remote dengan argumen umum pembelian telur simulator
                                child:FireServer("Heaven", 1)
                                child:FireServer("Heaven Egg", 1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
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

-- Tab 2: Egg Farm (Gabungan Teleport + Hatch)
FarmTab:CreateToggle({
   Name = "Auto Farm Heaven Egg (Teleport + Hatch)",
   CurrentValue = false,
   Flag = "HeavenFarmToggle",
   Callback = function(Value)
      getgenv().HeavenFarm = Value
      Rayfield:Notify({
         Title = "Heaven Farm",
         Content = Value and "Auto Teleport & Hatch Enabled!" or "Auto Farm Stopped",
         Duration = 2,
      })
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
   Content = "Combined Egg Farm ready to use!",
   Duration = 3,
})
```[cite: 1, 2, 3]

### Cara Cek Jika Masih Belum Mau Membuka Telur:
1. Tekan tombol **F9** di keyboard untuk membuka *Developer Console*.
2. Lihat apakah ada pesan atau error yang muncul saat Anda mengaktifkan toggle **Auto Farm Heaven Egg**.
