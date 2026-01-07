-- [[ QuangDungHub SUPREME - BẢN CẬP NHẬT VŨ KHÍ ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("QuangDungHub | Supreme v5", "DarkTheme")

-- Biến hệ thống
_G.AutoFarm = false
_G.QuySat = false
_G.Aimbot = false
_G.AutoChest = false
_G.SelectedWeapon = "Melee" -- Mặc định là đấm tay

-- [[ HÀM HỆ THỐNG ]] --

-- Hàm tự động cầm vũ khí
function autoEquip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            -- Kiểm tra xem Tool có đúng loại đã chọn không (Melee, Sword, hoặc Fruit)
            if tool:IsA("Tool") and (tool.ToolTip == _G.SelectedWeapon or tool.Name == _G.SelectedWeapon or (string.find(tool.ToolTip, _G.SelectedWeapon))) then
                character.Humanoid:EquipTool(tool)
            end
        end
    end
end

-- Hàm tìm người chơi gần nhất (Cho PvP)
local function getNearestPlayer()
    local closestDist = math.huge
    local target = nil
    for _, v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local dist = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                target = v
            end
        end
    end
    return target
end

-- [[ GIAO DIỆN GUI ]] --

-- TAB CÀY CUỐC
local Tab1 = Window:NewTab("Cày Level")
local Section1 = Tab1:NewSection("Cấu Hình Farm")

-- Mục chọn vũ khí (MỚI BỔ SUNG)
Section1:NewDropdown("Chọn Vũ Khí Để Farm", "Chọn loại vũ khí bạn đang dùng", {"Melee", "Sword", "Blox Fruit"}, function(v)
    _G.SelectedWeapon = v
    print("QuangDungHub: Đã chọn vũ khí: " .. v)
end)

Section1:NewToggle("Auto Farm Level", "Tự động bay và đánh quái", function(state)
    _G.AutoFarm = state
    spawn(function()
        while _G.AutoFarm do
            wait(0.1)
            pcall(function()
                autoEquip() -- Luôn cầm vũ khí khi đang farm
                for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and _G.AutoFarm then
                        repeat
                            wait()
                            -- Bay phía trên quái để né skill
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                            -- Auto Click
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                        until not _G.AutoFarm or not mob.Parent or mob.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end)
end)

-- TAB PVP QUY SÁT
local Tab2 = Window:NewTab("PvP & Quỷ Sát")
local Section2 = Tab2:NewSection("PvP Chuyên Nghiệp")

Section2:NewToggle("Aimbot Ghim Tâm", "Khóa camera vào đối thủ", function(state)
    _G.Aimbot = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Aimbot then
            local target = getNearestPlayer()
            if target then
                local cam = workspace.CurrentCamera
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)

Section2:NewToggle("BẬT QUỶ SÁT (Combo)", "Tự động giết người chơi gần nhất", function(state)
    _G.QuySat = state
    if state then
        _G.AutoFarm = false
        spawn(function()
            while _G.QuySat do
                wait()
                local target = getNearestPlayer()
                if target and target.Character then
                    autoEquip() -- Cầm vũ khí để PvP
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    -- Spam phím Z X C V
                    local vim = game:GetService("VirtualInputManager")
                    for _, key in pairs({"Z", "X", "C", "V"}) do
                        vim:SendKeyEvent(true, key, false, game)
                        wait(0.1)
                        vim:SendKeyEvent(false, key, false, game)
                    end
                end
            end
        end)
    end
end)

-- TAB TIỆN ÍCH
local Tab3 = Window:NewTab("Tiện Ích")
local Section3 = Tab3:NewSection("Khác")

Section3:NewToggle("Auto Nhặt Rương", "Teleport đi lấy rương", function(state)
    _G.AutoChest = state
    spawn(function()
        while _G.AutoChest do
            wait(0.5)
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") and _G.AutoChest then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            end
        end
    end)
end)

Section3:NewButton("Anti-AFK", "Chống bị Kick", function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
