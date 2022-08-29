--[[
    Chi'an Chi Assault disaster, By Frodo45127.

    This disaster consists in a series of coordinated assaults to the Great Wall by Vilich which, if succeeds, will generate additional armies,
    and will start an assault in Cathay.

    Requirements:
        - Triggers if, after two turns of max bastion thread, the Kurgan are still there.
    Effects:
        - Trigger/First Warning:
            - Warning that reinforcements will come.
            - Wait 3-6 turns.
            - Cancels disaster if the Kurgan are dealt with.
        - Reinforcements:
            - Spawn reinforcements if invasion is still in progress.
            - Cancels disaster if the Kurgan are dealt with.
        - After taking down the wall:
            - Spawns a lot of armies for Vilich, with more showing up every 7 turns
            - Lasts until the invasion ends, either by taking back the wall or by losing half of Cathay.

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

    -- Settings of the disaster that will be stored in a save.
    settings = {

        -- Common data for all disasters.
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = true,                  -- If the disaster can be repeated.
        min_turn = 30,                      -- Minimum turn required for the disaster to trigger.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 5,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        -- Disaster-specific data.
        warning_delay = 3,
        reinforcements_delay = 2,
        warning_event_key = "fro_dyn_dis_chianchi_assault_warning",
        first_attack_event_key = "fro_dyn_dis_chianchi_assault_wall_assault_trigger",
        first_attack_attackers_effect_key = "fro_dyn_dis_chianchi_assault_wall_assault_invader_buffs",
        second_attack_event_key = "fro_dyn_dis_chianchi_assault_daemonic_invasion_trigger",
        second_attack_attackers_effect_key = "fro_dyn_dis_chianchi_assault_daemonic_invasion_invader_buffs",
        finish_before_assault_event_key = "fro_dyn_dis_chianchi_assault_finish_before_assault",

        army_template = {
            chaos = "earlygame",
            tzeentch = "earlygame",
        },
        base_army_unit_count = 19,

        faction = "wh3_dlc20_chs_vilitch",
    }
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_chianchi_assault:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the warning. The invasion takes two turns to spawn, so we have to wait until then..
        core:add_listener(
            "ChianchiAssaultWarning",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay then
                    return true
                end
                return false;
            end,

            -- If the invasion is still active, proceed with the warning. If not, take it as "finished".
            function()
                if Bastion:get_saved_invasion_active_value() == true then
                    dynamic_disasters:execute_payload(self.settings.warning_event_key, nil, 0);
                else
                    core:remove_listener("ChianchiAssaultGatesDestroyed")
                    core:remove_listener("ChianchiAssaultCountDown")
                    self:trigger_end_disaster();
                end

                core:remove_listener("ChianchiAssaultWarning")
            end,
            true
        );

        -- Listener for the disaster. It should trigger a few turns after an invasion starts.
        core:add_listener(
            "ChianchiAssaultCountDown",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay + self.settings.reinforcements_delay then
                    return true
                end
                return false;
            end,

            -- If the invasion is still active, proceed with the disaster. If not, take it as "finished".
            function()
                if Bastion:get_saved_invasion_active_value() == true then
                    self:trigger_wall_attack_reinforcement();
                else
                    dynamic_disasters:execute_payload(self.settings.finish_before_assault_event_key, nil, 0);
                    core:remove_listener("ChianchiAssaultGatesDestroyed")
                    self:trigger_end_disaster();
                end
                core:remove_listener("ChianchiAssaultCountDown")
            end,
            true
        );

        -- Listener for the gates breach. It should trigger whenever the gates are breached.
        core:add_listener(
            "ChianchiAssaultGatesDestroyed",
            "WorldStartRound",
            function()
                local num_razed_gates = self:gates_razed_or_taken();

                -- Make sure this only triggers after the initial warning.
                if cm:turn_number() > self.settings.last_triggered_turn + self.settings.warning_delay then

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
                local num_razed_gates = self:gates_razed_or_taken();

                if Bastion:get_saved_invasion_active_value() == true and num_razed_gates > 0 then
                    self:trigger_full_daemonic_invasion();
                end

                if (Bastion:get_saved_invasion_active_value() == false) then
                    dynamic_disasters:execute_payload(self.settings.finish_before_assault_event_key, nil, 0);
                    self:trigger_end_disaster();
                end

                -- Remove this and the reinforcement event, just in case this triggers before the reinforcements come.
                core:remove_listener("ChianchiAssaultCountDown")
                core:remove_listener("ChianchiAssaultGatesDestroyed")
            end,
            true
        );
    end

    if self.settings.status == STATUS_FULL_INVASION then

        -- Every 7 turns spawn more armies until the listener gets destroyed.
        core:add_listener(
            "ChianchiAssaultGatesDestroyedArmyRespawner",
            "WorldStartRound",
            function()
                return cm:turn_number() % 7;
            end,
            function()
                local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod / 2));
                for _, location in pairs(Bastion.spawn_locations_by_gate) do
                    local spawn_pos = location.spawn_locations[math.random(1, #location.spawn_locations)]
                    dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_per_gate, self.name)
                end
            end,
            true
        )

        -- Listener for ending the disaster.
        core:add_listener(
            "ChianchiAssaultGatesFinished",
            "WorldStartRound",
            function()
                -- Only trigger once the invasion has been "finished" either by the player taking down the kurgan, or by the kurgan taking down cathay.
                if Bastion:get_saved_invasion_active_value() == false then
                    return true
                end
                return false;
            end,
            function()
                self:trigger_end_disaster();
                core:remove_listener("ChianchiAssaultGatesDestroyedArmyRespawner")
                core:remove_listener("ChianchiAssaultGatesFinished")
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_chianchi_assault:trigger()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay to trigger this after the initial warning.
    self.settings.reinforcements_delay = math.random(1, 3);

    -- Set the army difficulty based on game turn.
    local current_turn = cm:turn_number();
    if current_turn < 40 then
        self.settings.army_template.chaos = "earlygame";
        self.settings.army_template.tzeentch = "earlygame";
    end

    if current_turn >= 40 and current_turn < 90 then
        self.settings.army_template.chaos = "midgame";
        self.settings.army_template.tzeentch = "midgame";
    end

    if current_turn >= 90 then
        self.settings.army_template.chaos = "lategame";
        self.settings.army_template.tzeentch = "lategame";
    end

    -- Initialize listeners.
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first invasion reinforcements.
function disaster_chianchi_assault:trigger_wall_attack_reinforcement()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering bastion attack.");

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh3_main_sc_tze_tzeentch")
    dynamic_disasters:execute_payload(self.settings.first_attack_event_key, nil, 0);

    -- For each gate, spawn a few Vilich armies.
    local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod));
    for _, location in pairs(Bastion.spawn_locations_by_gate) do
        local spawn_pos = location.spawn_locations[math.random(1, #location.spawn_locations)]
        dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_per_gate, self.name)
    end
end

-- Function to trigger a full daemonic invasion through the gates of the Great Bastion.
function disaster_chianchi_assault:trigger_full_daemonic_invasion()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering daemonic invasion.");

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh3_main_sc_tze_tzeentch")
    dynamic_disasters:execute_payload(self.settings.second_attack_event_key, nil, 0);


    -- On the initial trigger of the invasion, spawn at least 3 more armies to kickstart the invasion.
    local armies_to_spawn_per_gate = math.floor(1 * math.ceil(self.settings.difficulty_mod));
    for _, location in pairs(Bastion.spawn_locations_by_gate) do
        local spawn_pos = location.spawn_locations[math.random(1, #location.spawn_locations)]
        dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, location.gate_key, spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_per_gate, self.name)
    end

    -- Set diplomacy.
    local attacker_faction = cm:get_faction(self.settings.faction);
    if attacker_faction ~= false and not attacker_faction:is_dead() then

        -- Apply buffs to the attackers, so they can at least push one province into player territory.
        cm:apply_effect_bundle(self.settings.second_attack_attackers_effect_key, self.settings.faction, 10)

        -- Force vilich to attack the whoever in cathay owns the gates.
        for _, region_key in pairs(Bastion.cathay_bastion_regions) do
            local region = cm:get_region(region_key)
            local region_owner = region:owning_faction()

            -- TODO: ignore it if the gates are hold by a vassal or norscan tribe.
            if region_owner:is_null_interface() == false and region_owner:subculture() == "wh3_main_sc_cth_cathay" and region_owner:name() ~= "rebels" and not attacker_faction:at_war_with(region_owner) then
                cm:force_declare_war(self.settings.faction, region_owner:name(), false, true)
            end
        end
    end

    -- Initialize listeners.
    self:set_status(STATUS_FULL_INVASION);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_chianchi_assault:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_chianchi_assault:check_start_disaster_conditions()
    if Bastion:get_saved_invasion_active_value() == true then
        return true;
    else
        return false;
    end
end

-- Utility function to check how many gates have been razed or taken
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

return disaster_chianchi_assault
