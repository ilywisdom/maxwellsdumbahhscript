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
    
    -- Cache screen resolution
    local scrW, scrH = ScrW(), ScrH()
    
    -- Update cached resolution when screen size changes
    hook.Add("OnScreenSizeChanged", "UpdateHideFaceScreenRes", function()
        scrW, scrH = ScrW(), ScrH()
    end)
    
    hook.Add("PostDrawTranslucentRenderables", "HideFaceSquare", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        
        local activeWeapon = ply:GetActiveWeapon()
        if not IsValid(activeWeapon) or activeWeapon:GetClass() != "weapon_hideface" then return end
        
        local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not headBone then return end
        
        local headPos, headAng = ply:GetBonePosition(headBone)
        if not headPos then return end
        
        -- Draw black square from multiple angles
        for i = 0, 359, 90 do
            cam.Start3D2D(headPos + Vector(0, 0, 0), Angle(0, i, 90), 0.1)
                surface.SetMaterial(blackMaterial)
                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawTexturedRect(-10, -15, 20, 30)
            cam.End3D2D()
        end
    end)
end

function SWEP:DrawWorldModel()
    -- Don't draw world model
end
