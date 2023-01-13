--[[
    Expanded Roster - Beastmen: https://steamcommunity.com/sharedfiles/filedetails/?id=2874672190

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Beastmen).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Beastmen templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "earlygame", "gor_great_axe", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "midgame", "gor_great_axe", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "midgame", "bestigor_dual_axe", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "lategame", "gor_great_axe", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "lategame", "bestigor_dual_axe", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("beastmen", "lategame", "gouge_horns", 4); if is_string(error_message) then out("\t\t" .. error_message); end
end

