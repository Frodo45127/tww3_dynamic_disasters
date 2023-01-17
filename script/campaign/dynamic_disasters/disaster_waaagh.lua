--[[
    Da Biggest Waaagh, By CA.

    Disaster ported from the endgames disasters. Greenskins go full retard. Extended functionality and fixes added.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Greenskin faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/Early Warning:
            - "The end is nigh" message
        - Invasion:
            - All major and minor non-confederated Greenskin factions declare war on every non Greenskin faction.
            - All major and minor non-confederated Greenskin factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Every ceil(10 / (difficulty_mod + 1)) turns spawn an extra army in each magical forest controlled by Greenskins.
        - Finish:
            - All Greenskin factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

disaster_waaagh = {
	name = "waaagh",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh_main_sc_grn_greenskins", "wh_main_sc_grn_savage_orcs" },
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
        }
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {
        enabled = true,                     -- If the disaster is enabled or not.
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

        army_count_per_province = 4,
        unit_count = 19,
        early_warning_delay = 10,

        factions = {

            "wh_main_grn_greenskins",                       -- Grimgor Ironhide
            "wh_main_grn_orcs_of_the_bloody_hand",          -- Wurrzag, The Greath Prophet
            "wh2_dlc15_grn_broken_axe",                     -- Grom, The Paunch
            "wh2_dlc15_grn_bonerattlaz",                    -- Azhag, The Butcher
            "wh_main_grn_crooked_moon",                     -- Skarsnik

            "wh_main_grn_top_knotz",
            "wh_main_grn_teef_snatchaz",
            "wh_main_grn_skullsmasherz",
            "wh_main_grn_skull-takerz",
            "wh_main_grn_scabby_eye",
            "wh_main_grn_red_fangs",
            "wh_main_grn_red_eye",
            "wh_main_grn_necksnappers",
            "wh_main_grn_broken_nose",
            "wh_main_grn_bloody_spearz",
            "wh_main_grn_black_venom",
            "wh_dlc03_grn_black_pit",
            "wh3_main_grn_tusked_sunz",
            "wh3_main_grn_slaves_of_zharr",
            "wh3_main_grn_moon_howlerz",
            --"wh3_main_grn_drippin_fangs", -- Not in the starting map.
            "wh3_main_grn_dimned_sun",
            "wh3_main_grn_dark_land_orcs",
            "wh3_main_grn_da_cage_breakaz",
            "wh2_main_grn_blue_vipers",
            "wh2_main_grn_arachnos",
            "wh2_dlc16_grn_naggaroth_orcs",
            "wh2_dlc16_grn_creeping_death",
            "wh2_dlc15_grn_skull_crag",
            "wh2_dlc14_grn_red_cloud",
            "wh2_dlc12_grn_leaf_cutterz_tribe",
        },

        regions = {},
	},

    army_templates = {

        -- Major
        wh_main_grn_greenskins = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_orcs_of_the_bloody_hand = {
            savage_orcs = "lategame",
        },
        wh2_dlc15_grn_broken_axe = {
            greenskins = "lategame_goblins",
        },
        wh2_dlc15_grn_bonerattlaz = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_crooked_moon = {
            greenskins = "lategame_goblins",
        },

        -- Minor
        wh_main_grn_top_knotz = {
            savage_orcs = "lategame",
        },
        wh_main_grn_teef_snatchaz = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_skullsmasherz = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_skull_takerz = {
            savage_orcs = "lategame",
        },
        wh_main_grn_scabby_eye = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_red_fangs = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_red_eye = {
            greenskins = "lategame_goblins",
        },
        wh_main_grn_necksnappers = {
            greenskins = "lategame_goblins",
        },
        wh_main_grn_broken_nose = {
            greenskins = "lategame_orcs",
        },
        wh_main_grn_bloody_spearz = {
            greenskins = "lategame_goblins",
        },
        wh_main_grn_black_venom = {
            greenskins = "lategame_goblins",
        },
        wh_dlc03_grn_black_pit = {
            greenskins = "lategame_orcs",
        },
        wh3_main_grn_tusked_sunz = {
            greenskins = "lategame_orcs",
        },
        wh3_main_grn_slaves_of_zharr = {
            greenskins = "lategame_orcs",
        },
        wh3_main_grn_moon_howlerz = {
            greenskins = "lategame_goblins",
        },
        --"wh3_main_grn_drippin_fangs", -- Not in the starting map.
        wh3_main_grn_dimned_sun = {
            savage_orcs = "lategame",
        },
        wh3_main_grn_dark_land_orcs = {
            greenskins = "lategame_orcs",
        },
        wh3_main_grn_da_cage_breakaz = {
            greenskins = "lategame_orcs",
        },
        wh2_main_grn_blue_vipers = {
            savage_orcs = "lategame",
        },
        wh2_main_grn_arachnos = {
            greenskins = "lategame_goblins",
        },
        wh2_dlc16_grn_naggaroth_orcs = {
            greenskins = "lategame_orcs",
        },
        wh2_dlc16_grn_creeping_death = {
            greenskins = "lategame_goblins",
        },
        wh2_dlc15_grn_skull_crag = {
            greenskins = "lategame_orcs",
        },
        wh2_dlc14_grn_red_cloud = {
            greenskins = "lategame_orcs",
        },
        wh2_dlc12_grn_leaf_cutterz_tribe = {
            greenskins = "lategame_orcs",
        },
    },

    factions_base_regions = {
        wh_main_grn_greenskins = "wh3_main_combi_region_sabre_mountain",
        wh_main_grn_orcs_of_the_bloody_hand = "wh3_main_combi_region_ekrund",
        wh2_dlc15_grn_broken_axe = "wh3_main_combi_region_massif_orcal",
        wh2_dlc15_grn_bonerattlaz = "wh3_main_combi_region_khazid_irkulaz",
        wh_main_grn_crooked_moon = "wh3_main_combi_region_mount_gunbad",

        -- Non-playable.
        wh_main_grn_top_knotz = "wh3_main_combi_region_galbaraz",
        wh_main_grn_teef_snatchaz = "wh3_main_combi_region_dragonhorn_mines",
        wh_main_grn_skullsmasherz = "wh3_main_combi_region_grung_zint",
        wh_main_grn_skull_takerz = "wh3_main_combi_region_fort_soll", -- These ones are the turn 1 attackers for Gelt.
        wh_main_grn_scabby_eye = "wh3_main_combi_region_barag_dawazbag",
        wh_main_grn_red_fangs = "wh3_main_combi_region_karak_azgal",
        wh_main_grn_red_eye = "wh3_main_combi_region_grom_peak",
        wh_main_grn_necksnappers = "wh3_main_combi_region_karak_eight_peaks",
        wh_main_grn_broken_nose = "wh3_main_combi_region_karak_izor",
        wh_main_grn_bloody_spearz = "wh3_main_combi_region_the_high_place",
        wh_main_grn_black_venom = "wh3_main_combi_region_steingart",
        wh_dlc03_grn_black_pit = "wh3_main_combi_region_the_black_pit",
        wh3_main_grn_tusked_sunz = "wh3_main_combi_region_blizzardpeak",
        wh3_main_grn_slaves_of_zharr = "wh3_main_combi_region_uzkulak",
        wh3_main_grn_moon_howlerz = "wh3_main_combi_region_darkhold",
        --wh3_main_grn_drippin_fangs = "wh3_main_combi_region_darkhold", -- Not in the starting map.
        wh3_main_grn_dimned_sun = "wh3_main_combi_region_kunlan",
        wh3_main_grn_dark_land_orcs = "wh3_main_combi_region_zharr_naggrund",
        wh3_main_grn_da_cage_breakaz = "wh3_main_combi_region_nagrar",
        wh2_main_grn_blue_vipers = "wh3_main_combi_region_pahuax",
        wh2_main_grn_arachnos = "wh3_main_combi_region_mount_arachnos",
        wh2_dlc16_grn_naggaroth_orcs = "wh3_main_combi_region_rothkar_spire",
        wh2_dlc16_grn_creeping_death = "wh3_main_combi_region_forest_of_gloom",
        wh2_dlc15_grn_skull_crag = "wh3_main_combi_region_shrine_of_loec",
        wh2_dlc14_grn_red_cloud = "wh3_main_combi_region_brionne",
        wh2_dlc12_grn_leaf_cutterz_tribe = "wh3_main_combi_region_cuexotl",
    },

    early_warning_incident_key = "wh3_main_ie_incident_endgame_waaagh_early_warning",
    early_warning_effects_key = "dyn_dis_waaagh_early_warning",
    invasion_incident_key = "wh3_main_ie_incident_endgame_waaagh",
    endgame_mission_name = "da_biggest_and_badest_waaagh",
    invader_buffs_effects_key = "wh3_main_ie_scripted_endgame_waaagh",
    finish_early_incident_key = "dyn_dis_waaagh_early_end",
	ai_personality = "wh3_combi_greenskin_endgame",
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_waaagh:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the disaster.
        core:remove_listener("WaaaghStart")
        core:add_listener(
            "WaaaghStart",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.early_warning_delay
            end,
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_early_incident_key, nil, 0, nil, nil, nil);
                    self:finish()
                else
                    self:trigger_da_biggest_waaagh();
                end
                core:remove_listener("WaaaghStart")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each faction capital.
        core:remove_listener("WaaaghRespawn")
        core:add_listener(
            "WaaaghRespawn",
            "WorldStartRound",
            function()
                return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and
                    dynamic_disasters:is_any_faction_alive_from_list_with_home_region(self.settings.factions);
            end,
            function()
                for _, faction_key in pairs(self.settings.factions) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and faction:subculture() == self.subculture and faction:has_home_region() then
                        local region = faction:home_region();
                        dynamic_disasters:create_scenario_force(faction:name(), region:name(), self.army_template, self.unit_count, false, 1, self.name, nil)
                    end
                end
            end,
            true
        )
    end

    -- Once we triggered the disaster, ending it is controlled by two missions, so we don't need to listen for an ending.
end

-- Function to trigger the early warning before the disaster.
function disaster_waaagh:start()

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.early_warning_delay = 1;
    else
        self.settings.early_warning_delay = cm:random_number(12, 8);
    end

    dynamic_disasters:trigger_incident(self.early_warning_incident_key, self.early_warning_effects_key, self.settings.early_warning_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);

end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_waaagh:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        core:remove_listener("WaaaghRespawn")
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_waaagh:check_start()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Do not start if we don't have any alive attackers.
    if not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions) then
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

    if cm:random_number(100, 0) / 100 < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_waaagh:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return (#self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions));
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the disaster.
function disaster_waaagh:trigger_da_biggest_waaagh()
    for _, faction_key in pairs(self.settings.factions) do

        -- Seriously????
        local faction_key_fixed = faction_key;
        if faction_key == "wh_main_grn_skull-takerz" then
            faction_key_fixed = "wh_main_grn_skull_takerz";
        end

        local faction = cm:get_faction(faction_key)
        if not faction:is_dead() or (faction:is_dead() and self.settings.revive_dead_factions == true) then
            local region_key = self.factions_base_regions[faction_key_fixed];
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);
            local army_template = self.army_templates[faction_key_fixed];

            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, army_template, self.unit_count, false, army_count, self.name, nil, self.settings.factions) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_no_confederation_only_war(faction_key, self.settings.enable_diplomacy)

                -- Give the invasion region to the invader if it isn't owned by them or a human
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region:is_abandoned() or region_owner == false or region_owner:is_null_interface() or (
                        region_owner:name() ~= faction_key and
                        region_owner:is_human() == false and
                        region_owner:subculture() ~= "wh_main_sc_grn_greenskins" and
                        region_owner:subculture() ~= "wh_main_sc_grn_savage_orcs") then
                        cm:transfer_region_to_faction(region_key, faction_key)
                    end
                end

                cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
                cm:instantly_research_all_technologies(faction_key)
                dynamic_disasters:declare_war_to_all(faction, { self.subculture }, true);

                cm:apply_effect_bundle(self.invader_buffs_effects_key, faction_key, 0)
                table.insert(self.settings.regions, region_key);
            end
        end
    end

    -- Force an alliance between all Greenskin hordes.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Prepare the victory mission/disaster end data.
    for i = 1, #self.settings.factions do
        table.insert(self.objectives[1].conditions, "faction " .. self.settings.factions[i])
    end

    -- Trigger either the victory mission, or just the related incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.invasion_incident_key, self.settings.regions[1], self.settings.factions[1], function () self:finish() end, false)
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_grn_greenskins")
    self:set_status(STATUS_STARTED);
end

return disaster_waaagh
