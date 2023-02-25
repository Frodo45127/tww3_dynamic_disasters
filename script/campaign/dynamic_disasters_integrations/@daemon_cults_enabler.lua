--[[

    Companion module for Dynamic Disasters. Overwrites the vanilla daemon cult logic to allow cults for AI factions, and reduces the corruption threshold for it.

    This is loaded as integration because, unlike mods, integrations are loaded on first tick, after the game has initialized.

]]--

if cm:get_campaign_name() == "main_warhammer" then
    out("\tFrodo45127: Replacing daemon cult logic to allow AI to build them.");

    local cult_creation_cooldown_turns = 15;
    local chance_of_cult_creation = 25;

    local cultist_factions = {
        wh3_dlc20_kho_blood_keepers = true,
        wh3_main_kho_bloody_sword = true,
        wh3_main_kho_brazen_throne = true,
        wh3_main_kho_crimson_skull = true,
        wh3_main_kho_exiles_of_khorne = true,
        wh3_main_kho_karneths_sons = true,
        wh3_main_kho_khorne = true,
        wh3_dlc20_nur_pallid_nurslings = true,
        wh3_main_nur_bubonic_swarm = true,
        wh3_main_nur_maggoth_kin = true,
        wh3_main_nur_nurgle = true,
        wh3_main_nur_poxmakers_of_nurgle = true,
        wh3_main_nur_septic_claw = true,
        wh3_dlc20_sla_keepers_of_bliss = true,
        wh3_main_sla_exquisite_pain = true,
        wh3_main_sla_rapturous_excess = true,
        wh3_main_sla_seducers_of_slaanesh = true,
        wh3_main_sla_slaanesh = true,
        wh3_main_sla_subtle_torture = true,
        wh3_dlc20_tze_apostles_of_change = true,
        wh3_dlc20_tze_the_sightless = true,
        wh3_main_tze_all_seeing_eye = true,
        wh3_main_tze_broken_wheel = true,
        wh3_main_tze_flaming_scribes = true,
        wh3_main_tze_oracles_of_tzeentch = true,
        wh3_main_tze_sarthoraels_watchers = true,
        wh3_main_tze_tzeentch = true,
    };

    -- Reduced to 25, because in immortal empires it's already rare enough to reach this without rifts.
    CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN = 25;
    TURN_THRESHOLD_CHAOS_CULTS_CAN_SPAWN = 10;
    CHAOS_CULTURE_TO_CORRUPTION_TYPE_MAPPING = {
        ["wh3_main_kho_khorne"] = "wh3_main_corruption_khorne",
        ["wh3_main_nur_nurgle"] = "wh3_main_corruption_nurgle",
        ["wh3_main_sla_slaanesh"] = "wh3_main_corruption_slaanesh",
        ["wh3_main_tze_tzeentch"] = "wh3_main_corruption_tzeentch"
    };
    CHAOS_CULTURE_TO_CULT_FOREIGN_SLOT_TYPE_MAPPING = {
        ["wh3_main_kho_khorne"] = "wh3_main_slot_set_kho_cult",
        ["wh3_main_nur_nurgle"] = "wh3_main_slot_set_nur_cult",
        ["wh3_main_sla_slaanesh"] = "wh3_main_slot_set_sla_cult",
        ["wh3_main_tze_tzeentch"] = "wh3_main_slot_set_tze_cult"
    };

    local function construct_cult_data_on_setup()
        local cult_data = {};
        for chaos_culture, corruption_type in pairs(CHAOS_CULTURE_TO_CORRUPTION_TYPE_MAPPING) do
            local record = {};
            table.insert(record, corruption_type);
            table.insert(record, CHAOS_CULTURE_TO_CULT_FOREIGN_SLOT_TYPE_MAPPING[chaos_culture]);
            table.insert(record, {});
            cult_data[chaos_culture] = record;
        end;

        -- cult_data table looks like this
        --[[
        local cult_data = {
            ["wh3_main_kho_khorne"] =   {"wh3_main_corruption_khorne",      "wh3_main_slot_set_kho_cult", {}},
            ["wh3_main_nur_nurgle"] =   {"wh3_main_corruption_nurgle",      "wh3_main_slot_set_nur_cult", {}},
            ["wh3_main_sla_slaanesh"] = {"wh3_main_corruption_slaanesh",    "wh3_main_slot_set_sla_cult", {}},
            ["wh3_main_tze_tzeentch"] = {"wh3_main_corruption_tzeentch",    "wh3_main_slot_set_tze_cult", {}}
        };
        ]]

        return cult_data;
    end;

    function setup_daemon_cults()
        local cult_data = construct_cult_data_on_setup();
        local faction_list = cm:model():world():faction_list()
        local factions = {};

        -- Get the list of all daemon factions that can have these.
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            if cult_data[faction:culture()] and not faction:is_rebel() and cultist_factions[faction:name()] ~= nil then
                table.insert(factions, faction:name());
            end;
        end

        if #factions > 0 then
            core:add_listener(
                "ai_create_daemon_cults",
                "EndOfRound",
                function()
                    -- don't continue if we're not past turn 10
                    if cm:model():turn_number() < TURN_THRESHOLD_CHAOS_CULTS_CAN_SPAWN then
                        return false;
                    end;

                    -- only continue if a faction isn't on cooldown
                    for i = 1, #factions do
                        if not cm:get_saved_value(factions[i] .. "_create_cult_on_cooldown") then
                            return true;
                        end;
                    end;

                    -- don't continue if every faction is on cooldown
                    return false;
                end,
                function(context)
                    -- collect the valid regions that can have a cult created
                    local region_list = cm:model():world():region_manager():region_list();

                    for i = 0, region_list:num_items() - 1 do
                        local current_region = region_list:item_at(i);
                        local current_region_owner = current_region:owning_faction();

                        -- exclude any abandoned regions and regions owned by human daemon factions
                        if not current_region:is_abandoned() and not current_region_owner:is_rebel() and current_region:foreign_slot_managers():is_empty() and not (current_region_owner:is_human() and cult_data[current_region_owner:culture()]) then
                            for k, v in pairs(cult_data) do
                                if cm:get_corruption_value_in_region(current_region, v[1]) >= CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN then
                                    table.insert(v[3], current_region:cqi());
                                end;
                            end;
                        end;
                    end;

                    -- for each available faction, create a cult in a random valid region
                    for i = 1, #factions do
                        if cm:random_number(100) <= chance_of_cult_creation then
                            local current_faction_name = factions[i];
                            local current_faction = cm:get_faction(current_faction_name);
                            local current_faction_cult_data = cult_data[current_faction:culture()];
                            local available_regions = current_faction_cult_data[3];

                            if #available_regions > 0 and not cm:get_saved_value(current_faction_name .. "_create_cult_on_cooldown") then
                                local region_cqi = available_regions[cm:random_number(#available_regions)];
                                local fs = cm:add_foreign_slot_set_to_region_for_faction(current_faction:command_queue_index(), region_cqi, current_faction_cult_data[2]);
                                local region = fs:region();

                                out("\tFrodo45127: Building daemon cult for " .. current_faction_name .. " in " .. region:name() .. ".");

                                cm:trigger_incident_with_targets(current_faction:command_queue_index(), "wh3_main_incident_cult_manifests", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());

                                cm:set_saved_value(current_faction_name .. "_create_cult_on_cooldown", true);
                                cm:add_turn_countdown_event(current_faction_name, cult_creation_cooldown_turns, "ScriptEventResetCultCreationCooldown", current_faction_name);
                            end;
                        end;
                    end;

                    -- clear out the collected regions for next time
                    for k, v in pairs(cult_data) do
                        v[3] = {};
                    end;
                end,
                true
            );

            -- reset cooldowns
            core:add_listener(
                "ai_reset_cult_creation_cooldown",
                "ScriptEventResetCultCreationCooldown",
                true,
                function(context)
                    cm:set_saved_value(context.string .. "_create_cult_on_cooldown", false);
                end,
                true
            );
        end;
    end;

    -- Initialize it here.
    setup_daemon_cults()
end
