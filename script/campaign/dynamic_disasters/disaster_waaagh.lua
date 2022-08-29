--[[
    Da Biggest Waaagh, By CA.

    Disaster ported from the endgames disasters. Greenskins go full retard.

    Requirements:
        - Random chance (0.005)
        - +0.005 for each greenskin faction that has been wiped out.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - One or more major greenskin factions recover their capitals and spawn a lot of armies.
        - Finish:
            - A certain amount of vampire capitals controled.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_waaagh = {
	name = "waaagh",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_grn_greenskins" },

	settings = {
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

		army_template = {
			greenskins = "lategame"
		},
		base_army_count = 4, -- Number of armies that spawn when the event fires.
		unit_count = 19,
		early_warning_event = "wh3_main_ie_incident_endgame_waaagh_early_warning",
		ai_personality = "wh3_combi_empire_endgame",
        early_warning_delay = 10,
	}
}

local potential_greenskins = {
	"wh_main_grn_greenskins",
	"wh_main_grn_orcs_of_the_bloody_hand",
	"wh2_dlc15_grn_broken_axe",
	"wh2_dlc15_grn_bonerattlaz",
	"wh_main_grn_crooked_moon"
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_waaagh:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:add_listener(
            "WaaaghStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                self:trigger_da_biggest_waaagh();
                core:remove_listener("WaaaghStart")
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

function disaster_waaagh:trigger()
    self:set_status(STATUS_TRIGGERED);
    dynamic_disasters:execute_payload("wh3_main_ie_scripted_endgame_early_warning", self.settings.early_warning_event, self.settings.early_warning_delay);

end

function disaster_waaagh:trigger_da_biggest_waaagh()
    self:set_status(STATUS_STARTED);
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_grn_greenskins")

	local greenskin_factions = {}
	
	for i = 1, #potential_greenskins do
		local faction_key = potential_greenskins[i]
		local faction = cm:get_faction(faction_key)
		local region_key = nil
		if not faction:is_human() and not faction:is_dead() and not faction:was_confederated() then
			if faction:faction_leader():has_region() then
				region_key = faction:faction_leader():region():name()
			elseif faction:has_home_region() then
				region_key = faction:home_region():name()
			end
			if region_key ~= nil then
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod))
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, self.settings.ai_personality)
			end
		end
	end

	-- If #greenskin factions == 0 they're probably all dead, so let's revive someone in Black Crag
	if #greenskin_factions == 0 then
		table.insert(potential_greenskins, "wh_main_grn_necksnappers")
		for i = 1, #potential_greenskins do
			local faction_key = potential_greenskins[i]
            local faction = cm:get_faction(faction_key)
			if not cm:get_faction(faction_key):is_human() and not (faction:was_confederated() and faction:can_be_human()) then
				local region_key = "wh3_main_combi_region_black_crag"
				local region_owner = cm:get_region(region_key):owning_faction()
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod))
				if region_owner:is_null_interface() or (not region_owner:name() == faction_key and not region_owner:is_human()) then
					cm:transfer_region_to_faction(region_key, faction_key)
				end
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, "wh3_combi_greenskin_endgame")
				break
			end
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
	for i = 1, #greenskin_factions do 
		table.insert(objectives[1].conditions, "faction "..greenskin_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_waaagh"
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(incident_key, objectives, nil, greenskin_factions[1])
    else
        dynamic_disasters:execute_payload(incident_key, incident_key, 0);
    end
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_waaagh:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_waaagh:check_start_disaster_conditions()
    local base_chance = 0.005;
    for _, faction_key in pairs(potential_greenskins) do
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
function disaster_waaagh:check_end_disaster_conditions()
    local all_attackers_dead = true;

    for _, faction_key in pairs(potential_greenskins) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and not faction:is_dead() then
            all_attackers_dead = false;
        end
    end

    return all_attackers_dead;
end

return disaster_waaagh
