--[[
    Chi'an Chi Assault disaster, By Frodo45127.

    This disaster consists in a series of coordinated assaults to the Great Wall by Vilich which, if succeeds, will generate additional armies,
    and will start an assault in Cathay itself. No longer shall you ignore the wall's defenses!

    Supports debug mode, but still requires a max bastion thread to trigger.

    Requirements:
        - Always triggers between 2 and 3 turns after the bastion reaches max thread, if no Kurgan armies have been defeated.
        - At least turn 30 (so the player has already "prepared").
        - Vilich must be not confederated.
    Effects:
        - Trigger/First Warning:
            - Warning that reinforcements will come.
            - Cancels disaster if the Kurgan are dealt with.
            - If all 3 bastion gates are still in cathay's hands after 1-3 turns:
                - Spawn reinforcements on all 3 gates (same spawns as bastion attacks).
                - Cancels disaster if the Kurgan are dealt with.
        - After taking down the wall:
            - Spawns at least 3 armies for Vilich, with more showing up every 7 turns.
            - Lasts until the invasion ends, either by taking back the wall or by losing half of Cathay.
        - Event waits 5 turns before being able to be repeated.
    TODO:
        - Allow armies of the other chaos gods.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_FULL_INVASION = 2;

-- Object representing the disaster.
disaster_chianchi_assault = {
    name = "chianchi_assault",

    -- Values for categorizing the disaster.
    is_global = false;
    allowed_for_sc = { "wh3_main_sc_cth_cathay" },
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
        revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        min_turn = 30,                      -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 1,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                   -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        -- Disaster-specific data.
        warning_delay = 1,
        reinforcements_delay = 1,

        army_template = {
            chaos = "earlygame",
            tzeentch = "earlygame",
        },

        faction = "wh3_dlc20_chs_vilitch",

        cqis = {},                                   -- List of invader's cqi, so we can track them and release them when needed.
        targets = {},                                -- List of regions/factions to invade.
    },

    unit_count = 19,

    subculture = "wh3_main_sc_tze_tzeentch",

    warning_event_key = "fro_dyn_dis_chianchi_assault_warning",
    first_attack_event_key = "fro_dyn_dis_chianchi_assault_wall_assault_trigger",
    second_attack_event_key = "fro_dyn_dis_chianchi_assault_daemonic_invasion_trigger",
    second_attack_attackers_effect_key = "fro_dyn_dis_chianchi_assault_daemonic_invasion_invader_buffs",
    finish_before_assault_event_key = "fro_dyn_dis_chianchi_assault_finish_before_assault",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_chianchi_assault:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the warning. The invasion takes two-three turns to warn the player, so we have to wait until then..
        core:remove_listener("ChianchiAssaultWarning")
        core:add_listener(
            "ChianchiAssaultWarning",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay;
            end,

            -- If the invasion is still active, proceed with the warning. If not, take it as "finished".
            function()
                if self:check_finish() then
                    self:finish();
                else
                    dynamic_disasters:trigger_incident(self.warning_event_key, nil, 0, nil, nil, nil);
                end

                core:remove_listener("ChianchiAssaultWarning")
            end,
            true
        );

        -- Listener for the disaster. It should trigger a few turns after an invasion starts.
        core:remove_listener("ChianchiAssaultCountDown")
        core:add_listener(
            "ChianchiAssaultCountDown",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay + self.settings.reinforcements_delay;
            end,

            -- If the invasion is still active, proceed with the disaster. If not, take it as "finished".
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_before_assault_event_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_wall_attack_reinforcement();
                end

                core:remove_listener("ChianchiAssaultCountDown")
            end,
            true
        );

        -- Listener for the gates breach. It should trigger whenever the gates are breached.
        -- NOTE: It triggers the next turn to not just spawn armies as the gate falls.
        core:remove_listener("ChianchiAssaultGatesDestroyed")
        core:add_listener(
            "ChianchiAssaultGatesDestroyed",
            "WorldStartRound",
            function()

                -- Make sure this only triggers after the initial warning.
                if cm:turn_number() > self.settings.last_triggered_turn + self.settings.warning_delay then
                    local num_razed_gates = self:gates_razed_or_taken();

                    -- Trigger in any of these situations:
                    -- - If the invasion ends before a gate it's destroyed, we finish the assault.
                    -- - If the invasion continues and we got a gate down, spawn the next phase of the assault.
                    if (Bastion:get_saved_invasion_active_value() == true and num_razed_gates > 0) or (Bastion:get_saved_invasion_active_value() == false) then
                        return true
                    end
                end
                return false;
            end,
            function()

                -- If we passed because the invasion ended, trigger the end of the disaster.
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_before_assault_event_key, nil, 0, nil, nil, nil);
                    self:finish();

                -- If we passed because the gates fell, trigger the full invasion.
                else
                    self:trigger_full_daemonic_invasion();
                end

                -- Remove this and the reinforcement event, just in case this triggers before the reinforcements come.
                core:remove_listener("ChianchiAssaultCountDown")
                core:remove_listener("ChianchiAssaultGatesDestroyed")
            end,
            true
        );
    end

    if self.settings.status == STATUS_FULL_INVASION then

        -- Every 6 turns spawn more armies until the listener gets destroyed.
        core:remove_listener("ChianchiAssaultGatesDestroyedArmyRespawner")
        core:add_listener(
            "ChianchiAssaultGatesDestroyedArmyRespawner",
            "WorldStartRound",
            function()
                return cm:turn_number() % 6 == 0;
            end,
            function()
                local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod / 2));
                for _, location in pairs(Bastion.spawn_locations_by_gate) do
                    local spawn_pos = location.spawn_locations[cm:random_number(#location.spawn_locations)]
                    dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.unit_count, true, armies_to_spawn_per_gate, self.name, nil)
                end
            end,
            true
        )

        -- Listener for ending the disaster.
        core:remove_listener("ChianchiAssaultGatesFinished")
        core:add_listener(
            "ChianchiAssaultGatesFinished",
            "WorldStartRound",
            function()
                return self:check_finish();
            end,
            function()
                self:finish();
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_chianchi_assault:start()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delays to trigger this after the initial warning.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.warning_delay = 1;
        self.settings.reinforcements_delay = 1;
        self.settings.wait_turns_between_repeats = 1;
    else
        self.settings.warning_delay = cm:random_number(3, 2);
        self.settings.reinforcements_delay = cm:random_number(4, self.settings.warning_delay);
        self.settings.wait_turns_between_repeats = 5;
    end

     -- Reset the invasion data from the previous invasion, if any.
    self.settings.cqis = {};
    self.settings.targets = {};

    -- Set the army difficulty based on game turn.
    local current_turn = cm:turn_number();
    self.settings.army_template.chaos = "earlygame";
    self.settings.army_template.tzeentch = "earlygame";

    if current_turn >= 50 and current_turn < 100 then
        self.settings.army_template.chaos = "midgame";
        self.settings.army_template.tzeentch = "midgame";
    elseif current_turn >= 100 then
        self.settings.army_template.chaos = "lategame";
        self.settings.army_template.tzeentch = "lategame";
    end

    -- Initialize listeners.
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_chianchi_assault:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        core:remove_listener("ChianchiAssaultWarning")
        core:remove_listener("ChianchiAssaultCountDown")
        core:remove_listener("ChianchiAssaultGatesDestroyed")
        core:remove_listener("ChianchiAssaultGatesDestroyedArmyRespawner")
        core:remove_listener("ChianchiAssaultGatesFinished")

        -- Free any scripted army we have.
        dynamic_disasters:release_armies(self.settings.cqis, self.settings.targets, cm:turn_number());
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_chianchi_assault:check_start()
    local faction = cm:get_faction(self.settings.faction);
    if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
        if Bastion:get_saved_invasion_active_value() == true then
            return true;
        else
            return false;
        end
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_chianchi_assault:check_finish()

    -- If the bastion meter went back to 0, end the disaster.
    if Bastion:get_saved_invasion_active_value() == false then
        return true;
    end

    -- If the faction is confederated, end the disaster.
    local faction = cm:get_faction(self.settings.faction);
    if faction == false or faction:is_null_interface() or faction:was_confederated() then
        return true;
    end

    return false;
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the first invasion reinforcements.
function disaster_chianchi_assault:trigger_wall_attack_reinforcement()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering bastion attack.");

    -- For each gate, spawn a few Vilich armies.
    local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod));
    for _, location in pairs(Bastion.spawn_locations_by_gate) do
        local spawn_pos = location.spawn_locations[cm:random_number(#location.spawn_locations, 1)]

        -- Store the gate to attack for each army.
        for j = 1, armies_to_spawn_per_gate do
            table.insert(self.settings.targets, location.gate_key)
        end

        dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.unit_count, true, armies_to_spawn_per_gate, self.name, chianchi_assault_gate_attackers_callback)
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.first_attack_event_key, nil, 0, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
end

-- Function to trigger a full daemonic invasion through the gates of the Great Bastion.
function disaster_chianchi_assault:trigger_full_daemonic_invasion()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering daemonic invasion.");

    -- On the initial trigger of the invasion, spawn at least 3 more armies to kickstart the invasion.
    local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod));
    for _, location in pairs(Bastion.spawn_locations_by_gate) do
        local spawn_pos = location.spawn_locations[cm:random_number(#location.spawn_locations, 1)]
        dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.unit_count, true, armies_to_spawn_per_gate, self.name, nil)
    end

    -- Apply buffs to the attackers, so they can at least push one province into player territory.
    cm:apply_effect_bundle(self.second_attack_attackers_effect_key, self.settings.faction, 10)

    -- Declare war on the owners of all gates and their neightbors, except if they're chaos-related or allies of vilich.
    local faction = cm:get_faction(self.settings.faction);
    dynamic_disasters:declare_war_for_owners_and_neightbours(faction, Bastion.cathay_bastion_regions, false, {"wh_main_sc_chs_chaos", "wh_dlc08_sc_nor_norsca"}, false);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.second_attack_event_key, nil, 0, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_FULL_INVASION);
end

-- Function to check how many gates have been razed or taken by other than Cathay.
function disaster_chianchi_assault:gates_razed_or_taken()
    local num_razed_gates_or_taken = 0;
    for i = 1, #Bastion.spawn_locations_by_gate do
        local region = cm:get_region(Bastion.spawn_locations_by_gate[i].gate_key);
        if region:is_abandoned() or region:owning_faction():subculture() ~= "wh3_main_sc_cth_cathay" then
            num_razed_gates_or_taken = num_razed_gates_or_taken + 1
        end
    end
    return num_razed_gates_or_taken;
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function chianchi_assault_gate_attackers_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 10)
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
        if disaster.name == "chianchi_assault" then
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

return disaster_chianchi_assault
