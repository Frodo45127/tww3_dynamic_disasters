--[[
    A Grudge Too Far, By CA.

    Disaster ported from the endgames disasters. Dwarfs go full retard.

    Requirements:
        - Random chance (0.005)
        - +0.005 for each dwarven faction that has been wiped out.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major (and some minor) dwarf factions recover their capitals and spawn a lot of armies.
        - Finish:
            - A certain amount of dwarf capitals controled, or dwarfs destroyed.

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

	settings = {
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },
		army_template = {
			dwarfs = "lategame"
		},
		major_army_count = 4, -- Number of armies that spawn for the major playables
		minor_army_count = 2, -- Number of armies that spawn for the minor dwarves
		unit_count = 19,
		early_warning_event = "wh3_main_ie_incident_endgame_grudge_too_far_early_warning",
		ai_personality = "wh3_combi_dwarf_endgame",
        early_warning_delay = 10,

        region_count_halved = 0,
        regions_to_capture = {}
	}
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

function disaster_grudge_too_far:trigger()
    self:set_status(STATUS_TRIGGERED);
    dynamic_disasters:execute_payload("wh3_main_ie_scripted_endgame_early_warning", self.settings.early_warning_event, self.settings.early_warning_delay);
end

function disaster_grudge_too_far:trigger_second_great_beard_war()
    self:set_status(STATUS_STARTED);
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_emp_empire")
	
	local dwarf_regions = {}
	
	for faction_key, region_key in pairs(potential_dwarfs) do
		local invasion_faction = cm:get_faction(faction_key)
		local can_be_human = invasion_faction:can_be_human()
		if not invasion_faction:is_human() and not (invasion_faction:was_confederated() and can_be_human) then
			table.insert(dwarf_regions, region_key)
			local army_count
			if can_be_human then
				army_count = math.floor(self.settings.major_army_count*self.settings.difficulty_mod)
			else
				army_count = math.floor(self.settings.minor_army_count*self.settings.difficulty_mod)
			end
			if army_count < 1 then
				army_count = 1
			end
			endgame:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, army_count)
			if faction_key == "wh_main_dwf_karak_izor" then
				if not invasion_faction:is_dead() and cm:get_region("wh3_main_combi_region_karak_eight_peaks"):owning_faction():name() == faction_key then
					endgame:create_scenario_force(faction_key, "wh3_main_combi_region_karak_eight_peaks", self.settings.army_template, self.settings.unit_count, true, army_count)
				end
			end

			cm:force_change_cai_faction_personality(faction_key, self.settings.ai_personality)

			-- Give the invasion region to the invader if it isn't owned by them or a human
			local region = cm:get_region(region_key)
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false) then
				cm:transfer_region_to_faction(region_key, faction_key)
			end

			endgame:no_peace_no_confederation_only_war(faction_key)
			endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)

			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_grudge_too_far", faction_key, 0)
		end
	end

	local human_factions = cm:get_human_factions()
	self.settings.region_count_halved = math.floor((#dwarf_regions/2) + 0.5)
	local objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total "..self.settings.region_count_halved,
			}
		}
	}

	for i = 1, #dwarf_regions do 
		table.insert(objectives[1].conditions, "region "..dwarf_regions[i])
        table.insert(self.settings.regions_to_capture, dwarf_regions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_grudge_too_far"
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(incident_key, objectives, dwarf_regions[1], nil)
    else
        dynamic_disasters:execute_payload(incident_key, incident_key, 0);
    end
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_grudge_too_far:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_grudge_too_far:check_start_disaster_conditions()
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
    local controlled_regions = 0;

    for _, region_key in pairs(self.settings.regions_to_capture) do
        local region = cm:get_region(region_key);

        -- TODO: check for allies too.
        if region ~= false and region:owning_faction():is_human() then
            controlled_regions = controlled_regions + 1;
        end
    end

    if controlled_regions >= self.settings.region_count_halved then
        return true
    end

    return false;
end

return disaster_grudge_too_far
