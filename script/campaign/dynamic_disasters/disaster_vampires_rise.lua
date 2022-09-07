--[[
    Vampires Rise, By CA.

    Disaster ported from the endgames disasters. Vampires go full retard.

    Requirements:
        - Random chance (0.005)
        - +0.005 for each vampire faction that has been wiped out.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - One major vampire faction recover his capitals and spawn a lot of armies.
        - Finish:
            - A certain amount of vampire capitals controled.

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

	settings = {
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },
		army_template = {
			vampires = "lategame"
		},
		base_army_count = 4, -- Number of armies that spawn in each vampire homeland when the event fires.
		unit_count = 19,
        early_warning_delay = 10,
	},

    early_warning_incident_key = "wh3_main_ie_incident_endgame_vampires_rise_early_warning",
    early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
	ai_personality = "wh3_combi_vampire_endgame",
}

local potential_vampires = {
	wh_main_vmp_schwartzhafen = "wh3_main_combi_region_castle_drakenhof",
	wh_main_vmp_vampire_counts = "wh3_main_combi_region_ka_sabar",
	wh2_dlc11_vmp_the_barrow_legion = "wh3_main_combi_region_blackstone_post",
	wh3_main_vmp_caravan_of_blue_roses = "wh3_main_combi_region_the_haunted_forest",
	wh_main_vmp_mousillon = "wh3_main_combi_region_mousillon"
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
                self:trigger_the_great_vampiric_war();
                core:remove_listener("VampiresRiseStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to end the invasion.
        core:add_listener(
            "VampiresRiseEnd",
            "WorldStartRound",
            function ()
                return self:check_end_disaster_conditions()
            end,
            function()
                self:trigger_end_disaster();
                core:remove_listener("VampiresRiseEnd")
            end,
            true
        );
    end
end

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

function disaster_vampires_rise:trigger_the_great_vampiric_war()

	local vampire_factions = {}
	
	for faction_key, region_key in pairs(potential_vampires) do
		local faction = cm:get_faction(faction_key)
		if not faction:is_human() and not (faction:was_confederated() and faction:can_be_human()) then
			table.insert(vampire_factions, faction_key)
			dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod), self.name)
			endgame:no_peace_no_confederation_only_war(faction_key)
			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_vampires_rise", faction_key, 0)
			cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, { region_key }, true, { "wh_main_sc_vmp_vampire_counts" })
		end
	end

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid"
            }
		}
	}

    -- If we got not factions, stop the disaster.
    if #vampire_factions == 0 then
        self:trigger_end_disaster();
        return
    end

	for i = 1, #vampire_factions do
		table.insert(objectives[1].conditions, "faction "..vampire_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_vampires_rise"
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(incident_key, objectives, nil, vampire_factions[1])
    else
        dynamic_disasters:execute_payload(incident_key, nil, 0, nil);
    end

    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
    self:set_status(STATUS_STARTED);
end


-- Function to trigger cleanup stuff after the invasion is over.
function disaster_vampires_rise:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_vampires_rise:check_start_disaster_conditions()

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    local base_chance = 0.005;
    for faction_key, _ in pairs(potential_vampires) do
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
function disaster_vampires_rise:check_end_disaster_conditions()
    local controlled_regions = 0;

    for _, region_key in pairs(potential_vampires) do
        local region = cm:get_region(region_key);

        -- TODO: check for allies too.
        if region ~= false and region:owning_faction():is_human() then
            controlled_regions = controlled_regions + 1;
        end
    end

    if controlled_regions >= #potential_vampires then
        return true
    end

    return false;
end

return disaster_vampires_rise
