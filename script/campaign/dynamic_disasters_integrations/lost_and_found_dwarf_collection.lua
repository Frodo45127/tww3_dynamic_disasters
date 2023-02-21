--[[
    Lost & Found: Dwarfs Collection: https://steamcommunity.com/sharedfiles/filedetails/?id=2897800168

    Last Updated: 21/02/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Lost & Found: Dwarfs Collection).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Dwarf templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame", "laf_dwf_inf_miners_steam_drills", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame", "laf_dwf_inf_thunderers_1", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame", "laf_dwf_veh_juggernaut_bolt_thrower", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame", "laf_dwf_veh_juggernaut_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_inf_miners_steam_drills", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_inf_slayers_pistols", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_inf_thunderers_1", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_inf_irondrakes_1", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_inf_crank_gunners", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_veh_juggernaut_bolt_thrower", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame", "laf_dwf_veh_juggernaut_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_inf_miners_steam_drills", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_inf_slayers_pistols", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_inf_thunderers_1", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_inf_irondrakes_1", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_inf_crank_gunners", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_veh_juggernaut_bolt_thrower", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_veh_juggernaut_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Vehicles
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame", "laf_dwf_veh_earth_borer", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end

