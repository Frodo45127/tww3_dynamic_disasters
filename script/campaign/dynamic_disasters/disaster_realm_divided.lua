--[[
    Realm Divided disaster, By Frodo45127.

    This disaster consists on a massive rebelion on Cathay. It can take multiple routes:
        - For northern provinces:
            - If Zhao Ming is still alive, you'll get a dilemma asking to side with him, with the Caravan Lords or with Wei-Jin.
                - If you go with Zhao Ming, you get an alliance with him to take down the Caravan Lords and Wei-Jin, with a confederation possibility at the end.
                - If you go with the Caravan Lords, you get an alliance with them to take down the Zhao Ming and Wei-Jin (with buffs to caravans?).
                - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Zhao Ming and the Caravan Lords, and increased bonus from the compass.
        - For southern provinces:
            - if Miao Ying is still alive, you'll get a dilemma asking to side with her, with the Caravan Lords or with Wei-Jin.
                - If you go with Miao Ying, you get an alliance with him to take down the Caravan Lords and Wei-Jin, with a confederation possibility at the end.
                - If you go with the Caravan Lords, you get an alliance with them to take down the Miao Ying and Wei-Jin (with buffs to caravans?).
                - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Miao Ying and the Caravan Lords, and increased bonus from the compass.
        - Civil war will broke out.
        - Ends when the player anahilates all other non-allied cathayan factions.

    Conditions to trigger:
        - Player must be a Cathayan faction.
        - Player must control at least half of Cathay.
        - After turn 30.
        - Random chance (10%) per turn.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_FULL_INVASION = 2;

-- Object representing the disaster.
disaster_example = {
    name = "realm_divided",

    -- Values for categorizing the disaster.
    is_global = false;
    allowed_for_sc = { "wh3_main_sc_cth_cathay" },
    denied_for_sc = {},

    -- Settings of the disaster that will be stored in a save.
    settings = {

        -- Common data for all disasters.
        enabled = false,                    -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = true,                  -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        min_turn = 30,                      -- Minimum turn required for the disaster to trigger.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 5,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },
    }
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_example:set_status(status)
    self.settings.status = status;

    -- Listener that need to be initialized after the disaster is triggered.
    if self.settings.status == STATUS_TRIGGERED then

    end

    -- Listener that need to be initialized after the status changes.
    if self.settings.status == STATUS_FULL_INVASION then
    end
end

-- Function to trigger the disaster. From here until the end of the disaster, everything is managed by the disaster itself.
function disaster_example:trigger()

    -- Initialize listeners.
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function disaster_example:trigger_end_disaster()
    dynamic_disasters:finish_disaster(self);
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function disaster_example:check_start_disaster_conditions()

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    return true;
end

-- Return the disaster so the manager can read it.
return disaster_example
