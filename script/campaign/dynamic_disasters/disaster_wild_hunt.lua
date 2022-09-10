--[[
    The Wild Hunt, By CA. Extended by Frodo45127

    Disaster ported from the endgames disasters. Wood Elfs go full retard. Extended functionality and fixes added.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Wood Elf faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Wood Elfs factions declare war on owner of attacked provinces and adjacent regions.
            - All major and minor non-confederated Wood Elfs factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
        - Finish:
            - A certain amount of Sacred Forest regions controled, or all Wood Elfs factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_wild_hunt = {
	name = "wild_hunt",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_dlc05_sc_wef_wood_elves" },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "CONTROL_N_REGIONS_FROM",
            conditions = {
                "override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
            },
            payloads = {
                "money 25000"
            }
        },
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
	settings = {
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

		army_template = {
			wood_elves = "lategame"
		},
        army_count_per_province = 4,
        unit_count = 19,
        early_warning_delay = 10,

        factions = {
            "wh_dlc05_wef_wood_elves",
            "wh_dlc05_wef_wydrioth",
            "wh3_main_wef_laurelorn",
            "wh_dlc05_wef_torgovann",
            "wh2_main_wef_bowmen_of_oreon",
            "wh_dlc05_wef_argwylon",
            "wh2_dlc16_wef_drycha",
            "wh2_dlc16_wef_sisters_of_twilight",

            -- Not in the vanilla disaster. TODO: Add the missing forests here.
        },

		regions = {},
	},

    early_warning_incident_key = "wh3_main_ie_incident_endgame_wild_hunt_early_warning",
    early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_wild_hunt",
    endgame_mission_name = "and_so_the_wild_hunt_begun",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_wild_hunt",
    ai_personality = "wh3_combi_woodelf_endgame",
}

local potential_wood_elves = {
	wh_dlc05_wef_wood_elves = "wh3_main_combi_region_kings_glade",
	wh_dlc05_wef_wydrioth = "wh3_main_combi_region_crag_halls_of_findol",
	wh3_main_wef_laurelorn = "wh3_main_combi_region_laurelorn_forest",
	wh_dlc05_wef_torgovann = "wh3_main_combi_region_vauls_anvil_loren",
	wh2_main_wef_bowmen_of_oreon = "wh3_main_combi_region_oreons_camp",
	wh_dlc05_wef_argwylon = "wh3_main_combi_region_waterfall_palace",
	wh2_dlc16_wef_drycha = "wh3_main_combi_region_gryphon_wood",
	wh2_dlc16_wef_sisters_of_twilight = "wh3_main_combi_region_the_witchwood"

    -- TODO: Add minor factions and missing regions.
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_wild_hunt:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:add_listener(
            "TheWildHuntStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                self:trigger_the_wild_hunt();
                core:remove_listener("TheWildHuntStart")
            end,
            true
        );
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function disaster_wild_hunt:trigger()

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
function disaster_wild_hunt:trigger_the_wild_hunt()
    for _, faction_key in pairs(self.settings.factions) do
        local region_key = potential_wood_elves[faction_key];
        local invasion_faction = cm:get_faction(faction_key)

        local army_count = math.floor(self.settings.army_count_per_province * self.settings.difficulty_mod);
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, false, army_count, self.name)

        -- In the case of the main Wood Elf faction, also spawn armies in the Oak of Ages if it owns it.
        if faction_key == "wh_dlc05_wef_wood_elves" then
            local oak_of_ages_region = cm:get_region("wh3_main_combi_region_the_oak_of_ages");
            if oak_of_ages_region:owning_faction():name() == faction_key then
                dynamic_disasters:create_scenario_force(faction_key, "wh3_main_combi_region_the_oak_of_ages", self.settings.army_template, self.settings.unit_count, false, army_count, self.name)
                dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { "wh3_main_combi_region_the_oak_of_ages" }, true, { "wh_dlc05_sc_wef_wood_elves" })
                table.insert(self.settings.regions, region_key);
            end
        end

        -- Give the invasion region to the invader if it isn't owned by them or a human
        local region = cm:get_region(region_key)
        local region_owner = region:owning_faction()
        if region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false and region_owner:subculture() ~= "wh_dlc05_sc_wef_wood_elves") then
            cm:transfer_region_to_faction(region_key, faction_key)
        end

        -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { region_key }, true, { "wh_dlc05_sc_wef_wood_elves" })

        cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
        table.insert(self.settings.regions, region_key);
    end

    -- Force an alliance between all Wood Elfs factions.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    table.insert(self.objectives[1].conditions, "total " .. math.ceil(#self.settings.regions * 0.65))
    for i = 1, #self.settings.regions do
        table.insert(self.objectives[1].conditions, "region " .. self.settings.regions[i])
    end
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[2].conditions, "faction " .. self.settings.factions[i])
    end

    -- Reveal all regions subject to capture.
    dynamic_disasters:reveal_regions(self.settings.regions);

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.settings.regions[1], self.settings.factions[1], self:trigger_end_disaster())
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_dlc05_sc_wef_wood_elves")
    self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_wild_hunt:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_wild_hunt:check_start_disaster_conditions()

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
    for faction_key, _ in pairs(potential_wood_elves) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and faction:is_dead() then
            base_chance = base_chance + 0.005;
        end
    end

    if math.random() < base_chance then
        return true;
    end

    return false;
end

return disaster_wild_hunt
