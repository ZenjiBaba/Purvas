local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local EnemiesService = game:GetService("Enemies")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera
local LocalEnemies = EnemiesService.LocalEnemies
local Mouse = LocalEnemies:GetMouse()

local SilentAim,Aimbot,Trigger = nil,false,false
local GravityCorrection = 2

local Window = Purvas.Utilities.UI:Window({
    Name = "Purvas Hub — "..Purvas.Game,
    Position = UDim2.new(0.05,0,0.5,-248)
    }) do Window:Watermark({Enabled = true})

    local AimAssistTab = Window:Tab({Name = "Combat"}) do
        local GlobalSection = AimAssistTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Toggle({Name = "Team Check",Flag = "TeamCheck",Value = false})
            GlobalSection:Dropdown({Name = "Silent Aim Mode",Flag = "SilentAim/Mode",List = {
                {Name = "Raycast",Mode = "Button",Value = true},
                {Name = "FindPartOnRayWithIgnoreList",Mode = "Button"},
                {Name = "FindPartOnRayWithWhitelist",Mode = "Button"},
                {Name = "FindPartOnRay",Mode = "Button"},
                {Name = "Hit/Target",Mode = "Button"}
            }})
        end
        local AimbotSection = AimAssistTab:Section({Name = "AimBOT",Side = "Left"}) do
            AimbotSection:Toggle({Name = "Enabled",Flag = "Aimbot/Enabled",Value = false})
            AimbotSection:Toggle({Name = "Visibility Check",Flag = "Aimbot/WallCheck",Value = false})
            AimbotSection:Toggle({Name = "Distance Check",Flag = "Aimbot/DistanceCheck",Value = false})
            AimbotSection:Toggle({Name = "Dynamic FOV",Flag = "Aimbot/DynamicFOV",Value = false})
            AimbotSection:Keybind({Name = "Keybind",Flag = "Aimbot/Keybind",Value = "MouseButton2",
            Mouse = true,Callback = function(Key,KeyDown) Aimbot = Window.Flags["Aimbot/Enabled"] and KeyDown end})
            AimbotSection:Slider({Name = "Smoothness",Flag = "Aimbot/Smoothness",Min = 0,Max = 100,Value = 25,Unit = "%"})
            AimbotSection:Slider({Name = "Field Of View",Flag = "Aimbot/FieldOfView",Min = 0,Max = 500,Value = 100})
            AimbotSection:Slider({Name = "Distance",Flag = "Aimbot/Distance",Min = 25,Max = 1000,Value = 250,Unit = "studs"})
            AimbotSection:Dropdown({Name = "Body Parts",Flag = "Aimbot/BodyParts",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle"}
            }})
            AimbotSection:Divider({Text = "Prediction"})
            AimbotSection:Toggle({Name = "Enabled",Flag = "Aimbot/Prediction/Enabled",Value = false})
            AimbotSection:Slider({Name = "Velocity",Flag = "Aimbot/Prediction/Velocity",Min = 1,Max = 10000,Value = 1000})
            AimbotSection:Slider({Name = "Gravity",Flag = "Aimbot/Prediction/Gravity",Min = 0,Max = 1000,Precise = 1,Value = 196.2})
        end
        local AFOVSection = AimAssistTab:Section({Name = "Aimbot FOV Circle",Side = "Left"}) do
            AFOVSection:Toggle({Name = "Enabled",Flag = "Aimbot/Circle/Enabled",Value = true})
            AFOVSection:Toggle({Name = "Filled",Flag = "Aimbot/Circle/Filled",Value = false})
            AFOVSection:Colorpicker({Name = "Color",Flag = "Aimbot/Circle/Color",Value = {1,0.66666662693024,1,0.25,false}})
            AFOVSection:Slider({Name = "NumSides",Flag = "Aimbot/Circle/NumSides",Min = 3,Max = 100,Value = 14})
            AFOVSection:Slider({Name = "Thickness",Flag = "Aimbot/Circle/Thickness",Min = 1,Max = 10,Value = 2})
        end
        local TFOVSection = AimAssistTab:Section({Name = "Trigger FOV Circle",Side = "Left"}) do
            TFOVSection:Toggle({Name = "Enabled",Flag = "Trigger/Circle/Enabled",Value = true})
            TFOVSection:Toggle({Name = "Filled",Flag = "Trigger/Circle/Filled",Value = false})
            TFOVSection:Colorpicker({Name = "Color",Flag = "Trigger/Circle/Color",
            Value = {0.0833333358168602,0.6666666269302368,1,0.25,false}})
            TFOVSection:Slider({Name = "NumSides",Flag = "Trigger/Circle/NumSides",Min = 3,Max = 100,Value = 14})
            TFOVSection:Slider({Name = "Thickness",Flag = "Trigger/Circle/Thickness",Min = 1,Max = 10,Value = 2})
        end
        local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Right"}) do
            SilentAimSection:Toggle({Name = "Enabled",Flag = "SilentAim/Enabled",Value = false})
            :Keybind({Mouse = true,Flag = "SilentAim/Keybind"})
            SilentAimSection:Toggle({Name = "Visibility Check",Flag = "SilentAim/WallCheck",Value = false})
            SilentAimSection:Toggle({Name = "Distance Check",Flag = "SilentAim/DistanceCheck",Value = false})
            SilentAimSection:Toggle({Name = "Dynamic FOV",Flag = "SilentAim/DynamicFOV",Value = false})
            SilentAimSection:Slider({Name = "Hit Chance",Flag = "SilentAim/HitChance",Min = 0,Max = 100,Value = 100,Unit = "%"})
            SilentAimSection:Slider({Name = "Field Of View",Flag = "SilentAim/FieldOfView",Min = 0,Max = 500,Value = 100})
            SilentAimSection:Slider({Name = "Distance",Flag = "SilentAim/Distance",Min = 25,Max = 1000,Value = 250,Unit = "studs"})
            SilentAimSection:Dropdown({Name = "Body Parts",Flag = "SilentAim/BodyParts",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle"}
            }})
            SilentAimSection:Divider({Text = "Prediction"})
            SilentAimSection:Toggle({Name = "Enabled",Flag = "SilentAim/Prediction/Enabled",Value = false})
            SilentAimSection:Slider({Name = "Velocity",Flag = "SilentAim/Prediction/Velocity",Min = 1,Max = 10000,Value = 1000})
            SilentAimSection:Slider({Name = "Gravity",Flag = "SilentAim/Prediction/Gravity",Min = 0,Max = 1000,Precise = 1,Value = 196.2})
        end
        local SAFOVSection = AimAssistTab:Section({Name = "Silent Aim FOV Circle",Side = "Right"}) do
            SAFOVSection:Toggle({Name = "Enabled",Flag = "SilentAim/Circle/Enabled",Value = true})
            SAFOVSection:Toggle({Name = "Filled",Flag = "SilentAim/Circle/Filled",Value = false})
            SAFOVSection:Colorpicker({Name = "Color",Flag = "SilentAim/Circle/Color",
            Value = {0.6666666865348816,0.6666666269302368,1,0.25,false}})
            SAFOVSection:Slider({Name = "NumSides",Flag = "SilentAim/Circle/NumSides",Min = 3,Max = 100,Value = 14})
            SAFOVSection:Slider({Name = "Thickness",Flag = "SilentAim/Circle/Thickness",Min = 1,Max = 10,Value = 2})
        end
        local TriggerSection = AimAssistTab:Section({Name = "Trigger",Side = "Right"}) do
            TriggerSection:Toggle({Name = "Enabled",Flag = "Trigger/Enabled",Value = false})
            TriggerSection:Toggle({Name = "Visibility Check",Flag = "Trigger/WallCheck",Value = true})
            TriggerSection:Toggle({Name = "Distance Check",Flag = "Trigger/DistanceCheck",Value = false})
            TriggerSection:Toggle({Name = "Dynamic FOV",Flag = "Trigger/DynamicFOV",Value = false})
            TriggerSection:Keybind({Name = "Keybind",Flag = "Trigger/Keybind",Value = "MouseButton2",
            Mouse = true,Callback = function(Key,KeyDown) Trigger = Window.Flags["Trigger/Enabled"] and KeyDown end})
            TriggerSection:Slider({Name = "Field Of View",Flag = "Trigger/FieldOfView",Min = 0,Max = 500,Value = 25})
            TriggerSection:Slider({Name = "Distance",Flag = "Trigger/Distance",Min = 25,Max = 1000,Value = 250,Unit = "studs"})
            TriggerSection:Slider({Name = "Delay",Flag = "Trigger/Delay",Min = 0,Max = 1,Precise = 2,Value = 0.15})
            TriggerSection:Toggle({Name = "Hold Mode",Flag = "Trigger/HoldMode",Value = false})
            TriggerSection:Dropdown({Name = "Body Parts",Flag = "Trigger/BodyParts",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle"}
            }})
            TriggerSection:Divider({Text = "Prediction"})
            TriggerSection:Toggle({Name = "Enabled",Flag = "Trigger/Prediction/Enabled",Value = false})
            TriggerSection:Slider({Name = "Velocity",Flag = "Trigger/Prediction/Velocity",Min = 1,Max = 10000,Value = 1000})
            TriggerSection:Slider({Name = "Gravity",Flag = "Trigger/Prediction/Gravity",Min = 0,Max = 1000,Precise = 1,Value = 196.2})
        end
    end
    local VisualsTab = Window:Tab({Name = "Visuals"}) do
        local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Ally Color",Flag = "ESP/Enemies/Ally",Value = {0.3333333432674408,0.6666666269302368,1,0,false}})
            GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/Enemies/Enemy",Value = {1,0.6666666269302368,1,0,false}})
            GlobalSection:Toggle({Name = "Team Check",Flag = "ESP/Enemies/TeamCheck",Value = false})
            GlobalSection:Toggle({Name = "Use Team Color",Flag = "ESP/Enemies/TeamColor",Value = false})
            GlobalSection:Toggle({Name = "Distance Check",Flag = "ESP/Enemies/DistanceCheck",Value = false})
            GlobalSection:Slider({Name = "Distance",Flag = "ESP/Enemies/Distance",Min = 25,Max = 1000,Value = 250,Unit = "studs"})
        end
        local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Box Enabled",Flag = "ESP/Enemies/Box/Enabled",Value = false})
            BoxSection:Toggle({Name = "Healthbar",Flag = "ESP/Enemies/Box/Healthbar",Value = false})
            BoxSection:Toggle({Name = "Filled",Flag = "ESP/Enemies/Box/Filled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Enemies/Box/Outline",Value = true})
            BoxSection:Slider({Name = "Thickness",Flag = "ESP/Enemies/Box/Thickness",Min = 1,Max = 10,Value = 1})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Box/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            BoxSection:Divider()
            BoxSection:Toggle({Name = "Text Enabled",Flag = "ESP/Enemies/Text/Enabled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Enemies/Text/Outline",Value = true})
            BoxSection:Toggle({Name = "Autoscale",Flag = "ESP/Enemies/Text/Autoscale",Value = true})
            BoxSection:Dropdown({Name = "Font",Flag = "ESP/Enemies/Text/Font",List = {
                {Name = "UI",Mode = "Button",Value = true},
                {Name = "System",Mode = "Button"},
                {Name = "Plex",Mode = "Button"},
                {Name = "Monospace",Mode = "Button"}
            }})
            BoxSection:Slider({Name = "Size",Flag = "ESP/Enemies/Text/Size",Min = 13,Max = 100,Value = 16})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
            OoVSection:Toggle({Name = "Enabled",Flag = "ESP/Enemies/Arrow/Enabled",Value = false})
            OoVSection:Toggle({Name = "Filled",Flag = "ESP/Enemies/Arrow/Filled",Value = true})
            OoVSection:Toggle({Name = "Outline",Flag = "ESP/Enemies/Arrow/Outline",Value = true})
            OoVSection:Slider({Name = "Width",Flag = "ESP/Enemies/Arrow/Width",Min = 14,Max = 28,Value = 18})
            OoVSection:Slider({Name = "Height",Flag = "ESP/Enemies/Arrow/Height",Min = 14,Max = 28,Value = 28})
            OoVSection:Slider({Name = "Distance From Center",Flag = "ESP/Enemies/Arrow/Distance",Min = 80,Max = 200,Value = 200})
            OoVSection:Slider({Name = "Thickness",Flag = "ESP/Enemies/Arrow/Thickness",Min = 1,Max = 10,Value = 1})
            OoVSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Arrow/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HeadSection = VisualsTab:Section({Name = "Head Dots",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Flag = "ESP/Enemies/Head/Enabled",Value = false})
            HeadSection:Toggle({Name = "Filled",Flag = "ESP/Enemies/Head/Filled",Value = true})
            HeadSection:Toggle({Name = "Outline",Flag = "ESP/Enemies/Head/Outline",Value = true})
            HeadSection:Toggle({Name = "Autoscale",Flag = "ESP/Enemies/Head/Autoscale",Value = true})
            HeadSection:Slider({Name = "Radius",Flag = "ESP/Enemies/Head/Radius",Min = 1,Max = 10,Value = 8})
            HeadSection:Slider({Name = "NumSides",Flag = "ESP/Enemies/Head/NumSides",Min = 3,Max = 100,Value = 4})
            HeadSection:Slider({Name = "Thickness",Flag = "ESP/Enemies/Head/Thickness",Min = 1,Max = 10,Value = 1})
            HeadSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Head/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
            TracerSection:Toggle({Name = "Enabled",Flag = "ESP/Enemies/Tracer/Enabled",Value = false})
            TracerSection:Dropdown({Name = "Mode",Flag = "ESP/Enemies/Tracer/Mode",List = {
                {Name = "From Bottom",Mode = "Button",Value = true},
                {Name = "From Mouse",Mode = "Button"}
            }})
            TracerSection:Slider({Name = "Thickness",Flag = "ESP/Enemies/Tracer/Thickness",Min = 1,Max = 10,Value = 1})
            TracerSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Tracer/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
            HighlightSection:Toggle({Name = "Enabled",Flag = "ESP/Enemies/Highlight/Enabled",Value = false})
            HighlightSection:Slider({Name = "Transparency",Flag = "ESP/Enemies/Highlight/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            HighlightSection:Colorpicker({Name = "Outline Color",Flag = "ESP/Enemies/Highlight/OutlineColor",Value = {1,1,0,0.5,false}})
        end Purvas.Utilities.Misc:LightingSection(VisualsTab,"Right")
    end Purvas.Utilities.Misc:SettingsSection(Window,"RightShift",false)
end

Window:SetValue("Background/Offset",296)
Window:LoadDefaultConfig("Purvas")
Window:SetValue("UI/Toggle",Window.Flags["UI/OOL"])

Purvas.Utilities.Misc:SetupWatermark(Window)
Purvas.Utilities.Misc:SetupLighting(Window.Flags)
Purvas.Utilities.Drawing:SetupCursor(Window.Flags)
Purvas.Utilities.Drawing:FOVCircle("Aimbot",Window.Flags)
Purvas.Utilities.Drawing:FOVCircle("Trigger",Window.Flags)
Purvas.Utilities.Drawing:FOVCircle("SilentAim",Window.Flags)

local WallCheckParams = RaycastParams.new()
WallCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
WallCheckParams.IgnoreWater = true

local function Raycast(Origin,Direction,Table)
    WallCheckParams.FilterDescendantsInstances = Table
    return Workspace:Raycast(Origin,Direction,WallCheckParams)
end

local function TeamCheck(Enabled,Enemies)
    if not Enabled then return true end
    return LocalEnemies.Team ~= Enemies.Team
end

local function DistanceCheck(Enabled,Distance,MaxDistance)
    if not Enabled then return true end
    return Distance <= MaxDistance
end

local function WallCheck(Enabled,Hitbox,Character)
    if not Enabled then return true end
    return not Raycast(Camera.CFrame.Position,
    Hitbox.Position - Camera.CFrame.Position,
    {LocalEnemies.Character,Character})
end

local function CalculateTrajectory(Origin,Velocity,Time,Gravity)
    --[[local PredictedPosition = Origin + Velocity * Time
    local Delta = (PredictedPosition - Origin).Magnitude
    Time = Time + Delta / ProjectileSpeed]]
    return Origin + Velocity * Time + Gravity * Time * Time / GravityCorrection
end

local function GetClosest(Enabled,FOV,DFOV,TC,BP,WC,DC,MD,PE,PS,PG)
    -- FieldOfView,DynamicFieldOfView,TeamCheck
    -- BodyParts,WallCheck,DistanceCheck,MaxDistance
    -- PredictionEnabled,ProjectileSpeed,ProjectileGravity

    if not Enabled then return end local Closest = nil
    FOV = DFOV and FOV * (1 + (80 - Camera.FieldOfView) / 100) or FOV

    for Index,Enemies in pairs(EnemiesService:GetEnemiess()) do
        if Enemies == LocalEnemies then continue end
        local Character = Enemies.Character

        if Character and TeamCheck(TC,Enemies) then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid then continue end if Humanoid.Health <= 0 then continue end

            for Index,BodyPart in pairs(BP) do
                BodyPart = Character:FindFirstChild(BodyPart) if not BodyPart then continue end
                local Distance = (BodyPart.Position - Camera.CFrame.Position).Magnitude
                if WallCheck(WC,BodyPart,Character) and DistanceCheck(DC,Distance,MD) then
                    local ScreenPosition,OnScreen = Camera:WorldToViewportPoint(PE and CalculateTrajectory(
                        BodyPart.Position,BodyPart.AssemblyLinearVelocity,Distance / PS,Vector3.new(0,PG,0)) or BodyPart.Position)
                    local NewFOV = (Vector2.new(ScreenPosition.X,ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if OnScreen and NewFOV <= FOV then FOV,Closest = NewFOV,{Enemies,Character,BodyPart,ScreenPosition} end
                end
            end
        end
    end

    return Closest
end

local function AimAt(Hitbox,Smoothness)
    if not Hitbox then return end
    local Mouse = UserInputService:GetMouseLocation()

    mousemoverel(
        (Hitbox[4].X - Mouse.X) * Smoothness,
        (Hitbox[4].Y - Mouse.Y) * Smoothness
    )
end

-- Universal Silent Aim by Averiias
local OldIndex,OldNamecall
OldIndex = hookmetamethod(game,"__index",function(Self,Index)
    local Mode = Window.Flags["SilentAim/Mode"][1]
    if Self == Mouse and not checkcaller() and Mode == "Hit/Target" and SilentAim
    and math.random(0,100) <= Window.Flags["SilentAim/HitChance"] then
        if Index == "Target" or Index == "target" then
            return SilentAim[3]
        elseif Index == "Hit" or Index == "hit" then
            return SilentAim[3].CFrame
        elseif Index == "X" or Index == "x" then
            return Self.X
        elseif Index == "Y" or Index == "y" then
            return Self.Y
        elseif Index == "UnitRay" then
            return Ray.new(Self.Origin,(Self.Hit - Self.Origin).Unit)
        end
    end return OldIndex(Self,Index)
end)
OldNamecall = hookmetamethod(game,"__namecall",function(Self,...)
    local Args,Method = {...},getnamecallmethod()
    if Self == Workspace and not checkcaller() and SilentAim
    and math.random(0,100) <= Window.Flags["SilentAim/HitChance"] then
        local Mode = Window.Flags["SilentAim/Mode"][1]
        if (Method == "Raycast" and Mode == Method) then
            Args[2] = (SilentAim[3].Position - Args[1]).Unit * 1000
            return OldNamecall(Self,unpack(Args))
        elseif (Method == "FindPartOnRayWithIgnoreList" and Mode == Method)
        or (Method == "FindPartOnRayWithWhitelist" and Mode == Method)
        or ((Method == "FindPartOnRay" or Method == "findPartOnRay") and Mode:lower() == Method:lower()) then
            Args[1] = Ray.new(Args[1].Origin,(SilentAim[3].Position - Args[1].Origin).Unit * 1000)
            return OldNamecall(Self,unpack(Args))
        end
    end return OldNamecall(Self,...)
end)

RunService.Heartbeat:Connect(function()
    SilentAim = GetClosest(
        Window.Flags["SilentAim/Enabled"],
        Window.Flags["SilentAim/FieldOfView"],
        Window.Flags["SilentAim/DynamicFOV"],
        Window.Flags["TeamCheck"],
        Window.Flags["SilentAim/BodyParts"],
        Window.Flags["SilentAim/WallCheck"],
        Window.Flags["SilentAim/DistanceCheck"],
        Window.Flags["SilentAim/Distance"],
        Window.Flags["SilentAim/Prediction/Enabled"],
        Window.Flags["SilentAim/Prediction/Velocity"],
        Window.Flags["SilentAim/Prediction/Gravity"]
    )
    if Aimbot then
        AimAt(GetClosest(
            Window.Flags["Aimbot/Enabled"],
            Window.Flags["Aimbot/FieldOfView"],
            Window.Flags["Aimbot/DynamicFOV"],
            Window.Flags["TeamCheck"],
            Window.Flags["Aimbot/BodyParts"],
            Window.Flags["Aimbot/WallCheck"],
            Window.Flags["Aimbot/DistanceCheck"],
            Window.Flags["Aimbot/Distance"],
            Window.Flags["Aimbot/Prediction/Enabled"],
            Window.Flags["Aimbot/Prediction/Velocity"],
            Window.Flags["Aimbot/Prediction/Gravity"]
        ),Window.Flags["Aimbot/Smoothness"] / 100)
    end
end)
Purvas.Utilities.Misc:NewThreadLoop(0,function()
    if not Trigger then return end
    local TriggerHitbox = GetClosest(
        Window.Flags["Trigger/Enabled"],
        Window.Flags["Trigger/FieldOfView"],
        Window.Flags["Trigger/DynamicFOV"],
        Window.Flags["TeamCheck"],
        Window.Flags["Trigger/BodyParts"],
        Window.Flags["Trigger/WallCheck"],
        Window.Flags["Trigger/DistanceCheck"],
        Window.Flags["Trigger/Distance"],
        Window.Flags["Trigger/Prediction/Enabled"],
        Window.Flags["Trigger/Prediction/Velocity"],
        Window.Flags["Trigger/Prediction/Gravity"]
    )

    if TriggerHitbox then mouse1press()
        task.wait(Window.Flags["Trigger/Delay"])
        if Window.Flags["Trigger/HoldMode"] then
            while task.wait() do
                TriggerHitbox = GetClosest(
                    Window.Flags["Trigger/Enabled"],
                    Window.Flags["Trigger/FieldOfView"],
                    Window.Flags["Trigger/DynamicFOV"],
                    Window.Flags["TeamCheck"],
                    Window.Flags["Trigger/BodyParts"],
                    Window.Flags["Trigger/WallCheck"],
                    Window.Flags["Trigger/DistanceCheck"],
                    Window.Flags["Trigger/Distance"],
                    Window.Flags["Trigger/Prediction/Enabled"],
                    Window.Flags["Trigger/Prediction/Velocity"],
                    Window.Flags["Trigger/Prediction/Gravity"]
                ) if not TriggerHitbox or not Trigger then break end
            end
        end mouse1release()
    end
end)

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

for Index,Enemies in pairs(EnemiesService:GetEnemiess()) do
    if Enemies == LocalEnemies then continue end
    Purvas.Utilities.Drawing:AddESP(Enemies,"Enemies","ESP/Enemies",Window.Flags)
end
EnemiesService.EnemiesAdded:Connect(function(Enemies)
    Purvas.Utilities.Drawing:AddESP(Enemies,"Enemies","ESP/Enemies",Window.Flags)
end)
EnemiesService.EnemiesRemoving:Connect(function(Enemies)
    Purvas.Utilities.Drawing:RemoveESP(Enemies)
end)
