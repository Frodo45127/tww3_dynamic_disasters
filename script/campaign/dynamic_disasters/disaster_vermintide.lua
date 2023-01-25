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
        - Stage 1:
            - If Clan Skryre has been confederated, end the disaster here.
            - Spawn all major factions armies on their relevant capitals, or in any capital. If their capital is in ruins or not in player's control, transfer it to them.

        - Stage 2.1:
            - When a Vermintide Army or a nuke results from an undercity in Lustria:
                - Trigger the Invasion of Lustria event.


            - If not:
                - Targets: Estalia, Tilea and Sartosa.
                - Spawn Clan Skyre armies on Estalia, Tilea and Sartosa.
                - Clan Skryre declares war on everyone not skaven.
                - Clan Skryre gets disabled diplomacy and full-retard AI.
                - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
                - Wait 6-10 turns for more info.
                - Dead major factions will respawn in Skavenblight.
                - Major factions will gain undercities on strategic places for them.
        - Stage 2:
            - Targets: The Empire, Araby's North Coast and Cathay's Hearthlands.
            - Spawn random skaven factions's armies on the Empire and Araby's North Coast.
            - If Eshin has not been confederated:
                - Spawn Clan Eshin armies on Cathay's Hearthlands.
            - All major and minor non-confederated skaven factions declare war on everyone not skaven.
            - All major and minor non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 4-7 turns for more info.
        - Stage 3:
            - Targets: Xlanhuapec, Itza and Tlaxtlan (Lustria).
            - Spawn Clans Pestilens and Skryre armies in Lustria.
            - All major and minor non-confederated skaven factions declare war on everyone not skaven.
            - All major and minor non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 4-6 turns for more info.
        - Stage 4:
            - Targets: Major settlments of the Karaz Ankor.
            - Spawn a mix of clans armies on settlements of the Karaz Ankor.
            - All major and minor non-confederated skaven factions declares war on everyone not skaven.
            - All major and minor non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 6-10 turns for more info.
        - Stage 5 (Optional):
            - Target: Karaz-a-Karak.
            - Clan Mors must be alive and not confederated.
            - Kazaz-a-Karak must be controlled by a dwarven faction.
            - Spawn a few Clan Mors armies in Karaz-a-Karak.
            - All major and minor non-confederated skaven factions declares war on everyone not skaven.
            - All major and minor non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - "The Green Shine of MorrsLieb" effect will last 10 more turns.

        - Finish:
            - Before Stage 1:
                - If Clan Skryre is killed/confederated.
            - After Stage 1:
                - All skaven factions destroyed.

    Ideas:
        - If its faction is dead, put krokgar in lustria after Xlanhuapec falls
        - If its faction is dead, put Belegar in Karak 8 Peaks
        - If we reach the Karaz-a-Karak battle, maybe enter as reinforcements?
        - Replace army spawns with undercities, and make some undercities explode.

    TODO: Replace army spawns on occupied regions with undercities initialized in stage 1 reaching boiling point.
    TODO: Test building nukes on a few cities.

]]


-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;
local STATUS_STAGE_3 = 4;
local STATUS_STAGE_4 = 5;
local STATUS_STAGE_5 = 6;

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
        revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
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
        stage_2_delay = 1,
        stage_3_delay = 1,
        stage_4_delay = 1,
        stage_5_delay = 1,
        invasion_over_delay = 10,

        ubersreik_battle_setup = false,
        ubersreik_battle_fought = false,
        under_cities_imploding_per_turn = 1,

        repeat_regions = {},

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

        factions_stage_1 = {
            "wh2_main_skv_clan_skryre",         -- Clan Skryre (Ikit Claw)
        },

        factions_stage_2_empire_and_araby = {
            "wh3_main_skv_clan_carrion",        -- Clan Carrion
            "wh2_dlc12_skv_clan_fester",        -- Clan Fester
            "wh2_dlc15_skv_clan_ferrik",        -- Clan Ferrik
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

        factions_stage_2_cathay = {
            "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
        },

        factions_stage_3_lustria = {
            "wh2_main_skv_clan_pestilens",      -- Clan Pestilens (Skrolk)
            "wh2_main_skv_clan_skryre",         -- Clan Skryre (Ikit Claw)
        },

        factions_stage_4_karaz_ankor = {

            -- Major factions
            "wh2_main_skv_clan_mors",           -- Clan Mors (Queek)
            "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
            "wh2_main_skv_clan_moulder",        -- Clan Moulder (Throt)

            -- Minor factions
            "wh2_dlc15_skv_clan_ferrik",        -- Clan Ferrik
        },

        factions_stage_5_karaz_a_karak = {
            "wh2_main_skv_clan_mors",           -- Clan Mors (Queek)
        },
    },

    base_army_unit_count = 19,
    subcultures_banned_from_region_transfer = { -- If a player is playing as one of these, disable the region transfer of abandoned settlement.
        "wh3_main_sc_kho_khorne",               -- That's because these are subcultures with no staying power that focus on full destruction, and
                                                -- the region transfer causes the game to force them to play cat and mouse for a really long time.
    },

    regions_stage_1 = {

        -- Skavenbligth
        "wh3_main_combi_region_skavenblight",

        -- Estalia
        "wh3_main_combi_region_bilbali",
        "wh3_main_combi_region_montenas",
        "wh3_main_combi_region_tobaro",
        "wh3_main_combi_region_magritta",
        "wh3_main_combi_region_nuja",

        -- Tilea
        "wh3_main_combi_region_miragliano",
        "wh3_main_combi_region_riffraffa",
        "wh3_main_combi_region_luccini",

        -- Sartosa
        "wh3_main_combi_region_sartosa",
    },
    regions_stage_2_empire = {

        -- The Empire (random cities, this invasion must be smaller than the rest).
        "wh3_main_combi_region_wissenburg",
        "wh3_main_combi_region_ubersreik",
        "wh3_main_combi_region_middenheim",
    },
    regions_stage_2_araby = {

        -- Araby
        "wh3_main_combi_region_al_haikk",
        "wh3_main_combi_region_copher",
        "wh3_main_combi_region_fyrus",
    },
    regions_stage_2_cathay = {

        -- Cathay. Mainly an Eshin invasion.
        "wh3_main_combi_region_xing_po",
        "wh3_main_combi_region_kunlan",
        "wh3_main_combi_region_jade_wind_mountain",
        "wh3_main_combi_region_village_of_the_moon",
        "wh3_main_combi_region_tai_tzu",
        "wh3_main_combi_region_shrine_of_the_alchemist",
    },
    regions_stage_3 = {

        -- Lustria
        "wh3_main_combi_region_xlanhuapec",
        "wh3_main_combi_region_itza",
        "wh3_main_combi_region_tlaxtlan",
    },
    regions_stage_4 = {

        -- Karaz Ankor
        "wh3_main_combi_region_karak_kadrin",
        "wh3_main_combi_region_karak_eight_peaks",
        "wh3_main_combi_region_karak_azul",
        "wh3_main_combi_region_karak_hirn",
        "wh3_main_combi_region_barak_varr",
        "wh3_main_combi_region_zhufbar",
    },
    regions_stage_5 = {

        -- Final battle of the Karaz Ankor.
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
        wh2_dlc12_skv_clan_fester = { skaven = "lategame" },
        wh2_dlc15_skv_clan_ferrik = { skaven = "lategame" },
        wh2_main_skv_grey_seer_clan = { skaven = "lategame" },
        wh2_dlc16_skv_clan_gritus = { skaven = "lategame" },
        wh3_main_skv_clan_gritus = { skaven = "lategame" },
        wh2_dlc15_skv_clan_kreepus = { skaven = "lategame" },
        wh3_main_skv_clan_krizzor = { skaven = "lategame" },
        wh2_dlc12_skv_clan_mange = { skaven = "lategame" },
        wh3_main_skv_clan_morbidus = { skaven = "lategame" },
        wh2_main_skv_clan_septik = { skaven = "lategame" },
        wh3_main_skv_clan_skrat = { skaven = "lategame" },
        wh2_main_skv_clan_spittel = { skaven = "lategame" },
        wh3_main_skv_clan_treecherik = { skaven = "lategame" },
        wh2_dlc15_skv_clan_volkn = { skaven = "lategame" },
        wh3_main_skv_clan_verms = { skaven = "lategame" },
    },

    stage_1_warning_event_key = "wh3_main_ie_incident_endgame_vermintide_1",
    stage_1_warning_effect_key = "dyn_dis_vermintide_early_warning",
    stage_1_event_key = "dyn_dis_vermintide_stage_1_trigger",
    stage_2_event_key = "dyn_dis_vermintide_stage_2_trigger",
    stage_3_event_key = "dyn_dis_vermintide_stage_3_trigger",
    stage_4_event_key = "dyn_dis_vermintide_stage_4_trigger",
    stage_5_event_key = "dyn_dis_vermintide_stage_5_trigger",
    finish_before_stage_1_event_key = "dyn_dis_vermintide_finish_before_stage_1",
    finish_event_key = "dyn_dis_vermintide_finish",
    endgame_mission_name = "the_vermintide",
    effects_global_key = "dyn_dis_vermintide_global_effects",
    attacker_buffs_key = "dyn_dis_vermintide_attacker_buffs",
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

        -- This triggers stage one of the disaster if the disaster hasn't been cancelled.
        core:remove_listener("VermintideStage1");
        core:add_listener(
            "VermintideStage1",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay;
            end,

            -- If there are skaven alive, proceed with stage 1.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_before_stage_1_event_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_stage_1();
                end
                core:remove_listener("VermintideStage1")
            end,
            true
        );

        -- This triggers the ubersreik battle incident.
        -- TODO: move this to a fucking quest battle.
        core:remove_listener("VermintideUbersreikSetup");
        core:add_listener(
            "VermintideUbersreikSetup",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_0_ubersreik_battle_delay;
            end,

            -- If there are skaven alive, proceed with stage 1.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_before_stage_1_event_key, nil, 0, nil, nil, nil);
                    core:remove_listener("VermintideStage1")
                    self:finish();
                else
                    self:setup_ubersreik_battle();
                end
                core:remove_listener("VermintideUbersreikAttack")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_1 then

        -- This triggers stage two of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "VermintideStage2",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay;
            end,

            -- If there are skaven alive, proceed with stage 2.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_event_key, nil, 0, nil, nil, nil);
                    self:finish();
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("VermintideStage2")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_2 then

        -- This triggers stage three of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "VermintideStage3",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay;
            end,

            -- If there are skaven alive, proceed with stage 3.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_event_key, nil, 0, nil, nil, nil);
                else
                    self:trigger_stage_3();
                end
                core:remove_listener("VermintideStage3")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_3 then

        -- This triggers stage four of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "VermintideStage4",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay + self.settings.stage_4_delay;
            end,

            -- If there are skaven alive, proceed with stage 4.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_event_key, nil, 0, nil, nil, nil);
                else
                    self:trigger_stage_4();
                end
                core:remove_listener("VermintideStage4")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_4 then

        -- This triggers stage five of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "VermintideStage5",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay + self.settings.stage_4_delay + self.settings.stage_5_delay;
            end,

            -- If there are skaven alive, proceed with stage 5.
            function()
                if self:check_finish() then
                    dynamic_disasters:trigger_incident(self.finish_event_key, nil, 0, nil, nil, nil);
                else
                    self:trigger_stage_5();
                end
                core:remove_listener("VermintideStage5")
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
    dynamic_disasters:trigger_incident(self.stage_1_warning_event_key, self.stage_1_warning_effect_key, self.settings.stage_1_delay, nil, nil, nil);
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
        core:remove_listener("VermintideUbersreikBattle");
        core:remove_listener("VermintideUbersreikBattleCleanup");
        core:remove_listener("VermintideUbersreikBattleCleanupAfterRetreat");
        core:remove_listener("VermintideIkitWarpfuel");
        core:remove_listener("VermintideUnderEmpireExpansion");
        core:remove_listener("VermintideUnderEmpireImplosion");
        core:remove_listener("VermintideUbersreikSetup");
        core:remove_listener("VermintideStage1");
        core:remove_listener("VermintideStage2");
        core:remove_listener("VermintideStage3");
        core:remove_listener("VermintideStage4");
        core:remove_listener("VermintideStage5");

        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_vermintide:check_start()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers for stage 1.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Do not start if Clan Skryre is not available to use.
    if not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_1) then
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

    local base_chance = 0.0025;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
            base_chance = base_chance + 0.0025;
        end
    end

    -- If the chaos invasion has been triggered, get this up a 10%.
    for _, disaster in pairs(dynamic_disasters.disasters) do
        if disaster.name == "chaos_invasion" and disaster.settings.started == true and disaster.settings.finished == false then
            base_chance = base_chance + 10;
            break;
        end
    end

    if cm:random_number(100, 0) / 100 < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_vermintide:check_finish()

    -- Update the list of available factions and check if are all dead.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- If all skaven factions are dead, end the disaster. If not, check depending on the state we're about to trigger.
    if not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions) then
        return true;
    end

    -- If we haven't triggered the first stage, we need to check if Skryre is dead or alive with no home region. If so, we end the disaster here.
    if self.settings.status == STATUS_TRIGGERED then
        self.settings.factions_stage_1 = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_1);

        return not disaster_vermintide:is_skryre_available() or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_1);
    end

    -- If we're about to trigger Stage 2, make sure we have minor factions to do it. Otherwise, end the invasion here.
    if self.settings.status == STATUS_STAGE_1 then

        -- Update the list of available factions. Ignore cathay for ending the disaster as it's optional.
        self.settings.factions_stage_2_empire_and_araby = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_2_empire_and_araby);
        self.settings.factions_stage_2_cathay = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_2_cathay);

        return not disaster_vermintide:is_skryre_available() or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_2_empire_and_araby);
    end

    -- If we're about to trigger Stage 3, make sure either Skryre or Pestilens are still alive.
    if self.settings.status == STATUS_STAGE_2 then
        self.settings.factions_stage_3_lustria = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_3_lustria);

        return not disaster_vermintide:is_skryre_available() or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_3_lustria);
    end

    -- If we're about to trigger Stage 4, make sure we have factions for it.
    if self.settings.status == STATUS_STAGE_3 then
        self.settings.factions_stage_4_karaz_ankor = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_4_karaz_ankor);

        return not disaster_vermintide:is_skryre_available() or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_4_karaz_ankor);
    end

    if self.settings.status == STATUS_STAGE_4 then

        -- Check if Karaz-a-Karak belongs to the Dawi before anything else.
        local region = cm:get_region(self.regions_stage_5[1]);
        if not region == false and region:is_null_interface() then
            local region_owner = region:owning_faction();

            -- Stage 5 should only trigger if Karaz-a-Karak belongs to the dwarfs.
            if not region_owner == false and region_owner:is_null_interface() == false and region_owner:subculture() ~= "wh_main_sc_dwf_dwarfs" then
                return true
            end
        end

        -- If we're about to trigger Stage 5, make sure Clan Mors is still alive.
        self.settings.factions_stage_5_karaz_a_karak = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_5_karaz_a_karak);

        return not disaster_vermintide:is_skryre_available() or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.factions_stage_5_karaz_a_karak);
    end

    return false;
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to trigger the first stage of the Vermintide.
function disaster_vermintide:trigger_stage_1()
    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_2_delay = 1;
    else
        self.settings.stage_2_delay = cm:random_number(10, 6);
    end

    -- Spawn a few Skryre armies in Estalia, Tilea and Sartosa. Enough so they're able to expand next.
    -- If they're owned by the player, spawn the armies in the home region of Skryre instead.
    -- If Clan Skryre has no home region, spawn
    local army_count = math.floor(1.5 * self.settings.difficulty_mod)
    for _, faction_key in pairs(self.settings.factions_stage_1) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false then
            for _, region_key in pairs(self.regions_stage_1) do
                dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count, self.name, nil, { "wh2_main_skv_clan_skryre" })
            end

            -- Apply the relevant CAI changes only to Clan Skryre and declare the appropiate wars.
            cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
            dynamic_disasters:no_peace_no_confederation_only_war(faction_key, self.settings.enable_diplomacy)
            dynamic_disasters:declare_war_to_all(faction, {"wh2_main_sc_skv_skaven"}, true)
        end
    end

    -- Setup strategic under-cities for all factions available, including the recently resurrected ones.
    for _, faction_key in pairs(self.settings.factions) do

        out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ".");
        if self.initial_under_empire_placements[faction_key] ~= nil then

            -- Only spawn new armies here for dead main factions.
            if cm:get_faction(faction_key):is_dead() == true then
                dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, "wh3_main_combi_region_skavenblight", self.army_templates[faction_key], self.base_army_unit_count, false, army_count, self.name, nil, { "wh2_main_skv_clan_skryre" })
            end

            for _, region_key in pairs(self.initial_under_empire_placements[faction_key]) do

                out("Frodo45127: Setting up initial underempire for faction " .. faction_key .. ", region " .. region_key .. ".");
                local region = cm:get_region(region_key);
                self:expand_under_empire_adjacent_region_check(faction_key, region, {}, true, true, true)
            end
        end
    end

    -- Prepare the regions to reveal.
    dynamic_disasters:prepare_reveal_regions(self.regions_stage_1);

    -- Make sure every attacker is at peace with each other.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, false);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_2_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_1_event_key, self.effects_global_key, self.settings.stage_2_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Vermintide.
function disaster_vermintide:trigger_stage_2()

    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_3_delay = 1;
    else
        self.settings.stage_3_delay = cm:random_number(7, 4);
    end

    -- Spawn a few armies in the Empire, the northern coast of Araby and Cathay.
    local army_count_empire = math.ceil(1.5 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_2_empire) do
        local faction_key = self.settings.factions_stage_2_empire_and_araby[cm:random_number(#self.settings.factions_stage_2_empire_and_araby)];
        dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count_empire, self.name, nil, { "wh2_main_skv_clan_skryre" })
    end

    local army_count_araby = math.ceil(1.5 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_2_araby) do
        local faction_key = self.settings.factions_stage_2_empire_and_araby[cm:random_number(#self.settings.factions_stage_2_empire_and_araby)];
        dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count_araby, self.name, nil, { "wh2_main_skv_clan_skryre" })
    end

    -- The Attack on Cathay depends on Eshin being available to spawn.
    if #self.settings.factions_stage_2_cathay > 0 then
        local army_count_cathay = math.ceil(1.5 * self.settings.difficulty_mod)
        for _, region_key in pairs(self.regions_stage_2_cathay) do
            local faction_key = self.settings.factions_stage_2_cathay[cm:random_number(#self.settings.factions_stage_2_cathay)];
            dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count_cathay, self.name, nil, { "wh2_main_skv_clan_skryre" })
        end
    end

    -- From this stage, we force all skaven on the map to declare war on everyone a single faction faces.
    -- This includes owners of the attacked region, and owners of nearby regions. Even if its Skaven.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        cm:instantly_research_all_technologies(faction_key);
        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        dynamic_disasters:no_peace_no_confederation_only_war(faction_key, self.settings.enable_diplomacy)
        dynamic_disasters:declare_war_to_all(faction, {"wh2_main_sc_skv_skaven"}, true)
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_3_delay);

    -- Also, make sure they're added to the victory conditions.
    for _, faction_key in pairs(self.settings.factions) do
        table.insert(self.objectives[1].conditions, "faction " .. faction_key)
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.stage_2_event_key, nil, self.settings.factions[1], function () self:finish() end, true)
    dynamic_disasters:trigger_incident(self.stage_2_event_key, self.effects_global_key, self.settings.stage_3_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_2);
end

-- Function to trigger the third stage of the Vermintide.
function disaster_vermintide:trigger_stage_3()

    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_4_delay = 1;
    else
        self.settings.stage_4_delay = cm:random_number(6, 4);
    end

    -- Spawn a few armies in Lustria.
    local army_count = math.ceil(2 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_3) do
        local faction_key = self.settings.factions_stage_3_lustria[cm:random_number(#self.settings.factions_stage_3_lustria, 1)];
        dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count, self.name, nil, { "wh2_main_skv_clan_skryre" })
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_to_all(faction, {"wh2_main_sc_skv_skaven"}, true)
    end

    -- Prepare the regions to reveal.
    dynamic_disasters:prepare_reveal_regions(self.regions_stage_3);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_4_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_3_event_key, self.effects_global_key, self.settings.stage_4_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_3);
end

-- Function to trigger the fourth stage of the Vermintide.
function disaster_vermintide:trigger_stage_4()

    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_5_delay = 1;
    else
        self.settings.stage_5_delay = cm:random_number(10, 6);
    end

    -- Spawn a few armies along the Karak Ankor.
    local army_count = math.ceil(1.5 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_4) do
        local faction_key = self.settings.factions_stage_4_karaz_ankor[cm:random_number(#self.settings.factions_stage_4_karaz_ankor)];
        dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count, self.name, nil, { "wh2_main_skv_clan_skryre" })
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_to_all(faction, {"wh2_main_sc_skv_skaven"}, true)
    end

    -- Prepare the regions to reveal.
    dynamic_disasters:prepare_reveal_regions(self.regions_stage_4);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_5_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_4_event_key, self.effects_global_key, self.settings.stage_5_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_4);
end

-- Function to trigger the fifth stage of the Vermintide.
function disaster_vermintide:trigger_stage_5()

    -- Spawn a few armies in Karaz-a-Karak.
    local army_count = math.ceil(2 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_5) do
        local faction_key = self.settings.factions_stage_5_karaz_a_karak[cm:random_number(#self.settings.factions_stage_5_karaz_a_karak)];
        dynamic_disasters:create_scenario_force_with_backup_plan(faction_key, region_key, self.army_templates[faction_key], self.base_army_unit_count, false, army_count, self.name, nil, { "wh2_main_skv_clan_skryre" })
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_to_all(faction, {"wh2_main_sc_skv_skaven"}, true)
    end

    -- Prepare the regions to reveal.
    dynamic_disasters:prepare_reveal_regions(self.regions_stage_5);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.invasion_over_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_5_event_key, self.effects_global_key, self.settings.invasion_over_delay, nil, nil, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_5);
end

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

--- Function to check if Clan Skryre still has a home region.
function disaster_vermintide:is_skryre_available()
    local faction = cm:get_faction("wh2_main_skv_clan_skryre");
    if not faction == false and faction:is_null_interface() == false then
        return faction:has_home_region();
    end

    return false;
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

-------------------------------------------
-- Underempire expansion logic end
-------------------------------------------

return disaster_vermintide
