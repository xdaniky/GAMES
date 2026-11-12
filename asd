-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "Xdaniky HUB : Tap Simulator",
   LoadingTitle = "Loading Scanner Hub...",
   LoadingSubtitle = "Auto-Detect & Fix",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

-- Create Tabs
local FarmTab = Window:CreateTab("Egg Farm", "egg")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Variables
getgenv().AutoFarmEgg = false
getgenv().SelectedEgg = nil
local eggNames = {}
local eggObjects = {}

-- 1. Fungsi Scan Telur yang Lebih Luas & Cerdas
local function ScanEggs()
    table.clear(eggNames)
    table.clear(eggObjects)
    
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if eggsFolder then
        -- Scan semua folder telur di dalam workspace.Eggs
        for _, category in ipairs(eggsFolder:GetChildren()) do
            -- Jika kategori berisi telur langsung atau sub-folder
            if category:IsA("Folder") or category:IsA("Model") then
                -- Cek apakah kategori ini sendiri adalah telur (punya Egg atau part teleport)
                if category:FindFirstChild("Egg") or category:FindFirstChild("2") or category:FindFirstChild("PriceTag") then
                    local eggName = category.Name
                    table.insert(eggNames, eggName)
                    eggObjects[eggName] = category
                else
                    -- Jika berupa sub-folder (misal: World1, World2, dll)
                    for _, subEgg in ipairs(category:GetChildren()) do
                        if subEgg:IsA("Folder") or subEgg:IsA("Model") then
                            local eggName = category.Name .. " - " .. subEgg.Name
                            table.insert(eggNames, eggName)
                            eggObjects[eggName] = subEgg
                        end
                    end
                end
            end
        end
    end
    
    if #eggNames == 0 then
        table.insert(eggNames, "Tidak ada telur ditemukan")
    end
end

ScanEggs()

-- 2. Combined Auto Teleport & Hatch Loop
task.spawn(function()
    while true do
        if getgenv().AutoFarmEgg and getgenv().SelectedEgg then
            pcall(function()
                local targetEgg = eggObjects[getgenv().SelectedEgg]
                if targetEgg then
                    -- Cari bagian untuk teleport (prioritas: part "2", lalu "Egg", lalu primary part)
                    local teleportPart = targetEgg:FindFirstChild("2") 
                        or targetEgg:FindFirstChild("Egg") 
                        or targetEgg:FindFirstChild("Hitbox") 
                        or targetEgg.PrimaryPart 
                        or targetEgg:FindFirstChildWhichIsA("BasePart")
                    
                    local character = LocalPlayer.Character
                    if teleportPart and character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
                    end

                    -- Coba cari dan temukan Remote Event untuk membeli telur secara otomatis di seluruh ReplicatedStorage
                    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
                        if descendant:IsA("RemoteEvent") and (string.find(descendant.Name:lower(), "egg") or string.find(descendant.Name:lower(), "buy")) then
                            -- Bersihkan nama telur jika menggunakan format kategori (misal "Heaven - Egg" jadi "Heaven")
                            local cleanEggName = string.match(getgenv().SelectedEgg, ".*fleshed (.*)") or getgenv().SelectedEgg
                            cleanEggName = string.gsub(cleanEggName, ".*%- ", "")
                            
                            descendant:FireServer(cleanEggName, 1)
                            descendant:FireServer(cleanEggName, "Normal")
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- UI COMPONENTS --
FarmTab:CreateDropdown({
   Name = "Pilih Telur (Auto-Detected)",
   Options = eggNames,
   CurrentOption = eggNames[1] or "None",
   Flag = "EggDropdown",
   Callback = function(Option)
      getgenv().SelectedEgg = Option
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
         Content = Value and ("Memulai farming: " .. tostring(getgenv().SelectedEgg)) or "Farm Dimatikan",
         Duration = 2,
      })
   end,
})

FarmTab:CreateButton({
   Name = "Refresh Daftar Telur",
   Callback = function()
      ScanEggs()
      Rayfield:Notify({
         Title = "Diperbarui",
         Content = "Daftar telur berhasil di-scan ulang!",
         Duration = 2,
      })
   end,
})

SettingsTab:CreateButton({
   Name = "Toggle UI (Buka/Tutup)",
   Callback = function()
      Rayfield:ToggleUI()
   end,
})

Rayfield:Notify({
   Title = "Xdaniky HUB",
   Content = "Script siap digunakan!",
   Duration = 3,
})
