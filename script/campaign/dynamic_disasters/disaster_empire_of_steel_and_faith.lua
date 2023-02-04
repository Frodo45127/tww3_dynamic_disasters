--[[
    Empire of Steel and Faith, By Frodo45127.

    The Empire goes full imperial... against everyone.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +1% for each imperial faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
        - At least one of the imperial factions must be alive.
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated imperial factions declare war on every non imperial faction.
            - All major and minor non-confederated imperial factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each imperial capital.
        - Finish:
            - All imperial factions are dead.

    Attacker Buffs:
        - For endgame:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
            - Unkeep: -50%
        - For a jack-of-all-trades faction:
            - Leadership: +40%
            - Magic Resistance: +20%
            - Physical Resistance: +20%
            - Ward Save: +10%


]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

empire_of_steel_and_faith = {
    name = "empire_of_steel_and_faith",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_emp_empire" },
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
            "wh_main_emp_empire",                           -- Karl Franz
            "wh2_dlc13_emp_the_huntmarshals_expedition",    -- Markus Wulfhart
            "wh2_dlc13_emp_golden_order",                   -- Balthasart Gelt
            "wh3_main_emp_cult_of_sigmar",                  -- Volkmar The Grim

            -- Minor
            "wh_main_emp_averland",
            "wh_main_emp_hochland",
            "wh_main_emp_marienburg",
            "wh_main_emp_middenland",
            "wh_main_emp_nordland",
            "wh_main_emp_ostermark",
            "wh_main_emp_ostland",
            "wh_main_emp_stirland",
            "wh_main_emp_talabecland",
            "wh_main_emp_wissenland",
        },
    },

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        empire = "lategame"
    },

    factions_base_regions = {
        wh_main_emp_empire = "wh3_main_combi_region_altdorf",
        wh2_dlc13_emp_the_huntmarshals_expedition = "wh3_main_combi_region_temple_of_kara",
        wh2_dlc13_emp_golden_order = "wh3_main_combi_region_pfeildorf",
        wh3_main_emp_cult_of_sigmar = "wh3_main_combi_region_sudenburg",
        wh_main_emp_averland = "wh3_main_combi_region_averheim",
        wh_main_emp_hochland = "wh3_main_combi_region_hergig",
        wh_main_emp_marienburg = "wh3_main_combi_region_marienburg",
        wh_main_emp_middenland = "wh3_main_combi_region_middenheim",
        wh_main_emp_nordland = "wh3_main_combi_region_salzenmund",
        wh_main_emp_ostermark = "wh3_main_combi_region_bechafen",
        wh_main_emp_ostland = "wh3_main_combi_region_wolfenburg",
        wh_main_emp_stirland = "wh3_main_combi_region_wurtbad",
        wh_main_emp_talabecland = "wh3_main_combi_region_talabheim",
        wh_main_emp_wissenland = "wh3_main_combi_region_nuln",
    },

    subculture = "wh_main_sc_emp_empire",

    early_warning_incident_key = "dyn_dis_empire_of_steel_and_faith_warning",
    early_warning_effects_key = "dyn_dis_empire_of_steel_and_faith_warning",
    invasion_incident_key = "dyn_dis_empire_of_steel_and_faith_trigger",
    endgame_mission_name = "steel_faith_and_guns",
    invader_buffs_effects_key = "dyn_dis_empire_of_steel_and_faith_attacker_buffs",
    finish_early_incident_key = "dyn_dis_empire_of_steel_and_faith_early_end",

    ai_personality_franz = "dyn_dis_wh3_combi_empire_franz_endgame",
    ai_personality_gelt = "dyn_dis_wh3_combi_empire_gelt_endgame",
    ai_personality_volkmar = "dyn_dis_wh3_combi_empire_volkmar_endgame",
    ai_personality_wulfhart = "dyn_dis_wh3_combi_empire_wilfhart_endgame",
    ai_personality_generic = "dyn_dis_wh3_combi_empire_minor_endgame",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function empire_of_steel_and_faith:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("EmpireOfSteelAndFaithStart")
        core:add_listener(
            "EmpireOfSteelAndFaithStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_empire_of_steel_and_faith();
                end
                core:remove_listener("EmpireOfSteelAndFaithStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each capital.
        core:remove_listener("EmpireOfSteelAndFaithRespawn")
        core:add_listener(
            "EmpireOfSteelAndFaithRespawn",
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
function empire_of_steel_and_faith:start()

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
function empire_of_steel_and_faith:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("EmpireOfSteelAndFaithRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function empire_of_steel_and_faith:check_start()

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
function empire_of_steel_and_faith:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the invasion itself.
function empire_of_steel_and_faith:trigger_empire_of_steel_and_faith()

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
                if invasion_faction:name() == "wh_main_emp_empire" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_franz)
                elseif invasion_faction:name() == "wh2_dlc13_emp_golden_order" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_gelt)
                elseif invasion_faction:name() == "wh3_main_emp_cult_of_sigmar" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_volkmar)
                elseif invasion_faction:name() == "wh2_dlc13_emp_the_huntmarshals_expedition" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_wulfhart)
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

return empire_of_steel_and_faith
