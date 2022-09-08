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
            - Give the player (and every faction) a choice to swap sides and become part of the chaos tide, as a vassal of one of the chaos gods.
                - As an incentive, you may be able to recruit chaos armies and maybe get access to warband?
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;
local STATUS_STAGE_3 = 4;

-- Object representing the disaster.
disaster_chaos_invasion = {
    name = "chaos_invasion",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = {},

    -- Settings of the disaster that will be stored in a save.
    settings = {

        -- Common data for all disasters.
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        -- Disaster-specific data.
        base_army_unit_count = 19,
        stage_1_delay = 1,
        stage_2_delay = 1,
        stage_3_delay = 1,

        army_template = nil,
    },

    stage_1_date = {
        army_template = {
            chaos = "lategame",
            tzeentch = "lategame",
        },
    },

    stage_1_warning_event_key = "fro_dyn_dis_chaos_invasion_stage_1_warning",
    stage_1_event_key = "fro_dyn_dis_chaos_invasion_stage_1_trigger",
    stage_2_event_key = "fro_dyn_dis_chaos_invasion_stage_2_trigger",
    stage_3_event_key = "fro_dyn_dis_chaos_invasion_stage_3_trigger",
    finish_before_stage_1_event_key = "fro_dyn_dis_chaos_invasion_finish_before_stage_1",
    finish_event_key = "fro_dyn_dis_chaos_invasion_finish",
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_chaos_invasion:set_status(status)
    self.settings.status = status;

    -- Listener that need to be initialized after the disaster is triggered.
    if self.settings.status == STATUS_TRIGGERED then

        -- This triggers stage one of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage1",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_before_stage_1_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_1();
                end
                core:remove_listener("ChaosInvasionStage1")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_1 then

        -- This triggers stage two of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage2",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("ChaosInvasionStage2")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_2 then

        -- This triggers stage three of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage3",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_3();
                end
                core:remove_listener("ChaosInvasionStage3")
            end,
            true
        );
    end
end

-- Function to trigger the disaster. From here until the end of the disaster, everything is managed by the disaster itself.
function disaster_chaos_invasion:trigger()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering first warning.");

    if dynamic_disasters.settings.debug == false then
        self.settings.stage_1_delay = math.random(8, 12);
    else
        self.settings.stage_1_delay = 1;
    end

    -- Initialize listeners.
    dynamic_disasters:execute_payload(self.stage_1_warning_event_key, nil, 0, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_1()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    if dynamic_disasters.settings.debug == false then
        self.settings.stage_2_delay = math.random(6, 10);
    else
        self.settings.stage_2_delay = 1;
    end

    local human_factions = cm:get_human_factions();
    for i = 1, #human_factions do
        cm:show_message_event_located(
            human_factions[i],
            "event_feed_strings_text_wh_event_feed_string_scripted_event_chaos_invasion_mid_primary_detail",
            "",
            "event_feed_strings_text_wh_event_feed_string_scripted_event_chaos_invasion_mid_secondary_detail",
            100,
            100,
            true, 30
        );
        --out.chaos("Showing Chaos Event : "..human_factions[i]);
        --cm:make_region_visible_in_shroud(human_factions[i], "wh_main_chaos_wastes");
    end

    cm:register_instant_movie("Warhammer/chs_rises");

    -- Advance status to stage 1.
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_2()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    if dynamic_disasters.settings.debug == false then
        self.settings.stage_3_delay = math.random(6, 10);
    else
        self.settings.stage_3_delay = 1;
    end

    local human_factions = cm:get_human_factions();
    for i = 1, #human_factions do
        cm:show_message_event_located(
            human_factions[i],
            "event_feed_strings_text_wh_event_feed_string_scripted_event_chaos_invasion_end_primary_detail",
            "",
            "event_feed_strings_text_wh_event_feed_string_scripted_event_chaos_invasion_end_secondary_detail",
            100,
            100,
            true, 31
        );
        --out.chaos("Showing Chaos Event : "..human_factions[i]);
        --cm:make_region_visible_in_shroud(human_factions[i], "wh_main_chaos_wastes");
    end
    cm:register_instant_movie("Warhammer/chs_invasion");

    -- Advance status to stage 2.
    self:set_status(STATUS_STAGE_2);
end

-- Function to trigger the third stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_3()


    -- Advance status to stage 3.
    self:set_status(STATUS_STAGE_3);
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function disaster_chaos_invasion:trigger_end_disaster()
    dynamic_disasters:finish_disaster(self);
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function disaster_chaos_invasion:check_start_disaster_conditions()

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    return true;
end


--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_chaos_invasion:check_end_disaster_conditions()
    return false;
end

-- Return the disaster so the manager can read it.
return disaster_chaos_invasion
