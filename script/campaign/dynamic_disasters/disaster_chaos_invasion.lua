--[[
    The End Times disaster, By Frodo45127.

    This disaster consists on a massive Chaos invasion to the whole world. This one is pretty complex, offering ample warning.

    -- Reference: https://warhammerfantasy.fandom.com/wiki/End_Times_Timeline#Appendix_1_-_Chronology_of_the_End_Times
    Ideas:
        - If this has started, the great ascendancy has more probabilities of starting.
        - Requires archaon to be non-vassalized (maybe alive too?).
        - Warning 8-12 turns before (reuse wh1/2 stuff?).
        - First wave:
            - Spawn many armies for Archaon and valkia.
            - Spawn armies of Kairos near bretonia (year of misfortune).
            - Force-vasallize any remaining norscan tribe by their closest chaos character. We need a chaos-tide.
            - Force all remaining chaos factions into war with ALL order/neutral factions.
        - Second wave (only if kislev is still alive):
            - Small global chaos corruptionincrease.
            - If chaos corruption goes above 75, spawn a rift on a province.
                - Said rift will spawn daemon armies each 10 turns + 1 an initial one.
            - Find Surtha Ek, attack kislev with him + multiple norscan armies from vasalized factions.
        - Second.5 wave (if vilich is usable);
            - If player is not cathayan, spawn a few armies to simulate vilich's attack to the great bastion.
            - If player is cathayan, increase a lot the bastion thread for the rest of the disaster.
        - Second.55 wave:
            - If Chaos captures all dark fortresses, you have a 50 countdown timer.
                - Put static reinforcements on ALL DARK FORTRESSES (1 ARMY OF EACH GOD?).
                - Take at least one back, or they'll open a great rift of Chaos and all will go to hell.
        - Third wave (only if NKari can be used):
            - Buff Nkari, give him armies and buff its corruption in the whole donut.
            - Message about the vortex dissapearing.
            - If player is the high elves, spawn a few armies near the gates, so they're used.
        - If chaos takes a certain amount of territories on Ulthuan:
            - Remove the vortex?
            - Trigger full chaos corruption accross the globe. Spawn more chaos armies.
            - Spawn daemonic armies at random provinces.
            - Spawn big daemonic armies north and south poles.
            - Give INCARNATION trait to certain characters?

        Stupid ideas and integrations:
            - If Miao Ying/Zharina are dead, vasalize them to Nkari/Azzazel.
            - If Naggarond is dead, vasalize them to Valkia.
            - If the high elves are dead, vasalize them to NKari.
            - If the empire is dead, vasalize it to Nurgle.
            - If grimgor is alive, trigger a separate disaster of him marching against Cathay.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_FULL_INVASION = 2;

-- Object representing the disaster.
disaster_example = {
    name = "example",

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
