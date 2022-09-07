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
		early_warning_delay = 10,
		is_current_victory_condition = false,
		faction_data = nil, -- To be filled with the relevant faction data.
	},

	tomb_kings_data = {
		faction_key = "wh2_dlc09_tmb_the_sentinels", -- Default invasion faction, will use another TK faction if they control the pyramid
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_tomb_kings",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_tomb_kings",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_tomb_kings",
		ai_personality = "wh3_combi_tombking_endgame",
		subculture = "wh2_dlc09_sc_tmb_tomb_kings",
		music = "wh2_dlc09_sc_tmb_tomb_kings",
		army_template = {
			tomb_kings = "lategame"
		}
	},
	vampires_data = {
		faction_key = "",
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_vampires",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_vampires",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_vampires",
		ai_personality = "wh3_combi_vampire_endgame",
		subculture = "wh_main_sc_vmp_vampire_counts",
		music = "wh_main_sc_vmp_vampire_counts",
		army_template = {
			vampires = "lategame"
		}
	},

	region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
    early_warning_incident_key = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
	early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
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

    	-- Fix for older versions of the disaster.
    	if self.settings.faction_data == nil then
    		self.settings.faction_data = self.tomb_kings_data;
    	end

    	-- Listener to keep spawning armies every 10 turns.
		core:add_listener(
			"endgame_pyramid_of_nagash_spawn_army",
			"WorldStartRound",
			function()
				return cm:turn_number() % 10 == 0 and cm:get_faction(self.settings.faction_data.faction_key):has_home_region()
			end,
			function()
				dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.settings.unit_count, false, math.ceil(self.settings.difficulty_mod), self.name)
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
					cm:remove_effect_bundle_from_region(self.settings.faction_data.region_bundle, self.region_key)
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
					cm:remove_effect_bundle_from_region(self.settings.faction_data.region_bundle, self.region_key)
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

    -- Debug mode support.
    if dynamic_disasters.settings.debug == false then
        self.settings.early_warning_delay = math.random(8, 12);
    else
        self.settings.early_warning_delay = 1;
    end

	dynamic_disasters:execute_payload(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil);
	self:set_status(STATUS_TRIGGERED);
end

function disaster_pyramid_of_nagash:trigger_resurection_of_nagash()
	local region = cm:get_region(self.region_key)
	local data = self.tomb_kings_data

	-- Check to see if AI Vampires or Tomb Kings already own the region
	if not region:is_abandoned() then
		local owning_faction = region:owning_faction()
		if not owning_faction:is_human() then
			if owning_faction:subculture() == "wh2_dlc09_sc_tmb_tomb_kings" then
				data.faction_key = owning_faction:name()
			elseif owning_faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
				data = self.vampires_data
				data.faction_key = owning_faction:name()
			end
		end
	end

	self.settings.faction_data = data;
	self.settings.army_template = self.settings.faction_data.army_template;

	dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.settings.unit_count, true, math.floor(self.settings.base_army_count*self.settings.difficulty_mod), self.name)

	cm:apply_effect_bundle(self.settings.faction_data.faction_bundle, self.settings.faction_data.faction_key, 0)
	cm:apply_effect_bundle_to_region(self.settings.faction_data.region_bundle, self.region_key, 0)
	cm:force_change_cai_faction_personality(self.settings.faction_data.faction_key, self.settings.faction_data.ai_personality)

	endgame:no_peace_no_confederation_only_war(self.settings.faction_data.faction_key)
	local invasion_faction = cm:get_faction(self.settings.faction_data.faction_key)
	dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { self.region_key }, true, { self.settings.faction_data.subculture })

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"faction "..self.settings.faction_data.faction_key,
				"confederation_valid"
			}
		},
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total 1",
				"region "..self.region_key
			}
		}
	}
	
    if dynamic_disasters.settings.victory_condition_triggered == false then
    	self.settings.is_current_victory_condition = true;
        dynamic_disasters:add_victory_condition(self.settings.faction_data.incident_key, objectives, self.region_key, nil)
    else
    	self.settings.is_current_victory_condition = false;
        dynamic_disasters:execute_payload(self.settings.faction_data.incident_key, nil, 0, nil);
    end

    -- Executed at the end because it needs some data set in this function to work.
	cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.faction_data.music);
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

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

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

    local faction = cm:get_faction(self.settings.faction_data.faction_key);
    if faction ~= false and not faction:is_dead() then
        done = false;
    end

	local region = cm:get_region(self.region_key)
	if not region:is_abandoned() and not region:owning_faction():is_human() then
		local owning_faction = region:owning_faction()
		if owning_faction:name() == self.settings.faction_data.faction_key then
			done = false;
		end

	end

    return done;
end

return disaster_pyramid_of_nagash
