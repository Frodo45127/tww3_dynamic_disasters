--[[
	Script by Frodo45127 for the Dynamic Disasters mod.

    Large parts of it are extended functions from the endgames.lua files, for compatibility reasons.
]]

-- Global Dynamic Disasters manager object, to keep track of all disasters.
dynamic_disasters = {
    settings = {
        enabled = true,                         -- If the entire Dynamic Disasters system is enabled.
        debug = false,                          -- Debug mode. Forces all disasters to trigger and all in-between phase timers are reduced to 1 turn.
        victory_condition_triggered = false,    -- If a disaster has already triggered a victory condition, as we can't have two at the same time.
        max_endgames_at_the_same_time = 4,      -- Max amount of endgame crisis one can trigger at the same time, to space them out a bit.
        currently_running_endgames = 0,         -- Amount of currently running endgames.
    },
    disasters = {},                             -- List of disasters. This is populated on first tick.

    -- List of weigthed units used by the manager.
    --
    -- If you make a mod adding units and want them to appear in disaster-created armies, add them here with a weight.
    army_templates = {
        vampires = {
            lategame = {

                --Infantry
                wh_main_vmp_inf_skeleton_warriors_1 = 2,
                wh_main_vmp_inf_crypt_ghouls = 4,
                wh_main_vmp_inf_cairn_wraiths = 4,
                wh_main_vmp_inf_grave_guard_0 = 8,
                wh_main_vmp_inf_grave_guard_1 = 8,

                --Cavalry
                wh_main_vmp_cav_black_knights_3 = 2,
                wh_main_vmp_cav_hexwraiths = 1,
                wh_dlc02_vmp_cav_blood_knights_0 = 2,

                --Monsters
                wh_main_vmp_mon_fell_bats = 1,
                wh_main_vmp_mon_dire_wolves = 1,
                wh_main_vmp_mon_crypt_horrors = 4,
                wh_main_vmp_mon_vargheists = 4,
                wh_main_vmp_mon_varghulf = 2,
                wh_main_vmp_mon_terrorgheist = 2,

                --Vehicles
                wh_dlc04_vmp_veh_corpse_cart_1 = 1,
                wh_dlc04_vmp_veh_corpse_cart_2 = 1,
                wh_main_vmp_veh_black_coach = 1,
                wh_dlc04_vmp_veh_mortis_engine_0 = 1,
            },
        },
        greenskins = {
            lategame = {

                --Infantry
                wh_dlc06_grn_inf_nasty_skulkers_0 = 2,
                wh_main_grn_inf_night_goblins = 2,
                wh_main_grn_inf_night_goblin_fanatics = 2,
                wh_main_grn_inf_night_goblin_fanatics_1 = 2,
                wh_main_grn_inf_orc_boyz = 2,
                wh_main_grn_inf_orc_big_uns = 8,
                wh_main_grn_inf_savage_orcs = 3,
                wh_main_grn_inf_savage_orc_big_uns = 8,
                wh_main_grn_inf_black_orcs = 8,
                wh_main_grn_inf_night_goblin_archers = 2,
                wh_main_grn_inf_orc_arrer_boyz = 4,
                wh_main_grn_inf_savage_orc_arrer_boyz = 8,

                --Cavalry
                wh_main_grn_cav_goblin_wolf_riders_0 = 2,
                wh_main_grn_cav_goblin_wolf_riders_1 = 4,
                wh_main_grn_cav_goblin_wolf_chariot = 3,
                wh_main_grn_cav_forest_goblin_spider_riders_0 = 2,
                wh_main_grn_cav_forest_goblin_spider_riders_1 = 2,
                wh_dlc06_grn_cav_squig_hoppers_0 = 1,
                wh_main_grn_cav_orc_boar_boyz = 1,
                wh_main_grn_cav_orc_boar_boy_big_uns = 5,
                wh_main_grn_cav_orc_boar_chariot = 1,
                wh_main_grn_cav_savage_orc_boar_boyz = 2,
                wh_main_grn_cav_savage_orc_boar_boy_big_uns = 3,

                --Monsters
                wh_dlc06_grn_inf_squig_herd_0 = 2,
                wh_main_grn_mon_trolls = 3,
                wh_main_grn_mon_giant = 2,
                wh_main_grn_mon_arachnarok_spider_0 = 2,

                --Artillery
                wh_main_grn_art_goblin_rock_lobber = 2,
                wh_main_grn_art_doom_diver_catapult = 4,
            },
        },
        tomb_kings = {
            lategame = {

                --Infantry
                wh2_dlc09_tmb_inf_skeleton_warriors_0 = 2,
                wh2_dlc09_tmb_inf_skeleton_spearmen_0 = 2,
                wh2_dlc09_tmb_inf_tomb_guard_0 = 6,
                wh2_dlc09_tmb_inf_tomb_guard_1 = 8,
                wh2_dlc09_tmb_inf_nehekhara_warriors_0 = 8,
                wh2_dlc09_tmb_inf_skeleton_archers_0 = 4,

                --Cavalry
                wh2_dlc09_tmb_cav_skeleton_horsemen_0 = 4,
                wh2_dlc09_tmb_cav_nehekhara_horsemen_0 = 2,
                wh2_dlc09_tmb_veh_skeleton_chariot_0 = 2,
                wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 = 3,
                wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 = 6,
                wh2_dlc09_tmb_mon_sepulchral_stalkers_0 = 3,
                wh2_dlc09_tmb_cav_necropolis_knights_0 = 1,
                wh2_dlc09_tmb_cav_necropolis_knights_1 = 2,

                --Monsters
                wh2_dlc09_tmb_mon_carrion_0 = 4,
                wh2_dlc09_tmb_mon_ushabti_0 = 2,
                wh2_dlc09_tmb_mon_ushabti_1 = 4,
                wh2_dlc09_tmb_veh_khemrian_warsphinx_0 = 2,
                wh2_dlc09_tmb_mon_tomb_scorpion_0 = 4,
                wh2_dlc09_tmb_mon_heirotitan_0 = 2,
                wh2_dlc09_tmb_mon_necrosphinx_0 = 2,
                wh2_pro06_tmb_mon_bone_giant_0 = 4,

                --Artillery
                wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
                wh2_dlc09_tmb_art_casket_of_souls_0 = 3,
            },
        },
        empire = {
            lategame = {

                --Infantry
                wh_main_emp_inf_swordsmen = 5,
                wh_main_emp_inf_halberdiers = 5,
                wh_main_emp_inf_greatswords = 5,
                wh_main_emp_inf_crossbowmen = 2,
                wh_dlc04_emp_inf_free_company_militia_0 = 1,
                wh_main_emp_inf_handgunners = 3,

                --Cavalry
                wh_main_emp_cav_empire_knights = 4,
                wh_main_emp_cav_reiksguard = 1,
                wh_main_emp_cav_pistoliers_1 = 2,
                wh_main_emp_cav_outriders_0 = 1,
                wh_main_emp_cav_outriders_1 = 2,
                wh_dlc04_emp_cav_knights_blazing_sun_0 = 1,
                wh_main_emp_cav_demigryph_knights_0 = 2,
                wh_main_emp_cav_demigryph_knights_1 = 2,

                --Artillery
                wh_main_emp_art_mortar = 1,
                wh_main_emp_art_great_cannon = 1,
                wh_main_emp_art_helblaster_volley_gun = 1,
                wh_main_emp_art_helstorm_rocket_battery = 1,
            },
        },
        wood_elves = {
            lategame = {

                --Infantry
                wh_dlc05_wef_inf_eternal_guard_0 = 8,
                wh_dlc05_wef_inf_eternal_guard_1 = 12,
                wh_dlc05_wef_inf_dryads_0 = 4,
                wh_dlc05_wef_inf_wardancers_1 = 8,
                wh_dlc05_wef_inf_wildwood_rangers_0 = 4,
                wh_dlc05_wef_inf_glade_guard_2 = 12,
                wh_dlc05_wef_inf_deepwood_scouts_1 = 8,
                wh_dlc05_wef_inf_waywatchers_0 = 6,

                --Cavalry
                wh_dlc05_wef_cav_wild_riders_1 = 6,
                wh_dlc05_wef_cav_glade_riders_0 = 6,
                wh_dlc05_wef_cav_glade_riders_1 = 2,
                wh_dlc05_wef_cav_hawk_riders_0 = 1,
                wh_dlc05_wef_cav_sisters_thorn_0 = 1,

                --Monsters
                wh_dlc05_wef_mon_treekin_0 = 4,
                wh_dlc05_wef_mon_treeman_0 = 4,
                wh_dlc05_wef_mon_great_eagle_0 = 1,
                wh_dlc05_wef_forest_dragon_0 = 2,
            }
        },
        dwarfs = {
            lategame = {

                --Infantry
                wh_main_dwf_inf_miners_1 = 6,
                wh_main_dwf_inf_hammerers = 8,
                wh_main_dwf_inf_ironbreakers = 8,
                wh_main_dwf_inf_longbeards = 4,
                wh_main_dwf_inf_longbeards_1 = 8,
                wh_main_dwf_inf_slayers = 6,
                wh2_dlc10_dwf_inf_giant_slayers = 4,
                wh_main_dwf_inf_thunderers_0 = 8,
                wh_main_dwf_inf_irondrakes_0 = 4,
                wh_main_dwf_inf_irondrakes_2 = 6,
                wh_dlc06_dwf_inf_rangers_0 = 2,
                wh_dlc06_dwf_inf_rangers_1 = 4,
                wh_dlc06_dwf_inf_bugmans_rangers_0 = 2,

                --Artillery
                wh_main_dwf_art_grudge_thrower = 1,
                wh_main_dwf_art_cannon = 4,
                wh_main_dwf_art_organ_gun = 4,
                wh_main_dwf_art_flame_cannon = 2,

                --Vehicles
                wh_main_dwf_veh_gyrocopter_0 = 1,
                wh_main_dwf_veh_gyrocopter_1 = 1,
                wh_main_dwf_veh_gyrobomber = 1,
            },
        },
        lizardmen = {
            lategame = {

                --Infantry
                wh2_main_lzd_inf_saurus_spearmen_0 = 8,
                wh2_main_lzd_inf_saurus_spearmen_1 = 8,
                wh2_main_lzd_inf_saurus_warriors_0 = 8,
                wh2_main_lzd_inf_saurus_warriors_1 = 8,
                wh2_main_lzd_inf_chameleon_skinks_0 = 4,
                wh2_main_lzd_inf_temple_guards = 4,

                --Cavalry
                wh2_main_lzd_cav_cold_one_spearmen_1 = 2,
                wh2_main_lzd_cav_horned_ones_0 = 2,
                wh2_main_lzd_cav_cold_ones_1 = 2,
                wh2_dlc12_lzd_cav_ripperdactyl_riders_0 = 2, -- Not exactly cavalry, but on the category.

                --Monsters
                wh2_main_lzd_mon_kroxigors = 2,
                wh2_main_lzd_mon_kroxigors_blessed = 1,
                wh2_dlc13_lzd_mon_razordon_pack_0 = 1,
                wh2_dlc12_lzd_mon_salamander_pack_0 = 1,
                wh2_dlc12_lzd_mon_ancient_salamander_0 = 1,
                wh2_main_lzd_mon_bastiladon_1 = 1,
                wh2_main_lzd_mon_bastiladon_2 = 1,
                wh2_dlc12_lzd_mon_bastiladon_3 = 1,
                wh2_main_lzd_mon_ancient_stegadon = 1,
                wh2_dlc12_lzd_mon_ancient_stegadon_1 = 1,  -- Engine of the gods
                wh2_dlc17_lzd_mon_troglodon_0 = 1,
                wh2_main_lzd_mon_carnosaur_0 = 1,
                wh2_dlc13_lzd_mon_dread_saurian_1 = 1,
            },
        },
        vampire_coast = {
            earlygame = {

                --Melee Infantry
                wh2_dlc11_cst_inf_zombie_deckhands_mob_0 = 6,
                wh2_dlc11_cst_inf_zombie_deckhands_mob_1 = 6,
                wh2_dlc11_cst_inf_syreens = 2,

                --Ranged Infantry
                wh2_dlc11_cst_inf_zombie_gunnery_mob_0 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_1 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_2 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_3 = 4,

                wh2_dlc11_cst_cav_deck_droppers_0 = 1,
                wh2_dlc11_cst_cav_deck_droppers_1 = 1,
                wh2_dlc11_cst_cav_deck_droppers_2 = 1,

                --Monsters
                wh2_dlc11_cst_mon_animated_hulks_0 = 1,

                --Vehicles
                wh2_dlc11_cst_art_mortar = 1,
                wh2_dlc11_cst_art_carronade = 1,
            },
            midgame = {

                --Melee Infantry
                wh2_dlc11_cst_inf_zombie_deckhands_mob_0 = 4,
                wh2_dlc11_cst_inf_zombie_deckhands_mob_1 = 4,
                wh2_dlc11_cst_inf_depth_guard_0 = 2,
                wh2_dlc11_cst_inf_depth_guard_1 = 2,
                wh2_dlc11_cst_inf_syreens = 4,

                --Ranged Infantry
                wh2_dlc11_cst_inf_deck_gunners_0 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_0 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_1 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_2 = 4,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_3 = 4,

                wh2_dlc11_cst_cav_deck_droppers_0 = 2,
                wh2_dlc11_cst_cav_deck_droppers_1 = 2,
                wh2_dlc11_cst_cav_deck_droppers_2 = 2,

                --Monsters
                wh2_dlc11_cst_mon_rotting_leviathan_0 = 1,
                wh2_dlc11_cst_mon_mournguls_0 = 1,
                wh2_dlc11_cst_mon_necrofex_colossus_0 = 1,
                wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 = 1,
                wh2_dlc11_cst_mon_animated_hulks_0 = 2,

                --Vehicles
                wh2_dlc11_cst_art_mortar = 2,
                wh2_dlc11_cst_art_carronade = 2,
            },
            lategame = {

                --Melee Infantry
                wh2_dlc11_cst_inf_depth_guard_0 = 4,
                wh2_dlc11_cst_inf_depth_guard_1 = 4,
                wh2_dlc11_cst_inf_syreens = 4,

                --Ranged Infantry
                wh2_dlc11_cst_inf_deck_gunners_0 = 2,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_0 = 2,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_1 = 2,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_2 = 2,
                wh2_dlc11_cst_inf_zombie_gunnery_mob_3 = 2,
                wh2_dlc11_cst_cav_deck_droppers_0 = 1,
                wh2_dlc11_cst_cav_deck_droppers_1 = 1,
                wh2_dlc11_cst_cav_deck_droppers_2 = 1,

                --Monsters
                wh2_dlc11_cst_mon_rotting_leviathan_0 = 1,
                wh2_dlc11_cst_mon_terrorgheist = 1,
                wh2_dlc11_cst_mon_rotting_prometheans_0 = 1,
                wh2_dlc11_cst_mon_mournguls_0 = 1,
                wh2_dlc11_cst_mon_necrofex_colossus_0 = 2,
                wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0 = 1,

                --Vehicles
                wh2_dlc11_cst_art_mortar = 2,
                wh2_dlc11_cst_art_carronade = 2,
            },
        },
        dark_elves = {
            earlygame = {

                --Infantry
                wh2_main_def_inf_bleakswords_0 = 8,
                wh2_main_def_inf_dreadspears_0 = 8,
                wh2_main_def_inf_black_ark_corsairs_1 = 4,
                wh2_main_def_inf_darkshards_0 = 4,
                wh2_main_def_inf_darkshards_1 = 4,

                --Cavalry
                wh2_main_def_cav_dark_riders_0 = 2,
                wh2_main_def_cav_dark_riders_1 = 2,
                wh2_main_def_cav_dark_riders_2 = 2,

                --Monsters
                wh2_main_def_mon_war_hydra = 1,

                --Artillery
                wh2_main_def_art_reaper_bolt_thrower = 1,
            },
            midgame = {

                --Infantry
                wh2_main_def_inf_black_ark_corsairs_0 = 8,
                wh2_main_def_inf_black_ark_corsairs_1 = 8,
                wh2_main_def_inf_witch_elves_0 = 8,
                wh2_main_def_inf_darkshards_0 = 4,
                wh2_main_def_inf_darkshards_1 = 4,
                wh2_main_def_inf_shades_2 = 4,

                --Cavalry
                wh2_main_def_cav_dark_riders_0 = 2,
                wh2_main_def_cav_dark_riders_1 = 2,
                wh2_main_def_cav_dark_riders_2 = 2,
                wh2_main_def_cav_cold_one_knights_0 = 1,
                wh2_main_def_cav_cold_one_knights_1 = 1,

                --Monsters
                wh2_main_def_mon_war_hydra = 1,
                wh2_main_def_mon_black_dragon = 1,

                --Vehicles
                wh2_main_def_cav_cold_one_chariot = 1,

                --Artillery
                wh2_main_def_art_reaper_bolt_thrower = 1,
            },
            lategame = {

                --Infantry
                wh2_main_def_inf_black_guard_0 = 8,
                wh2_main_def_inf_har_ganeth_executioners_0 = 8,
                wh2_dlc10_def_inf_sisters_of_slaughter = 8,
                wh2_main_def_inf_shades_0 = 6,
                wh2_main_def_inf_shades_1 = 6,
                wh2_main_def_inf_shades_2 = 6,

                --Cavalry
                wh2_main_def_cav_cold_one_knights_0 = 2,
                wh2_main_def_cav_cold_one_knights_1 = 2,
                wh2_dlc10_def_cav_doomfire_warlocks_0 = 2,

                --Monsters
                wh2_main_def_mon_war_hydra = 1,
                wh2_dlc10_def_mon_kharibdyss_0 = 1,
                wh2_main_def_mon_black_dragon = 1,
                wh2_dlc14_def_mon_bloodwrack_medusa_0 = 1,

                --Vehicles
                wh2_main_def_cav_cold_one_chariot = 1,
                wh2_dlc14_def_cav_scourgerunner_chariot_0 = 1,

                --Artillery
                wh2_main_def_art_reaper_bolt_thrower = 1,
                wh2_dlc14_def_veh_bloodwrack_shrine_0 = 1,
            },
        },
        skaven = {
            lategame = {

                --Melee Infantry
                wh2_main_skv_inf_stormvermin_0 = 4,
                wh2_main_skv_inf_stormvermin_1 = 4,
                wh2_main_skv_inf_plague_monks = 4,

                --Ranged Infantry
                wh2_dlc12_skv_inf_ratling_gun_0 = 8,
                wh2_dlc12_skv_inf_warplock_jezzails_0 = 8,
                wh2_dlc14_skv_inf_poison_wind_mortar_0 = 4,
                wh2_main_skv_inf_death_globe_bombardiers = 4,

                --Monsters
                wh2_main_skv_mon_rat_ogres = 2,
                wh2_dlc16_skv_mon_brood_horror_0 = 2,
                wh2_main_skv_mon_hell_pit_abomination = 1,

                --Artillery
                wh2_main_skv_art_plagueclaw_catapult = 1,
                wh2_main_skv_art_warp_lightning_cannon = 1,
                wh2_main_skv_veh_doomwheel = 1,
                wh2_dlc12_skv_veh_doom_flayer_0 = 2,
            }
        },
        norsca = {
            earlygame = {

                --Infantry
                wh_main_nor_inf_chaos_marauders_0 = 8,
                wh_main_nor_inf_chaos_marauders_1 = 8,
                wh_dlc08_nor_inf_marauder_spearman_0 = 8,
                wh_dlc08_nor_inf_marauder_berserkers_0 = 2,
                wh_dlc08_nor_inf_marauder_hunters_0 = 4,
                wh_dlc08_nor_inf_marauder_hunters_1 = 4,

                --Cavalry
                wh_dlc08_nor_cav_marauder_horsemasters_0 = 3,
                wh_main_nor_cav_marauder_horsemen_1 = 3,
                wh_main_nor_cav_chaos_chariot = 4,

                --Monsters
                wh_dlc08_nor_mon_norscan_giant_0 = 1,
                wh_main_nor_mon_chaos_trolls = 2,
                wh_dlc08_nor_cha_skin_wolf_werekin_0 = 2,
            },
            midgame = {

                --Infantry
                wh_main_nor_inf_chaos_marauders_0 = 8,
                wh_main_nor_inf_chaos_marauders_1 = 8,
                wh_dlc08_nor_inf_marauder_spearman_0 = 4,
                wh_dlc08_nor_inf_marauder_berserkers_0 = 4,
                wh_dlc08_nor_inf_marauder_hunters_0 = 4,

                --Cavalry
                wh_dlc08_nor_cav_marauder_horsemasters_0 = 3,
                wh_main_nor_cav_marauder_horsemen_1 = 3,
                wh_main_nor_cav_chaos_chariot = 4,
                wh_dlc08_nor_veh_marauder_warwolves_chariot_0 = 2,

                --Monsters
                wh_dlc08_nor_mon_war_mammoth_1 = 1,
                wh_dlc08_nor_mon_norscan_giant_0 = 1,
                wh_dlc08_nor_mon_norscan_ice_trolls_0 = 2,
                wh_dlc08_nor_cha_skin_wolf_werekin_0 = 2,
            },
            lategame = {

                --Infantry
                wh_dlc08_nor_inf_marauder_champions_0 = 8,
                wh_dlc08_nor_inf_marauder_champions_1 = 8,
                wh_dlc08_nor_inf_marauder_berserkers_0 = 4,
                wh_dlc08_nor_inf_marauder_hunters_0 = 4,

                --Cavalry
                wh_dlc08_nor_cav_marauder_horsemasters_0 = 2,
                wh_main_nor_cav_marauder_horsemen_1 = 2,
                wh_dlc08_nor_veh_marauder_warwolves_chariot_0 = 1,

                --Monsters
                wh_dlc08_nor_mon_war_mammoth_1 = 1,
                wh_dlc08_nor_mon_war_mammoth_2 = 1,
                wh_dlc08_nor_mon_norscan_giant_0 = 1,
                wh_dlc08_nor_mon_norscan_ice_trolls_0 = 2,
                wh_dlc08_nor_mon_fimir_0 = 3,
                wh_dlc08_nor_mon_fimir_1 = 2,
            },
        },
        chaos = {
            earlygame = {

                --Infantry
                wh_main_chs_inf_chaos_marauders_0 = 8,
                wh_main_chs_inf_chaos_marauders_1 = 8,
                wh_main_chs_inf_chaos_warriors_1 = 4,
                wh_dlc01_chs_inf_chaos_warriors_2 = 4,
                wh_dlc01_chs_inf_forsaken_0 = 2,

                --Cavalry
                wh_dlc06_chs_cav_marauder_horsemasters_0 = 4,
                wh_main_chs_cav_chaos_chariot = 4,
                wh_dlc01_chs_cav_gorebeast_chariot = 1,
                wh_main_chs_cav_chaos_knights_0 = 1,

                --Monsters
                wh_main_chs_mon_chaos_warhounds_1 = 4,
                wh_dlc01_chs_mon_trolls_1 = 2,
                wh_main_chs_mon_chaos_spawn = 2,
                wh_dlc06_chs_feral_manticore = 2,
                wh_main_chs_mon_giant = 1,

                --Artillery
                wh_main_chs_art_hellcannon = 1,

                --Vehicles
                wh3_dlc20_chs_mon_warshrine = 1,
            },
            midgame = {

                --Infantry
                wh_main_chs_inf_chaos_warriors_1 = 8,
                wh_dlc01_chs_inf_chaos_warriors_2 = 8,
                wh_dlc01_chs_inf_forsaken_0 = 4,

                --Cavalry
                wh_dlc06_chs_cav_marauder_horsemasters_0 = 4,
                wh_main_chs_cav_chaos_chariot = 2,
                wh_dlc01_chs_cav_gorebeast_chariot = 1,
                wh_main_chs_cav_chaos_knights_0 = 1,

                --Monsters
                wh_main_chs_mon_chaos_warhounds_1 = 2,
                wh_dlc01_chs_mon_trolls_1 = 2,
                wh_main_chs_mon_chaos_spawn = 2,
                wh_dlc06_chs_feral_manticore = 2,
                wh_main_chs_mon_giant = 1,
                wh_dlc01_chs_mon_dragon_ogre = 1,

                --Artillery
                wh_main_chs_art_hellcannon = 1,

                --Vehicles
                wh3_dlc20_chs_mon_warshrine = 1,
            },
            lategame = {

                --Infantry
                wh_main_chs_inf_chaos_warriors_1 = 2,
                wh_dlc01_chs_inf_chaos_warriors_2 = 2,
                wh_dlc01_chs_inf_forsaken_0 = 4,
                wh_main_chs_inf_chosen_0 = 8,
                wh_main_chs_inf_chosen_1 = 6,
                wh_dlc01_chs_inf_chosen_2 = 6,

                --Cavalry
                wh_dlc06_chs_cav_marauder_horsemasters_0 = 2,
                wh_main_chs_cav_chaos_chariot = 2,
                wh_dlc01_chs_cav_gorebeast_chariot = 1,
                wh_main_chs_cav_chaos_knights_0 = 1,
                wh_main_chs_cav_chaos_knights_1 = 2,

                --Monsters
                wh_dlc06_chs_inf_aspiring_champions_0 = 2, -- They're not really monsters but they're a low entity unit like monsters
                wh_main_chs_mon_chaos_warhounds_1 = 2,
                wh_main_chs_mon_trolls = 3,
                wh_dlc01_chs_mon_trolls_1 = 2,
                wh_main_chs_mon_chaos_spawn = 2,
                wh_dlc06_chs_feral_manticore = 2,
                wh_main_chs_mon_giant = 2,
                wh_dlc01_chs_mon_dragon_ogre = 2,
                wh_dlc01_chs_mon_dragon_ogre_shaggoth = 2,

                --Artillery
                wh_main_chs_art_hellcannon = 1,

                --Vehicles
                wh3_dlc20_chs_mon_warshrine = 1,
            }
        },
        tzeentch = {
            earlygame = {

                --Melee Infantry
                wh3_dlc20_chs_inf_chaos_marauders_mtze = 8,
                wh3_dlc20_chs_inf_chaos_marauders_mtze_spears = 8,
                wh3_main_tze_inf_forsaken_0 = 2,

                --Ranged Infantry
                wh3_main_tze_inf_blue_horrors_0 = 4,
                wh3_main_tze_inf_pink_horrors_0 = 2,

                --Cavalry
                wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins = 1,
                wh3_main_tze_veh_burning_chariot_0 = 1,
                wh3_dlc20_chs_cav_chaos_chariot_mtze = 1,
                wh3_dlc20_chs_cav_chaos_knights_mtze_lances = 1,

                --Monsters
                wh3_main_tze_mon_spawn_of_tzeentch_0 = 2,
                wh3_dlc20_chs_mon_warshrine_mtze = 1,

                --Artillery
                wh_main_chs_art_hellcannon = 1,
                wh3_main_tze_mon_flamers_0 = 1,
            },
            midgame = {

                --Melee Infantry
                wh_main_chs_inf_chaos_warriors_0 = 6,
                wh_main_chs_inf_chaos_warriors_1 = 6,
                wh_dlc01_chs_inf_chaos_warriors_2 = 6,
                wh3_dlc20_chs_inf_chaos_warriors_mtze = 2,
                wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds = 2,
                wh3_main_tze_inf_forsaken_0 = 4,

                --Ranged Infantry
                wh3_main_tze_inf_blue_horrors_0 = 4,
                wh3_main_tze_inf_pink_horrors_0 = 2,
                wh3_main_tze_inf_pink_horrors_1 = 1,

                --Cavalry
                wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins = 1,
                wh3_main_tze_veh_burning_chariot_0 = 1,
                wh3_dlc20_chs_cav_chaos_chariot_mtze = 1,
                wh3_dlc20_chs_cav_chaos_knights_mtze_lances = 1,

                --Monsters
                wh3_main_tze_mon_spawn_of_tzeentch_0 = 2,
                wh3_dlc20_chs_mon_warshrine_mtze = 1,
                wh3_main_tze_mon_lord_of_change_0 = 1,

                --Artillery
                wh_main_chs_art_hellcannon = 1,
                wh3_main_tze_mon_flamers_0 = 1,
            },
            lategame = {

                --Melee Infantry
                wh3_dlc20_chs_inf_chaos_warriors_mtze = 2,
                wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds = 2,
                wh3_main_tze_inf_forsaken_0 = 4,
                wh3_dlc20_chs_inf_chosen_mtze = 8,
                wh3_dlc20_chs_inf_chosen_mtze_halberds = 6,

                --Ranged Infantry
                wh3_main_tze_inf_pink_horrors_0 = 2,
                wh3_main_tze_inf_pink_horrors_1 = 4,

                --Cavalry
                wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins = 2,
                wh3_main_tze_veh_burning_chariot_0 = 2,
                wh3_dlc20_chs_cav_chaos_chariot_mtze = 2,
                wh3_dlc20_chs_cav_chaos_knights_mtze_lances = 2,
                wh3_main_tze_cav_chaos_knights_0 = 1,
                wh3_main_tze_cav_doom_knights_0 = 2,

                --Monsters
                wh3_main_tze_mon_spawn_of_tzeentch_0 = 2,
                wh3_dlc20_chs_mon_warshrine_mtze = 1,
                wh3_main_tze_mon_lord_of_change_0 = 1,

                --Artillery
                wh3_main_tze_mon_flamers_0 = 2,
                wh3_main_tze_mon_exalted_flamers_0 = 1,
                wh3_main_tze_mon_soul_grinder_0 = 1,
            }
        },
    }
};

-- Settings required for all disasters. If missing, this manager will add them to each disaster with these values.
local mandatory_settings = {
    enabled = true,                     -- If the disaster is enabled or not.
    started = false,                    -- If the disaster has been started.
    finished = false,                   -- If the disaster has been finished.
    repeteable = false,                 -- If the disaster can be repeated.
    is_endgame = true,                  -- If the disaster is an endgame.
    min_turn = 60,                      -- Minimum turn required for the disaster to trigger.
    max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
    status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
    last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
    last_finished_turn = 0,             -- Turn when the disaster was last finished.
    wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
    difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
    campaigns = {},                     -- Campaigns this disaster works on.
}

--[[
    MCT Helpers, so the users can configure the disasters as they want.
]]--

-- Listener to initialize the mod from the MCT settings, if available.
core:add_listener(
    "DynamicDisastersSettingsLoader",
    "MctInitialized",
    true,
    function(context)
        dynamic_disasters:load_from_mct(context:mct());
    end,
    true
)

-- Listener to update the mod mid-campaign from the MCT settings, if available.
core:add_listener(
    "DynamicDisastersSettingsMidCamnpaignLoader",
    "MctFinalized",
    true,
    function(context)
        dynamic_disasters:load_from_mct(context:mct());
    end,
    true
)

-- Function to load settings from the mct.
---@param mct object #MCT object.
function dynamic_disasters:load_from_mct(mct)
    local mod = mct:get_mod_by_key("dynamic_disasters")

    local dynamic_disasters_enable = mod:get_option_by_key("dynamic_disasters_enable")
    local dynamic_disasters_enable_setting = dynamic_disasters_enable:get_finalized_setting()
    self.settings.enabled = dynamic_disasters_enable_setting

    local dynamic_disasters_debug = mod:get_option_by_key("dynamic_disasters_debug")
    local dynamic_disasters_debug_setting = dynamic_disasters_debug:get_finalized_setting()
    self.settings.debug = dynamic_disasters_debug_setting

    local dynamic_disasters_max_simul = mod:get_option_by_key("dynamic_disasters_max_simul")
    local dynamic_disasters_max_simul_setting = dynamic_disasters_max_simul:get_finalized_setting()
    self.settings.max_endgames_at_the_same_time = dynamic_disasters_max_simul_setting

    for _, disaster in pairs(self.disasters) do
        local disaster_enable = mod:get_option_by_key(disaster.name .. "_enable");
        if not disaster_enable == false then
            local disaster_enable_setting = disaster_enable:get_finalized_setting();
            disaster.settings.enabled = disaster_enable_setting;
        end

        local min_turn = mod:get_option_by_key(disaster.name .. "_min_turn_value");
        if not min_turn == false then
            local min_turn_setting = min_turn:get_finalized_setting();
            disaster.settings.min_turn = min_turn_setting;
        end

        local max_turn = mod:get_option_by_key(disaster.name .. "_max_turn_value");
        if not max_turn == false then
            local max_turn_setting = max_turn:get_finalized_setting();
            disaster.settings.max_turn = max_turn_setting;
        end

        local difficulty_mod = mod:get_option_by_key(disaster.name .. "_difficulty_mod");
        if not difficulty_mod == false then
            local difficulty_mod_setting = difficulty_mod:get_finalized_setting();
            disaster.settings.difficulty_mod = difficulty_mod_setting / 100;
        end
    end
end

--[[
    End of MCT Helpers.
]]--

-- Function to setup the save/load from savegame logic for items.
--
-- Pretty much a reusable function to load data from save and set it to be saved on the next save.
---@param item table #Object/Table to save. It MUST CONTAIN a settings node, as that's what it really gets saved.
---@param save_key string #Unique key to identify the saved data.
local function setup_save(item, save_key)
    local old_data = cm:get_saved_value(save_key);
    if old_data ~= nil then
       item.settings = old_data;
    end
    cm:set_saved_value(save_key, item.settings);
end

-- Initialise the disasters available, reading the files from the dynamic_disasters folder preparing the manager.
--
-- Extended from endgames.lua to keep things more or less compatible.
cm:add_first_tick_callback(
    function()

        -- Look for dynamic disaster files and load them into the framework
        local disaster_files = core:get_filepaths_from_folder("/script/campaign/dynamic_disasters/", "*.lua")
        out("####################")
        out("Frodo45127: Loading the following disasters from /script/campaign/dynamic_disasters/:")
        local disasters_loaded = {}
        local env = core:get_env()

        for i = 1, #disaster_files do
            local disaster_filepath = disaster_files[i]
            local disaster_name = tostring(string.sub(disaster_filepath, 35, (string.len(disaster_filepath)-4)))

            -- Make sure the file is loaded correctly, skip its inclusion if not
            local loaded_file, load_error = loadfile(disaster_filepath)
            if loaded_file then

                -- Make sure the file is set as loaded
                package.loaded[disaster_filepath] = true

                -- Set the environment of the Lua chunk to the global environment
                -- Note to future me: removing this makes the disasters unable to load core listeners. Do not remove it.
                setfenv(loaded_file, env)

                -- Execute the loaded Lua chunk so the functions within are registered
                local disaster_executed_successfully, result = pcall(loaded_file)
                if not disaster_executed_successfully then
                    out("\tFailed to execute loaded disaster file [" .. disaster_name .. "], error is: " .. tostring(result))
                else
                    -- Add the disaster to our loaded disasters list.
                    out("\t"..disaster_name.." loaded successfully")
                    table.insert(disasters_loaded, result)
                end

            -- If the disaster failed to load, report it.
            else
                out("\tFailed to load disaster file [" .. disaster_name .. "], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:")
                local path_no_lua =  tostring(string.sub(disaster_filepath, 0, (string.len(disaster_filepath)-4)))
                local require_result, require_error = pcall(require, path_no_lua)

                if require_result then
                    out("\tWARNING: require() seemed to be able to load file [" .. disaster_filepath .. "] with filename [" .. disaster_name .. "], where loadfile failed? Maybe the scenario is loaded, maybe it isn't - proceed with caution!")
                else
                    -- strip tab and newline characters from error string
                    out("\t\t" .. string.gsub(string.gsub(require_error, "\t", ""), "\n", ""))
                end

            end
        end

        -- Once loaded, we need to check if the disaster is available for our campaign/faction.
        local faction_name = cm:get_local_faction_name();
        local faction = cm:get_faction(faction_name);
        local campaign_key = cm:get_campaign_name();

        for _, disaster in pairs(disasters_loaded) do

            -- Check that it has all the required settings, and initialize them in case it has them missing.
            for setting, value in pairs(mandatory_settings) do
                if disaster.settings[setting] == nil then
                    disaster.settings[setting] = value;
                    out("\tDisaster: "..disaster.name..". Missing setting: ".. setting .. ". Initializing to default value.")
                end
            end

            -- Check that the disaster supports the campaign we're loading into.
            -- Each disaster must manually specify which campaign map supports, as it will probably need custom tweaks for each map.
            local allowed_in_campaign = false;
            for _, campaign_supported in pairs(disaster.settings.campaigns) do
                if campaign_supported == campaign_key then
                    allowed_in_campaign = true;
                    break
                end
            end

            if allowed_in_campaign then

                -- Global disasters may be blacklisted for certain subcultures.
                if disaster.is_global == true then
                    local allowed = true;

                    for _, subculture in pairs(disaster.denied_for_sc) do
                        if subculture == faction:subculture() then
                            allowed = false
                        end
                    end

                    if allowed == true then
                        table.insert(dynamic_disasters.disasters, disaster)
                    end

                -- If the disaster is not global, check if it's allowed and not denied for your subculture.
                else
                    local allowed = false;

                    for _, subculture in pairs(disaster.allowed_for_sc) do
                        if subculture == faction:subculture() then
                            allowed = true
                        end
                    end

                    if allowed == true then
                        for _, subculture in pairs(disaster.denied_for_sc) do
                            if subculture == faction:subculture() then
                                allowed = false
                            end
                        end

                        if allowed == true then
                            table.insert(dynamic_disasters.disasters, disaster)
                        end
                    end
                end
            end
        end

        if #dynamic_disasters.disasters > 0 then
            out(#dynamic_disasters.disasters.." total disasters loaded successfully.")
            out("####################")
        else
            out("0 disasters loaded.")
            out("####################")
            return
        end

        -- Once all disasters are loaded, get their settings from the mct if available.
        if get_mct then
            dynamic_disasters:load_from_mct(get_mct());
        end

        -- Once all the disasters are loaded, setup saving-restoring data from save.
        setup_save(dynamic_disasters, "dynamic_disasters_settings")
        for _, disaster in ipairs(dynamic_disasters.disasters) do
            setup_save(disaster, disaster.name .. "_settings");

            -- Make sure to initialize listeners of already in-progress disasters.
            if disaster.settings.started == true then
                disaster:set_status(disaster.settings.status);
            end
        end

        -- There's a thing going on with two different victory conditions getting triggered (it bugs out the victory missions panel)
        -- so we need to make sure that none of the vanilla endgames are triggered before allowing this to trigger victory conditions.
        if endgame.settings.endgame_enabled == true then
            dynamic_disasters.settings.victory_condition_triggered = true;
        end

        -- Listener for evaluating if a disaster can be started or not. Triggered at the begining of each turn.
        core:add_listener(
            "ScriptEventMaybeDisasterTime",
            "WorldStartRound",
            true,
            function ()
                return dynamic_disasters:process_disasters()
            end,
            true
        );
    end
)

-- Function to process all the disasters available and trigger them when they can be triggered.
--
-- This function only takes care of starting the disaster's own logic. Once it starts, this leaves the disaster do its thing.
function dynamic_disasters:process_disasters()

    -- Only process disasters if we enabled the mod.
    if self.settings.enabled == true then

        out("Frodo45127: Processing disasters on turn " .. cm:turn_number() .. ".");
        for _, disaster in ipairs(self.disasters) do
            out("Frodo45127: Processing disaster ".. disaster.name);
            if disaster.settings.enabled == true then

                -- If it's already done, check if it's repeteable.
                if disaster.settings.finished == true then

                    -- If it's repeteable, try to trigger it again.
                    if disaster.settings.repeteable == true then
                        if disaster.settings.last_finished_turn > 0 and cm:turn_number() - disaster.settings.last_finished_turn > disaster.settings.wait_turns_between_repeats then
                            if disaster.settings.is_endgame == false or (disaster.settings.is_endgame == true and self.settings.currently_running_endgames < self.settings.max_endgames_at_the_same_time) then

                                if disaster:check_start_disaster_conditions() then
                                    out("Frodo45127: Disaster " .. disaster.name .. " triggered (repeated trigger).");
                                    disaster.settings.finished = false;
                                    disaster.settings.started = true;
                                    disaster.settings.last_triggered_turn = cm:turn_number();

                                    if disaster.settings.is_endgame == true then
                                        self.settings.currently_running_endgames = self.settings.currently_running_endgames + 1;
                                    end

                                    disaster:trigger();
                                end
                            end
                        end
                    end

                -- If it's not yet started, check if we have the minimum requirements to start it.
                elseif disaster.settings.started == false then
                    if cm:turn_number() >= disaster.settings.min_turn and (disaster.settings.is_endgame == false or (disaster.settings.is_endgame == true and self.settings.currently_running_endgames < self.settings.max_endgames_at_the_same_time)) then
                        if disaster:check_start_disaster_conditions() then
                            out("Frodo45127: Disaster " .. disaster.name .. " triggered (first trigger).");
                            disaster.settings.started = true;
                            disaster.settings.last_triggered_turn = cm:turn_number();

                            if disaster.settings.is_endgame == true then
                                self.settings.currently_running_endgames = self.settings.currently_running_endgames + 1;
                            end

                            disaster:trigger();
                        end
                    end
                end
            end
        end
    end
end

-- Function to cleanup after a disaster has finished.
---@param disaster table #Object/table of the disaster to finish.
function dynamic_disasters:finish_disaster(disaster)
    disaster.settings.finished = true;
    disaster.settings.started = false;
    disaster:set_status(0);
    disaster.settings.last_finished_turn = cm:turn_number();

    if disaster.settings.is_endgame == true then
        self.settings.currently_running_endgames = self.settings.currently_running_endgames - 1;
    end
end

-- Function to trigger an incident for a phase of a disaster. It can have an associated effect and a payload that lasts the provided duration.
---@param incident_key string #Incident key for the incident this function will trigger. Must exists in the DB.
---@param effect_bundle_key string #Optional. Effect Bundle key for the effect bundle to trigger with this incident. Must exists in the DB.
---@param duration integer #Optional. Duration for the effect bundle.
---@param region_key string #Optional. Region key for the region this incident will allow to zoom in.
function dynamic_disasters:execute_payload(incident_key, effect_bundle_key, duration, region_key)
    if duration == nil then
        duration = 0;
    end

    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        local incident_builder = cm:create_incident_builder(incident_key)
        local payload_builder = cm:create_payload()

        -- If we got no effect, just trigger the incident without payload.
        if effect_bundle_key ~= nil then
            local payload = cm:create_new_custom_effect_bundle(effect_bundle_key)
            payload:set_duration(duration)
            payload_builder:effect_bundle_to_faction(payload)
        end

        -- This doesn't work.
        --if region_key ~= nil then
        --    incident_builder:set_region(region_key);
        --end

        incident_builder:set_payload(payload_builder)
        cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(human_factions[i]))
    end
end

-- Function to add a victory condition linked to a disaster. Do not trigger this twice, as it messes up the Victory Conditions panel.
---@param incident_key string #Incident key for the incident this function will trigger. Must exists in the DB.
---@param objectives table #Takes the objectives generated by the victory-specific functions, or a table manually generated with the objectives data.
---@param target_region_key string #Optional. Region key that will be zoom in when clicking on the dilemma.
---@param target_faction_key string #Optional. Faction key of the faction that will be zoom in when clicking on the dilemma.
function dynamic_disasters:add_victory_condition(incident_key, objectives, target_region_key, target_faction_key)
    local target_region_cqi = 0;
    local target_faction_cqi = 0;

    if not target_region_key == nil then
        target_region_cqi = cm:get_region(target_region_key):cqi();
    end

    if not target_faction_key == nil then
        target_faction_cqi = cm:get_region(target_faction_key):cqi();
    end

    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
        cm:trigger_incident_with_targets(
            cm:get_faction(human_factions[i]):command_queue_index(),
            incident_key,
            target_faction_cqi,
            0,
            0,
            0,
            target_region_cqi,
            0
        )
    end

    self.settings.victory_condition_triggered = true;
end

-- Function to spawn armies at a specific land region on the campaign map. This ensures the spawn position is valid within the region.
-- If passed an invalid/sea region, this function will fail.
---@param faction_key string #Faction key of the owner of the armies.
---@param region_key string #Land region key used for spawning and declaring war.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param declare_war boolean #If war should be declared between the owner of the armies and the owner of the region where they'll spawn.
---@param total_armies integer #Amount of armies to spawn. If not provided, it'll spawn 1.
---@param disaster_name string #Name of the disaster that will use this army.
function dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, unit_count, declare_war, total_armies, disaster_name)

    -- total_armies shouldn't be nil, but if it is assume we want a single army
    if total_armies == nil then
        total_armies = 1
    end

    for i = 1, total_armies do
        local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 10)
        local unit_list = self:generate_random_army(army_template, unit_count, disaster_name)

        cm:create_force(
            faction_key,
            unit_list,
            region_key,
            pos_x,
            pos_y,
            false,
            function(cqi)
                local character = cm:char_lookup_str(cqi)
                cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
                cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
                cm:add_agent_experience(character, cm:random_number(25, 15), true)
                cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
            end
        )
    end

    if declare_war then
        local invasion_faction = cm:get_faction(faction_key)
        local region_owning_faction = cm:get_region(region_key):owning_faction()
        if region_owning_faction:is_null_interface() == false and faction_key ~= region_owning_faction:name() and region_owning_faction:name() ~= "rebels" and invasion_faction:at_war_with(region_owning_faction) == false then
            out("ENDGAME: Declaring war between "..faction_key.." and "..region_owning_faction:name())
            cm:force_declare_war(faction_key, region_owning_faction:name(), false, false)
        end
    end

end

-- Function to spawn armies at specific coordinates on the campaign map. This ensures the spawn position is valid within 15 hex of the coordinates.
-- If passed a coordinate that has no valid position within range, this function will fail.
---@param faction_key string #Faction key of the owner of the armies.
---@param region_key string #Land region key used for spawning and declaring war. If spawning at sea, just provide a valid one.
---@param coords table #Table with X/Y coordinates around which the armies should spawn.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param declare_war boolean #If war should be declared between the owner of the armies and the owner of the region where they'll spawn.
---@param total_armies integer #Amount of armies to spawn. If not provided, it'll spawn 1.
---@param disaster_name string #Name of the disaster that will use this army.
function dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, coords, army_template, unit_count, declare_war, total_armies, disaster_name)

    -- total_armies shouldn't be nil, but if it is assume we want a single army
    if total_armies == nil then
        total_armies = 1
    end

    for i = 1, total_armies do
        local unit_list = self:generate_random_army(army_template, unit_count, disaster_name)
        local x, y = cm:find_valid_spawn_location_for_character_from_position(faction_key, coords[1], coords[2], false, 15);

        cm:create_force(
            faction_key,
            unit_list,
            region_key,
            x,
            y,
            false,
            function(cqi)
                local character = cm:char_lookup_str(cqi)
                cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
                cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
                cm:add_agent_experience(character, cm:random_number(25, 15), true)
                cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
            end
        )
    end

    if declare_war then
        local invasion_faction = cm:get_faction(faction_key)
        local region_owning_faction = cm:get_region(region_key):owning_faction()
        if region_owning_faction:is_null_interface() == false and faction_key ~= region_owning_faction:name() and region_owning_faction:name() ~= "rebels" and not invasion_faction == false and invasion_faction:at_war_with(region_owning_faction) == false then
            out("Frodo45127: Declaring war between "..faction_key.." and "..region_owning_faction:name())
            cm:force_declare_war(faction_key, region_owning_faction:name(), false, false)
        end
    end
end

-- Function to reveal a bunch of regions for the players, if they can't see them yet.
---@param regions table #List of land region keys.
function dynamic_disasters:reveal_regions(regions)
    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        for i2 = 1, #regions do
            cm:make_region_visible_in_shroud(human_factions[i], regions[i2]);
        end
    end
end

-- Function to generate random armies based on a combination of templates. Allows combination between different templates.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param disaster_name string #Name of the disaster that will use this army.
---@return string #A comma separated string of units to spawn in the army.
function dynamic_disasters:generate_random_army(army_template, unit_count, disaster_name)
    local ram = random_army_manager
    ram:remove_force(disaster_name)
    ram:new_force(disaster_name)

    for race, template_type in pairs(army_template) do
        for unit, weight in pairs(self.army_templates[race][template_type]) do
            ram:add_unit(disaster_name, unit, weight)
        end
    end

    return ram:generate_force(disaster_name, unit_count, false);
end

-- Function to remove all confederated factions from the provided list of factions, returning the new faction key list.
---@param factions table #Faction keys to check for confederation.
---@return table #Indexed table with the non-confederated faction keys.
function dynamic_disasters:remove_confederated_factions_from_list(factions)
    local clean_factions = {};
    for i = 1, #factions do
        local faction = cm:get_faction(factions[i]);
        if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
           table.insert(clean_factions, factions[i]);
        end
    end

    return clean_factions;
end


-- Function to declare war on all region owners of provided regions, and optionally on all neigthbors of the provided faction.
--
-- TODO: Make this function allow to ignore allies when declaring war.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object
---@param regions table #Region keys to declare war to.
---@param attack_faction_neightbors boolean #If we should declare war on all the current faction neighbours too.
---@param subcultures_to_ignore table #List of subcultures to ignore on war declarations.
function dynamic_disasters:declare_war_for_owners_and_neightbours(faction, regions, attack_faction_neightbors, subcultures_to_ignore)
    if faction:is_null_interface() == false then

        -- First, declare war on the explicitly provided region owners and its neightbor regions.
        for _, region_key in pairs(regions) do
            local region = cm:get_region(region_key);
            if region:is_null_interface() == false then

                -- Try to declare war on its neighbors first, so we don't depend on the status of the current region.
                self:declare_war_on_adjacent_region_owners(faction, region, subcultures_to_ignore)

                -- Then get if the current region is occupied and try to declare war on the owner.
                local region_owner = region:owning_faction()
                if region_owner:is_null_interface() == false then

                    -- Get if we should ignore the curreent region.
                    local region_subculture = region_owner:subculture();
                    local ignore_region = false;
                    for j = 1, #subcultures_to_ignore do
                        if subcultures_to_ignore[j] == region_subculture then
                            ignore_region = true;
                            break;
                        end
                    end

                    -- If the current region is not to be ignored, declate war on the owner.
                    if ignore_region == false and region_owner:name() ~= "rebels" and not faction:at_war_with(region_owner) then
                        cm:force_declare_war(faction:name(), region_owner:name(), false, true)
                    end
                end
            end
        end

        -- If we also want to attack all the faction's physical neighbors, find all the faction's regions and declare war aplenty.
        if attack_faction_neightbors then
            local region_list = faction:region_list();
            for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i);
                if region:is_null_interface() == false then

                    -- Try to declare war on its neighbors first, so we don't depend on the status of the current region.
                    self:declare_war_on_adjacent_region_owners(faction, region, subcultures_to_ignore)
                end
            end
        end
    end
end

-- Function to declare war on all region owners of regions adjacent to a specific region.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object
---@param base_region REGION_SCRIPT_INTERFACE #Region object
---@param subcultures_to_ignore table #List of subcultures to ignore on war declarations.
function dynamic_disasters:declare_war_on_adjacent_region_owners(faction, base_region, subcultures_to_ignore)
    if base_region:is_null_interface() == false then
        local adjacent_regions = base_region:adjacent_region_list()

        for i = 0, adjacent_regions:num_items() - 1 do
            local region = adjacent_regions:item_at(i)

            -- Ignore abandoned regions.
            if region:is_abandoned() == false then
                local region_owner = region:owning_faction()
                if region_owner:is_null_interface() == false then

                    -- Get if we should ignore the curreent region.
                    local region_subculture = region_owner:subculture();
                    local ignore_region = false;
                    for j = 1, #subcultures_to_ignore do
                        if subcultures_to_ignore[j] == region_subculture then
                            ignore_region = true;
                            break;
                        end
                    end

                    if ignore_region == false and region_owner:name() ~= "rebels" and not faction:at_war_with(region_owner) then
                        endgame:declare_war(faction:name(), region_owner:name())
                    end
                end
            end
        end
    end
end
