--[[
    A Grudge Too Far, By CA. Extended by Frodo45127.

    Disaster ported from the endgames disasters. Dwarfs go full retard. Extended functionality and fixes added.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Dwarfen faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated dwarfen factions declare war on owner of attacked provinces and adjacent regions.
            - All major and minor non-confederated dwarfen factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
        - Finish:
            - A certain amount of dwarf regions controled, or all dwarf factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_grudge_too_far = {
	name = "grudge_too_far",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_dwf_dwarfs" },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "CONTROL_N_REGIONS_FROM",
            conditions = {
                "override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
            }
        },
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid"
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

        --Disaster-specific data.
		army_template = {
			dwarfs = "lategame"
		},

		army_count_per_province = 4,
		unit_count = 19,
        early_warning_delay = 10,

        factions = {
            "wh2_dlc17_dwf_thorek_ironbrow",
            "wh_main_dwf_karak_izor",
            "wh_main_dwf_karak_kadrin",
            "wh3_main_dwf_the_ancestral_throng",
            "wh_main_dwf_dwarfs",
            "wh_main_dwf_kraka_drak",
            "wh_main_dwf_barak_varr",
            "wh_main_dwf_zhufbar",
            "wh3_main_dwf_karak_azorn",
            "wh_main_dwf_karak_norn",
            "wh_main_dwf_karak_hirn",
            "wh_main_dwf_karak_azul",
            "wh_main_dwf_karak_ziflin"
        },
        region_count_halved = 0,
        regions = {}
	},
    early_warning_incident_key = "wh3_main_ie_incident_endgame_grudge_too_far_early_warning",
	early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_grudge_too_far",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_grudge_too_far",
	ai_personality = "wh3_combi_dwarf_endgame",
}

local potential_dwarfs = {
	wh2_dlc17_dwf_thorek_ironbrow = "wh3_main_combi_region_karak_zorn",
	wh_main_dwf_karak_izor = "wh3_main_combi_region_zarakzil",
	wh_main_dwf_karak_kadrin = "wh3_main_combi_region_karak_kadrin",
	wh3_main_dwf_the_ancestral_throng = "wh3_main_combi_region_drackla_spire",
	wh_main_dwf_dwarfs = "wh3_main_combi_region_karaz_a_karak",
	wh_main_dwf_kraka_drak = "wh3_main_combi_region_kraka_drak",
	wh_main_dwf_barak_varr = "wh3_main_combi_region_barak_varr",
	wh_main_dwf_zhufbar = "wh3_main_combi_region_zhufbar",
	wh3_main_dwf_karak_azorn = "wh3_main_combi_region_karak_azorn",
	wh_main_dwf_karak_norn = "wh3_main_combi_region_karak_norn",
	wh_main_dwf_karak_hirn = "wh3_main_combi_region_karak_hirn",
	wh_main_dwf_karak_azul = "wh3_main_combi_region_karak_azul",
	wh_main_dwf_karak_ziflin = "wh3_main_combi_region_karak_ziflin"
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_grudge_too_far:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:add_listener(
            "GrudgeTooFarStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                self:trigger_second_great_beard_war();
                core:remove_listener("GrudgeTooFarStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to end the disaster.
        core:add_listener(
            "GrudgeTooFarEnd",
            "WorldStartRound",
            function ()
                return self:check_end_disaster_conditions()
            end,
            function()
                self:trigger_end_disaster();
                core:remove_listener("GrudgeTooFarEnd")
            end,
            true
        );
    end
end

-- Function to trigger the early warning before the disaster.
function disaster_grudge_too_far:trigger()

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
function disaster_grudge_too_far:trigger_second_great_beard_war()
	for _, faction_key in pairs(self.settings.factions) do
        local region_key = potential_dwarfs[faction_key];
		local invasion_faction = cm:get_faction(faction_key)

        local army_count = math.floor(self.settings.army_count_per_province * self.settings.difficulty_mod);
		dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, army_count, self.name)

        -- In the case of Karak Izor, also spawn armies in Karak Eight Peaks if it controls it.
        if faction_key == "wh_main_dwf_karak_izor" then
            local karak_eight_peaks_region = cm:get_region("wh3_main_combi_region_karak_eight_peaks");
			if karak_eight_peaks_region:owning_faction():name() == faction_key then
				dynamic_disasters:create_scenario_force(faction_key, "wh3_main_combi_region_karak_eight_peaks", self.settings.army_template, self.settings.unit_count, true, army_count, self.name)
			end
		end

		-- Give the invasion region to the invader if it isn't owned by them or a human
		local region = cm:get_region(region_key)
		local region_owner = region:owning_faction()
		if region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false) then
			cm:transfer_region_to_faction(region_key, faction_key)
		end

        -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
		cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
		endgame:no_peace_no_confederation_only_war(faction_key)
		dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { region_key }, true, { "wh_main_sc_dwf_dwarfs" })

		cm:apply_effect_bundle(self.settings.invader_buffs_effects_key, faction_key, 0)
	end

    -- Force an alliance between all dwarfen holds.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    self.settings.region_count_halved = math.floor((#self.settings.regions / 2) + 0.5)
    table.insert(self.objectives[1].conditions, "total " .. self.settings.region_count_halved)
	for i = 1, #self.settings.regions do
		table.insert(self.objectives[1].conditions, "region " .. self.settings.regions[i])
	end
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[2].conditions, "faction " .. self.settings.factions[i])
    end

    -- Reveal all regions subject to capture.
    dynamic_disasters:reveal_regions(self.settings.regions);

    -- Trigger either the victory mission, or just the related incident.
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(self.invasion_incident_key, self.objectives, self.settings.regions[1], nil)
    else
        dynamic_disasters:execute_payload(self.invasion_incident_key, nil, 0, nil);
    end

    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_dwf_dwarfs")
    self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_grudge_too_far:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_grudge_too_far:check_start_disaster_conditions()

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
    for faction_key, _ in pairs(potential_dwarfs) do
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

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_grudge_too_far:check_end_disaster_conditions()

    -- The objective is to control a few dwarven settlements, or kill the dwafs.
    -- We only need one player to do it, so check each player independently.
    for _, human_faction_key in pairs(cm:get_human_factions()) do
        local controlled_regions = 0;
        local human_faction = cm:get_region(human_faction_key);

        for _, region_key in pairs(self.settings.regions) do
            local region = cm:get_region(region_key);
            if not region == false and region:is_null_interface() == false then
                local region_owner = region:owning_faction();
                if region_owner:name() == human_faction_key or region_owner:is_ally_vassal_or_client_state_of(human_faction) then
                    controlled_regions = controlled_regions + 1;
                end
            end
        end

        -- If a human controls the required amount of provinces, end the disaster.
        if controlled_regions >= self.settings.region_count_halved then
            return true
        end
    end

    -- If we got no factions to even spawn, consider it finished. This is a saveguard, should never be executed if all works correctly.
    if #self.settings.factions == 0 then
        return true;
    end

    -- Also check if all Dwarves are dead.
    local attackers_still_alive = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false then
            attackers_still_alive = true;
            break;
        end
    end

    return not attackers_still_alive;
end

return disaster_grudge_too_far
