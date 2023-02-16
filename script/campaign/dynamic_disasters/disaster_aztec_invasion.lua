--[[
    Aztec Invasion disaster, By Frodo45127.

    This disaster consists in a coastal invasion by Lizarmen, to restore the... status of the world according to the great plan.
    Meaning, the classic "There is no problem with others if there is no others" solution.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Lizardmen faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - Message of warning about rumors of weird ships.
            - Small debuf to sea trade.
            - Wait 6-10 turns for more info.
        - Stage 1:
            - This stage is focused on securing the home provinces of each faction and, in a greater scope, secure Lustria.
            - All major and minor non-confederated Lizardmen factions declare war on every non Lizardmen faction.
            - All major and minor non-confederated Lizardmen factions gets disabled diplomacy and full-retard AI.
            - Target: secure home provinces.
                - If Mazdamundi can be used, spawn armies both, at his capital, and on the coasts of Mexico not belonging to Lizardmen.
                - If Kroq-Gar can be used, spawn armies both, at his capital, and on the eastern/southern coast of the Southlands not belonging to Lizardmen.
                - If Tehenhauin can be used, spawn armies both, at his capital, and on the western/southern coast of Lustria not belonging to Lizardmen.
                - If Tiktaq'to can be used, spawn armies both, at his capital, and on the western coast of the Southlands not belonging to Lizardmen.
                - If Gor-Rok can be used, spawn extra armies at his capital and set them to attack the eastern coast of Lustria. Army spawn depends on the amount of settlements not belonging to Lizardmen.
                - If Nakai can be used, spawn a few hordes around his current armies, and in the eastern coast of Cathay.
                - If Oxyotl can be used, spawn armies on the antartic coast to help him capture the southern wastes.
            - Trigger "The Silence of the Southern Seas" incident (-50% income from ports, due to lost comercial traffic).
            - Wait 6-10 turns for more info.

        - Stage 2:
            - This stage is focused on finally enacting the Great Plan invading others.
            - Target: invade enemies.
                - Mazdamundi: Naggaroth.
                - Kroq-Gar: Eastern Colonies, Dragon Isles.
                - Tehenhauin: Old World, Skavenblight.
                - Tiktaq'to: Araby, Black Pyramid, Karak Zorn.
                - Gor-Rok: Naggaroth.
                - Nakai: Celestial Lake.
                - Oxyotl: Southern Southlands, Albion.
            - Trigger "The Enactment of the Great Plan" incident (-75% income from ports, due to lost comercial traffic).
            - Start "Breaking of the Great Plan" mission.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
        - Finish:
            - All lizard factions destroyed.

    Attacker Buffs:
        - For endgame:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
            - Unkeep: -50%
            - Leadership: +20%
        - For specialization in generic infantry formations.
            - Armour: 20%
            - Melee Attack: 20%
            - Melee Defence: 20%

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;

-- Object representing the disaster.
disaster_aztec_invasion = {
    name = "aztec_invasion",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh2_main_sc_lzd_lizardmen" },
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
        }
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {

        -- Common data for all disasters.
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

        -- Disaster-specific data.
        stage_1_delay = 1,
        stage_2_delay = 1,
        grace_period = 1,

        factions = {                        -- Factions that will receive the attacking armies.
            "wh2_main_lzd_hexoatl",                     -- Mazda
            "wh2_main_lzd_last_defenders",              -- Kroq-Gar
            "wh2_dlc12_lzd_cult_of_sotek",              -- Tehenhauin
            "wh2_main_lzd_tlaqua",                      -- Tiktaq'to
            "wh2_main_lzd_itza",                        -- Gor-Rok
            "wh2_dlc13_lzd_spirits_of_the_jungle",      -- Nakai
            "wh2_dlc17_lzd_oxyotl",                     -- Oxyotl
        },

        stage_1_data = {
            regions = {
                wh2_main_lzd_hexoatl = {
                    "mexico_coast",
                    "lustria_west_coast",
                },
                wh2_main_lzd_last_defenders = {
                    "southlands_east_coast",
                },
                wh2_dlc12_lzd_cult_of_sotek = {
                    "lustria_south_coast",
                },
                wh2_main_lzd_tlaqua = {
                    "southlands_west_coast",
                    "southlands_south_coast",
                },
                wh2_main_lzd_itza = {
                    "lustria_north_east_coast",
                    "lustria_east_coast",
                },
                wh2_dlc13_lzd_spirits_of_the_jungle = {
                    "cathay_eastern_coast",
                },
                wh2_dlc17_lzd_oxyotl = {
                    "antartid_east",
                    "antartid_west",
                },
            },
            cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
            targets = {},                                -- List of regions/factions to invade.
        },

        stage_2_data = {
            regions = {
                wh2_main_lzd_hexoatl = {
                    sea = {
                        "naggarond_coast",
                    },
                    land = {},
                },
                wh2_main_lzd_last_defenders = {
                    sea = {
                        "darklands_south_coast",
                        "eastern_isles",
                    },
                    land = {},
                },
                wh2_dlc12_lzd_cult_of_sotek = {
                    sea = {
                        "tilea_and_estalia_coast",
                    },
                    land = {},
                },
                wh2_main_lzd_tlaqua = {
                    sea = {},
                    land = {
                        "wh3_main_combi_region_karak_zorn",
                        "wh3_main_combi_region_black_pyramid_of_nagash",
                        "wh3_main_combi_region_great_desert_of_araby",
                    },
                },
                wh2_main_lzd_itza = {
                    sea = {
                        "naggarond_coast",
                    },
                    land = {},
                },
                wh2_dlc13_lzd_spirits_of_the_jungle = {
                    sea = {
                        "cathay_eastern_coast",
                    },

                    -- These are not for land spawns. These are the target settlements. Spawns are at sea.
                    land = {
                        "wh3_main_combi_region_wei_jin",
                        "wh3_main_combi_region_kunlan",
                        "wh3_main_combi_region_zhanshi",
                        "wh3_main_combi_region_nonchang",
                        "wh3_main_combi_region_shi_long",
                        "wh3_main_combi_region_hanyu_port",
                    },
                },
                wh2_dlc17_lzd_oxyotl = {
                    sea = {
                        "southlands_south_coast",
                        "bretonnia_north_coast",
                    },
                    land = {},
                },
            },
            cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
            targets = {},                                -- List of regions/factions to invade.
        },
    },

    unit_count = 19,
    army_count_per_province = 4,


    army_templates = {
        wh2_main_lzd_hexoatl = { lizardmen = "lategame_hexoatl" },
        wh2_main_lzd_last_defenders = { lizardmen = "lategame_last_defenders" },
        wh2_dlc12_lzd_cult_of_sotek = { lizardmen = "lategame_cult_of_sotek" },
        wh2_main_lzd_tlaqua = { lizardmen = "lategame_tlaqua" },
        wh2_main_lzd_itza = { lizardmen = "lategame_itza" },
        wh2_dlc13_lzd_spirits_of_the_jungle = { lizardmen = "lategame_spirits_of_the_jungle" },
        wh2_dlc17_lzd_oxyotl = { lizardmen = "lategame_oxyotl" },
    },

    early_warning_event_key = "dyn_dis_aztec_invasion_early_warning",
    stage_1_incident_key = "dyn_dis_aztec_invasion_stage_1_trigger",
    stage_2_incident_key = "dyn_dis_aztec_invasion_stage_2_trigger",

    endgame_mission_name = "d_day",
    subculture = "wh2_main_sc_lzd_lizardmen",

    invader_buffs_effects_key = "fro_dyn_dis_aztec_invasion_trigger_invader_buffs",
    finish_early_incident_key = "dyn_dis_aztec_invasion_early_end",
    ai_personality = "fro_dyn_dis_wh3_combi_lizardmen_endgame",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_aztec_invasion:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the stage 1 trigger.
        core:remove_listener("DisasterAztecInvasionStage1")
        core:add_listener(
            "DisasterAztecInvasionStage1",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_stage_1();
                end
                core:remove_listener("DisasterAztecInvasionStage1")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_1 then

        -- Listener for the stage 2 trigger.
        core:remove_listener("DisasterAztecInvasionStage2")
        core:add_listener(
            "DisasterAztecInvasionStage2",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("DisasterAztecInvasionStage2")
            end,
            true
        );

        -- Listener to know when to free the AI armies.
        core:remove_listener("AztecInvasionFreeArmiesStage1");
        core:add_listener(
            "AztecInvasionFreeArmiesStage1",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.grace_period
            end,
            function()
                out("Frodo45127: AztecInvasionFreeArmiesStage1")
                local max_turn = self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.grace_period;
                dynamic_disasters:release_armies(self.settings.stage_1_data.cqis, self.settings.stage_1_data.targets, max_turn);
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_2 then

        -- Listener to know when to free the AI armies.
        core:remove_listener("AztecInvasionFreeArmiesStage2");
        core:add_listener(
            "AztecInvasionFreeArmiesStage2",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.grace_period
            end,
            function()
                out("Frodo45127: AztecInvasionFreeArmiesStage2")
                local max_turn = self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.grace_period;
                dynamic_disasters:release_armies(self.settings.stage_2_data.cqis, self.settings.stage_2_data.targets, max_turn);
            end,
            true
        );

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each capital.
        core:remove_listener("AztecInvasionRespawn")
        core:add_listener(
            "AztecInvasionRespawn",
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
            end,
            true
        );
    end

    -- Once we triggered the disaster, ending it is controlled by a mission, so we don't need to listen for an ending.
end

-- Function to trigger the disaster.
function disaster_aztec_invasion:start()
    out("Frodo45127: Starting disaster: " .. self.name .. ". Triggering early warning.");

    -- Recalculate the delay to trigger this.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_1_delay = 1;
        self.settings.grace_period = 4;
    else
        self.settings.stage_1_delay = cm:random_number(12, self.settings.grace_period);
        self.settings.grace_period = 8;
    end

    -- Initialize listeners.
    dynamic_disasters:trigger_incident(self.early_warning_event_key, self.early_warning_event_key, self.settings.stage_1_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_aztec_invasion:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        core:remove_listener("AztecInvasionFreeArmiesStage1");
        core:remove_listener("AztecInvasionFreeArmiesStage2");
        core:remove_listener("AztecInvasionRespawn");

        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_aztec_invasion:check_start()

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

    -- Otherwise, we use normal calculations.
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
function disaster_aztec_invasion:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the stage 1 of the disaster.
function disaster_aztec_invasion:trigger_stage_1()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering stage 1.");

    -- Recalculate the delay to trigger this.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_2_delay = 1;
    else
        self.settings.stage_2_delay = cm:random_number(12, 8);
    end

    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key)

        if not faction:is_dead() or (faction:is_dead() and self.settings.revive_dead_factions == true) then
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);
            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, nil, self.army_templates[faction_key], self.unit_count, false, army_count, self.name, nil, self.settings.factions) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_only_war(faction_key, self.settings.enable_diplomacy)

                for _, coast in pairs(self.settings.stage_1_data.regions[faction_key]) do
                    out("Frodo45127: Coast " .. tostring(coast) .. ".")

                    for j = 1, #dyn_dis_coasts[coast] do
                        local sea_region = dyn_dis_coasts[coast][j];
                        out("Frodo45127: Sea Region " .. tostring(sea_region) .. ".")

                        for i = 1, #dyn_dis_sea_regions[sea_region].coastal_regions do

                            -- Armies calculation, per province.
                            local region_key = dyn_dis_sea_regions[sea_region].coastal_regions[i];
                            local army_count = cm:random_number(math.ceil(self.settings.difficulty_mod));
                            local spawn_pos = dyn_dis_sea_regions[sea_region].spawn_positions[cm:random_number(#dyn_dis_sea_regions[sea_region].spawn_positions)];
                            out("Frodo45127: Armies to spawn: " .. tostring(army_count) .. " for " .. region_key .. " region, spawn pos X: " .. spawn_pos[1] .. ", Y: " .. spawn_pos[2] .. ".");

                            -- Store the region for invasion controls.
                            for k = 1, army_count do
                                table.insert(self.settings.stage_1_data.targets, region_key)
                            end

                            dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, spawn_pos, self.army_templates[faction_key], self.unit_count, false, army_count, self.name, aztec_invasion_spawn_armies_callback);
                        end
                    end
                end

                -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
                cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
                cm:instantly_research_all_technologies(faction_key);
                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
                dynamic_disasters:declare_war_to_all(faction, { self.subculture }, true);
            end
        end
    end

    -- Force an alliance between all lizardmen.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_1_incident_key, self.stage_1_incident_key, self.settings.stage_2_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the stage 2 of the disaster.
function disaster_aztec_invasion:trigger_stage_2()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering stage 2.");

    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction:is_dead() or (faction:is_dead() and self.settings.revive_dead_factions == true) then

            -- These factions will launch naval invasions all over the globe.
            if faction_key == "wh2_main_lzd_hexoatl" or
                faction_key == "wh2_main_lzd_last_defenders" or
                faction_key == "wh2_dlc12_lzd_cult_of_sotek" or
                faction_key == "wh2_main_lzd_itza" or
                faction_key == "wh2_dlc17_lzd_oxyotl" then

                local regions = self.settings.stage_2_data.regions[faction_key];
                local army_count = cm:random_number(math.ceil(self.settings.difficulty_mod));
                for _, coast in pairs(regions.sea) do
                    for j = 1, #dyn_dis_coasts[coast] do
                        local sea_region = dyn_dis_coasts[coast][j];
                        for i = 1, #dyn_dis_sea_regions[sea_region].coastal_regions do

                            -- Armies calculation, per province.
                            local region_key = dyn_dis_sea_regions[sea_region].coastal_regions[i];
                            local spawn_pos = dyn_dis_sea_regions[sea_region].spawn_positions[cm:random_number(#dyn_dis_sea_regions[sea_region].spawn_positions)];
                            out("Frodo45127: Armies to spawn: " .. tostring(army_count) .. " for " .. region_key .. " region, spawn pos X: " .. spawn_pos[1] .. ", Y: " .. spawn_pos[2] .. ".");

                            -- Store the region for invasion controls.
                            for k = 1, army_count do
                                table.insert(self.settings.stage_2_data.targets, region_key)
                            end

                            dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, spawn_pos, self.army_templates[faction_key], self.settings.unit_count, false, army_count, self.name, aztec_invasion_spawn_armies_callback);

                        end
                    end
                end
            end

            -- TikTaq'to only has land spawns in its capital, with target settlements set.
            if faction_key == "wh2_main_lzd_tlaqua" then
                local regions = self.settings.stage_2_data.regions[faction_key];
                local army_count = cm:random_number(math.ceil(self.settings.difficulty_mod));
                for _, target_region_key in pairs(regions.land) do

                    -- Store the region for invasion controls.
                    for i = 1, army_count do
                        table.insert(self.settings.stage_2_data.targets, target_region_key)
                    end

                    dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, nil, self.army_templates[faction_key], self.settings.unit_count, false, army_count, self.name, aztec_invasion_spawn_armies_callback, self.settings.factions);
                end
            end

            -- Nakai has sea spawns, but the invasion targets are deep in land.
            if faction_key == "wh2_dlc13_lzd_spirits_of_the_jungle" then
                local regions = self.settings.stage_2_data.regions[faction_key];
                local coast = regions.sea[1]
                local sea_region = dyn_dis_coasts[coast][cm:random_number(#dyn_dis_coasts[coast])];
                local army_count = cm:random_number(math.ceil(self.settings.difficulty_mod * 0.75));
                for _, region_key in pairs(regions.land) do

                    -- Armies calculation, per province.
                    local spawn_pos = dyn_dis_sea_regions[sea_region].spawn_positions[cm:random_number(#dyn_dis_sea_regions[sea_region].spawn_positions)];
                    out("Frodo45127: Armies to spawn: " .. tostring(army_count) .. " for " .. region_key .. " region, spawn pos X: " .. spawn_pos[1] .. ", Y: " .. spawn_pos[2] .. ".");

                    -- Store the region for invasion controls.
                    for i = 1, army_count do
                        table.insert(self.settings.stage_2_data.targets, region_key)
                    end

                    dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, spawn_pos, self.army_templates[faction_key], self.settings.unit_count, false, army_count, self.name, aztec_invasion_spawn_armies_callback);
                end
            end
        end
    end

    -- Force an alliance between all lizardmen, in case something happen and they broke the previous one.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Prepare the victory mission/disaster end data.
    for _, faction_key in pairs(self.settings.factions) do
        table.insert(self.objectives[1].conditions, "faction " .. faction_key)
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.stage_2_incident_key, nil, self.settings.factions[1], function () self:finish() end, true)
    dynamic_disasters:trigger_incident(self.stage_2_incident_key, self.stage_2_incident_key, 10, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_STAGE_2);
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function aztec_invasion_spawn_armies_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 0)
    cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
    cm:add_agent_experience(character, cm:random_number(25, 15), true)
    cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))

    local general = cm:get_character_by_cqi(cqi)
    local invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())

    if invasion == nil or invasion == false then
        return
    end

    -- Store all the disaster's cqis, so we can free them later.
    for i = 1, #dynamic_disasters.disasters do
        local disaster = dynamic_disasters.disasters[i];
        if disaster.name == "aztec_invasion" then
            local cqis = {};
            local targets = {};
            if disaster.settings.status == STATUS_TRIGGERED then
                cqis = disaster.settings.stage_1_data.cqis;
                targets = disaster.settings.stage_1_data.targets;
            elseif disaster.settings.status == STATUS_STAGE_1 then
                cqis = disaster.settings.stage_2_data.cqis;
                targets = disaster.settings.stage_2_data.targets;
            end
            out("\tFrodo45127: Army with cqi " .. cqi .. " created and added to the invasions force.")

            table.insert(cqis, cqi);

            local region_key = targets[#targets];
            local region = cm:get_region(region_key);

            if not region == false and region:is_null_interface() == false then
                local faction = region:owning_faction();
                if not faction == false and faction:is_null_interface() == false and faction:name() ~= "rebels" and faction:subculture() ~= disaster.subculture then

                    invasion:set_target("REGION", region_key, faction:name());
                    invasion:add_aggro_radius(15);
                    invasion:abort_on_target_owner_change(true);

                    if invasion:has_target() then
                        out.design("\t\tFrodo45127: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to attack " .. region_key .. ".")
                        invasion:start_invasion(nil, false, false, false)
                    end
                end
            end
        end
    end

    -- If we didn't return before due to an early return on invasion movement or cancelation, release the army.
    invasion:release();
end

return disaster_aztec_invasion
