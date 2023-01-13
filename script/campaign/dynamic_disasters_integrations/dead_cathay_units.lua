--[[
    Dead's Cathay Unit Pack: https://steamcommunity.com/sharedfiles/filedetails/?id=2790154343

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Dead's Cathay Unit Pack).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Cathay templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "peasant_cav_archers", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_tiger", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_juggernaut_crew", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "midgame", "nangau_rifles", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "midgame", "rocket_troops", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "midgame", "cth_tiger", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "lategame", "bannerman", 6); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "lategame", "nangau_rifles", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "lategame", "rocket_troops", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "lategame", "battle_turtle", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
