--[[
    Expanded Roster - Greenskins - Goblin Pack: https://steamcommunity.com/sharedfiles/filedetails/?id=2863393121

    Last Updated: 20/09/2022
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Expanded Roster - Greenskins - Goblin Pack).");

if dynamic_disasters then
    local error_message = false

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_inf_forest_bow", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "grn_inf_night_goblin_spears", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "colossal_squig", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "armored_colossal_squig", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("greenskins", "lategame", "wh_grn_forest_goblin_warboss", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
