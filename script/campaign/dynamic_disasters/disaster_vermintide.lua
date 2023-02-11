--[[
    
    Vermintide, By Frodo45127, with changes imported from CA's Vermintide.

    Disaster resulting from the merge of my old Great Ascendancy, and the vanilla Vermintide. Nothing happens.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.25% (1/400 turns).
        - +0.25% for each Skaven faction that has been wiped out (not confederated).
        - If the chaos invasion disaster has been triggered, chance of this disaster triggering increases by 10%.
        - At least turn 130 (so the player has already "prepared").
        - Clan Skryre must be not confederated (it's the one it starts the invasion).
    Effects:
        - For the entire disaster since the stage 1:
            - Ikit will get cores and nukes each turn.
            - Skavens will keep expanding the underempire constantly.
            - Skaven underempire expansion is fast at the start, but slow once they start re-occupying previous undercities.
            - Skaven underempire expansion will transfer to them abandoned settlements, except if one of the players is a destruction-focused faction.
            - Each turn, a few of the undercities will max out, wrecking havoc around the world.
        - Trigger/Early Warning:
            - Message about Morrslieb increasing in size.
            - Wait 6-10 turns for more info.
            - After 2-4 turns (only for empire, dwarfs and wood elves):
                - Marker for battle appears on ubersreik.
                - When entering the marker, a battle is fought.
                - Battle remains available until invasion ends or battle is fought.
                - Winning the battle gives you an army with the Ubersreik heroes.
        - Invasion:
            - All major and minor non-confederated Skaven factions declare war on every non Skaven faction.
            - All major and minor non-confederated Skaven factions gets disabled diplomacy and full-retard AI.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Spawn all major factions armies on their relevant capitals, or in any capital. If their capital is in ruins or not in player's control, transfer it to them.
            - All subsequent extensions of the disaster are triggered by underempire expansion:
                - If the underempire extends under Nuln, Altdorf and Middenheim (Skaven owning these settlements count as expansion), implode these cities with rat king invasions.
                - If the underempire extends under Wei-Jin, Nan-Gau and Po-Mei (Skaven owning these settlements count as expansion), implode these cities with rat king invasions.
                - If the underempire extends under Copher, Lashiek and Caliph's Palace (Skaven owning these settlements count as expansion), implode these cities with rat king invasions.
                - If the underempire extends under Xlanhuapec, Itza and Tlaxtlan (Skaven owning these settlements count as expansion), implode these cities with rat king invasions.
                - If the underempire extends under Karak Kadrin, Karak Eight Peaks, Karak Azul, Karak Hirn, Barak Varr, Karak Izor and Zhufbar (Skaven owning these settlements count as expansion), implode these cities with rat king invasions.
                    - If the underempire extends under Karaz-a-Karak, the dwarfs hold it, and before it the "Skaven assaults the Karaz Ankor" event has trigger, implode these cities with rat king invasions.

    Attacker Buffs:
        - For endgame:
            - Leadership: +20%
        - For Skaven faction:
            - Recruitment Cost: -75%
            - Replenishment Rate: +20%
            - Unkeep: -75%
            - Ammunation: +50%

    Ideas:
        - If its faction is dead, put krokgar in lustria after Xlanhuapec falls
        - If its faction is dead, put Belegar in Karak 8 Peaks
        - If we reach the Karaz-a-Karak battle, maybe enter as reinforcements?

]]


-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_INVASION = 2;

-- Object representing the disaster.
disaster_vermintide = {
    name = "the_vermintide",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh2_main_sc_skv_skaven" },
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

        -- Common data for all disasters.
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        revive_dead_factions = false,       -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        short_victory_is_min_turn = false,  -- If the short victory turn should be used as min turn.
        long_victory_is_min_turn = false,   -- If the long victory turn should be used as min turn.
        min_turn = 130,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        -- Disaster-specific data.
        stage_0_ubersreik_battle_delay = 1,
        stage_1_delay = 1,

        ubersreik_battle_setup = false,
        ubersreik_battle_fought = false,
        under_cities_imploding_per_turn = 1,

        trigger_invasion_empire_turn = 0,
        trigger_invasion_araby_turn = 0,
        trigger_invasion_cathay_turn = 0,
        trigger_invasion_lustria_turn = 0,
        trigger_invasion_karaz_ankor_turn = 0,
        trigger_invasion_karaz_a_karak_turn = 0,

        regions = {},                       -- Regions to reveal fog for.
        repeat_regions = {},                -- List of regions we've previously expanded the underempire.

        -- List of skaven factions that will participate in the uprising.
        factions = {

            -- Major factions
            "wh2_main_skv_clan_mors",           -- Clan Mors (Queek)
            "wh2_main_skv_clan_pestilens",      -- Clan Pestilens (Skrolk)
            "wh2_dlc09_skv_clan_rictus",        -- Clan Rictus (Tretch)
            "wh2_main_skv_clan_skryre",         -- Clan Skryre (Ikit Claw)
            "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
            "wh2_main_skv_clan_moulder",        -- Clan Moulder (Throt)

            -- Minor factions
            "wh3_main_skv_clan_carrion",        -- Clan Carrion
            "wh2_dlc15_skv_clan_ferrik",        -- Clan Ferrik
            "wh2_dlc16_skv_clan_gritus",        -- Clan Gritus
            "wh2_dlc15_skv_clan_kreepus",       -- Clan Kreepus
            "wh3_main_skv_clan_krizzor",        -- Clan Krizzor
            "wh2_dlc12_skv_clan_mange",         -- Clan Mange
            "wh3_main_skv_clan_morbidus",       -- Clan Morbidus
            "wh3_main_skv_clan_mordkin",        -- Clan Mordkin
            "wh2_main_skv_clan_septik",         -- Clan Septik
            "wh3_main_skv_clan_skrat",          -- Clan Skrat
            "wh2_main_skv_clan_spittel",        -- Clan Spittel
            "wh3_main_skv_clan_treecherik",     -- Clan Treecherik
            "wh3_main_skv_clan_verms",          -- Clan Verms
        },
    },

    unit_count = 19,
    army_count_per_province = 4,

    factions_base_regions = {

        -- Major factions
        wh2_main_skv_clan_mors = "wh3_main_combi_region_misty_mountain",
        wh2_main_skv_clan_pestilens = "wh3_main_combi_region_oyxl",
        wh2_dlc09_skv_clan_rictus = "wh3_main_combi_region_crookback_mountain",
        wh2_main_skv_clan_skryre = "wh3_main_combi_region_skavenblight",
        wh2_main_skv_clan_eshin = "wh3_main_combi_region_xing_po",
        wh2_main_skv_clan_moulder = "wh3_main_combi_region_hell_pit",

        -- Minor factions
        wh3_main_skv_clan_carrion = "wh3_main_combi_region_nagashizzar",
        wh2_dlc15_skv_clan_ferrik = "wh3_main_combi_region_karak_dum",
        wh2_dlc16_skv_clan_gritus = "wh3_main_combi_region_tyrant_peak",
        wh2_dlc15_skv_clan_kreepus = "wh3_main_combi_region_mordheim",
        wh3_main_skv_clan_krizzor = "wh3_main_combi_region_xen_wu",
        wh2_dlc12_skv_clan_mange = "wh3_main_combi_region_spektazuma",
        wh3_main_skv_clan_morbidus = "wh3_main_combi_region_temple_avenue_of_gold",
        wh3_main_skv_clan_mordkin = "wh3_main_combi_region_teotiqua",
        wh2_main_skv_clan_septik = "wh3_main_combi_region_rackdo_gorge",
        wh3_main_skv_clan_skrat = "wh3_main_combi_region_kaiax",
        wh2_main_skv_clan_spittel = "wh3_main_combi_region_altar_of_the_horned_rat",
        wh3_main_skv_clan_treecherik = "wh3_main_combi_region_flayed_rock",
        wh3_main_skv_clan_verms = "wh3_main_combi_region_black_crag",
    },

    regions_empire = {
        "wh3_main_combi_region_middenheim",
        "wh3_main_combi_region_altdorf",
        "wh3_main_combi_region_nuln",
    },
    regions_araby = {
        "wh3_main_combi_region_copher",
        "wh3_main_combi_region_lashiek",
        "wh3_main_combi_region_wizard_caliphs_palace",
    },
    regions_cathay = {
        "wh3_main_combi_region_wei_jin",
        "wh3_main_combi_region_po_mei",
        "wh3_main_combi_region_nan_gau",
    },
    regions_lustria = {
        "wh3_main_combi_region_xlanhuapec",
        "wh3_main_combi_region_itza",
        "wh3_main_combi_region_tlaxtlan",
    },
    regions_karaz_ankor = {
        "wh3_main_combi_region_karak_kadrin",
        "wh3_main_combi_region_karak_eight_peaks",
        "wh3_main_combi_region_karak_izor",
        "wh3_main_combi_region_karak_azul",
        "wh3_main_combi_region_karak_hirn",
        "wh3_main_combi_region_barak_varr",
        "wh3_main_combi_region_zhufbar",
    },
    regions_karaz_a_karak = {
        "wh3_main_combi_region_karaz_a_karak",
    },

    army_templates = {

        -- Major factions use faction-specific templates
        wh2_main_skv_clan_mors = { skaven = "lategame_mors" },
        wh2_main_skv_clan_pestilens = { skaven = "lategame_pestilens" },
        wh2_dlc09_skv_clan_rictus = { skaven = "lategame_rictus" },
        wh2_main_skv_clan_skryre = { skaven = "lategame_skryre" },
        wh2_main_skv_clan_eshin = { skaven = "lategame_eshin" },
        wh2_main_skv_clan_moulder = { skaven = "lategame_moulder" },

        -- Minor factions use generic templates
        wh3_main_skv_clan_carrion = { skaven = "lategame" },
        wh2_dlc15_skv_clan_ferrik = { skaven = "lategame" },
        wh2_dlc16_skv_clan_gritus = { skaven = "lategame" },
        wh2_dlc15_skv_clan_kreepus = { skaven = "lategame" },
        wh3_main_skv_clan_krizzor = { skaven = "lategame" },
        wh2_dlc12_skv_clan_mange = { skaven = "lategame" },
        wh3_main_skv_clan_morbidus = { skaven = "lategame" },
        wh3_main_skv_clan_mordkin = { skaven = "lategame" },
        wh2_main_skv_clan_septik = { skaven = "lategame" },
        wh3_main_skv_clan_skrat = { skaven = "lategame" },
        wh2_main_skv_clan_spittel = { skaven = "lategame" },
        wh3_main_skv_clan_treecherik = { skaven = "lategame" },
        wh3_main_skv_clan_verms = { skaven = "lategame" },
    },

    early_warning_event_key = "wh3_main_ie_incident_endgame_vermintide_1",
    early_warning_effect_key = "dyn_dis_vermintide_early_warning",
    vermintide_event_key = "dyn_dis_vermintide_vermintide_trigger",
    invasion_empire_event_key = "dyn_dis_vermintide_empire_trigger",
    invasion_araby_event_key = "dyn_dis_vermintide_araby_trigger",
    invasion_cathay_event_key = "dyn_dis_vermintide_cathay_trigger",
    invasion_lustria_event_key = "dyn_dis_vermintide_lustria_trigger",
    invasion_karaz_ankor_event_key = "dyn_dis_vermintide_karaz_ankor_trigger",
    invasion_karaz_a_karak_event_key = "dyn_dis_vermintide_karaz_a_karak_trigger",
    finish_before_vermintide_event_key = "dyn_dis_vermintide_finish_before_stage_1",
    finish_event_key = "dyn_dis_vermintide_finish",
    endgame_mission_name = "the_vermintide",
    effects_global_key = "dyn_dis_vermintide_global_effects",
    attacker_buffs_key = "dyn_dis_vermintide_attacker_buffs",
    subculture = "wh2_main_sc_skv_skaven",

    -- TODO: Split this.
    ai_personality = "wh3_combi_skaven_endgame",

    ubersreik_incident_key = "wh3_main_ie_incident_endgame_vermintide_ubersreik",
    ubersreik_battle_success_incident_key = "wh3_main_ie_incident_endgame_vermintide_ubersreik_success",
    ubersreik_region_key = "wh3_main_combi_region_ubersreik",
    ubersreik_faction_key = "wh2_main_skv_skaven_qb1",
    ubersreik_battle_units = "wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_1,wh2_main_skv_inf_stormvermin_1,wh2_main_skv_inf_plague_monks,wh2_main_skv_inf_plague_monks,wh2_main_skv_inf_poison_wind_globadiers,wh2_main_skv_inf_poison_wind_globadiers,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_main_skv_inf_warpfire_thrower,wh2_main_skv_inf_warpfire_thrower,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_mon_rat_ogres",
    ubersreik_reward_units = "wh_main_dwf_inf_irondrakes_0,wh_main_dwf_inf_irondrakes_0,wh_main_dwf_inf_hammerers,wh_main_dwf_inf_hammerers,wh_dlc05_wef_inf_wildwood_rangers_0,wh_dlc05_wef_inf_wildwood_rangers_0,wh_main_emp_cav_outriders_1,wh_main_emp_cav_outriders_1,wh_main_emp_veh_steam_tank",
    ubersreik_reward_agents = {
        {type = "champion", subtype = "wh_main_emp_captain", forename = "names_name_2147355016", family_name = "names_name_2147354850"},
        {type = "spy", subtype = "wh_dlc05_wef_waystalker", forename = "names_name_2147359174", family_name = ""},
        {type = "spy", subtype = "wh_main_emp_witch_hunter", forename = "names_name_2147357411", family_name = "names_name_2147344113"},
        {type = "wizard", subtype = "wh_main_emp_bright_wizard", forename = "names_name_2147355023", family_name = "names_name_2147344053"},
        {type = "champion", subtype = "wh_main_dwf_thane", forename = "names_name_2147345808", family_name = "names_name_2147354039"}
    },

    inital_expansion_chance = 39, -- Chance for each region to get an under empire expansion each turn
    repeat_expansion_chance = 13, -- Chance for a region to get an under empire if it didn't get one on the first dice roll
    unique_building_chance = 25, -- Chance for a region to get one of the special faction-unique under empire templates
    under_empire_buildings = {
        generic = {
            {
                "wh2_dlc12_under_empire_annexation_war_camp_1",
                "wh2_dlc12_under_empire_money_crafting_2",
                "wh2_dlc12_under_empire_food_kidnappers_2",
                "wh2_dlc12_under_empire_food_raiding_camp_1"
            },
            {
                "wh2_dlc12_under_empire_settlement_stronghold_3",
            },
            {
                "wh2_dlc12_under_empire_settlement_stronghold_4",
                "wh2_dlc12_under_empire_food_raiding_camp_1"
            },
            {
                "wh2_dlc12_under_empire_settlement_stronghold_5",
                "wh2_dlc12_under_empire_food_raiding_camp_1",
                "wh2_dlc12_under_empire_discovery_deeper_tunnels_1"
            },
            {
                "wh2_dlc12_under_empire_settlement_warren_3",
            },
            {
                "wh2_dlc12_under_empire_settlement_warren_4",
                "wh2_dlc12_under_empire_food_raiding_camp_1"
            },
            {
                "wh2_dlc12_under_empire_settlement_warren_5",
                "wh2_dlc12_under_empire_food_raiding_camp_1",
                "wh2_dlc12_under_empire_discovery_deeper_tunnels_1"
            }
        },
        wh2_main_skv_clan_skryre = {
            "wh2_dlc12_under_empire_annexation_doomsday_1",
            "wh2_dlc12_under_empire_money_crafting_2",
            "wh2_dlc12_under_empire_food_kidnappers_2",
            "wh2_dlc12_under_empire_food_raiding_camp_1"
        },
        wh2_main_skv_clan_pestilens = {
            "wh2_dlc14_under_empire_annexation_plague_cauldron_1",
            "wh2_dlc12_under_empire_money_crafting_2",
            "wh2_dlc12_under_empire_food_kidnappers_2",
            "wh2_dlc12_under_empire_food_raiding_camp_1"
        },
    },

    initial_under_empire_placements = {
        wh2_main_skv_clan_mors = {
            "wh3_main_combi_region_karag_orrud",
            "wh3_main_combi_region_karak_zorn",
            "wh3_main_combi_region_galbaraz",
        },
        wh2_main_skv_clan_pestilens = {
            "wh3_main_combi_region_xahutec",
            "wh3_main_combi_region_hualotal",
            "wh3_main_combi_region_hexoatl",
        },
        wh2_dlc09_skv_clan_rictus = {
            "wh3_main_combi_region_karak_azul",
            "wh3_main_combi_region_black_fortress",
            "wh3_main_combi_region_zharr_naggrund",
        },
        wh2_main_skv_clan_skryre = {
            "wh3_main_combi_region_pfeildorf",
            "wh3_main_combi_region_altdorf",
            "wh3_main_combi_region_nuln",
        },
        wh2_main_skv_clan_eshin = {
            "wh3_main_combi_region_nan_gau",
            "wh3_main_combi_region_wei_jin",
            "wh3_main_combi_region_shang_yang",
        },
        wh2_main_skv_clan_moulder = {
            "wh3_main_combi_region_kislev",
            "wh3_main_combi_region_middenheim",
            "wh3_main_combi_region_kraka_drak",
        },
    }
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_vermintide:set_status(status)
    self.settings.status = status;

    --------------------------------------------
    -- Code for the Ubersreik battle
    --------------------------------------------

    -- This triggers the ubersreik battle incident.
    -- TODO: move this to a fucking quest battle.
    core:remove_listener("VermintideUbersreikSetup");
    core:add_listener(
        "VermintideUbersreikSetup",
        "WorldStartRound",
        function()
            return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_0_ubersreik_battle_delay;
        end,
        function()
            self:setup_ubersreik_battle();
            core:remove_listener("VermintideUbersreikAttack")
        end,
        true
    );

    core:remove_listener("VermintideUbersreikBattle");
    core:add_listener(
        "VermintideUbersreikBattle",
        "AreaEntered",
        function(context)
            return context:area_key() == "endgame_vermintide_marker" and self.settings.status >= STATUS_TRIGGERED and self.settings.ubersreik_battle_setup == true and self.settings.ubersreik_battle_fought == false;
        end,
        function(context)
            local character = context:family_member():character()

            if not character:is_null_interface() and character:has_military_force() then
                local faction = character:faction()

                if faction:is_human() and (faction:subculture() == "wh_main_sc_emp_empire" or faction:subculture() == "wh_dlc05_sc_wef_wood_elves" or faction:subculture() == "wh_main_sc_dwf_dwarfs") then

                    -- Mute these events so we don't get notifications for the battle factions.
                    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
                    cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

                    -- Settings to remember that this is a special battle.
                    cm:set_saved_value("VermintideUbersreikBattleActive", true);

                    -- Generate the battle. This handles generating the armies and triggering the battle.
                    self:generate_ubersreik_battle_force(character);
                end
            end
        end,
        true
    )

    -- Listener to cleanup after the Ubersreik battle.
    core:remove_listener("VermintideUbersreikBattleCleanup");
    core:add_listener(
        "VermintideUbersreikBattleCleanup",
        "BattleCompleted",
        function()
            return cm:get_saved_value("VermintideUbersreikBattleActive");
        end,
        function()
            invasion_manager:kill_invasion_by_key("VermintideUbersreikInvasion");
            dynamic_disasters:kill_faction_silently(self.ubersreik_faction_key);
            cm:set_saved_value("VermintideUbersreikBattleActive", false);

            -- If we won, spawn the extra army and remove the battle marker.
            local pb = cm:model():pending_battle()

            if pb:has_been_fought() and pb:defender_won() and pb:has_defender() then
                local defender_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1)
                local defender_fm = cm:get_family_member_by_cqi(defender_fm_cqi)
                if defender_fm and not defender_fm:character_details():is_null_interface() then
                    self:generate_ubersreik_army(defender_fm:character_details():faction():name())
                    cm:remove_interactable_campaign_marker("endgame_vermintide_marker")

                    self.settings.ubersreik_battle_fought = true;
                    core:remove_listener("VermintideUbersreikBattle")
                end
            end
        end,
        true
    );

    -- Listener to check if the character ran a way from the Ubersreik battle and cleanup accordingly.
    core:remove_listener("VermintideUbersreikBattleCleanupAfterRetreat");
    core:add_listener(
        "VermintideUbersreikBattleCleanupAfterRetreat",
        "CharacterWithdrewFromBattle",
        function()
            return cm:get_saved_value("VermintideUbersreikBattleActive");
        end,
        function()
            out("Frodo45127: Listener VermintideUbersreikBattleCleanupAfterRetreat triggered.")
            invasion_manager:kill_invasion_by_key("VermintideUbersreikInvasion");
            dynamic_disasters:kill_faction_silently(self.ubersreik_faction_key);
            cm:set_saved_value("VermintideUbersreikBattleActive", false);
        end,
        true
    );

    --------------------------------------------
    -- End of code for the Ubersreik battle
    --------------------------------------------

    -- Listener to provide ikit with nukes and stuff while he's alive.
    core:remove_listener("VermintideIkitWarpfuel");
    core:add_listener(
        "VermintideIkitWarpfuel",
        "WorldStartRound",
        function()
            return self.settings.started == true;
        end,
        function()
            local skryre_faction = cm:get_faction("wh2_main_skv_clan_skryre")
            if not skryre_faction == false and skryre_faction:is_null_interface() == false and skryre_faction:is_dead() == false and skryre_faction:is_human() == false then

                out("Frodo45127: Giving Ikit 14 reactor cores (4 from this, 10 from expansion, same as vanilla but all in one go).");
                cm:faction_add_pooled_resource(skryre_faction:name(), "skv_reactor_core", "missions", 14)
                if cm:random_number(100) <= (10 * self.settings.difficulty_mod) then

                    out("Frodo45127: Giving Ikit 4 nukes. It's fallout, baby!");
                    cm:faction_add_pooled_resource(skryre_faction:name(), "skv_nuke", "workshop_production", 4)
                end
            end
        end,
        true
    )

    --------------------------------------------
    -- Code for Underempire Management.
    --------------------------------------------

    -- Listener to keep retriggering the Under-Empire expansion each turn, as long as the disaster lasts.
    core:remove_listener("VermintideUnderEmpireExpansion");
    core:add_listener(
        "VermintideUnderEmpireExpansion",
        "WorldStartRound",
        function()
            return self.settings.started == true and self.settings.status > STATUS_TRIGGERED;
        end,
        function()
            self:expand_under_empire()
        end,
        true
    )

    -- Listener to keep retriggering the Under-Empire building upgrades each turn, as long as the disaster lasts.
    core:remove_listener("VermintideUnderEmpireImplosion");
    core:add_listener(
        "VermintideUnderEmpireImplosion",
        "WorldStartRound",
        function()
            return self.settings.started == true and self.settings.status > STATUS_TRIGGERED;
        end,
        function()
            self:implode_under_empire()
        end,
        true
    )

    -- Trigger can trigger twice here, so make sure we don't have duplicated listeners running.
    if self.settings.status == STATUS_TRIGGERED then

        -- This triggers the main invasion of the disaster if the disaster hasn't been cancelled.
        core:remove_listener("VermintideInvasion");
        core:add_listener(
            "VermintideInvasion",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay;
            end,

            -- If there are skaven alive, proceed with stage 1.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_before_vermintide_event_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_vermintide();
                end
                core:remove_listener("VermintideInvasion")
            end,
            true
        );
    end

    if self.settings.status == STATUS_INVASION then

        -- This triggers the skaven invasion of the empire.
        core:remove_listener("VermintideInvasionEmpire")
        core:add_listener(
            "VermintideInvasionEmpire",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionEmpire") == true and self:are_regions_owned_or_undercontrolled(self.regions_empire);
            end,
            function()
                self:trigger_death_from_below(self.regions_empire);
                cm:set_saved_value("VermintideInvasionEmpire", true);
                self.trigger_invasion_empire_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionEmpire");
            end,
            true
        );

        -- This triggers the skaven invasion of Araby.
        core:remove_listener("VermintideInvasionAraby")
        core:add_listener(
            "VermintideInvasionAraby",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionAraby") == true and self:are_regions_owned_or_undercontrolled(self.regions_araby);
            end,
            function()
                self:trigger_death_from_below(self.regions_araby);
                cm:set_saved_value("VermintideInvasionAraby", true);
                self.trigger_invasion_araby_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionAraby");
            end,
            true
        );

        -- This triggers the skaven invasion of Cathay.
        core:remove_listener("VermintideInvasionCathay")
        core:add_listener(
            "VermintideInvasionCathay",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionCathay") == true and self:are_regions_owned_or_undercontrolled(self.regions_cathay);
            end,
            function()
                self:trigger_death_from_below(self.regions_cathay);
                cm:set_saved_value("VermintideInvasionCathay", true);
                self.trigger_invasion_cathay_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionCathay");
            end,
            true
        );

        -- This triggers the skaven invasion of Lustria.
        core:remove_listener("VermintideInvasionLustria")
        core:add_listener(
            "VermintideInvasionLustria",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionLustria") == true and self:are_regions_owned_or_undercontrolled(self.regions_lustria);
            end,
            function()
                self:trigger_death_from_below(self.regions_lustria);
                cm:set_saved_value("VermintideInvasionLustria", true);
                self.trigger_invasion_lustria_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionLustria");
            end,
            true
        );

        -- This triggers the skaven invasion of the Karak Ankor.
        core:remove_listener("VermintideInvasionKarakAnkor")
        core:add_listener(
            "VermintideInvasionKarakAnkor",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionKarakAnkor") == true and self:are_regions_owned_or_undercontrolled(self.regions_karaz_ankor);
            end,
            function()
                self:trigger_death_from_below(self.regions_karaz_ankor);
                cm:set_saved_value("VermintideInvasionKarakAnkor", true);
                self.trigger_invasion_karaz_ankor_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionKarakAnkor");
            end,
            true
        );

        -- This triggers the skaven invasion of Karaz-a-Karak.
        core:remove_listener("VermintideInvasionKarazaKarak")
        core:add_listener(
            "VermintideInvasionKarazaKarak",
            "WorldStartRound",
            function()
                return not cm:get_saved_value("VermintideInvasionKarazaKarak") == true and cm:get_saved_value("VermintideInvasionKarakAnkor") == true and self:are_regions_owned_or_undercontrolled(self.regions_karaz_a_karak);
            end,
            function()
                self:trigger_death_from_below(self.regions_karaz_a_karak);
                cm:set_saved_value("VermintideInvasionKarazaKarak", true);
                self.trigger_invasion_karaz_a_karak_turn = cm:turn_number() + 1;
                core:remove_listener("VermintideInvasionKarazaKarak");
            end,
            true
        );

        -- Listener to keep spawning armies every (10 / (difficulty_mod + 1)) turns, one army on each faction's capital.
        core:remove_listener("VermintideRespawn")
        core:add_listener(
            "VermintideRespawn",
            "WorldStartRound",
            function()
                return cm:turn_number() % math.ceil(10 / (self.settings.difficulty_mod + 1)) == 0 and
                    dynamic_disasters:is_any_faction_alive_from_list_with_home_region(self.settings.factions);
            end,
            function()
                for _, faction_key in pairs(self.settings.factions) do
                    local faction = cm:get_faction(faction_key);
                    if not faction == false and faction:is_null_interface() == false and faction:has_home_region() then
                        local region = faction:home_region();
                        dynamic_disasters:create_scenario_force(faction:name(), region:name(), self.army_templates[faction:name()], self.unit_count, false, 1, self.name, nil)
                    end
                end
            end,
            true
        );

        -- Listener to trigger vermintide invasions events on the next turn after the undercities are setup.
        core:remove_listener("VermintidePostponedEvents")
        core:add_listener(
            "VermintidePostponedEvents",
            "WorldStartRound",
            function()
                return self.trigger_invasion_empire_turn == cm:turn_number() or
                   self.trigger_invasion_araby_turn == cm:turn_number() or
                   self.trigger_invasion_cathay_turn == cm:turn_number() or
                   self.trigger_invasion_lustria_turn == cm:turn_number() or
                   self.trigger_invasion_karaz_ankor_turn == cm:turn_number() or
                   self.trigger_invasion_karaz_a_karak_turn == cm:turn_number();
            end,
            function()
                if self.trigger_invasion_empire_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_empire_event_key, nil, nil, nil, nil, nil);
                end
                if self.trigger_invasion_araby_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_araby_event_key, nil, nil, nil, nil, nil);
                end
                if self.trigger_invasion_cathay_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_cathay_event_key, nil, nil, nil, nil, nil);
                end
                if self.trigger_invasion_lustria_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_lustria_event_key, nil, nil, nil, nil, nil);
                end
                if self.trigger_invasion_karaz_ankor_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_karaz_ankor_event_key, nil, nil, nil, nil, nil);
                end
                if self.trigger_invasion_karaz_a_karak_turn == cm:turn_number() then
                    dynamic_disasters:trigger_incident(self.invasion_karaz_a_karak_event_key, nil, nil, nil, nil, nil);
                end
            end,
            true
        );
    end

    -- No need to have a specific listener to end the disaster after no more stages can be triggered, as that's controlled by a mission.
end

-- Function to trigger the disaster.
function disaster_vermintide:start()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay to trigger this.
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_1_delay = 2;                    -- 2 instead of 1 to let ubersreik trigger in a different turn than step 1.
        self.settings.stage_0_ubersreik_battle_delay = 1;
    else
        self.settings.stage_1_delay = cm:random_number(10, 6);
        self.settings.stage_0_ubersreik_battle_delay = cm:random_number(4, 2); -- Make sure we trigger this one BEFORE the stage 1 triggers.
    end

    -- Initialize listeners.
    dynamic_disasters:trigger_incident(self.early_warning_event_key, self.early_warning_effect_key, self.settings.stage_1_delay, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end


-- Function to trigger cleanup stuff after the invasion is over.
function disaster_vermintide:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        -- Remove all effects related to this disaster and its missions.
        local faction_list = cm:model():world():faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            cm:remove_effect_bundle(self.effects_global_key, faction:name());
        end

        -- Remove all the related listeners.
        core:remove_listener("VermintideUbersreikSetup");
        core:remove_listener("VermintideUbersreikBattle");
        core:remove_listener("VermintideUbersreikBattleCleanup");
        core:remove_listener("VermintideUbersreikBattleCleanupAfterRetreat");
        core:remove_listener("VermintideIkitWarpfuel");
        core:remove_listener("VermintideUnderEmpireExpansion");
        core:remove_listener("VermintideUnderEmpireImplosion");
        core:remove_listener("VermintideInvasion");
        core:remove_listener("VermintideInvasionEmpire");
        core:remove_listener("VermintideInvasionAraby");
        core:remove_listener("VermintideInvasionCathay");
        core:remove_listener("VermintideInvasionLustria");
        core:remove_listener("VermintideInvasionKarakAnkor");
        core:remove_listener("VermintideInvasionKarazaKarak");
        core:remove_listener("VermintideRespawn");
        core:remove_listener("VermintidePostponedEvents")

        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_vermintide:check_start()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers for the invasion.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Do not start if Clan Skryre is not available to use.
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

    local base_chance = 2.5;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
            base_chance = base_chance + 2.5;
        end
    end

    -- If the chaos invasion has been triggered, get this up a 10%.
    for _, disaster in pairs(dynamic_disasters.disasters) do
        if disaster.name == "chaos_invasion" and disaster.settings.started == true and disaster.settings.finished == false then
            base_chance = base_chance + 100;
            break;
        end
    end

    if cm:random_number(1000, 0) < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_vermintide:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    return #self.settings.factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the first stage of the Vermintide.
function disaster_vermintide:trigger_vermintide()
    for _, faction_key in pairs(self.settings.factions) do
        local invasion_faction = cm:get_faction(faction_key)

        if not invasion_faction:is_dead() or (invasion_faction:is_dead() and self.settings.revive_dead_factions == true) then
            local region_key = self.factions_base_regions[faction_key];
            local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);
            if dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.unit_count, false, army_count, self.name, nil, self.settings.factions) then

                -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
                dynamic_disasters:no_peace_no_confederation_only_war(faction_key, self.settings.enable_diplomacy)

                -- Give the invasion region to the invader if it isn't owned by them or a human
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region:is_abandoned() or region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false and region_owner:subculture() ~= self.subculture) then
                        cm:transfer_region_to_faction(region_key, faction_key)
                    end
                end

                -- Change their AI so it becomes aggressive, while declaring war to everyone and their mother.
                cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
                cm:instantly_research_all_technologies(faction_key);
                dynamic_disasters:declare_war_to_all(invasion_faction, { self.subculture }, true);
                table.insert(self.settings.regions, region_key);
            end
        end
    end

    -- Setup strategic under-cities for all factions available, including the recently resurrected ones.
    for _, faction_key in pairs(self.settings.factions) do

        out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ".");
        if self.initial_under_empire_placements[faction_key] ~= nil then
            for _, region_key in pairs(self.initial_under_empire_placements[faction_key]) do

                out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
                local region = cm:get_region(region_key);
                self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
            end
        end

    end

    -- In debug mode, expand the underempire to the trigger regions too.
    if dynamic_disasters.settings.debug_2 == true then
        local faction_key = "wh2_main_skv_clan_skryre";
        for _, region_key in pairs(self.regions_empire) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
        for _, region_key in pairs(self.regions_araby) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
        for _, region_key in pairs(self.regions_cathay) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
        for _, region_key in pairs(self.regions_lustria) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
        for _, region_key in pairs(self.regions_karaz_ankor) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
        for _, region_key in pairs(self.regions_karaz_a_karak) do
            out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
            local region = cm:get_region(region_key);
            self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
        end
    end

    -- Make sure every attacker is at peace with each other.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(0);

    -- Also, make sure they're added to the victory conditions.
    for _, faction_key in pairs(self.settings.factions) do
        table.insert(self.objectives[1].conditions, "faction " .. faction_key)
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.vermintide_event_key, nil, self.settings.factions[1], function () self:finish() end, true)
    dynamic_disasters:trigger_incident(self.vermintide_event_key, self.effects_global_key, 0, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", self.subculture)
    self:set_status(STATUS_INVASION);
end

--------------------------------------------------------------------------

--------------------------------------------------------------------------

-- Function to apply the Morrslieb effects to all factions.
---@param duration integer #Duration of the effects, in turns.
function disaster_vermintide:morrslieb_gaze_is_upon_us(duration)
    local faction_list = cm:model():world():faction_list()
    local province_list = cm:model():world():province_list();

    -- Apply the corruption effects to all alive factions, except humans.
    -- Humans get this effect via payload with effect.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false and faction:is_human() == false then
            cm:apply_effect_bundle(self.effects_global_key, faction:name(), duration)
        end
    end

    -- Apply the Storms of Magic to all provinces at random, based on our current stage.
    local base_chance = self.settings.status * 10;
    for i = 0, province_list:num_items() - 1 do
        local province = province_list:item_at(i);
        local chance = cm:random_number(100, 0);
        if chance > base_chance then
            cm:force_winds_of_magic_change(province:key(), "wom_strength_5");
        end
    end;

    -- Apply attackers buffs to all alive skaven factions.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
            cm:apply_effect_bundle(self.attacker_buffs_key, faction_key, duration);
        end
    end
end

-------------------------------------------
-- Ubersreik battle stuff
-------------------------------------------

-- Function to setup the stuff for the ubersreik battle.
function disaster_vermintide:setup_ubersreik_battle()

    -- Only do this if we have a valid position for the marker.
    local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement("wh_main_emp_empire", self.ubersreik_region_key, false, true, 9)
    if pos_x > -1 then

        -- Enable the battle only for empire, wood elves and dwarfs.
        local human_factions = cm:get_human_factions()
        for i = 1, #human_factions do
            local faction = cm:get_faction(human_factions[i])
            if faction:subculture() == "wh_main_sc_emp_empire" or faction:subculture() == "wh_dlc05_sc_wef_wood_elves" or faction:subculture() == "wh_main_sc_dwf_dwarfs" then

                -- Only setup this if we find a valid position for the marker.
                self.settings.ubersreik_battle_setup = true;

                local region_cqi = cm:get_region(self.ubersreik_region_key):cqi();
                local faction_cqi = faction:command_queue_index();
                cm:trigger_incident_with_targets(faction_cqi, self.ubersreik_incident_key, 0, 0, 0, 0, region_cqi, 0)
            end
        end
    end

    -- If we found at least one human player with a valid position, setup the marker.
    if self.settings.ubersreik_battle_setup == true then
        cm:add_interactable_campaign_marker("endgame_vermintide_marker", "endgame_vermintide_marker", pos_x, pos_y, 2)
    end
end

-- Function to generate the army for the ubersreik battle, and trigger them to attack.
---@param character CHARACTER_SCRIPT_INTERFACE #Character that's triggering the battle.
function disaster_vermintide:generate_ubersreik_battle_force(character)
    local mf = character:military_force();
    local faction = character:faction()
    local faction_name = faction:name()

    -- guard against invasion already existing
    invasion_manager:kill_invasion_by_key("VermintideUbersreikInvasion");

    -- Spawn the invasion, declare war on them and force them to do an attack of oportunity.
    ---@type invasion
    local invasion = invasion_manager:new_invasion("VermintideUbersreikInvasion", self.ubersreik_faction_key, self.ubersreik_battle_units, {character:logical_position_x(), character:logical_position_y()})
    invasion:set_target("CHARACTER", character:command_queue_index(), faction_name)
    invasion:start_invasion(
        function(context2)
            core:add_listener(
                "endgame_vermintide_ubersreik_invasion_war_declared",
                "FactionLeaderDeclaresWar",
                function(context)
                    return context:character():faction():name() == self.ubersreik_faction_key
                end,
                function()
                    local attacker_mf = context2:get_general():military_force()
                    local attacker_cqi = attacker_mf:command_queue_index();     -- Invader.
                    local defender_cqi = mf:command_queue_index();              -- Player.

                    -- Lock the AI army so it doesn't run away.
                    cm:set_force_has_retreated_this_turn(attacker_mf);
                    cm:force_attack_of_opportunity(attacker_cqi, defender_cqi, false);
                end,
                false
            );

            cm:force_declare_war(self.ubersreik_faction_key, faction_name, false, false)
        end,
        false,
        false,
        false
    )
end

-- This function generates the "Reward" army for completing the Ubersreik battle.
---@param faction_key integer #Faction that will receive the army.
function disaster_vermintide:generate_ubersreik_army(faction_key)

    -- In case no more valid positions are found, retry with a bigger radious.
    local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, self.ubersreik_region_key, false, true, 10)
    if pos_x == -1 or pos_y == -1 then
        out("Frodo45127: Armies failed to spawn at region " .. self.ubersreik_region_key .. ". Retrying with bigger radious.");
        pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, self.ubersreik_region_key, false, true, 10)
    end

    -- In case no more valid positions are found, retry with a much bigger radious.
    if pos_x == -1 or pos_y == -1 then
        out("Frodo45127: Armies failed to spawn at region " .. self.ubersreik_region_key .. ". Retrying with much bigger radious.");
        pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, self.ubersreik_region_key, false, true, 15)
    end

    -- If they're still invalid, fallback to the faction's capital.
    if pos_x == -1 or pos_y == -1 then
        out("Frodo45127: Armies failed to spawn again. Falling back to factions capital.");

        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:has_home_region() then
            pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, faction:home_region(), false, true, 5)
        else
            out("Frodo45127: Armies failed to spawn again in the faction's capital. Sorry, no reward for you.");
            return;
        end
    end

    -- Make sure we don't get events for the army/character spawns.
    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
    cm:disable_event_feed_events(true, "wh_event_category_traits_ancillaries", "", "")

    -- Create the army, and attach the relevant heroes to it.
    cm:create_force(
        faction_key,
        self.ubersreik_reward_units,
        self.ubersreik_region_key,
        pos_x,
        pos_y,
        false,
        function(cqi)
            local force = cm:get_character_by_cqi(cqi):military_force()
            local force_cqi = force:command_queue_index()

            cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(cqi), 7)

            for i = 1, #self.ubersreik_reward_agents do
                local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, self.ubersreik_region_key, false, true, 10)
                local agent = cm:create_agent(faction_key, self.ubersreik_reward_agents[i].type, self.ubersreik_reward_agents[i].subtype, agent_x, agent_y, nil)
                local forename = common:get_localised_string(self.ubersreik_reward_agents[i].forename)
                local family_name = common:get_localised_string(self.ubersreik_reward_agents[i].family_name)
                cm:change_character_custom_name(agent, forename, family_name, "", "")
                cm:add_agent_experience(cm:char_lookup_str(agent:command_queue_index()), 25, true)
                cm:embed_agent_in_force(agent, force);
            end

            -- Reenable the events for army/character spawns.
            cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
            cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
            cm:disable_event_feed_events(false, "wh_event_category_traits_ancillaries", "", "")

            -- Trigger an incident informing about the new army.
            local faction_cqi = cm:get_faction(faction_key):command_queue_index();
            cm:trigger_incident_with_targets(faction_cqi, self.ubersreik_battle_success_incident_key, 0, 0, 0, force_cqi, 0, 0)
        end
    )
end

-------------------------------------------
-- Underempire expansion logic
-------------------------------------------

-- This function expands the underempire when called, if expansion is still possible.
function disaster_vermintide:expand_under_empire()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
    for i = 1, #self.settings.factions do

        -- We're only interested in expanding the underempire for factions that are actually alive.
        local faction_key = self.settings.factions[i];
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then

            -- Keep track of all the regions a faction has expanded to, so we can slow them down when they re-expand on these regions.
            local checked_regions = {}

            -- Try to expand to regions bordering the current underempire.
            local foreign_region_list = faction:foreign_slot_managers()
            for i2 = 0, foreign_region_list:num_items() -1 do
                local region = foreign_region_list:item_at(i2):region()
                self:expand_under_empire_adjacent_region_check(faction_key, region, checked_regions, false)
            end

            -- Try to expand to regions bordering the current surface empire.
            local region_list = faction:region_list()
            for i2 = 0, region_list:num_items() -1 do
                local region = region_list:item_at(i2)
                self:expand_under_empire_adjacent_region_check(faction_key, region, checked_regions, false)
            end
        end
    end
end

-- This function expands the underempire for the provided faction, using the provided region as source region to expand from.
function disaster_vermintide:expand_under_empire_adjacent_region_check(sneaky_skaven, region, checked_regions, force_unique_setup, ignore_rolls, apply_to_current_region)
    local adjacent_region_list = region:adjacent_region_list()
    for i = 0, adjacent_region_list:num_items() -1 do
        local adjacent_region = adjacent_region_list:item_at(i)
        local adjacent_region_key = adjacent_region:name()

        if apply_to_current_region == true then
            adjacent_region = region;
            adjacent_region_key = region:name();
        end

        -- To reduce iterations, we only process regions that have not be processed yet this turn.
        if checked_regions[adjacent_region_key] == nil then
            checked_regions[adjacent_region_key] = true

            -- Expand with higher chance on the first expansion, the reduce the expansion chance.
            if not adjacent_region == false and adjacent_region:is_null_interface() == false then
                local chance = self.repeat_expansion_chance
                if self.settings.repeat_regions[adjacent_region_key] == nil then
                    self.settings.repeat_regions[adjacent_region_key] = true
                    chance = self.inital_expansion_chance
                end

                local dice_roll = cm:random_number(100, 1)
                if (dice_roll <= chance or ignore_rolls == true) then
                    out("Frodo45127: Spreading under-empire to " .. adjacent_region_key .. " for " .. sneaky_skaven)

                    -- If the region is abandoned and no player is one of the excluded factions, do not use underempire. Take the region directly.
                    if adjacent_region:is_abandoned() and not dynamic_disasters:is_a_player_destructive_faction() then
                        cm:transfer_region_to_faction(adjacent_region_key, sneaky_skaven)

                    -- Only expand to regions not owned by the same faction.
                    -- Note that this can result in undercities changing hands frequently, which I find kinda in lore.
                    elseif adjacent_region:owning_faction():name() ~= sneaky_skaven then
                        local is_sneaky_skaven_present = false
                        local foreign_slot_managers = adjacent_region:foreign_slot_managers()
                        for i2 = 0, foreign_slot_managers:num_items() -1 do
                            local foreign_slot_manager = foreign_slot_managers:item_at(i2)
                            if foreign_slot_manager:faction():name() == sneaky_skaven then
                                is_sneaky_skaven_present = true
                                break
                            end
                        end

                        if is_sneaky_skaven_present == false then

                            -- Pick the underempire setup at random. 25% chance of faction specific layouts.
                            local under_empire_buildings
                            if self.under_empire_buildings[sneaky_skaven] ~= nil and (cm:random_number(100) <= self.unique_building_chance or force_unique_setup == true) then
                                under_empire_buildings = self.under_empire_buildings[sneaky_skaven]
                            else
                                local random_index = cm:random_number(#self.under_empire_buildings.generic)
                                under_empire_buildings = self.under_empire_buildings.generic[random_index]
                            end

                            local region_cqi = adjacent_region:cqi()
                            local faction_cqi = cm:get_faction(sneaky_skaven):command_queue_index()
                            local foreign_slot = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, region_cqi, "wh2_dlc12_slot_set_underempire")

                            -- Add the buildings to the underempire.
                            for i3 = 1, #under_empire_buildings do
                                local building_key = under_empire_buildings[i3]
                                local slot = foreign_slot:slots():item_at(i3-1)
                                cm:foreign_slot_instantly_upgrade_building(slot, building_key)
                                out("Frodo45127: Added " .. building_key .. " to " .. adjacent_region:name() .. " for " .. sneaky_skaven)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- This function replaces the main building of an undercity with its max-level equivalent, triggering nukes/rat kings/plagues in the process.
function disaster_vermintide:implode_under_empire()

    for _, faction_key in pairs(self.settings.factions) do
        local imploded_undercities = 0;
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false then
            local foreign_slots = faction:foreign_slot_managers();
            for i = 0, foreign_slots:num_items() -1 do

                -- Check if we already imploded enough undercities for this faction this turn.
                if imploded_undercities >= self.settings.under_cities_imploding_per_turn then
                    break;
                end

                local foreign_slot = foreign_slots:item_at(i);
                local slots = foreign_slot:slots();
                for i2 = 0, slots:num_items() - 1 do
                    local slot = slots:item_at(i2)
                    if not slot:is_null_interface() and slot:has_building() then
                        local new_building = false;
                        local building_key = slot:building();
                        if building_key == "wh2_dlc12_under_empire_annexation_doomsday_1" then
                            new_building = "wh2_dlc12_under_empire_annexation_doomsday_2";
                        elseif building_key == "wh2_dlc12_under_empire_annexation_war_camp_1" then
                            new_building = "wh2_dlc12_under_empire_annexation_war_camp_2";
                        elseif building_key == "wh2_dlc14_under_empire_annexation_plague_cauldron_1" then
                            new_building = "wh2_dlc14_under_empire_annexation_plague_cauldron_2";
                        end

                        if not new_building == false then
                            local region = foreign_slot:region();

                            cm:foreign_slot_instantly_upgrade_building(slot, new_building);
                            out("Frodo45127: Imploding undercity, added " .. new_building .. " to " .. region:name() .. " for " .. faction:name());

                            imploded_undercities = imploded_undercities + 1;
                        end
                    end
                end
            end
        end
    end
end

--- This function checks if all provided regions are owned by skaven, or have an skaven undercity on them.
---@param regions table #Indexed table of region keys.
---@return boolean #If all regions are controlled by skaven or not.
function disaster_vermintide:are_regions_owned_or_undercontrolled(regions)
    local skaven_controlled = true;

    for _, region_key in pairs(regions) do
        local region = cm:get_region(region_key);
        if not region == false and region:is_null_interface() == false and not region:is_abandoned() then
            local hidden_skaven = false;

            local fsms = region:foreign_slot_managers()
            for i = 0, fsms:num_items() - 1 do
                local fsm = fsms:item_at(i)
                if fsm:faction():subculture() == self.subculture then
                    hidden_skaven = true
                    break;
                end
            end

            if (region:owning_faction():subculture() ~= self.subculture and not hidden_skaven) then
                skaven_controlled = false;
                break;
            end
        end
    end

    return skaven_controlled;
end

--- This function triggers an implosion of undercities in the specified regions, or just spawns armies if the relevant regions are owned by skaven instead of having an undercity.
---@param regions table #Indexed table of region keys.
function disaster_vermintide:trigger_death_from_below(regions)
    local army_count = math.floor(self.army_count_per_province * self.settings.difficulty_mod);

    for _, region_key in pairs(regions) do
        local region = cm:get_region(region_key);
        if not region == false and region:is_null_interface() == false and not region:is_abandoned() then
            local owner = region:owning_faction();

            -- If it's already under skaven control, just give them armies.
            if not owner == false and owner:is_null_interface() == false and owner:subculture() == self.subculture then
                dynamic_disasters:create_scenario_force(owner:name(), region:name(), self.army_templates[owner:name()], self.unit_count, false, army_count, self.name, nil);

            -- Otherwise, just trigger whatever the undercity for that region has.
            -- NOTE: A bit cheaty, but here we need to replace the main building in case its not an anexation one.
            else
                local fsms = region:foreign_slot_managers()
                for i = 0, fsms:num_items() - 1 do
                    local fsm = fsms:item_at(i)
                    local slots = fsm:slots();

                    local already_at_max_annex = false;
                    for i2 = 0, slots:num_items() - 1 do
                        local slot = slots:item_at(i2)
                        if not slot:is_null_interface() and slot:has_building() then
                            local building_key = slot:building();
                            if building_key == "wh2_dlc12_under_empire_annexation_doomsday_2" or building_key == "wh2_dlc14_under_empire_annexation_plague_cauldron_2" or building_key == "wh2_dlc12_under_empire_annexation_doomsday_2" then
                                already_at_max_annex = true;
                                break;
                            end
                        end
                    end

                    -- Do not try to do anything if we already upped up this settlement to max level.
                    if not already_at_max_annex then
                        local annex_index = false;
                        for i2 = 0, slots:num_items() - 1 do
                            local slot = slots:item_at(i2)
                            if not slot:is_null_interface() and slot:has_building() then
                                local building_key = slot:building();
                                if building_key == "wh2_dlc12_under_empire_annexation_doomsday_1" or building_key == "wh2_dlc14_under_empire_annexation_plague_cauldron_1" or building_key == "wh2_dlc12_under_empire_annexation_doomsday_1" then
                                    annex_index = i2;
                                    break;
                                end
                            end
                        end

                        -- If there was no anexation building, put the rat king one in.
                        if annex_index == false then
                            local main_slot = slots:item_at(0);
                            cm:foreign_slot_instantly_upgrade_building(main_slot, "wh2_dlc12_under_empire_annexation_war_camp_1");
                            out("Frodo45127: Undercity with no annex building, replacing main building with Rat King at " .. region:name() .. ".");
                            annex_index = 0;
                        end

                        local annex_slot = slots:item_at(annex_index);
                        local new_building = false;
                        local building_key = annex_slot:building();
                        if building_key == "wh2_dlc12_under_empire_annexation_doomsday_1" then
                            new_building = "wh2_dlc12_under_empire_annexation_doomsday_2";
                        elseif building_key == "wh2_dlc14_under_empire_annexation_plague_cauldron_1" then
                            new_building = "wh2_dlc14_under_empire_annexation_plague_cauldron_2";
                        elseif building_key == "wh2_dlc12_under_empire_annexation_war_camp_1" then
                            new_building = "wh2_dlc12_under_empire_annexation_war_camp_2";
                        end

                        -- Fallback situation.
                        if new_building == false then
                            new_building = "wh2_dlc12_under_empire_annexation_war_camp_2";
                        end

                        if not new_building == false then
                            cm:foreign_slot_instantly_upgrade_building(annex_slot, new_building);
                            out("Frodo45127: Imploding undercity, added " .. new_building .. " to " .. region:name() .. ".");
                        end
                    end
                end
            end
        end
    end
end

-------------------------------------------
-- Underempire expansion logic end
-------------------------------------------

return disaster_vermintide
