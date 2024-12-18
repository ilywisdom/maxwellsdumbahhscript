if SERVER then
    AddCSLuaFile()
end

local function Initialize()
    -- Create the base directory if it doesn't exist
    if not file.Exists("maxwellsdumbahhscript", "DATA") then
        file.CreateDir("maxwellsdumbahhscript")
    end
end

-- Run initialization when the script loads
Initialize()

-- Add hook for when the gamemode initializes
hook.Add("Initialize", "MaxwellsDumbAhhScript_Init", Initialize)

print("[Maxwell's Dumb Ahh Script] Initialized!")
