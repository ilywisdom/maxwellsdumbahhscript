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
    local WEAPON_CLASS = "weapon_hideface"
    local SQUARE_SIZE = 50
    
    hook.Add("PrePlayerDraw", "HideFaceSquare", function(ply)
        -- Check if player has the face hider equipped
        local weapon = ply:GetActiveWeapon()
        if IsValid(weapon) and weapon:GetClass() == WEAPON_CLASS then
            -- Get the head position
            local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
            if headBone then
                -- Draw a black material over the head
                render.SetMaterial(blackMaterial)
                render.DrawQuadEasy(
                    ply:GetBonePosition(headBone),
                    ply:GetAngles():Forward(),
                    SQUARE_SIZE,
                    SQUARE_SIZE,
                    Color(0, 0, 0, 255)
                )
            end
        end
    end)
end

function SWEP:DrawWorldModel()
    -- Don't draw world model
end
