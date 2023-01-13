--[[
    Expanded Roster - Dark Elves: https://steamcommunity.com/sharedfiles/filedetails/?id=2879095418

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Dark Elves).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Dark Elves templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dark_elves", "earlygame", "hunters_anath_raema", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dark_elves", "midgame", "hunters_anath_raema", 6); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dark_elves", "lategame", "tower_masters", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("dark_elves", "lategame", "lords_oblivion", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("dark_elves", "lategame", "magma_dragon", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
