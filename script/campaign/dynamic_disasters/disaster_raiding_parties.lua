--[[
    Raiding Parties disaster, By Frodo45127.

    This disaster consists on limited coastal attacks by either Vampire Coast armies, Norscan or Dark Elven fleets.
    NOTE: This disaster can use the three factions, except the ones sharing subculture with the player.

    Requirements:
        - Random chance (0.05)
        - At least turn 30 (so the player has a coast).
        - At least one of the potential attackers must be alive (you can end this disaster by killing them all).
    Effects:
        - Trigger/First Warning:
            - Message of warning about ships with black and tattered sails.
            - Wait 4-10 turns for more info.
        - Invasion:
            - Get some random coastal areas, weigthed a bit considering the provinces the player owns.
            - Pick one random faction and give them some armies near those settlements.
        - Finish:
            - Once everything is spawned, consider it done.

]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;

-- Object representing the disaster.
disaster_raiding_parties = {
    name = "raiding_parties",

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
        repeteable = true,                  -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        min_turn = 30,                      -- Minimum turn required for the disaster to trigger.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 10,    -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        -- Disaster-specific data.
        warning_delay = 1,
        warning_event_key = "fro_dyn_dis_raiding_parties_warning",
        raiding_event_key = "fro_dyn_dis_raiding_parties_trigger",
        raiding_raiders_effect_key = "fro_dyn_dis_raiding_parties_invader_buffs",

        army_template = {},
        base_army_unit_count = 19,

        faction = "",
        subculture = "",
        potential_attack_factions_alive = {},
        potential_attack_subcultures_alive = {},
    }
}

-- Potential areas of invasion. It containes a table with area-of-invasion -> [regions to invade from].
-- Copied from the aztec invasion. If that updates, remember to copy it here.
local potential_attack_vectors = {

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
    wh2_dlc11_sc_cst_vampire_coast = {      -- Vampire Coast
        "wh2_dlc11_cst_vampire_coast",          -- Harkon
        "wh2_dlc11_cst_noctilus",               -- Noctilus
        "wh2_dlc11_cst_pirates_of_sartosa",     -- Aranessa
        "wh2_dlc11_cst_the_drowned",            -- Cylostra
    },
    wh2_main_sc_def_dark_elves = {          -- Dark elves
        "wh2_main_def_dark_elves",              -- Malekith
        "wh2_main_def_cult_of_pleasure",        -- Morathi
        "wh2_main_def_har_ganeth",              -- Hellebron
        "wh2_dlc11_def_the_blessed_dread",      -- Lokhir
        "wh2_main_def_hag_graef",               -- Malus
        "wh2_twa03_def_rakarth",                -- Rakarth
    },
    wh_dlc08_sc_nor_norsca = {              -- Norsca
        "wh_dlc08_nor_norsca",                  -- Wulfrik
        "wh_dlc08_nor_wintertooth",             -- Throgg
    },
}

-- Potential coasts to attack. Each coast may contain one or more regions.
local potential_coasts = {
    cathay_eastern_coast = {
        "wh3_main_combi_region_northern_straits_of_the_jade_sea",
        "wh3_main_combi_region_the_jade_sea",
    },
    darklands_south_coast = {
        "wh3_main_combi_region_sea_of_storms",
    },
    eastern_isles = {
        "wh3_main_combi_region_the_eastern_isles",
    },
    southlands_east_coast = {
        "wh3_main_combi_region_the_bitter_sea",
        "wh3_main_combi_region_shifting_mangrove_coastline",
    },
    southlands_south_coast = {
        "wh3_main_combi_region_the_churning_gulf",
        "wh3_main_combi_region_serpent_coast_sea",
    },
    southlands_west_coast = {
        "wh3_main_combi_region_gulf_of_medes",
        "wh3_main_combi_region_the_southern_straits",
    },
    southlands_north_coast = {
        "wh3_main_combi_region_shark_straights",
        "wh3_main_combi_region_the_pirate_coast",
    },
    badlands_coast = {
        "wh3_main_combi_region_the_black_gulf",
    },
    tilea_and_estalia_coast = {
        "wh3_main_combi_region_tilean_sea",
        "wh3_main_combi_region_the_estalia_coastline",
    },
    bretonnia_west_coast = {
        "wh3_main_combi_region_middle_sea",
        "wh3_main_combi_region_the_mistnar_crossing",
    },
    bretonnia_north_coast = {
        "wh3_main_combi_region_southern_sea_of_chaos",
        "wh3_main_combi_region_the_albion_channel",
    },
    norsca_south_coast = {
        "wh3_main_combi_region_southern_sea_of_chaos",
        "wh3_main_combi_region_gulf_of_kislev",
        "wh3_main_combi_region_sea_of_claws",
    },

    -- We skip the straits of chaos west of norsca. No sense on putting that single province from where they cannot raid anything.
    norsca_north_coast = {
        "wh3_main_combi_region_frozen_sea",
        "wh3_main_combi_region_kraken_sea",
        "wh3_main_combi_region_northern_sea_of_chaos",
    },

    -- We skip shard coast, for the same thing as the west of norsca.
    naggarond_coast = {
        "wh3_main_combi_region_sea_of_malice",
        "wh3_main_combi_region_sea_of_chill",
        "wh3_main_combi_region_the_forbidding_coast",
    },

    mexico_coast = {
        "wh3_main_combi_region_straits_of_fear",
        "wh3_main_combi_region_sea_of_serpents",
        "wh3_main_combi_region_scorpion_coast",
    },
    lustria_north_east_coast = {
        "wh3_main_combi_region_tarantula_coast",
        "wh3_main_combi_region_the_vampire_coast_sea",
    },
    lustria_east_coast = {
        "wh3_main_combi_region_the_vampire_coast_sea",
        "wh3_main_combi_region_mangrove_coast_sea",
    },
    lustria_south_coast = {
        "wh3_main_combi_region_the_lustria_straight",
        "wh3_main_combi_region_worm_coast",
    },
    lustria_west_coast = {
        "wh3_main_combi_region_the_turtle_shallows",
        "wh3_main_combi_region_sea_of_squalls",
    },

    donut_east_coast = {
        "wh3_main_combi_region_shifting_isles",
        "wh3_main_combi_region_the_mistnar_crossing",
    },
    donut_north_west_coast = {
        "wh3_main_combi_region_the_isles",
        "wh3_main_combi_region_the_bleak_coast",
    },
    donut_south_coast = {
        "wh3_main_combi_region_straits_of_lothern",
    },

    -- Who the fuck would raid that?
    antartid = {
        "wh3_main_combi_region_the_daemonium_coast",
        "wh3_main_combi_region_serpent_coast_sea",
        "wh3_main_combi_region_the_churning_gulf",
        "wh3_main_combi_region_daemons_landing",
        "wh3_main_combi_region_the_lustria_straight",
    },
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_raiding_parties:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Listener for the warning.
        core:add_listener(
            "RaidingPartiesWarning",
            "WorldStartRound",
            function()
                return cm:turn_number() == self.settings.last_triggered_turn + self.settings.warning_delay
            end,
            function()
                self:trigger_raiding_parties();
                self:trigger_end_disaster();
                core:remove_listener("RaidingPartiesWarning")
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_raiding_parties:trigger()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Get the subculture/faction to use as raiders.
    self.settings.subculture = self.settings.potential_attack_subcultures_alive[math.random(1, #self.settings.potential_attack_subcultures_alive)];
    self.settings.faction = self.settings.potential_attack_factions_alive[self.settings.subculture][math.random(1, #self.settings.potential_attack_factions_alive[self.settings.subculture])];

    -- Get the army template to use, based on the subculture.
    if self.settings.subculture == "wh2_dlc11_sc_cst_vampire_coast" then
        self.settings.army_template.vampire_coast = "lategame";
    end

    if self.settings.subculture == "wh_dlc08_sc_nor_norsca" then
        self.settings.army_template.norsca = "lategame";
    end

    if self.settings.subculture == "wh2_main_sc_def_dark_elves" then
        self.settings.army_template.dark_elves = "lategame";
    end

    -- Recalculate the delay for further executions.
    self.settings.warning_delay = math.random(4, 10);
    self.settings.wait_turns_between_repeats = self.settings.warning_delay + 10;

    self:set_status(STATUS_TRIGGERED);
    dynamic_disasters:execute_payload(self.settings.warning_event_key, nil, 0);
end

-- Function to trigger the raid itself.
function disaster_raiding_parties:trigger_raiding_parties()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    -- TODO: Allow to attack the attacked region to the payload, so it can be zoom in.
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
    dynamic_disasters:execute_payload(self.settings.raiding_event_key, nil, 0);

    -- Get all the coastal regions (as in region with a port) to attack by weight.
    local attack_vectors = {};
    local avg = 0;
    local count = 0;

    -- Calculate the weight of each attack region.
    for coast, regions in pairs(potential_coasts) do
        attack_vectors[coast] = 0;
        count = count + 1;

        for _, sea_region in pairs(regions) do
            local sea_region_data = potential_attack_vectors[sea_region];

            for _, land_region in pairs(sea_region_data.coastal_regions) do
                local region = cm:get_region(land_region)
                local region_owner = region:owning_faction()

                -- Do not attack your own subculture. Attack everyone else.
                if region_owner:is_null_interface() == false and region_owner:subculture() ~= self.settings.subculture and region_owner:name() ~= "rebels" then
                    attack_vectors[coast] = attack_vectors[coast] + 1;

                    -- Give a bit more priority to player coastal settlements.
                    if region_owner:is_human() == true then
                        attack_vectors[coast] = attack_vectors[coast] + 0.5;
                    end
                end
            end

            avg = avg + attack_vectors[coast];
        end
    end

    -- Once we have the attack vectors, create the invasion forces.
    local coasts_to_attack = {};
    local average = avg / count;

    -- Get the regions only from the ones with more weight, so it doesn't only focus on the player.
    for coast, weight in pairs(attack_vectors) do
        if weight >= average then
            table.insert(coasts_to_attack, coast);
        end
    end

    -- If no coast to attack has been found, just cancel the attack.
    if #coasts_to_attack < 1 then

        -- TODO: Put a message here, or something to signal the pirates are no longer going to attack.
        return
    end

    -- Get the region at random from the top half of the coasts.
    local coast_to_attack = coasts_to_attack[math.random(1, #coasts_to_attack)];
    for _, sea_region in pairs(potential_coasts[coast_to_attack]) do

        -- Scale is an optional value for manually increasing/decreasing armies in one region.
        -- By default it's 1 (no change in amount of armies).
        local scale = 1;
        if potential_attack_vectors[sea_region].scale ~= nil then
            scale = potential_attack_vectors[sea_region].scale;
        end

        -- Armies calculation.
        local armies_to_spawn = math.ceil(self.settings.difficulty_mod) * math.ceil(#potential_attack_vectors[sea_region].coastal_regions * 0.5) * scale;
        local armies_to_spawn_in_each_spawn_point = armies_to_spawn / #potential_attack_vectors[sea_region].spawn_positions;
        out("Frodo45127: Armies to spawn: " .. tostring(armies_to_spawn_in_each_spawn_point) .. " per region.");

        -- Spawn armies at sea.
        for i = 1, #potential_attack_vectors[sea_region].spawn_positions do
            local spawn_pos = potential_attack_vectors[sea_region].spawn_positions[i];
            dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, potential_attack_vectors[sea_region].coastal_regions[1], spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_in_each_spawn_point, self.name);
        end
    end

    -- Set diplomacy.
    local attacker_faction = cm:get_faction(self.settings.faction);
    if attacker_faction ~= false and not attacker_faction:is_dead() then

        -- Apply buffs to the attackers, so they can at least push one province into player territory.
        cm:apply_effect_bundle(self.settings.raiding_raiders_effect_key, self.settings.faction, 10)

        -- Make every attacking faction go full retard against the owner of the coastal provinces.
        for _, sea_region in pairs(potential_coasts[coast_to_attack]) do
            for _, land_region in pairs(potential_attack_vectors[sea_region].coastal_regions) do
                local region = cm:get_region(land_region)
                local region_owner = region:owning_faction()

                if region_owner:is_null_interface() == false and region_owner:subculture() ~= self.settings.subculture and region_owner:name() ~= "rebels" and not attacker_faction:at_war_with(region_owner) then
                    cm:force_declare_war(self.settings.faction, region_owner:name(), false, true)
                end
            end
        end
    end
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_raiding_parties:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_raiding_parties:check_start_disaster_conditions()

    -- First, get all player subcultures. We need to discard them from the "alive" list.
    local human_factions = cm:get_human_factions()
    local human_subcultures = {}
    for i = 1, #human_factions do
        table.insert(human_subcultures, cm:get_faction(human_factions[i]):subculture())
    end

    -- Second, only trigger it if any of the factions is alive.
    -- We not only use this to check if a faction is alive, but also to get what factions/subcultures are still alive.
    -- That way we can only pickup factions that are actually alive, and end the raidings if you wipe them out.
    self.settings.potential_attack_factions_alive = {};
    self.settings.potential_attack_subcultures_alive = {};
    local count_alive = 0;
    for subculture, factions in pairs(potential_attack_factions) do
        local is_human = false;
        for _, human_subculture in pairs(human_subcultures) do
            if human_subculture == subculture then
                is_human = true;
                break;
            end
        end

        -- Only consider non-human factions for this.
        if is_human == false then
            local factions_alive = {};
            local count = 0;
            for _, faction_key in pairs(factions) do
                local faction = cm:get_faction(faction_key);
                if faction ~= false and not faction:is_dead() then
                    count = count + 1;
                    table.insert(factions_alive, faction_key);
                end
            end

            if count > 0 then
                count_alive = count_alive + 1;
                self.settings.potential_attack_factions_alive[subculture] = factions_alive;
                table.insert(self.settings.potential_attack_subcultures_alive, subculture);
            end
        end
    end

    -- If none of the available factions is alive, do not trigger the disaster.
    if count_alive == 0 then
        return false;
    end

    local base_chance = 0.02;
    for _, factions in pairs(potential_attack_factions) do
        for _, faction_key in pairs(factions) do
            local faction = cm:get_faction(faction_key);
            if faction ~= false and faction:is_dead() then
                base_chance = base_chance + 0.01;
            end
        end
    end

    if math.random() < base_chance then
        return true;
    end

    return false;
end


return disaster_raiding_parties
