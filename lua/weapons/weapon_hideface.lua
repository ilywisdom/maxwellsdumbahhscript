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
    if CLIENT then
        -- Toggle the face hiding effect
        local owner = self:GetOwner()
        hiddenFaces[owner] = not hiddenFaces[owner]
    end
end

function SWEP:SecondaryAttack()
    -- Nothing
end

if CLIENT then
    local blackMaterial = Material("vgui/black")
    local WEAPON_CLASS = "weapon_hideface"
    local SQUARE_SIZE = 15
    
    -- Track players who have activated the face hider
    local hiddenFaces = {}
    
    hook.Add("PrePlayerDraw", "HideFaceSquare", function(ply)
        if hiddenFaces[ply] then
            local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
            if headBone then
                local bonePos, boneAng = ply:GetBonePosition(headBone)
                -- Adjusted offset to be more in front of the face
                local forward = boneAng:Forward()
                local right = boneAng:Right()
                local up = boneAng:Up()
                -- Move the square forward and slightly up
                local offsetPos = bonePos + (forward * 5) + (up * 1)
                
                render.SetMaterial(blackMaterial)
                render.DrawQuadEasy(
                    offsetPos,
                    forward,
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
