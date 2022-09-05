--[[
    Aztec Invasion disaster, By Frodo45127.

    This disaster consists in a coastal invasion by Lizarmen, to restore the... status of the world according to the great plan.
    Meaning, the classic "There is no problem with others if there is no others" solution.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.5% (1/200 turns).
        - +0.5% for each Lizardmen faction that has been wiped out (not confederated).
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/First Warning:
            - Message of warning about rumors of weird ships.
            - Small debuf to sea trade.
            - Wait 3-6 turns for more info.
        - Second Warning:
            - Message of warning about weird ships made of rocks.
            - Medium debuf to sea trade.
            - Wait 3-6 turns for more info.
        - Invasion:
            - All major non-confederated lizardmen factions declare war on owner of coasts if not lizard.
            - All major non-confederated lizardmen factions gets disabled diplomacy and full-retard AI.
            - Spawn lizardmen armies on all coasts not belonging to them.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
        - Finish:
            - All lizard factions destroyed.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STARTED = 2;

-- Object representing the disaster.
disaster_aztec_invasion = {
    name = "aztec_invasion",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = { "wh2_main_sc_lzd_lizardmen" },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid"
            }
        }
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {

        -- Common data for all disasters.
        enabled = true,                     -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = true,                  -- If the disaster is an endgame.
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        -- Disaster-specific data.
        second_warning_delay = 1,
        invasion_delay = 1,
        army_template = {
            lizardmen = "lategame"
        },
        base_army_unit_count = 19,
    },

    first_warning_event_key = "fro_dyn_dis_aztec_invasion_warning_1",
    second_warning_event_key = "fro_dyn_dis_aztec_invasion_warning_2",
    invasion_event_key = "fro_dyn_dis_aztec_invasion_trigger",
    ai_personality = "fro_dyn_dis_wh3_combi_lizardmen_endgame",
}

-- Potential areas of invasion. It containes a table with area-of-invasion -> [regions to invade from].
--
-- NOTE: This one is global so other disasters can use it too.
dyn_dis_sea_potential_attack_vectors = {

    -- Cathay's eastern coast, north.
    wh3_main_combi_region_northern_straits_of_the_jade_sea = {
        scale = 2,
        spawn_positions = {
            {1375, 597},
            {1377, 535},
        },
        coastal_regions = {
            "wh3_main_combi_region_beichai",
            "wh3_main_combi_region_haichai",
        }
    },

    -- Cathay's eastern coast, mid and south.
    wh3_main_combi_region_the_jade_sea = {
        scale = 3,
        spawn_positions = {
            {1408, 365},
            {1390, 496},
        },
        coastal_regions = {
            "wh3_main_combi_region_dai_cheng",
            "wh3_main_combi_region_li_zhu",
            "wh3_main_combi_region_fu_chow",
        }
    },

    -- Islands south of Ind.
    wh3_main_combi_region_the_eastern_isles = {
        spawn_positions = {
            {961, 66},
            {898, 99},
            {955, 180},
        },
        coastal_regions = {
            "wh3_main_combi_region_tower_of_the_sun",
            "wh3_main_combi_region_tor_elasor",
            "wh3_main_combi_region_tower_of_the_stars",
        }
    },

    -- Cathay's Great Channel.
    wh3_main_combi_region_eastern_sea_of_dread = {
        spawn_positions = {
            {1236, 302},
        },
        coastal_regions = {
            "wh3_main_combi_region_fu_hung",
            "wh3_main_combi_region_waili_village",
        }
    },

    -- Sea east of Norsca
    wh3_main_combi_region_frozen_sea = {
        spawn_positions = {
            {800, 797},
            {705, 870},
            {778, 827},
        },
        coastal_regions = {
            "wh3_main_combi_region_port_of_secrets",
            "wh3_main_combi_region_the_tower_of_torment",
            "wh3_main_combi_region_stormvrack_mount",
            "wh3_main_combi_region_tribeslaughter",
            "wh3_main_combi_region_temple_of_heimkel",
            "wh3_main_combi_region_frozen_landing",
            "wh3_main_combi_region_sjoktraken",
            "wh3_main_combi_region_kraka_drak",
        }
    },

    -- Sea north/east of Norsca
    wh3_main_combi_region_kraken_sea = {
        spawn_positions = {
            {676, 883},
            {660, 893},
            {568, 902},
        },
        coastal_regions = {
            "wh3_main_combi_region_monolith_of_flesh",
            "wh3_main_combi_region_bilious_cliffs",
            "wh3_main_combi_region_black_rock",
            "wh3_main_combi_region_altar_of_spawns",
            "wh3_main_combi_region_winter_pyre",
            "wh3_main_combi_region_the_tower_of_flies",
        }
    },

    -- Coast north of the Great Ocean
    wh3_main_combi_region_the_shard_coast = {
        spawn_positions = {
            {292, 830},
            {359, 838},
        },
        coastal_regions = {
            "wh3_main_combi_region_shagrath",
            "wh3_main_combi_region_nagrar",
        }
    },

    -- Coast south/east of Lustria
    wh3_main_combi_region_mangrove_coast_sea = {
        spawn_positions = {
            {282, 132},
            {264, 175},
        },
        coastal_regions = {
            "wh3_main_combi_region_chupayotl",
            "wh3_main_combi_region_mangrove_coast",
        }
    },

    -- Channel between Albion and Couronne
    wh3_main_combi_region_the_albion_channel = {
        spawn_positions = {
            {371, 667},
            {340, 703},
            {317, 746},
        },
        coastal_regions = {
            "wh3_main_combi_region_languille",
            "wh3_main_combi_region_isle_of_wights",
            "wh3_main_combi_region_konquata",
        }
    },

    -- North/West coast of Bretonnia
    wh3_main_combi_region_the_mistnar_crossing = {
        spawn_positions = {
            {332, 650},
            {350, 615},
            {370, 584},
        },
        coastal_regions = {
            "wh3_main_combi_region_mousillon",
            "wh3_main_combi_region_lyonesse",
            "wh3_main_combi_region_mistnar",
            "wh3_main_combi_region_tor_koruali",
        }
    },

    -- Southern coast of Bretonnia
    wh3_main_combi_region_middle_sea = {
        spawn_positions = {
            {381, 560},
            {416, 501},
            {397, 528},
        },
        coastal_regions = {
            "wh3_main_combi_region_castle_carcassonne",
            "wh3_main_combi_region_brionne",
            "wh3_main_combi_region_bordeleaux",
        }
    },

    -- Sea north of Norsca
    wh3_main_combi_region_northern_sea_of_chaos = {
        spawn_positions = {
            {495, 891},
            {405, 858},
            {537, 900},
        },
        coastal_regions = {
            "wh3_main_combi_region_serpent_jetty",
            "wh3_main_combi_region_the_monolith_of_katam",
            "wh3_main_combi_region_varg_camp",
            "wh3_main_combi_region_cliff_of_beasts",
            "wh3_main_combi_region_the_folly_of_malofex",
            "wh3_main_combi_region_the_fetid_catacombs",
            "wh3_main_combi_region_fortress_of_the_damned",
        }
    },

    -- Sea north of Nagarrond
    wh3_main_combi_region_sea_of_chill = {
        spawn_positions = {
            {223, 804},
        },
        coastal_regions = {
            "wh3_main_combi_region_blacklight_tower",
            "wh3_main_combi_region_har_ganeth"
        }
    },

    -- Sea north of Albion
    wh3_main_combi_region_straights_of_chaos = {
        spawn_positions = {
            {361, 823},
            {362, 787},
        },
        coastal_regions = {
            "wh3_main_combi_region_citadel_of_lead",
            "wh3_main_combi_region_troll_fjord",
        }
    },

    -- Sea south of Norsca
    wh3_main_combi_region_sea_of_claws = {
        spawn_positions = {
            {498, 764},
            {555, 782},
        },
        coastal_regions = {
            "wh3_main_combi_region_altar_of_the_crimson_harvest",
            "wh3_main_combi_region_dietershafen",
            "wh3_main_combi_region_longship_graveyard",
            "wh3_main_combi_region_salzenmund",
        }
    },

    -- Gulf West of Kislev
    wh3_main_combi_region_gulf_of_kislev = {
        spawn_positions = {
            {589, 784},
        },
        coastal_regions = {
            "wh3_main_combi_region_norden",
            "wh3_main_combi_region_erengrad",
            "wh3_main_combi_region_castle_alexandronov",
            "wh3_main_combi_region_bay_of_blades",
        }
    },

    -- Sea of Nagarrond
    wh3_main_combi_region_sea_of_malice = {
        spawn_positions = {
            {149, 789},
            {181, 780},
        },
        coastal_regions = {
            "wh3_main_combi_region_circle_of_destruction",
            "wh3_main_combi_region_hag_graef",
            "wh3_main_combi_region_naggarond",
            "wh3_main_combi_region_the_great_arena",
        }
    },

    -- Coast East of Naggarond
    wh3_main_combi_region_the_forbidding_coast = {
        spawn_positions = {
            {291, 785},
            {276, 735},
            {232, 690},
        },
        coastal_regions = {
            "wh3_main_combi_region_karond_kar",
            "wh3_main_combi_region_black_creek_spire",
            "wh3_main_combi_region_slavers_point",
            "wh3_main_combi_region_the_twisted_glade",
        }
    },

    -- Coast between Nagarrond and the Donut
    wh3_main_combi_region_the_bleak_coast = {
        spawn_positions = {
            {166, 623},
            {151, 544},
        },
        coastal_regions = {
            "wh3_main_combi_region_arnheim",
            "wh3_main_combi_region_the_moon_shard",
            "wh3_main_combi_region_whitepeak",
            "wh3_main_combi_region_tor_anroc",
            "wh3_main_combi_region_tor_dranil",
        }
    },

    -- Northern coast of the Donut
    wh3_main_combi_region_the_isles = {
        spawn_positions = {
            {225, 662},
            {294, 658},
        },
        coastal_regions = {
            "wh3_main_combi_region_tor_anlec",
            "wh3_main_combi_region_shrine_of_khaine",
            "wh3_main_combi_region_shrine_of_kurnous",
            "wh3_main_combi_region_elisia",
        }
    },

    -- South/East of the Donut
    wh3_main_combi_region_shifting_isles = {
        spawn_positions = {
            {364, 536},
            {333, 486},
        },
        coastal_regions = {
            "wh3_main_combi_region_tralinia",
            "wh3_main_combi_region_elessaeli",
            "wh3_main_combi_region_shrine_of_loec",
            "wh3_main_combi_region_cairn_thel",
        }
    },

    -- South of the Donut
    wh3_main_combi_region_straits_of_lothern = {
        spawn_positions = {
            {278, 482},
            {182, 519},
            {221, 487},
        },
        coastal_regions = {
            "wh3_main_combi_region_lothern",
            "wh3_main_combi_region_vauls_anvil_ulthuan",
            "wh3_main_combi_region_avethir",
            "wh3_main_combi_region_tor_sethai",

        }
    },

    -- Coast of Skeggi
    wh3_main_combi_region_sea_of_serpents = {
        spawn_positions = {
            {147, 512},
            {144, 473},
        },
        coastal_regions = {
            "wh3_main_combi_region_skeggi",
            "wh3_main_combi_region_port_reaver",
            "wh3_main_combi_region_swamp_town",
            "wh3_main_combi_region_monument_of_the_moon",
        }
    },

    -- Gulf of the Southern Princess
    wh3_main_combi_region_the_black_gulf = {
        spawn_positions = {
            {605, 465},
            {563, 404},
        },
        coastal_regions = {
            "wh3_main_combi_region_gronti_mingol",
            "wh3_main_combi_region_myrmidens",
            "wh3_main_combi_region_zvorak",
            "wh3_main_combi_region_stonemine_tower",
            "wh3_main_combi_region_matorca",
            "wh3_main_combi_region_barak_varr",
            "wh3_main_combi_region_dok_karaz",
        }
    },

    -- Coast north of the Southlands
    wh3_main_combi_region_the_pirate_coast = {
        spawn_positions = {
            {531, 346},
            {482, 371},
            {549, 385},
        },
        coastal_regions = {
            "wh3_main_combi_region_copher",
            "wh3_main_combi_region_fyrus",
            "wh3_main_combi_region_al_haikk",
            "wh3_main_combi_region_zandri",
            "wh3_main_combi_region_stormhenge",
            "wh3_main_combi_region_sartosa",
            "wh3_main_combi_region_argalis",
        }
    },

    -- West sea of the Southlands
    wh3_main_combi_region_shark_straights = {
        spawn_positions = {
            {444, 343},
            {405, 283},
        },
        coastal_regions = {
            "wh3_main_combi_region_sorcerers_islands",
            "wh3_main_combi_region_lashiek",
        }
    },

    -- Gulf south/west of the Southlands
    wh3_main_combi_region_gulf_of_medes = {
        spawn_positions = {
            {519, 232},
            {425, 235},
        },
        coastal_regions = {
            "wh3_main_combi_region_plain_of_tuskers",
            "wh3_main_combi_region_sudenburg",
            "wh3_main_combi_region_el_kalabad",
            "wh3_main_combi_region_great_desert_of_araby",
            "wh3_main_combi_region_wizard_caliphs_palace",
        }
    },

    -- South/West coast of the Southlands
    wh3_main_combi_region_the_southern_straits = {
        spawn_positions = {
            {475, 195},
            {512, 136},
        },
        coastal_regions = {
            "wh3_main_combi_region_zlatlan",
            "wh3_main_combi_region_nahuontl",
            "wh3_main_combi_region_statues_of_the_gods",
            "wh3_main_combi_region_deaths_head_monoliths",
        }
    },

    -- Sea east of Middle Lustria
    wh3_main_combi_region_sea_of_squalls = {
        spawn_positions = {
            {16, 481},
            {11, 414},
        },
        coastal_regions = {
            "wh3_main_combi_region_shrine_of_sotek",
            "wh3_main_combi_region_macu_peaks",
            "wh3_main_combi_region_fallen_gates",
        }
    },

    -- Sea around Dragon Islands
    wh3_main_combi_region_sea_of_storms = {
        spawn_positions = {
            {950, 398},
            {1015, 319},
        },
        coastal_regions = {
            "wh3_main_combi_region_dragon_fang_mount",
            "wh3_main_combi_region_shattered_stone_isle",
            "wh3_main_combi_region_dread_rock",
            "wh3_main_combi_region_shattered_cove",
            "wh3_main_combi_region_ruins_end",
            "wh3_main_combi_region_bitter_bay",
        }
    },

    -- South/East coast of the Southlands
    wh3_main_combi_region_serpent_coast_sea = {
        spawn_positions = {
            {618, 49},
            {693, 50},
            {661, 70},
        },
        coastal_regions = {
            "wh3_main_combi_region_caverns_of_sotek",
            "wh3_main_combi_region_tor_surpindar",
            "wh3_main_combi_region_volulltrax",
            "wh3_main_combi_region_the_skull_carvers_abode",
        }
    },

    -- Atlantid coast, East
    wh3_main_combi_region_the_daemonium_coast = {
        spawn_positions = {
            {772, 68},
            {876, 39},
        },
        coastal_regions = {
            "wh3_main_combi_region_altar_of_facades",
            "wh3_main_combi_region_castle_of_splendour",
        }
    },

    -- Sea north of Couronne
    wh3_main_combi_region_southern_sea_of_chaos = {
        spawn_positions = {
            {406, 708},
            {442, 736},
        },
        coastal_regions = {
            "wh3_main_combi_region_couronne",
            "wh3_main_combi_region_aarnau",
            "wh3_main_combi_region_wreckers_point",
            "wh3_main_combi_region_pack_ice_bay",
        }
    },

    -- North/East coast of the Southlands
    wh3_main_combi_region_the_bitter_sea = {
        spawn_positions = {
            {849, 336},
            {837, 234},
            {856, 278},
        },
        coastal_regions = {
            "wh3_main_combi_region_lahmia",
            "wh3_main_combi_region_lybaras",
            "wh3_main_combi_region_doom_glade",
            "wh3_main_combi_region_temple_of_skulls",
        }
    },

    -- East coast of the Southlands
    wh3_main_combi_region_shifting_mangrove_coastline = {
        spawn_positions = {
            {811, 197},
            {782, 155},
            {735, 105},
        },
        coastal_regions = {
            "wh3_main_combi_region_serpent_coast",
            "wh3_main_combi_region_the_cursed_jungle",
            "wh3_main_combi_region_teotiqua",
            "wh3_main_combi_region_temple_avenue_of_gold",
        }
    },

    -- South coast of the Southlands
    wh3_main_combi_region_the_churning_gulf = {
        spawn_positions = {
            {562, 53},
            {554, 108},
        },
        coastal_regions = {
            "wh3_main_combi_region_dawns_light",
            "wh3_main_combi_region_fortress_of_dawn",
            "wh3_main_combi_region_yuatek",
            "wh3_main_combi_region_the_lost_palace",
            "wh3_main_combi_region_fateweavers_crevasse",
        }
    },

    -- Atlantid, center.
    wh3_main_combi_region_daemons_landing = {
        spawn_positions = {
            {456, 87},
        },
        coastal_regions = {
            "wh3_main_combi_region_daemons_gate",
        }
    },

    -- Atlantid, West
    wh3_main_combi_region_the_lustria_straight = {
        spawn_positions = {
            {375, 86},
            {228, 64},
            {290, 70},
        },
        coastal_regions = {
            "wh3_main_combi_region_grotrilexs_glare_lighthouse",
            "wh3_main_combi_region_the_sinhall_monolith",
            "wh3_main_combi_region_mount_athull",
            "wh3_main_combi_region_the_never_ending_chasm",
            "wh3_main_combi_region_the_godless_crater",
            "wh3_main_combi_region_citadel_of_dusk",
            "wh3_main_combi_region_dusk_peaks",
        }
    },

    -- Lustria, South/West coast
    wh3_main_combi_region_worm_coast = {
        spawn_positions = {
            {200, 88},
            {130, 123},
            {77, 167},
        },
        coastal_regions = {
            "wh3_main_combi_region_xlanzec",
            "wh3_main_combi_region_kaiax",
            "wh3_main_combi_region_the_dust_gate",
            "wh3_main_combi_region_the_copper_landing",
            "wh3_main_combi_region_the_golden_colossus",
        }
    },

    -- Lustria, West coast
    wh3_main_combi_region_the_turtle_shallows = {
        spawn_positions = {
            {32, 216},
            {13, 294},
            {20, 388},
        },
        coastal_regions = {
            "wh3_main_combi_region_sentinels_of_xeti",
            "wh3_main_combi_region_great_turtle_isle",
            "wh3_main_combi_region_golden_ziggurat",
            "wh3_main_combi_region_chamber_of_visions",
            "wh3_main_combi_region_the_blood_hall",
            "wh3_main_combi_region_pillars_of_unseen_constellations",
            "wh3_main_combi_region_wellsprings_of_eternity",
            "wh3_main_combi_region_spektazuma",
        }
    },

    -- Sea around the Galleon's Graveyard
    wh3_main_combi_region_the_galleons_graveyard_sea = {
        spawn_positions = {
            {256, 416},
        },
        coastal_regions = {
            "wh3_main_combi_region_the_galleons_graveyard",
        }
    },

    -- Straits east of the fallen gates.
    wh3_main_combi_region_straits_of_fear = {
        spawn_positions = {
            {123, 543},
            {78, 510},
        },
        coastal_regions = {
            "wh3_main_combi_region_grey_rock_point",
            "wh3_main_combi_region_ssildra_tor",
            "wh3_main_combi_region_ziggurat_of_dawn",
        }
    },

    -- Coast North/East of Lustria
    wh3_main_combi_region_scorpion_coast = {
        spawn_positions = {
            {132, 412},
            {181, 373},
        },
        coastal_regions = {
            "wh3_main_combi_region_the_high_sentinel",
            "wh3_main_combi_region_temple_of_kara",
        }
    },

    -- Coast North/East/East of Lustria
    wh3_main_combi_region_tarantula_coast = {
        spawn_positions = {
            {221, 355},
            {256, 316},
        },
        coastal_regions = {
            "wh3_main_combi_region_temple_of_tlencan", -- Bregonne
            "wh3_main_combi_region_tlax",
        }
    },

    -- Coast east of Lustria
    wh3_main_combi_region_the_vampire_coast_sea = {
        spawn_positions = {
            {323, 281},
            {300, 215},
            {261, 190},
        },
        coastal_regions = {
            "wh3_main_combi_region_pox_marsh",
            "wh3_main_combi_region_the_awakening",
            "wh3_main_combi_region_the_blood_swamps",
            "wh3_main_combi_region_fuming_serpent",
            "wh3_main_combi_region_the_star_tower",
            "wh3_main_combi_region_altar_of_the_horned_rat",
        }
    },

    -- Sea south of Tilea
    wh3_main_combi_region_tilean_sea = {
        spawn_positions = {
            {484, 421},
        },
        coastal_regions = {
            "wh3_main_combi_region_luccini",
            "wh3_main_combi_region_miragliano",
            "wh3_main_combi_region_tobaro",
            "wh3_main_combi_region_skavenblight",
        }
    },

    -- Coast of Estalia
    wh3_main_combi_region_the_estalia_coastline = {
        spawn_positions = {
            {407, 403},
            {360, 450},
        },
        coastal_regions = {
            "wh3_main_combi_region_magritta",
            "wh3_main_combi_region_nuja",
            "wh3_main_combi_region_bilbali",
        }
    },
}

-- Factions that will receive the attacking armies.
local potential_attack_factions = {
    "wh2_main_lzd_hexoatl",                     -- Mazda
    "wh2_main_lzd_last_defenders",              -- Kroq-Gar
    "wh2_dlc12_lzd_cult_of_sotek",              -- Tehenhauin
    "wh2_main_lzd_tlaqua",                      -- Tiktaq'to
    "wh2_main_lzd_itza",                        -- Gor-Rok
    "wh2_dlc13_lzd_spirits_of_the_jungle",      -- Nakai
    "wh2_dlc17_lzd_oxyotl",                     -- Oxyotl
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_aztec_invasion:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the second warning.
        core:add_listener(
            "DisasterAztecInvasionSecondWarning",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.second_warning_delay
            end,
            function()
                self:trigger_second_warning();
                core:remove_listener("DisasterAztecInvasionSecondWarning")
            end,
            true
        );

        -- Listener for the invasion.
        core:add_listener(
            "DisasterAztecInvasionAztecInvasion",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.second_warning_delay + self.settings.invasion_delay
            end,
            function()
                self:trigger_aztec_invasion();
                core:remove_listener("DisasterAztecInvasionAztecInvasion")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STARTED then

        -- Listener to end the invasion.
        core:add_listener(
            "DisasterAztecInvasionEnd",
            "WorldStartRound",
            function ()
                return self:check_end_disaster_conditions()
            end,
            function()
                self:trigger_end_disaster();
                core:remove_listener("DisasterAztecInvasionEnd")
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_aztec_invasion:trigger()
    out("Frodo45127: Starting disaster: " .. self.name);

    self:set_status(STATUS_TRIGGERED);
    self:trigger_first_warning();
end

-- Function to trigger the first warning before the invasion.
function disaster_aztec_invasion:trigger_first_warning()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering first warning.");

    if dynamic_disasters.settings.debug == false then
        self.settings.second_warning_delay = math.random(3, 6);
    else
        self.settings.second_warning_delay = 1;
    end

    dynamic_disasters:execute_payload(self.first_warning_event_key, self.first_warning_event_key, self.settings.second_warning_delay, nil);
end

-- Function to trigger the second warning before the invasion.
function disaster_aztec_invasion:trigger_second_warning()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering second warning.");

    if dynamic_disasters.settings.debug == false then
        self.settings.invasion_delay = math.random(3, 6);
    else
        self.settings.invasion_delay = 1;
    end

    dynamic_disasters:execute_payload(self.second_warning_event_key, self.second_warning_event_key, self.settings.invasion_delay, nil);
end

-- Function to trigger the invasion itself.
function disaster_aztec_invasion:trigger_aztec_invasion()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_lzd_lizardmen")

    -- Get all the coastal regions (as in region with a port) owned by the player.
    local attack_vectors = {}

    -- Calculate the weight of each sea region, so we can increase the amount of armies depending on various values.
    for sea_region, sea_region_data in pairs(dyn_dis_sea_potential_attack_vectors) do
        attack_vectors[sea_region] = 0;

        for _, land_region in pairs(sea_region_data.coastal_regions) do
            local region = cm:get_region(land_region)
            local region_owner = region:owning_faction()

            -- Do not attack lizardmen. Attack everyone else.
            if region_owner:is_null_interface() == false and region_owner:subculture() ~= "wh2_main_sc_lzd_lizardmen" and region_owner:name() ~= "rebels" then
                attack_vectors[sea_region] = attack_vectors[sea_region] + 1;
            end
        end
    end

    -- Once we have the attack vectors, create the invasion forces.
    -- Both, the areas attacked and the amount of armies to spawn are based on campaign difficulty.
    local attacker_faction = potential_attack_factions[math.random(1, #potential_attack_factions)];
    for sea_region, weight in pairs(attack_vectors) do
        out("Frodo45127: Sea Region: " .. sea_region .. ". weight: " .. tostring(weight));

        -- Only attack regions with weight, meaning at least one province belongs to the player.
        if weight > 0 then

            -- Scale is an optional value for manually increasing/decreasing armies in one region.
            -- By default it's 1 (no change in amount of armies).
            local scale = 1;
            if dyn_dis_sea_potential_attack_vectors[sea_region].scale ~= nil then
                scale = dyn_dis_sea_potential_attack_vectors[sea_region].scale;
            end

            -- Armies calculation: We want between 1-4 per province, scaling based on difficulty.
            local armies_to_spawn = (1 + math.ceil(self.settings.difficulty_mod)) * math.ceil(weight * 0.5) * scale;
            local armies_to_spawn_in_each_spawn_point = armies_to_spawn / #dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions;
            out("Frodo45127: Armies to spawn: " .. tostring(armies_to_spawn) .. " per region.");

            -- Spawn armies at sea, scaling them with the amount of coastal regions the sea region borders.
            for i = 1, #dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions do
                local spawn_pos = dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions[i];
                dynamic_disasters:create_scenario_force_at_coords(attacker_faction, dyn_dis_sea_potential_attack_vectors[sea_region].coastal_regions[1], spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_in_each_spawn_point, self.name);
            end

            -- Change attacker for the next region.
            attacker_faction = potential_attack_factions[math.random(1, #potential_attack_factions)];
        end
    end

    -- Trigger wars and faction buffs/AI changes for attackers. Do this after spawning armies so it only affects alive/spawned factions.
    for _, faction_key in pairs(potential_attack_factions) do
        local faction = cm:get_faction(faction_key);
        if faction:is_null_interface() == false and not faction:is_dead() then

            -- Change their AI to something more aggressive.
            cm:force_change_cai_faction_personality(faction_key, self.ai_personality)

            -- Apply buffs to the attackers, so they can at least push one province into player territory.
            cm:apply_effect_bundle("fro_dyn_dis_aztec_invasion_trigger_invader_buffs", faction_key, 10)

            -- Declare war on EVERY human, and disable diplomacy.
            endgame:no_peace_no_confederation_only_war(faction_key)

            -- Make every attacking faction go full retard against the owner of the coastal provinces.
            for sea_region, weight in pairs(attack_vectors) do
                if weight > 0 then
                    dynamic_disasters:declare_war_for_owners_and_neightbours(faction, dyn_dis_sea_potential_attack_vectors[sea_region].coastal_regions, true, {"wh2_main_sc_lzd_lizardmen"});
                end
            end
        end
    end

    -- Make sure every attacker is at peace with each other.
    for _, src_faction_key in pairs(potential_attack_factions) do
        for _, dest_faction_key in pairs(potential_attack_factions) do
            if src_faction_key ~= dest_faction_key then
                cm:force_make_peace(src_faction_key, dest_faction_key);
            end
        end

        -- Also, make sure they're added to the victory conditions.
        table.insert(self.objectives[1].conditions, "faction " .. src_faction_key)
    end

    -- Trigger the victory condition, if needed.
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(self.invasion_event_key, self.objectives, nil, nil)
        local human_factions = cm:get_human_factions()
        for i = 1, #human_factions do
            cm:apply_effect_bundle(self.invasion_event_key, human_factions[i], 10)
        end
    else
        dynamic_disasters:execute_payload(self.invasion_event_key, self.invasion_event_key, 10, nil);
    end

    -- Set the invasions status to started.
    self:set_status(STATUS_STARTED);
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_aztec_invasion:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_aztec_invasion:check_start_disaster_conditions()

    -- Update the potential factions removing the confederated ones.
    potential_attack_factions = dynamic_disasters:remove_confederated_factions_from_list(potential_attack_factions);

    -- Check if any of the attackers if actually alive.
    local attackers_still_alive = false;
    for _, faction_key in pairs(potential_attack_factions) do
        local faction = cm:get_faction(faction_key);
        if faction:is_null_interface() == false and faction:is_dead() == false then
            attackers_still_alive = true;
            break;
        end
    end

    -- Do not start if we don't have attackers.
    if #potential_attack_factions == 0 or attackers_still_alive == false then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    -- Base chance: 1/200 turns (0.5%).
    local base_chance = 0.005;

    -- Increase the change of starting based on how many attackers are already dead.
    for _, faction_key in pairs(potential_attack_factions) do
        local faction = cm:get_faction(faction_key);
        if faction:is_null_interface() == false and faction:is_dead() then

            -- Increase in 0.5% the chance of triggering for each dead attacker.
            base_chance = base_chance + 0.005;
        end
    end

    if math.random() < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_aztec_invasion:check_end_disaster_conditions()

    -- Update the potential factions removing the confederated ones.
    potential_attack_factions = dynamic_disasters:remove_confederated_factions_from_list(potential_attack_factions);

    local all_attackers_dead = true;

    for _, faction_key in pairs(potential_attack_factions) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and not faction:is_dead() then
            all_attackers_dead = false;
        end
    end

    return all_attackers_dead;
end

return disaster_aztec_invasion
