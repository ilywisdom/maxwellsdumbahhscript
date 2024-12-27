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

if CLIENT then
    -- Move these variables outside the scope but keep them local to CLIENT
    blackMaterial = Material("vgui/black")
    WEAPON_CLASS = "weapon_hideface"
    SQUARE_SIZE = 15
end

-- Move hiddenFaces table outside of CLIENT section and make it global
hiddenFaces = hiddenFaces or {}

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
    hook.Add("PrePlayerDraw", "HideFaceSquare", function(ply)
        if hiddenFaces[ply] then
            local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
            if headBone then
                local bonePos, boneAng = ply:GetBonePosition(headBone)
                local forward = boneAng:Forward()
                local right = boneAng:Right()
                local up = boneAng:Up()
                -- Adjusted position to better cover the face
                local offsetPos = bonePos + (forward * 4) + (up * 0) -- Centered on face, slightly further out
                
                render.SetMaterial(blackMaterial)
                render.DrawQuadEasy(
                    offsetPos,
                    forward,
                    SQUARE_SIZE,
                    SQUARE_SIZE * 1.2, -- Made slightly taller to better cover the face
                    Color(0, 0, 0, 255),
                    90 -- Rotate 90 degrees to better align with face
                )
            end
        end
    end)
end

function SWEP:DrawWorldModel()
    -- Don't draw world model
end
