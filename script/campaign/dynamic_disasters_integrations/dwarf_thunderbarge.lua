--[[
    Dwarf Thunderbarge: https://steamcommunity.com/sharedfiles/filedetails/?id=2852872304

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Dwarf Thunderbarge).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Dwarf templates
    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Vehicles
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "cody_dwf_veh_thunderbarge_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Vehicles
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "cody_dwf_veh_thunderbarge_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end

