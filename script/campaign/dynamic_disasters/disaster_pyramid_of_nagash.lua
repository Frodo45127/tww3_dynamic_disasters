--[[
    Piramid of Nagash, By CA.

    Disaster ported from the endgames disasters. The owner of the Black Pyramid (if is Vampire of Tomb King)goes full retard. If neither holds the Pyramid, the sentinels will take control of it instead.

    Requirements:
        - Random chance: 1.5% (1/75 turns). This is more than others to compensate the fact that this one cannot be increased by killing related factions.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
        	- If a player or a non Vampire and non Tomb Kings faction holds the Black Pyramid:
        		- Spawn armies from "Sentinels of Nagash" around it.
        		- Declare war on the player and adjacent regions.
        	- If a Vampire or a Tomb Kings faction holds the Black Pyramid:
        		- Spawn armies of said faction around it.
        		- Declare war on the player and adjacent regions.
            - Keep respawning armies every (10 / difficulty_multiplier) turns as long as they hold the Black Pyramid.
        - Finish:
            - Capture the Black Pyramid or destroy its owner.

    Ideas:
        - Resurrect Nagash faction and extend this with the Nagash mod.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_pyramid_of_nagash = {
	name = "pyramid_of_nagash",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = {},

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total 1",
				"region wh3_main_combi_region_black_pyramid_of_nagash"
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
		army_template = {},					-- To be filled once we pick a faction for the disaster.
		army_count_per_province = 8,
		unit_count = 19,
        early_warning_delay = 10,

		faction_data = nil, 				-- To be filled once we pick a faction for the disaster.
	},

	tomb_kings_data = {
		faction_key = "wh2_dlc09_tmb_the_sentinels", -- Default invasion faction, will use another TK faction if they control the pyramid
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_tomb_kings",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_tomb_kings",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_tomb_kings",
		finish_early_incident_key = "dyn_dis_pyramid_of_nagash_tomb_kings_early_end",
		ai_personality = "wh3_combi_tombking_endgame",
		subculture = "wh2_dlc09_sc_tmb_tomb_kings",
		music = "wh2_dlc09_sc_tmb_tomb_kings",
		army_template = {
			tomb_kings = "lategame"
		}
	},
	vampires_data = {
		faction_key = "",		-- To be filled by the one that's ocupying the Black Pyramid.
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_vampires",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_vampires",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_vampires",
		ai_personality = "wh3_combi_vampire_endgame",
		finish_early_incident_key = "dyn_dis_pyramid_of_nagash_vampires_early_end",
		subculture = "wh_main_sc_vmp_vampire_counts",
		music = "wh_main_sc_vmp_vampire_counts",
		army_template = {
			vampires = "lategame"
		}
	},

	region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
    early_warning_incident_key = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
	early_warning_effects_key = "wh3_main_ie_scripted_endgame_early_warning",
	endgame_mission_name = "guess_whos_back",
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

                -- Check if the sentinels are available to use.
    			local sentinels_available = true;
    			local region = cm:get_region(self.region_key)
				local region_owner = region:owning_faction();
				if region:is_abandoned() or
					region_owner:is_human() or
					(
						region_owner:is_human() == false and
						region_owner:subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings" and
						region_owner:subculture() ~= "wh_main_sc_vmp_vampire_counts"
					) then

					-- The disaster cannot begin if we need the sentinels to spawn and they've been confederated.
					local faction = cm:get_faction("wh2_dlc09_tmb_the_sentinels");
				    if faction == false or faction:is_null_interface() == true or faction:was_confederated() == true then
				    	sentinels_available = false;
				    end
				end

                if sentinels_available == false then
                    dynamic_disasters:execute_payload(self.settings.faction_data.finish_early_incident_key, nil, 0, nil);
                    self:trigger_end_disaster()
                else
                    self:trigger_resurection_of_nagash();
                end
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

    	-- Listener to keep spawning armies every (10 / difficulty_mod) turns, as long as they hold the Black Pyramid.
		core:add_listener(
			"PyramidOfNagashRespawn",
			"WorldStartRound",
			function()
				return cm:turn_number() % math.ceil(10 / self.settings.difficulty_mod) == 0 and cm:get_faction(self.settings.faction_data.faction_key):has_home_region()
			end,
			function()
			    local army_count = math.floor(self.settings.difficulty_mod);
				dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.settings.unit_count, false, army_count, self.name)
			end,
			true
		)
    end
end

-- Function to trigger the early warning before the disaster.
function disaster_pyramid_of_nagash:trigger()

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = math.random(8, 12);
    end

	dynamic_disasters:execute_payload(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil);
	self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the disaster.
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

	-- Set the faction data and army templates to use on the invasion.
	self.settings.faction_data = data;
	self.settings.army_template = self.settings.faction_data.army_template;

    local army_count = math.floor(self.settings.army_count_per_province * self.settings.difficulty_mod);
	dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.settings.unit_count, false, army_count, self.name)

	local faction = cm:get_faction(self.settings.faction_data.faction_key)
	cm:force_change_cai_faction_personality(self.settings.faction_data.faction_key, self.settings.faction_data.ai_personality)
	endgame:no_peace_no_confederation_only_war(self.settings.faction_data.faction_key)
	dynamic_disasters:declare_war_for_owners_and_neightbours(faction, { self.region_key }, true, { self.settings.faction_data.subculture })

	cm:apply_effect_bundle(self.settings.faction_data.faction_bundle, self.settings.faction_data.faction_key, 0)
	cm:apply_effect_bundle_to_region(self.settings.faction_data.region_bundle, self.region_key, 0)

    -- Prepare the victory mission/disaster end data.
    table.insert(self.objectives[2].conditions, "faction " .. self.settings.faction_data.faction_key)

    -- Reveal all regions subject to capture.
    dynamic_disasters:reveal_regions({ self.region_key });

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.settings.faction_data.incident_key, self.region_key, self.settings.faction_data.faction_key, function () self:trigger_end_disaster() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.faction_data.music)
    self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_pyramid_of_nagash:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        -- Cleanup before finishing the disaster.
        cm:remove_effect_bundle_from_region(self.settings.faction_data.region_bundle, self.region_key)
		core:remove_listener("PyramidOfNagashRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_pyramid_of_nagash:check_start_disaster_conditions()
	local region = cm:get_region(self.region_key)
	local region_owner = region:owning_faction();
	if region:is_abandoned() or
		region_owner:is_human() or
		(
			region_owner:is_human() == false and
			region_owner:subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings" and
			region_owner:subculture() ~= "wh_main_sc_vmp_vampire_counts"
		) then

		-- The disaster cannot begin if we need the sentinels to spawn and they've been confederated.
		local faction = cm:get_faction("wh2_dlc09_tmb_the_sentinels");
	    if faction == false or faction:is_null_interface() == true or faction:was_confederated() == true then
	    	return false;
	    end
	end

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    -- If we're at max turn, trigger it without checking chances.
    if self.settings.max_turn > 0 and cm:turn_number() == self.settings.max_turn then
        return true;
    end

    local base_chance = 0.015;
    if math.random() < base_chance then
        return true;
    end

    return false;
end

return disaster_pyramid_of_nagash
