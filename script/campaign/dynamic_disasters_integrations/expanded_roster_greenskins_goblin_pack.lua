--[[
    Expanded Roster - Greenskins - Goblin Pack: https://steamcommunity.com/sharedfiles/filedetails/?id=2863393121

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Greenskins - Goblin Pack).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Greeenskin templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_snotling", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_night_goblin_spears", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_forest_spear", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_forest_sword", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_hill_goblins", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_forest_bow", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "colossal_squig", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "wh_grn_forest_goblin_warboss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_night_goblin_spears", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_forest_spear", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_forest_sword", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_hill_goblins", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_forest_bow", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "colossal_squig", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "armored_colossal_squig", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "wh_grn_forest_goblin_warboss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "grn_inf_night_goblin_spears", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "grn_inf_forest_spear", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "grn_inf_forest_sword", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "grn_inf_hill_goblins", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "grn_inf_forest_bow", 6); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "colossal_squig", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "armored_colossal_squig", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_goblins", "wh_grn_forest_goblin_warboss", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
