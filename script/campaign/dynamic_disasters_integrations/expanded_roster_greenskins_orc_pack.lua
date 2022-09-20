--[[
    Expanded Roster - Greenskins - Orc Pack: https://steamcommunity.com/sharedfiles/filedetails/?id=2861674142

    Last Updated: 20/09/2022
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Greenskins - Orc Pack).");

if dynamic_disasters then
    local error_message = false

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_inf_black_orc_shields", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_inf_black_orc_dual", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_big_uns_shields", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_inf_savage_big_great", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_mon_savage_giant", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "wh_grn_orc_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "wh_grn_savage_boss", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
