--[[
    Expanded Roster - Beastmen: https://steamcommunity.com/sharedfiles/filedetails/?id=2874672190

    Dummy integration, as of yet there are no beastmen templates. To my future self, remember to make this work once you get beastmen incursions/chaos beastmen in.
    Last Updated: 21/11/2022
]]

--[[

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Beastmen).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Lategame Orcs
    ----------------------------------------
    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_black_orc_shields", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_black_orc_dual", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_big_uns_shields", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_inf_savage_big_great", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame_orcs", "wh_grn_orc_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    -- Lategame Savage Orcs
    ----------------------------------------
    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "grn_inf_savage_big_great", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("savage_orcs", "lategame", "wh_grn_savage_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end

end
]]
