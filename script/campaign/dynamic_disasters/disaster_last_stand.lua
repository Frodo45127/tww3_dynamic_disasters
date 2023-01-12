--[[
    Last StanD disaster, By Frodo45127.

    This disaster gives factions with only one province left armies near their capital from other factions.

    Supports debug mode. It never ends.

    Requirements:
    - At least turn 30.

    Effects:
    - Triggers the turn after a faction is left with 1 settlement.
    - Wait period of 10 turns between triggers (to not spam the event).
    - Spawnable armies:
        - Any faction:
            - 10% + difficulty_mod * 10 chance of spawning army of allied faction.
        - Master:
            - 10% + difficulty_mod * 10 chance of spawning army of a vassal.
            - 25% chance of said army attacking them, switching sides.
        - Vassals:
            - 10% + difficulty_mod * 10 chance of spawning army of master.
        - Norscan factions:
            - 10% + difficulty_mod * 10 chance of spawning army of daemons of random god.
        - Human order factions:
            - 10% + difficulty_mod * 10 chance of spawning army of mercenaries (mix of units from kislev, bretonia, the empire and cathay).
        - Skaven:
            - 10% + difficulty_mod * 10 chance of spawning army of skaven.
            - 50% chance of said army attacking them, switching sides.

]]

-- Status list for this disaster.
local STATUS_SETUP_AND_READY = 1;

-- Object representing the disaster.
last_stand = {
    name = "last_stand",

    -- Values for categorizing the disaster.
    is_global = true,                   -- If the disaster should be allowed to happen for all factions.
    allowed_for_sc = {},                -- Subcultures that will trigger the disaster. Unused if the disaster is global.
    denied_for_sc = {},                 -- Subcultures that will not trigger the disaster.
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
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        min_turn = 2,                      -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.

        -- Disaster-specific data.
        factions_last_stand_status = {},   -- Status of each faction's last stance situation, to track when each faction can still receive a last stance and when not.
        grace_period = 10,                  -- Grace period between last stance triggers for a faction.
        factions_to_spawn = {},             -- List of factions calling for reinforcements.
    },

    -- Army templates to use. We split them by subculture.
    army_templates = {
        wh2_dlc09_sc_tmb_tomb_kings = {
            tomb_kings = "",
        },
        wh2_dlc11_sc_cst_vampire_coast = {
            vampire_coast = "",
        },
        wh2_main_sc_def_dark_elves = {
            dark_elves = "",
        },
        wh2_main_sc_hef_high_elves = {
            high_elves = "",
        },
        wh2_main_sc_lzd_lizardmen = {
            lizardmen = "",
        },
        wh2_main_sc_skv_skaven = {
            skaven = "",
        },
        wh3_main_sc_cth_cathay = {
            cathay = "",
        },
        wh3_main_sc_dae_daemons = {
            daemons = "",
        },
        wh3_main_sc_kho_khorne = {
            khorne = "",
        },
        wh3_main_sc_ksl_kislev = {
            kislev = "",
        },
        wh3_main_sc_nur_nurgle = {
            nurgle = "",
        },
        wh3_main_sc_ogr_ogre_kingdoms = {
            ogre_kingdoms = "",
        },
        wh3_main_sc_sla_slaanesh = {
            slaanesh = "",
        },
        wh3_main_sc_tze_tzeentch = {
            tzeentch = "",
        },
        wh_dlc03_sc_bst_beastmen = {
            beastmen = "",
        },
        wh_dlc05_sc_wef_wood_elves = {
            wood_elves = "",
        },
        wh_dlc08_sc_nor_norsca = {
            norsca = "",
        },
        wh_main_sc_brt_bretonnia = {
            bretonnia = "",
        },
        wh_main_sc_chs_chaos = {
            chaos = "",
        },
        wh_main_sc_dwf_dwarfs = {
            dwarfs = "",
        },
        wh_main_sc_emp_empire = {
            empire = "",
        },
        wh_main_sc_grn_greenskins = {
            greenskins = "",
        },
        wh_main_sc_grn_savage_orcs = {
            savage_orcs = "",
        },

        -- This one is a mix of factions, as it's intended to represent mercenaries.
        wh_main_sc_teb_teb = {
            --teb = "",             -- These are empire, ignore them for now.
            --empire = "",
            --bretonnia = "",
            kislev = "",
            cathay = "",
        },

        wh_main_sc_vmp_vampire_counts = {
            vampire_counts = "",
        },
    },
    incident_key_allies = "dyn_dis_last_stand_allies",
    incident_key_master = "dyn_dis_last_stand_master",
    incident_key_vassal_normal = "dyn_dis_last_stand_vassal_normal",
    incident_key_vassal_betrayal = "dyn_dis_last_stand_vassal_betrayal",
    incident_key_chaos_gods = "dyn_dis_last_stand_chaos_gods",
    incident_key_mercenaries = "dyn_dis_last_stand_mercs",
    incident_key_skaven_betrayed = "dyn_dis_last_stand_skaven_betrayed",
    incident_key_skaven_normal = "dyn_dis_last_stand_skaven_normal",
    possible_skaven_betrayers = {

        -- Major factions
        "wh2_main_skv_clan_mors",           -- Clan Mors (Queek)
        "wh2_main_skv_clan_pestilens",      -- Clan Pestilens (Skrolk)
        "wh2_dlc09_skv_clan_rictus",        -- Clan Rictus (Tretch)
        "wh2_main_skv_clan_skryre",         -- Clan Skryre (Ikit Claw)
        "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
        "wh2_main_skv_clan_moulder",        -- Clan Moulder (Throt)

        -- Minor factions
        "wh3_main_skv_clan_carrion",        -- Clan Carrion
        "wh2_dlc12_skv_clan_fester",        -- Clan Fester
        "wh2_dlc15_skv_clan_ferrik",        -- Clan Ferrik
        "wh2_main_skv_grey_seer_clan",      -- Clan Grey Seer (what's this)
        "wh2_dlc16_skv_clan_gritus",        -- Clan Gritus
        "wh3_main_skv_clan_gritus",         -- Clan Gritus (again? From another campaign?)
        "wh2_dlc15_skv_clan_kreepus",       -- Clan Kreepus
        "wh3_main_skv_clan_krizzor",        -- Clan Krizzor
        "wh2_dlc12_skv_clan_mange",         -- Clan Mange
        "wh3_main_skv_clan_morbidus",       -- Clan Morbidus
        "wh2_main_skv_clan_septik",         -- Clan Septik
        "wh3_main_skv_clan_skrat",          -- Clan Skrat
        "wh2_main_skv_clan_spittel",        -- Clan Spittel
        "wh3_main_skv_clan_treecherik",     -- Clan Treecherik
        "wh2_dlc15_skv_clan_volkn",         -- Clan Volkn
        "wh3_main_skv_clan_verms",          -- Clan Verms
    },
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function last_stand:set_status(status)
    self.settings.status = status;

    -- Listener that need to be initialized after the disaster is triggered.
    if self.settings.status == STATUS_SETUP_AND_READY then

        -- Listener to query the state of a faction previous to a battle.
        core:remove_listener("LastStandPreBattleWatcher");
        core:add_listener(
            "LastStandPreBattleWatcher",
            "PendingBattle",
            function()
                return self.settings.started and not cm:get_saved_value("LastStandPreBattleData")
            end,
            function()
                local _, _, faction_name = cm:pending_battle_cache_get_defender(1);
                local faction = cm:get_faction(faction_name);
                if not faction == false and faction:is_null_interface() == false then
                    local region_count = faction:region_list():num_items();
                    cm:set_saved_value("LastStandPreBattleData", {faction:name(), region_count});

                    out("Frodo45127: Faction " .. faction:name() .. " pre-battle with " .. region_count .. " regions.")
                end
            end,
            true
        );

        -- Listener to query the state of a faction after a battle.
        core:remove_listener("LastStandPostBattleWatcher");
        core:add_listener(
            "LastStandPostBattleWatcher",
            "BattleCompleted",
            function()
                return self.settings.started and cm:get_saved_value("LastStandPreBattleData");
            end,
            function()
                local pre_battle_data = cm:get_saved_value("LastStandPreBattleData");

                -- If the defender lost and has gone from 2 settlements to 1, set him up for reinforcements.
                local faction_name = pre_battle_data[1];
                local pre_region_count = pre_battle_data[2];

                local faction = cm:get_faction(faction_name);
                if not faction == false and faction:is_null_interface() == false then
                    local post_region_count = faction:region_list():num_items();
                    out("Frodo45127: Faction " .. faction:name() .. " post-battle with " .. post_region_count .. " regions.")

                    if pre_region_count > 1 and post_region_count == 1 then
                        self.settings.factions_to_spawn[faction:name()] = true;
                    end
                end

                cm:set_saved_value("LastStandPreBattleData", false);
            end,
            true
        );

        -- Listener to check if the character ran away and cleanup accordingly.
        core:remove_listener("LastStandCleanupAfterRetreat");
        core:add_listener(
            "LastStandCleanupAfterRetreat",
            "CharacterWithdrewFromBattle",
            function()
                return cm:get_saved_value("LastStandPreBattleData");
            end,
            function()
                cm:set_saved_value("LastStandPreBattleData", false);
            end,
            true
        );

        -- Listener to spawn armies that should be spawned in the current turn.
        core:remove_listener("LastStandSpawner");
        core:add_listener(
            "LastStandSpawner",
            "FactionTurnStart",
            function(context)
                return self.settings.started and self.settings.factions_to_spawn[context:faction():name()] == true
            end,
            function(context)
                local faction = context:faction();
                self:rohan_arrives(faction);
                self.settings.factions_to_spawn[context:faction():name()] = nil;
            end,
            true
        );
    end
end

-- Function to trigger the disaster setup.
function last_stand:trigger()
    out("Frodo45127: Initializing Last Stance disaster.")
    self:set_status(STATUS_SETUP_AND_READY);
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function last_stand:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function last_stand:check_start_disaster_conditions()
    return true;
end

-- Function to check if a faction can receive reinforcements, and spawn the reinforcement armies.
--
---@param faction FACTION_SCRIPT_INTERFACE #Faction to check if it needs reinforcements.
function last_stand:rohan_arrives(faction)

    --and not faction:name() == "rebels"
    if not faction == false and faction:is_null_interface() == false and not faction:is_dead() == true then
        local region_count = faction:region_list():num_items();

        out("Frodo45127: Region count for faction " .. faction:name() .. ": " .. tostring(region_count) .. ".")
        if region_count == 1 then

            -- Check if we're not in the grace period from a previous last stance.
            local faction_status = self.settings.factions_last_stand_status[faction:name()];
            out("Frodo45127: Status for faction " .. faction:name() .. ": " .. tostring(faction_status) .. ".")
            if faction_status == nil or (not faction_status == nil and faction_status >= cm:turn_number()) then

                out("Frodo45127: Faction " .. faction:name() .. " is in last stance and out of grace period. Trying to call for reinforcements.")

                -- Test case. Only for debug mode.
                local region = faction:home_region();
                if dynamic_disasters.settings.debug_2 == true then
                    local army_template = self:choose_army_template(faction, nil);
                    local army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);
                    out("Frodo45127: Faction " .. faction:name() .. " receives debug army as reinforcements.")

                    if army_spawned == true then
                        dynamic_disasters:trigger_incident(self.incident_key_allies, nil, nil, region:name(), faction:name());
                    end
                end

                -- Common check: allied armies.
                local army_spawned = false;
                local allies = faction:factions_military_allies_with();
                for j = 0, allies:num_items() - 1 do
                    local ally = allies:item_at(j);
                    local chance = cm:random_number(100, 0);
                    if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then
                        local army_template = self:choose_army_template(ally, nil);
                        local spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);
                        if army_spawned == false then
                            army_spawned = spawned;
                        end
                        out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from ally " .. ally:name() .. ".")
                    end
                end

                if army_spawned == true then
                    dynamic_disasters:trigger_incident(self.incident_key_allies, nil, nil, region:name(), faction:name());
                end

                -- Common check: master armies to reinforce a vassal.
                --
                -- Same as the allied check, but for vassals.
                local army_spawned = false;
                if faction:is_vassal() then
                    local chance = cm:random_number(100, 0);
                    if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then
                        local master = faction:master();
                        local army_template = self:choose_army_template(master, nil);
                        army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);
                        out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from master " .. master:name() .. ".")

                        if army_spawned == true then
                            dynamic_disasters:trigger_incident(self.incident_key_master, nil, nil, region:name(), faction:name());
                        end
                    end
                end

                -- Common check: vassal armies to reinforce their master.
                --
                -- Vassals come to their master's aid. Small chance they come to backstab him.
                local army_spawned = false;
                local vassals = faction:vassals()
                if not vassals:is_empty() then
                    for j = 0, vassals:num_items() - 1 do
                        local chance = cm:random_number(100, 0);
                        if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then
                            local vassal = vassals:item_at(j)
                            local army_template = self:choose_army_template(vassal, nil);
                            local chance_betray = cm:random_number(100, 0);

                            out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from vassal " .. vassal:name() .. ".")
                            if chance_betray < 25 then
                                army_spawned = dynamic_disasters:create_scenario_force(vassal:name(), region:name(), army_template, 20, true, 1, self.name, rohan_army_callback);
                                out("Frodo45127: Faction " .. faction:name() .. " gets backstabbed by the reinforcement army from the vassal " .. vassal:name() .. ".")

                                if army_spawned == true then
                                    dynamic_disasters:trigger_incident(self.incident_key_vassal_betrayal, nil, nil, region:name(), faction:name());
                                end
                            else
                                army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);

                                if army_spawned == true then
                                    dynamic_disasters:trigger_incident(self.incident_key_vassal_normal, nil, nil, region:name(), faction:name());
                                end
                            end
                        end
                    end
                end

                -- Faction specific check: chaos undivided and norsca.
                --
                -- They may receive a random army from a daemonic faction.
                local army_spawned = false;
                if faction:subculture() == "wh_dlc08_sc_nor_norsca" or faction:subculture() == "wh_main_sc_chs_chaos" then
                    local chance = cm:random_number(100, 0);
                    if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then
                        local army_template = self:choose_army_template(faction, {
                            "wh3_main_sc_kho_khorne",
                            "wh3_main_sc_nur_nurgle",
                            "wh3_main_sc_sla_slaanesh",
                            "wh3_main_sc_tze_tzeentch",
                        });
                        army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);
                        out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from chaos gods.")

                        if army_spawned == true then
                            dynamic_disasters:trigger_incident(self.incident_key_chaos_gods, nil, nil, region:name(), faction:name());
                        end
                    end
                end

                -- Faction specific check: cathay, empire, bretonia, kislev.
                --
                -- They may receive a random army from a passing mercenary group or a cathayan caravan (we use TEB subculture with mixed units for this).
                local army_spawned = false;
                if faction:subculture() == "wh3_main_sc_cth_cathay" or
                    faction:subculture() == "wh3_main_sc_ksl_kislev" or
                    faction:subculture() == "wh_main_sc_brt_bretonnia" or
                    faction:subculture() == "wh_main_sc_emp_empire" then
                    local chance = cm:random_number(100, 0);
                    if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then
                        local army_template = self:choose_army_template(faction, { "wh_main_sc_teb_teb" });
                        army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);
                        out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from mercenaries passing by.")

                        if army_spawned == true then
                            dynamic_disasters:trigger_incident(self.incident_key_mercenaries, nil, nil, region:name(), faction:name());
                        end
                    end
                end

                -- Faction specific check: skaven.
                --
                -- The fun ones. They may receive a random army from another skaven faction, which has 50% chance of betraying them.
                local army_spawned = false;
                if faction:subculture() == "wh2_main_sc_skv_skaven" then
                    local chance = cm:random_number(100, 0);
                    if (chance < 10 + self.settings.difficulty_mod * 10) or dynamic_disasters.settings.debug_2 == true then

                        -- Betrayer stuff. We need another skaven faction which is still alive.
                        local possible_skaven_betrayers = cm:random_sort_copy(self.possible_skaven_betrayers);
                        local possible_skaven_betrayers_alive = {};

                        for _, betrayer_key in pairs(possible_skaven_betrayers) do
                            local betrayer = cm:get_faction(betrayer_key);
                            if not betrayer == false and betrayer:is_null_interface() == false and betrayer_key ~= faction:name() then
                                table.insert(possible_skaven_betrayers_alive, betrayer_key);
                            end
                        end

                        local chance_betray = cm:random_number(100, 0);
                        local betrayer_faction_key = possible_skaven_betrayers_alive[cm:random_number(#possible_skaven_betrayers_alive)]
                        local army_template = self:choose_army_template(cm:get_faction(betrayer_faction_key), nil);
                        out("Frodo45127: Faction " .. faction:name() .. " receives reinforcement army from the underempire.")

                        if #possible_skaven_betrayers_alive > 0 and chance_betray < 50 then
                            army_spawned = dynamic_disasters:create_scenario_force(betrayer_faction_key, region:name(), army_template, 20, true, 1, self.name, rohan_army_callback);
                            out("Frodo45127: Faction " .. faction:name() .. " gets backstabbed by the reinforcement army from the underempire.")

                            if army_spawned == true then
                                dynamic_disasters:trigger_incident(self.incident_key_skaven_betrayed, nil, nil, region:name(), faction:name());
                            end
                        else
                            army_spawned = dynamic_disasters:create_scenario_force(faction:name(), region:name(), army_template, 20, false, 1, self.name, rohan_army_callback);

                            if army_spawned == true then
                                dynamic_disasters:trigger_incident(self.incident_key_skaven_normal, nil, nil, region:name(), faction:name());
                            end
                        end
                    end
                end

                -- Set/Update the faction status.
                self.settings.factions_last_stand_status[faction:name()] = cm:turn_number() + self.settings.grace_period;
            end
        end
    end
end

-- Function to get an army template based on status on the campaign, and faction to pull the template from.
--
---@param faction FACTION_SCRIPT_INTERFACE #Faction to check if it needs reinforcements.
---@param subcultures table #Optional. List of subcultures to choose a random template from instead of from the faction provided.
---@return table #Army template.
function last_stand:choose_army_template(faction, subcultures)
    local template_key = "earlygame";
    local current_turn = cm:turn_number();
    if current_turn >= 50 and current_turn < 100 then
        template_key = "midgame";
    elseif current_turn >= 100 then
        template_key = "lategame";
    end

    -- TODO: Take into account faction_specific armies, and populate all subcultures with the three army templates.
    local subculture = faction:subculture();
    if not subcultures == nil and not table.is_empty(subcultures) then
        subculture = subcultures[cm:random_number(#subcultures, 1)];
    end

    local template = table.copy(self.army_templates[subculture]);
    for key, value in pairs(template) do
        template[key] = template_key;
    end

    return template;
end

-- Callback function to pass to a create_force function. Main difference with the default callback is that it limits the free unkeep duration, so the army ends up working as a normal army, and the AI may disband it.
---@param cqi integer #CQI of the army.
function rohan_army_callback(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 5)
    cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
    cm:add_agent_experience(character, cm:random_number(25, 15), true)
    cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
end

-- Return the disaster so the manager can read it.
return last_stand
