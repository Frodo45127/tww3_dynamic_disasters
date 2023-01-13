--[[
    Expanded Roster - Greenskins - Orc Pack: https://steamcommunity.com/sharedfiles/filedetails/?id=2861674142

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Greenskins - Orc Pack).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Greeenskin templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_inf_orc_boyz_spear", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_big_uns_shields", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "grn_mon_savage_giant", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "earlygame", "wh_grn_orc_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_orc_boyz_spear", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_big_uns_shields", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_savage_orc_spear", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_inf_savage_big_great", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "midgame", "wh_grn_orc_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_black_orc_shields", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_black_orc_dual", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_big_uns_shields", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_savage_big_great", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "wh_grn_orc_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end


    ----------------------------------------
    -- Savage Orc templates
    ----------------------------------------
    ---- Late game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "grn_inf_savage_big_great", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "wh_grn_savage_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

end
