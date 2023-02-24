--[[

    Companion module for Dynamic Disasters. Allows increasing armies spawned by underempire's Rat King building.

    This is loaded as integration because, unlike mods, integrations are loaded on first tick, after the game has initialized.

]]--

--------------------------------------------------------------------------------------------------------
-- If we do not control rats, replace the vanilla underempire warcamp to allow expanding their armies.
--------------------------------------------------------------------------------------------------------
local human_factions = cm:get_human_factions();
local man_sized_rats = true;
for _, faction_name in pairs(human_factions) do
    local faction = cm:get_faction(faction_name);
    if faction:subculture() == "wh2_main_sc_skv_skaven" then
        man_sized_rats = false;
        break;
    end
end

if man_sized_rats then
    out("Frodo45127: Replacing under_empire_war_camp_created, as no man-sized rats have been found.");

    -- Function to overwrite the vanilla underempire warcamp spawns with better ones, more in-line with this mod.
    ---@param region_key string #Region key where the army will spawn.
    ---@param faction FACTION_SCRIPT_INTERFACE #Faction that will own the spawned army.
    function under_empire_war_camp_created(region_key, faction)
        local faction_key = faction:name();
        local ram = random_army_manager;
        ram:remove_force("skaven_warcamp");
        ram:new_force("skaven_warcamp");

        local melee_unit_key = "wh2_main_skv_inf_clanrats_1";
        local spear_unit_key = "wh2_main_skv_inf_clanrat_spearmen_1";

        if cm:get_factions_bonus_value(faction, "under_empire_warcamp_upgrade") > 0 then
            melee_unit_key = "wh2_main_skv_inf_stormvermin_1";
            spear_unit_key = "wh2_main_skv_inf_stormvermin_0";
        end

        -- Standard Army
        ram:add_unit("skaven_warcamp", melee_unit_key, 3);
        ram:add_unit("skaven_warcamp", spear_unit_key, 2);
        ram:add_unit("skaven_warcamp", "wh2_main_skv_inf_plague_monks", 2);
        ram:add_unit("skaven_warcamp", "wh2_main_skv_mon_rat_ogres", 1);
        ram:add_unit("skaven_warcamp", "wh2_main_skv_art_plagueclaw_catapult", 1);

        local warcamp_bonus_values = {
            under_empire_warcamp_clanrat = melee_unit_key,
            under_empire_warcamp_plague_monk = "wh2_main_skv_inf_plague_monks",
            under_empire_warcamp_hell_pit = "wh2_main_skv_mon_hell_pit_abomination",
            under_empire_warcamp_catapult = "wh2_main_skv_art_plagueclaw_catapult",
            under_empire_warcamp_doomwheel = "wh2_main_skv_veh_doomwheel"
        };

        for bonus_value, unit_key in pairs(warcamp_bonus_values) do
            local num_units_to_add = cm:get_factions_bonus_value(faction, bonus_value)

            if num_units_to_add > 0 then
                for i = 1, num_units_to_add do
                    ram:add_unit("skaven_warcamp", unit_key, 1);
                end
            end
        end

        --local unit_count = random_army_manager:mandatory_unit_count("skaven_warcamp");
        local spawn_units = random_army_manager:generate_force("skaven_warcamp", 19, false);
        local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 9);

        local region = cm:get_region(region_key);
        local region_owner = region:owning_faction();
        local region_owner_key = region_owner:name();

        local settlement_x = region:settlement():logical_position_x();
        local settlement_y = region:settlement():logical_position_y();

        if pos_x > -1 then
            cm:create_force(
                faction_key,
                spawn_units,
                region_key,
                pos_x,
                pos_y,
                true,
                function(cqi)
                    cm:apply_effect_bundle_to_characters_force("wh2_dlc12_bundle_underempire_army_spawn", cqi, 5);
                    cm:add_character_vfx(cqi, "scripted_effect20", false);
                end
            );

            -- Declare War (if they are not team mates in MPC)
            if not faction:is_team_mate(region_owner) then
                cm:force_declare_war(faction_key, region_owner_key, false, false);
            end

            -- Destroy Under-City
            cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());

            -- Tell the army owner
            cm:show_message_event_located(
                faction_key,
                "event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_title",
                "regions_onscreen_" .. region_key,
                "event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_description",
                settlement_x,
                settlement_y,
                true,
                121
            );

            -- Tell the region owner
            cm:show_message_event_located(
                region_owner_key,
                "event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_title",
                "regions_onscreen_" .. region_key,
                "event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_description_target",
                settlement_x,
                settlement_y,
                true,
                121
            );

            -- Frodo45127: Additionally, we spawn slave armies depending on if we're running a disaster that uses this or not.
            local part_of_disaster = false;
            for _, disaster in pairs(dynamic_disasters.disasters) do
                if (disaster.name == "skaven_incursions" or disaster.name == "the_vermintide") and disaster.settings.started == true and disaster.settings.finished == false then
                    part_of_disaster = disaster;
                    break;
                end
            end

            if not part_of_disaster == false then
                local current_turn = cm:turn_number();
                local army_count_base = 0.25
                if current_turn >= 50 and current_turn < 100 then
                    army_count_base = 0.5;
                elseif current_turn >= 100 then
                    army_count_base = 0.75;
                end

                local army_count = math.ceil(army_count_base + part_of_disaster.settings.difficulty_mod)
                out("Frodo45127: Spawning trash army for skaven attack on region " .. region_key .. " for " .. faction:name() .. ".")
                dynamic_disasters:create_scenario_force(faction:name(), region_key, { skaven = "lategame_trash" }, part_of_disaster.unit_count, false, army_count, part_of_disaster.name, nil)
            end
            -- End of custom changes.
        end
    end

else
    out("Frodo45127: man-sized rats have been found, using vanilla under_empire_war_camp_created.");
end
