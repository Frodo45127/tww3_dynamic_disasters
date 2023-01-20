--[[
    The Greatest Crusade, By Frodo45127.

    Bretonnia decides to launch one last crusade... against everyone.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +1% for each Bretonnian faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
        - At least one of the Bretonnian factions must be alive.
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Bretonnian factions declare war on every non Bretonnian faction.
            - All major and minor non-confederated Bretonnian factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each Bretonnian capital.
        - Finish:
            - All Bretonnian factions are dead.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

the_greatest_crusade = {
    name = "the_greatest_crusade",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_brt_bretonnia" },
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
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        early_warning_delay = 10,

        factions = {

            -- Major
            "wh_main_brt_bretonnia",
            "wh_main_brt_bordeleaux",
            "wh_main_brt_carcassonne",
            "wh2_dlc14_brt_chevaliers_de_lyonesse",

            -- Minor
            "wh2_main_brt_knights_of_origo",
            "wh2_main_brt_knights_of_the_flame",
            "wh2_main_brt_thegans_crusaders",
            "wh3_main_brt_aquitaine",
            "wh_main_brt_artois",
            "wh_main_brt_bastonne",
            "wh_main_brt_lyonesse",
            "wh_main_brt_parravon",
        },
    },

    unit_count = 19,
    army_count_per_province = 4,
    army_template = {
        bretonnia = "lategame"
    },

    factions_base_regions = {
        wh_main_brt_bretonnia = "wh3_main_combi_region_couronne",
        wh_main_brt_bordeleaux = "wh3_main_combi_region_temple_of_tlencan",
        wh_main_brt_carcassonne = "wh3_main_combi_region_castle_carcassonne",
        wh2_dlc14_brt_chevaliers_de_lyonesse = "wh3_main_combi_region_copher",
        wh2_main_brt_knights_of_origo = "wh3_main_combi_region_zandri",
        wh2_main_brt_knights_of_the_flame = "wh3_main_combi_region_lashiek",
        wh2_main_brt_thegans_crusaders = "wh3_main_combi_region_martek",
        wh3_main_brt_aquitaine = "wh3_main_combi_region_aquitaine",
        wh_main_brt_artois = "wh3_main_combi_region_castle_artois",
        wh_main_brt_bastonne = "wh3_main_combi_region_castle_bastonne",
        wh_main_brt_lyonesse = "wh3_main_combi_region_lyonesse",
        wh_main_brt_parravon = "wh3_main_combi_region_parravon",
    },

    subculture = "wh_main_sc_brt_bretonnia",

    early_warning_incident_key = "dyn_dis_the_greatest_crusade_warning",
    early_warning_effects_key = "dyn_dis_the_greatest_crusade_warning",
    invasion_incident_key = "dyn_dis_the_greatest_crusade_trigger",
    endgame_mission_name = "the_greatest_counter_crusade",
    invader_buffs_effects_key = "dyn_dis_the_greatest_crusade_attacker_buffs",
    finish_early_incident_key = "dyn_dis_the_greatest_crusade_early_end",

    ai_personality_alberic = "dyn_dis_wh3_combi_bretonnia_alberic_endgame",
    ai_personality_fay = "dyn_dis_wh3_combi_bretonnia_fayenchantress_endgame",
    ai_personality_louen = "dyn_dis_wh3_combi_bretonnia_louen_endgame",
    ai_personality_repanse = "dyn_dis_wh3_combi_bretonnia_repanse_endgame",
    ai_personality_generic = "dyn_dis_wh3_combi_bretonnia_minor_endgame",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function the_greatest_crusade:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("TheGreatestCrusadeStart")
        core:add_listener(
            "TheGreatestCrusadeStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_the_greatest_crusade();
                end
                core:remove_listener("TheGreatestCrusadeStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each capital.
        core:remove_listener("TheGreatestCrusadeRespawn")
        core:add_listener(
            "TheGreatestCrusadeRespawn",
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
function the_greatest_crusade:start()

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
function the_greatest_crusade:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("TheGreatestCrusadeRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function the_greatest_crusade:check_start()

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
function the_greatest_crusade:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the invasion itself.
function the_greatest_crusade:trigger_the_greatest_crusade()

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
                if invasion_faction:name() == "wh_main_brt_bretonnia" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_louen)
                elseif invasion_faction:name() == "wh_main_brt_bordeleaux" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_alberic)
                elseif invasion_faction:name() == "wh_main_brt_carcassonne" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_fay)
                elseif invasion_faction:name() == "wh2_dlc14_brt_chevaliers_de_lyonesse" then
                    cm:force_change_cai_faction_personality(invasion_faction:name(), self.ai_personality_repanse)
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

return the_greatest_crusade
