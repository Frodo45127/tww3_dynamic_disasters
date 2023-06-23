--[[
    The Will of Hashut, By CA. Extended by Frodo45127.

    Chaos Dwarfs reach their endgame, obtaining the blood of Hashut. They spawn portals in certain areas and start expanding.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Chaos Dwarf faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
        - At least one of the Chaos Dwarf factions must be alive.
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Chaos Dwarf factions declare war on every non Chaos Dwarf faction.
            - All major and minor non-confederated Chaos Dwarf factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in a random portal for each faction.
        - Finish:
            - Chaos Dwarfs are destroyed.

    Attacker Buffs:
        - For endgame:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
            - Unkeep: -75%
        - For Zarr-Nagrund.
            - Ammunation: +50%
            - Leadership: +20%
            - Melee Defense: 10%

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

will_of_hashut = {
    name = "will_of_hashut",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh3_dlc23_sc_chd_chaos_dwarfs" },
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
        {
            type = "CONTROL_N_REGIONS_FROM",
            conditions = {
                "total 3",
                "override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
            },
            payloads = {
                "money 25000"
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
        proximity_war = false,              -- If true, war declarations will be against neightbours only. If false, they'll be global.
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
            "wh3_dlc23_chd_zhatan",
            "wh3_dlc23_chd_astragoth",
            "wh3_dlc23_chd_legion_of_azgorh",

            -- Minor
            "wh3_dlc23_chd_conclave",
            "wh3_dlc23_chd_minor_faction",
        },
    },

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        chaos_dwarfs = "lategame"
    },

    portal_regions = {
        "wh3_main_combi_region_po_mei",
        "wh3_main_combi_region_gorssel",
        "wh3_main_combi_region_circle_of_destruction",
        "wh3_main_combi_region_tlaxtlan",
        "wh3_main_combi_region_antoch",
        "wh3_main_combi_region_zharr_naggrund" --including zharr naggrund
    },

    objective_regions = {
        "wh3_main_combi_region_zharr_naggrund",
        "wh3_dlc23_combi_region_gash_kadrak",
        "wh3_main_combi_region_the_falls_of_doom"
    },

    subculture = "wh3_dlc23_sc_chd_chaos_dwarfs",
    ai_personality = "wh3_combi_chaos_dwarf_endgame",

    early_warning_incident_key = "wh3_dlc23_ie_incident_endgame_chaos_dwarfs_hashut_early_warning",
    early_warning_effects_key = "dyn_dis_will_of_hashut_warning",
    invasion_incident_key = "wh3_dlc23_ie_incident_endgame_chaos_dwarfs_hashut",
    endgame_mission_name = "will_of_hashut",
    invader_buffs_effects_key = "wh3_dlc23_ie_scripted_endgame_faction_chaos_dwarfs_hashut",
    finish_early_incident_key = "dyn_dis_will_of_hashut_early_end",

    region_bundle = "wh3_dlc23_ie_scripted_endgame_region_chaos_dwarfs_hashut",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function will_of_hashut:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("WillOfHashutStart")
        core:add_listener(
            "WillOfHashutStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_will_of_hashut();
                end
                core:remove_listener("WillOfHashutStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns in random portals for each faction.
        core:remove_listener("WillOfHashutRespawn")
        core:add_listener(
            "WillOfHashutRespawn",
            "WorldStartRound",
            function()
                return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and
                    dynamic_disasters:is_any_faction_alive_from_list_with_home_region(self.settings.factions);
            end,
            function()
                for _, faction_key in pairs(self.settings.factions) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and faction:has_home_region() and faction:num_generals() <= 24 then
                        local region_key = self.portal_regions[cm:random_number(#self.portal_regions)]
                        dynamic_disasters:create_scenario_force(faction:name(), region_key, self.army_template, self.unit_count, false, 1, self.name, nil, nil)
                    end
                end
            end,
            true
        )
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function will_of_hashut:start()

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
function will_of_hashut:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("WillOfHashutRespawn")

        -- Close all teleport nodes.
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_cathay", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_cathay_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_empire", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_empire_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_lustria", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_lustria_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_naggaroth", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_naggaroth_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_southlands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")
        cm:teleportation_network_close_all_nodes("wh3_dlc23_endgame_chd_southlands_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")

        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function will_of_hashut:check_start()

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
function will_of_hashut:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the invasion itself.
function will_of_hashut:trigger_will_of_hashut()

    -- Give the Zharr Naggrund to their original owner if they're still alive and don't have it.
    local zarr_region = cm:get_region(self.objective_regions[1]);
    local zarr_owner = zarr_region:owning_faction();
    if zarr_owner:is_null_interface() or (zarr_owner:name() ~= "wh3_dlc23_chd_conclave" and zarr_owner:is_human() == false) then
        local new_owner = cm:get_faction("wh3_dlc23_chd_conclave");
        if not new_owner == false and new_owner:is_null_interface() == false and new_owner:was_confederated() == false and new_owner:is_dead() == false then
            cm:transfer_region_to_faction(zarr_region:name(), new_owner:name())
        end
    end

    for _, faction_key in pairs(self.settings.factions) do
        local invasion_faction = cm:get_faction(faction_key)

        if not invasion_faction:is_dead() or (invasion_faction:is_dead() and self.settings.revive_dead_factions == true) then
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);
            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, nil, self.army_template, self.unit_count, false, army_count, self.name, nil, self.settings.factions, nil) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_only_war(faction_key, self.settings.enable_diplomacy)

                -- Spawn one army per portal.
                for i = 1, #self.portal_regions do
                    dynamic_disasters:create_scenario_force(faction_key, self.portal_regions[i], self.army_template, self.unit_count, false, 1, self.name, nil, nil)
                end

                -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
                cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality);
                cm:instantly_research_all_technologies(faction_key);
                dynamic_disasters:declare_war_to_all(invasion_faction, { self.subculture }, true);

                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
            end
        end
    end

    -- Apply effects to Zarr-Naggrund.
    cm:apply_effect_bundle_to_region(self.region_bundle, self.objective_regions[1], 0)

    -- Force an alliance between all disaster factions.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Add the target regions to the second mission.
    for i = 1, #self.objective_regions do
        table.insert(objectives[2].conditions, "region "..self.objective_regions[i])
    end

    -- Open all the nodes in the teleportation network for spawning armies.
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_cathay", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_cathay_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_empire", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_empire_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_lustria", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_lustria_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_naggaroth", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_naggaroth_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_southlands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")
    cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_southlands_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.objective_regions[1], self.settings.factions[1], function () self:finish() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_STARTED);

end

return will_of_hashut
