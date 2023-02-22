--[[
    Cataph's Southern Realms (TEB) 3.0: https://steamcommunity.com/sharedfiles/filedetails/?id=2927296206

    Last Updated: 21/02/2023
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Cataph's Southern Realms (TEB) 3.0).");

if dynamic_disasters then
    local error_message = false

    -- Add templates.
    error_message = dynamic_disasters:add_army_template_to_race("teb", "earlygame"); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_army_template_to_race("teb", "midgame"); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_army_template_to_race("teb", "lategame"); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Early Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_militia_spearmen", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_half_pikes", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_conqui_adventurers", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_duellists", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_militia_archers", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_xbowmen", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_handgunners", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Melee Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_light_scouts", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_conqui_lancers", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_militia_knights", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_conqui_riders", 2); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "wh_main_emp_art_mortar", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_light_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_duellist_hero", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_priestess", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "wh_main_teb_cha_wizard_fire_2", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "earlygame", "teb_duellist_hero_encarmine", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Mid Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_pikemen", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_conqui_adventurers", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_duellists", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_republican_guard", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_handgunners", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_border_rangers", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_pavisiers", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_guard_kossars", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Melee Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_militia_knights", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_freelance_knights", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_broken_lances", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_kotrs", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_conqui_riders", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_enforcers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_carabiniers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_xbow_cav", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_paymaster", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "wh_main_emp_art_mortar", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_light_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_galloper", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_duellist_hero", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_priestess", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "wh_main_teb_cha_wizard_fire_2", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "midgame", "teb_duellist_hero_encarmine", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Late Game
    ----------------------------------------

    -- Melee Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_pikemen", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_republican_guard", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_shieldbearers", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_bwatch", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_sisters", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_montante_greatswords", 6); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_pavisiers", 8); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_guard_kossars", 6); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_swash", 4); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_conqui_royal_guard", 4); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Melee Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_freelance_knights", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_broken_lances", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_kotrs", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_encarmine", 3); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_noble_retinue", 3); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Ranged Cavalry
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_enforcers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_carabiniers", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_xbow_cav", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_paymaster", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Artillery
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "wh_main_emp_art_mortar", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_light_cannon", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_galloper", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_tank", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    -- Heroes
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_duellist_hero", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_priestess", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "wh_main_teb_cha_wizard_fire_2", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("teb", "lategame", "teb_duellist_hero_encarmine", 1); if is_string(error_message) then out("\t\t" .. error_message); end

    ----------------------------------------
    ---- Code changes
    ----------------------------------------

    -- We need to replace the default TEB army template from Last Stand with the custom one for Southern Realms.
    local last_stand = dynamic_disasters:disaster("last_stand");
    if last_stand then
        last_stand.army_templates.wh_main_sc_teb_teb = { teb = "" };
        last_stand.army_templates["wh_main_teb_border_princes_CB"] = { teb = "" };
        last_stand.army_templates["wh_main_teb_estalia_CB"] = { teb = "" };
        last_stand.army_templates["wh_main_teb_tilea_CB"] = { teb = "" };
        last_stand.army_templates["wh2_main_emp_new_world_colonies_CB"] = { teb = "" };
        last_stand.army_templates["mixer_teb_southern_realms"] = { teb = "" };

        last_stand.mercenary_subcultures["wh_main_teb_border_princes_CB"] = true
        last_stand.mercenary_subcultures["wh_main_teb_estalia_CB"] = true
        last_stand.mercenary_subcultures["wh_main_teb_tilea_CB"] = true
        last_stand.mercenary_subcultures["wh2_main_emp_new_world_colonies_CB"] = true
        last_stand.mercenary_subcultures["mixer_teb_southern_realms"] = true
    end
end
