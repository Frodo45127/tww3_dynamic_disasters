--[[
    For The Motherland, By Frodo45127.

    Kislev decides that everything is the motherland, if you think hard enough.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +1% for each Kislevite faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
        - At least one of the Kislevite factions must be alive.
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Kislevite factions declare war on every non Kislevite faction.
            - All major and minor non-confederated Kislevite factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each Kislevite capital.
        - Finish:
            - Kislev is destroyed.

    Attacker Buffs:
        - For endgame:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
            - Unkeep: -50%
            - Leadership: +20%
        - For their generic mix of hybrid infantry, ranged infantry, and cavalry:
            - Reload Time: -10%
            - Missile Damage: +10%
            - Charge Bonus: +10%
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

for_the_motherland = {
    name = "for_the_motherland",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh3_main_sc_ksl_kislev" },
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
            "wh3_main_ksl_the_ice_court",
            "wh3_main_ksl_the_great_orthodoxy",
            "wh3_main_ksl_ursun_revivalists",

            -- Minor
            "wh3_main_ksl_brotherhood_of_the_bear",
            "wh3_main_ksl_druzhina_enclave",
            "wh3_main_ksl_ropsmenn_clan",
        },
    },

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        kislev = "lategame"
    },

    factions_base_regions = {
        wh3_main_ksl_the_ice_court = "wh3_main_combi_region_kislev",
        wh3_main_ksl_the_great_orthodoxy = "wh3_main_combi_region_erengrad",
        wh3_main_ksl_ursun_revivalists = "wh3_main_combi_region_karak_vlag",                    -- Not where it starts, but it's a safer position than a minor settlement in the middle of the chaos wastes.
        wh3_main_ksl_brotherhood_of_the_bear = "wh3_main_combi_region_the_tower_of_khrakk",
        wh3_main_ksl_druzhina_enclave = "wh3_main_combi_region_fort_ostrosk",
        wh3_main_ksl_ropsmenn_clan = "wh3_main_combi_region_praag",
    },

    subculture = "wh3_main_sc_ksl_kislev",

    early_warning_incident_key = "dyn_dis_for_the_motherland_warning",
    early_warning_effects_key = "dyn_dis_for_the_motherland_warning",
    invasion_incident_key = "dyn_dis_for_the_motherland_trigger",
    endgame_mission_name = "for_our_lands",
    invader_buffs_effects_key = "dyn_dis_for_the_motherland_attacker_buffs",
    finish_early_incident_key = "dyn_dis_for_the_motherland_early_end",

    ai_personality_katarin = "dyn_dis_wh3_combi_kislev_katarin_endgame",
    ai_personality_kostaltyn = "dyn_dis_wh3_combi_kislev_kostaltyn_endgame",
    ai_personality_boris = "dyn_dis_wh3_combi_kislev_boris_endgame",
    ai_personality_generic = "dyn_dis_wh3_combi_kislev_minor_endgame",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function for_the_motherland:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("ForTheMotherlandStart")
        core:add_listener(
            "ForTheMotherlandStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_for_the_motherland();
                end
                core:remove_listener("ForTheMotherlandStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each capital.
        core:remove_listener("ForTheMotherlandRespawn")
        core:add_listener(
            "ForTheMotherlandRespawn",
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
        )
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function for_the_motherland:start()

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
function for_the_motherland:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("ForTheMotherlandRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function for_the_motherland:check_start()

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

    local base_chance = 5;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
            base_chance = base_chance + 5;
        end
    end

    if cm:random_number(1000, 0) < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function for_the_motherland:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the invasion itself.
function for_the_motherland:trigger_for_the_motherland()

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
                if invasion_faction:name() == "wh3_main_ksl_the_ice_court" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_katarin)
                elseif invasion_faction:name() == "wh3_main_ksl_the_great_orthodoxy" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_kostaltyn)
                elseif invasion_faction:name() == "wh3_main_ksl_ursun_revivalists" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_boris)
                else
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_generic)
                end

                cm:instantly_research_all_technologies(faction_key);
                dynamic_disasters:declare_war_to_all(invasion_faction, { self.subculture }, true);

                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
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

return for_the_motherland
