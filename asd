-- Autoclick UI Minimalis (Toggle) - TapRequested
-- Jenis  : LocalScript
-- Letak  : StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- ===== Pengaturan =====
local DEFAULT_INTERVAL = 0.1
local MIN_INTERVAL = 0.03

-- ===== Remote =====
local TapEvent = ReplicatedStorage
	:WaitForChild("RemoteServices")
	:WaitForChild("TapService")
	:WaitForChild("RE")
	:WaitForChild("TapRequested")

-- ===== Aksi klik =====
-- Jika TapController mengirim argumen, tambahkan di dalam FireServer(...)
local function doClick()
	pcall(function()
		TapEvent:FireServer()
	end)
end

-- ===== Warna =====
local BG = Color3.fromRGB(17, 17, 17)
local FIELD = Color3.fromRGB(28, 28, 28)
local TEXT = Color3.fromRGB(230, 230, 230)
local MUTED = Color3.fromRGB(130, 130, 130)
local ACCENT = Color3.fromRGB(74, 222, 128)
local OFF = Color3.fromRGB(55, 55, 55)

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "AutoclickUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 112)
frame.Position = UDim2.new(0, 20, 0.5, -56)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local function makeLabel(text, size, pos, color, font, align)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos
	l.Text = text
	l.TextColor3 = color
	l.Font = font or Enum.Font.Gotham
	l.TextSize = 12
	l.TextXAlignment = align or Enum.TextXAlignment.Center
	l.Parent = frame
	return l
end

local title = makeLabel("Autoclick", UDim2.new(1, 0, 0, 26), UDim2.new(0, 0, 0, 0), MUTED, Enum.Font.GothamMedium)
title.Active = true

makeLabel("Interval (detik)", UDim2.new(0, 100, 0, 22), UDim2.new(0, 12, 0, 30), MUTED, nil, Enum.TextXAlignment.Left)
local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(52, 22)
box.Position = UDim2.new(1, -64, 0, 30)
box.BackgroundColor3 = FIELD
box.BorderSizePixel = 0
box.Text = tostring(DEFAULT_INTERVAL)
box.TextColor3 = TEXT
box.Font = Enum.Font.Gotham
box.TextSize = 12
box.ClearTextOnFocus = false
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)

makeLabel("Aktif", UDim2.new(0, 100, 0, 24), UDim2.new(0, 12, 0, 62), TEXT, nil, Enum.TextXAlignment.Left)

local track = Instance.new("TextButton")
track.Size = UDim2.fromOffset(44, 22)
track.Position = UDim2.new(1, -56, 0, 63)
track.BackgroundColor3 = OFF
track.BorderSizePixel = 0
track.Text = ""
track.AutoButtonColor = false
track.Parent = frame
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(16, 16)
knob.Position = UDim2.fromOffset(3, 3)
knob.BackgroundColor3 = TEXT
knob.BorderSizePixel = 0
knob.Parent = track
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local status = makeLabel("Siap", UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 1, -24), MUTED)

-- ===== Logika =====
local running = false
local count = 0
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

local function getInterval()
	local n = tonumber(box.Text) or DEFAULT_INTERVAL
	n = math.max(MIN_INTERVAL, n)
	box.Text = tostring(n)
	return n
end

local function setRunning(state)
	running = state

	TweenService:Create(track, tweenInfo, {
		BackgroundColor3 = running and ACCENT or OFF,
	}):Play()
	TweenService:Create(knob, tweenInfo, {
		Position = running and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3),
	}):Play()

	if running then
		count = 0
		status.Text = "Berjalan"
		local interval = getInterval()
		task.spawn(function()
			while running do
				doClick()
				count += 1
				status.Text = "Berjalan • " .. count .. " klik"
				task.wait(interval)
			end
		end)
	else
		status.Text = "Berhenti • " .. count .. " klik"
	end
end

track.MouseButton1Click:Connect(function()
	setRunning(not running)
end)

-- ===== Drag jendela =====
local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
