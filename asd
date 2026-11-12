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

-- Create Tabs (Tab Auto Click, Egg Farm, dan Settings)
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

-- 2. Fungsi Scan Semua Telur di workspace.Eggs
local function ScanEggs()
    table.clear(eggNames)
    table.clear(eggObjects)
    
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if eggsFolder then
        for _, item in ipairs(eggsFolder:GetChildren()) do
            if item:IsA("Folder") or item:IsA("Model") then
                table.insert(eggNames, item.Name)
                eggObjects[item.Name] = item
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

-- 3. Fungsi Gabungan Teleport + Auto Hatch
task.spawn(function()
    while true do
        if getgenv().AutoFarmEgg and getgenv().SelectedEgg then
            pcall(function()
                local targetEgg = eggObjects[getgenv().SelectedEgg]
                if targetEgg then
                    -- A. Cari bagian untuk Teleport
                    local targetCFrame = nil
                    local part2 = targetEgg:FindFirstChild("2")
                    local eggModel = targetEgg:FindFirstChild("Egg")
                    
                    if part2 and part2:IsA("BasePart") then
                        targetCFrame = part2.CFrame
                    elseif eggModel then
                        if eggModel:IsA("Model") then
                            targetCFrame = eggModel:GetPivot()
                        elseif eggModel:IsA("BasePart") then
                            targetCFrame = eggModel.CFrame
                        end
                    elseif targetEgg:IsA("Model") then
                        targetCFrame = targetEgg:GetPivot()
                    else
                        local anyPart = targetEgg:FindFirstChildWhichIsA("BasePart", true)
                        if anyPart then targetCFrame = anyPart.CFrame end
                    end

                    -- Eksekusi Teleport
                    local character = LocalPlayer.Character
                    if targetCFrame and character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 3, 2)
                    end

                    -- B. Eksekusi Pembelian Telur
                    for _, desc in ipairs(targetEgg:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            if fireproximityprompt then
                                fireproximityprompt(desc)
                            end
                        end
                    end

                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
        end
        task.wait(0.25)
    end
end)

-- UI COMPONENTS --
-- Tab 1: Auto Click (KEMBALI DISEDIAKAN)
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
   Name = "Pilih Telur (Auto-Detected)",
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
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm Telur (Teleport + Hatch)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      getgenv().AutoFarmEgg = Value
      Rayfield:Notify({
         Title = "Egg Farm",
         Content = Value and ("Farming: " .. tostring(getgenv().SelectedEgg)) or "Farm Dimatikan",
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
         Content = "Ditemukan " .. #eggNames .. " telur di workspace!",
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
   Content = "Auto Click & Egg Farm siap digunakan!",
   Duration = 3,
})
