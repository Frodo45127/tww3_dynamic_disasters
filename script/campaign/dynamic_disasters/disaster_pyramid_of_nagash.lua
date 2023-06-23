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
        		- Declare war on every non tomb king faction.
        	- If a Vampire or a Tomb Kings faction holds the Black Pyramid:
        		- Spawn armies of said faction around it.
        		- Declare war on every faction not of the same subculture as the owner of the Black Pyramid.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in the Black Pyramid, if it's controlled by the disaster faction.
        - Finish:
            - Capture the Black Pyramid or destroy its owner.

    Attacker Buffs:
        - For endgame (Vampires and Tomb Kings:
            - Recruitment Cost: -50%
            - Replenishment Rate: +10%
        - Only for Vampires:
            - Unkeep: -50%
        - Only for the Black Pyramid region/province:
            - Only for Vampires:
                - Vampiric Corruption: +20%.
            - For all:
                - Leadership: +20%
                - Melee Defense: +10%

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
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

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
				"confederation_valid",
				"vassalization_valid"
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
        revive_dead_factions = false,       -- If true, dead factions will be revived if needed.
        proximity_war = false,              -- If true, war declarations will be against neightbours only. If false, they'll be global.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        short_victory_is_min_turn = false,  -- If the short victory turn should be used as min turn.
        long_victory_is_min_turn = true,    -- If the long victory turn should be used as min turn.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        --Disaster-specific data.
        early_warning_delay = 10,
		army_template = {},					-- To be filled once we pick a faction for the disaster.
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
			vampire_counts = "lategame"
		}
	},

	unit_count = 19,
	army_count_per_province = 8,

	region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
    early_warning_incident_key = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
	early_warning_effects_key = "dyn_dis_black_pyramid_early_warning",
	endgame_mission_name = "guess_whos_back",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_pyramid_of_nagash:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

	    -- Listener for the disaster.
        core:remove_listener("PyramidOfNagashStart")
	    core:add_listener(
	        "PyramidOfNagashStart",
	        "WorldStartRound",
	        function()
	            return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
	        end,
	        function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.settings.faction_data.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_resurection_of_nagash();
                end
	            core:remove_listener("PyramidOfNagashStart")
	        end,
	        true
	    );

    end

    if self.settings.status == STATUS_STARTED then

    	-- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, as long as they hold the Black Pyramid.
        core:remove_listener("PyramidOfNagashStart")
		core:add_listener(
			"PyramidOfNagashRespawn",
			"WorldStartRound",
			function()
				return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and cm:get_faction(self.settings.faction_data.faction_key):has_home_region()
			end,
			function()
			    local army_count = math.floor(self.settings.difficulty_mod);
				dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.settings.unit_count, false, army_count, self.name, nil)
			end,
			true
		)
    end
end

-- Function to trigger the early warning before the disaster.
function disaster_pyramid_of_nagash:start()

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = cm:random_number(12, 8);
    end

	-- Set the faction data here, so the disaster stops if said faction loses the pyramid.
	local region = cm:get_region(self.region_key)
	local data = self.tomb_kings_data

	local owning_faction = region:owning_faction()
	if not owning_faction:is_human() then
		if owning_faction:subculture() == "wh2_dlc09_sc_tmb_tomb_kings" then
			data.faction_key = owning_faction:name()
		elseif owning_faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
			data = self.vampires_data
			data.faction_key = owning_faction:name()
		end
	end

	self.settings.faction_data = data;
	self.settings.army_template = self.settings.faction_data.army_template;

	dynamic_disasters:trigger_incident(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil, nil, nil);
	self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_pyramid_of_nagash:finish()
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
function disaster_pyramid_of_nagash:check_start()
	local region = cm:get_region(self.region_key)
	if region == false or region:is_null_interface() then
		return false;
	end

	-- The disaster can only trigger if either vampires or tomb kings control the pyramid.
	local region_owner = region:owning_faction();
	if region:is_abandoned() or (
		region_owner == false or
		region_owner:is_null_interface() or
		region_owner:is_human() or (
			region_owner:subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings" and
			region_owner:subculture() ~= "wh_main_sc_vmp_vampire_counts"
		)) then
		return false;
	end

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        return true;
    end

    -- If we're at max turn, trigger it without checking chances.
    if self.settings.max_turn > 0 and cm:turn_number() == self.settings.max_turn then
        return true;

    -- If we have max turn set, we need to use a 1 in turn range chance.
    -- This makes it so we don't give extreme chance of triggering at the max turn.
    elseif self.settings.max_turn > self.settings.min_turn then
        local range = self.settings.max_turn - self.settings.min_turn;
        if cm:random_number(range, 0) <= 1 then
            return true;
        end
    else

        local base_chance = 15;
        if cm:random_number(1000, 0) <= base_chance then
            return true;
        end
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_pyramid_of_nagash:check_finish()
	local region = cm:get_region(self.region_key)
	if region == false or region:is_null_interface() then
		return true;
	end

	-- If no vampires nor tomb kings control the pyramid, or the previous controlling faction has lost the pyramid, cancel the disaster.
	local region_owner = region:owning_faction();
	if region:is_abandoned() or (
		region_owner == false or
		region_owner:is_null_interface() or
		region_owner:is_human() or (
			region_owner:subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings" and
			region_owner:subculture() ~= "wh_main_sc_vmp_vampire_counts"
		) or
		region_owner:name() ~= self.settings.faction_data.faction_key) then
		return true;
	end

    return false;
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the disaster.
function disaster_pyramid_of_nagash:trigger_resurection_of_nagash()
    local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);

    -- Army spawn may fail, but we ignore it here. The checks before this function already ensure the faction is alive, so this is not essential.
	dynamic_disasters:create_scenario_force(self.settings.faction_data.faction_key, self.region_key, self.settings.army_template, self.unit_count, false, army_count, self.name, nil)

    -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
    dynamic_disasters:no_peace_no_confederation_only_war(self.settings.faction_data.faction_key, self.settings.enable_diplomacy)

	local faction = cm:get_faction(self.settings.faction_data.faction_key)
	cm:force_change_cai_faction_personality(self.settings.faction_data.faction_key, self.settings.faction_data.ai_personality)
	cm:instantly_research_all_technologies(self.settings.faction_data.faction_key)
    dynamic_disasters:declare_war_configurable(not self.settings.perimeter_war, self.settings.perimeter_war, true, faction, nil, nil, true, { self.settings.faction_data.subculture }, true);

	cm:apply_effect_bundle(self.settings.faction_data.faction_bundle, self.settings.faction_data.faction_key, 0)
	cm:apply_effect_bundle_to_region(self.settings.faction_data.region_bundle, self.region_key, 0)

    -- Prepare the victory mission/disaster end data.
    table.insert(self.objectives[2].conditions, "faction " .. self.settings.faction_data.faction_key)

    -- Reveal all regions subject to capture.
    dynamic_disasters:prepare_reveal_regions({ self.region_key });

	-- Make the Black Pyramid fly!
	cm:override_building_chain_display("wh2_dlc09_special_settlement_pyramid_of_nagash_tmb", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating");

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.settings.faction_data.incident_key, self.region_key, self.settings.faction_data.faction_key, function () self:finish() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.faction_data.music)
    self:set_status(STATUS_STARTED);
end

return disaster_pyramid_of_nagash
