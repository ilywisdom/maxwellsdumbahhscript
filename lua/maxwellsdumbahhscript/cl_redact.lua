-- Create material for the black redaction square
local REDACT_MATERIAL = Material("vgui/black")



-- Cache screen resolution for performance
local scrW, scrH = ScrW(), ScrH()

-- Update cached resolution when screen size changes
hook.Add("OnScreenSizeChanged", "UpdateRedactScreenRes", function()
    scrW, scrH = ScrW(), ScrH()
end)


-- Draw black squares over redacted text
hook.Add("HUDPaint", "DrawRedactionSquares", function()
    -- Get all players
    for _, ply in ipairs(player.GetAll()) do
        -- Check if player has redacted text
        if ply:GetNWBool("HasRedactedText", false) then
            local redactedText = ply:GetNWString("RedactedText", "")
            if redactedText == "" then return end
            
            -- Get player's position for text rendering
            local pos = ply:GetPos() + Vector(0, 0, 85) -- Offset above player head
            local screenPos = pos:ToScreen()
            
            -- Get text size to determine rectangle size
            surface.SetFont("DermaDefault") 
            local textWidth, textHeight = surface.GetTextSize(redactedText)
            
            -- Draw black rectangle
            surface.SetDrawColor(0, 0, 0, 255)
            surface.SetMaterial(REDACT_MATERIAL)
            surface.DrawTexturedRect(screenPos.x - textWidth/2, screenPos.y - textHeight/2, textWidth, textHeight)
        end
    end
end)
