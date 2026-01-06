-- [[ QuangDungHub V4 - STABLE EDITION ]] --
-- Phím tắt Ẩn/Hiện: Thường là phím RightControl (PC) hoặc nút nhỏ trên màn hình (Mobile)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("QuangDungHub | V4 Stable", "DarkTheme")

-- Configs mặc định
_G.AutoFarm = false
_G.Aimbot = false
_G.AutoRun = false
_G.QuySat = false
_G.AutoChest = false

-- [[ FIX LỖI: CÁC BIẾN DỊCH VỤ ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")

-- [[ HÀM TỐI ƯU HÓA ]] --
local function getNearestPlayer()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local d = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

-- [[ TAB 1: CÀY CUỐC & TIỀN ]] --
local Tab1 = Window:NewTab("Auto Farm & Chest")
local FarmSection = Tab1:NewSection("Sửa lỗi: Bật là chạy")

FarmSection:NewToggle("Auto Farm Level", "Sửa lỗi không nhận quái", function(state)
    _G.AutoFarm = state
    if state then
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    -- Tìm quái trong Workspace (Cần kiểm tra kỹ tên folder quái của server)
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and _G.AutoFarm then
                            repeat
                                task.wait()
                                -- Di chuyển tới quái
                                LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                -- Auto Click mượt hơn
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new(851, 158))
                            until not _G.AutoFarm or mob.Humanoid.Health <= 0 or not mob.Parent
                        end
                    end
                end)
            end
        end)
    end
end)

FarmSection:NewToggle("Auto Nhặt Rương", "Quét rương toàn bản đồ", function(state)
    _G.AutoChest = state
    if state then
        task.spawn(function()
            while _G.AutoChest do
                task.wait(0.1)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Chest") and v:IsA("Part") and _G.AutoChest then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.3)
                    end
                end
            end
        end)
    end
end)

-- [[ TAB 2: PVP & QUỶ SÁT ]] --
local Tab2 = Window:NewTab("PvP QuangDung")
local PvPSection = Tab2:NewSection("Chế độ Chiến Đấu")

PvPSection:NewToggle("Aimbot Khóa Tâm", "Tự động ghim camera", function(state)
    _G.Aimbot = state
    if state then
        RunService:BindToRenderStep("QuangDungAimbot", 1, function()
            if _G.Aimbot then
                local target = getNearestPlayer()
                if target then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("QuangDungAimbot")
    end
end)

PvPSection:NewToggle("BẬT QUỶ SÁT", "Auto Combo cực gắt", function(state)
    _G.QuySat = state
    if state then
        task.spawn(function()
            while _G.QuySat do
                task.wait()
                local target = getNearestPlayer()
                if target and target.Character then
                    -- Dán chặt sau lưng
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    -- Combo Z X C V
                    for _, key in pairs({"Z", "X", "C", "V"}) do
                        VIM:SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        VIM:SendKeyEvent(false, key, false, game)
                    end
                end
            end
        end)
    end
end)

-- [[ TAB 3: HỆ THỐNG & PHÍM TẮT ]] --
local Tab3 = Window:NewTab("Cài Đặt")
local SettingSection = Tab3:NewSection("Menu & Phím Tắt")

-- Tính năng ẩn hiện menu
SettingSection:NewKeybind("Ẩn/Hiện Menu", "Bấm phím này để đóng mở menu nhanh", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

SettingSection:NewToggle("Chống Treo Máy (Anti-AFK)", "Bật để không bị văng", function(state)
    if state then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)
