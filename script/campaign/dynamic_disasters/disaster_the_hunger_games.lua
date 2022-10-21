--[[
    A Grudge Too Far, By CA. Extended by Frodo45127.

    Disaster ported from the endgames disasters. Dwarfs go full retard. Extended functionality and fixes added.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Dwarfen faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated dwarfen factions declare war on owner of attacked provinces and adjacent regions.
            - All major and minor non-confederated dwarfen factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
        - Finish:
            - A certain amount of dwarf regions controled, or all dwarf factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_the_hunger_games = {
    name = "the_hunger_games",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_dwf_dwarfs" },
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
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
        enabled = false,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).

        --Disaster-specific data.
        army_count_per_province = 4,
        unit_count = 19,
        early_warning_delay = 10,

        factions = {
            "wh2_dlc17_dwf_thorek_ironbrow",
            "wh_main_dwf_karak_izor",
            "wh_main_dwf_karak_kadrin",
            "wh3_main_dwf_the_ancestral_throng",
            "wh_main_dwf_dwarfs",
            "wh_main_dwf_kraka_drak",
            "wh_main_dwf_barak_varr",
            "wh_main_dwf_zhufbar",
            "wh3_main_dwf_karak_azorn",
            "wh_main_dwf_karak_norn",
            "wh_main_dwf_karak_hirn",
            "wh_main_dwf_karak_azul",
            "wh_main_dwf_karak_ziflin",

            -- Not in the vanilla disaster.
            "wh2_main_dwf_spine_of_sotek_dwarfs",
            "wh2_main_dwf_greybeards_prospectors",
            "wh2_dlc15_dwf_clan_helhein",
        },
        regions = {}
    },

    army_template = {
        dwarfs = "lategame"
    },

    early_warning_incident_key = "wh3_main_ie_incident_endgame_grudge_too_far_early_warning",
    early_warning_effects_key = "dyn_dis_grudge_too_far_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_grudge_too_far",
    endgame_mission_name = "we_ran_out_of_book",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_grudge_too_far",
    finish_early_incident_key = "dyn_dis_grudge_too_far_early_end",
    ai_personality = "wh3_combi_dwarf_endgame",
}

local potential_dwarfs = {
    wh2_dlc17_dwf_thorek_ironbrow = "wh3_main_combi_region_karak_zorn",
    wh_main_dwf_karak_izor = "wh3_main_combi_region_zarakzil",
    wh_main_dwf_karak_kadrin = "wh3_main_combi_region_karak_kadrin",
    wh3_main_dwf_the_ancestral_throng = "wh3_main_combi_region_drackla_spire",
    wh_main_dwf_dwarfs = "wh3_main_combi_region_karaz_a_karak",
    wh_main_dwf_kraka_drak = "wh3_main_combi_region_kraka_drak",
    wh_main_dwf_barak_varr = "wh3_main_combi_region_barak_varr",
    wh_main_dwf_zhufbar = "wh3_main_combi_region_zhufbar",
    wh3_main_dwf_karak_azorn = "wh3_main_combi_region_karak_azorn",
    wh_main_dwf_karak_norn = "wh3_main_combi_region_karak_norn",
    wh_main_dwf_karak_hirn = "wh3_main_combi_region_karak_hirn",
    wh_main_dwf_karak_azul = "wh3_main_combi_region_karak_azul",
    wh_main_dwf_karak_ziflin = "wh3_main_combi_region_karak_ziflin",

    -- Not in the vanilla disaster.
    wh2_main_dwf_spine_of_sotek_dwarfs = "wh3_main_combi_region_mine_of_the_bearded_skulls",
    wh2_main_dwf_greybeards_prospectors = "wh3_main_combi_region_vulture_mountain",
    wh2_dlc15_dwf_clan_helhein = "wh3_main_combi_region_ash_ridge_mountains",
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_the_hunger_games:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:add_listener(
            "GrudgeTooFarStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,

            function()

                -- Update the potential factions removing the confederated ones and check if we still have factions to use.
                self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
                if #self.settings.factions == 0 then
                    dynamic_disasters:execute_payload(self.finish_early_incident_key, nil, 0, nil);
                    self:trigger_end_disaster()
                else
                    self:trigger_second_great_beard_war();
                end
                core:remove_listener("GrudgeTooFarStart")
            end,
            true
        );
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function disaster_the_hunger_games:trigger()

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = cm:random_number(12, 8);
    end

    dynamic_disasters:execute_payload(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the disaster.
function disaster_the_hunger_games:trigger_second_great_beard_war()
    for _, faction_key in pairs(self.settings.factions) do
        local region_key = potential_dwarfs[faction_key];
        local invasion_faction = cm:get_faction(faction_key)

        local army_count = math.floor(self.settings.army_count_per_province * self.settings.difficulty_mod);
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.army_template, self.settings.unit_count, false, army_count, self.name, nil)

        -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
        endgame:no_peace_no_confederation_only_war(faction_key)

        -- In the case of Karak Izor, also spawn armies in Karak Eight Peaks if it controls it.
        if faction_key == "wh_main_dwf_karak_izor" then
            local karak_eight_peaks_region = cm:get_region("wh3_main_combi_region_karak_eight_peaks");
            if karak_eight_peaks_region:owning_faction():name() == faction_key then
                dynamic_disasters:create_scenario_force(faction_key, "wh3_main_combi_region_karak_eight_peaks", self.army_template, self.settings.unit_count, false, army_count, self.name, nil)
                dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { "wh3_main_combi_region_karak_eight_peaks" }, true, { "wh_main_sc_dwf_dwarfs" })
                table.insert(self.settings.regions, region_key);
            end
        end

        -- Give the invasion region to the invader if it isn't owned by them or a human, or by another dwarf.
        local region = cm:get_region(region_key)
        local region_owner = region:owning_faction()
        if region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false and region_owner:subculture() ~= "wh_main_sc_dwf_dwarfs") then
            cm:transfer_region_to_faction(region_key, faction_key)
        end

        -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
        cm:instantly_research_all_technologies(faction_key)
        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        dynamic_disasters:declare_war_for_owners_and_neightbours(invasion_faction, { region_key }, true, { "wh_main_sc_dwf_dwarfs" })

        cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
        table.insert(self.settings.regions, region_key);
    end

    -- Force an alliance between all dwarfen holds.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- If we got regions, prepare the victory mission/disaster end data.
    table.insert(self.objectives[2].conditions, "total " .. math.ceil(#self.settings.regions * 0.65))
    for i = 1, #self.settings.regions do
        table.insert(self.objectives[2].conditions, "region " .. self.settings.regions[i])
    end
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[1].conditions, "faction " .. self.settings.factions[i])
    end

    -- Reveal all regions subject to capture.
    dynamic_disasters:prepare_reveal_regions(self.settings.regions);

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.settings.regions[1], self.settings.factions[1], function () self:trigger_end_disaster() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_dwf_dwarfs")
    self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_the_hunger_games:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_the_hunger_games:check_start_disaster_conditions()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Check if any of the attackers if actually alive.
    local attackers_still_alive = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false then
            attackers_still_alive = true;
            break;
        end
    end

    -- Do not start if we don't have any alive attackers.
    if attackers_still_alive == false then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        return true;
    end

    -- If we're at max turn, trigger it without checking chances.
    if self.settings.max_turn > 0 and cm:turn_number() == self.settings.max_turn then
        return true;
    end

    local base_chance = 0.005;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
            base_chance = base_chance + 0.005;
        end
    end

    if cm:random_number(1, 0) < base_chance then
        return true;
    end

    return false;
end

return disaster_the_hunger_games
