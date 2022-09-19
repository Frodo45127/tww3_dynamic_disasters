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

    -- Who the fuck would raid that? The AI, aparently. A lot.
    antartid = {
        "wh3_main_combi_region_the_daemonium_coast",
        "wh3_main_combi_region_serpent_coast_sea",
        "wh3_main_combi_region_the_churning_gulf",
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
