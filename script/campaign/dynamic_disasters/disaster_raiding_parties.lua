--[[
    Raiding Parties disaster, By Frodo45127.

    This disaster consists on limited coastal attacks by either Vampire Coast armies, Norscan or Dark Elven fleets.

    Supports debug mode.

    NOTE: This disaster can use three subcultures, except when one of them is shared with the player.

    Requirements:
        - Random chance: 2% (1/50 turns).
        - +1% for each possible attacker faction that has been wiped out (not confederated).
        - At least turn 30 (so the player has a coast).
        - At least one of the potential attackers must be alive (you can end this disaster by killing them all).
        - At least 10 turns have passed since the last pirate raid.
    Effects:
        - Trigger/First Warning:
            - Message of warning about ships with black and tattered sails.
            - Wait 4-10 turns for more info.
        - Invasion:
            - Get some random coastal areas, weigthed a bit considering the provinces the player owns.
            - Pick one random faction and give them some armies on the coast nearby.
            - Invasion is canceled (storm event) if attacker's faction is wiped out before the invasion begins.
        - Finish:
            - Once everything is spawned, it's up to the AI to attack.

    Attacker Buffs (they're raiders, quick to deploy, but slow on land and hard to recover):
        - Ammunation: +50%
        - Movement Range: -10%
        - Replenishment Rate: -10%
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

-- Object representing the disaster.
disaster_raiding_parties = {
    name = "raiding_parties",

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
        proximity_war = false,              -- If true, war declarations will be against neightbours only. If false, they'll be global.
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
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        -- Disaster-specific data.
        army_template = {},
        warning_delay = 1,                  -- Turns between the warning and the assault.
        grace_period = 1,                   -- Turns between the warning and the assault + 6. Once ended, we release the armies to the AI, no matter if they fulfilled their objectives or not.

        faction = "",
        subculture = "",
        factions_alive = {},
        subcultures_alive = {},
        factions = {           -- Factions that will receive the attacking armies.
            wh2_dlc11_sc_cst_vampire_coast = {      -- Vampire Coast
                "wh2_dlc11_cst_vampire_coast",          -- Harkon
                "wh2_dlc11_cst_noctilus",               -- Noctilus
                "wh2_dlc11_cst_pirates_of_sartosa",     -- Aranessa
                "wh2_dlc11_cst_the_drowned",            -- Cylostra
            },
            wh2_main_sc_def_dark_elves = {          -- Dark elves
                "wh2_main_def_naggarond",               -- Malekith
                "wh2_main_def_cult_of_pleasure",        -- Morathi
                "wh2_main_def_har_ganeth",              -- Hellebron
                "wh2_dlc11_def_the_blessed_dread",      -- Lokhir
                "wh2_main_def_hag_graef",               -- Malus
                "wh2_twa03_def_rakarth",                -- Rakarth
            },
            wh_dlc08_sc_nor_norsca = {              -- Norsca
                "wh_dlc08_nor_norsca",                  -- Wulfrik
                "wh_dlc08_nor_wintertooth",             -- Throgg
            },
        },

        cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
        targets = {},                                -- List of regions/factions to invade.
    },

    unit_count = 19,

    warning_event_key = "fro_dyn_dis_raiding_parties_warning",
    warning_effect_key = "dyn_dis_raiding_parties_early_warning",
    raiding_event_key = "fro_dyn_dis_raiding_parties_trigger",
    invader_buffs_effects_key = "fro_dyn_dis_raiding_parties_invader_buffs",
    finish_early_incident_key = "fro_dyn_dis_raiding_parties_early_end",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_raiding_parties:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the warning.
        core:remove_listener("RaidingPartiesWarning")
        core:add_listener(
            "RaidingPartiesWarning",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay
            end,
            function()
                if self:update_alive() == false then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_raiding_parties();
                end
                core:remove_listener("RaidingPartiesWarning")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to know when to free the AI armies and finish the disaster.
        core:remove_listener("RaidingPartiesFreeArmies")
        core:add_listener(
            "RaidingPartiesFreeArmies",
            "WorldStartRound",
            function()
                return cm:turn_number() <= self.settings.last_triggered_turn + self.settings.grace_period
            end,
            function()
                out("Frodo45127: RaidingPartiesFreeArmies")
                local max_turn = self.settings.last_triggered_turn + self.settings.grace_period;
                dynamic_disasters:release_armies(self.settings.cqis, self.settings.targets, max_turn);

                -- Finish the disaster after all armies are freed.
                if cm:turn_number() == max_turn then
                    self:finish();
                    core:remove_listener("RaidingPartiesFreeArmies")
                end
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_raiding_parties:start()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay for further executions.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.warning_delay = 1;
        self.settings.grace_period = 5; -- Keep this a few turns ahead to test if the AI actually works.
        self.settings.wait_turns_between_repeats = 1;
    else
        self.settings.warning_delay = cm:random_number(10, 4);
        self.settings.grace_period = self.settings.warning_delay + 6;
        self.settings.wait_turns_between_repeats = self.settings.grace_period + 4;
    end

     -- Reset the invasion data from the previous invasion, if any.
    self.settings.cqis = {};
    self.settings.targets = {};

    -- Get the subculture/faction to use as raiders. Here so we can check if this faction is invalid at the point of triggering the raid, to avoid "weird" stuff.
    self.settings.subculture = self.settings.subcultures_alive[cm:random_number(#self.settings.subcultures_alive)];
    self.settings.faction = self.settings.factions_alive[self.settings.subculture][cm:random_number(#self.settings.factions_alive[self.settings.subculture])];

    local invasion_turn = cm:turn_number() + self.settings.warning_delay;
    local template = "earlygame";
    if invasion_turn >= 50 and invasion_turn < 100 then
        template = "midgame";
    elseif invasion_turn >= 100 then
        template = "lategame";
    end

    self.settings.army_template = {};
    if self.settings.subculture == "wh2_dlc11_sc_cst_vampire_coast" then
        self.settings.army_template.vampire_coast = template;
    elseif self.settings.subculture == "wh_dlc08_sc_nor_norsca" then
        self.settings.army_template.norsca = template;
    elseif self.settings.subculture == "wh2_main_sc_def_dark_elves" then
        self.settings.army_template.dark_elves = template;
    end

    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");
    dynamic_disasters:trigger_incident(self.warning_event_key, self.warning_effect_key, self.settings.warning_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_raiding_parties:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_raiding_parties:check_start()

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
    for _, factions in pairs(self.settings.factions) do
        for _, faction_key in pairs(factions) do
            local faction = cm:get_faction(faction_key);
            if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
                base_chance = base_chance + 10;
            end
        end
    end

    if cm:random_number(1000, 0) <= base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_raiding_parties:check_finish()

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

-- Function to trigger the raid itself.
function disaster_raiding_parties:trigger_raiding_parties()
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

                    -- Do not attack your own subculture. Attack everyone else.
                    if not region_owner == false and region_owner:is_null_interface() == false and region_owner:subculture() ~= self.settings.subculture then
                        attack_vectors[coast] = attack_vectors[coast] + (1 / #sea_region_data.coastal_regions);

                        -- Give a bit more priority to player coastal settlements.
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
    local faction = cm:get_faction(self.settings.faction);
    local coast_to_attack = coasts_to_attack[cm:random_number(math.ceil(#coasts_to_attack / 3))];
    local first_sea_region = nil;
    for _, sea_region in pairs(dyn_dis_coasts[coast_to_attack]) do
        first_sea_region = sea_region;

        -- Spawn armies at sea.
        for i = 1, #dyn_dis_sea_regions[sea_region].coastal_regions do

            -- Armies calculation, per province.
            local region_key = dyn_dis_sea_regions[sea_region].coastal_regions[i];
            local army_count = math.floor(cm:random_number(math.ceil(self.settings.difficulty_mod)));
            local spawn_pos = dyn_dis_sea_regions[sea_region].spawn_positions[cm:random_number(#dyn_dis_sea_regions[sea_region].spawn_positions)];
            out("Frodo45127: Armies to spawn: " .. tostring(army_count) .. " for " .. region_key .. " region, spawn pos X: " .. spawn_pos[1] .. ", Y: " .. spawn_pos[2] .. ".");

            -- Store the region for invasion controls.
            for j = 1, army_count do
                table.insert(self.settings.targets, region_key)
            end

            dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, region_key, spawn_pos, self.settings.army_template, self.unit_count, false, army_count, self.name, raiding_parties_spawn_armies_callback);
        end
    end

    -- Make every attacking faction go full retard against the owner of the coastal provinces.
    if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
        for _, sea_region in pairs(dyn_dis_coasts[coast_to_attack]) do
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, dyn_dis_sea_regions[sea_region].coastal_regions, false, {self.settings.subculture}, false);
        end
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:apply_effect_bundle(self.invader_buffs_effects_key, self.settings.faction, 10)
    dynamic_disasters:trigger_incident(self.raiding_event_key, nil, 0, dyn_dis_sea_regions[first_sea_region].coastal_regions[1], nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
    self:set_status(STATUS_STARTED);
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function raiding_parties_spawn_armies_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 10)
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
        if disaster.name == "raiding_parties" then
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

-- Function to update the list of alive faction/subculture that we can use for the disaster.
---@return boolean #If we got at least one faction/subculture alive.
function disaster_raiding_parties:update_alive()

    -- First, get all player subcultures. We need to discard them from the "alive" list.
    local human_factions = cm:get_human_factions()
    local human_subcultures = {}
    for i = 1, #human_factions do
        table.insert(human_subcultures, cm:get_faction(human_factions[i]):subculture())
    end

    -- Second, re-populate the alive lists so we can make sure that the faction we're going to use is actually alive.
    self.settings.factions_alive = {};
    self.settings.subcultures_alive = {};
    local count_alive = 0;
    for subculture, _ in pairs(self.settings.factions) do

        -- Update the potential factions removing the confederated ones.
        self.settings.factions[subculture] = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions[subculture]);

        local is_human = false;
        for _, human_subculture in pairs(human_subcultures) do
            if human_subculture == subculture then
                is_human = true;
                break;
            end
        end

        -- If the subculture is shared with a human player, discard all factions from it.
        -- That way we can directly avoid problematic situations.
        if is_human then
            self.settings.factions[subculture] = {};

        -- If the subculture is not human, then proceed to get the factions alive.
        else
            local factions_alive = {};
            local count = 0;
            for _, faction_key in pairs(self.settings.factions[subculture]) do
                local faction = cm:get_faction(faction_key);

                -- Do not use vassals for this, as we may ran into an issue with your own vassals declaring war on you.
                if not faction == false and faction:is_null_interface() == false and not faction:is_dead() and not faction:is_vassal() then
                    count = count + 1;
                    table.insert(factions_alive, faction_key);
                end
            end

            if count > 0 then
                count_alive = count_alive + 1;
                self.settings.factions_alive[subculture] = factions_alive;
                table.insert(self.settings.subcultures_alive, subculture);
            end
        end
    end

    -- Return if at least one of the subcultures has one or more factions alive.
    return count_alive > 0
end

return disaster_raiding_parties
