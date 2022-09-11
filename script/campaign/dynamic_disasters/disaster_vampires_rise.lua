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
            - All major and minor non-confederated vampire factions declare war on owner of attacked provinces and adjacent regions.
            - All major and minor non-confederated vampire factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
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

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid"
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
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        --Disaster-specific data.
		army_template = {
			vampires = "lategame"
		},

        army_count_per_province = 4,
        unit_count = 19,
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

    early_warning_incident_key = "wh3_main_ie_incident_endgame_vampires_rise_early_warning",
    early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_vampires_rise",
    endgame_mission_name = "planet_of_the_dead",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_vampires_rise",
    finish_early_incident_key = "dyn_dis_vampires_rise_early_end",
	ai_personality = "wh3_combi_vampire_endgame",
}

local potential_vampires = {
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
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_vampires_rise:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:add_listener(
            "VampiresRiseStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()

                -- Update the potential factions removing the confederated ones and check if we still have factions to use.
                self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
                if #self.settings.factions == 0 then
                    dynamic_disasters:execute_payload(self.finish_early_incident_key, nil, 0, nil);
                else
                    self:trigger_the_great_vampiric_war();
                end
                core:remove_listener("VampiresRiseStart")
            end,
            true
        );
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function disaster_vampires_rise:trigger()

    -- Debug mode support.
    if dynamic_disasters.settings.debug == false then
        self.settings.early_warning_delay = math.random(8, 12);
    else
        self.settings.early_warning_delay = 1;
    end

    dynamic_disasters:execute_payload(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the disaster.
function disaster_vampires_rise:trigger_the_great_vampiric_war()
    for _, faction_key in pairs(self.settings.factions) do
        local region_key = potential_vampires[faction_key];
		local faction = cm:get_faction(faction_key)

        local army_count = math.floor(self.settings.army_count_per_province * self.settings.difficulty_mod);
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, false, army_count, self.name)

        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, { region_key }, true, { "wh_main_sc_vmp_vampire_counts" })

        cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
        table.insert(self.settings.regions, region_key);
	end

    -- Force an alliance between all dwarfen holds.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[1].conditions, "faction " .. self.settings.factions[i])
    end

    -- Reveal all regions subject to capture.
    dynamic_disasters:reveal_regions(self.settings.regions);

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.settings.regions[1], self.settings.factions[1], self:trigger_end_disaster())
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
    self:set_status(STATUS_STARTED);
end


-- Function to trigger cleanup stuff after the invasion is over.
function disaster_vampires_rise:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_vampires_rise:check_start_disaster_conditions()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Check if any of the attackers if actually alive.
    local attackers_still_alive = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false then
            attackers_still_alive = true;
            break;
        end
    end

    -- Do not start if we don't have any alive attackers.
    if attackers_still_alive == false then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
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

    if math.random() < base_chance then
        return true;
    end

    return false;
end

return disaster_vampires_rise
