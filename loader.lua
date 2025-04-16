-- GUI + ESP + Teleport Fort + Auto Ambil Bonds
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local autoAmbilAktif = false

-- GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "UtilityGUI"
screenGui.ResetOnSpawn = false

local function createButton(name, posY, callback)
    local button = Instance.new("TextButton", screenGui)
    button.Size = UDim2.new(0, 220, 0, 30)
    button.Position = UDim2.new(0, 10, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.TextScaled = true
    button.MouseButton1Click:Connect(callback)
    return button
end

-- ESP Bonds
local function createESP(item)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESP"
    billboard.Adornee = item
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    billboard.Parent = item
end

local function enableESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Bonds" and not obj:FindFirstChild("ItemESP") then
            createESP(obj)
        end
    end
end

-- Teleport Fort
local function getForts()
    local forts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(obj.Name:lower(), "fort") then
            table.insert(forts, obj)
        end
    end
    return forts
end

local function smoothTeleport(pos)
    local dist = (HumanoidRootPart.Position - pos).Magnitude
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(math.clamp(dist/50,1,5)), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

local function teleportToForts()
    local forts = getForts()
    for _, fort in pairs(forts) do
        smoothTeleport(fort.Position + Vector3.new(0, 5, 0))
        wait(1)
    end
end

-- Tampilkan Nama Semua Objek
local function displayAllObjectNames()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:FindFirstChild("ObjectLabel") then
            local billboard = Instance.new("BillboardGui", obj)
            billboard.Name = "ObjectLabel"
            billboard.Size = UDim2.new(0, 100, 0, 20)
            billboard.AlwaysOnTop = true
            billboard.Adornee = obj

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.TextScaled = true
            label.Text = obj.Name
        end
    end
end

-- Ambil Semua Bonds
local function ambilBonds()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Bonds" then
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            else
                local model = obj:FindFirstAncestorOfClass("Model")
                if model then model.Parent = Character end
            end
        end
    end
end

-- Auto Ambil Bonds Terdekat
local function getNearestBonds()
    local closest, closestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Bonds" then
            local dist = (HumanoidRootPart.Position - obj.Position).Magnitude
            if dist < closestDist then
                closest = obj
                closestDist = dist
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        if autoAmbilAktif then
            local bonds = getNearestBonds()
            if bonds and (HumanoidRootPart.Position - bonds.Position).Magnitude <= 15 then
                local prompt = bonds:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                else
                    local model = bonds:FindFirstAncestorOfClass("Model")
                    if model then model.Parent = Character end
                end
            end
        end
        task.wait(1)
    end
end)

local function toggleAutoAmbil()
    autoAmbilAktif = not autoAmbilAktif
end

-- Tombol GUI
createButton("ESP Bonds", 50, enableESP)
createButton("Teleport ke Semua Fort", 90, teleportToForts)
createButton("Tampilkan Nama Semua Object", 130, displayAllObjectNames)
createButton("Ambil Semua Bonds", 170, ambilBonds)
createButton("Auto Ambil Bonds (Toggle)", 210, toggleAutoAmbil)
