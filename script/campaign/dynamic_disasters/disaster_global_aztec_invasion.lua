--[[
    Aztec Invasion disaster, By Frodo45127.

    This disaster consists in a coastal invasion by Lizarmen, to restore the... status of the world according to the great plan.
    Meaning, the classic "There is no problem with others if there is no others" solution.

    Requirements:
        - Having more than 5 provinces out of the "dejure provinces" of your faction.
        - +1 if you attacked the lizards or they have been wiped out (optional, +1 to the weigth of this disaster to happen).
        - At least turn 60 (so the player has already "prepared").
    Effects:
        - Trigger/First Warning:
            - Message of warning about rumors of weird ships.
            - Wait 3-6 turns for more info.
        - Second Warning:
            - Message of warning about weird ships with lizards on board confirmed.
            - Wait 3-6 turns for more info.
        - Invasion:
            - Spawn new faction: Fixers of the Great Plan.
                - At war with everyone except lizards.
                - Cannot do diplomacy.
                - Starts with a ton of money so it can be a menace in the first few turns of his existance.
            - Spawn 2 invasion-controlled armies (composition depending on dificulty, maybe 3 for capitals) in every coastal region not belonging to lizards.
            - Attack their corresponding settlements.
            - Once they've taken the cities, free their AI.
        - Finish:
            - The faction "Fixers of the Great Plan" is no more.

]]

-- Statuses this disaster supports. Status 1 is common to all disasters and it's declared in the manager file.
local DISASTER_STATUS_UNTRIGGERED = 1;
local DISASTER_STATUS_FIRST_WARNING_EMITED = 2;
local DISASTER_STATUS_SECOND_WARNING_EMITED = 3;
local DISASTER_STATUS_INVASION_STARTED = 4;
local DISASTER_STATUS_INVASION_DESTROYED = 100;

-- Object with the default values for this disaster. This is meant to be unique.
DisasterAztecInvasion = {

    -- Common data for all disasters.
    save_key = "DisasterAztecInvasionState",
    name = "disaster_global_aztec_invasion",
    inner = {

        -- Common data for all disasters.
        repeteable = false,
        started = false,
        finished = false,
        turns_to_trigger_from_campaign_start = 1,
        turns_to_trigger_from_first_warning = 1,
        turns_to_trigger_from_second_warning = 1,
        wait_turns_between_repeats = 0,
        last_finished_turn = 0,

        -- Disaster-specific data.
        status = DISASTER_STATUS_UNTRIGGERED,
        first_warning_turn = 0,
        second_warning_turn = 0,
        invasion_start_turn = 0,
        invasion_end_turn = 0,
    }

}

-- Function to trigger the disaster.
function DisasterAztecInvasion.trigger_start_disaster()
    out("Frodo45127: Starting disaster: " .. DisasterAztecInvasion.name);

    -- Listeners for the different phases of the disaster.
    core:add_listener(
        "DisasterAztecInvasionSecondWarning",
        "ScriptEventDisasterAztecInvasionSecondWarning",
        true,
        DisasterAztecInvasion.trigger_second_warning,
        true
    );

    core:add_listener(
        "DisasterAztecInvasionAztecInvasion",
        "ScriptEventDisasterAztecInvasionAztecInvasion",
        true,
        DisasterAztecInvasion.trigger_aztec_invasion,
        true
    );

    DisasterAztecInvasion.trigger_first_warning();
end

-- Function to trigger the first warning before the invasion.
function DisasterAztecInvasion.trigger_first_warning()
    out("Frodo45127: Disaster: " .. DisasterAztecInvasion.name .. " . Triggering first warning.");

    DisasterAztecInvasion.inner.first_warning_turn = cm:turn_number();
    DisasterAztecInvasion.inner.status = DISASTER_STATUS_FIRST_WARNING_EMITED;
    DisasterAztecInvasion.inner.started = true;

    cm:add_turn_countdown_event(DynamicDisastersManager.inner.faction_name, DisasterAztecInvasion.inner.turns_to_trigger_from_first_warning, "ScriptEventDisasterAztecInvasionSecondWarning");
end

-- Function to trigger the second warning before the invasion.
function DisasterAztecInvasion.trigger_second_warning()
    out("Frodo45127: Disaster: " .. DisasterAztecInvasion.name .. " . Triggering second warning.");

    DisasterAztecInvasion.inner.second_warning_turn = cm:turn_number();
    DisasterAztecInvasion.inner.status = DISASTER_STATUS_SECOND_WARNING_EMITED;

    cm:add_turn_countdown_event(DynamicDisastersManager.inner.faction_name, DisasterAztecInvasion.inner.turns_to_trigger_from_second_warning, "ScriptEventDisasterAztecInvasionAztecInvasion");
end

-- Function to trigger the invasion itself.
function DisasterAztecInvasion.trigger_aztec_invasion()
    out("Frodo45127: Disaster: " .. DisasterAztecInvasion.name .. " . Triggering invasion.");

    DisasterAztecInvasion.inner.invasion_start_turn = cm:turn_number();
    DisasterAztecInvasion.inner.status = DISASTER_STATUS_INVASION_STARTED;
end

-- Function to trigger cleanup stuff after the invasion is over.
function DisasterAztecInvasion.trigger_end_aztec_invasion()
    out("Frodo45127: Disaster: " .. DisasterAztecInvasion.name .. " . Triggering end invasion.");

    DisasterAztecInvasion.inner.started = false;
    DisasterAztecInvasion.inner.finished = true;
    DisasterAztecInvasion.inner.invasion_end_turn = cm:turn_number();
    DisasterAztecInvasion.inner.status = DISASTER_STATUS_INVASION_DESTROYED;

    DynamicDisastersManager.finish_disaster(DisasterAztecInvasion);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function DisasterAztecInvasion.check_disaster_conditions()

    return true;
end
