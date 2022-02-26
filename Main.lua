_G.Toggle = true
_G.Debug = false
_G.DebugLot = ""

local function sprint(Txt,Clr3)
	local Status = script.Parent.MainF.Status
	Status.Text = Txt
	if Clr3 then
		Status.TextColor3 = Clr3
	end
end

local RS = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer
local CurLot = script.Parent.CurLot
local TotFires = 0

local LotLocs = {
	["burn1Lot"] = CFrame.new(Vector3.new(7948, 21, 146), Vector3.new(-0.997168362, -6.08767365, 0.0752015486)),
	["burn2Lot"] = CFrame.new(Vector3.new(7771, 22, -246), Vector3.new(1, -4.2536513, -2.44584207)),
	["burn3Lot"] = CFrame.new(Vector3.new(7597, 22, -599), Vector3.new(-0.994129956, 5.51916344, 0.10819231)),
	["burn4Lot"] = CFrame.new(Vector3.new(6708, 23, 3747), Vector3.new(-0.999998748, -4.9789235, -0.00156937528)),
	["burn5Lot"] = CFrame.new(Vector3.new(2278, 23, 2840), Vector3.new(-0.998562038, 2.95421163, 0.0536083542)),
	["burn6Lot"] = CFrame.new(Vector3.new(2690, 23, 1071), Vector3.new(-0.0617179647, -1.07858353, 0.998093605)),
	["burn7Lot"] = CFrame.new(Vector3.new(2164, 22, -1601), Vector3.new(0.991271257, 5.3023399, -0.131838113)),
	["burn8Lot"] = CFrame.new(Vector3.new(-2343, 22, -3193), Vector3.new(-0.999505222, 4.99192332, 0.0314525887)),
	["burn9Lot"] = CFrame.new(Vector3.new(-1961, 22, -5873), Vector3.new(0.0635205433, -6.49538805, 0.997980535)),
	["burn10Lot"] = CFrame.new(Vector3.new(8879, 22, -3328), Vector3.new(-0.0582940169, 1.22769572, 0.998299479)),
	["burn11Lot"] = CFrame.new(Vector3.new(-2416, 22, -5474), Vector3.new(-0.99537003, 5.15047986, -0.0961168632))
}

--Anti-AFK
local VirtualUser=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--Functions

local function FindCar()
	for i,v in pairs(game:GetService("Workspace").Cars:GetChildren()) do
		if v.PlayerLoc.Value.Name == Player.Name then
			return v
		end
	end
end

local function FindFire()
	local Lots = game:GetService("Workspace").BurnSystem.BurnLots:GetChildren()
	for i,v in pairs(Lots) do
		if v.fireActive.Value == true then
			sprint("Fire!",Color3.fromRGB(19, 202, 16))
			return v
		end
	end
end

--Main Loop

if _G.Debug == false then
	repeat
		sprint("Searching...",Color3.fromRGB(255, 195, 15))
		CurLot.Value = nil
		local Char = Player.Character
		local Lot = FindFire()
		if Lot then
			CurLot.Value = Lot
			script.Parent.MainF.StatLot.Text = Lot.Name
			if Char then
				sprint("Teleporting...",Color3.fromRGB(19, 202, 16))
				Char.HumanoidRootPart.Anchored = true
				Char.HumanoidRootPart.CFrame = LotLocs[Lot.Name] * CFrame.new(0,0,0)
				game:GetService("ReplicatedStorage").SpawnCar:FireServer("requestSpawn","fF450FD",LotLocs[Lot.Name])
				Char.HumanoidRootPart.Anchored = false
			end
			local FirePart = Lot.fireParts:FindFirstChildOfClass("Part")
			if FirePart then
				local Car = FindCar()
				if Car then
					fireclickdetector(Car.Body.hTouch1.ClickDetector)
					Char.Humanoid:EquipTool(Player.Backpack:FindFirstChild('Water Hose'))
					sprint("Extinguishing...",Color3.fromRGB(19, 202, 16))
					repeat
						if Char:FindFirstChild("Water Hose") then
							Char:FindFirstChild("Water Hose").RemoteEvent:FireServer("Fire",FirePart)
						else
							sprint("HOSE UNEQUIPPED",Color3.fromRGB(226, 9, 9))
							wait(3)
						end
						wait()
					until Lot.fireActive.Value == false or _G.Toggle == false
					if Char then
						Char.Humanoid:UnequipTools()
					end
					sprint("Fire is Out",Color3.fromRGB(191, 255, 15))
					TotFires = TotFires + 1
					script.Parent.MainF.StatFires.Val.Text = tostring(TotFires)
					wait(2)
				end
			end
		end
		wait(1)
	until _G.Toggle == false
else
	local Char = Player.Character
	if Char then
		sprint("Teleporting...",Color3.fromRGB(19, 202, 16))
		local Lot = _G.DebugLot
		Char.HumanoidRootPart.Anchored = true
		Char.HumanoidRootPart.CFrame = LotLocs[Lot] * CFrame.new(0,0,0)
		game:GetService("ReplicatedStorage").SpawnCar:FireServer("requestSpawn","fF450FD",LotLocs[Lot])
		Char.HumanoidRootPart.Anchored = false
	end
end