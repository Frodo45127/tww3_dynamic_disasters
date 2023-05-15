--[[
    Cataph's Kraka Drak: the Norse Dwarfs 3.0: https://steamcommunity.com/workshop/filedetails/?id=2878423760

    Last Updated: 24/02/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Cataph's Kraka Drak: the Norse Dwarfs 3.0).");

if dynamic_disasters then
    local error_message = false

    -- Add templates.
    error_message = dynamic_disasters:add_army_template_to_race("dwarfs", "earlygame_kraka_drak"); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_army_template_to_race("dwarfs", "midgame_kraka_drak"); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_army_template_to_race("dwarfs", "lategame_kraka_drak"); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "kraka_nor_marauders", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "kraka_nor_marauders_spears", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_miners_0", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_dwarf_warrior_0", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_dwarf_warrior_1", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_slayers", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "kraka_spikegunners", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_quarrellers_0", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_inf_quarrellers_1", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "kraka_marauder_horsemen", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_dlc06_dwf_art_bolt_thrower_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_art_grudge_thrower", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_cha_rune_smith_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_cha_master_engineer_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "earlygame_kraka_drak", "wh_main_dwf_cha_thane", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_dwarf_warrior_0", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_dwarf_warrior_1", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_longbeards", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_longbeards_1", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_braves", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_wardbearers", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_stormbeards", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_slayers", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_spikegunners", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_quarrellers_0", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_inf_quarrellers_1", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_pathgrinders", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_dlc06_dwf_inf_rangers_1", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_trollsearers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_frostgun", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "kraka_marauder_horsemen", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_dlc06_dwf_art_bolt_thrower_0", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_art_grudge_thrower", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_cha_rune_smith_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_cha_master_engineer_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "midgame_kraka_drak", "wh_main_dwf_cha_thane", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_inf_longbeards", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_inf_longbeards_1", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_inf_slayers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh2_dlc10_dwf_inf_giant_slayers", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_braves", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_wardbearers", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_stormbeards", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_huskarls", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_spikegunners", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_inf_quarrellers_0", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_inf_quarrellers_1", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_pathgrinders", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_dlc06_dwf_inf_rangers_1", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_trollsearers", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_frostgun", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_marauder_horsemen", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_dlc06_dwf_art_bolt_thrower_0", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_art_grudge_thrower", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "kraka_drakken", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_cha_rune_smith_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_cha_master_engineer_0", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("dwarfs", "lategame_kraka_drak", "wh_main_dwf_cha_thane", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Code changes
    ----------------------------------------

    -- Only perform function changes if we ended without an error message.
    if not is_string(error_message) then

        -- Changes for the last stand disaster, so reinforcements coming from Kraka Drak spawn modded units.
        local last_stand = dynamic_disasters:disaster("last_stand");
        if last_stand then
            last_stand.army_templates["ak_kraka_custom"] = { dwarfs = "" };

            last_stand.modded_template_key["ak_kraka_custom"] = function (template_key)
                return template_key .. "_kraka_drak";
            end
        end

        -- Changes for A Grudge too Far disaster.
        local grudge_too_far = dynamic_disasters:disaster("grudge_too_far");
        if grudge_too_far then
            grudge_too_far["spawn_army"] = function (_, faction_key, region_key, army_count)
                local template = grudge_too_far.army_template;
                if faction_key == "ak_kraka_custom" or faction_key == "wh_main_dwf_kraka_drak" then
                    template = { dwarfs = "lategame_kraka_drak" };
                end

                return dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, template, grudge_too_far.unit_count, false, army_count, grudge_too_far.name, nil, grudge_too_far.settings.factions)
            end
        end
    end
end
