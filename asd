-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "Xdaniky HUB : Tap Simulator",
   LoadingTitle = "Loading Dynamic Hub...",
   LoadingSubtitle = "Auto-Detect Eggs",
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
local LocalPlayer = Players.LocalPlayer

-- Variables
getgenv().AutoClicking = false
getgenv().SelectedEgg = nil
getgenv().AutoFarmEgg = false
local ClickDelay = 0.1
local clientSequenceCounter = 2

-- List untuk menyimpan nama-nama telur yang terdeteksi
local eggNames = {}
local eggFolders = {}

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

-- 2. Fungsi Otomatis Mendeteksi Telur di workspace.Eggs
local function ScanEggs()
    table.clear(eggNames)
    table.clear(eggFolders)
    
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if eggsFolder then
        for _, eggFolder in ipairs(eggsFolder:GetChildren()) do
            -- Cek apakah folder tersebut memiliki objek "Egg" atau bagian telepor/posisi
            if eggFolder:FindFirstChild("Egg") or eggFolder:FindFirstChild("2") then
                local eggName = eggFolder.Name
                table.insert(eggNames, eggName)
                eggFolders[eggName] = eggFolder
            end
        end
    end
    
    -- Jika tidak ada telur terdeteksi, masukkan placeholder agar UI tidak error
    if #eggNames == 0 then
        table.insert(eggNames, "None Found")
    end
end

-- Scan pertama kali saat script dijalankan
ScanEggs()

-- 3. Combined Auto Teleport & Hatch Loop untuk Telur yang Dipilih
task.spawn(function()
    while true do
        if getgenv().AutoFarmEgg and getgenv().SelectedEgg then
            pcall(function()
                local targetEggFolder = eggFolders[getgenv().SelectedEgg]
                if targetEggFolder then
                    -- Ambil bagian teleport (biasanya part "2" atau model "Egg")
                    local teleportPart = targetEggFolder:FindFirstChild("2") or targetEggFolder:FindFirstChild("Egg")
                    local character = LocalPlayer.Character
                    
                    if teleportPart and character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
                    end

                    -- Coba kirim remote pembelian telur
                    local remoteFolder = ReplicatedStorage:FindFirstChild("RemoteServices")
                    if remoteFolder then
                        local eggService = remoteFolder:FindFirstChild("EggService") or remoteFolder:FindFirstChild("Eggs")
                        if eggService then
                            local re = eggService:FindFirstChild("RE") or eggService:FindFirstChild("Remote") or eggService
                            for _, child in ipairs(re:GetChildren()) do
                                if child:IsA("RemoteEvent") then
                                    child:FireServer(getgenv().SelectedEgg, 1)
                                    child:FireServer(getgenv().SelectedEgg .. " Egg", 1)
                                end
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

-- Tab 2: Egg Farm (Dynamic Dropdown & Toggle)
FarmTab:CreateDropdown({
   Name = "Select Egg (Auto-Detected)",
   Options = eggNames,
   CurrentOption = eggNames[1] or "None",
   Flag = "EggDropdown",
   Callback = function(Option)
      getgenv().SelectedEgg = Option
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm Selected Egg (Teleport + Hatch)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      getgenv().HeavenFarm = Value -- dihubungkan ke variabel farm
      getgenv().AutoFarmEgg = Value
      Rayfield:Notify({
         Title = "Egg Farm",
         Content = Value and ("Farming: " .. tostring(getgenv().SelectedEgg)) or "Farm Stopped",
         Duration = 2,
      })
   end,
})

-- Tombol untuk Refresh daftar telur jika ada tambahan baru
FarmTab:CreateButton({
   Name = "Refresh Egg List",
   Callback = function()
      ScanEggs()
      Rayfield:Notify({
         Title = "Refreshed",
         Content = "Daftar telur berhasil diperbarui dari workspace!",
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
   Title = "Xdaniky HUB Loaded",
   Content = "Auto-detect eggs is ready!",
   Duration = 3,
})
