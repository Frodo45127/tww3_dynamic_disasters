--[[
    Vampires Rise, By CA.

    Disaster ported from the endgames disasters. Vampires go full retard. Extended functionality and fixes added.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Vampire faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated vampire factions declare war on every non vampire faction.
            - All major and minor non-confederated vampire factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each vampire count faction capital.
        - Finish:
            - All vampire factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_vampires_rise = {
	name = "vampires_rise",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_vmp_vampire_counts" },
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
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.

        --Disaster-specific data.
        early_warning_delay = 10,

        factions = {
            "wh_main_vmp_schwartzhafen",            -- Vlad/Isabella.
            "wh_main_vmp_vampire_counts",           -- Manfred
            "wh2_dlc11_vmp_the_barrow_legion",      -- Heinrich Kemmler
            "wh3_main_vmp_caravan_of_blue_roses",   -- Helman Ghorst
            "wh_main_vmp_mousillon",                -- The Red Duke

            -- Minor Factions
            "wh_main_vmp_waldenhof",
            "wh2_main_vmp_the_silver_host",
            "wh2_main_vmp_strygos_empire",
            "wh2_main_vmp_necrarch_brotherhood",
            "wh3_main_ie_vmp_sires_of_mourkain",
            "wh3_main_vmp_lahmian_sisterhood",
            "wh3_main_vmp_nagashizzar",
            "wh3_dlc21_vmp_jiangshi_rebels",
        },

        regions = {},
	},

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        vampire_counts = "lategame"
    },

    factions_base_regions = {
    	wh_main_vmp_schwartzhafen = "wh3_main_combi_region_castle_drakenhof",
    	wh_main_vmp_vampire_counts = "wh3_main_combi_region_ka_sabar",
    	wh2_dlc11_vmp_the_barrow_legion = "wh3_main_combi_region_blackstone_post",
    	wh3_main_vmp_caravan_of_blue_roses = "wh3_main_combi_region_the_haunted_forest",
    	wh_main_vmp_mousillon = "wh3_main_combi_region_mousillon",

        -- Minor Factions
        wh_main_vmp_waldenhof = "wh3_main_combi_region_castle_templehof",
        wh2_main_vmp_the_silver_host = "wh3_main_combi_region_lahmia",
        wh2_main_vmp_strygos_empire = "wh3_main_combi_region_al_haikk",
        wh2_main_vmp_necrarch_brotherhood = "wh3_main_combi_region_springs_of_eternal_life",
        wh3_main_ie_vmp_sires_of_mourkain = "wh3_main_combi_region_morgheim",
        wh3_main_vmp_lahmian_sisterhood = "wh3_main_combi_region_silver_pinnacle",
        wh3_main_vmp_nagashizzar = "wh3_main_combi_region_nagashizzar", -- Not in the combi map, but fuck all.
        wh3_dlc21_vmp_jiangshi_rebels = "wh3_main_combi_region_nonchang",
    },

    subculture = "wh_main_sc_vmp_vampire_counts",

    early_warning_incident_key = "wh3_main_ie_incident_endgame_vampires_rise_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_vampires_rise",
    endgame_mission_name = "planet_of_the_dead",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_vampires_rise",
    finish_early_incident_key = "dyn_dis_vampires_rise_early_end",
	ai_personality = "wh3_combi_vampire_endgame",

    effects_global_key = "dyn_dis_vampire_rise_global_effects",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_vampires_rise:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("VampiresRiseStart")
        core:add_listener(
            "VampiresRiseStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_the_great_vampiric_war();
                end
                core:remove_listener("VampiresRiseStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each faction's capital.
        core:remove_listener("VampiresRiseRespawn")
        core:add_listener(
            "VampiresRiseRespawn",
            "WorldStartRound",
            function()
                return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and
                    dynamic_disasters:is_any_faction_alive_from_list_with_home_region(self.settings.factions);
            end,
            function()
                for _, faction_key in pairs(self.settings.factions) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and faction:subculture() == self.subculture and faction:has_home_region() then
                        local region = faction:home_region();
                        dynamic_disasters:create_scenario_force(faction:name(), region:name(), self.army_template, self.unit_count, false, 1, self.name, nil)
                    end
                end
            end,
            true
        )
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function disaster_vampires_rise:start()

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = cm:random_number(12, 8);
    end

    -- Trigger the corruption-related effects
    self:death_and_decay(self.settings.early_warning_delay);

    dynamic_disasters:trigger_incident(self.early_warning_incident_key, self.effects_global_key, self.settings.early_warning_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_vampires_rise:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        local faction_list = cm:model():world():faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            cm:remove_effect_bundle(self.effects_global_key, faction:name());
        end

        core:remove_listener("VampiresRiseRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_vampires_rise:check_start()

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
    end

    local base_chance = 0.005;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
            base_chance = base_chance + 0.005;
        end
    end

    if cm:random_number(100, 0) / 100 < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_vampires_rise:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the disaster.
function disaster_vampires_rise:trigger_the_great_vampiric_war()
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key)
        if not faction:is_dead() or (faction:is_dead() and self.settings.revive_dead_factions == true) then
            local region_key = self.factions_base_regions[faction_key];
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);

            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_template, self.unit_count, false, army_count, self.name, nil, self.settings.factions) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_no_confederation_only_war(faction_key, self.settings.enable_diplomacy)

                -- Give the invasion region to the invader if it isn't owned by them or a human
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region:is_abandoned() or region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false and region_owner:subculture() ~= self.subculture) then
                        cm:transfer_region_to_faction(region_key, faction_key)
                    end
                end

                cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
                cm:instantly_research_all_technologies(faction_key)
                dynamic_disasters:declare_war_to_all(faction, { self.subculture }, true);

                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
                table.insert(self.settings.regions, region_key);
            end
        end
    end

    -- Force an alliance between all vampire factions.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[1].conditions, "faction " .. self.settings.factions[i])
    end

    -- Trigger the corruption-related effects
    self:death_and_decay(0);

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.settings.regions[1], self.settings.factions[1], function () self:finish() end, true)
    dynamic_disasters:trigger_incident(self.invasion_incident_key, self.effects_global_key, 0, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_STARTED);
end

-- Function to apply global vampiric corruption to all factions.
---@param duration_global_effects integer #Duration of the global effects, in turns.
function disaster_vampires_rise:death_and_decay(duration_global_effects)
    local faction_list = cm:model():world():faction_list();

    -- Apply the corruption effects to all alive factions, except humans.
    -- Humans get this effect via payload with effect.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false and faction:is_human() == false then
            cm:apply_effect_bundle(self.effects_global_key, faction:name(), duration_global_effects)
        end
    end
end

return disaster_vampires_rise
