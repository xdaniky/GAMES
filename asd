-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "Xdaniky HUB : Tap Simulator",
   LoadingTitle = "Loading Xdaniky HUB...",
   LoadingSubtitle = "Tap Simulator",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "XdanikyHubConfig"
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
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Variables
getgenv().AutoClicking = false
getgenv().AutoFarmEgg = false
getgenv().SelectedEgg = nil
local ClickDelay = 0.1
local clientSequenceCounter = 2

local eggNames = {}
local eggObjects = {}

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

-- 2. Fungsi Scan Telur Berdasarkan Struktur Workspace.Eggs
local function ScanEggs()
    table.clear(eggNames)
    table.clear(eggObjects)
    
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if eggsFolder then
        for _, item in ipairs(eggsFolder:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Model") then
                local name = item.Name
                if name ~= "30M Visits" and (item:FindFirstChild("Egg") or item:FindFirstChild("PriceTag") or item:FindFirstChild("1") or item:FindFirstChild("2")) then
                    table.insert(eggNames, name)
                    eggObjects[name] = item
                end
            end
        end
    end
    
    table.sort(eggNames)
    if #eggNames == 0 then
        table.insert(eggNames, "None Found")
    else
        getgenv().SelectedEgg = eggNames[1]
    end
end

ScanEggs()

-- 3. Sistem 1x Teleport Lalu Auto Open (Tombol F)
local lastTeleportedEgg = nil

task.spawn(function()
    while true do
        if getgenv().AutoFarmEgg and getgenv().SelectedEgg then
            pcall(function()
                local targetEggFolder = eggObjects[getgenv().SelectedEgg]
                if targetEggFolder then
                    -- Teleport 1x saja saat mulai atau mengganti telur
                    if lastTeleportedEgg ~= getgenv().SelectedEgg then
                        local tpPart = targetEggFolder:FindFirstChild("2") 
                            or targetEggFolder:FindFirstChild("1") 
                            or targetEggFolder:FindFirstChild("PriceTag")
                        
                        local character = LocalPlayer.Character
                        if tpPart and tpPart:IsA("BasePart") and character and character:FindFirstChild("HumanoidRootPart") then
                            character.HumanoidRootPart.CFrame = tpPart.CFrame + Vector3.new(0, 3, 0)
                            lastTeleportedEgg = getgenv().SelectedEgg
                            task.wait(0.5)
                        end
                    end

                    -- Trigger ProximityPrompt jika ada
                    for _, desc in ipairs(targetEggFolder:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            if fireproximityprompt then
                                fireproximityprompt(desc)
                            end
                        end
                    end

                    -- Simulasi menekan tombol "F" secara otomatis untuk membuka/menyalakan Auto Hatch game
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            end)
        else
            lastTeleportedEgg = nil
        end
        task.wait(0.2)
    end
end)

-- UI COMPONENTS --
-- Tab 1: Auto Click
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
local EggDropdown = FarmTab:CreateDropdown({
   Name = "Pilih Telur",
   Options = eggNames,
   CurrentOption = {eggNames[1] or "None Found"},
   MultipleOptions = false,
   Flag = "EggDropdown",
   Callback = function(Options)
      if type(Options) == "table" then
          getgenv().SelectedEgg = Options[1]
      else
          getgenv().SelectedEgg = Options
      end
      lastTeleportedEgg = nil
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Hatch (Teleport + Spam F)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      getgenv().AutoFarmEgg = Value
      lastTeleportedEgg = nil
      Rayfield:Notify({
         Title = "Egg Farm",
         Content = Value and ("Farming Telur: " .. tostring(getgenv().SelectedEgg)) or "Farm Dimatikan",
         Duration = 2,
      })
   end,
})

FarmTab:CreateButton({
   Name = "Refresh Daftar Telur",
   Callback = function()
      ScanEggs()
      EggDropdown:Refresh(eggNames)
      Rayfield:Notify({
         Title = "Diperbarui",
         Content = "Berhasil memuat ulang daftar telur!",
         Duration = 2,
      })
   end,
})

-- Tab 3: Settings
SettingsTab:CreateButton({
   Name = "Toggle UI (Buka/Tutup)",
   Callback = function()
      Rayfield:ToggleUI()
   end,
})

-- Initial Notification
Rayfield:Notify({
   Title = "Xdaniky HUB Loaded",
   Content = "Auto Click & Auto Hatch (F) siap digunakan!",
   Duration = 3,
})
```[cite: 1, 2, 3, 7, 8]
