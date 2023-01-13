--[[
    Expanded Roster - Norsca: https://steamcommunity.com/sharedfiles/filedetails/?id=2907218501

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Norsca).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Norsca templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_pit", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_maidens", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_bondsmen", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_reavers", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_valkyrie", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "earlygame", "deco_nor_jarl", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_pit", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_maidens", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_huskarls", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_reavers", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_valkyrie", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_hydra", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "midgame", "deco_nor_jarl", 1); if is_string(error_message) then out("\t\t" .. error_message); end


    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_pit", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_maidens", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_huskarls", 6); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_reavers", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_valkyrie", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_hydra", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("norsca", "lategame", "deco_nor_jarl", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- TODO: Integrate them into the chaos templates once these units are actually available to chaos, if ever.
end

