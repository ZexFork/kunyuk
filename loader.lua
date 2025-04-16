-- Inisialisasi variabel
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local currentCamera = workspace.CurrentCamera

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Fungsi untuk membuat tombol dengan tampilan kotak dan warna hitam-putih
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 300, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Warna latar belakang hitam
    button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Warna teks putih
    button.Text = text
    button.Font = Enum.Font.SourceSansBold  -- Font tebal
    button.TextSize = 24
    button.Parent = screenGui

    -- Menambahkan efek hover untuk button
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Warna gelap saat hover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Kembali ke hitam saat keluar dari hover
    end)

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Menambahkan Judul GUI
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 500, 0, 50)
titleLabel.Position = UDim2.new(0.5, -250, 0.2, -25)
titleLabel.Text = "Auto Farm & Gun Aura"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 32
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = screenGui

-- Tombol untuk memulai Auto Farm Bonds
local startButton = createButton("Start Auto Farm Bonds", UDim2.new(0.5, -150, 0.5, -25), function()
    spawn(autoFarmBonds)
end)

-- Tombol untuk memulai Gun Aura
local gunAuraButton = createButton("Start Gun Aura", UDim2.new(0.5, -150, 0.5, 35), function()
    spawn(gunAura)
end)

-- Fungsi untuk Auto Farm Bonds
local function autoFarmBonds()
    while true do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Bonds" and obj:IsA("Part") then
                -- Teleportasi ke lokasi Bonds
                humanoidRootPart.CFrame = obj.CFrame
                -- Ambil Bonds
                firetouchinterest(humanoidRootPart, obj, 0)
                firetouchinterest(humanoidRootPart, obj, 1)
                wait(0.5) -- Penundaan untuk mencegah spam
            end
        end
        wait(1) -- Penundaan untuk mengurangi beban CPU
    end
end

-- Fungsi untuk Gun Aura
local function gunAura()
    while true do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                -- Cek jarak antara pemain dan musuh
                local distance = (obj.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 15 then
                    -- Menyerang musuh dalam jarak tertentu
                    local gun = character:FindFirstChildOfClass("Tool")
                    if gun then
                        -- Serang musuh
                        gun:Activate()
                    end
                end
            end
        end
        wait(0.1) -- Penundaan untuk mencegah spam
    end
end
