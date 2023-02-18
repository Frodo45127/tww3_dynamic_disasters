--[[
    Bretonaian Crusades disaster, By Frodo45127.

    This disaster consists on a limited crusade of a Bretonian faction against a neutral/chaotic faction.

    Crusader's win if they capture the target settlement in time. Lose otherwise. If crusaders win,
    they get a couple extra armies and a chance they choose to continue the crusade afterwards.

    Supports debug mode. Cannot run if there are no more bretonian factions left, or if "The Greatest Crusade" has been triggered.

    Requirements:
        - Random chance: 2% (1/50 turns).
        - +1% for each possible attacker faction that has been wiped out (not confederated).
        - At least turn 30.
        - At least one of the potential attackers must be alive (you can end this disaster by killing them all).
        - At least 10 turns have passed since the last crusade.
    Effects:
        - Trigger/First Warning:
            - Message of warning about bretonian knights preparing for war.
            - Wait 4-10 turns for more info.
        - Invasion:
            - Get a random province owned by a neutral/chaos faction, within 1 province of a coast.
            - Pick one random faction and give them some armies on the coast nearby.
            - Invasion is canceled if attacker's faction is wiped out before the invasion begins.
            - If failed in the period given, just finish the invasion.
            - If it's a success, have a 25% chance of them getting more armies on the coast and attacking another couple of neightbouring regions owned by neutral/chaos factions.
        - Finish:
            - Once everything is spawned, it's up to the AI to attack.

    Attacker Buffs (only while the invasion lasts):
        - For Cavalry-focused faction:
            - Replenishment Rate: +10%
            - Leadership: +20%
            - Armour For Cavalry: +20%
            - Melee Attack For Cavalry: +20%
            - Charge Bonus For Cavalry: +20%
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_FIRST_INVASION = 2;
local STATUS_SECOND_INVASION = 3;

-- Object representing the disaster.
disaster_bretonian_crusades = {
    name = "bretonian_crusades",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = {},
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {

        -- Common data for all disasters.
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = true,                  -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        revive_dead_factions = false,       -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        short_victory_is_min_turn = false,  -- If the short victory turn should be used as min turn.
        long_victory_is_min_turn = false,   -- If the long victory turn should be used as min turn.
        min_turn = 30,                      -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 10,    -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {          -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.
            "the_greatest_crusade",
        },

        -- Disaster-specific data.
        army_template = {
            bretonnia = "earlygame",
        },

        warning_delay = 1,                  -- Turns between the warning and the assault.
        crusading_time = 1,                 -- Turns we give the crusaders to reach their goal before considering the crusade a failure.
        grace_period = 1,                   -- Turns between the warning and the assault + 6. Once ended, we release the armies to the AI, no matter if they fulfilled their objectives or not.

        faction = "",
        target_faction = "",
        subculture = "wh_main_sc_brt_bretonnia",
        factions_alive = {},
        factions = {

            -- Major
            "wh_main_brt_bretonnia",
            "wh_main_brt_bordeleaux",
            "wh_main_brt_carcassonne",
            "wh2_dlc14_brt_chevaliers_de_lyonesse",

            -- Minor
            "wh2_main_brt_knights_of_origo",
            "wh2_main_brt_knights_of_the_flame",
            "wh2_main_brt_thegans_crusaders",
            "wh3_main_brt_aquitaine",
            "wh_main_brt_artois",
            "wh_main_brt_bastonne",
            "wh_main_brt_lyonesse",
            "wh_main_brt_parravon",
        },

        cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
        targets = {},                                -- List of regions/factions to invade.
    },

    unit_count = 19,

    warning_incident_key = "dyn_dis_bretonian_crusades_warning",
    warning_effect_key = "dyn_dis_bretonian_crusades_warning",
    crusade_incident_key = "dyn_dis_bretonian_crusades_trigger",
    invader_buffs_effects_key = "dyn_dis_bretonian_crusades_invader_buffs",
    finish_early_incident_key = "dyn_dis_bretonian_crusades_early_end",             -- This one is end due to not being able to launch the crusade.
    bad_ending_incident_key = "dyn_dis_bretonian_crusades_bad_end",               -- This one is end due to either dying during the crusade, or not taking their targets on time.
    good_ending_incident_key = "dyn_dis_bretonian_crusades_good_end",              -- This one is end due taking their objectives on time and stopping.
    very_good_ending_incident_key = "dyn_dis_bretonian_crusades_very_good_end",         -- This one is end due taking their objectives on time and continuing to a nearby settlement.
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_bretonian_crusades:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the warning.
        core:remove_listener("BretonianCrusadeWarning")
        core:add_listener(
            "BretonianCrusadeWarning",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay
            end,
            function()
                if self:update_alive() == false then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_crusade();
                end
                core:remove_listener("BretonianCrusadeWarning")
            end,
            true
        );
    end

    if self.settings.status == STATUS_FIRST_INVASION then

        -- Listener to know when to free the AI armies and finish the disaster.
        core:remove_listener("BretonianCrusadeFreeArmies")
        core:add_listener(
            "BretonianCrusadeFreeArmies",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.crusading_time
            end,
            function()
                out("Frodo45127: BretonianCrusadeFreeArmies")
                local max_turn = self.settings.last_triggered_turn + self.settings.crusading_time;
                dynamic_disasters:release_armies(self.settings.cqis, self.settings.targets, max_turn);

                -- Finish the disaster after all armies are freed.
                if cm:turn_number() == max_turn then
                    self:finish();
                    core:remove_listener("BretonianCrusadeFreeArmies")
                end
            end,
            true
        );

        -- Listener to check if the crusaders managed to achieve their goals.
        core:remove_listener("BretonianCrusadeTargetReachedOrTimeout")
        core:add_listener(
            "BretonianCrusadeTargetReachedOrTimeout",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.crusading_time
            end,
            function()

                local controlled = 0;
                for _, region_key in pairs(self.settings.targets) do
                    local region = cm:get_region(region_key);
                    if not region:is_abandoned() then
                        local owner = region:owning_faction();
                        if owner:name() == self.settings.faction then
                            controlled = controlled + 1;
                        end
                    end
                end

                -- If they reached their target, roll a 1d4 to either end the crusade in a success, or continue it.
                if controlled == #self.settings.targets then
                    if cm:random_number(100, 0) <= 25 or dynamic_disasters.settings.debug_2 == true then
                        self:trigger_extended_crusade();
                        core:remove_listener("BretonianCrusadeTargetReachedOrTimeout")
                    else
                        dynamic_disasters:trigger_incident(self.good_ending_incident_key, nil, 0, nil, nil, nil);
                        self:finish();
                        core:remove_listener("BretonianCrusadeTargetReachedOrTimeout")
                    end

                -- If we reached the turn limit and the crusaders lost, end the crusade here as a failure.
                elseif cm:turn_number() == self.settings.last_triggered_turn + self.settings.crusading_time then
                    dynamic_disasters:trigger_incident(self.bad_ending_incident_key, nil, 0, nil, nil, nil);
                    self:finish();
                    core:remove_listener("BretonianCrusadeTargetReachedOrTimeout")
                end
            end,
            true
        );
    end

    if self.settings.status == STATUS_SECOND_INVASION then

        -- Listener to know when to free the AI armies and finish the disaster.
        core:remove_listener("BretonianCrusadeFreeArmies2")
        core:add_listener(
            "BretonianCrusadeFreeArmies2",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.grace_period
            end,
            function()
                out("Frodo45127: BretonianCrusadeFreeArmies2")
                local max_turn = self.settings.last_triggered_turn + self.settings.grace_period;
                dynamic_disasters:release_armies(self.settings.cqis, self.settings.targets, max_turn);

                -- Finish the disaster after all armies are freed.
                if cm:turn_number() == max_turn then
                    self:finish();
                    core:remove_listener("BretonianCrusadeFreeArmies2")
                end
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_bretonian_crusades:start()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay for further executions.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.warning_delay = 1;
        self.settings.crusading_time = 4;
        self.settings.grace_period = 5; -- Keep this a few turns ahead to test if the AI actually works.
        self.settings.wait_turns_between_repeats = 1;
    else
        self.settings.warning_delay = cm:random_number(10, 4);
        self.settings.crusading_time = 8;
        self.settings.grace_period = self.settings.warning_delay + self.settings.crusading_time + 6;
        self.settings.wait_turns_between_repeats = self.settings.grace_period + 4;
    end

     -- Reset the invasion data from the previous invasion, if any.
    self.settings.cqis = {};
    self.settings.targets = {};

    -- Get the faction to use as raiders. Here so we can check if this faction is invalid at the point of triggering the raid, to avoid "weird" stuff.
    self.settings.faction = self.settings.factions_alive[cm:random_number(#self.settings.factions_alive)];

    local invasion_turn = cm:turn_number() + self.settings.warning_delay;
    if invasion_turn >= 50 and invasion_turn < 100 then
        self.settings.army_template.bretonnia = "midgame";
    elseif invasion_turn >= 100 then
        self.settings.army_template.bretonnia = "lategame";
    end

    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");
    dynamic_disasters:trigger_incident(self.warning_incident_key, self.warning_effect_key, self.settings.warning_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_bretonian_crusades:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_bretonian_crusades:check_start()

    -- If none of the available factions is alive, do not trigger the disaster.
    if self:update_alive() == false then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        return true;
    end

    -- Base chance: 1/50 turns (2%).
    local base_chance = 20;

    -- Increase the change of starting based on how many attackers are already dead.
    -- In theory, no need to remove again confederated factions.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and not faction:is_human() and faction:is_dead() then
            base_chance = base_chance + 10;
        end
    end

    if cm:random_number(1000, 0) <= base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_bretonian_crusades:check_finish()

    -- If the faction we picked before is dead or a vassal, we cannot trigger the disaster.
    local faction = cm:get_faction(self.settings.faction);
    if faction == false or faction:is_null_interface() or faction:is_dead() or faction:is_vassal() then
        return true;
    end

    return false;
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the first invasion itself.
function disaster_bretonian_crusades:trigger_crusade()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");

    -- Get all the coastal regions (as in region with a port) to attack by weight.
    local attack_vectors = {};
    local count = 0;

    -- Calculate the weight of each attack region.
    for coast, regions in pairs(dyn_dis_coasts) do
        attack_vectors[coast] = 0;
        count = count + 1;

        for _, sea_region in pairs(regions) do
            local sea_region_data = dyn_dis_sea_regions[sea_region];

            for _, land_region in pairs(sea_region_data.coastal_regions) do
                local region = cm:get_region(land_region)
                if not region == false and region:is_null_interface() == false and not region:is_abandoned() then
                    local region_owner = region:owning_faction()

                    -- Do not attack order factions. Attack everyone else.
                    if not region_owner == false and region_owner:is_null_interface() == false and not dynamic_disasters:is_order_faction(region_owner:name()) then
                        attack_vectors[coast] = attack_vectors[coast] + (1 / #sea_region_data.coastal_regions);

                        -- Give a bit more priority to player coastal settlements, if it's not an order faction.
                        if region_owner:is_human() == true then
                            attack_vectors[coast] = attack_vectors[coast] + 0.5;
                        end
                    end
                end
            end
        end
    end

    -- Get the regions sorted by value, so we can then pick just from the first half.
    local coasts_to_attack = {};
    for vector, _ in pairs(attack_vectors) do
        table.insert(coasts_to_attack, vector)
    end

    table.sort(coasts_to_attack, function(a, b) return attack_vectors[a] > attack_vectors[b] end)

    -- If no coast to attack has been found, just cancel the attack.
    if #coasts_to_attack < 1 then
        out("Frodo45127: We have no coasts to attack. Canceling disaster.");
        dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
        self:finish()
        return;
    end

    -- Get the region at random from the top third of the coasts.
    out("Frodo45127: We have " .. #coasts_to_attack .. " coasts to attack. Using only the upper third.");
    local coast_to_attack = coasts_to_attack[cm:random_number(math.ceil(#coasts_to_attack / 3))];
    out("Frodo45127: Coast chosen to attack: " .. coast_to_attack .. ".");

    -- Find a neutral/chaotic faction in the coastal regions we selected to use as target. Use random order to give more variety on targets.
    self.settings.target_faction = "";
    local random_sea_regions = cm:random_sort_copy(dyn_dis_coasts[coast_to_attack]);
    for _, sea_region in pairs(random_sea_regions) do
        local random_coasts = cm:random_sort_copy(dyn_dis_sea_regions[sea_region].coastal_regions);

        for i = 1, #random_coasts do
            local region = cm:get_region(random_coasts[i]);
            if not region == false and region:is_null_interface() == false and not region:is_abandoned() then
                local region_owner = region:owning_faction();
                if not region_owner == false and region_owner:is_null_interface() == false and (dynamic_disasters:is_chaos_faction(region_owner:name()) or dynamic_disasters:is_neutral_faction(region_owner:name())) then
                    self.settings.target_faction = region_owner:name();
                    break;
                end
            end
        end

        if not self.settings.target_faction == "" then
            break;
        end
    end

    -- Cancel the disaster if we have no target faction.
    if self.settings.target_faction == "" then
        dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
        self:finish();
    end

    local first_coast = nil;
    for _, sea_region in pairs(dyn_dis_coasts[coast_to_attack]) do

        -- Spawn armies at sea.
        for i = 1, #dyn_dis_sea_regions[sea_region].coastal_regions do

            -- Only spawn the armies needed to invade one of the coast owners, chosen at random.
            local region_key = dyn_dis_sea_regions[sea_region].coastal_regions[i];
            local region = cm:get_region(region_key);
            if not region == false and region:is_null_interface() == false and not region:is_abandoned() and region:owning_faction():name() == self.settings.target_faction then
                if first_coast == nil then
                    first_coast = region_key;
                end

                -- Armies calculation, per province.
                local army_count = math.floor(cm:random_number(math.ceil(self.settings.difficulty_mod)));
                local spawn_pos = dyn_dis_sea_regions[sea_region].spawn_positions[cm:random_number(#dyn_dis_sea_regions[sea_region].spawn_positions)];
                out("Frodo45127: Armies to spawn: " .. tostring(army_count) .. " for " .. region_key .. " region, spawn pos X: " .. spawn_pos[1] .. ", Y: " .. spawn_pos[2] .. ".");

                -- Store the region for invasion controls.
                for j = 1, army_count do
                    table.insert(self.settings.targets, region_key)
                end

                dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, region_key, spawn_pos, self.settings.army_template, self.unit_count, false, army_count, self.name, bretonian_crusades_spawn_armies_callback);
            end
        end
    end

    out("Frodo45127: Declaring war between crusaders of " .. self.settings.faction .. " and " .. self.settings.target_faction .. ".");

    -- Declare war against the coast owners. Due to how coasts are selected, we have guaranteed that at least one of the land provinces
    -- belongs to a neutral/chaos faction, so only declare war against the first neutral owner we find here.
    dynamic_disasters:declare_war(self.settings.faction, self.settings.target_faction, true, true);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:apply_effect_bundle(self.invader_buffs_effects_key, self.settings.faction, self.settings.crusading_time)
    dynamic_disasters:trigger_incident(self.crusade_incident_key, nil, 0, first_coast, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
    self:set_status(STATUS_FIRST_INVASION);
end

-- Function to trigger the second invasion.
function disaster_bretonian_crusades:trigger_extended_crusade()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering second invasion.");

    local base_regions = cm:random_sort_copy(self.settings.targets);
    local new_target = nil;
    for _, region_key in pairs(base_regions) do
        local region = cm:get_region(region_key);
        local adjacent_region_list = region:adjacent_region_list();
        for i = 0, adjacent_region_list:num_items() -1 do
            local adjacent_region = adjacent_region_list:item_at(i);
            if not adjacent_region:is_abandoned() then
                local adjacent_region_owner = adjacent_region:owning_faction();
                if adjacent_region_owner:name() == self.settings.target_faction then
                    new_target = adjacent_region:name();
                    break;
                end
            end
        end

        if not (new_target == nil) then
            break;
        end
    end

    -- If no more settlements are in range, just cancel the attack.
    if new_target == nil then
        dynamic_disasters:trigger_incident(self.good_ending_incident_key, nil, 0, nil, nil, nil);
        self:finish()
        return;
    end

    -- Make sure we reset the armies we're going to script.
    self.settings.cqi = {};
    self.settings.targets = {};

    -- Spawn armies only to attack the new target, and nothing more. One army per captured city.
    for _, previous_target in pairs(base_regions) do
        table.insert(self.settings.targets, new_target)
        dynamic_disasters:create_scenario_force(self.settings.faction, previous_target, self.settings.army_template, self.unit_count, false, 1, self.name, bretonian_crusades_spawn_armies_callback);
    end

    -- Make sure the war is not over.
    dynamic_disasters:declare_war(self.settings.faction, self.settings.target_faction, true, true);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:apply_effect_bundle(self.invader_buffs_effects_key, self.settings.faction, self.settings.crusading_time)
    dynamic_disasters:trigger_incident(self.very_good_ending_incident_key, nil, 0, new_target, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
    self:set_status(STATUS_SECOND_INVASION);
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function bretonian_crusades_spawn_armies_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 8)
    cm:add_agent_experience(character, cm:random_number(25, 10), true)
    cm:add_experience_to_units_commanded_by_character(character, cm:random_number(5, 2))

    local general = cm:get_character_by_cqi(cqi)
    local invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())

    if invasion == nil or invasion == false then
        return
    end

    -- Store all the disaster's cqis, so we can free them later.
    for i = 1, #dynamic_disasters.disasters do
        local disaster = dynamic_disasters.disasters[i];
        if disaster.name == "bretonian_crusades" then
            local cqis = disaster.settings.cqis;
            local targets = disaster.settings.targets;

            out("\tFrodo45127: Army with cqi " .. cqi .. " created and added to the invasions force.")
            table.insert(cqis, cqi);

            local region_key = targets[#targets];
            local region = cm:get_region(region_key);

            if not region == false and region:is_null_interface() == false then
                local faction = region:owning_faction();
                if not faction == false and faction:is_null_interface() == false and faction:name() ~= "rebels" and faction:name() ~= disaster.settings.faction then

                    invasion:set_target("REGION", region_key, faction:name());
                    invasion:add_aggro_radius(15);
                    invasion:abort_on_target_owner_change(true);

                    if invasion:has_target() then
                        out.design("\t\tFrodo45127: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to attack " .. region_key .. ".")
                        invasion:start_invasion(nil, false, false, false)
                        return;
                    end
                end
            end
        end
    end

    -- If we didn't return before due to an early return on invasion movement or cancelation, release the army.
    invasion:release();
end

-- Function to update the list of alive faction that we can use for the disaster.
---@return boolean #If we got at least one faction alive.
function disaster_bretonian_crusades:update_alive()
    self.settings.factions_alive = {};

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);

        -- Do not use vassals for this, as we may ran into an issue with your own vassals declaring war on you.
        if not faction == false and faction:is_null_interface() == false and not faction:is_human() and not faction:is_dead() and not faction:is_vassal() then
            table.insert(self.settings.factions_alive, faction_key);
        end
    end

    -- Return if at least one of the subcultures has one or more factions alive.
    return #self.settings.factions_alive > 0
end

return disaster_bretonian_crusades
