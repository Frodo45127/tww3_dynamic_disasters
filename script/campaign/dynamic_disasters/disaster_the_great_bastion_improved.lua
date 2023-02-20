--[[
    The Great Bastion (Improved), By Frodo45127.

    This disaster effectively replaces the vanilla Great Bastion mechanic for Cathay, making it toggleable, extensible and tweakable.
    UI-related stuff is dealt the same way as the vanilla script: through script states.

    Unlike other disasters, this triggers from the start, same trigger logic as the vanilla script.

    The main changes of this vs the vanilla one are:
    - Status tracking moved from random saved values to disaster settings.
    - Dragon Emperor's Wrath compass effect now causes a storm to appear.
    - It uses Dynamic Disaster's army templates for invading armies instead of hardcoded army compositions.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;

the_great_bastion_improved = {
    name = "the_great_bastion_improved",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = {},
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
        --"wh3_main_chaos",
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        revive_dead_factions = false,       -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        short_victory_is_min_turn = false,  -- If the short victory turn should be used as min turn.
        long_victory_is_min_turn = false,   -- If the long victory turn should be used as min turn.
        min_turn = 1,                       -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        -- Disaster-specific settings
        invasion_duration_threshold = 20,               -- number of turns an invasion can last until the threat meter is reset
        base_threat_per_turn = 6,                       -- percentage to add to threat meter each turn
        base_gate_threat_increase = 2,                  -- percentage to add to threat meter each turn per gate that is razed/not owned by cathay
        destroyed_army_threat_reduction = 20,           -- percentage to remove from threat meter each time a kurgan warband army is destroyed. keep in parity with wh3_main_incident_cth_bastion_threat_decreases_kill in campaign_payload_ui_details
        max_threat_value = 100,                         -- maximum amount the threat meter can be
        max_regions_unoccupied_by_cathay = 8,           -- how many regions need to be not be occupied by cathay for the threat meter to reset

        invasion_duration = 0,                          -- Duration of the current invasion.
        threat_value = 10,                              -- Current Bastion thread value.
        invasion_active = false,                        -- If the kurgan invasion is active.
        gate_to_focus = "",                             -- Gate that we'll use when declaring an invasion.
        pre_invasion_1_passed = false,                  -- This keeps track if we triggered the T-1 turn code or we skipped it for the current invasion.
        pre_invasion_2_passed = false,                  -- This keeps track if we triggered the T-2 turn code or we skipped it for the current invasion.

        spawn_locations_used = {},                      -- List of coordinates used each turn by each gate, to try and not repite coordinates when spawning armies.
        spawn_locations_by_gate = {},
        cathay_bastion_regions = {},
        dragon_emperors_wrath_region_list = {},

        army_template = {
            norsca = "earlygame",
        },
        extra_army_templates = {
            "khorne",
            "nurgle",
            "slaanesh",
            "tzeentch",
        },
        army_count_main_gate = 8,
        army_count_secondary_gates = 4,
    },

    bastion_threat_modifier_compass = "bastion_threat_modifier_compass",    -- Modifier to the current thread by Compass position.
    bastion_threat_modifier = "bastion_threat_modifier",                    -- Modifier to the current thread by Edicts.

    -- UI Variables. This is what we need to set to update the UI.
    ui_bastion_threat = "bastion_threat",                               -- Current bastion thread. Note that for some bizarre reason the UI does a *100 on the thread, so we have to pass it as /100
    ui_base_threat_per_turn = "base_threat_per_turn",                   -- Base thread per turn, before modifiers.
    ui_base_gate_threat_increase = "base_gate_threat_increase",         -- Thread modifier per razed/lost gate.
    ui_bastion_threat_change = "bastion_threat_change",                 -- Thread change expected for the next turn.
    ui_base_compass_threat_decrease = "base_compass_threat_decrease",   -- UI value for the compass pointing to the bastion.
    ui_base_gate_threat_reduction_value = "base_gate_threat_reduction_value",

    cathay_subculture = "wh3_main_sc_cth_cathay",
    invasion_faction = "wh3_main_rogue_kurgan_warband",

    message_keys = { -- incident mapping
        ["begin_attack"] = "wh3_main_incident_cth_bastion_threat_maximum",
        ["threat_increasing"] = "wh3_main_incident_cth_bastion_threat_increases",
        ["threat_decreasing"] = "wh3_main_incident_cth_bastion_threat_decreases",
        ["invasion_successful"] = "wh3_main_incident_cth_bastion_invasion_successful",
        ["invader_killed"] = "wh3_main_incident_cth_bastion_threat_decreases_kill"
    },

    cathay_bastion_regions = { -- list of regions close to the bastion, should a number of them not be occupied by cathay or in ruins, then stop the invasions
        "wh3_main_chaos_region_snake_gate",
        "wh3_main_chaos_region_turtle_gate",
        "wh3_main_chaos_region_dragon_gate",
        "wh3_main_chaos_region_nan_gau",
        "wh3_main_chaos_region_mines_of_nan_yang",
        "wh3_main_chaos_region_terracotta_graveyard",
        "wh3_main_chaos_region_po_mei",
        "wh3_main_chaos_region_ming_zhu",
        "wh3_main_chaos_region_city_of_the_shugengan",
        "wh3_main_chaos_region_wei_jin",
        "wh3_main_chaos_region_weng_chang",
    },
    cathay_bastion_regions_combi = {
        "wh3_main_combi_region_snake_gate",
        "wh3_main_combi_region_turtle_gate",
        "wh3_main_combi_region_dragon_gate",
        "wh3_main_combi_region_nan_gau",
        "wh3_main_combi_region_haichai",
        "wh3_main_combi_region_terracotta_graveyard",
        "wh3_main_combi_region_po_mei",
        "wh3_main_combi_region_ming_zhu",
        "wh3_main_combi_region_city_of_the_shugengan",
        "wh3_main_combi_region_wei_jin",
        "wh3_main_combi_region_weng_chang"
    },

    dragon_emperors_wrath_region_list = { -- list of regions to apply dragon emperor's wrath compass ability to
        "wh3_main_chaos_region_snake_gate",
        "wh3_main_chaos_region_turtle_gate",
        "wh3_main_chaos_region_dragon_gate",
        "wh3_main_chaos_region_fortress_of_eyes",
        "wh3_main_chaos_region_iron_storm",
        "wh3_main_chaos_region_dragons_crossroad",
        "wh3_main_chaos_region_red_fortress"
    },
    dragon_emperors_wrath_region_list_combi = {
        "wh3_main_combi_region_snake_gate",
        "wh3_main_combi_region_turtle_gate",
        "wh3_main_combi_region_dragon_gate",
        "wh3_main_combi_region_fortress_of_eyes",
        "wh3_main_combi_region_iron_storm",
        "wh3_main_combi_region_dragons_crossroad",
        "wh3_main_combi_region_red_fortress"
    },

    spawn_locations_by_gate = { -- possible locations to spawn new kurgan warband armies
        {
            gate_key = "wh3_main_chaos_region_snake_gate",
            spawn_locations = {
                {848, 579},
                {860, 557},
                {847, 569},
                {852, 582},
                {871, 580},
                {840, 579}
            }
        },
        {
            gate_key = "wh3_main_chaos_region_turtle_gate",
            spawn_locations = {
                {882, 671},
                {885, 639},
                {872, 647},
                {893, 654},
                {884, 675},
                {903, 670}
            }
        },
        {
            gate_key = "wh3_main_chaos_region_dragon_gate",
            spawn_locations = {
                {861, 614},
                {883, 617},
                {868, 620},
                {855, 611},
                {865, 605},
                {879, 600}
            }
        }
    },
    spawn_locations_by_gate_combi = {
        {
            gate_key = "wh3_main_combi_region_snake_gate",
            spawn_locations = {
                {1164, 685},
                {1158, 700},--{1156, 670},
                {1167, 697},
                {1185, 684},--{1185, 676},
                {1177, 691}--{1170, 691}
            }
        },
        {
            gate_key = "wh3_main_combi_region_turtle_gate",
            spawn_locations = {
                {1264, 668},
                {1228, 675},
                {1266, 669},
                {1252, 702},--{1243, 695},
                {1241, 680},
                {1224, 697},--{1235, 694}
            }
        },
        {
            gate_key = "wh3_main_combi_region_dragon_gate",
            spawn_locations = {
                {1212, 686},
                {1211, 690},
                {1210, 699},
                {1223, 675},
                {1208, 695},--{1199, 695},
                {1192, 679}--{1292, 679} Pretty sure this one's a typo, 1292 is far from the gate.
            }
        }
    },
}

--- Callback applied to spawned armies. This one is here because it needs to be before the listeners.
local function invaders_callback(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
    local general = cm:get_character_by_cqi(cqi)
    local invasion = invasion_manager:get_invasion(cqi)

    if not invasion then
        invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())
    end

    local m_x = general:logical_position_x()
    local m_y = general:logical_position_y()

    invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1)

    local coords = {{x = m_x, y = m_y},{x = m_x, y = m_y}}
    invasion:set_target("PATROL", coords, nil)
    invasion:add_aggro_radius(5)
    if invasion:has_target() then
        out.design("\t\tFrodo45127: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to be stationary")
        invasion:start_invasion(nil, true, false, false)
    end
end

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function the_great_bastion_improved:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Kill the bastion on every reload.
        self:disable_vanilla_great_bastion();

        -- Update the UI on load.
        self:reload_ui();

        -- reduce the threat each time a kurgan warband army is defeated in battle, or end the active invasion if they die entirely
        core:add_listener(
            "the_great_bastion_improved_check_bastion_threat_battle",
            "BattleCompleted",
            function()
                return cm:pending_battle_cache_faction_is_involved(self.invasion_faction)
            end,
            function()
                if cm:pending_battle_cache_attacker_victory() and cm:pending_battle_cache_faction_is_defender(self.invasion_faction) and not self.settings.invasion_active then
                    out.design("Frodo45127: Kurgan army destroyed in battle, modifying threat by -" .. self.settings.destroyed_army_threat_reduction)

                    self:trigger_incident_only_for_cathay(self.message_keys["invader_killed"], true)

                    self.settings.threat_value = math.max(self.settings.threat_value - self.settings.destroyed_army_threat_reduction, 1)
                    cm:set_script_state(self.ui_bastion_threat, math.min(self.settings.threat_value / 100, 1.0))
                end

                if cm:get_faction(self.invasion_faction):is_dead() then
                    self:end_bastion_invasion(false)
                end
            end,
            true
        )

        -- Listener to handle updating the Threat level each turn, and triggering invasions when needed.
        core:add_listener(
            "the_great_bastion_improved_respawn_bastion_besiegers",
            "WorldStartRound",
            true,
            function()
                local turn_number = cm:model():turn_number()
                local kurgan_warband = cm:get_faction(self.invasion_faction)

                -- Recalculate the current threat level
                self.settings.threat_value = math.min(self.settings.threat_value + self:get_threat_increase_value(), self.settings.max_threat_value)
                cm:set_script_state(self.ui_bastion_threat, math.min(self.settings.threat_value / 100, 1.0))

                -- If the faction is dead end any active invasion.
                if kurgan_warband:is_dead() then
                    self:end_bastion_invasion(false)
                end

                -- If there isn't an active invasion but we got razed/uncontrolled gates, spawn small armies under ai control up to the number of razed gates.
                if not self.settings.invasion_active then
                    local gates_lost = 0

                    for i = 1, #self.settings.spawn_locations_by_gate do
                        local region = cm:get_region(self.settings.spawn_locations_by_gate[i].gate_key);
                        if region:is_abandoned() or region:owning_faction():subculture() ~= self.cathay_subculture then
                            gates_lost = gates_lost + 1
                        end
                    end

                    -- TODO: this is... fucking weak. Change it for a more punishing alternative.
                    local armies_to_spawn = gates_lost - kurgan_warband:military_force_list():num_items()
                    if armies_to_spawn > 0 then
                        local template_key = "earlygame";
                        if turn_number >= 30 and turn_number < 60 then
                            template_key = "midgame";
                        elseif turn_number >= 60 then
                            template_key = "lategame";
                        end

                        for i = 1, math.min(armies_to_spawn, #self.settings.spawn_locations_by_gate) do
                            local gate = self.settings.spawn_locations_by_gate[i]
                            local coordinates = gate.spawn_locations[1]
                            local template = table.copy(self.settings.army_template);

                            for key, value in pairs(template) do
                                template[key] = template_key
                            end

                            dynamic_disasters:create_scenario_force_at_coords(self.invasion_faction, gate.gate_key, coordinates, template, 14, false, 1, self.name, invaders_callback);
                            self:spawn_army(7, "chaos_besiegers_1", coordinates)
                            out.design("\tFrodo45127: Spawning small army for [" .. gate.gate_key .. "] at position [" .. coordinates[1] .. ", " .. coordinates[2] .. "]")
                        end

                        local mf_list = kurgan_warband:military_force_list()
                        for i = 0, mf_list:num_items() - 1 do
                            dynamic_disasters:release_military_force(mf_list:item_at(i))
                        end
                    end

                end

                -- Threat growing but not yet at max level.
                if not self.settings.invasion_active and self.settings.threat_value < self.settings.max_threat_value then
                    local threat_increase = self:get_threat_increase_value()

                    -- If we're one turn from full invasion.
                    if self.settings.threat_value + threat_increase >= self.settings.max_threat_value then
                        self:trigger_pre_invasion_1(false);

                    -- If we're two turns from full invasion, select a random gate to target and warn the player.
                    elseif self.settings.threat_value + (2 * threat_increase) >= self.settings.max_threat_value then
                        self:trigger_pre_invasion_2(false);
                    end

                -- Threat meter at max, not invasion triggered yet (time to trigger it).
                elseif not self.settings.invasion_active and self.settings.threat_value >= self.settings.max_threat_value then

                    -- Make sure the pre-stuff gets properly triggered if it wasn't before, or otherwise this will end within a turn.
                    --
                    -- Note: trigger_pre_invasion_2 swaps the focused gate. We don't want that at this point.
                    if self.settings.pre_invasion_2_passed == true then
                        --self:trigger_pre_invasion_2(true);
                        self.settings.pre_invasion_2_passed = false;
                    end

                    if self.settings.pre_invasion_1_passed == true then
                        self:trigger_pre_invasion_1(true);
                        self.settings.pre_invasion_1_passed = false;
                    end

                    -- TODO: change this. If the gate is too strong, the armies just stand there.
                    local mf_list = kurgan_warband:military_force_list()
                    for i = 0, mf_list:num_items() - 1 do
                        dynamic_disasters:release_military_force(mf_list:item_at(i))
                    end

                    self.settings.invasion_active = true;
                    self:trigger_incident_only_for_cathay(self.message_keys["begin_attack"], true)
                    out("Frodo45127: Beginning invasion!")

                -- Invasion is currently ongoing.
                else
                    -- check if the invasion has lasted the maximum number of turns, if so, end it
                    if self.settings.invasion_duration >= self.settings.invasion_duration_threshold then
                        self:end_bastion_invasion(false)
                    else
                        self.settings.invasion_duration = self.settings.invasion_duration + 1;
                    end
                end

                -- Respawn heroes every 5 turns
                if turn_number % 5 == 0 then
                    self:spawn_bastion_agent_if_none()
                end

                -- If an invasion is active, count how many regions are not occupied by cathay. if enough have been lost, end the invasion
                local region_unoccupied_count = 0
                for i = 1, #self.settings.cathay_bastion_regions do
                    local current_bastion_region = cm:get_region(self.settings.cathay_bastion_regions[i])
                    if current_bastion_region:is_abandoned() or current_bastion_region:owning_faction():subculture() ~= self.cathay_subculture then
                        region_unoccupied_count = region_unoccupied_count + 1
                    end
                end

                if region_unoccupied_count >= self.settings.max_regions_unoccupied_by_cathay then
                    out("Frodo45127: Bastion invasion destroyed too much. Stopping invasion")
                    self:end_bastion_invasion(true)
                end

                -- Ensure kurgan warband and dreaded wo are always allied
                local dreaded_wo = cm:get_faction("wh3_main_chs_dreaded_wo")
                if dreaded_wo and not kurgan_warband:allied_with(dreaded_wo) then
                    cm:disable_event_feed_events(true, "", "", "diplomacy_treaty_negotiated_military_alliance")
                    cm:force_alliance(self.invasion_faction, "wh3_main_chs_dreaded_wo", true)
                    cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_treaty_negotiated_military_alliance") end, 0.2)
                end
            end,
            true
        )

        -- Listener to handle Emperor's Wrath compass power activation.
        core:add_listener(
            "the_great_bastion_improved_emperors_wrath_activated",
            "WoMCompassUserActionTriggeredEvent",
            function(context)
                return context:action() == "apply_attrition_to_enemies_in_direction"
            end,
            function()
                for i = 1, #self.settings.dragon_emperors_wrath_region_list do
                    cm:apply_effect_bundle_to_region("wh3_region_payload_compass_wrath", self.settings.dragon_emperors_wrath_region_list[i], 3)
                end

                if cm:get_local_faction_subculture(true) == self.cathay_subculture then
                    CampaignUI.ClosePanel("cathay_compass")
                    cuim:start_scripted_sequence()

                    cm:scroll_camera_with_cutscene_to_settlement(3, function() cuim:stop_scripted_sequence() end, self.settings.dragon_emperors_wrath_region_list[1])
                end
            end,
            true
        )

        -- Listener to trigger a custom intro when Miao Ying or Zhao Ming defend the bastion. Discovered it by accident. It's a fun detail.
        core:add_listener(
            "the_great_bastion_improved_player_defends_bastion_battle",
            "BattleBeingFought",
            function()
                cm:remove_custom_battlefield("bastion_battle")

                local pb = cm:model():pending_battle()

                if pb:has_defender() then
                    local defender = pb:defender()
                    local subtype = defender:character_subtype_key()

                    if pb:siege_battle() and (subtype == "wh3_main_cth_miao_ying" or subtype == "wh3_main_cth_zhao_ming") and defender:faction():is_human() then
                        local region_key = pb:region_data():key()

                        for i = 1, #self.settings.spawn_locations_by_gate do
                            if region_key == self.settings.spawn_locations_by_gate[i].gate_key then
                                return true
                            end
                        end
                    end
                end
            end,
            function()
                local pb = cm:model():pending_battle()
                local script = "script/battle/quest_battles/cathay_bastion/miao_ying/battle_script.lua"

                if pb:defender():character_subtype_key() == "wh3_main_cth_zhao_ming" then
                    script = "script/battle/quest_battles/cathay_bastion/zhao_ming/battle_script.lua"
                end

                local x, y = pb:display_position()

                cm:add_custom_battlefield(
                    "bastion_battle",       -- string identifier
                    x,                      -- x co-ord
                    y,                      -- y co-ord
                    9999,                   -- radius around position
                    false,                  -- will campaign be dumped
                    "",                     -- loading override
                    script,                 -- script override
                    "",                     -- entire battle override
                    0,                      -- human alliance when battle override
                    false,                  -- launch battle immediately
                    true,                   -- is land battle (only for launch battle immediately)
                    false                   -- force application of autoresolver result
                )
            end,
            true
        )

        -- Listener to recalculate bastion thread at turn start. Otherwise the bloody thing always lags 1 turn.
        core:add_listener(
            "the_great_bastion_improved_update_ui",
            "ScriptEventHumanFactionTurnStart",
            function(context)
                local faction = context:faction();
                return faction:subculture() == self.cathay_subculture and faction:is_human();
            end,
            function()
                self:reload_ui()
            end,
            true
        )

        -- Listener to recalculate bastion thread depending on Compass changes.
        core:add_listener(
            "the_great_bastion_improved_reload_bastion_threat_UI_compass",
            "WoMCompassUserDirectionSelectedEvent",
            true,
            function()
                self:get_threat_increase_value()
            end,
            true
        )

        -- Listener to recalculate bastion thread depending on regions changed (in case we lost a bastion gate).
        core:add_listener(
            "the_great_bastion_improved_reload_bastion_threat_UI_region",
            "RegionFactionChangeEvent",
            function (context)
                local key = context:region():name();

                for i = 1, #self.settings.spawn_locations_by_gate do
                    if key == self.settings.spawn_locations_by_gate[i].gate_key then
                        return true
                    end
                end

                return false;
            end,
            function()
                self:get_threat_increase_value()
            end,
            true
        )

    end

end

-- Function to trigger the early warning before the disaster.
function the_great_bastion_improved:start()
    self:trigger_the_great_bastion_improved();
end

-- Function to trigger cleanup stuff after the invasion is over.
function the_great_bastion_improved:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end disaster.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function the_great_bastion_improved:check_start()

    -- Same logic as in the vanilla disaster: if we're in combi and no cathayan players are in, do not start it.
    return (cm:get_campaign_name() == "main_warhammer" and #cm:get_human_factions_of_subculture(self.cathay_subculture) < 1) == false
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function the_great_bastion_improved:check_finish()
    return false;
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

--- Function to disable the vanilla Bastion mechanic.
function the_great_bastion_improved:disable_vanilla_great_bastion()
    out("Frodo45127: Disabling vanilla Great Bastion logic.");

    -- These should be all the listeners the Bastion mechanic uses to update its status.
    core:remove_listener("check_bastion_threat_battle");
    core:remove_listener("respawn_bastion_besiegers");
    core:remove_listener("emperors_wrath_activated");
    core:remove_listener("player_defends_bastion_battle");
    core:remove_listener("reload_bastion_threat_UI_compass");
    core:remove_listener("reload_bastion_threat_UI_region");

    out("Frodo45127: Disabled vanilla Great Bastion logic.");
end

--- Function to trigger the disaster.
function the_great_bastion_improved:trigger_the_great_bastion_improved()
    out("Frodo45127: Great Bastion Improved started.");

    local combined_map = cm:get_campaign_name() == "main_warhammer"
    if combined_map then
        self.settings.spawn_locations_by_gate = self.spawn_locations_by_gate_combi
        self.settings.cathay_bastion_regions = self.cathay_bastion_regions_combi
        self.settings.dragon_emperors_wrath_region_list = self.dragon_emperors_wrath_region_list_combi
    else
        self.settings.spawn_locations_by_gate = self.spawn_locations_by_gate
        self.settings.cathay_bastion_regions = self.cathay_bastion_regions
        self.settings.dragon_emperors_wrath_region_list = self.dragon_emperors_wrath_region_list
    end

    -- Initialize this so, in the situation when we bypass the two-turn warning due to a sudden increase on threat, we still have a gate key.
    self.settings.gate_to_focus = self:get_random_gate();

    -- Disable Public Order for the Bastion Gatehouses
    for i = 1, #self.settings.spawn_locations_by_gate do
        cm:set_public_order_disabled_for_province_for_region_for_all_factions_and_set_default(self.settings.spawn_locations_by_gate[i].gate_key, true)
    end

    -- Setup listeners and let it run.
    self:reload_ui();
    self:set_status(STATUS_TRIGGERED);
end

--- Function to trigger the code that must execute one turn before invasion happens.
---@param forced boolean #If we're forcing this function to trigger out of time.
function the_great_bastion_improved:trigger_pre_invasion_1(forced)
    local turn_number = cm:model():turn_number()
    local kurgan_warband = cm:get_faction(self.invasion_faction)

    -- get the army strength data based on turn number and difficulty, and spawn the armies
    local template_key = "earlygame";
    if turn_number >= 30 and turn_number < 60 then
        template_key = "midgame";
    elseif turn_number >= 60 then
        template_key = "lategame";
    end

    local secondary_armies = math.ceil(self.settings.difficulty_mod * 2);
    local main_armies = math.ceil(secondary_armies * 2);

    for i = 1, #self.settings.spawn_locations_by_gate do
        local current_gate = self.settings.spawn_locations_by_gate[i].gate_key;

        -- Give the focus gate a few more armies than normal.
        if current_gate == self.settings.gate_to_focus then
            for j = 1, main_armies do
                local position = self:get_random_position_for_gate(current_gate);
                local template = table.copy(self.settings.army_template);

                for key, value in pairs(template) do
                    template[key] = template_key
                end

                -- Add a random chaos god template in the mix to spice up the main armies.
                template[self.settings.extra_army_templates[cm:random_number(#self.settings.extra_army_templates)]] = template_key;
                dynamic_disasters:create_scenario_force_at_coords(self.invasion_faction, current_gate, position, template, 19, false, 1, self.name, invaders_callback);
            end
        else
            for j = 1, secondary_armies do
                local position = self:get_random_position_for_gate(current_gate);
                local template = table.copy(self.settings.army_template);

                for key, value in pairs(template) do
                    template[key] = template_key
                end

                dynamic_disasters:create_scenario_force_at_coords(self.invasion_faction, current_gate, position, template, 19, false, 1, self.name, invaders_callback);
            end
        end
    end

    -- Spawn agents to accompany armies.
    self:spawn_bastion_agent_if_none()
end

--- Function to trigger the code that must execute two turns before invasion happens.
---@param forced boolean #If we're forcing this function to trigger out of time.
function the_great_bastion_improved:trigger_pre_invasion_2(forced)
    self.settings.pre_invasion_2_passed = true;
    self.settings.gate_to_focus = self:get_random_gate()

    if not forced == true then
        self:trigger_incident_only_for_cathay(self.message_keys["threat_increasing"], false, self.settings.gate_to_focus)
    end

    out("Frodo45127: Invasion is near, selecting [" .. self.settings.gate_to_focus .. "] as a target")
end

--- Function to get the current threat increase value, made up of the base threat, bastions not controlled by cathay and any bonus values.
function the_great_bastion_improved:get_threat_increase_value()
    local threat_increase = self.settings.base_threat_per_turn

    -- Threat modifiers by razed/lost gates.
    for i = 1, #self.settings.spawn_locations_by_gate do
        local gate_key = self.settings.spawn_locations_by_gate[i].gate_key
        local current_bastion_region = cm:get_region(gate_key)

        if current_bastion_region:is_abandoned() or current_bastion_region:owning_faction():subculture() ~= self.cathay_subculture then
            out("Frodo45127: Bastion [" .. gate_key .. "] is not occupied by Cathay - adding: " .. self.settings.base_gate_threat_increase)
            threat_increase = threat_increase + self.settings.base_gate_threat_increase
        end
    end

    -- Thread modifiers from other sources (mainly compass and edicts).
    local bonus_values = self:collect_threat_bonus_values();
    threat_increase = math.max(threat_increase + bonus_values, 1)

    out("Frodo45127: Current bastion threat change is: " .. threat_increase .. " (bonus values are " .. bonus_values .. ")")
    cm:set_script_state(self.ui_bastion_threat_change, threat_increase)

    return threat_increase
end

--- Trigger an incident only for all human Cathay factions.
function the_great_bastion_improved:trigger_incident_only_for_cathay(incident_key, target_kurgan_warband, region)
    local human_factions = cm:get_human_factions(true)

    for i = 1, #human_factions do
        local current_human_faction = cm:get_faction(human_factions[i])

        if current_human_faction:culture() == "wh3_main_cth_cathay" then
            if target_kurgan_warband then
                cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, cm:get_faction(self.invasion_faction):command_queue_index(), 0, 0, 0, 0, 0)
            elseif region then
                cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, 0, 0, 0, 0, cm:get_region(region):cqi(), 0)
            else
                cm:trigger_incident(human_factions[i], incident_key, true)
            end
        end
    end
end

--- Function to end the current invasion.
---@param invasion_successful boolean #If the invasion was a success or not.
function the_great_bastion_improved:end_bastion_invasion(invasion_successful)
    if not self.settings.invasion_active then
        return false
    end

    out("Frodo45127: Bastion invasion has finished. Is success? " .. invasion_successful .. ". Resetting threat.");

    self.settings.invasion_active = false;
    self.settings.invasion_duration = 0;
    cm:set_script_state(self.ui_bastion_threat, 1.0)

    if invasion_successful then
        self:trigger_incident_only_for_cathay(self.message_keys["invasion_successful"], true)
    else
        self:trigger_incident_only_for_cathay(self.message_keys["threat_decreasing"], true)
    end
end

--- Spawn a hero if the kurgan warband faction doesn't have any.
function the_great_bastion_improved:spawn_bastion_agent_if_none()
    local faction = cm:get_faction(self.invasion_faction)

    if not cm:faction_contains_agents(faction) then
        local position = self:get_random_position_for_gate(self:get_random_gate())
        local x, y = cm:find_valid_spawn_location_for_character_from_position(self.invasion_faction, position[1], position[2], false, 5)
        local agent = cm:spawn_agent_at_position(faction, x, y, "wizard")
        if not agent:is_null_interface() then
            out("Frodo45127: Spawned Kurgan Warband hero at [" .. x .. ", " .. y .. "] with name: [" .. common.get_localised_string(agent:get_forename()) .. "]")
        end
    end
end

--- This function reloads all the data needed by the UI, so we can keep it more up to date.
function the_great_bastion_improved:reload_ui()

    -- Update bonuses applied to the bastion.
    self:get_threat_increase_value()
    self:collect_threat_bonus_values()

    cm:set_script_state(self.ui_bastion_threat, math.min(self.settings.threat_value / 100, 1.0))            -- Current bastion thread. We need to initialize it here to support mid-campaign enabling.
    cm:set_script_state(self.ui_base_threat_per_turn, self.settings.base_threat_per_turn)                   -- This one never changes, so it can be left as is.
    cm:set_script_state(self.ui_base_gate_threat_increase, self.settings.base_gate_threat_increase)         -- Base thread per turn, before modifiers. This doesn't change either.

    for i = 1, #self.settings.spawn_locations_by_gate do
        local gate_key = self.settings.spawn_locations_by_gate[i].gate_key;
        local region = cm:get_region(gate_key);
        local value = self:get_threat_bonus_values_from_region(region);
        cm:set_script_state(gate_key .. self.ui_base_gate_threat_reduction_value, value)
    end
end


--- Function to get the bonus values to threat from compass and province edicts.
--- NOTE: Compass bonus is applied on a region basis. Meaning while it says we're applying -2% due to compass pointed to bastion,
--- internally we check each each region for said -2%, and if found in one of them, we just show it. Took me a while to realise this.
function the_great_bastion_improved:collect_threat_bonus_values()
    local bonus_value = 0
    local compass_bonus_value = 0

    for i = 1, #self.settings.spawn_locations_by_gate do
        local current_bastion_region = cm:get_region(self.settings.spawn_locations_by_gate[i].gate_key)
        local regions_compass_bonus_value = cm:get_regions_bonus_value(current_bastion_region, self.bastion_threat_modifier_compass);

        -- Bonus value per-region. This usually comes from edicts.
        if not current_bastion_region:is_abandoned() and current_bastion_region:owning_faction():subculture() == self.cathay_subculture then
            bonus_value = bonus_value + self:get_threat_bonus_values_from_region(current_bastion_region);
        end

        -- The first region we find the compass bonus value in a region, we register it.
        -- We ignore it in the other regions.
        if compass_bonus_value == 0 and regions_compass_bonus_value ~= 0 then
            compass_bonus_value = regions_compass_bonus_value
            cm:set_script_state(self.ui_base_compass_threat_decrease, compass_bonus_value)
        end
    end

    bonus_value = bonus_value + compass_bonus_value

    return bonus_value
end

function the_great_bastion_improved:get_threat_bonus_values_from_region(region)
    local regions_compass_bonus_value = cm:get_regions_bonus_value(region, self.bastion_threat_modifier_compass);

    -- Bonus value per-region. This usually comes from edicts.
    if not region:is_abandoned() and region:owning_faction():subculture() == self.cathay_subculture then
        return cm:get_regions_bonus_value(region, self.bastion_threat_modifier) or 0;
    end

    return 0;
end

--- This function returns the region key of a gate, chosen at random.
function the_great_bastion_improved:get_random_gate()
    return self.settings.spawn_locations_by_gate[cm:random_number(#self.settings.spawn_locations_by_gate)].gate_key;
end

--- This function returns a pair of coordinates for a gate.
--- NOTE: It actively tracks what coordinates have been used on the same turn, to try not repeat them within the same turn.
---@param gate_key string #Key of the gate to check coordinates to.
function the_great_bastion_improved:get_random_position_for_gate(gate_key)

    -- Grab the list of spawn coordiantes for our gate.
    local spawn_positions = {}
    for i = 1, #self.settings.spawn_locations_by_gate do
        local current_gate = self.settings.spawn_locations_by_gate[i]
        if gate_key == current_gate.gate_key then

            -- Initialize the spawn locations used for each table if they don't exists.
            if not self.settings.spawn_locations_used[gate_key] ~= nil then
                self.settings.spawn_locations_used[gate_key] = {};
            end

            -- If we haven't used any position for this gate this turn, randomize its coordinates.
            if #self.settings.spawn_locations_used[gate_key] == 0 then
                current_gate.spawn_locations = cm:random_sort(current_gate.spawn_locations)
            end

            spawn_positions = current_gate.spawn_locations;
            break
        end
    end

    -- Pick the next coordinate in order. If we already picked them all, start again from the begining.
    if #self.settings.spawn_locations_used[gate_key] == #spawn_positions then
        self.settings.spawn_locations_used[gate_key] = {};
    end

    local offset = #self.settings.spawn_locations_used[gate_key] + 1;
    local position = table.copy(spawn_positions[offset]);
    table.insert(self.settings.spawn_locations_used[gate_key], position);

    return position;
end

return the_great_bastion_improved
