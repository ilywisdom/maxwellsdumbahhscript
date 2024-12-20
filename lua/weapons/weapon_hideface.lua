SWEP.PrintName = "Face Hider"
SWEP.Author = "Maxwell's Dumb Ahh Script"
SWEP.Purpose = "Hides your face with a black square"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    -- Nothing
end

function SWEP:SecondaryAttack()
    -- Nothing
end

if CLIENT then
    local blackMaterial = Material("vgui/black")
    local screenW, screenH = ScrW(), ScrH()
    local WEAPON_CLASS = "weapon_hideface"
    local HEAD_BONES = {
        "ValveBiped.Bip01_Head1",
        "ValveBiped.Bip01_Neck1",
        "ValveBiped.Bip01_Spine4", -- Upper torso as fallback
    }
    local SQUARE_SIZE = {w = 20, h = 30}
    local SQUARE_OFFSET = Vector(0, 0, 2)
    local SPIN_SPEED = 180 -- Degrees per second
    local BOUNCE_HEIGHT = 2
    local BOUNCE_SPEED = 3
    
    -- Cache math functions
    local math_rad = math.rad
    local math_cos = math.cos
    local math_sin = math.sin
    
    -- Update screen resolution when it changes
    hook.Add("OnScreenSizeChanged", "HideFaceUpdateRes", function()
        screenW, screenH = ScrW(), ScrH()
    end)
    
    hook.Add("PostDrawTranslucentRenderables", "HideFaceSquare", function()
        surface.SetMaterial(blackMaterial)
        surface.SetDrawColor(0, 0, 0, 255)
        
        local curTime = CurTime()
        local spinAngle = (curTime * SPIN_SPEED) % 360
        local bounceOffset = math_sin(curTime * BOUNCE_SPEED) * BOUNCE_HEIGHT
        
        for _, player in ipairs(player.GetAll()) do
            if not IsValid(player) or not player:Alive() then continue end
            
            local activeWeapon = player:GetActiveWeapon()
            if not IsValid(activeWeapon) or activeWeapon:GetClass() != WEAPON_CLASS then continue end
            
            -- Try each bone in order until we find one
            local headPos = nil
            for _, boneName in ipairs(HEAD_BONES) do
                local bone = player:LookupBone(boneName)
                if bone then
                    headPos = player:GetBonePosition(bone)
                    if headPos then break end
                end
            end
            
            -- If no valid bone found, use player's eye position as fallback
            if not headPos then
                headPos = player:EyePos()
            end
            
            -- Add bounce animation to offset
            local animatedOffset = Vector(0, 0, SQUARE_OFFSET.z + bounceOffset)
            headPos:Add(animatedOffset)
            
            -- Draw rotating squares
            for i = 0, 3 do
                local ang = spinAngle + (i * 90)
                cam.Start3D2D(headPos, Angle(0, ang, 90), 0.1)
                    surface.DrawTexturedRect(-SQUARE_SIZE.w/2, -SQUARE_SIZE.h/2, SQUARE_SIZE.w, SQUARE_SIZE.h)
                cam.End3D2D()
            end
        end
    end)
end

function SWEP:DrawWorldModel()
    -- Don't draw world model
end
