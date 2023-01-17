--[[
    Example disaster.

    This file contains the minimum code you need to create a new disaster.

    The file name must always be "disaster_yourdisastername.lua". For more advanced examples, check the other disasters.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_FULL_INVASION = 2;

-- Object representing the disaster.
disaster_example = {
    name = "example",

    -- Values for categorizing the disaster.
    is_global = false,                  -- If the disaster should be allowed to happen for all factions.
    allowed_for_sc = {},                -- Subcultures that will trigger the disaster. Unused if the disaster is global.
    denied_for_sc = {},                 -- Subcultures that will not trigger the disaster.
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {

        -- Common data for all disasters.
        enabled = false,                    -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        min_turn = 60,                      -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {}                   -- Extra settings this disaster may pull from MCT.
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
function disaster_example:start()

    -- Initialize listeners.
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function disaster_example:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function disaster_example:check_start()
    return true;
end

-- Return the disaster so the manager can read it.
return disaster_example
