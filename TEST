loadstring(game:HttpGet("https://raw.githubusercontent.com/CeleryHub/CeleryHub/main/OnlyCelery.lua"))()
local Stats = game:GetService('Stats')

local Players = game:GetService('Players')

local RunService = game:GetService('RunService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Celery_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/CeleryHub/CeleryHub/main/CeleUtil.lua'))()

local local_player = Players.LocalPlayer

local camera = workspace.CurrentCamera

local celery_Data = nil

local hit_Sound = nil

local closest_Entity = nil

local parry_remote = nil
local hitsoundidagaugyg84ghun = "8706823799"
getgenv().aura_Enabled = false

getgenv().hit_sound_Enabled = false

getgenv().hit_effect_Enabled = false

getgenv().night_mode_Enabled = false

getgenv().trail_Enabled = false

getgenv().self_effect_Enabled = false

local Services = {

    game:GetService('AdService'),

    game:GetService('SocialService')

}

-- Shop Fractions

function SwordCrateManual()

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)

end

function ExplosionCrateManual()

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)

end

function SwordCrateAuto()

while _G.AutoSword do

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)

wait(1)

end

end

function ExplosionCrateAuto()

while _G.AutoBoom do

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)

wait(1)

end

end

-- Ui Library

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Blade Ball Celery", HidePremium = true, SaveConfig = true, ConfigFolder = "cElerytEst"})
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Tab2 = Window:MakeTab({
	Name = "Shop",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Tab3 = Window:MakeTab({
	Name = "Visuals",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
--[[
local Combat = Tab:NewSection("Combat")

local Shop = Tab2:NewSection("Shop")

local Visual = Tab3:NewSection("Visual")
]]

Tab3:AddDropdown({
	Name = "Hit Sounds",
	Default = "Chinese guy",
	Options = {"Chinese guy", "TF2 Wrench", "Fleshy", "annoying steel", "Roblox Sword"},
	Callback = function(Value)
        pcall(function()
		if Value == "Chinese guy" then
            game:GetService("CoreGui"):FindFirstChild('cele_temp').Sound.SoundId = "rbxassetid://8706823799"
        elseif Value == "TF2 Wrench" then
            game:GetService("CoreGui"):FindFirstChild('cele_temp').Sound.SoundId = "rbxassetid://5909769329"
        elseif Value == "Fleshy" then
            print('flesh')
            game:GetService("CoreGui"):FindFirstChild('cele_temp').Sound.SoundId = "rbxassetid://3802437361"
        elseif Value == "annoying steel" then
            print('steel')
            game:GetService("CoreGui"):FindFirstChild('cele_temp').Sound.SoundId = "rbxassetid://430304282"
        elseif Value == "Roblox Sword" then
            print('sword')
            game:GetService("CoreGui"):FindFirstChild('cele_temp').Sound.SoundId = "rbxassetid://12222225"
        end
    end)
	end    
})


function initializate(dataFolder_name: string)
    if not game:GetService("CoreGui"):FindFirstChild(dataFolder_name) then
        local celery_Data = Instance.new('Folder', game:GetService('CoreGui'))

        celery_Data.Name = dataFolder_name

        hit_Sound = Instance.new('Sound', celery_Data)

        hit_Sound.SoundId = 'rbxassetid://'..hitsoundidagaugyg84ghun

        hit_Sound.Volume = 5

    end
end
local function get_closest_entity(Object: Part)

    task.spawn(function()

        local closest

        local max_distance = math.huge

        for index, entity in workspace.Alive:GetChildren() do

            if entity.Name ~= Players.LocalPlayer.Name then

                local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude

                if distance < max_distance then

                    closest_Entity = entity

                    max_distance = distance

                end

            end

        end

        return closest_Entity

    end)

end

--// Thanks Aries for this.

function resolve_parry_Remote()

    for _, value in Services do

        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')

        if not temp_remote then

            continue

        end

        if not temp_remote.Name:find('\n') then

            continue

        end

        parry_remote = temp_remote

    end

end

local aura_table = {

    canParry = true,

    is_Spamming = false,

    parry_Range = 0,

    spam_Range = 0,  

    hit_Count = 0,

    hit_Time = tick(),

    ball_Warping = tick(),

    is_ball_Warping = false

}

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()

    if getgenv().hit_sound_Enabled then

        hit_Sound:Play()

    end

    if getgenv().hit_effect_Enabled then

        local hit_effect = game:GetObjects("rbxassetid://18894222844")[1]

        hit_effect.Parent = Celery_Util.getBall()

        hit_effect:Emit(3)

        

        task.delay(5, function()

            hit_effect:Destroy()

        end)

    end

end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()

    aura_table.hit_Count += 1

    task.delay(0.15, function()

        aura_table.hit_Count -= 1

    end)

end)

workspace:WaitForChild("Balls").ChildRemoved:Connect(function(child)

    aura_table.hit_Count = 0

    aura_table.is_ball_Warping = false

    aura_table.is_Spamming = false

end)

Tab:AddToggle({
	Name = "Auto Parry",
	Default = false,
	Callback = function(Value)
    resolve_parry_Remote()

    getgenv().aura_Enabled = Value

end
})

Tab3:AddToggle({
	Name = "Hit Sound",
	Default = false,
	Callback = function(toggled)

    getgenv().hit_sound_Enabled = toggled

end})

Tab:AddToggle({
	Name = "Hit Effect",
	Default = false,
	Callback = function(toggled)

    getgenv().hit_effect_Enabled = toggled

end})

Tab2:AddButton({
	Name = "Buy Sword Crate",
	Callback = function()
SwordCrateManual()
    print("Clicked")

end})

Tab2:AddButton({
	Name = "Buy Explosion Crate",
	Callback = function()

ExplosionCrateManual()

    print("Clicked")

end})

Tab3:AddToggle({
	Name = "Night/Day",
	Default = false,
	Callback = function(toggled)

    getgenv().night_mode_Enabled = toggled

end})
Tab3:AddToggle({
	Name = "Trail",
	Default = false,
	Callback = function(toggled)

    getgenv().trail_Enabled = toggled

end})

Tab3:AddToggle({
	Name = "Remove Particles",
    Default = false,
	Callback = function(cool)
    pcall(function()
    for _,v in pairs, game:GetDescendants() do
        if v:IsA("ParticleEmitter") and cool == true then
            v.Parent = nil
        end
    end
    game.DescendantAdded:Connect(function(x)
        if x:IsA("ParticleEmitter") and cool == true then
            x.Parent = nil
        end
    end)
end)
end})
--[[
Tab:AddButton({
	Name = "Aiming Mechanism",
	Callback = function()  
    --game:GetService("StarterGui"):SetCore("DevConsoleVisible",true)

warn("exed")

local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local Local = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local script = Local.Character:WaitForChild("BaseUIS")

local Held, Tap = {}, nil
UserInputService.InputBegan:Connect(function(input)
	local start = os.clock()
	if input.UserInputType == Enum.UserInputType.Touch then
		table.insert(Held, input)
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				local time = os.clock()-start
				if time <= 0.125 then
					Tap = input
				end
				table.remove(Held, table.find(Held, input))
			end
		end)
	end
end)

local old; old = hookmetamethod(game, "__namecall", function(self, ...)
	local args, method = {...}, getnamecallmethod()
	if method == "FireServer" and self.Name == "ParryAttempt" and Tap then
		local Hit = Tap
		--warn(unpack(args[4]))
		args[4][1] = math.floor(Hit.Position.X)
		args[4][2] = math.floor(Hit.Position.Y)
		--warn(unpack(args[4]))
		Tap = nil
	elseif method == "FireServer" and self.Name == "ParryAttempt" and not Tap then
		--warn("No Tap")
	end
	return old(self, unpack(args))
end)
end})
]]
--// trail

task.defer(function()

    game:GetService("RunService").Heartbeat:Connect(function()

        if not local_player.Character then

            return

        end

        if getgenv().trail_Enabled then

            local trail = game:GetObjects("rbxassetid://17483658369")[1]

            trail.Name = 'cel_fx'

            if local_player.Character.PrimaryPart:FindFirstChild('cel_fx') then

                return

            end

            local Attachment0 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            local Attachment1 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            Attachment0.Position = Vector3.new(0, -2.411, 0)

            Attachment1.Position = Vector3.new(0, 2.504, 0)

            trail.Parent = local_player.Character.PrimaryPart

            trail.Attachment0 = Attachment0

            trail.Attachment1 = Attachment1

        else

            

            if local_player.Character.PrimaryPart:FindFirstChild('cel_fx') then

                local_player.Character.PrimaryPart['cel_fx']:Destroy()

            end

        end

    end)

end)

--// night-mode

task.defer(function()

    while task.wait(1) do

        if getgenv().night_mode_Enabled then

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 3.9}):Play()

        else

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()

        end

    end

end)

--// aura

task.spawn(function()

    RunService.PreRender:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        if closest_Entity then

            if workspace.Alive:FindFirstChild(closest_Entity.Name) and workspace.Alive:FindFirstChild(closest_Entity.Name).Humanoid.Health > 0 then

                if aura_table.is_Spamming then

                    if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura_table.spam_Range then   

                        parry_remote:FireServer(

                            0.5,

                            CFrame.new(camera.CFrame.Position, Vector3.zero),

                            {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},

                            {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},

                            false

                        )

                    end

                end

            end

        end

    end)

    RunService.Heartbeat:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10

        local self = Celery_Util.getBall()

        if not self then

            return

        end

        self:GetAttributeChangedSignal('target'):Once(function()

            aura_table.canParry = true

        end)

        if self:GetAttribute('target') ~= local_player.Name or not aura_table.canParry then

            return

        end

        get_closest_entity(local_player.Character.PrimaryPart)

        local player_Position = local_player.Character.PrimaryPart.Position

        local ball_Position = self.Position

        local ball_Velocity = self.AssemblyLinearVelocity

        if self:FindFirstChild('zoomies') then

            ball_Velocity = self.zoomies.VectorVelocity

        end

        local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit

        local ball_Distance = local_player:DistanceFromCharacter(ball_Position)

        local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)

        local ball_Speed = ball_Velocity.Magnitude

        local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)

        local ball_predicted_Distance = (ball_Distance - ping / 15.5) - (ball_Speed / 3.5)

        local target_Position = closest_Entity.HumanoidRootPart.Position

        local target_Distance = local_player:DistanceFromCharacter(target_Position)

        local target_distance_Limited = math.min(target_Distance / 10000, 0.1)

        local target_Direction = (local_player.Character.PrimaryPart.Position - closest_Entity.HumanoidRootPart.Position).Unit

        local target_Velocity = closest_Entity.HumanoidRootPart.AssemblyLinearVelocity

        local target_isMoving = target_Velocity.Magnitude > 0

        local target_Dot = target_isMoving and math.max(target_Direction:Dot(target_Velocity.Unit), 0)

        aura_table.spam_Range = math.max(ping / 10, 15) + ball_Speed / 7

        aura_table.parry_Range = math.max(math.max(ping, 4) + ball_Speed / 3.5, 9.5)

        aura_table.is_Spamming = aura_table.hit_Count > 1 or ball_Distance < 13.5

        if ball_Dot < -0.2 then

            aura_table.ball_Warping = tick()

        end

        task.spawn(function()

            if (tick() - aura_table.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance <= 10 then

                aura_table.is_ball_Warping = false

                return

            end

            aura_table.is_ball_Warping = true

        end)

        if ball_Distance <= aura_table.parry_Range and not aura_table.is_Spamming and not aura_table.is_ball_Warping then

            parry_remote:FireServer(

                0.5,

                CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),

                {[closest_Entity.Name] = target_Position},

                {target_Position.X, target_Position.Y},

                false

            )

            aura_table.canParry = false

            aura_table.hit_Time = tick()

            aura_table.hit_Count += 1

            task.delay(0.15, function()

                aura_table.hit_Count -= 1

            end)

        end

        task.spawn(function()

            repeat

                RunService.Heartbeat:Wait()

            until (tick() - aura_table.hit_Time) >= 1

                aura_table.canParry = true

        end)

    end)

end)

initializate('cele_temp')
OrionLib:Init()
