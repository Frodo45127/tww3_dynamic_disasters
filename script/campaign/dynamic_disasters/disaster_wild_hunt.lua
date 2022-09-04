--[[
    The Wild Hunt, By CA.

    Disaster ported from the endgames disasters. Wood Elfs go full retard.

    Requirements:
        - Random chance (0.005)
        - +0.005 for each wood elf faction that has been wiped out.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All mayor wood elf factions recover their capitals and spawn a lot of armies.
        - Finish:
            - A certain amount of wood elf capitals controled.

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

	settings = {
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

		army_template = {
			wood_elves = "lategame"
		},
		base_army_count = 4, -- Number of armies that spawn in each forest glade when the event fires.
		unit_count = 19,
		early_warning_event = "wh3_main_ie_incident_endgame_wild_hunt_early_warning",
		ai_personality = "wh3_combi_woodelf_endgame",
		early_warning_delay = 10,
		region_count_halved = 0,
		factions_to_destroy = {},
		regions_to_capture = {},
	}
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

    if self.settings.status == STATUS_STARTED then

        -- Listener to end the invasion.
        core:add_listener(
            "WildHuntEnd",
            "WorldStartRound",
            function ()
                return self:check_end_disaster_conditions()
            end,
            function()
                self:trigger_end_disaster();
                core:remove_listener("WildHuntEnd")
            end,
            true
        );
    end
end

function disaster_wild_hunt:trigger()
    self:set_status(STATUS_TRIGGERED);
    dynamic_disasters:execute_payload("wh3_main_ie_scripted_endgame_early_warning", self.settings.early_warning_event, self.settings.early_warning_delay, nil);

end

function disaster_wild_hunt:trigger_the_wild_hunt()
    self:set_status(STATUS_STARTED);
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_dlc05_sc_wef_wood_elves")

	local forest_regions = {}
	local wood_elf_factions = {}
	
	for faction_key, region_key in pairs(potential_wood_elves) do
		local faction = cm:get_faction(faction_key);
		if not faction:is_human() and not (faction:was_confederated() and faction:can_be_human()) then
			table.insert(forest_regions, region_key)
			table.insert(wood_elf_factions, faction_key)

			endgame:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, 2)
			if faction_key ==  "wh_dlc05_wef_wood_elves" then
				endgame:create_scenario_force(faction_key, "wh3_main_combi_region_the_oak_of_ages", self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod))
			end

			endgame:no_peace_no_confederation_only_war(faction_key)
			
			local invasion_faction = cm:get_faction(faction_key)
			local region = cm:get_region(region_key)
			local region_owner = region:owning_faction()

			cm:force_change_cai_faction_personality(faction_key, self.settings.ai_personality)

			if region_owner:is_null_interface() or region_owner:name() == "rebels" or (not region_owner:name() == faction_key and not region_owner:is_human()) then
				cm:transfer_region_to_faction(region_key, faction_key)
			end
			
			endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)

			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_wild_hunt", faction_key, 0)
		end
	end

	local human_factions = cm:get_human_factions()
	local region_count_halved = math.floor((#forest_regions/2) + 0.5)
	local objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total "..region_count_halved,
			}
		},
		{
			type = "DESTROY_FACTION",
			conditions = {
				"confederation_valid"
			}
		}
	}

	for i = 1, #forest_regions do 
		table.insert(objectives[1].conditions, "region "..forest_regions[i])
		table.insert(self.settings.regions_to_capture, forest_regions[i])
	end

	for i = 1, #wood_elf_factions do 
		table.insert(objectives[2].conditions, "faction "..wood_elf_factions[i])
		table.insert(self.settings.factions_to_destroy, wood_elf_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_wild_hunt"
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(incident_key, objectives, forest_regions[1], nil)
    else
        dynamic_disasters:execute_payload(incident_key, incident_key, 0, nil);
    end

end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_wild_hunt:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_wild_hunt:check_start_disaster_conditions()
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

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_wild_hunt:check_end_disaster_conditions()
    local controlled_regions = 0;
    local factions_destroyed = true;

    for _, region_key in pairs(self.settings.regions_to_capture) do
        local region = cm:get_region(region_key);

        -- TODO: check for allies too.
        if region ~= false and region:owning_faction():is_human() then
            controlled_regions = controlled_regions + 1;
        end
    end

    for _, faction_key in pairs(self.settings.factions_to_destroy) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and not faction:is_dead() then
            factions_destroyed = false;
        end
    end

    if controlled_regions >= self.settings.region_count_halved or factions_destroyed == true then
        return true
    end

    return false;

end

return disaster_wild_hunt
