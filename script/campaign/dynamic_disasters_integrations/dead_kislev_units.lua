--[[
    Dead's Kislev Units: https://steamcommunity.com/sharedfiles/filedetails/?id=2789944159

    Last Updated: 13/01/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Dead's Kislev Units).");

if dynamic_disasters then
    local error_message = false

    ----------------------------------------
    -- Kislev templates
    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "earlygame", "kvassnic", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "earlygame", "uwu_cannon_crew", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Vehicles
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "earlygame", "ksl_war_wagon", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "midgame", "kvassnic", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "midgame", "uwu_cannon_crew", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "midgame", "wojtek", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "midgame", "frost_bear", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Vehicles
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "midgame", "ksl_war_wagon", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "lategame", "uwu_cannon_crew", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Monsters
    error_message = dynamic_disasters:add_unit_to_army_template("kislev", "lategame", "frost_bear", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
