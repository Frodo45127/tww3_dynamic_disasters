--[[
    The Dragon Emperor's Wrath, By Frodo45127. Loosely based on Wyccc's Cathay endgame.

    The dragon emperor of Cathay goes full... emperor, attacking everyone.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Cathayan faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
        - At least one of the cathayan factions must be alive.
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Cathayan factions declare war on every non Cathayan faction.
            - All major and minor non-confederated Cathayan factions gets disabled diplomacy and full-retard AI.
            - Cathayan armies are spawned in sea lanes exits and invade predefined regions (islands south of Cathay, and multiple attacks on lustria).
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each Cathayan capital and on the maritime routes.
        - Finish:
            - Cathay is destroyed.

    Attacker Buffs:
        - For endgame:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
            - Unkeep: -50%
            - Leadership: +20%
        - For specialization in generic infantry formations.
            - Melee Defence: 10%
            - Reload Time: -10%

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

dragon_emperors_wrath = {
    name = "dragon_emperors_wrath",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh3_main_sc_cth_cathay" },
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid",
                "vassalization_valid"
            },
            payloads = {
                "money 50000"
            }
        },
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        revive_dead_factions = false,       -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        short_victory_is_min_turn = false,  -- If the short victory turn should be used as min turn.
        long_victory_is_min_turn = true,    -- If the long victory turn should be used as min turn.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        early_warning_delay = 10,

        factions = {

            -- Major
            "wh3_main_cth_the_northern_provinces",
            "wh3_main_cth_the_western_provinces",

            -- Minor
            "wh3_main_cth_burning_wind_nomads",
            "wh3_main_cth_celestial_loyalists",
            "wh3_main_cth_eastern_river_lords",
            "wh3_main_cth_imperial_wardens",
            "wh3_main_cth_the_jade_custodians",
        },

        cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
        targets = {},                                -- List of regions/factions to invade.
    },

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        cathay = "lategame"
    },

    factions_base_regions = {
        wh3_main_cth_the_northern_provinces = "wh3_main_combi_region_nan_gau",
        wh3_main_cth_the_western_provinces = "wh3_main_combi_region_hanyu_port",
        wh3_main_cth_burning_wind_nomads = "wh3_main_combi_region_fu_hung",
        wh3_main_cth_celestial_loyalists = "wh3_main_combi_region_wei_jin",
        wh3_main_cth_eastern_river_lords = "wh3_main_combi_region_shi_wu",
        wh3_main_cth_imperial_wardens = "wh3_main_combi_region_dragon_gate",
        wh3_main_cth_the_jade_custodians = "wh3_main_combi_region_shi_long",
    },

    sea_lanes = {
        wh3_main_cth_the_northern_provinces = {
            {
                coordinates = {21, 411},                -- Lustrian Gulf exit.
                regions = {
                    "wh3_main_combi_region_shrine_of_sotek",
                    "wh3_main_combi_region_macu_peaks",
                    "wh3_main_combi_region_fallen_gates",
                }
            },
            {
                coordinates = {88, 112},                -- Sea of Storms exit.
                regions = {
                    "wh3_main_combi_region_the_golden_colossus",
                    "wh3_main_combi_region_the_copper_landing",
                    "wh3_main_combi_region_the_dust_gate",
                    "wh3_main_combi_region_kaiax",
                }
            },
        },
        wh3_main_cth_the_western_provinces = {
            {
                coordinates = {1067, 88},               -- Sea of dread exit.
                regions = {
                    "wh3_main_combi_region_tower_of_the_sun",
                    "wh3_main_combi_region_tower_of_the_stars",
                    "wh3_main_combi_region_tor_elasor",
                }
            }
        }
    },

    subculture = "wh3_main_sc_cth_cathay",

    early_warning_incident_key = "dyn_dis_dragon_emperors_wrath_warning",
    early_warning_effects_key = "dyn_dis_dragon_emperors_wrath_warning",
    invasion_incident_key = "dyn_dis_dragon_emperors_wrath_trigger",
    endgame_mission_name = "unleashed",
    invader_buffs_effects_key = "dyn_dis_dragon_emperors_wrath_attacker_buffs",
    finish_early_incident_key = "dyn_dis_dragon_emperors_wrath_early_end",

    miao_yin_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_miao_yin",
    zhao_ming_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_zhao_ming",
    generic_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_generic",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function dragon_emperors_wrath:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("DragonEmperorWrathStart")
        core:add_listener(
            "DragonEmperorWrathStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_dragon_emperors_wrath();
                end
                core:remove_listener("DragonEmperorWrathStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each capital.
        -- Also, for each base coastal province they control in the new world, they may get an aditional army sent.
        core:remove_listener("DragonEmperorWrathRespawn")
        core:add_listener(
            "DragonEmperorWrathRespawn",
            "WorldStartRound",
            function()
                return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and
                    dynamic_disasters:is_any_faction_alive_from_list_with_home_region(self.settings.factions);
            end,
            function()
                for _, faction_key in pairs(self.settings.factions) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and faction:has_home_region() then
                        local region = faction:home_region();
                        dynamic_disasters:create_scenario_force(faction:name(), region:name(), self.army_template, self.unit_count, false, 1, self.name, nil)
                    end
                end

                for faction_key, spawns_data in pairs(self.sea_lanes) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and not faction:is_dead() and not faction:was_confederated() then
                        for _, spawn_data in pairs(spawns_data) do
                            for _, region_key in pairs(spawn_data.regions) do
                                local region = cm:get_region(region_key);
                                if not region == false and region:is_null_interface() == false and not region:is_abandoned() and dynamic_disasters:faction_subculture_in_list(region:owning_faction(), {self.subculture}) then
                                    out("Frodo45127: Disaster: " .. self.name .. ". Trying to respawn invaders for region " .. region_key .. " coordinates X: ".. tostring(spawn_data.coordinates[1]) .. ", Y: " .. tostring(spawn_data.coordinates[2]) .. ".");
                                    dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, spawn_data.coordinates, self.army_template, self.unit_count, false, 1, self.name, nil)
                                end
                            end
                        end
                    end
                end
            end,
            true
        )
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function dragon_emperors_wrath:start()

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = cm:random_number(12, 8);
    end

    dynamic_disasters:trigger_incident(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function dragon_emperors_wrath:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("DragonEmperorWrathRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function dragon_emperors_wrath:check_start()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Do not start if we don't have any alive attackers.
    if not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions) then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        return true;
    end

    -- If we're at max turn, trigger it without checking chances.
    if self.settings.max_turn > 0 and cm:turn_number() == self.settings.max_turn then
        return true;

    -- If we have max turn set, we need to use a 1 in turn range chance.
    -- This makes it so we don't give extreme chance of triggering at the max turn.
    elseif self.settings.max_turn > self.settings.min_turn then
        local range = self.settings.max_turn - self.settings.min_turn;
        if cm:random_number(range, 0) <= 1 then
            return true;
        end
    else

        local base_chance = 5;
        for _, faction_key in pairs(self.settings.factions) do
            local faction = cm:get_faction(faction_key);
            if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
                base_chance = base_chance + 5;
            end
        end

        if cm:random_number(1000, 0) <= base_chance then
            return true;
        end
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function dragon_emperors_wrath:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the invasion itself.
function dragon_emperors_wrath:trigger_dragon_emperors_wrath()

    for _, faction_key in pairs(self.settings.factions) do
        local invasion_faction = cm:get_faction(faction_key)

        if not invasion_faction:is_dead() or (invasion_faction:is_dead() and self.settings.revive_dead_factions == true) then
            local region_key = self.factions_base_regions[faction_key];
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);
            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_template, self.unit_count, false, army_count, self.name, nil, self.settings.factions) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_only_war(faction_key, self.settings.enable_diplomacy)

                -- Give the invasion region to the invader if it isn't owned by them or a human
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region:is_abandoned() or region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false and region_owner:subculture() ~= self.subculture) then
                        cm:transfer_region_to_faction(region_key, faction_key)
                    end
                end

                -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
                if invasion_faction:name() == "wh3_main_cth_the_northern_provinces" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.miao_yin_ai_personality)
                elseif invasion_faction:name() == "wh3_main_cth_the_western_provinces" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.zhao_ming_ai_personality)
                else
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.generic_ai_personality)
                end

                cm:instantly_research_all_technologies(faction_key);
                dynamic_disasters:declare_war_to_all(invasion_faction, { self.subculture }, true);

                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
            end
        end
    end

    -- Miao Yin and Zhao Ming should also spawn scripted armies in exits of sea lines going into Cathay, atacking nearby regions.
    -- If they're alive, of course.
    for faction_key, spawns_data in pairs(self.sea_lanes) do
        local faction = cm:get_faction(faction_key);
        if not faction:is_dead() and not faction:was_confederated() then
            for _, spawn_data in pairs(spawns_data) do
                for _, region_key in pairs(spawn_data.regions) do
                    out("Frodo45127: Disaster: " .. self.name .. ". Trying to spawn invaders for region " .. region_key .. " coordinates X: ".. tostring(spawn_data.coordinates[1]) .. ", Y: " .. tostring(spawn_data.coordinates[2]) .. ".");
                    if dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, spawn_data.coordinates, self.army_template, self.unit_count, false, 1, self.name, dragon_emperors_wrath_spawn_armies_callback) then
                        out("Frodo45127: Disaster: " .. self.name .. ". Army spawned for region " .. region_key .. " coordinates X: ".. tostring(spawn_data.coordinates[1]) .. ", Y: " .. tostring(spawn_data.coordinates[2]) .. ".");

                        -- Store the region for invasion controls.
                        for j = 1, 2 do
                            table.insert(self.settings.targets, region_key)
                        end
                    end
                end
            end
        end
    end

    -- Force an alliance between all disaster factions.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[1].conditions, "faction " .. self.settings.factions[i])
    end

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, nil, self.settings.factions[1], function () self:finish() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_STARTED);
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function dragon_emperors_wrath_spawn_armies_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 10)
    cm:add_agent_experience(character, cm:random_number(25, 10), true)
    cm:add_experience_to_units_commanded_by_character(character, cm:random_number(5, 2))

    local general = cm:get_character_by_cqi(cqi)
    local invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())

    if invasion == nil or invasion == false then
        return
    end

    -- Store all the disaster's cqis, so we can free them later.
    for i = 1, #dynamic_disasters.disasters do
        local disaster = dynamic_disasters.disasters[i];
        if disaster.name == "dragon_emperors_wrath" then
            local cqis = disaster.settings.cqis;
            local targets = disaster.settings.targets;

            out("\tFrodo45127: Army with cqi " .. cqi .. " created and added to the invasions force.")
            table.insert(cqis, cqi);

            local region_key = targets[#targets];
            local region = cm:get_region(region_key);

            if not region == false and region:is_null_interface() == false then
                local faction = region:owning_faction();
                if not faction == false and faction:is_null_interface() == false and faction:name() ~= "rebels" and faction:name() ~= disaster.settings.faction then

                    invasion:set_target("REGION", region_key, faction:name());
                    invasion:add_aggro_radius(15);
                    invasion:abort_on_target_owner_change(true);

                    if invasion:has_target() then
                        out.design("\t\tFrodo45127: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to attack " .. region_key .. ".")
                        invasion:start_invasion(nil, false, false, false)
                        return;
                    end
                end
            end
        end
    end

    -- If we didn't return before due to an early return on invasion movement or cancelation, release the army.
    invasion:release();
end

return dragon_emperors_wrath
