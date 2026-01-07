-- [[ QuangDungHub V6 - MAX SPEED & SAFE FARM ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("QuangDungHub | God Mode", "DarkTheme")

-- Configs
_G.AutoFarm = false
_G.FastAttack = true -- Mặc định bật tốc độ cao
_G.Distance = 7 -- Khoảng cách đứng trên đầu quái
_G.Weapon = "Melee"

-- [[ HÀM HỆ THỐNG TỐI ƯU ]] --

-- Hàm Auto Equip chuẩn
function autoEquip()
    pcall(function()
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == _G.Weapon or tool.Name == _G.Weapon) then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end

-- HÀM FAST ATTACK (Siêu nhanh)
local function DoFastAttack()
    pcall(function()
        local CombatRemote = game:GetService("ReplicatedStorage").Remotes.Validator -- Tên Remote có thể thay đổi tùy version game
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        -- Gửi tín hiệu đánh liên tục không chờ animation
        CombatRemote:FireServer(math.huge) 
    end)
end

-- [[ GIAO DIỆN GUI ]] --
local Tab = Window:NewTab("Farm Siêu Tốc")
local FarmSection = Tab:NewSection("Chế Độ Cày Thuê")

FarmSection:NewDropdown("Chọn Vũ Khí", "Chọn đúng mới đánh nhanh được", {"Melee", "Sword", "Blox Fruit"}, function(v)
    _G.Weapon = v
end)

FarmSection:NewSlider("Độ Cao (Trên đầu quái)", "Chỉnh khoảng cách đứng trên đầu", 5, 15, 7, function(s)
    _G.Distance = s
end)

FarmSection:NewToggle("AUTO FARM MAX SPEED", "Farm cực nhanh + Đứng yên trên đầu", function(state)
    _G.AutoFarm = state
    
    -- Vòng lặp Farm chính
    spawn(function()
        while _G.AutoFarm do
            task.wait() -- Tốc độ quét tối đa
            pcall(function()
                local player = game.Players.LocalPlayer
                local hrp = player.Character.HumanoidRootPart
                
                for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and _G.AutoFarm then
                        autoEquip()
                        
                        -- CỐ ĐỊNH TỌA ĐỘ TRÊN ĐẦU QUÁI
                        repeat
                            -- Ép đứng yên tại vị trí phía trên quái
                            hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- Xả sát thương Max Speed
                            DoFastAttack()
                            task.wait() -- Không delay để đạt tốc độ cao nhất
                        until not _G.AutoFarm or not mob.Parent or mob.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end)
end)

-- TAB PVP (Giữ nguyên từ bản trước)
local TabPvP = Window:NewTab("PvP & Quỷ Sát")
-- ... (Các tính năng PvP giữ nguyên)
