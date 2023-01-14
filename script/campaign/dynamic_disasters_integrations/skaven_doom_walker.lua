--[[
    Skaven Doom Walker: https://steamcommunity.com/workshop/filedetails/?id=2889113183

    Last Updated: 14/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Skaven Doom Walker).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Skaven templates
    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("skaven", "lategame", "skaven_mech", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game (Skryre)
    ----------------------------------------

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("skaven", "lategame_skryre", "skaven_mech", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("skaven", "lategame_skryre", "skaven_mech_at", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
