--[[

    Companion module for Dynamic Disasters, containing data reusable between disasters.

]]--

-- Potential coasts to attack. Each coast may contain one or more regions.
--
-- NOTE: This one is global so other disasters can use it too.
dyn_dis_coasts = {
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
    norsca_south_coast_1 = {
        "wh3_main_combi_region_southern_sea_of_chaos",
    },

    norsca_south_coast_2 = {
        "wh3_main_combi_region_gulf_of_kislev",
    },

    norsca_south_coast_3 = {
        "wh3_main_combi_region_sea_of_claws",
    },

    -- We skip the straits of chaos west of norsca. No sense on putting that single province from where they cannot raid anything.
    norsca_north_coast_1 = {
        "wh3_main_combi_region_frozen_sea",
    },

    norsca_north_coast_2 = {
        "wh3_main_combi_region_kraken_sea",
    },

    norsca_north_coast_3 = {
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

    -- Who the fuck would raid that? The AI, aparently. A lot.
    antartid_east = {
        "wh3_main_combi_region_the_daemonium_coast",
        "wh3_main_combi_region_serpent_coast_sea",
    },

    antartid_west = {
        "wh3_main_combi_region_daemons_landing",
        "wh3_main_combi_region_the_lustria_straight",
    },
}

-- Potential areas of invasion. It containes a table with area-of-invasion -> [regions to invade from].
--
-- NOTE: This one is global so other disasters can use it too.
dyn_dis_sea_regions = {

    -- Cathay's eastern coast, north.
    wh3_main_combi_region_northern_straits_of_the_jade_sea = {
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

-- List of army templates with weigthed units used by the manager.
--
-- NOTE: If you want to add units to the templates, DO NOT ADD THEM HERE. Add them through the relevant functions in the manager.
dyn_dis_army_templates = {
    tomb_kings = {
        earlygame = {

            --Melee Infantry
            wh2_dlc09_tmb_inf_skeleton_warriors_0 = 8,
            wh2_dlc09_tmb_inf_skeleton_spearmen_0 = 8,
            wh2_dlc09_tmb_inf_nehekhara_warriors_0 = 6,

            --Ranged Infantry
            wh2_dlc09_tmb_inf_skeleton_archers_0 = 6,

            --Cavalry
            wh2_dlc09_tmb_veh_skeleton_chariot_0 = 3,
            wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 = 2,
            wh2_dlc09_tmb_cav_nehekhara_horsemen_0 = 3,
            wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 = 2,

            --Monsters
            wh2_dlc09_tmb_mon_carrion_0 = 2,
            wh2_dlc09_tmb_mon_ushabti_0 = 2,

            --Artillery
            wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 1,

            --Heroes
            wh2_dlc09_tmb_cha_necrotect_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_nehekhara_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_shadow_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_light_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_death_0 = 1,
            wh2_dlc09_tmb_cha_tomb_prince_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh2_dlc09_tmb_inf_skeleton_warriors_0 = 2,
            wh2_dlc09_tmb_inf_skeleton_spearmen_0 = 2,
            wh2_dlc09_tmb_inf_tomb_guard_0 = 4,
            wh2_dlc09_tmb_inf_tomb_guard_1 = 4,
            wh2_dlc09_tmb_inf_nehekhara_warriors_0 = 8,

            --Ranged Infantry
            wh2_dlc09_tmb_inf_skeleton_archers_0 = 6,

            --Cavalry
            wh2_dlc09_tmb_veh_skeleton_chariot_0 = 3,
            wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 = 2,
            wh2_dlc09_tmb_cav_nehekhara_horsemen_0 = 3,
            wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 = 2,

            --Monsters
            wh2_dlc09_tmb_mon_sepulchral_stalkers_0 = 1,
            wh2_dlc09_tmb_mon_ushabti_0 = 3,
            wh2_dlc09_tmb_mon_ushabti_1 = 3,
            wh2_dlc09_tmb_mon_tomb_scorpion_0 = 1,
            wh2_dlc09_tmb_mon_heirotitan_0 = 1,
            wh2_dlc09_tmb_mon_necrosphinx_0 = 1,
            wh2_pro06_tmb_mon_bone_giant_0 = 1,

            --Artillery
            wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
            wh2_dlc09_tmb_art_casket_of_souls_0 = 1,

            --Heroes
            wh2_dlc09_tmb_cha_necrotect_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_nehekhara_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_shadow_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_light_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_death_0 = 1,
            wh2_dlc09_tmb_cha_tomb_prince_0 = 1,
        },
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

            --Heroes
            wh2_dlc09_tmb_cha_necrotect_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_nehekhara_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_shadow_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_light_0 = 1,
            wh2_dlc09_tmb_cha_liche_priest_death_0 = 1,
            wh2_dlc09_tmb_cha_tomb_prince_0 = 1,
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
    high_elves = {
        earlygame = {

            --Melee Infantry
            wh2_main_hef_inf_spearmen_0 = 8,
            wh2_main_hef_inf_white_lions_of_chrace_0 = 6,

            --Ranged Infantry
            wh2_main_hef_inf_archers_0 = 6,
            wh2_main_hef_inf_archers_1 = 6,
            wh2_main_hef_inf_lothern_sea_guard_0 = 4,
            wh2_main_hef_inf_lothern_sea_guard_1 = 4,

            --Cavalry
            wh2_main_hef_cav_silver_helms_0 = 2,
            wh2_main_hef_cav_silver_helms_1 = 2,

            --Artillery
            wh2_main_hef_art_eagle_claw_bolt_thrower = 1,

            --Monsters
            wh2_main_hef_mon_great_eagle = 1,

            --Heroes
            wh2_main_hef_cha_noble_0 = 1,
            wh2_dlc10_hef_cha_handmaiden_0 = 1,
            wh2_main_hef_cha_mage_life_0 = 1,
            wh2_main_hef_cha_loremaster_of_hoeth_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh2_main_hef_inf_spearmen_0 = 6,
            wh2_main_hef_inf_white_lions_of_chrace_0 = 4,

            --Ranged Infantry
            wh2_main_hef_inf_lothern_sea_guard_0 = 8,
            wh2_main_hef_inf_lothern_sea_guard_1 = 8,

            --Cavalry
            wh2_main_hef_cav_silver_helms_0 = 2,
            wh2_main_hef_cav_silver_helms_1 = 2,
            wh2_dlc15_hef_veh_lion_chariot_of_chrace_0 = 1,
            wh2_main_hef_cav_ithilmar_chariot = 1,
            wh2_main_hef_cav_tiranoc_chariot = 2,

            --Artillery
            wh2_main_hef_art_eagle_claw_bolt_thrower = 1,

            --Monsters
            wh2_dlc15_hef_mon_war_lions_of_chrace_0 = 1,
            wh2_main_hef_mon_moon_dragon = 1,
            wh2_main_hef_mon_phoenix_flamespyre = 1,
            wh2_main_hef_mon_phoenix_frostheart = 1,
            wh2_main_hef_mon_star_dragon = 1,
            wh2_main_hef_mon_sun_dragon = 1,

            --Heroes
            wh2_main_hef_cha_noble_0 = 1,
            wh2_dlc10_hef_cha_handmaiden_0 = 1,
            wh2_main_hef_cha_mage_life_0 = 1,
            wh2_main_hef_cha_loremaster_of_hoeth_0 = 1,
        },
        lategame = {

            --Melee Infantry
            wh2_main_hef_inf_phoenix_guard = 6,
            wh2_main_hef_inf_swordmasters_of_hoeth_0 = 4,

            --Ranged Infantry
            wh2_dlc10_hef_inf_sisters_of_avelorn_0 = 8,
            wh2_main_hef_inf_lothern_sea_guard_1 = 4,

            --Cavalry
            wh2_main_hef_cav_dragon_princes = 3,
            wh2_dlc15_hef_veh_lion_chariot_of_chrace_0 = 2,
            wh2_main_hef_cav_ithilmar_chariot = 2,

            --Artillery
            wh2_main_hef_art_eagle_claw_bolt_thrower = 1,

            --Monsters
            wh2_dlc15_hef_mon_war_lions_of_chrace_0 = 1,
            wh2_main_hef_mon_moon_dragon = 2,
            wh2_main_hef_mon_star_dragon = 2,
            wh2_main_hef_mon_sun_dragon = 2,
            wh2_dlc15_hef_mon_arcane_phoenix_0 = 1,

            --Heroes
            wh2_main_hef_cha_noble_0 = 1,
            wh2_dlc10_hef_cha_handmaiden_0 = 1,
            wh2_main_hef_cha_mage_life_0 = 1,
            wh2_main_hef_cha_loremaster_of_hoeth_0 = 1,
        },
    },
    lizardmen = {
        earlygame = {

            --Melee Infantry
            wh2_main_lzd_inf_saurus_spearmen_0 = 4,
            wh2_main_lzd_inf_saurus_spearmen_1 = 4,
            wh2_main_lzd_inf_saurus_warriors_0 = 4,
            wh2_main_lzd_inf_saurus_warriors_1 = 4,
            wh2_main_lzd_inf_skink_cohort_0 = 8,

            --Ranged Infantry
            wh2_main_lzd_inf_skink_cohort_1 = 4,
            wh2_main_lzd_inf_chameleon_skinks_0 = 2,
            wh2_main_lzd_inf_skink_skirmishers_0 = 6,

            --Cavalry
            wh2_main_lzd_cav_cold_one_spearmen_1 = 4,
            wh2_main_lzd_cav_horned_ones_0 = 3,
            wh2_main_lzd_cav_cold_ones_1 = 3,

            --Monsters
            wh2_main_lzd_mon_kroxigors = 2,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_main_lzd_mon_bastiladon_2 = 1,
            wh2_main_lzd_mon_carnosaur_0 = 1,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
        midgame = {

            --Infantry
            wh2_main_lzd_inf_saurus_spearmen_0 = 8,
            wh2_main_lzd_inf_saurus_spearmen_1 = 8,
            wh2_main_lzd_inf_saurus_warriors_0 = 8,
            wh2_main_lzd_inf_saurus_warriors_1 = 8,
            wh2_main_lzd_inf_chameleon_skinks_0 = 6,
            wh2_main_lzd_inf_temple_guards = 2,

            --Cavalry
            wh2_main_lzd_cav_cold_one_spearmen_1 = 4,
            wh2_main_lzd_cav_horned_ones_0 = 3,
            wh2_main_lzd_cav_cold_ones_1 = 3,

            --Monsters
            wh2_main_lzd_mon_kroxigors = 2,
            wh2_dlc13_lzd_mon_razordon_pack_0 = 1,
            wh2_dlc12_lzd_mon_salamander_pack_0 = 1,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_main_lzd_mon_bastiladon_2 = 1,
            wh2_main_lzd_mon_ancient_stegadon = 1,
            wh2_dlc17_lzd_mon_troglodon_0 = 1,
            wh2_main_lzd_mon_carnosaur_0 = 1,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
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
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_main_lzd_mon_bastiladon_2 = 1,
            wh2_dlc12_lzd_mon_bastiladon_3 = 1,         -- Arc of Sotek
            wh2_main_lzd_mon_ancient_stegadon = 1,
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 1,   -- Engine of the gods
            wh2_dlc17_lzd_mon_troglodon_0 = 1,
            wh2_main_lzd_mon_carnosaur_0 = 1,
            wh2_dlc13_lzd_mon_dread_saurian_1 = 1,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
        lategame_hexoatl = {

            --Infantry
            wh2_main_lzd_inf_saurus_spearmen_0 = 2,
            wh2_main_lzd_inf_saurus_spearmen_1 = 6,
            wh2_main_lzd_inf_saurus_warriors_0 = 2,
            wh2_main_lzd_inf_saurus_warriors_1 = 6,
            wh2_main_lzd_inf_temple_guards = 4,

            --Cavalry
            wh2_main_lzd_cav_cold_ones_1 = 2,
            wh2_main_lzd_cav_cold_one_spearmen_1 = 4,
            wh2_main_lzd_cav_horned_ones_0 = 4,

            --Monsters
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
        },
        lategame_last_defenders = {

            --Cavalry
            wh2_main_lzd_cav_cold_one_spearmen_1 = 2,
            wh2_main_lzd_cav_horned_ones_0 = 2,
            wh2_main_lzd_cav_cold_ones_1 = 2,
            wh2_dlc12_lzd_cav_ripperdactyl_riders_0 = 2, -- Not exactly cavalry, but on the category.

            --Monsters
            wh2_main_lzd_mon_kroxigors = 4,
            wh2_dlc13_lzd_mon_razordon_pack_0 = 2,
            wh2_dlc12_lzd_mon_salamander_pack_0 = 2,
            wh2_dlc12_lzd_mon_ancient_salamander_0 = 2,
            wh2_main_lzd_mon_bastiladon_1 = 2,          -- Healer boi
            wh2_main_lzd_mon_bastiladon_2 = 2,
            wh2_dlc12_lzd_mon_bastiladon_3 = 2,         -- Arc of Sotek
            wh2_main_lzd_mon_ancient_stegadon = 2,
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 2,   -- Engine of the gods
            wh2_main_lzd_mon_carnosaur_0 = 4,
            wh2_dlc13_lzd_mon_dread_saurian_1 = 1,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
        lategame_cult_of_sotek = {

            --Infantry
            wh2_main_lzd_inf_saurus_spearmen_0 = 3,
            wh2_main_lzd_inf_saurus_warriors_0 = 3,
            wh2_main_lzd_inf_temple_guards = 2,
            wh2_main_lzd_inf_chameleon_skinks_0 = 8,
            wh2_dlc17_lzd_inf_chameleon_stalkers_0 = 8,

            --Cavalry
            wh2_main_lzd_cav_cold_ones_1 = 2,
            wh2_main_lzd_cav_cold_one_spearmen_1 = 2,

            --Monsters
            wh2_main_lzd_mon_kroxigors = 4,
            wh2_dlc12_lzd_mon_salamander_pack_0 = 3,
            wh2_dlc12_lzd_mon_ancient_salamander_0 = 3,
            wh2_main_lzd_mon_bastiladon_1 = 2,          -- Healer boi
            wh2_dlc12_lzd_mon_bastiladon_3 = 2,         -- Arc of Sotek
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 1,   -- Engine of the gods

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
        lategame_tlaqua = {

            --Infantry
            wh2_main_lzd_inf_chameleon_skinks_0 = 4,
            wh2_dlc17_lzd_inf_chameleon_stalkers_0 = 4,

            --Cavalry
            wh2_main_lzd_cav_cold_ones_1 = 2,
            wh2_main_lzd_cav_cold_one_spearmen_1 = 2,
            wh2_dlc12_lzd_cav_ripperdactyl_riders_0 = 8, -- Not exactly cavalry, but on the category.
            wh2_dlc12_lzd_cav_terradon_riders_0_tlaqua = 6,
            wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua = 6,

            --Monsters
            wh2_dlc13_lzd_mon_razordon_pack_0 = 6,
            wh2_dlc12_lzd_mon_salamander_pack_0 = 4,
            wh2_dlc12_lzd_mon_ancient_salamander_0 = 2,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_dlc12_lzd_mon_bastiladon_3 = 1,         -- Arc of Sotek
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 1,   -- Engine of the gods

            --Heroes
            wh2_main_lzd_cha_skink_chief_3 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
            wh2_main_lzd_cha_skink_priest_heavens_3 = 1,
        },
        lategame_itza = {

            --Infantry
            wh2_main_lzd_inf_saurus_spearmen_0 = 2,
            wh2_main_lzd_inf_saurus_spearmen_1 = 6,
            wh2_main_lzd_inf_saurus_warriors_0 = 2,
            wh2_main_lzd_inf_saurus_warriors_1 = 6,
            wh2_main_lzd_inf_temple_guards = 4,

            --Cavalry
            wh2_main_lzd_cav_cold_ones_1 = 2,
            wh2_main_lzd_cav_cold_one_spearmen_1 = 4,
            wh2_main_lzd_cav_horned_ones_0 = 4,

            --Monsters
            wh2_main_lzd_mon_kroxigors = 2,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_dlc12_lzd_mon_bastiladon_3 = 1,         -- Arc of Sotek
            wh2_dlc13_lzd_mon_dread_saurian_1 = 1,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
        },
        lategame_spirits_of_the_jungle = {

            --Infantry
            wh2_main_lzd_inf_saurus_spearmen_1 = 4,
            wh2_main_lzd_inf_saurus_warriors_1 = 4,
            wh2_main_lzd_inf_temple_guards = 2,

            --Monsters
            wh2_main_lzd_mon_kroxigors = 8,
            wh2_main_lzd_mon_kroxigors_blessed = 4,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_main_lzd_mon_ancient_stegadon = 2,
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 2,   -- Engine of the gods
            wh2_dlc13_lzd_mon_dread_saurian_0 = 2,
            wh2_dlc13_lzd_mon_dread_saurian_1 = 2,

            --Heroes
            wh2_main_lzd_cha_saurus_scar_veteran_2 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
            wh2_main_lzd_cha_skink_priest_heavens_3 = 1,
        },
        lategame_oxyotl = {

            --Infantry
            wh2_dlc17_lzd_inf_chameleon_stalkers_0 = 8,
            wh2_main_lzd_inf_chameleon_skinks_0 = 8,

            --Monsters
            wh2_dlc13_lzd_mon_razordon_pack_0 = 4,
            wh2_dlc12_lzd_mon_salamander_pack_0 = 4,
            wh2_main_lzd_mon_bastiladon_1 = 1,          -- Healer boi
            wh2_dlc12_lzd_mon_ancient_stegadon_1 = 1,   -- Engine of the gods
            wh2_dlc17_lzd_mon_troglodon_0 = 4,
            wh2_main_lzd_mon_carnosaur_0 = 2,
            wh2_dlc13_lzd_mon_dread_saurian_1 = 1,

            --Heroes
            wh2_main_lzd_cha_skink_chief_3 = 1,
            wh2_main_lzd_cha_skink_priest_beasts_3 = 1,
            wh2_main_lzd_cha_skink_priest_heavens_3 = 1,
        },
    },
    skaven = {
        earlygame = {

            --Melee Infantry
            wh2_main_skv_inf_clanrat_spearmen_0 = 8,
            wh2_main_skv_inf_clanrat_spearmen_1 = 8,
            wh2_main_skv_inf_clanrats_0 = 8,
            wh2_main_skv_inf_clanrats_1 = 8,
            wh2_main_skv_inf_night_runners_0 = 6,

            --Ranged Infantry
            wh2_main_skv_inf_night_runners_1 = 4,
            wh2_main_skv_inf_warpfire_thrower = 2,
            wh2_dlc12_skv_inf_ratling_gun_0 = 1,
            wh2_dlc12_skv_inf_warplock_jezzails_0 = 1,
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 1,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 2,

            --Characters
            wh2_main_skv_cha_assassin = 1,
            wh2_main_skv_cha_warlock_engineer = 1,
        },
        midgame = {

            --Melee Infantry
            wh2_main_skv_inf_clanrat_spearmen_0 = 8,
            wh2_main_skv_inf_clanrat_spearmen_1 = 8,
            wh2_main_skv_inf_clanrats_0 = 8,
            wh2_main_skv_inf_clanrats_1 = 8,
            wh2_main_skv_inf_stormvermin_0 = 2,
            wh2_main_skv_inf_stormvermin_1 = 2,
            wh2_main_skv_inf_plague_monks = 1,
            wh2_main_skv_inf_night_runners_0 = 4,

            --Ranged Infantry
            wh2_main_skv_inf_night_runners_1 = 4,
            wh2_main_skv_inf_warpfire_thrower = 2,
            wh2_dlc12_skv_inf_ratling_gun_0 = 3,
            wh2_dlc12_skv_inf_warplock_jezzails_0 = 3,
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 2,
            wh2_main_skv_inf_death_globe_bombardiers = 1,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 1,
            wh2_main_skv_art_warp_lightning_cannon = 1,
            wh2_main_skv_veh_doomwheel = 1,

            --Characters
            wh2_main_skv_cha_assassin = 1,
            wh2_main_skv_cha_warlock_engineer = 1,
        },
        lategame = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 6,
            wh2_main_skv_inf_stormvermin_1 = 6,
            wh2_main_skv_inf_plague_monks = 4,

            --Ranged Infantry
            wh2_dlc12_skv_inf_ratling_gun_0 = 6,
            wh2_dlc12_skv_inf_warplock_jezzails_0 = 6,
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 4,
            wh2_main_skv_inf_death_globe_bombardiers = 4,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,
            wh2_main_skv_mon_hell_pit_abomination = 1,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 2,
            wh2_main_skv_art_warp_lightning_cannon = 2,
            wh2_main_skv_veh_doomwheel = 1,

            --Characters
            wh2_main_skv_cha_assassin = 1,
            wh2_main_skv_cha_warlock_engineer = 1,
        },

        -- This one is basically to increase numbers. It's intended to be pure trash.
        lategame_trash = {

            --Melee Infantry
            wh2_main_skv_inf_skavenslave_spearmen_0 = 8,
            wh2_main_skv_inf_skavenslaves_0 = 8,
            wh2_main_skv_inf_clanrats_0 = 4,
            wh2_main_skv_inf_clanrats_1 = 4,

            --Ranged Infantry
            wh2_main_skv_inf_skavenslave_slingers_0 = 8,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,

            --Artillery
            wh2_main_skv_art_warp_lightning_cannon = 2,

            --Characters
            wh2_main_skv_cha_assassin = 1,
            wh2_main_skv_cha_warlock_engineer = 1,
            wh2_main_skv_cha_plague_priest_2 = 1,
        },

        lategame_skryre = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 4,
            wh2_main_skv_inf_stormvermin_1 = 4,

            --Ranged Infantry
            wh2_dlc12_skv_inf_ratling_gun_0 = 8,
            wh2_dlc12_skv_inf_warplock_jezzails_0 = 8,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 2,
            wh2_main_skv_art_warp_lightning_cannon = 2,
            wh2_main_skv_veh_doomwheel = 2,
            wh2_dlc12_skv_veh_doom_flayer_0 = 3,

            --Characters
            wh2_main_skv_cha_warlock_engineer = 1,
        },
        lategame_pestilens = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 4,
            wh2_main_skv_inf_stormvermin_1 = 4,
            wh2_main_skv_inf_plague_monks = 8,

            --Ranged Infantry
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 4,
            wh2_main_skv_inf_death_globe_bombardiers = 4,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,
            wh2_main_skv_mon_hell_pit_abomination = 1,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 2,
            wh2_main_skv_veh_doomwheel = 2,

            --Characters
            wh2_main_skv_cha_plague_priest_0 = 1,
            wh2_main_skv_cha_plague_priest_2 = 1,
        },
        lategame_mors = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 8,
            wh2_main_skv_inf_stormvermin_1 = 8,

            --Ranged Infantry
            wh2_dlc12_skv_inf_ratling_gun_0 = 3,
            wh2_dlc12_skv_inf_warplock_jezzails_0 = 3,
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 2,
            wh2_main_skv_inf_death_globe_bombardiers = 2,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 4,
            wh2_main_skv_mon_hell_pit_abomination = 2,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 1,
            wh2_main_skv_art_warp_lightning_cannon = 1,
            wh2_main_skv_veh_doomwheel = 1,

            --Characters
            wh2_dlc16_skv_cha_chieftain_1 = 1,
            wh2_main_skv_cha_assassin = 1,
        },
        lategame_moulder = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 3,
            wh2_main_skv_inf_stormvermin_1 = 3,

            --Ranged Infantry
            wh2_dlc14_skv_inf_poison_wind_mortar_0 = 4,
            wh2_main_skv_inf_death_globe_bombardiers = 4,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 4,
            wh2_dlc16_skv_mon_rat_ogre_mutant = 8,
            wh2_dlc16_skv_mon_brood_horror_0 = 6,
            wh2_main_skv_mon_hell_pit_abomination = 3,

            --Characters
            wh2_dlc16_skv_cha_packmaster_0 = 1,
            wh2_dlc16_skv_cha_packmaster_2 = 1,
        },
        lategame_eshin = {

            --Melee Infantry
            wh2_main_skv_inf_death_runners_0 = 8,
            wh2_dlc14_skv_inf_eshin_triads_0 = 8,
            wh2_dlc14_skv_inf_warp_grinder_0 = 2,

            --Ranged Infantry
            wh2_main_skv_inf_night_runners_0 = 6,
            wh2_main_skv_inf_night_runners_1 = 6,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,

            --Artillery
            wh2_main_skv_art_plagueclaw_catapult = 1,
            wh2_main_skv_art_warp_lightning_cannon = 1,
            wh2_main_skv_veh_doomwheel = 1,

            --Characters
            wh2_dlc14_skv_cha_eshin_sorcerer_0 = 1,
            wh2_main_skv_cha_assassin = 1,
        },
        lategame_rictus = {

            --Melee Infantry
            wh2_main_skv_inf_stormvermin_0 = 6,
            wh2_main_skv_inf_stormvermin_1 = 6,

            --Ranged Infantry
            wh2_dlc12_skv_inf_ratling_gun_0 = 4,
            wh2_main_skv_inf_night_runners_0 = 6,
            wh2_main_skv_inf_night_runners_1 = 6,

            --Monsters
            wh2_main_skv_mon_rat_ogres = 2,
            wh2_dlc16_skv_mon_brood_horror_0 = 2,
            wh2_main_skv_mon_hell_pit_abomination = 1,

            --Artillery
            wh2_main_skv_art_warp_lightning_cannon = 1,
            wh2_main_skv_veh_doomwheel = 1,

            --Characters
            wh2_dlc16_skv_cha_chieftain_0 = 1,
            wh2_main_skv_cha_assassin = 1,
        },
    },
    cathay = {
        earlygame = {

            --Melee Infantry
            wh3_main_cth_inf_peasant_spearmen_1 = 8,
            wh3_main_cth_inf_jade_warriors_0 = 4,
            wh3_main_cth_inf_jade_warriors_1 = 2,

            --Ranged Infantry
            wh3_main_cth_inf_iron_hail_gunners_0 = 2,
            wh3_main_cth_inf_peasant_archers_0 = 6,
            wh3_main_cth_inf_jade_warrior_crossbowmen_0 = 2,

            --Cavalry -- ignore the peaseant horsement, they're trash.
            wh3_main_cth_cav_jade_lancers_0 = 2,

            --Artillery
            wh3_main_cth_art_grand_cannon_0 = 1,
            wh3_main_cth_veh_sky_lantern_0 = 1,

            --Heroes
            wh3_main_cth_cha_alchemist_0 = 1,
            wh3_main_cth_cha_astromancer_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh3_main_cth_inf_peasant_spearmen_1 = 4,
            wh3_main_cth_inf_jade_warriors_0 = 8,
            wh3_main_cth_inf_jade_warriors_1 = 4,

            --Ranged Infantry
            wh3_main_cth_inf_peasant_archers_0 = 3,
            wh3_main_cth_inf_jade_warrior_crossbowmen_0 = 6,
            wh3_main_cth_inf_jade_warrior_crossbowmen_1 = 4,
            wh3_main_cth_inf_crane_gunners_0 = 2,

            --Cavalry
            wh3_main_cth_cav_jade_lancers_0 = 3,

            --Artillery
            wh3_main_cth_art_grand_cannon_0 = 1,
            wh3_main_cth_veh_war_compass_0 = 1,
            wh3_main_cth_veh_sky_lantern_0 = 1,

            --Heroes
            wh3_main_cth_cha_alchemist_0 = 1,
            wh3_main_cth_cha_astromancer_0 = 1,
        },
        lategame = {

            --Melee Infantry
            wh3_main_cth_inf_jade_warriors_0 = 4,
            wh3_main_cth_inf_jade_warriors_1 = 4,
            wh3_main_cth_inf_dragon_guard_0 = 6,

            --Ranged Infantry
            wh3_main_cth_inf_jade_warrior_crossbowmen_0 = 2,
            wh3_main_cth_inf_jade_warrior_crossbowmen_1 = 4,
            wh3_main_cth_inf_crane_gunners_0 = 3,
            wh3_main_cth_inf_dragon_guard_crossbowmen_0 = 6,

            --Cavalry
            wh3_main_cth_cav_jade_lancers_0 = 2,
            wh3_main_cth_cav_jade_longma_riders_0 = 3,

            --Artillery
            wh3_main_cth_art_fire_rain_rocket_battery_0 = 1,
            wh3_main_cth_veh_war_compass_0 = 1,
            wh3_main_cth_veh_sky_junk_0 = 1,

            --Monsters
            wh3_main_cth_mon_terracotta_sentinel_0 = 2,

            --Heroes
            wh3_main_cth_cha_alchemist_0 = 1,
            wh3_main_cth_cha_astromancer_0 = 1,
        }
    },
    daemons = {
        earlygame = {

            --Infantry
            wh3_main_nur_inf_nurglings_0 = 8,
            wh3_main_tze_inf_blue_horrors_0 = 8,
            wh3_main_nur_inf_plaguebearers_0 = 8,
            wh3_main_sla_inf_daemonette_0 = 8,

            --Ranged Infantry
            wh3_main_tze_inf_pink_horrors_0 = 6,

            --Monsters
            wh3_main_nur_mon_beast_of_nurgle_0 = 2,
            wh3_main_nur_mon_plague_toads_0 = 3,
            wh3_main_tze_mon_screamers_0 = 2,
            wh3_main_kho_inf_flesh_hounds_of_khorne_0 = 2,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
            wh3_main_tze_cha_iridescent_horror_metal_0 = 1,
            wh3_main_tze_cha_iridescent_horror_tzeentch_0 = 1,
            wh3_main_nur_cha_plagueridden_death_0 = 1,
            wh3_main_nur_cha_plagueridden_nurgle_0 = 1,
            wh3_main_sla_cha_alluress_shadow_0 = 1,
            wh3_main_sla_cha_alluress_slaanesh_0 = 1,
        },
        midgame = {

            --Infantry
            wh3_main_nur_inf_nurglings_0 = 4,
            wh3_main_nur_inf_plaguebearers_1 = 8,
            wh3_main_sla_inf_daemonette_1 = 8,
            wh3_main_kho_inf_bloodletters_0 = 8,

            --Ranged Infantry
            wh3_main_tze_inf_pink_horrors_1 = 6,

            --Cavalry
            wh3_main_tze_veh_burning_chariot_0 = 2,

            --Monsters
            wh3_main_nur_cav_pox_riders_of_nurgle_0 = 2,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 3,
            wh3_main_nur_mon_rot_flies_0 = 3,
            wh3_main_tze_cha_exalted_lord_of_change_tzeentch_0 = 1,
            wh3_main_tze_mon_flamers_0 = 1,

            --Artillery
            wh3_main_kho_veh_blood_shrine_0 = 1,
            wh3_main_kho_veh_skullcannon_0 = 1,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
            wh3_main_tze_cha_iridescent_horror_metal_0 = 1,
            wh3_main_tze_cha_iridescent_horror_tzeentch_0 = 1,
            wh3_main_nur_cha_plagueridden_death_0 = 1,
            wh3_main_nur_cha_plagueridden_nurgle_0 = 1,
            wh3_main_sla_cha_alluress_shadow_0 = 1,
            wh3_main_sla_cha_alluress_slaanesh_0 = 1,
        },
        lategame = {

            --Infantry
            wh3_main_nur_inf_plaguebearers_1 = 8,
            wh3_main_sla_inf_daemonette_1 = 8,
            wh3_main_kho_inf_bloodletters_1 = 8,

            --Ranged Infantry
            wh3_main_tze_inf_pink_horrors_1 = 6,

            --Cavalry
            wh3_main_tze_veh_burning_chariot_0 = 2,

            --Monsters
            wh3_main_nur_cav_plague_drones_0 = 2,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 3,
            wh3_main_nur_mon_great_unclean_one_0 = 1,
            wh3_main_sla_mon_keeper_of_secrets_0 = 1,
            wh3_main_tze_cha_exalted_lord_of_change_tzeentch_0 = 1,
            wh3_main_kho_mon_bloodthirster_0 = 1,

            --Artillery
            wh3_main_kho_mon_soul_grinder_0 = 1,
            wh3_main_nur_mon_soul_grinder_0 = 1,
            wh3_main_sla_mon_soul_grinder_0 = 1,
            wh3_main_tze_mon_soul_grinder_0 = 1,
            wh3_main_kho_veh_blood_shrine_0 = 1,
            wh3_main_kho_veh_skullcannon_0 = 1,
            wh3_main_tze_mon_exalted_flamer_0 = 1,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
            wh3_main_tze_cha_iridescent_horror_metal_0 = 1,
            wh3_main_tze_cha_iridescent_horror_tzeentch_0 = 1,
            wh3_main_nur_cha_plagueridden_death_0 = 1,
            wh3_main_nur_cha_plagueridden_nurgle_0 = 1,
            wh3_main_sla_cha_alluress_shadow_0 = 1,
            wh3_main_sla_cha_alluress_slaanesh_0 = 1,
        },
    },
    khorne = {
        earlygame = {

            --Infantry
            wh3_main_kho_inf_chaos_warriors_0 = 4,
            wh3_main_kho_inf_chaos_warriors_1 = 4,
            wh3_main_kho_inf_chaos_warriors_2 = 4,
            wh3_dlc20_chs_inf_forsaken_mkho = 4,
            wh3_main_kho_inf_bloodletters_0 = 8,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mkho_lances = 2,
            wh3_dlc20_chs_cav_chaos_chariot_mkho = 1,

            --Monsters
            wh3_main_kho_mon_spawn_of_khorne_0 = 2,

            --Artillery
            wh3_main_kho_veh_skullcannon_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mkho = 1,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
        },
        midgame = {

            --Infantry
            wh3_main_kho_inf_chaos_warriors_0 = 6,
            wh3_main_kho_inf_chaos_warriors_1 = 6,
            wh3_main_kho_inf_chaos_warriors_2 = 6,
            wh3_dlc20_chs_inf_chosen_mkho = 2,
            wh3_dlc20_chs_inf_forsaken_mkho = 4,
            wh3_main_kho_inf_bloodletters_0 = 8,
            wh3_main_kho_inf_bloodletters_1 = 4,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mkho = 2,
            wh3_dlc20_chs_cav_chaos_knights_mkho_lances = 2,
            wh3_dlc20_chs_cav_chaos_chariot_mkho = 1,

            --Monsters
            wh3_main_kho_mon_spawn_of_khorne_0 = 2,
            wh3_main_kho_mon_khornataurs_0 = 1,
            wh3_main_kho_mon_bloodthirster_0 = 1,

            --Artillery
            wh3_main_kho_veh_skullcannon_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mkho = 1,
            wh3_main_kho_veh_blood_shrine_0 = 1,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
        },
        lategame = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_mkho = 6,
            wh3_dlc20_chs_inf_chosen_mkho_dualweapons = 6,
            wh3_main_kho_inf_bloodletters_1 = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mkho = 2,
            wh3_dlc20_chs_cav_chaos_knights_mkho_lances = 2,
            wh3_main_kho_cav_bloodcrushers_0 = 2,
            wh3_main_kho_cav_skullcrushers_0 = 2,
            wh3_main_kho_cav_gorebeast_chariot = 1,

            --Monsters
            wh3_main_kho_mon_spawn_of_khorne_0 = 2,
            wh3_main_kho_mon_khornataurs_0 = 1,
            wh3_main_kho_mon_khornataurs_1 = 1,
            wh3_main_kho_mon_bloodthirster_0 = 1,
            wh3_main_kho_mon_soul_grinder_0 = 1,

            --Artillery
            wh3_main_kho_veh_skullcannon_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mkho = 1,
            wh3_main_kho_veh_blood_shrine_0 = 1,

            --Heroes
            wh3_main_kho_cha_bloodreaper_0 = 1,
        },
        lategame_humans_only = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_mkho = 6,
            wh3_dlc20_chs_inf_chosen_mkho_dualweapons = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mkho = 2,
            wh3_dlc20_chs_cav_chaos_knights_mkho_lances = 2,
            wh3_main_kho_cav_skullcrushers_0 = 2,
            wh3_main_kho_cav_gorebeast_chariot = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mkho = 1,
        },
        lategame_daemons_only = {

            --Infantry
            wh3_main_kho_inf_bloodletters_1 = 6,

            --Cavalry
            wh3_main_kho_cav_bloodcrushers_0 = 2,

            --Monsters
            wh3_main_kho_mon_spawn_of_khorne_0 = 2,
            wh3_main_kho_mon_khornataurs_0 = 1,
            wh3_main_kho_mon_khornataurs_1 = 1,
            wh3_main_kho_mon_bloodthirster_0 = 1,
            wh3_main_kho_mon_soul_grinder_0 = 1,

            --Artillery
            wh3_main_kho_veh_skullcannon_0 = 1,

            --Vehicles
            wh3_main_kho_veh_blood_shrine_0 = 1,
        }
    },
    kislev = {
        earlygame = {

            --Melee Infantry
            wh3_main_ksl_inf_armoured_kossars_0 = 8,
            wh3_main_ksl_inf_armoured_kossars_1 = 8,

            --Ranged Infantry
            wh3_main_ksl_inf_kossars_0 = 8,
            wh3_main_ksl_inf_kossars_1 = 8,

            --Cavalry
            wh3_main_ksl_cav_horse_archers_0 = 3,
            wh3_main_ksl_cav_kossovite_dervishes_0 = 2,

            --Monsters
            wh3_main_ksl_mon_snow_leopard_0 = 1,

            --Artillery
            wh3_main_ksl_veh_little_grom_0 = 1,

            --Heroes
            wh3_main_ksl_cha_patriarch_0 = 1,
            wh3_main_ksl_cha_frost_maiden_ice_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh3_main_ksl_inf_armoured_kossars_0 = 6,
            wh3_main_ksl_inf_armoured_kossars_1 = 6,
            wh3_main_ksl_inf_tzar_guard_0 = 3,
            wh3_main_ksl_inf_tzar_guard_1 = 3,

            --Ranged Infantry
            wh3_main_ksl_inf_kossars_0 = 6,
            wh3_main_ksl_inf_kossars_1 = 6,
            wh3_main_ksl_inf_streltsi_0 = 4,

            --Cavalry
            wh3_main_ksl_cav_winged_lancers_0 = 2,
            wh3_main_ksl_veh_light_war_sled_0 = 2,
            wh3_main_ksl_veh_heavy_war_sled_0 = 2,

            --Monsters
            wh3_main_ksl_mon_snow_leopard_0 = 1,
            wh3_main_ksl_mon_elemental_bear_0 = 1,

            --Artillery
            wh3_main_ksl_veh_little_grom_0 = 1,

            --Heroes
            wh3_main_ksl_cha_patriarch_0 = 1,
            wh3_main_ksl_cha_frost_maiden_ice_0 = 1,
        },
        lategame = {

            --Melee Infantry
            wh3_main_ksl_inf_armoured_kossars_0 = 3,
            wh3_main_ksl_inf_armoured_kossars_1 = 3,
            wh3_main_ksl_inf_tzar_guard_0 = 6,
            wh3_main_ksl_inf_tzar_guard_1 = 6,

            --Ranged Infantry
            wh3_main_ksl_inf_streltsi_0 = 4,
            wh3_main_ksl_inf_ice_guard_0 = 6,
            wh3_main_ksl_inf_ice_guard_1 = 6,

            --Cavalry
            wh3_main_ksl_cav_gryphon_legion_0 = 2,
            wh3_main_ksl_cav_war_bear_riders_1 = 2,
            wh3_main_ksl_veh_light_war_sled_0 = 2,
            wh3_main_ksl_veh_heavy_war_sled_0 = 2,

            --Monsters
            wh3_main_ksl_mon_snow_leopard_0 = 1,
            wh3_main_ksl_mon_elemental_bear_0 = 1,

            --Artillery
            wh3_main_ksl_veh_little_grom_0 = 1,

            --Heroes
            wh3_main_ksl_cha_patriarch_0 = 1,
            wh3_main_ksl_cha_frost_maiden_ice_0 = 1,
        },
    },
    nurgle = {
        earlygame = {

            --Infantry
            wh3_dlc20_chs_inf_chaos_marauders_mnur = 8,
            wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons = 8,
            wh3_main_nur_inf_nurglings_0 = 6,
            wh3_dlc20_chs_inf_chaos_warriors_mnur = 4,
            wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons = 4,
            wh3_main_nur_inf_forsaken_0 = 3,
            wh3_main_nur_inf_plaguebearers_0 = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_chariot_mnur = 2,

            --Monsters
            wh3_main_nur_mon_plague_toads_0 = 2,
            wh3_main_nur_cav_pox_riders_of_nurgle_0 = 2,
            wh3_main_nur_mon_spawn_of_nurgle_0 = 2,
            wh3_main_nur_mon_rot_flies_0 = 2,
            wh3_main_nur_mon_beast_of_nurgle_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mnur = 1,
        },
        midgame = {

            --Infantry
            wh3_dlc20_chs_inf_chaos_warriors_mnur = 8,
            wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons = 8,
            wh3_main_nur_inf_forsaken_0 = 3,
            wh3_main_nur_inf_plaguebearers_0 = 6,
            wh3_main_nur_inf_plaguebearers_1 = 3,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_chariot_mnur = 2,
            wh3_dlc20_chs_cav_chaos_knights_mnur_lances = 2,

            --Monsters
            wh3_main_nur_mon_spawn_of_nurgle_0 = 2,
            wh3_main_nur_mon_rot_flies_0 = 2,
            wh3_main_nur_mon_beast_of_nurgle_0 = 1,
            wh3_main_nur_mon_great_unclean_one_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mnur = 1,
        },
        lategame = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_mnur = 6,
            wh3_dlc20_chs_inf_chosen_mnur_greatweapons = 6,
            wh3_main_nur_inf_plaguebearers_1 = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mnur = 2,
            wh3_dlc20_chs_cav_chaos_knights_mnur_lances = 2,

            --Monsters
            wh3_main_nur_mon_spawn_of_nurgle_0 = 2,
            wh3_main_nur_cav_plague_drones_0 = 1,
            wh3_main_nur_cav_plague_drones_1 = 1,
            wh3_main_nur_mon_great_unclean_one_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mnur = 1,
            wh3_main_nur_mon_soul_grinder_0 = 1,
        },
        lategame_humans_only = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_mnur = 6,
            wh3_dlc20_chs_inf_chosen_mnur_greatweapons = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_mnur = 2,
            wh3_dlc20_chs_cav_chaos_knights_mnur_lances = 2,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_mnur = 1,
        },
        lategame_daemons_only = {

            --Infantry
            wh3_main_nur_inf_plaguebearers_1 = 6,

            --Monsters
            wh3_main_nur_mon_spawn_of_nurgle_0 = 2,
            wh3_main_nur_cav_plague_drones_0 = 1,
            wh3_main_nur_cav_plague_drones_1 = 1,
            wh3_main_nur_mon_great_unclean_one_0 = 1,

            --Vehicles
            wh3_main_nur_mon_soul_grinder_0 = 1,
        }
    },
    ogre_kingdoms = {
        earlygame = {

            --Melee Infantry
            wh3_main_ogr_inf_gnoblars_0 = 4,

            --Ranged Infantry
            wh3_main_ogr_inf_gnoblars_1 = 6,

            --Cavalry
            wh3_main_ogr_cav_mournfang_cavalry_0 = 4,

            --Monsters
            wh3_main_ogr_mon_sabretusk_pack_0 = 2,
            wh3_main_ogr_inf_ogres_0 = 4,
            wh3_main_ogr_inf_ogres_1 = 8,
            wh3_main_ogr_inf_ogres_2 = 4,
            wh3_main_ogr_mon_gorgers_0 = 6,
            wh3_main_ogr_inf_leadbelchers_0 = 2,

            -- Artillery
            wh3_main_ogr_veh_gnoblar_scraplauncher_0 = 1,
        },
        midgame = {

            --Ranged Infantry
            wh3_main_ogr_inf_gnoblars_1 = 4,

            --Cavalry
            wh3_main_ogr_cav_mournfang_cavalry_1 = 4,
            wh3_main_ogr_cav_mournfang_cavalry_2 = 4,

            --Monsters
            wh3_main_ogr_mon_sabretusk_pack_0 = 2,
            wh3_main_ogr_inf_maneaters_0 = 8,
            wh3_main_ogr_inf_maneaters_1 = 4,
            wh3_main_ogr_inf_maneaters_2 = 4,
            wh3_main_ogr_inf_maneaters_3 = 8,
            wh3_main_ogr_inf_ironguts_0 = 4,
            wh3_main_ogr_mon_gorgers_0 = 4,
            wh3_main_ogr_inf_leadbelchers_0 = 2,

            -- Artillery
            wh3_main_ogr_veh_gnoblar_scraplauncher_0 = 1,
        },
        lategame = {

            --Ranged Infantry
            wh3_main_ogr_inf_gnoblars_1 = 4,

            --Cavalry
            wh3_main_ogr_cav_crushers_0 = 4,
            wh3_main_ogr_cav_crushers_1 = 4,

            --Monsters
            wh3_main_ogr_inf_maneaters_1 = 4,
            wh3_main_ogr_inf_maneaters_2 = 6,
            wh3_main_ogr_inf_maneaters_3 = 6,
            wh3_main_ogr_inf_ironguts_0 = 4,
            wh3_main_ogr_mon_gorgers_0 = 4,
            wh3_main_ogr_inf_leadbelchers_0 = 4,
            wh3_main_ogr_mon_stonehorn_0 = 2,
            wh3_main_ogr_mon_stonehorn_1 = 2,

            -- Artillery
            wh3_main_ogr_veh_gnoblar_scraplauncher_0 = 1,
            wh3_main_ogr_veh_ironblaster_0 = 1,
        },
    },
    slaanesh = {
        earlygame = {

            --Infantry
            wh3_main_sla_inf_marauders_0 = 6,
            wh3_main_sla_inf_marauders_1 = 6,
            wh3_main_sla_inf_marauders_2 = 6,
            wh3_dlc20_chs_inf_chaos_warriors_msla = 4,
            wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges = 2,
            wh3_dlc20_chs_inf_forsaken_msla = 2,
            wh3_main_sla_inf_daemonette_0 = 8,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_msla_lances = 2,
            wh3_main_sla_cav_hellstriders_0 = 1,
            wh3_main_sla_veh_seeker_chariot_0 = 1,

            --Monsters
            wh3_main_sla_mon_spawn_of_slaanesh_0 = 2,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_msla = 1,
        },
        midgame = {

            --Infantry
            wh3_dlc20_chs_inf_chaos_warriors_msla = 6,
            wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges = 6,
            wh3_dlc20_chs_inf_forsaken_msla = 3,
            wh3_main_sla_inf_daemonette_0 = 8,
            wh3_main_sla_inf_daemonette_1 = 4,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_msla_lances = 2,
            wh3_main_sla_cav_hellstriders_0 = 1,
            wh3_main_sla_cav_hellstriders_1 = 1,
            wh3_main_sla_veh_seeker_chariot_0 = 2,

            --Monsters
            wh3_main_sla_mon_spawn_of_slaanesh_0 = 2,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_msla = 1,
        },
        lategame = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_msla = 6,
            wh3_dlc20_chs_inf_chosen_msla_hellscourges = 6,
            wh3_main_sla_inf_daemonette_1 = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_msla = 2,
            wh3_dlc20_chs_cav_chaos_knights_msla_lances = 2,
            wh3_main_sla_cav_hellstriders_0 = 2,
            wh3_main_sla_cav_hellstriders_1 = 2,
            wh3_main_sla_cav_seekers_of_slaanesh_0 = 2,
            wh3_main_sla_cav_heartseekers_of_slaanesh_0 = 2,
            wh3_main_sla_veh_hellflayer_0 = 2,
            wh3_main_sla_veh_seeker_chariot_0 = 2,
            wh3_main_sla_veh_exalted_seeker_chariot_0 = 2,

            --Monsters
            wh3_main_sla_mon_spawn_of_slaanesh_0 = 2,
            wh3_main_sla_mon_keeper_of_secrets_0 = 1,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_msla = 1,
            wh3_main_sla_mon_soul_grinder_0 = 1,
        },
        lategame_humans_only = {

            --Infantry
            wh3_dlc20_chs_inf_chosen_msla = 6,
            wh3_dlc20_chs_inf_chosen_msla_hellscourges = 6,

            --Cavalry
            wh3_dlc20_chs_cav_chaos_knights_msla = 2,
            wh3_dlc20_chs_cav_chaos_knights_msla_lances = 2,
            wh3_main_sla_cav_hellstriders_0 = 2,
            wh3_main_sla_cav_hellstriders_1 = 2,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine_msla = 1,
        },
        lategame_daemons_only = {

            --Infantry
            wh3_main_sla_inf_daemonette_1 = 6,

            --Cavalry
            wh3_main_sla_cav_seekers_of_slaanesh_0 = 2,
            wh3_main_sla_cav_heartseekers_of_slaanesh_0 = 2,
            wh3_main_sla_veh_hellflayer_0 = 2,
            wh3_main_sla_veh_seeker_chariot_0 = 2,
            wh3_main_sla_veh_exalted_seeker_chariot_0 = 2,

            --Monsters
            wh3_main_sla_mon_spawn_of_slaanesh_0 = 2,
            wh3_main_sla_mon_keeper_of_secrets_0 = 1,
            wh3_main_sla_mon_fiends_of_slaanesh_0 = 1,

            --Vehicles
            wh3_main_sla_mon_soul_grinder_0 = 1,
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
        },
        lategame_humans_only = {

            --Melee Infantry
            wh3_dlc20_chs_inf_chosen_mtze = 6,
            wh3_dlc20_chs_inf_chosen_mtze_halberds = 6,

            --Cavalry
            wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins = 2,
            wh3_dlc20_chs_cav_chaos_chariot_mtze = 2,
            wh3_dlc20_chs_cav_chaos_knights_mtze_lances = 2,
            wh3_main_tze_cav_chaos_knights_0 = 1,
            wh3_main_tze_cav_doom_knights_0 = 2,
        },
        lategame_daemons_only = {

            --Melee Infantry
            wh3_main_tze_inf_forsaken_0 = 4,

            --Ranged Infantry
            wh3_main_tze_inf_pink_horrors_0 = 2,
            wh3_main_tze_inf_pink_horrors_1 = 4,

            --Cavalry
            wh3_main_tze_veh_burning_chariot_0 = 2,

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
    beastmen = {
        earlygame = {

            --Melee Infantry
            wh_dlc03_bst_inf_gor_herd_0 = 6,
            wh_dlc03_bst_inf_gor_herd_1 = 6,
            wh_dlc03_bst_inf_ungor_spearmen_0 = 8,
            wh_dlc03_bst_inf_ungor_spearmen_1 = 8,

            --Ranged Infantry
            wh_dlc03_bst_inf_ungor_raiders_0 = 6,

            --Cavalry
            wh_dlc03_bst_inf_centigors_0 = 2,
            wh_dlc03_bst_inf_centigors_1 = 4,
            wh_dlc03_bst_inf_centigors_2 = 4,
            wh2_dlc17_bst_cav_tuskgor_chariot_0 = 2,

            --Monsters
            wh_dlc03_bst_inf_chaos_warhounds_1 = 2,
            wh_dlc05_bst_mon_harpies_0 = 2,
            wh_dlc03_bst_inf_razorgor_herd_0 = 2,
        },
        midgame = {

            --Melee Infantry
            wh_dlc03_bst_inf_gor_herd_0 = 8,
            wh_dlc03_bst_inf_gor_herd_1 = 8,
            wh_dlc03_bst_inf_bestigor_herd_0 = 4,

            --Ranged Infantry
            wh_dlc03_bst_inf_ungor_raiders_0 = 6,

            --Cavalry
            wh_dlc03_bst_inf_centigors_1 = 4,
            wh_dlc03_bst_inf_centigors_2 = 4,
            wh2_dlc17_bst_cav_tuskgor_chariot_0 = 2,
            wh_dlc03_bst_cav_razorgor_chariot_0 = 1,

            --Monsters
            wh_dlc03_bst_inf_chaos_warhounds_1 = 2,
            wh_dlc05_bst_mon_harpies_0 = 2,
            wh_dlc03_bst_inf_razorgor_herd_0 = 2,
            wh_dlc03_bst_inf_minotaurs_0 = 1,
            wh_dlc03_bst_inf_cygor_0 = 1,
            wh_dlc03_bst_mon_chaos_spawn_0 = 3,
        },
        lategame = {

            --Melee Infantry
            wh_dlc03_bst_inf_gor_herd_0 = 4,
            wh_dlc03_bst_inf_gor_herd_1 = 4,
            wh_dlc03_bst_inf_bestigor_herd_0 = 8,

            --Ranged Infantry
            wh_dlc03_bst_inf_ungor_raiders_0 = 6,

            --Cavalry
            wh_dlc03_bst_inf_centigors_1 = 4,
            wh_dlc03_bst_inf_centigors_2 = 4,
            wh_dlc03_bst_cav_razorgor_chariot_0 = 2,

            --Monsters
            wh_dlc03_bst_inf_minotaurs_1 = 4,
            wh_dlc03_bst_inf_minotaurs_2 = 4,
            wh_dlc03_bst_inf_cygor_0 = 1,
            wh_dlc03_bst_mon_chaos_spawn_0 = 3,
            wh2_dlc17_bst_mon_ghorgon_0 = 1,
            wh2_dlc17_bst_mon_jabberslythe_0 = 1,
        },
    },
    wood_elves = {
        earlygame = {

            --Melee Infantry
            wh_dlc05_wef_inf_eternal_guard_0 = 8,
            wh_dlc05_wef_inf_eternal_guard_1 = 8,
            wh_dlc05_wef_inf_wardancers_0 = 2,
            wh_dlc05_wef_inf_wardancers_1 = 2,

            --Ranged Infantry
            wh_dlc05_wef_inf_glade_guard_1 = 8,
            wh_dlc05_wef_inf_glade_guard_2 = 8,
            wh_dlc05_wef_inf_deepwood_scouts_1 = 4,

            --Cavalry
            wh_dlc05_wef_cav_glade_riders_0 = 4,
            wh_dlc05_wef_cav_glade_riders_1 = 4,
            wh_dlc05_wef_cav_hawk_riders_0 = 2,

            --Monsters
            wh_dlc05_wef_mon_treekin_0 = 2,
            wh_dlc05_wef_mon_great_eagle_0 = 2,
        },
        midgame = {

            --Melee Infantry
            wh_dlc05_wef_inf_eternal_guard_1 = 6,
            wh_dlc05_wef_inf_wildwood_rangers_0 = 2,
            wh_dlc05_wef_inf_wardancers_0 = 6,
            wh_dlc05_wef_inf_wardancers_1 = 6,

            --Ranged Infantry
            wh_dlc05_wef_inf_glade_guard_1 = 6,
            wh_dlc05_wef_inf_glade_guard_2 = 6,
            wh_dlc05_wef_inf_deepwood_scouts_1 = 8,
            wh_dlc05_wef_inf_waywatchers_0 = 2,

            --Cavalry
            wh_dlc05_wef_cav_wild_riders_0 = 2,
            wh_dlc05_wef_cav_wild_riders_1 = 2,
            wh_dlc05_wef_cav_glade_riders_0 = 4,
            wh_dlc05_wef_cav_glade_riders_1 = 4,
            wh_dlc05_wef_cav_hawk_riders_0 = 2,

            --Monsters
            wh_dlc05_wef_mon_treekin_0 = 2,
            wh_dlc05_wef_mon_treeman_0 = 2,
            wh_dlc05_wef_mon_great_eagle_0 = 2,
            wh_dlc05_wef_forest_dragon_0 = 1,
        },
        lategame = {

            --Melee Infantry
            wh_dlc05_wef_inf_wildwood_rangers_0 = 4,
            wh_dlc05_wef_inf_wardancers_0 = 8,
            wh_dlc05_wef_inf_wardancers_1 = 8,
            wh2_dlc16_wef_inf_bladesingers_0 = 4,

            --Ranged Infantry
            wh_dlc05_wef_inf_deepwood_scouts_1 = 8,
            wh_dlc05_wef_inf_waywatchers_0 = 6,

            --Cavalry
            wh_dlc05_wef_cav_wild_riders_0 = 6,
            wh_dlc05_wef_cav_wild_riders_1 = 4,
            wh_dlc05_wef_cav_glade_riders_0 = 4,
            wh_dlc05_wef_cav_glade_riders_1 = 2,
            wh_dlc05_wef_cav_hawk_riders_0 = 1,
            wh_dlc05_wef_cav_sisters_thorn_0 = 2,

            --Monsters
            wh_dlc05_wef_mon_treekin_0 = 4,
            wh_dlc05_wef_mon_treeman_0 = 4,
            wh_dlc05_wef_mon_great_eagle_0 = 1,
            wh_dlc05_wef_forest_dragon_0 = 2,
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
    bretonnia = {
        earlygame = {

            --Melee Infantry
            wh_dlc07_brt_inf_peasant_mob_0 = 4,
            wh_dlc07_brt_inf_men_at_arms_1 = 6,
            wh_dlc07_brt_inf_men_at_arms_2 = 3,
            wh_dlc07_brt_inf_spearmen_at_arms_1 = 6,
            wh_dlc07_brt_inf_grail_reliquae_0 = 1,

            --Range Infantry
            wh_main_brt_inf_peasant_bowmen = 2,
            wh_dlc07_brt_inf_peasant_bowmen_1 = 6,
            wh_dlc07_brt_inf_peasant_bowmen_2 = 6,

            --Cavalry
            wh_main_brt_cav_mounted_yeomen_0 = 2,
            wh_main_brt_cav_mounted_yeomen_1 = 2,
            wh_dlc07_brt_cav_knights_errant_0 = 6,
            wh_main_brt_cav_knights_of_the_realm = 4,

            --Artillery
            wh_main_brt_art_field_trebuchet = 1,

            --Heroes
            wh_dlc07_brt_cha_damsel_life_0 = 1,
            wh_dlc07_brt_cha_damsel_beasts_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh_dlc07_brt_inf_peasant_mob_0 = 2,
            wh_dlc07_brt_inf_men_at_arms_1 = 6,
            wh_dlc07_brt_inf_men_at_arms_2 = 4,
            wh_dlc07_brt_inf_spearmen_at_arms_1 = 4,
            wh_dlc07_brt_inf_grail_reliquae_0 = 1,
            wh_dlc07_brt_inf_battle_pilgrims_0 = 2,
            wh_dlc07_brt_inf_foot_squires_0 = 3,

            --Range Infantry
            wh_main_brt_inf_peasant_bowmen = 2,
            wh_dlc07_brt_inf_peasant_bowmen_1 = 6,
            wh_dlc07_brt_inf_peasant_bowmen_2 = 6,

            --Cavalry
            wh_main_brt_cav_mounted_yeomen_1 = 2,
            wh_dlc07_brt_cav_knights_errant_0 = 6,
            wh_main_brt_cav_knights_of_the_realm = 6,
            wh_main_brt_cav_pegasus_knights = 1,
            wh_dlc07_brt_cav_questing_knights_0 = 2,

            --Artillery
            wh_dlc07_brt_art_blessed_field_trebuchet_0 = 1,

            --Heroes
            wh_dlc07_brt_cha_damsel_life_0 = 1,
            wh_dlc07_brt_cha_damsel_beasts_0 = 1,
        },
        lategame = {

            --Melee Infantry
            wh_dlc07_brt_inf_men_at_arms_2 = 4,
            wh_dlc07_brt_inf_grail_reliquae_0 = 1,
            wh_dlc07_brt_inf_battle_pilgrims_0 = 4,
            wh_dlc07_brt_inf_foot_squires_0 = 6,

            --Range Infantry
            wh_main_brt_inf_peasant_bowmen = 2,
            wh_dlc07_brt_inf_peasant_bowmen_1 = 6,
            wh_dlc07_brt_inf_peasant_bowmen_2 = 6,

            --Cavalry
            wh_dlc07_brt_cav_questing_knights_0 = 6,
            wh_main_brt_cav_grail_knights = 6,
            wh_dlc07_brt_cav_grail_guardians_0 = 2,
            wh_dlc07_brt_cav_royal_hippogryph_knights_0 = 2,
            wh_main_brt_cav_pegasus_knights = 2,

            --Artillery
            wh_dlc07_brt_art_blessed_field_trebuchet_0 = 1,

            --Heroes
            wh_dlc07_brt_cha_damsel_life_0 = 1,
            wh_dlc07_brt_cha_damsel_beasts_0 = 1,
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
        },
        lategame_humans_only = {

            --Infantry
            wh_main_chs_inf_chosen_0 = 6,
            wh_main_chs_inf_chosen_1 = 6,
            wh_dlc01_chs_inf_chosen_2 = 6,
            wh_dlc06_chs_inf_aspiring_champions_0 = 2, -- They're not really monsters but they're a low entity unit like monsters

            --Cavalry
            wh_dlc01_chs_cav_gorebeast_chariot = 1,
            wh_main_chs_cav_chaos_knights_0 = 2,
            wh_main_chs_cav_chaos_knights_1 = 2,

            --Artillery
            wh_main_chs_art_hellcannon = 1,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine = 1,
        },
        lategame_daemons_only = {

            --Infantry
            wh_dlc01_chs_inf_forsaken_0 = 4,
            wh_main_chs_mon_chaos_spawn = 4,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine = 1,
        },
        lategame_beasts_and_daemons = {

            --Monsters
            wh_main_chs_mon_trolls = 3,
            wh_dlc01_chs_mon_trolls_1 = 3,
            wh_main_chs_mon_chaos_spawn = 4,
            wh_main_chs_mon_giant = 2,
            wh_dlc01_chs_mon_dragon_ogre = 6,
            wh_dlc01_chs_mon_dragon_ogre_shaggoth = 6,

            --Vehicles
            wh3_dlc20_chs_mon_warshrine = 1,
        },
    },
    dwarfs = {
        earlygame = {

            --Melee Infantry
            wh_main_dwf_inf_miners_0 = 4,
            wh_main_dwf_inf_miners_1 = 4,
            wh_main_dwf_inf_dwarf_warrior_0 = 8,
            wh_main_dwf_inf_dwarf_warrior_1 = 8,
            wh_main_dwf_inf_slayers = 4,

            --Ranged Infantry
            wh_main_dwf_inf_quarrellers_0 = 8,
            wh_main_dwf_inf_quarrellers_1 = 8,
            wh_main_dwf_inf_thunderers_0 = 2,

            --Artillery
            wh_dlc06_dwf_art_bolt_thrower_0 = 2,
            wh_main_dwf_art_grudge_thrower = 2,
        },
        midgame = {

            --Melee Infantry
            wh_main_dwf_inf_dwarf_warrior_0 = 6,
            wh_main_dwf_inf_dwarf_warrior_1 = 6,
            wh_main_dwf_inf_longbeards = 2,
            wh_main_dwf_inf_longbeards_1 = 2,
            wh_main_dwf_inf_hammerers = 2,
            wh_main_dwf_inf_ironbreakers = 2,
            wh_main_dwf_inf_slayers = 4,

            --Ranged Infantry
            wh_main_dwf_inf_quarrellers_0 = 4,
            wh_main_dwf_inf_quarrellers_1 = 4,
            wh_main_dwf_inf_thunderers_0 = 6,
            wh_main_dwf_inf_irondrakes_0 = 2,
            wh_main_dwf_inf_irondrakes_2 = 2,
            wh_dlc06_dwf_inf_rangers_0 = 2,
            wh_dlc06_dwf_inf_rangers_1 = 2,

            --Artillery
            wh_main_dwf_art_grudge_thrower = 2,
            wh_main_dwf_art_cannon = 4,
            wh_main_dwf_art_organ_gun = 2,

            --Vehicles
            wh_main_dwf_veh_gyrocopter_0 = 1,
            wh_main_dwf_veh_gyrocopter_1 = 1,
        },
        lategame = {

            --Melee Infantry
            wh_main_dwf_inf_longbeards = 4,
            wh_main_dwf_inf_longbeards_1 = 6,
            wh_main_dwf_inf_hammerers = 8,
            wh_main_dwf_inf_ironbreakers = 8,
            wh_main_dwf_inf_slayers = 6,
            wh2_dlc10_dwf_inf_giant_slayers = 4,

            --Ranged Infantry
            wh_main_dwf_inf_thunderers_0 = 8,
            wh_main_dwf_inf_irondrakes_0 = 4,
            wh_main_dwf_inf_irondrakes_2 = 4,
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
    empire = {
        earlygame = {

            --Melee Infantry
            wh_dlc04_emp_inf_flagellants_0 = 2,
            wh_main_emp_inf_swordsmen = 8,
            wh_main_emp_inf_halberdiers = 6,

            --Ranged Infantry
            wh_main_emp_inf_crossbowmen = 6,
            wh_main_emp_inf_handgunners = 2,
            wh2_dlc13_emp_inf_archers_0 = 4,

            --Cavalry
            wh_main_emp_cav_pistoliers_1 = 4,
            wh_main_emp_cav_outriders_0 = 4,
            wh_main_emp_cav_outriders_1 = 4,
            wh_main_emp_cav_empire_knights = 2,

            --Artillery
            wh_main_emp_art_mortar = 1,
            wh_main_emp_art_great_cannon = 1,
            wh_main_emp_art_helblaster_volley_gun = 1,
            wh_main_emp_art_helstorm_rocket_battery = 1,
        },
        midgame = {

            --Melee Infantry
            wh_dlc04_emp_inf_flagellants_0 = 2,
            wh_main_emp_inf_swordsmen = 6,
            wh_main_emp_inf_halberdiers = 6,
            wh_main_emp_inf_greatswords = 4,

            --Ranged Infantry
            wh_main_emp_inf_crossbowmen = 4,
            wh_main_emp_inf_handgunners = 6,
            wh_dlc04_emp_inf_free_company_militia_0 = 1,

            --Cavalry
            wh_main_emp_cav_outriders_0 = 2,
            wh_main_emp_cav_outriders_1 = 2,
            wh_main_emp_cav_empire_knights = 4,
            wh_main_emp_cav_reiksguard = 2,
            wh_dlc04_emp_cav_knights_blazing_sun_0 = 2,

            --Artillery
            wh_main_emp_art_mortar = 1,
            wh_main_emp_art_great_cannon = 1,
            wh_main_emp_art_helblaster_volley_gun = 1,
            wh_main_emp_art_helstorm_rocket_battery = 1,
        },
        lategame = {

            --Melee Infantry
            wh_dlc04_emp_inf_flagellants_0 = 3,
            wh_main_emp_inf_halberdiers = 6,
            wh_main_emp_inf_greatswords = 8,

            --Ranged Infantry
            wh_main_emp_inf_crossbowmen = 4,
            wh_main_emp_inf_handgunners = 6,
            wh_dlc04_emp_inf_free_company_militia_0 = 1,

            --Cavalry
            wh_main_emp_cav_empire_knights = 4,
            wh_main_emp_cav_reiksguard = 1,
            wh_dlc04_emp_cav_knights_blazing_sun_0 = 1,
            wh_main_emp_cav_demigryph_knights_0 = 2,
            wh_main_emp_cav_demigryph_knights_1 = 2,

            --Artillery
            wh_main_emp_art_great_cannon = 1,
            wh_main_emp_art_helblaster_volley_gun = 1,
            wh_main_emp_art_helstorm_rocket_battery = 2,
        },
    },
    greenskins = {
        earlygame = {

            --Melee Infantry
            wh_main_grn_inf_night_goblins = 4,
            wh_dlc06_grn_inf_nasty_skulkers_0 = 2,
            wh_main_grn_inf_orc_boyz = 8,
            wh_main_grn_inf_orc_big_uns = 2,

            --Ranged Infantry
            wh_main_grn_inf_night_goblin_archers = 4,
            wh_main_grn_inf_orc_arrer_boyz = 6,
            wh_main_grn_inf_savage_orc_arrer_boyz = 2,

            --Cavalry
            wh_main_grn_cav_orc_boar_boyz = 4,
            wh_main_grn_cav_orc_boar_chariot = 2,

            --Monsters
            wh2_dlc15_grn_mon_river_trolls_0 = 2,
            wh2_dlc15_grn_mon_stone_trolls_0 = 2,
            wh_main_grn_mon_giant = 1,

            --Artillery
            wh_main_grn_art_goblin_rock_lobber = 1,
            wh_main_grn_art_doom_diver_catapult = 2,

            --Hero
            wh2_pro09_grn_cha_black_orc_big_boss_0 = 1,
            wh_main_grn_cha_orc_shaman_0 = 1,
        },
        midgame = {

            --Melee Infantry
            wh_dlc06_grn_inf_nasty_skulkers_0 = 2,
            wh_main_grn_inf_orc_boyz = 6,
            wh_main_grn_inf_orc_big_uns = 8,

            --Ranged Infantry
            wh_main_grn_inf_night_goblin_archers = 4,
            wh_main_grn_inf_orc_arrer_boyz = 6,
            wh_main_grn_inf_savage_orc_arrer_boyz = 2,

            --Cavalry
            wh_main_grn_cav_orc_boar_boyz = 4,
            wh_main_grn_cav_orc_boar_boy_big_uns = 6,
            wh_main_grn_cav_orc_boar_chariot = 2,

            --Monsters
            wh2_dlc15_grn_mon_river_trolls_0 = 2,
            wh2_dlc15_grn_mon_stone_trolls_0 = 2,
            wh_main_grn_mon_giant = 2,

            --Artillery
            wh_main_grn_art_goblin_rock_lobber = 2,
            wh_main_grn_art_doom_diver_catapult = 4,

            --Hero
            wh2_pro09_grn_cha_black_orc_big_boss_0 = 1,
            wh_main_grn_cha_orc_shaman_0 = 1,
        },
        lategame_orcs = {

            --Infantry
            wh_dlc06_grn_inf_nasty_skulkers_0 = 2,
            wh_main_grn_inf_orc_big_uns = 8,
            wh_main_grn_inf_black_orcs = 8,
            wh_main_grn_inf_night_goblin_archers = 2,
            wh_main_grn_inf_savage_orc_arrer_boyz = 6,

            --Cavalry
            wh_main_grn_cav_orc_boar_boyz = 1,
            wh_main_grn_cav_orc_boar_boy_big_uns = 2,
            wh_main_grn_cav_orc_boar_chariot = 1,
            wh_main_grn_cav_savage_orc_boar_boyz = 4,
            wh_main_grn_cav_savage_orc_boar_boy_big_uns = 4,

            --Monsters
            wh2_dlc15_grn_mon_river_trolls_0 = 2,
            wh2_dlc15_grn_mon_stone_trolls_0 = 2,
            wh_main_grn_mon_giant = 2,
            wh_main_grn_mon_arachnarok_spider_0 = 1,
            wh2_dlc15_grn_mon_rogue_idol_0 = 1,

            --Artillery
            wh_main_grn_art_goblin_rock_lobber = 2,
            wh_main_grn_art_doom_diver_catapult = 4,

            --Hero
            wh2_pro09_grn_cha_black_orc_big_boss_0 = 1,
            wh_main_grn_cha_orc_shaman_0 = 1,
        },

        lategame_goblins = {

            --Infantry
            wh_dlc06_grn_inf_nasty_skulkers_0 = 4,
            wh_main_grn_inf_night_goblins = 6,
            wh_main_grn_inf_night_goblin_fanatics = 4,
            wh_main_grn_inf_night_goblin_fanatics_1 = 4,
            wh_main_grn_inf_night_goblin_archers = 8,

            --Cavalry
            wh_main_grn_cav_goblin_wolf_riders_0 = 2,
            wh_main_grn_cav_goblin_wolf_riders_1 = 4,
            wh_main_grn_cav_goblin_wolf_chariot = 3,
            wh_main_grn_cav_forest_goblin_spider_riders_0 = 2,
            wh_main_grn_cav_forest_goblin_spider_riders_1 = 2,
            wh_dlc06_grn_cav_squig_hoppers_0 = 1,

            --Monsters
            wh_dlc06_grn_inf_squig_herd_0 = 2,
            wh2_dlc15_grn_mon_river_trolls_0 = 3,
            wh2_dlc15_grn_mon_stone_trolls_0 = 3,
            wh_main_grn_mon_giant = 1,
            wh_main_grn_mon_arachnarok_spider_0 = 1,
            wh2_dlc15_grn_mon_rogue_idol_0 = 1,

            --Vechicles
            wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0 = 2,
            wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0 = 2,

            --Artillery
            wh_main_grn_art_goblin_rock_lobber = 1,
            wh_main_grn_art_doom_diver_catapult = 2,

            --Hero
            wh_main_grn_cha_goblin_big_boss_0 = 1,
            wh_main_grn_cha_goblin_great_shaman_0 = 1,
        },
    },
    savage_orcs = {
        lategame = {

            --Infantry
            wh_main_grn_inf_savage_orc_big_uns = 8,
            wh_main_grn_inf_savage_orc_arrer_boyz = 8,

            --Cavalry
            wh_main_grn_cav_orc_boar_chariot = 2,
            wh_main_grn_cav_savage_orc_boar_boyz = 2,
            wh_main_grn_cav_savage_orc_boar_boy_big_uns = 3,

            --Monsters
            wh2_dlc15_grn_mon_river_trolls_0 = 3,
            wh2_dlc15_grn_mon_stone_trolls_0 = 3,
            wh_main_grn_mon_giant = 2,
            wh_main_grn_mon_arachnarok_spider_0 = 1,
            wh2_dlc15_grn_mon_rogue_idol_0 = 1,

            --Artillery
            wh_main_grn_art_goblin_rock_lobber = 1,

            --Hero
            wh2_dlc15_grn_cha_river_troll_hag_0 = 1,
            wh_main_grn_cha_orc_shaman_0 = 1,
        },
    },
    teb = {},
    vampire_counts = {
        earlygame = {

            --Infantry
            wh_main_vmp_inf_zombie = 6,
            wh_main_vmp_inf_skeleton_warriors_1 = 6,
            wh_main_vmp_inf_crypt_ghouls = 6,
            wh_main_vmp_inf_cairn_wraiths = 4,
            wh_main_vmp_inf_grave_guard_0 = 2,

            --Cavalry
            wh_main_vmp_cav_black_knights_0 = 2,
            wh_main_vmp_cav_hexwraiths = 1,

            --Monsters
            wh_main_vmp_mon_fell_bats = 1,
            wh_main_vmp_mon_dire_wolves = 1,
            wh_main_vmp_mon_crypt_horrors = 4,
            wh_main_vmp_mon_vargheists = 2,

            --Vehicles
            wh_dlc04_vmp_veh_corpse_cart_1 = 1,
            wh_dlc04_vmp_veh_corpse_cart_2 = 1,
        },
        midgame = {

            --Infantry
            wh_main_vmp_inf_skeleton_warriors_1 = 4,
            wh_main_vmp_inf_crypt_ghouls = 6,
            wh_main_vmp_inf_cairn_wraiths = 4,
            wh_main_vmp_inf_grave_guard_0 = 8,
            wh_main_vmp_inf_grave_guard_1 = 8,

            --Cavalry
            wh_main_vmp_cav_black_knights_3 = 2,
            wh_main_vmp_cav_hexwraiths = 1,

            --Monsters
            wh_main_vmp_mon_fell_bats = 1,
            wh_main_vmp_mon_dire_wolves = 1,
            wh_main_vmp_mon_crypt_horrors = 4,
            wh_main_vmp_mon_vargheists = 2,
            wh_main_vmp_mon_varghulf = 1,
            wh_main_vmp_mon_terrorgheist = 1,

            --Vehicles
            wh_dlc04_vmp_veh_corpse_cart_1 = 1,
            wh_dlc04_vmp_veh_corpse_cart_2 = 1,
            wh_main_vmp_veh_black_coach = 1,
        },
        lategame = {

            --Infantry
            wh_main_vmp_inf_crypt_ghouls = 2,
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
}
