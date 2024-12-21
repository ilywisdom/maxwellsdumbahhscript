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
    local SQUARE_SIZE = {w = 15, h = 15}
    local SQUARE_OFFSET = Vector(0, 0, 0)
    local BOUNCE_HEIGHT = 0
    
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
        
        for _, player in ipairs(player.GetAll()) do
            if not IsValid(player) or not player:Alive() then continue end
            
            local activeWeapon = player:GetActiveWeapon()
            if not IsValid(activeWeapon) or activeWeapon:GetClass() != WEAPON_CLASS then continue end
            
            local headPos = player:EyePos() + Vector(0, 0, -3)
            local eyeAngles = player:EyeAngles()
            
            -- Draw square directly in front of face
            cam.Start3D2D(headPos + eyeAngles:Forward() * 4, Angle(0, eyeAngles.y - 90, 90), 0.1)
                surface.DrawTexturedRect(-SQUARE_SIZE.w/2, -SQUARE_SIZE.h/2, SQUARE_SIZE.w, SQUARE_SIZE.h)
            cam.End3D2D()
        end
    end)
end

function SWEP:DrawWorldModel()
    -- Don't draw world model
end
