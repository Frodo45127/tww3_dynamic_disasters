--[[
    Piramid of Nagash, By CA.

    Disaster ported from the endgames disasters. Vampires/Tomb Kings go full retard.

    Requirements:
        - Random chance (0.02)
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - Spawn vampires/tomb kings armies at the black piramid.
        - Finish:
            - Take the piramid or destroy its owner.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_pyramid_of_nagash = {
	name = "pyramid_of_nagash",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_vmp_vampire_counts", "wh2_dlc09_sc_tmb_tomb_kings" },

	settings = {
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },
		army_template = {},
		base_army_count = 8, -- Number of armies that spawn when the event fires.
		unit_count = 19	,
		faction_key = "wh2_dlc09_tmb_the_sentinels", -- Default invasion faction
		region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
		early_warning_event = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
		ai_personality_tomb_kings = "wh3_combi_tombking_endgame",
		ai_personality_vampires = "wh3_combi_vampire_endgame",
		early_warning_delay = 10,
		is_current_victory_condition = false,
		region_bundle = "",
	}
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_pyramid_of_nagash:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

	    -- Listener for the disaster.
	    core:add_listener(
	        "PyramidOfNagashStart",
	        "WorldStartRound",
	        function()
	            return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
	        end,
	        function()
	            self:trigger_resurection_of_nagash();
	            core:remove_listener("PyramidOfNagashStart")
	        end,
	        true
	    );

    end

    if self.settings.status == STATUS_STARTED then

    	-- Listener to keep spawning armies every 10 turns.
		core:add_listener(
			"endgame_pyramid_of_nagash_spawn_army",
			"WorldStartRound",
			function()
				return cm:turn_number() % 10 and cm:get_faction(self.settings.faction_key):has_home_region()
			end,
			function()
				endgame:create_scenario_force(self.settings.faction_key, self.settings.region_key, self.settings.army_template, self.settings.unit_count, false, 1)
			end,
			true
		)

		-- Victory listeners.
	    if self.settings.is_current_victory_condition == true then
			core:add_listener(
				"endgame_pyramid_of_nagash_ultimate_victory",
				"MissionSucceeded",
				function(context)
					return context:mission():mission_record_key() == "wh_main_ultimate_victory"
				end,
				function()
					cm:remove_effect_bundle_from_region(self.settings.region_bundle, self.settings.settings.region_key)
					core:remove_listener("endgame_pyramid_of_nagash_spawn_army")
					core:remove_listener("endgame_pyramid_of_nagash_ultimate_victory")
					disaster_pyramid_of_nagash:trigger_end_disaster()
				end,
				true
			)
	    else
			core:add_listener(
				"endgame_pyramid_of_nagash_ultimate_victory",
				"WorldStartRound",
				function(context)
					return self:check_end_disaster_conditions()
				end,
				function()
					cm:remove_effect_bundle_from_region(self.settings.region_bundle, self.settings.settings.region_key)
					core:remove_listener("endgame_pyramid_of_nagash_spawn_army")
					core:remove_listener("endgame_pyramid_of_nagash_ultimate_victory")
					disaster_pyramid_of_nagash:trigger_end_disaster()
				end,
				true
			)

	    end
    end
end

function disaster_pyramid_of_nagash:trigger()
	self:set_status(STATUS_TRIGGERED);
	dynamic_disasters:execute_payload("wh3_main_ie_scripted_endgame_early_warning", self.settings.early_warning_event, self.settings.early_warning_delay, nil);
end

function disaster_pyramid_of_nagash:trigger_resurection_of_nagash()
	local region = cm:get_region(self.settings.region_key)
	local owning_faction

	-- Check to see if AI Vampires or Tomb Kings already own the region
	if not region:is_abandoned() and not region:owning_faction():is_human() then
		owning_faction = region:owning_faction()

		if owning_faction:subculture() == "wh2_dlc09_sc_tmb_tomb_kings" then
			self.settings.faction_key = owning_faction:name()
			self.settings.army_template.tomb_kings = "lategame"
		elseif owning_faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
			self.settings.faction_key = owning_faction:name()
			self.settings.army_template.vampires = "lategame"
		else
			-- Default to Tomb Kings if neither Tomg Kings or Vampires own the region
			self.settings.army_template.tomb_kings = "lategame"
		end

	-- If the region is abandoned or controlled by a human we use the default
	else
		self.settings.army_template.tomb_kings = "lategame"
	end

	endgame:create_scenario_force(self.settings.faction_key, self.settings.region_key, self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod))

	local incident_key, faction_bundle
	if self.settings.army_template.vampires == "lategame" then
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_vampires"
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_vampires"
		self.settings.region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_vampires"
		cm:force_change_cai_faction_personality(self.settings.faction_key, self.settings.ai_personality_vampires)
	else
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_dlc09_sc_tmb_tomb_kings")
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_tomb_kings"
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_tomb_kings"
		self.settings.region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_tomb_kings"
		cm:force_change_cai_faction_personality(self.settings.faction_key, self.settings.ai_personality_tomb_kings)
	end

	cm:apply_effect_bundle(faction_bundle, self.settings.faction_key, 0)
	cm:apply_effect_bundle_to_region(self.settings.region_bundle, self.settings.region_key, 0)
	
	endgame:no_peace_no_confederation_only_war(self.settings.faction_key)
	local invasion_faction = cm:get_faction(self.settings.faction_key)
	endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"faction "..self.settings.faction_key,
				"confederation_valid"
			}
		},
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total 1",
				"region "..self.settings.region_key
			}
		}
	}
	
    if dynamic_disasters.settings.victory_condition_triggered == false then
    	self.settings.is_current_victory_condition = true;
        dynamic_disasters:add_victory_condition(incident_key, objectives, self.settings.region_key, nil)
    else
    	self.settings.is_current_victory_condition = false;
        dynamic_disasters:execute_payload(incident_key, incident_key, 0, nil);
    end

    -- Executed at the end because it needs some data set in this function to work.
	self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_pyramid_of_nagash:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_pyramid_of_nagash:check_start_disaster_conditions()
    local base_chance = 0.02;

    if math.random() < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_pyramid_of_nagash:check_end_disaster_conditions()
    local done = true;

    local faction = cm:get_faction(self.settings.faction_key);
    if faction ~= false and not faction:is_dead() then
        done = false;
    end

	local region = cm:get_region(self.settings.region_key)
	if not region:is_abandoned() and not region:owning_faction():is_human() then
		local owning_faction = region:owning_faction()
		if owning_faction:name() == self.settings.faction_key then
			done = false;
		end

	end

    return done;
end

return disaster_pyramid_of_nagash
