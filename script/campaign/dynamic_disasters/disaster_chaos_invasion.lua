--[[
    The End Times disaster, By Frodo45127.

    This disaster consists on a massive Chaos invasion to the whole world. This one is pretty complex, offering ample warning.

    Requirements:
        - Random chance: 0.1% (1/100 turns).
        - At least turn 100 (so the player has already "prepared").
        - Archaon must be not confederated (it's the one it starts the invasion).

    Effects:
        - Trigger/Early Warning:
            - Message about something in the north from the old Chaos Invasion.
            - Wait 8-12 turns for more info.
        - Stage 1:
            - If Archaon has been confederated, end the disaster here.
            - If not:
                - Targets (TODO: Force them to try to get to the targets):
                    - Archaon: Kislev, Praag, Erenburg.
                    - Sigvald: No particular target, just buildup of forces.
                    - Kholek: Zharr Naggrund, Firemouth.
                    - Valkia: Naggarond.
                    - Vilich: Great Bastion.
                - Spawn each faction's armies in provinces we expect they have by now.
                - Each attacker faction declares war on all non-chaos/non vassal of chaos owners of said provinces and on all its neightbours.
                - (TODO: UI is broken)If player is Cathay, "Flow of the Polar Gates" increases bastion thread.
                - Trigger "Flow of the Polar Gates" incident (global chaos corruption).
                - Trigger "Chaos Rises" video.
                - Wait 6-10 turns for more info.
        - Stage 2:
            - Targets (TODO: Force them to try to get to the targets):
                - Archaon: Kislev, Praag, Erenburg (Reinforcements).
                - Sigvald: No particular target, just buildup of forces (Reinforcements).
                - Kholek: Zharr Naggrund, Firemouth (Reinforcements).
                - Daniel: Norsca.
                - Belakor: The Oak of Ages... ideally. But we're going to just give him reinforcements at Konquatta.

                - Skarbrand: This one just give him armies wherever its capital is, or at Infernius if he got himself killed.
                - Kugath: Mousillon.
                - Kairos: Mousillon, Carcassone, Bastonne.
                - Sarthorael: High Sentinel, Kara's Temple, Bregonne.
                - N'Kari: Gaen Vale, Asurian's Temple, Tor Elyr, White Tower of Hoeth.

                - Valkia: Naggarond (Reinforcements).
                - Festus: Altdorf, Middenheim, Talabheim.
                - Vilich: Great Bastion (Reinforcements), Averheim (From Barak Varr).
                - Azzazel: Tor Sethai, Vaul's Anvil (Ulthuan), Lothern.

            - Spawn each faction's armies in provinces we expect they have by now, at sea, or near their objectives.
            - Each attacker faction declares war on all non-chaos/non vassal of chaos owners of said provinces and on all its neightbours.
            - Trigger "Flow of the Polar Gates" incident (global chaos corruption).
            - Trigger "Chaos Invasion" (Sarthorael's spawn) video.
            - Give all non player-controlled dark fortresses to chaos armies, if they're owned by norsca.
            - Rifts:
                - Spawn respawnable rifts across the Northern and Southern chaos wastes.
                - Spawn respawnable rifts on all provinces that reach at least 75 of any chaos corruption.
                - Rifts change chaos god depending on the region owner.
                - Rifts have a (10% + (self.settings.difficulty_mod * 10)) chance to spawn an army each turns.
                - Spawned armies belong either to the faction that owns the Rift (if demonic) or to Archaon.
                - If a character travels through a rift, it has a chance of receiving the trait for being on the related realm too long.
                - If a character travels through a rift, it has a chance of spotting a Daemon Prince. If the character accepts to fight it, it'll gain a trait for being in a realm of chaos too long. If the character wins the fight, it'll win a chaos realm ancillary.
                - TODO: Make sure all chaos realm battles are fought in storms of magic.
                - TODO: Add ancillaries for Nurgle and Tzeench.
        - Stage 2a:
            - If Gaen Vale, Asurian's Temple, Tor Elyr and White Tower of Hoeth are either in hands of Chaos, Norsca, or in Ruins:
                - Trigger "The Great Vortex Undone", which has the following effects:
                    - Spawn respawnable rifts across the whole world in any region with over 75 of Corruption.
                    - "Hide" the vortex by removing the VFX.
                    - Give mission to "restore" the Vortex by taking back Gaen Vale, Asurian's Temple, Tor Elyr and White Tower of Hoeth.
                    - When the mission is completed, stop its effects and rift respawn outside the chaos wastes and norsca.

    -- Reference for the timeline: https://warhammerfantasy.fandom.com/wiki/End_Times_Timeline#Appendix_1_-_Chronology_of_the_End_Times
    Not Yet Implemented:
        - Stage 2a:
            - Give INCARNATION trait to certain characters (maybe).
            - Stage the vortex up and down in size, enabling/disabling rifts in certain parts of the world.

        - Stage 3b:
            - If player is Cathay, Empire, Bretonia, Vampires, High Elves or Dark Elves, trigger a dilemma to become a vassal of chaos:
                - If rejected, continue as normal.
                - If accepted:
                    - Receive ancillaries of the chaos gods.
                    - Sign peace with all chaos factions and restore diplomacy with them.
                    - Disable diplomacy with every other faction. No more diplo for you, traitor.
        - Stage 3a:
            - If Grimgor is alive, trigger a separate disaster of him marching against Cathay.

        - Stage 4:
            - If chaos keeps all dark fortresses, trigger some kind of event about getting the favourt of the 4 chaos gods (TBD).
            - Put static reinforcements on all dark fortresses (1 army of each god).
            - Trigger an endgame event (you lose) if chaos keeps the fortresses for too long.


    NOTE:
        - About rift closing, because I keep forgetting it:
            - First, QueryTeleportationNetworkShouldHandoverCharacterNodeClosure is called to check if the closer is an army and should trigger a battle.
            - Then, TeleportationNetworkCharacterNodeClosureHandedOver is called to generate the army as an invasion force from one of the qbi factions, and at the same time forces the army to fight.
            - Then, BattleCompleted is called if the battle is a closure battle and kills the attacker's faction, then closes the gate.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;

-- Object representing the disaster.
disaster_chaos_invasion = {
    name = "chaos_invasion",

    -- Values for categorizing the disaster.
    is_global = true;
    allowed_for_sc = {},
    denied_for_sc = {           -- Disabled for all chaos-related subcultures except Skaven. They're already broken on their own.
        "wh3_main_sc_dae_daemons",
        "wh3_main_sc_kho_khorne",
        "wh3_main_sc_nur_nurgle",
        "wh3_main_sc_sla_slaanesh",
        "wh3_main_sc_tze_tzeentch",
        "wh_dlc03_sc_bst_beastmen",
        "wh_dlc08_sc_nor_norsca",
        "wh_main_sc_chs_chaos",
    },
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid"
            },
            payloads = {
                "money 25000"
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
        min_turn = 100,                     -- Minimum turn required for the disaster to trigger.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {                    -- Extra settings this disaster may pull from MCT.
            "enable_rifts",
        },

        -- Disaster-specific data.
        enable_rifts = true,
        base_army_unit_count = 19,
        stage_1_delay = 1,
        stage_2_delay = 1,
        grace_period = 1,
        great_vortex_undone = false,

        -- Rewards for the different chaos realms battles.
        khorne_realm_rewards = {
            "wh3_main_anc_weapon_gilellions_soulnetter",
            "wh3_main_anc_weapon_skars_kraken_killer",
            "wh3_main_anc_weapon_the_bane_spear",
            "wh3_main_anc_weapon_chainsword"
        },

        nurgle_realm_rewards = {
            --"wh3_main_anc_weapon_gilellions_soulnetter",
            --"wh3_main_anc_weapon_skars_kraken_killer",
            --"wh3_main_anc_weapon_the_bane_spear",
            --"wh3_main_anc_weapon_chainsword"
        },

        slaanesh_realm_rewards = {
            "wh3_main_anc_follower_the_dark_princes_paramour",
            "wh3_main_anc_follower_personal_sycophant",
            "wh3_main_anc_weapon_slaaneshs_blade"
        },

        tzeench_realm_rewards = {
            --"wh3_main_anc_weapon_gilellions_soulnetter",
            --"wh3_main_anc_weapon_skars_kraken_killer",
            --"wh3_main_anc_weapon_the_bane_spear",
            --"wh3_main_anc_weapon_chainsword"
        },

        -- List of Chaos factions that will participate in the invasion.
        factions = {
            "wh_main_chs_chaos",                    -- Archaon
            "wh3_dlc20_chs_kholek",                 -- Kholek
            "wh3_dlc20_chs_sigvald",                -- Sigvald
            "wh3_main_dae_daemon_prince",           -- Daniel
            "wh3_main_chs_shadow_legion",           -- Belakor

            -- COC
            "wh3_dlc20_chs_valkia",                 -- Valkia
            "wh3_dlc20_chs_festus",                 -- Festus
            "wh3_dlc20_chs_vilitch",                -- Vilich
            "wh3_dlc20_chs_azazel",                 -- Azzazel

            -- Monogods
            "wh3_main_kho_exiles_of_khorne",        -- Skarbrand
            "wh3_main_nur_poxmakers_of_nurgle",     -- Ku'gath
            "wh3_main_tze_oracles_of_tzeentch",     -- Kairos
            "wh3_main_tze_sarthoraels_watchers",    -- Sarthorael, Tzeenchian faction of Aliexpress
            "wh3_main_sla_seducers_of_slaanesh",    -- N'Kari
        },

        stage_1_data = {
            factions = {
                "wh_main_chs_chaos",                -- Archaon
                "wh3_dlc20_chs_kholek",             -- Kholek
                "wh3_dlc20_chs_sigvald",            -- Sigvald
                "wh3_dlc20_chs_valkia",             -- Valkia
                "wh3_dlc20_chs_vilitch",            -- Vilich
            },
            cqis = {},                              -- List of invader's cqi, so we can track them and release them when needed.
            targets = {},                           -- List of regions/factions to invade.
        },

        stage_2_data = {
            factions = {
                "wh_main_chs_chaos",                    -- Archaon
                "wh3_dlc20_chs_kholek",                 -- Kholek
                "wh3_dlc20_chs_sigvald",                -- Sigvald
                "wh3_main_dae_daemon_prince",           -- Daniel
                "wh3_main_chs_shadow_legion",           -- Belakor

                -- COC
                "wh3_dlc20_chs_valkia",                 -- Valkia
                "wh3_dlc20_chs_festus",                 -- Festus
                "wh3_dlc20_chs_vilitch",                -- Vilich
                "wh3_dlc20_chs_azazel",                 -- Azzazel

                -- Monogods
                "wh3_main_kho_exiles_of_khorne",        -- Skarbrand
                "wh3_main_nur_poxmakers_of_nurgle",     -- Ku'gath
                "wh3_main_tze_oracles_of_tzeentch",     -- Kairos
                "wh3_main_tze_sarthoraels_watchers",    -- Sarthorael, Tzeenchian faction of Aliexpress
                "wh3_main_sla_seducers_of_slaanesh",    -- N'Kari
            },
            cqis = {},                                  -- List of invader's cqi, so we can track them and release them when needed.
            targets = {},                               -- List of regions/factions to invade.
        },
    },

    stage_1_data = {
        regions = {
            wh_main_chs_chaos = {
                "wh3_main_combi_region_the_writhing_fortress",
                "wh3_main_combi_region_the_howling_citadel",
                "wh3_main_combi_region_the_crystal_spires",
            },
            wh3_dlc20_chs_kholek = {
                "wh3_main_combi_region_the_challenge_stone",
                "wh3_main_combi_region_the_volary",
                "wh3_main_combi_region_icespewer",
            },
            wh3_dlc20_chs_sigvald = {
                "wh3_main_combi_region_black_rock",
                "wh3_main_combi_region_the_twisted_towers",
                "wh3_main_combi_region_the_forest_of_decay",
            },
            wh3_dlc20_chs_valkia = {
                "wh3_dlc20_combi_region_glacier_encampment",
                "wh3_main_combi_region_dagraks_end",
                "wh3_dlc20_combi_region_glacial_gardens",
            },
            wh3_dlc20_chs_vilitch = {
                "wh3_main_combi_region_red_fortress",
                "wh3_main_combi_region_bloodwind_keep",
                "wh3_main_combi_region_fortress_of_eyes",
            },
        },

        army_templates = {
            wh_main_chs_chaos = {
                chaos = "lategame_humans_only",
                khorne = "lategame_humans_only",
                nurgle = "lategame_humans_only",
                tzeentch = "lategame_humans_only",
                slaanesh = "lategame_humans_only",
            },
            wh3_dlc20_chs_kholek = {
                chaos = "lategame_beasts_and_daemons",
            },
            wh3_dlc20_chs_sigvald = {
                chaos = "lategame",
                slaanesh = "lategame",
            },
            wh3_dlc20_chs_valkia = {
                chaos = "lategame",
                khorne = "lategame",
            },
            wh3_dlc20_chs_vilitch = {
                chaos = "lategame",
                tzeentch = "lategame",
            },
        },
    },

    stage_2_data = {
        regions = {
            wh_main_chs_chaos = {
                land = {
                    regions = {
                        "wh3_main_combi_region_the_writhing_fortress",
                        "wh3_main_combi_region_the_howling_citadel",
                        "wh3_main_combi_region_the_crystal_spires",
                    },
                },
            },
            wh3_dlc20_chs_kholek = {
                land = {
                    regions = {
                        "wh3_main_combi_region_the_challenge_stone",
                        "wh3_main_combi_region_the_volary",
                        "wh3_main_combi_region_icespewer",
                    },
                },
            },
            wh3_dlc20_chs_sigvald = {
                land = {
                    regions = {
                        "wh3_main_combi_region_black_rock",
                        "wh3_main_combi_region_the_twisted_towers",
                        "wh3_main_combi_region_the_forest_of_decay",
                    },
                },
            },
            wh3_main_dae_daemon_prince = {
                land = {
                    regions = {
                        "wh3_main_combi_region_the_forbidden_citadel",
                        "wh3_main_combi_region_sarl_encampment",
                        "wh3_main_combi_region_naglfari_plain",
                    },
                },
            },
            wh3_main_chs_shadow_legion = {
                land = {
                    regions = {
                        "wh3_main_combi_region_konquata",
                        "wh3_main_combi_region_isle_of_wights",
                        "wh3_main_combi_region_citadel_of_lead",
                    },
                },
            },
            wh3_dlc20_chs_valkia = {
                land = {
                    regions = {
                        "wh3_dlc20_combi_region_glacier_encampment",
                        "wh3_main_combi_region_dagraks_end",
                        "wh3_dlc20_combi_region_glacial_gardens",
                    },
                },
            },
            wh3_dlc20_chs_festus = {
                land = {
                    regions = {
                        "wh3_main_combi_region_middenstag", --"wh3_main_combi_region_brass_keep", Brass keep alwasy fail to spawn armies, so we use Middenstag instead as spawning region.
                        "wh3_main_combi_region_hergig",
                        "wh3_dlc20_combi_region_krudenwald",
                    },
                },
            },
            wh3_dlc20_chs_vilitch = {
                land = {
                    regions = {
                        "wh3_main_combi_region_red_fortress",
                        "wh3_main_combi_region_bloodwind_keep",
                        "wh3_main_combi_region_fortress_of_eyes",
                    },
                },
                sea = {
                    coords = {
                        {605, 465},
                        {563, 404},
                    },
                    targets = {
                        "wh3_main_combi_region_matorca",
                        "wh3_main_combi_region_myrmidens",
                    },
                }
            },
            wh3_dlc20_chs_azazel = {
                sea = {
                    coords = {
                        {221, 487},
                        {278, 482},
                    },
                    targets = {
                        "wh3_main_combi_region_lothern",
                        "wh3_main_combi_region_shrine_of_asuryan",
                    },
                }
            },
            wh3_main_kho_exiles_of_khorne = {
                land = {
                    regions = {
                        "wh3_main_combi_region_infernius",
                    }
                },
            },
            wh3_main_nur_poxmakers_of_nurgle = {
                sea = {
                    coords = {
                        {332, 650},
                        {350, 615},
                        {370, 584},
                    },
                    targets = {
                        "wh3_main_combi_region_languille",
                        "wh3_main_combi_region_lyonesse",
                        "wh3_main_combi_region_mousillon",
                    },
                }
            },
            wh3_main_tze_oracles_of_tzeentch = {
                sea = {
                    coords = {
                        {381, 560},
                        {397, 528},
                        {416, 501},
                    },
                    targets = {
                        "wh3_main_combi_region_bordeleaux",
                        "wh3_main_combi_region_parravon",
                        "wh3_main_combi_region_castle_carcassonne",
                    }
                }
            },
            wh3_main_tze_sarthoraels_watchers = {
                sea = {
                    coords = {
                        {132, 412},
                        {181, 373},
                    },
                    targets = {
                        "wh3_main_combi_region_the_high_sentinel",
                        "wh3_main_combi_region_temple_of_kara",
                    }
                }
            },
            wh3_main_sla_seducers_of_slaanesh = {
                land = {
                    regions = {
                        "wh3_main_combi_region_tor_achare",
                        "wh3_main_combi_region_elisia",
                        "wh3_main_combi_region_shrine_of_kurnous",
                    },
                    targets = {
                        "wh3_main_combi_region_gaean_vale",
                        "wh3_main_combi_region_tor_elyr",
                        "wh3_main_combi_region_white_tower_of_hoeth",
                    },
                },
            },
        },

        army_templates = {
            wh_main_chs_chaos = {
                chaos = "lategame_humans_only",
                khorne = "lategame_humans_only",
                nurgle = "lategame_humans_only",
                tzeentch = "lategame_humans_only",
                slaanesh = "lategame_humans_only",
            },
            wh3_dlc20_chs_kholek = {
                chaos = "lategame_beasts_and_daemons",
                khorne = "lategame_daemons_only",
                nurgle = "lategame_daemons_only",
                tzeentch = "lategame_daemons_only",
                slaanesh = "lategame_daemons_only",
            },
            wh3_dlc20_chs_sigvald = {
                chaos = "lategame",
                slaanesh = "lategame",
            },
            wh3_main_dae_daemon_prince = {
                chaos = "lategame_daemons_only",
                khorne = "lategame_daemons_only",
                nurgle = "lategame_daemons_only",
                tzeentch = "lategame_daemons_only",
                slaanesh = "lategame_daemons_only",
            },
            wh3_main_chs_shadow_legion = {
                chaos = "lategame_daemons_only",
                khorne = "lategame_daemons_only",
                nurgle = "lategame_daemons_only",
                tzeentch = "lategame_daemons_only",
                slaanesh = "lategame_daemons_only",
            },
            wh3_dlc20_chs_valkia = {
                chaos = "lategame",
                khorne = "lategame",
            },
            wh3_dlc20_chs_festus = {
                chaos = "lategame",
                nurgle = "lategame",
            },
            wh3_dlc20_chs_vilitch = {
                chaos = "lategame",
                tzeentch = "lategame",
            },
            wh3_dlc20_chs_azazel = {
                chaos = "lategame",
                slaanesh = "lategame",
            },
            wh3_main_kho_exiles_of_khorne = {
                khorne = "lategame",
            },
            wh3_main_nur_poxmakers_of_nurgle = {
                nurgle = "lategame",
            },
            wh3_main_tze_oracles_of_tzeentch = {
                tzeentch = "lategame",
            },
            wh3_main_tze_sarthoraels_watchers = {
                tzeentch = "lategame",
            },
            wh3_main_sla_seducers_of_slaanesh = {
                slaanesh = "lategame",
            },
        },
    },

    dark_fortress_regions = {
        wh_main_chs_chaos = {
            "wh3_main_combi_region_zanbaijin",
            "wh3_main_combi_region_karak_dum",
            "wh3_main_combi_region_karak_vlag",
            "wh3_main_combi_region_the_howling_citadel",
            "wh3_main_combi_region_the_writhing_fortress",
        },
        wh3_dlc20_chs_kholek = {
            "wh3_main_combi_region_the_challenge_stone",
            "wh3_main_combi_region_zharr_naggrund",
            "wh3_main_combi_region_tower_of_gorgoth",
            "wh3_main_combi_region_shang_yang",
        },
        wh3_dlc20_chs_sigvald = {
            "wh3_main_combi_region_the_monolith_of_katam",
            "wh3_main_combi_region_fortress_of_the_damned",
            "wh3_main_combi_region_the_silvered_tower_of_sorcerers",
            "wh3_main_combi_region_doomkeep",
            "wh3_main_combi_region_the_twisted_towers",
        },
        wh3_main_dae_daemon_prince = {
            "wh3_main_combi_region_black_rock",
            "wh3_main_combi_region_the_crystal_spires",
            "wh3_main_combi_region_kraka_drak",
        },
        wh3_main_chs_shadow_legion = {
            "wh3_main_combi_region_konquata",
            "wh3_main_combi_region_monolith_of_borkill_the_bloody_handed",
        },
        wh3_dlc20_chs_valkia = {
            "wh3_main_combi_region_ancient_city_of_quintex",
            "wh3_main_combi_region_the_palace_of_ruin",
            "wh3_main_combi_region_the_frozen_city",
        },
        wh3_dlc20_chs_festus = {
            "wh3_main_combi_region_brass_keep",
            "wh3_main_combi_region_middenheim",
            "wh3_main_combi_region_nuln",
            "wh3_main_combi_region_praag",
        },
        wh3_dlc20_chs_vilitch = {
            "wh3_main_combi_region_red_fortress",
            "wh3_main_combi_region_fortress_of_eyes",
            "wh3_main_combi_region_bloodwind_keep",
            "wh3_main_combi_region_nan_gau",
            "wh3_main_combi_region_wei_jin",
        },
        wh3_dlc20_chs_azazel = {
            "wh3_main_combi_region_the_tower_of_khrakk",
            "wh3_main_combi_region_the_forbidden_citadel",
            "wh3_main_combi_region_dagraks_end",
            "wh3_main_combi_region_altar_of_the_crimson_harvest",
        },
        --wh3_main_kho_exiles_of_khorne = {},
        wh3_main_nur_poxmakers_of_nurgle = {
            "wh3_main_combi_region_black_fortress",
        },
        wh3_main_tze_oracles_of_tzeentch = {
            "wh3_main_combi_region_okkams_forever_maze",
            "wh3_main_combi_region_the_lost_palace",
            "wh3_main_combi_region_the_godless_crater",
            "wh3_main_combi_region_daemons_gate",
        },
        --wh3_main_tze_sarthoraels_watchers = {},
        --wh3_main_sla_seducers_of_slaanesh = {},
    },

    great_vortex_undone = {
        objectives = {
            {
                type = "CONTROL_N_REGIONS_FROM",
                conditions = {
                    "override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
                },
                payloads = {
                    "money 25000"
                }
            }
        },
        regions = {
            "wh3_main_combi_region_gaean_vale",
            "wh3_main_combi_region_shrine_of_asuryan",
            "wh3_main_combi_region_tor_elyr",
            "wh3_main_combi_region_white_tower_of_hoeth",
        },
    },

    --------------------------------
    -- Teleportation nodes stuff
    --------------------------------
    teleportation_nodes_templates = {
        "wh3_main_teleportation_node_template_kho",
        "wh3_main_teleportation_node_template_nur",
        "wh3_main_teleportation_node_template_sla",
        "wh3_main_teleportation_node_template_tze"
    },

    teleportation_nodes_realm_by_templates = {
        wh3_main_teleportation_node_template_kho = "khorne",
        wh3_main_teleportation_node_template_nur = "nurgle",
        wh3_main_teleportation_node_template_sla = "slaanesh",
        wh3_main_teleportation_node_template_tze = "tzeentch"
    },

    teleportation_nodes_defender_army_templates = {
        wh3_main_teleportation_node_template_kho = {
            khorne = "lategame_daemons_only",
        },
        wh3_main_teleportation_node_template_nur = {
            nurgle = "lategame_daemons_only",
        },
        wh3_main_teleportation_node_template_sla = {
            slaanesh = "lategame_daemons_only",
        },
        wh3_main_teleportation_node_template_tze = {
            tzeentch = "lategame_daemons_only",
        }
    },

    teleportation_nodes_chaos_wastes = {
        "dyn_dis_wh3_dlc20_combi_province_frigid_wasteland",        -- x:271, Y: 907 -- Spawns inside a mountain.
        "dyn_dis_wh3_main_combi_province_bloodfire_falls",          -- x:778, Y: 912
        "dyn_dis_wh3_main_combi_province_chimera_plateau",          -- x:1028, Y: 735
        "dyn_dis_wh3_main_combi_province_eastern_steppes",          -- x:1246, Y: 708
        "dyn_dis_wh3_main_combi_province_ironfrost_glacier",        -- x:158, Y: 895 -- Spawns in the province right to ironfrost glaciers, in wh3_dlc20_combi_province_frigid_wasteland.
        "dyn_dis_wh3_main_combi_province_kdatha",                   -- x:994, Y: 830
        "dyn_dis_wh3_main_combi_province_northern_wastes",          -- x:389, Y: 935
        "dyn_dis_wh3_main_combi_province_plain_of_illusions",       -- x:737, Y: 926 -- NOTE: This opens by default with the first one that opens.
        "dyn_dis_wh3_main_combi_province_stonesky_foothills",       -- x:1175, Y: 701
        "dyn_dis_wh3_main_combi_province_the_abyssal_glacier",      -- x:562, Y: 27
        "dyn_dis_wh3_main_combi_province_the_blood_marshes",        -- x:914, Y: 876
        "dyn_dis_wh3_main_combi_province_the_cold_mires",           -- x:473, Y: 939
        "dyn_dis_wh3_main_combi_province_the_daemonium_hills",      -- x:700, Y: 21
        "dyn_dis_wh3_main_combi_province_the_eternal_lagoon",       -- x:581, Y: 949
        "dyn_dis_wh3_main_combi_province_the_ice_fire_plains",      -- x:305, Y: 27
        "dyn_dis_wh3_main_combi_province_the_noisome_tumour",       -- x:652, Y: 942
        "dyn_dis_wh3_main_combi_province_the_red_wastes",           -- x:1305, Y: 667
        "dyn_dis_wh3_main_combi_province_the_shard_lands",          -- x:371, Y: 880
        "dyn_dis_wh3_main_combi_province_the_skull_road",           -- x:881, Y: 773
        "dyn_dis_wh3_main_combi_province_the_southern_wastes",      -- x:458, Y: 48
    },
    teleportation_nodes_norsca = {
        "dyn_dis_wh3_main_combi_province_albion",                   -- X:336, Y:726
        "dyn_dis_wh3_main_combi_province_gianthome_mountains",      -- X:716, Y:850
        "dyn_dis_wh3_main_combi_province_goromadny_mountains",      -- X:814, Y:767
        "dyn_dis_wh3_main_combi_province_helspire_mountains",       -- X:463, Y:865
        "dyn_dis_wh3_main_combi_province_ice_tooth_mountains",      -- X:491, Y:780
        "dyn_dis_wh3_main_combi_province_mountains_of_hel",         -- X:631, Y:853
        "dyn_dis_wh3_main_combi_province_mountains_of_naglfari",    -- X:509, Y:845
        "dyn_dis_wh3_main_combi_province_trollheim_mountains",      -- X:644, Y:816
        "dyn_dis_wh3_main_combi_province_vanaheim_mountains",       -- X:462, Y:802
    },
    teleportation_nodes_cathay = {
        "dyn_dis_wh3_main_combi_province_broken_lands_of_tian_li",  -- X:1221, Y:383 -- Bugged. Spawns inside a mountain.
        "dyn_dis_wh3_main_combi_province_celestial_lake",           -- X:1284, Y:527
        "dyn_dis_wh3_main_combi_province_celestial_riverlands",     -- X:1246, Y:469
        "dyn_dis_wh3_main_combi_province_central_great_bastion",    -- X:1211, Y:655 -- Usable, but spawns in wh3_main_combi_province_lands_of_stone_and_steel, too close to the one for that province.
        "dyn_dis_wh3_main_combi_province_eastern_great_bastion",    -- X:1234, Y:664 -- Bugged. Spawns inside the mountains of the Great Basion.
        "dyn_dis_wh3_main_combi_province_forests_of_the_moon",      -- X:1243, Y:579
        "dyn_dis_wh3_main_combi_province_jade_river_delta",         -- X:1150, Y:654
        "dyn_dis_wh3_main_combi_province_jungles_of_chian",         -- X:1264, Y:653
        "dyn_dis_wh3_main_combi_province_gunpowder_road",           -- X:1358, Y:565
        "dyn_dis_wh3_main_combi_province_imperial_road",            -- X:1307, Y:396 -- Bugged. Spawns unusable, partly inside a mountain.
        "dyn_dis_wh3_main_combi_province_lands_of_stone_and_steel", -- X:1218, Y:656 -- Usable, but model is partially inside a mountain
        "dyn_dis_wh3_main_combi_province_mount_li",                 -- X:1377, Y:415
        "dyn_dis_wh3_main_combi_province_nongchang_basin",          -- X:1261, Y:500
        "dyn_dis_wh3_main_combi_province_plains_of_xen",            -- X:1340, Y:624
        "dyn_dis_wh3_main_combi_province_serpent_estuary",          -- X:1318, Y:368
        "dyn_dis_wh3_main_combi_province_the_great_canal",          -- X:1264, Y:420
        "dyn_dis_wh3_main_combi_province_warpstone_desert",         -- X:1121, Y:561
        "dyn_dis_wh3_main_combi_province_wastelands_of_jinshen",    -- X:1139, Y:494
        "dyn_dis_wh3_main_combi_province_western_great_bastion",    -- X:1182, Y:657 -- Usable, but spawns in wh3_main_combi_province_lands_of_stone_and_steel.
    },
    teleportation_nodes_old_world = {
        "dyn_dis_wh3_dlc20_combi_province_middle_mountains",                -- X:593, Y:725
        "dyn_dis_wh3_main_combi_province_argwylon",                         -- X:523, Y:558
        "dyn_dis_wh3_main_combi_province_averland",                         -- X:627, Y:594
        "dyn_dis_wh3_main_combi_province_axe_bite_pass",                    -- X:484, Y:614
        "dyn_dis_wh3_main_combi_province_barrows_of_cuileux",               -- X:458, Y:555
        "dyn_dis_wh3_main_combi_province_bastonne",                         -- X:440, Y:597
        "dyn_dis_wh3_main_combi_province_black_blood_pass",                 -- X:703, Y:796
        "dyn_dis_wh3_main_combi_province_black_mountains",                  -- X:597, Y:544
        "dyn_dis_wh3_main_combi_province_black_water",                      -- X:726, Y:602
        "dyn_dis_wh3_main_combi_province_blightwater",                      -- X:720, Y:386
        "dyn_dis_wh3_main_combi_province_blood_river_valley",               -- X:660, Y:517
        "dyn_dis_wh3_main_combi_province_broken_teeth",                     -- X:841, Y:396
        "dyn_dis_wh3_main_combi_province_carcassonne",                      -- X:455, Y:510
        "dyn_dis_wh3_main_combi_province_coast_of_lyonesse",                -- X:367, Y:621
        "dyn_dis_wh3_main_combi_province_deadrock_gap",                     -- X:806, Y:578
        "dyn_dis_wh3_main_combi_province_death_pass",                       -- X:759, Y:474
        "dyn_dis_wh3_main_combi_province_doom_glades",                      -- X:94, Y:648
        "dyn_dis_wh3_main_combi_province_eastern_badlands",                 -- X:743, Y:413
        "dyn_dis_wh3_main_combi_province_eastern_border_princes",           -- X:671, Y:548
        "dyn_dis_wh3_main_combi_province_eastern_oblast",                   -- X:794, Y:770
        "dyn_dis_wh3_main_combi_province_eight_peaks",                      -- X:768, Y:451
        "dyn_dis_wh3_main_combi_province_estalia",                          -- X:412, Y:438
        "dyn_dis_wh3_main_combi_province_forest_of_arden",                  -- X:404, Y:648
        "dyn_dis_wh3_main_combi_province_forest_of_chalons",                -- X:471, Y:575
        "dyn_dis_wh3_main_combi_province_forest_of_gloom",                  -- X:692, Y:543
        "dyn_dis_wh3_main_combi_province_gisoreux_gap",                     -- X:453, Y:646
        "dyn_dis_wh3_main_combi_province_gryphon_wood",                     -- X:681, Y:686
        "dyn_dis_wh3_main_combi_province_hochland",                         -- X:613, Y:697
        "dyn_dis_wh3_main_combi_province_irrana_mountains",                 -- X:399, Y:468
        "dyn_dis_wh3_main_combi_province_marches_of_couronne",              -- X:399, Y:668
        "dyn_dis_wh3_main_combi_province_middenland",                       -- X:697, Y:408
        "dyn_dis_wh3_main_combi_province_marshes_of_madness",               -- X:546, Y:698
        "dyn_dis_wh3_main_combi_province_mootland",                         -- X:656, Y:609
        "dyn_dis_wh3_main_combi_province_nordland",                         -- X:545, Y:760
        "dyn_dis_wh3_main_combi_province_northern_grey_mountains",          -- X:449, Y:615
        "dyn_dis_wh3_main_combi_province_northern_sylvania",                -- X:674, Y:627
        "dyn_dis_wh3_main_combi_province_northern_worlds_edge_mountains",   -- X:795, Y:666
        "dyn_dis_wh3_main_combi_province_ostermark",                        -- X:689, Y:715
        "dyn_dis_wh3_main_combi_province_ostland",                          -- X:636, Y:723
        "dyn_dis_wh3_main_combi_province_peak_pass",                        -- X:736, Y:647
        "dyn_dis_wh3_main_combi_province_pirates_current",                  -- X:502, Y:383
        "dyn_dis_wh3_main_combi_province_reikland",                         -- X:515, Y:646
        "dyn_dis_wh3_main_combi_province_rib_peaks",                        -- X:776, Y:597
        "dyn_dis_wh3_main_combi_province_river_brienne",                    -- X:387, Y:589
        "dyn_dis_wh3_main_combi_province_river_lynsk",                      -- X:635, Y:781
        "dyn_dis_wh3_main_combi_province_river_urskoy",                     -- X:707, Y:734
        "dyn_dis_wh3_main_combi_province_solland",                          -- X:577, Y:577
        "dyn_dis_wh3_main_combi_province_southern_badlands",                -- X:630, Y:368
        "dyn_dis_wh3_main_combi_province_southern_grey_mountains",          -- X:543, Y:563 -- Unusable. Partly out of the walkable terrain.
        "dyn_dis_wh3_main_combi_province_southern_oblast",                  -- X:730, Y:695
        "dyn_dis_wh3_main_combi_province_southern_sylvania",                -- X:721, Y:621
        "dyn_dis_wh3_main_combi_province_southern_worlds_edge_mountains",   -- X:794, Y:462
        "dyn_dis_wh3_main_combi_province_stirland",                         -- X:595, Y:630
        "dyn_dis_wh3_main_combi_province_talabecland",                      -- X:592, Y:685
        "dyn_dis_wh3_main_combi_province_talsyn",                           -- X:524, Y:519
        "dyn_dis_wh3_main_combi_province_the_blighted_marshes",             -- X:464, Y:450
        "dyn_dis_wh3_main_combi_province_the_cursed_city",                  -- X:718, Y:761
        "dyn_dis_wh3_main_combi_province_the_misty_hills",                  -- X:501, Y:697
        "dyn_dis_wh3_main_combi_province_the_silver_road",                  -- X:742, Y:540
        "dyn_dis_wh3_main_combi_province_the_vaults",                       -- X:563, Y:515
        "dyn_dis_wh3_main_combi_province_the_wasteland",                    -- X:440, Y:662
        "dyn_dis_wh3_main_combi_province_the_witchs_wood",                  -- X:532, Y:721
        "dyn_dis_wh3_main_combi_province_tilea",                            -- X:507, Y:449
        "dyn_dis_wh3_main_combi_province_torgovann",                        -- X:514, Y:550
        "dyn_dis_wh3_main_combi_province_troll_country",                    -- X:692, Y:786
        "dyn_dis_wh3_main_combi_province_western_badlands",                 -- X:641, Y:435
        "dyn_dis_wh3_main_combi_province_western_border_princes",           -- X:581, Y:441
        "dyn_dis_wh3_main_combi_province_western_oblast",                   -- X:625, Y:789
        "dyn_dis_wh3_main_combi_province_wissenland",                       -- X:576, Y:551
        "dyn_dis_wh3_main_combi_province_winters_teeth_pass",               -- X:541, Y:612
        "dyn_dis_wh3_main_combi_province_wydrioth",                         -- X:517, Y:550
        "dyn_dis_wh3_main_combi_province_yn_edri_eternos",                  -- X:508, Y:541
    },
    teleportation_nodes_mountains_of_mourne = {
        "dyn_dis_wh3_main_combi_province_ancient_giant_lands",      -- X:1011, Y:667
        "dyn_dis_wh3_main_combi_province_bone_road",                -- X:1019, Y:601
        "dyn_dis_wh3_main_combi_province_gash_kadrak",              -- X:970, Y:673
        "dyn_dis_wh3_main_combi_province_gnoblar_country",          -- X:983, Y:463
        "dyn_dis_wh3_main_combi_province_ivory_road",               -- X:1018, Y:504
        "dyn_dis_wh3_main_combi_province_mountains_of_mourn",       -- X:1006, Y:574
        "dyn_dis_wh3_main_combi_province_path_to_the_east",         -- X:927, Y:692
        "dyn_dis_wh3_main_combi_province_the_dragon_isles",         -- X:976, Y:389
        "dyn_dis_wh3_main_combi_province_the_haunted_forest",       -- X:1054, Y:416
        "dyn_dis_wh3_main_combi_province_the_maw",                  -- X:1074, Y:507
        "dyn_dis_wh3_main_combi_province_wyrm_pass",                -- X:1080, Y:444  -- Works, but this province doesn't have any region. Instead, it spawns in Gnoblar Territory
    },
    teleportation_nodes_dark_lands = {
        "dyn_dis_wh3_main_combi_province_the_blasted_wastes",       -- X:836, Y:658
        "dyn_dis_wh3_main_combi_province_the_desolation_of_azgorh", -- X:845, Y:508
        "dyn_dis_wh3_main_combi_province_the_howling_wastes",       -- X:940, Y:486
        "dyn_dis_wh3_main_combi_province_the_plain_of_bones",       -- X:880, Y:446
        "dyn_dis_wh3_main_combi_province_the_plain_of_zharr",       -- X:939, Y:640
        "dyn_dis_wh3_main_combi_province_the_wolf_lands",           -- X:912, Y:535
        "dyn_dis_wh3_main_combi_province_zorn_uzkul",               -- X:848, Y:732
    },
    teleportation_nodes_southlands = {
        "dyn_dis_wh3_main_combi_province_atalan_mountains",                 -- X:465, Y:295
        "dyn_dis_wh3_main_combi_province_barrier_idols",                    -- X:705, Y:349
        "dyn_dis_wh3_main_combi_province_central_jungles",                  -- X:628, Y:164
        "dyn_dis_wh3_main_combi_province_coast_of_araby",                   -- X:499, Y:332
        "dyn_dis_wh3_main_combi_province_crater_of_the_waking_dead",        -- X:806, Y:355
        "dyn_dis_wh3_main_combi_province_dawns_landing",                    -- X:549, Y:78
        "dyn_dis_wh3_main_combi_province_devils_backbone",                  -- X:732, Y:308
        "dyn_dis_wh3_main_combi_province_eastern_colonies",                 -- X:989, Y:141
        "dyn_dis_wh3_main_combi_province_great_desert_of_araby",            -- X:488, Y:256
        "dyn_dis_wh3_main_combi_province_great_mortis_delta",               -- X:583, Y:273
        "dyn_dis_wh3_main_combi_province_heart_of_the_jungle",              -- X:653, Y:218
        "dyn_dis_wh3_main_combi_province_kingdom_of_beasts",                -- X:774, Y:259
        "dyn_dis_wh3_main_combi_province_land_of_assassins",                -- X:425, Y:269
        "dyn_dis_wh3_main_combi_province_land_of_the_dead",                 -- X:609, Y:299
        "dyn_dis_wh3_main_combi_province_land_of_the_dervishes",            -- X:559, Y:246
        "dyn_dis_wh3_main_combi_province_shifting_sands",                   -- X:636, Y:256
        "dyn_dis_wh3_main_combi_province_southern_jungles",                 -- X:617, Y:114
        "dyn_dis_wh3_main_combi_province_southlands_worlds_edge_mountains", -- X:670, Y:221
        "dyn_dis_wh3_main_combi_province_the_cracked_land",                 -- X:538, Y:297
        "dyn_dis_wh3_main_combi_province_the_golden_pass",                  -- X:730, Y:180
        "dyn_dis_wh3_main_combi_province_the_jungles_of_the_gods",          -- X:706, Y:121
        "dyn_dis_wh3_main_combi_province_western_jungles",                  -- X:536, Y:195
    },
    teleportation_nodes_lustria = {
        "dyn_dis_wh3_main_combi_province_aymara_swamps",            -- X:108, Y:404
        "dyn_dis_wh3_main_combi_province_copper_desert",            -- X:98, Y:207
        "dyn_dis_wh3_main_combi_province_culchan_plains",           -- X:214, Y:140
        "dyn_dis_wh3_main_combi_province_headhunters_jungle",       -- X:237, Y:198
        "dyn_dis_wh3_main_combi_province_isthmus_of_lustria",       -- X:81, Y:490
        "dyn_dis_wh3_main_combi_province_jungles_of_green_mist",    -- X:28, Y:343
        "dyn_dis_wh3_main_combi_province_jungles_of_pahualaxa",     -- X:100, Y:422
        "dyn_dis_wh3_main_combi_province_mosquito_swamps",          -- X:227, Y:268
        "dyn_dis_wh3_main_combi_province_river_qurveza",            -- X:171, Y:228
        "dyn_dis_wh3_main_combi_province_scorpion_coast",           -- X:152, Y:325
        "dyn_dis_wh3_main_combi_province_spine_of_sotek",           -- X:123, Y:206
        "dyn_dis_wh3_main_combi_province_the_capes",                -- X:292, Y:96
        "dyn_dis_wh3_main_combi_province_the_creeping_jungle",      -- X:92, Y:369
        "dyn_dis_wh3_main_combi_province_the_gwangee_valley",       -- X:87, Y:311
        "dyn_dis_wh3_main_combi_province_the_isthmus_coast",        -- X:114, Y:513
        "dyn_dis_wh3_main_combi_province_the_lost_valley",          -- X:185, Y:198
        "dyn_dis_wh3_main_combi_province_the_night_forest_road",    -- X:201, Y:125
        "dyn_dis_wh3_main_combi_province_the_sacred_pools",         -- X:156, Y:251
        "dyn_dis_wh3_main_combi_province_the_turtle_isles",         -- X:40, Y:258
        "dyn_dis_wh3_main_combi_province_vampire_coast",            -- X:264, Y:261
        "dyn_dis_wh3_main_combi_province_volcanic_islands",         -- X:268, Y:214
    },
    teleportation_nodes_naggaroth = {
        "dyn_dis_wh3_main_combi_province_ashen_coast",              -- X:14, Y:582  -- Bugged sometimes.
        "dyn_dis_wh3_main_combi_province_deadwood",                 -- X:278, Y:863
        "dyn_dis_wh3_main_combi_province_granite_hills",            -- X:218, Y:785
        "dyn_dis_wh3_main_combi_province_iron_coast",               -- X:37, Y:850
        "dyn_dis_wh3_main_combi_province_iron_foothills",           -- X:104, Y:821
        "dyn_dis_wh3_main_combi_province_iron_mountains",           -- X:62, Y:821
        "dyn_dis_wh3_main_combi_province_ironsand_desert",          -- X:28, Y:636
        "dyn_dis_wh3_main_combi_province_obsidian_peaks",           -- X:124, Y:718
        "dyn_dis_wh3_main_combi_province_red_desert",               -- X:12, Y:640  -- Bugged, to close to the map border it seems.
        "dyn_dis_wh3_main_combi_province_spiteful_peaks",           -- X:151, Y:832
        "dyn_dis_wh3_main_combi_province_the_black_flood",          -- X:143, Y:777
        "dyn_dis_wh3_main_combi_province_the_bleak_coast",          -- X:135, Y:588
        "dyn_dis_wh3_main_combi_province_the_broken_lands",         -- X:265, Y:801
        "dyn_dis_wh3_main_combi_province_the_clawed_coast",         -- X:173, Y:730
        "dyn_dis_wh3_main_combi_province_the_road_of_skulls",       -- X:200, Y:829
        "dyn_dis_wh3_main_combi_province_the_witchwood",            -- X:78, Y:657
        "dyn_dis_wh3_main_combi_province_titan_peaks",              -- X:75, Y:581
    },
    teleportation_nodes_ulthuan = {
        "dyn_dis_wh3_main_combi_province_avelorn",                  -- X:266, Y:582
        "dyn_dis_wh3_main_combi_province_caledor",                  -- X:216, Y:510
        "dyn_dis_wh3_main_combi_province_chrace",                   -- X:307, Y:620
        "dyn_dis_wh3_main_combi_province_cothique",                 -- X:324, Y:615
        "dyn_dis_wh3_main_combi_province_eagle_gate",               -- X:177, Y:572 - Usable, but spawns in another province, though understandable due to the lack of space on their own.
        "dyn_dis_wh3_main_combi_province_eataine",                  -- X:242, Y:515
        "dyn_dis_wh3_main_combi_province_ellyrion",                 -- X:209, Y:547
        "dyn_dis_wh3_main_combi_province_griffon_gate",             -- X:205, Y:586 - Usable, but spawns in another province, though understandable due to the lack of space on their own.
        "dyn_dis_wh3_main_combi_province_nagarythe",                -- X:229, Y:640
        "dyn_dis_wh3_main_combi_province_northern_yvresse",         -- X:327, Y:580
        "dyn_dis_wh3_main_combi_province_phoenix_gate",             -- X:244, Y:631 - Usable, but spawns in another province, though understandable due to the lack of space on their own.
        "dyn_dis_wh3_main_combi_province_saphery",                  -- X:300, Y:572
        "dyn_dis_wh3_main_combi_province_southern_yvresse",         -- X:305, Y:531
        "dyn_dis_wh3_main_combi_province_the_great_ocean",          -- X:259, Y:459
        "dyn_dis_wh3_main_combi_province_tiranoc",                  -- X:183, Y:602
        "dyn_dis_wh3_main_combi_province_unicorn_gate",             -- X:209, Y:619 - Usable, but spawns in another province, though understandable due to the lack of space on their own.
    },

    favoured_corruptions = {
        FavouredCorruptionKhorne = "wh3_main_teleportation_node_template_kho",
        FavouredCorruptionSlaanesh = "wh3_main_teleportation_node_template_sla",
        FavouredCorruptionTzeentch = "wh3_main_teleportation_node_template_tze",
        FavouredCorruptionNurgle = "wh3_main_teleportation_node_template_nur",
        --FavouredCorruptionUndivided = "dyn_dis_wh3_main_teleportation_node_template_undivided",
    },

    -- When closing a rift, this faction is fought (second thing is the random army key).
    rift_closure_force_data = {
        ["wh3_main_teleportation_node_template_kho"] = {"wh3_main_kho_khorne_qb1", "rift_army_khorne"},
        ["wh3_main_teleportation_node_template_nur"] = {"wh3_main_nur_nurgle_qb1", "rift_army_nurgle"},
        ["wh3_main_teleportation_node_template_sla"] = {"wh3_main_sla_slaanesh_qb1", "rift_army_slaanesh"},
        ["wh3_main_teleportation_node_template_tze"] = {"wh3_main_tze_tzeentch_qb1", "rift_army_tzeentch"}
    },

    stage_early_warning_incident_key = "dyn_dis_chaos_invasion_stage_early_warning",
    stage_1_incident_key = "dyn_dis_chaos_invasion_stage_1_trigger",
    stage_2_incident_key = "dyn_dis_chaos_invasion_stage_2_trigger",
    stage_3_incident_key = "dyn_dis_chaos_invasion_stage_3_trigger",
    finish_before_stage_1_event_key = "dyn_dis_chaos_invasion_finish_before_stage_1",
    finish_event_key = "dyn_dis_chaos_invasion_finish",

    great_vortex_undone_incident_key = "dyn_dis_chaos_invasion_great_vortex_undone",
    great_vortex_undone_effect_key = "dyn_dis_chaos_invasion_great_vortex_undone",
    great_vortex_undone_cancel_incident_key = "dyn_dis_chaos_invasion_great_vortex_undone_cancel",

    great_vortex_undone_mission_name = "great_vortex_undone",
    endgame_mission_name = "endtimes_unfolding",
    battle_in_rift_khorne_dilemma_key = "dyn_dis_chaos_invasion_rift_dilemma_khorne",
    battle_in_rift_nurgle_dilemma_key = "dyn_dis_chaos_invasion_rift_dilemma_nurgle",
    battle_in_rift_slaanesh_dilemma_key = "dyn_dis_chaos_invasion_rift_dilemma_slaanesh",
    battle_in_rift_tzeentch_dilemma_key = "dyn_dis_chaos_invasion_rift_dilemma_tzeentch",

    battle_in_rift_khorne_effect_key = "dyn_dis_chaos_invasion_rift_chance_of_reward_khorne",
    battle_in_rift_nurgle_effect_key = "dyn_dis_chaos_invasion_rift_chance_of_reward_nurgle",
    battle_in_rift_slaanesh_effect_key = "dyn_dis_chaos_invasion_rift_chance_of_reward_slaanesh",
    battle_in_rift_tzeentch_effect_key = "dyn_dis_chaos_invasion_rift_chance_of_reward_tzeentch",

    attacker_buffs_key = "fro_dyn_dis_chaos_invasion_attacker_buffs",
    effects_global_key = "fro_dyn_dis_chaos_invasion_global_effects",

    teleportation_network = "dyn_dis_chaos_invasion_network",
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_chaos_invasion:set_status(status)
    self.settings.status = status;

    -- Listener to spawn armies from open rifts. This one needs to trigger as long as the disaster is running.
    core:remove_listener("ChaosInvasionRiftArmies");
    core:add_listener(
        "ChaosInvasionRiftArmies",
        "WorldStartRound",
        function()
            return self.settings.started;
        end,
        function(context)
            local world = cm:model():world();
            local open_nodes = world:teleportation_network_system():lookup_network(self.teleportation_network):open_nodes();
            local default_owner = "wh_main_chs_chaos";

            for i = 0, open_nodes:num_items() - 1 do
                if (math.random() <= (0.05 + (self.settings.difficulty_mod / 20)) or dynamic_disasters.settings.debug_2) then
                    local current_node = open_nodes:item_at(i);
                    local x, y = current_node:position();
                    local region_data = world:region_data_at_position(x, y);

                    if not region_data:is_null_interface() then
                        local region = region_data:region();

                        -- Spawn a demon army based on the rift's template and assign it to the region owner, if it's chaos.
                        if not region == false and not region:is_null_interface() and not region:is_abandoned() then
                            local region_owner = region:owning_faction();
                            if not region_owner == false and not region_owner:is_null_interface() then
                                local army_template = {};

                                local template_key = current_node:template_key();
                                if template_key == "wh3_main_teleportation_node_template_kho" then
                                    army_template = {
                                        khorne = "lategame_daemons_only",
                                    }
                                elseif template_key == "wh3_main_teleportation_node_template_nur" then
                                    army_template = {
                                        nurgle = "lategame_daemons_only",
                                    }
                                elseif template_key == "wh3_main_teleportation_node_template_sla" then
                                    army_template = {
                                        slaanesh = "lategame_daemons_only",
                                    }
                                else -- Tzeench as fallback.
                                    army_template = {
                                        tzeentch = "lategame_daemons_only",
                                    }
                                end

                                local faction_army_owner = default_owner;
                                for j = 1, #self.settings.factions do
                                    if region_owner:name() == self.settings.factions[j] then
                                        faction_army_owner = self.settings.factions[j];
                                        break;
                                    end
                                end

                                local unit_count = math.random(14, 20);
                                dynamic_disasters:create_scenario_force_at_coords(faction_army_owner, region:name(), {x, y}, army_template, unit_count, false, 1, self.name, nil)
                            end
                        end
                    end
                end
            end
        end,
        true
    );

    -- Listener to respawn rifts.
    core:remove_listener("ChaosInvasionRespawnRiftsChaosWastes");
    core:add_listener(
        "ChaosInvasionRespawnRiftsChaosWastes",
        "WorldStartRound",
        function()
            return self.settings.started and self.settings.status >= STATUS_STAGE_2 and self.settings.enable_rifts and (cm:random_number(5) == 1 or dynamic_disasters.settings.debug_2);
        end,
        function()
            out("Frodo45127: Respawning rifts at random on provinces with at least 75% chaos corruption.");
            local percentage = 0.5 + (self.settings.difficulty_mod / 10);
            local min_chaos = 75;
            self:open_teleportation_nodes(self.teleportation_nodes_chaos_wastes, percentage, min_chaos)
            self:open_teleportation_nodes(self.teleportation_nodes_norsca, percentage, min_chaos);

            -- If Ulthuan has fallen, respawn everywhere.
            if self.settings.great_vortex_undone then
                percentage = 0.25 + (self.settings.difficulty_mod / 10);
                self:open_teleportation_nodes(self.teleportation_nodes_cathay, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_old_world, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_mountains_of_mourne, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_dark_lands, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_southlands, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_lustria, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_naggaroth, percentage, min_chaos);
                self:open_teleportation_nodes(self.teleportation_nodes_ulthuan, percentage, min_chaos);
            end
        end,
        true
    );

    -- Listener for switching templates of rifts if the region owner is favoured by another god.
    core:remove_listener("ChaosInvasionRiftSwitchingTemplates");
    core:add_listener(
        "ChaosInvasionRiftSwitchingTemplates",
        "CharacterPerformsSettlementOccupationDecision",
        function(context)
            return self.settings.started;
        end,
        function(context)
            local region = context:garrison_residence():region()
            local province = region:province();
            local node_key = "dyn_dis_" .. province:key();
            out("Frodo45127: Checking template-switching for node: " .. node_key)

            local world = cm:model():world();
            local network = world:teleportation_network_system():lookup_network(self.teleportation_network);
            local node = network:lookup_open_node(node_key);

            if not node == nil then
                local corruption = false;
                local faction = context:character():faction()
                if not faction == false and faction:is_null_interface() == false then
                    corruption = self:favoured_corruption_for_faction(faction);
                end

                if not corruption == false then
                    out("Frodo45127: Switching node from region: " .. region:name() .. ", from corruption: " .. tostring(node:template_key()) .. ", to corruption: " .. tostring(corruption) .. ".")
                    cm:teleportation_network_close_node(node_key)
                    cm:callback(
                        function()
                            cm:teleportation_network_open_node(node_key, corruption)
                        end,
                    0.5)
                end
            end
        end,
        true
    );

    -- Listener to tell the game that, when an army tries to close a rift, there should be battle.
    core:remove_listener("ChaosInvasionRiftClosingBattleQuery");
    core:add_listener(
        "ChaosInvasionRiftClosingBattleQuery",
        "QueryTeleportationNetworkShouldHandoverCharacterNodeClosure",
        function(context)
            local closing_character = context:character_family_member();

            if not closing_character:is_null_interface() then
                local character = closing_character:character();

                if not character:is_null_interface() then
                    if character:has_military_force() then
                        return true;
                    else
                        -- hero closed the rift, trigger event to complete rift closure narrative mission
                        core:trigger_event("ScriptEventRiftClosureBattleWon", character);
                    end;
                end;
            end;
        end,
        function(context)
            context:flag_for_script_handover();
        end,
        true
    );

    -- Listener to generate battles on rift closure.
    core:remove_listener("ChaosInvasionRiftClosingBattle");
    core:add_listener(
        "ChaosInvasionRiftClosingBattle",
        "TeleportationNetworkCharacterNodeClosureHandedOver",
        function(context)
            local closing_character = context:character_family_member();

            if not closing_character:is_null_interface() then
                local character = closing_character:character();

                return not character:is_null_interface() and character:has_military_force();
            end;
        end,
        function(context)
            local character = context:character_family_member():character();

            -- Mute these events so we don't get notifications for the closure battle factions.
            cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

            -- Settings to remember that this is a rift battle.
            cm:set_saved_value("ChaosInvasionRiftClosureBattleActive", {context:node_key(), context:template_key(), character:command_queue_index()});

            -- Generate the battle. This handles generating the armies and triggering the battle.
            self:generate_rift_closure_battle(character, context:template_key());
        end,
        true
    );

    -- Listener to cleanup after a battle to close a rift.
    core:remove_listener("ChaosInvasionRiftClosingBattleCleanup");
    core:add_listener(
        "ChaosInvasionRiftClosingBattleCleanup",
        "BattleCompleted",
        function()
            return cm:get_saved_value("ChaosInvasionRiftClosureBattleActive");
        end,
        function()
            local node_details = cm:get_saved_value("ChaosInvasionRiftClosureBattleActive");

            -- close the rift if the battle was won
            if cm:pending_battle_cache_defender_victory() then
                cm:teleportation_network_close_node(node_details[1]);

                local char_cqi = node_details[3];
                local char = cm:get_character_by_cqi(char_cqi);
                if char then
                    core:trigger_event("ScriptEventRiftClosureBattleWon", char);
                end;
            end;

            invasion_manager:kill_invasion_by_key("ChaosInvasionRiftClosureArmy");

            for _, v in pairs(self.rift_closure_force_data) do
                dynamic_disasters:kill_faction_silently(v[1]);
            end;

            cm:set_saved_value("ChaosInvasionRiftClosureBattleActive", false);
        end,
        true
    );

    -- Listener to check if the character ran a way from a "closing rift" battle and cleanup accordingly.
    core:remove_listener("ChaosInvasionRiftClosingBattleCleanupAfterRetreat");
    core:add_listener(
        "ChaosInvasionRiftClosingBattleCleanupAfterRetreat",
        "CharacterWithdrewFromBattle",
        function(context)
            return cm:get_saved_value("ChaosInvasionRiftClosureBattleActive");
        end,
        function(context)
            out("Frodo45127: Listener ChaosInvasionRiftClosingBattleCleanupAfterRetreat triggered.")
            invasion_manager:kill_invasion_by_key("ChaosInvasionRiftClosureArmy");

            for _, v in pairs(self.rift_closure_force_data) do
                dynamic_disasters:kill_faction_silently(v[1]);
            end;

            cm:set_saved_value("ChaosInvasionRiftClosureBattleActive", false);
        end,
        true
    );

    -- Listener to cleanup after a battle of event on a rift. Similar to the closing rift one, but it closes both nodes of the network.
    core:remove_listener("ChaosInvasionRiftEventBattleCleanup");
    core:add_listener(
        "ChaosInvasionRiftEventBattleCleanup",
        "BattleCompleted",
        function()
            return cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
        end,
        function()
            local node_details = cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
            local char_cqi = node_details[3];
            local char = cm:get_character_by_cqi(char_cqi);

            -- If we won, give use an special chaos-infused item and close both source and destination nodes.
            if cm:pending_battle_cache_attacker_victory() then
                cm:teleportation_network_close_node(node_details[1][1]);
                cm:teleportation_network_close_node(node_details[2][1]);

                -- Disable this battle so it doesn't come up again.
                local reward = nil;
                local template = node_details[4];
                if template == "wh3_main_teleportation_node_template_kho" then
                    reward_index = math.random(#self.settings.khorne_realm_rewards);
                    reward = self.settings.khorne_realm_rewards[reward_index];
                    table.remove(self.settings.khorne_realm_rewards, reward_index);
                elseif template == "wh3_main_teleportation_node_template_nur" then
                    reward_index = math.random(#self.settings.nurgle_realm_rewards);
                    reward = self.settings.nurgle_realm_rewards[reward_index];
                    table.remove(self.settings.nurgle_realm_rewards, reward_index);
                elseif template == "wh3_main_teleportation_node_template_sla" then
                    reward_index = math.random(#self.settings.slaanesh_realm_rewards);
                    reward = self.settings.slaanesh_realm_rewards[reward_index];
                    table.remove(self.settings.slaanesh_realm_rewards, reward_index);
                elseif template == "wh3_main_teleportation_node_template_tze" then
                    reward_index = math.random(#self.settings.tzeench_realm_rewards);
                    reward = self.settings.tzeench_realm_rewards[reward_index];
                    table.remove(self.settings.tzeench_realm_rewards, reward_index);
                end

                if char then
                    core:trigger_event("ScriptEventRiftClosureBattleWon", char);
                end;

                -- Pick an item from the ones available in the chaos realm, and give it to the character.
                -- If the character is alive, give it to him. If he/she died in battle, give it to the faction.
                -- NOTE: while we should check for item availability in the map, we don't. Because I've heard some chaos races receive these.
                if char then
                    cm:force_add_ancillary(char, reward, true, false)
                else
                    cm:add_ancillary_to_faction(cm:get_faction(node_details[6]), reward, false)
                end
            end;

            -- Regardless of the result, give the character a debuff if it doesn't has one yet and it survived.
            if not char == false then
                if node_details[5] == false then
                    local realm = self.teleportation_nodes_realm_by_templates[node_details[4]];
                    local faction = char:faction();

                    out("Frodo45127: Event battle fough. Trying to add chaos realm trait from " .. tostring(realm) .. ".");
                    local trait_name = self:get_chaos_trait_name(realm, faction:subculture(), faction:name());
                    if trait_name then

                        out("Frodo45127: Trait to add: " .. tostring(trait_name) .. ".");
                        cm:force_add_trait(cm:char_lookup_str(char), trait_name, true, 3);
                    end;
                end
            end

            invasion_manager:kill_invasion_by_key("ChaosInvasionRiftClosureArmy");

            for _, v in pairs(self.rift_closure_force_data) do
                dynamic_disasters:kill_faction_silently(v[1]);
            end;

            cm:set_saved_value("ChaosInvasionRiftEventBattleActive", false);
        end,
        true
    );

    -- Listener to check if the character ran a way from a Daemon Prince in a rift and cleanup accordingly.
    core:remove_listener("ChaosInvasionRiftEventBattleCleanupAfterRetreat");
    core:add_listener(
        "ChaosInvasionRiftEventBattleCleanupAfterRetreat",
        "CharacterWithdrewFromBattle",
        function(context)
            return cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
        end,
        function(context)
            local node_details = cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
            local char_cqi = node_details[3];
            local char = cm:get_character_by_cqi(char_cqi);

            -- If the coward ran away AFTER meeting the enemy army, apply a debuff trait anyway.
            if node_details[5] == false then
                local realm = self.teleportation_nodes_realm_by_templates[node_details[4]];
                local faction = char:faction();

                out("Frodo45127: Ran away from event battle. Trying to add chaos realm trait from " .. tostring(realm) .. ".");
                local trait_name = self:get_chaos_trait_name(realm, faction:subculture(), faction:name());
                if trait_name then

                    out("Frodo45127: Trait to add: " .. tostring(trait_name) .. ".");
                    cm:force_add_trait(cm:char_lookup_str(char), trait_name, true, 3);
                end;
            end

            invasion_manager:kill_invasion_by_key("ChaosInvasionRiftClosureArmy");

            for _, v in pairs(self.rift_closure_force_data) do
                dynamic_disasters:kill_faction_silently(v[1]);
            end;

            cm:set_saved_value("ChaosInvasionRiftEventBattleActive", false);
        end,
        true
    );

    -- Listener to assign debuff traits to travelers of the rifts.
    core:remove_listener("ChaosInvasionRiftArmyTravelCompleted");
    core:add_listener(
        "ChaosInvasionRiftArmyTravelCompleted",
        "TeleportationNetworkMoveCompleted",
        function(context)
            local character = context:character():character();
            local faction = character:faction();
            return faction:is_human() and context:from_record():network_key() == self.teleportation_network;
        end,
        function(context)
            local character = context:character():character();
            local faction = character:faction();

            local network = cm:model():world():teleportation_network_system():lookup_network(self.teleportation_network)
            local from_node_key = context:from_key()
            local to_node_key = context:to_key()
            local from_template_key = network:lookup_open_node(from_node_key):template_key()
            local to_node = network:lookup_open_node(to_node_key);
            local to_template_key = to_node:template_key()
            local trait_received = false;

            -- Precalculate the template to get.
            local template = from_template_key;
            if math.random() > 0.5 then
                template = to_template_key;
            end

            -- If we're trying to travel through the Chaos Realms, you get a chance of receiving a trait.
            if math.random() <= 0.1 or dynamic_disasters.settings.debug_2 then
                local realm = self.teleportation_nodes_realm_by_templates[template];

                out("Frodo45127: Trying to add chaos realm trait. Realm: " .. tostring(realm) .. ".");
                local trait_name = self:get_chaos_trait_name(realm, faction:subculture(), faction:name());
                if trait_name then

                    out("Frodo45127: Trait to add: " .. tostring(trait_name) .. ".");
                    cm:force_add_trait(cm:char_lookup_str(character), trait_name, true, 3);
                    trait_received = true;
                end;
            end

            -- If we're lucky, trigger a dilemma to choose between fight a battle and get an artifact, or just ran away.
            if math.random() <= 0.1 or dynamic_disasters.settings.debug_2 then
                local dilemma_key = nil;
                local effect_key = nil;

                out("Frodo45127: dilemma key to to use mid-journey on the chaos realms: " .. tostring(dilemma_key) .. ".")
                if template == "wh3_main_teleportation_node_template_kho" and #self.settings.khorne_realm_rewards > 0 then
                    dilemma_key = self.battle_in_rift_khorne_dilemma_key;
                    effect_key = self.battle_in_rift_khorne_effect_key;
                elseif template == "wh3_main_teleportation_node_template_nur" and #self.settings.nurgle_realm_rewards > 0 then
                    dilemma_key = self.battle_in_rift_nurgle_dilemma_key;
                    effect_key = self.battle_in_rift_nurgle_effect_key;
                elseif template == "wh3_main_teleportation_node_template_sla" and #self.settings.slaanesh_realm_rewards > 0 then
                    dilemma_key = self.battle_in_rift_slaanesh_dilemma_key;
                    effect_key = self.battle_in_rift_slaanesh_effect_key;
                elseif template == "wh3_main_teleportation_node_template_tze" and #self.settings.tzeench_realm_rewards > 0 then
                    dilemma_key = self.battle_in_rift_tzeentch_dilemma_key;
                    effect_key = self.battle_in_rift_tzeentch_effect_key;
                end

                -- Only trigger a dilemma if we have rewards for the selected realm.
                if dilemma_key then
                    core:add_listener(
                        "ChaosInvasionRiftDilemma" .. faction:name(),
                        "DilemmaChoiceMadeEvent",
                        function (context)
                            return context:faction():is_human() and context:dilemma() == dilemma_key
                        end,
                        function (context)
                            local choice = context:choice();

                            -- If we want to fight, then we do the same as with normal closure battles, but we also need to change the battlefield to a RoC one.
                            if choice == 0 then

                                -- Store the fact that we're fighting an special battle, so we can clean up after it later.
                                local from_data = {from_node_key, from_template_key}
                                local to_data = {to_node_key, to_template_key}
                                local faction_key = context:faction():name();

                                cm:set_saved_value("ChaosInvasionRiftEventBattleActive", {from_data, to_data, character:command_queue_index(), template, trait_received, faction_key});

                                -- Generate the battle against a Daemon Prince. This handles generating the armies and triggering the battle.
                                local general = nil;
                                if template == "wh3_main_teleportation_node_template_kho" then
                                    general = "dyn_dis_wh3_kho_cha_daemon_prince_of_khorne";
                                elseif template == "wh3_main_teleportation_node_template_nur" then
                                    general = "dyn_dis_wh3_nur_cha_daemon_prince_of_nurgle";
                                elseif template == "wh3_main_teleportation_node_template_sla" then
                                    general = "dyn_dis_wh3_sla_cha_daemon_prince_of_slaanesh";
                                else -- Tzeench is our backup.
                                    general = "dyn_dis_wh3_tze_cha_daemon_prince_of_tzeentch";
                                end

                                -- Mute these events so we don't get notifications for the event battle factions.
                                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
                                cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

                                -- Generate and trigger the battle.
                                self:generate_rift_closure_battle(character, template, true, general, 20);

                            -- If we ran away, do nothing. If we didn't venture more than neccessary in the chaos realms, we're ok.
                            else
                                return
                            end
                        end,
                        false
                    );

                    -- Setup the choice's payloads.
                    local choices = {
                        {
                            effect_bundle = effect_key
                        },
                        ""
                    };

                    dynamic_disasters:trigger_dilemma(faction, dilemma_key, choices)
                end
            end
        end,
        true
    );

    -- Listener to setup Chaos Realm battles.
    core:remove_listener("ChaosInvasionRiftEventPendingBattle");
    core:add_listener(
        "ChaosInvasionRiftEventPendingBattle",
        "PendingBattle",
        function()
            return cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
        end,
        function()
            local battle_data = cm:get_saved_value("ChaosInvasionRiftEventBattleActive");
            local template = battle_data[4];

            out("Frodo45127: Template chosen for rift battle: " .. tostring(template) .. ".")

            if template == "wh3_main_teleportation_node_template_kho" then
                cm:pending_battle_add_scripted_tile_upgrade_tag("dyn_dis_chaos_invasion_realm_battle_kho");
            elseif template == "wh3_main_teleportation_node_template_nur" then
                cm:pending_battle_add_scripted_tile_upgrade_tag("dyn_dis_chaos_invasion_realm_battle_nur");
            elseif template == "wh3_main_teleportation_node_template_sla" then
                cm:pending_battle_add_scripted_tile_upgrade_tag("dyn_dis_chaos_invasion_realm_battle_sla");
            else -- Tzeench is our backup.
                cm:pending_battle_add_scripted_tile_upgrade_tag("dyn_dis_chaos_invasion_realm_battle_tze");
            end
            cm:update_pending_battle();
        end,
        true
    );

    -- Listener to remove debuff traits to travelers of the rifts.
    core:remove_listener("ChaosInvasionRiftTraitRemover");
    core:add_listener(
        "ChaosInvasionRiftTraitRemover",
        "CharacterTurnEnd",
        function(context)
            local character = context:character();
            local faction = character:faction();
            return faction:is_human();
        end,
        function(context)
            local character = context:character();
            local faction = character:faction();

            -- If we're in a settlement and we have a Chaos Realm trait, you get a chance of removing it.
            -- We can also remove it if we have a building with the trait removal thing, but nobody builds those.
            if character:in_settlement() then
                local value = character:region():bonus_values():scripted_value("chaos_realm_trait_removal", "value");
                if value > 0 or character:region():is_province_capital() then
                    for _, realm in pairs(self.teleportation_nodes_realm_by_templates) do
                        if cm:random_number(100) <= value or dynamic_disasters.settings.debug_2 then

                            -- Reduce 1 level or remove the trait.
                            local trait_name = self:get_chaos_trait_name(realm, faction:subculture(), faction:name());
                            out("Frodo45127: Tying to remove chaos realm trait " .. tostring(trait_name));

                            if trait_name then
                                local num_points = math.min(character:trait_points(trait_name), 9);

                                cm:force_remove_trait(cm:char_lookup_str(character), trait_name);

                                if num_points / 3 > 1 and not trait_name:find("_daemons") then
                                    cm:force_add_trait(cm:char_lookup_str(character), trait_name, false, (math.floor(num_points / 3 - 1)) * 3);
                                end;
                            end;

                        end;
                    end;
                end;
            end;
        end,
        true
    );

    -- Listener to know when to free the AI armies.
    core:remove_listener("ChaosInvasionFreeArmiesStage1");
    core:add_listener(
        "ChaosInvasionFreeArmiesStage1",
        "WorldStartRound",
        function()
            return self.settings.started and cm:turn_number() <= self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.grace_period
        end,
        function()
            out("Frodo45127: ChaosInvasionFreeArmiesStage1")
            local max_turn = self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.grace_period;
            dynamic_disasters:release_armies(self.settings.stage_1_data.cqis, self.settings.stage_1_data.targets, max_turn)
        end,
        true
    );

    -- Listener to know when to free the AI armies.
    core:remove_listener("ChaosInvasionFreeArmiesStage2");
    core:add_listener(
        "ChaosInvasionFreeArmiesStage2",
        "WorldStartRound",
        function()
            return self.settings.started and cm:turn_number() <= self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.grace_period
        end,
        function()
            out("Frodo45127: ChaosInvasionFreeArmiesStage2")
            local max_turn = self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.grace_period;
            dynamic_disasters:release_armies(self.settings.stage_2_data.cqis, self.settings.stage_2_data.targets, max_turn)
        end,
        true
    );

    -- Listener to cancel the vortex mission if an order AI manages to recover the 4 target cities.
    core:remove_listener("ChaosInvasionGreatVortexUndoneAIEnd");
    core:add_listener(
        "ChaosInvasionGreatVortexUndoneAIEnd",
        "WorldStartRound",
        function()
            local regions = self.great_vortex_undone.regions;
            local regions_controlled_by_order = 0;
            for i = 1, #regions do
                local region = cm:get_region(regions[i]);
                if not region == false and region:is_null_interface() == false and region:is_abandoned() == false then
                    local owner = region:owning_faction();
                    if dynamic_disasters:is_order_faction(owner:name()) and owner:is_human() == false then
                        regions_controlled_by_order = regions_controlled_by_order + 1;
                    end
                end
            end

            return self.settings.great_vortex_undone == true and regions_controlled_by_order == #regions;
        end,
        function()

            -- Just cancel the mission, trigger the vortex restoration, and a small incident explaining why.
            local humans = cm:get_human_factions();
            for i = 1, #humans do
                cm:cancel_custom_mission(humans[i], "dyn_dis_" .. self.name .. "_" .. self.great_vortex_undone_mission_name .. "_1");
            end

            dynamic_disasters:trigger_incident(self.great_vortex_undone_cancel_incident_key, nil, 0, nil);
            self:restore_vortex()
        end,
        true
    );

    -- Listener to trigger the Great Vortex Undone branch of the disaster.
    core:remove_listener("ChaosInvasionGreatVortexUndoneTrigger");
    core:add_listener(
        "ChaosInvasionGreatVortexUndoneTrigger",
        "WorldStartRound",
        function()
            local regions = self.great_vortex_undone.regions;
            local order_stands = false;
            for i = 1, #regions do
                local region = cm:get_region(regions[i]);
                if not region == false and region:is_null_interface() == false and region:is_abandoned() == false then
                    local owner = region:owning_faction();
                    if not dynamic_disasters:is_chaos_faction(owner:name()) then
                        order_stands = true;
                        break;
                    end
                end
            end

            return order_stands == false and self.settings.great_vortex_undone == false;
        end,
        function()

            -- Remove the VFX and trigger the mission to recover ulthuan.
            self.settings.great_vortex_undone = true;

            ---@type table
            local objectives = table.copy(self.great_vortex_undone.objectives);
            table.insert(objectives[1].conditions, "total " .. #self.great_vortex_undone.regions)
            for i = 1, #self.great_vortex_undone.regions do
                table.insert(objectives[1].conditions, "region " .. self.great_vortex_undone.regions[i])
            end

            -- Apply the corruption effects to all alive factions, except humans.
            -- Humans get this effect via payload with effect.
            local faction_list = cm:model():world():faction_list()
            for i = 0, faction_list:num_items() - 1 do
                local faction = faction_list:item_at(i)

                if not faction:is_dead() and faction:is_human() == false then
                    cm:apply_effect_bundle(self.great_vortex_undone_effect_key, faction:name(), 0)
                end
            end

            dynamic_disasters:add_mission(objectives, false, self.name, self.great_vortex_undone_mission_name, self.great_vortex_undone_incident_key, self.great_vortex_undone.regions[i], nil, function () self:restore_vortex() end, true)
            dynamic_disasters:trigger_incident(self.great_vortex_undone_incident_key, self.great_vortex_undone_effect_key, 0, nil);
            cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_chs_chaos")
            --cm:remove_vfx(dynamic_disasters.vortex_vfx);
        end,
        true
    );

    -- Listener that need to be initialized after the disaster is triggered.
    if self.settings.status == STATUS_TRIGGERED then

        -- This triggers stage one of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage1",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:trigger_incident(self.finish_before_stage_1_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_1();
                end
                core:remove_listener("ChaosInvasionStage1")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_1 then

        -- This triggers stage two of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage2",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:trigger_incident(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("ChaosInvasionStage2")
            end,
            true
        );
    end

    -- No need to have a specific listener to end the disaster after no more stages can be triggered, as that's controlled by a mission.
end

-- Function to trigger the disaster. From here until the end of the disaster, everything is managed by the disaster itself.
function disaster_chaos_invasion:trigger()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering first warning.");

    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_1_delay = 1;
        self.settings.grace_period = 5;
    else
        self.settings.stage_1_delay = math.random(8, 12);
        self.settings.grace_period = 15;
    end

    -- Initialize listeners.
    dynamic_disasters:trigger_incident(self.stage_early_warning_incident_key, self.stage_early_warning_incident_key, self.settings.stage_1_delay, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_1()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering stage 1.");

    if dynamic_disasters.settings.debug_2 == true then
        self.settings.stage_2_delay = 1;
    else
        self.settings.stage_2_delay = math.random(6, 10);
    end

    -- Spawn all the initial chaos armies.
    local army_count = math.ceil(3 * self.settings.difficulty_mod);
    for _, faction_key in pairs(self.settings.stage_1_data.factions) do
        local army_template = self.stage_1_data.army_templates[faction_key];
        for _, region_key in pairs(self.stage_1_data.regions[faction_key]) do
            dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, self.settings.base_army_unit_count, false, army_count, self.name, nil)
        end

        local faction = cm:get_faction(faction_key);
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.stage_1_data.regions[faction_key], true, self.denied_for_sc)
        self:declare_war_on_unvasalized_norscans(faction, self.stage_1_data.regions[faction_key])
    end

    -- Make sure every attacker is allied with each other. This is to ensure all of them are on the same chaos-tide.
    -- Further down the line they may fight each other, but for now we need them to push.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Trigger the chaos-related effects
    self:trigger_chaos_effects(self.settings.stage_2_delay, nil);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:trigger_incident(self.stage_1_incident_key, self.effects_global_key, self.settings.stage_2_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_chs_chaos")
    cm:register_instant_movie("Warhammer/chs_rises");

    -- Advance status to stage 1.
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_2()

    -- Spawn all the stage 2 chaos armies. This is where hell breaks loose... literally.
    for _, faction_key in pairs(self.settings.stage_2_data.factions) do

        -- Land spawns are region-based, so we spawn them using their region key.
        local army_count = math.ceil(2 * self.settings.difficulty_mod);
        local army_template = self.stage_2_data.army_templates[faction_key];
        if self.stage_2_data.regions[faction_key]["land"] ~= nil and self.stage_2_data.regions[faction_key]["land"]["regions"] ~= nil then
            for j, region_key in pairs(self.stage_2_data.regions[faction_key].land.regions) do
                if self.stage_2_data.regions[faction_key]["land"]["targets"] ~= nil then
                    local target_region_key = self.stage_2_data.regions[faction_key].land.targets[j];
                    if target_region_key ~= nil then
                        for i = 1, army_count do
                            table.insert(self.settings.stage_2_data.targets, target_region_key)
                        end

                        dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, self.settings.base_army_unit_count, false, army_count, self.name, chaos_invasion_spawn_armies_callback_sea)
                    else
                        script_error("ERROR: Missing target region for spawn at land.")
                    end
                else
                    dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, self.settings.base_army_unit_count, false, army_count, self.name, nil)
                end
            end

            -- Skarbrand has to spawn troops on its capital too.
            local faction = cm:get_faction(faction_key);
            if faction_key == "wh3_main_kho_exiles_of_khorne" then
                local region = faction:home_region();
                if not region == false and region:is_null_interface() == false then
                    dynamic_disasters:create_scenario_force(faction_key, region:name(), army_template, self.settings.base_army_unit_count, false, army_count, self.name, nil)
                end
            end

            -- First, declare war on the player, or we may end up in a locked turn due to mutual alliances. But do it after resurrecting them or we may break their war declarations!
            endgame:no_peace_no_confederation_only_war(faction_key)

            -- War declarations against AI.
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.stage_2_data.regions[faction_key].land.regions, true, self.denied_for_sc)
            self:declare_war_on_unvasalized_norscans(faction, self.stage_2_data.regions[faction_key].land.regions)
            if self.stage_2_data.regions[faction_key]["land"]["targets"] ~= nil then
                dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.stage_2_data.regions[faction_key].land.targets, true, self.denied_for_sc)
                self:declare_war_on_unvasalized_norscans(faction, self.stage_2_data.regions[faction_key].land.targets)
            end
        end

        -- Sea spawns are coordinate based with a region key of a land region nearby. We need to pass them a callback so they're out of the AI control until their target falls.
        if self.stage_2_data.regions[faction_key]["sea"] ~= nil and self.stage_2_data.regions[faction_key]["sea"]["coords"] ~= nil and self.stage_2_data.regions[faction_key]["sea"]["targets"] ~= nil then
            for j, coords in pairs(self.stage_2_data.regions[faction_key].sea.coords) do
                local target_region_key = self.stage_2_data.regions[faction_key].sea.targets[j];
                if target_region_key ~= nil then
                    for i = 1, army_count do
                        table.insert(self.settings.stage_2_data.targets, target_region_key)
                    end

                    dynamic_disasters:create_scenario_force_at_coords(faction_key, target_region_key, coords, army_template, self.settings.base_army_unit_count, false, army_count, self.name, chaos_invasion_spawn_armies_callback_sea)
                else
                    script_error("ERROR: Missing target region for spawn at sea.")
                end
            end

            local faction = cm:get_faction(faction_key);
            endgame:no_peace_no_confederation_only_war(faction_key)
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.stage_2_data.regions[faction_key].sea.targets, true, self.denied_for_sc)
            self:declare_war_on_unvasalized_norscans(faction, self.stage_2_data.regions[faction_key].sea.targets)
        end

        -- After spawning armies and declaring wars, try to give certain dark fortresses to specific factions. Only if norsca holds them.
        if self.dark_fortress_regions[faction_key] ~= nil then
            for i = 1, #self.dark_fortress_regions[faction_key] do
                local region_key = self.dark_fortress_regions[faction_key][i];
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region_owner == false or region_owner:is_null_interface() or (region_owner:name() == "wh_dlc08_sc_nor_norsca" and region_owner:is_human() == false) then

                        -- Do not get a hold of the dark fortresses if they're arleady owned by another demon faction.
                        local is_not_owned_by_ignored = true
                        local ignored_subcultures_for_transfer = {
                            "wh3_main_sc_dae_daemons",
                            "wh3_main_sc_kho_khorne",
                            "wh3_main_sc_nur_nurgle",
                            "wh3_main_sc_sla_slaanesh",
                            "wh3_main_sc_tze_tzeentch",
                            "wh_main_sc_chs_chaos",
                        };

                        if not region_owner == false and region_owner:is_null_interface() == false then
                            for j = 1, #ignored_subcultures_for_transfer do
                                if region_owner:subculture() == ignored_subcultures_for_transfer[j] then
                                    is_not_owned_by_ignored = false;
                                    break;
                                end
                            end
                        end

                        if is_not_owned_by_ignored == true then
                            cm:transfer_region_to_faction(region_key, faction_key)
                        end
                    end
                end
            end
        end
    end

    -- Make sure every attacker is allied with each other. This is to ensure all of them are on the same chaos-tide.
    -- Further down the line they may fight each other, but for now we need them to push.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    if self.settings.enable_rifts then

        -- Open the rifts on the chaos wastes and norsca.
        local percentage = 0.5 + (self.settings.difficulty_mod / 10);
        local min_chaos = 50;
        self:open_teleportation_nodes(self.teleportation_nodes_chaos_wastes, percentage, min_chaos);
        self:open_teleportation_nodes(self.teleportation_nodes_norsca, percentage, min_chaos);

        -- Prepare the final mission objectives.
        for _, faction_key in pairs(self.settings.factions) do
            table.insert(self.objectives[1].conditions, "faction " .. faction_key)
        end
    end

    -- Trigger the chaos-related effects
    self:trigger_chaos_effects(0, 10);

    -- The war declarations can cause a fair bit of issues. Make sure all chaos factions remain allies.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Trigger the end game mission.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.stage_2_incident_key, nil, self.settings.factions[1], function () self:trigger_end_disaster() end, true)
    dynamic_disasters:trigger_incident(self.stage_2_incident_key, self.effects_global_key, 0, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_chs_chaos")
    cm:register_instant_movie("Warhammer/chs_invasion");

    -- Advance status to stage 2.
    self:set_status(STATUS_STAGE_2);
end

-- Function to declare war on unvasalized norscans to actually vassaile them.
---@param faction FACTION_SCRIPT_INTERFACE #Faction that will declare war.
---@param regions string #Regions keys to declare war on.
function disaster_chaos_invasion:declare_war_on_unvasalized_norscans(faction, regions)
    local faction_key = faction:name();

    -- If the owners are norsca AND not a vassal of chaos, declare war on them too to kinda trigger a vasallization by force.
    for _, region_key in pairs(regions) do
        local region = cm:get_region(region_key);
        if not region == false and region:is_null_interface() == false and region:is_abandoned() == false then
            local region_owner = region:owning_faction()

            -- NOTE: there are a few chaos factions that we need to consider "norscan" for this check, or they cause issues with war declarations.
            if region_owner:is_null_interface() == false and region_owner:name() ~= "rebels" and (
                region_owner:subculture() == "wh_dlc08_sc_nor_norsca"
                --region_owner:name() == "wh2_dlc16_chs_acolytes_of_the_keeper" or
                --region_owner:name() == "wh3_main_chs_dreaded_wo" or
                --region_owner:name() == "wh3_main_chs_gharhar" or
                --region_owner:name() == "wh3_main_chs_khazag" or
                --region_owner:name() == "wh3_main_chs_kvellig" or
                --region_owner:name() == "wh3_main_chs_tong"
            ) and not faction:at_war_with(region_owner) then

                -- The chaos check must ignore the fake norscans.
                local is_vassal_of_chaos = false;
                for _, chaos_faction_key in pairs(self.default_settings.factions) do
                    if region_owner:is_vassal(chaos_faction_key) then
                        is_vassal_of_chaos = true;
                        break;
                    end
                end

                -- NOTE: This fails to declare war on certain chaos factions (Khazag, Tong,...) which are considered internally as Chaos.
                if not is_vassal_of_chaos then
                    local vassalizers = {
                        "wh3_main_sc_dae_daemons",
                        "wh3_main_sc_kho_khorne",
                        "wh3_main_sc_nur_nurgle",
                        "wh3_main_sc_sla_slaanesh",
                        "wh3_main_sc_tze_tzeentch",
                        "wh_dlc03_sc_bst_beastmen",
                        "wh_main_sc_chs_chaos",
                    };

                    dynamic_disasters:declare_war_for_owners_and_neightbours(faction, regions, true, vassalizers)
                end
            end

            -- After checking the region owner, check the neighbours too for the same thing.
            local adjacent_regions = region:adjacent_region_list()
            for i = 0, adjacent_regions:num_items() - 1 do
                local ad_region = adjacent_regions:item_at(i)
                if not ad_region == false and ad_region:is_null_interface() == false and ad_region:is_abandoned() == false then
                    local ad_region_owner = ad_region:owning_faction()

                    -- NOTE: there are a few chaos factions that we need to consider "norscan" for this check, or they cause issues with war declarations.
                    if ad_region_owner:is_null_interface() == false and ad_region_owner:name() ~= "rebels" and (
                        ad_region_owner:subculture() == "wh_dlc08_sc_nor_norsca"
                        --ad_region_owner:name() == "wh2_dlc16_chs_acolytes_of_the_keeper" or
                        --ad_region_owner:name() == "wh3_main_chs_dreaded_wo" or
                        --ad_region_owner:name() == "wh3_main_chs_gharhar" or
                        --ad_region_owner:name() == "wh3_main_chs_khazag" or
                        --ad_region_owner:name() == "wh3_main_chs_kvellig" or
                        --ad_region_owner:name() == "wh3_main_chs_tong"
                    ) and not faction:at_war_with(ad_region_owner) then

                        -- The chaos check must ignore the fake norscans.
                        local is_vassal_of_chaos = false;
                        for _, chaos_faction_key in pairs(self.default_settings.factions) do
                            if ad_region_owner:is_vassal(chaos_faction_key) then
                                is_vassal_of_chaos = true;
                                break;
                            end
                        end

                        -- NOTE: This fails to declare war on certain chaos factions (Khazag, Tong,...) which are considered internally as Chaos.
                        if not is_vassal_of_chaos then
                            local vassalizers = {
                                "wh3_main_sc_dae_daemons",
                                "wh3_main_sc_kho_khorne",
                                "wh3_main_sc_nur_nurgle",
                                "wh3_main_sc_sla_slaanesh",
                                "wh3_main_sc_tze_tzeentch",
                                "wh_dlc03_sc_bst_beastmen",
                                "wh_main_sc_chs_chaos",
                            };

                            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, regions, true, vassalizers)
                        end
                    end
                end
            end
        end
    end
end

-- Function to trigger the opening of the Chaos Wastes rifts.
---@param nodes table #Numeric-indexed table with the list of node keys to open.
---@param percentage float? #Optional. Percentage of the closed nodes of the nodes provided that we're going to open. Accepts values 0-1.
---@param min_chaos_required float? #Optional. Minimal amount of chaos required in a province to allow spawning a rift. Accepts values 0-100.
function disaster_chaos_invasion:open_teleportation_nodes(nodes, percentage, min_chaos_required)
    out("Frodo45127: Opening rifts.");
    if percentage == nil or percentage > 1 or percentage < 0.1 then
        percentage = 1.0;
    end

    if min_chaos_required == nil or min_chaos_required > 100 or min_chaos_required < 0 then
        min_chaos_required = 50;
    end

    local world = cm:model():world();
    local network = world:teleportation_network_system():lookup_network(self.teleportation_network);
    local closed_nodes = network:closed_nodes();
    local available_nodes = {};

    -- Get the open nodes from our subset, so we can limit them if there are too many open nodes.
    local open_nodes = 0;
    for i = 1, #nodes do
        local node = network:lookup_open_node(nodes[i]);
        if not node == nil and not node == false and not node:is_null_interface() then
            open_nodes = open_nodes + 1;
        end
    end

    -- Get all the closed nodes and their coordinates, so we only have to deal with closed ones.
    for i = 1, #nodes do
        for j = 0, closed_nodes:num_items() - 1 do
            local current_closed_node = closed_nodes:item_at(j);
            if current_closed_node:key() == nodes[i] then
                local x, y = current_closed_node:position();
                table.insert(available_nodes, {current_closed_node:key(), x, y});
            end
        end;
    end

    -- Sort them randomly.
    available_nodes = cm:random_sort(available_nodes);

    local max_nodes_open = (#nodes * percentage) - open_nodes;
    if max_nodes_open <= 0 then
        out("Frodo45127: Too many rifts open. Not opening more.");
    else
        out("Frodo45127: Rifts to open: " .. max_nodes_open .. ".");
        for i = 1, max_nodes_open do
            if available_nodes[i] then

                --Try to open nodes with corruptions that buff faction owners.
                local region = world:region_data_at_position(available_nodes[i][2], available_nodes[i][3]):region();
                if not region == false and region:is_null_interface() == false then

                    local corruption_undivided = cm:get_corruption_value_in_region(region, "wh3_main_corruption_chaos");
                    local corruption_khorne = cm:get_corruption_value_in_region(region, "wh3_main_corruption_khorne");
                    local corruption_nurgle = cm:get_corruption_value_in_region(region, "wh3_main_corruption_nurgle");
                    local corruption_slaanesh = cm:get_corruption_value_in_region(region, "wh3_main_corruption_slaanesh");
                    local corruption_tzeentch = cm:get_corruption_value_in_region(region, "wh3_main_corruption_tzeentch");

                    out("Frodo45127: region: " .. region:name() .. ", corruption_undivided: " .. tostring(corruption_undivided) .. ", corruption_khorne: " .. tostring(corruption_khorne) .. ", corruption_nurgle: " .. tostring(corruption_nurgle) .. ", corruption_slaanesh: " .. tostring(corruption_slaanesh) .. ", corruption_tzeentch: " .. tostring(corruption_tzeentch) .. ".")
                    if corruption_undivided >= min_chaos_required or
                        corruption_khorne >= min_chaos_required or
                        corruption_nurgle >= min_chaos_required or
                        corruption_slaanesh >= min_chaos_required or
                        corruption_tzeentch >= min_chaos_required then

                        local corruption = false;
                        local faction = region:owning_faction()
                        if not faction == false and faction:is_null_interface() == false then
                            corruption = self:favoured_corruption_for_faction(faction);
                        end

                        local template = nil;
                        if corruption == false then
                            template = self.teleportation_nodes_templates[math.random(#self.teleportation_nodes_templates)];
                        else
                            template = corruption;
                        end
                        out("Frodo45127: region: " .. region:name() .. ", X: " .. tostring(available_nodes[i][2]) .. ", Y: " .. tostring(available_nodes[i][3]) .. ", faction: " .. faction:name() .. ", corruption: " .. tostring(corruption) .. ", template: " .. tostring(template) .. ".")

                        cm:teleportation_network_open_node(available_nodes[i][1], template);
                    end
                end;
            else
                break;
            end
        end;
    end
end

-- This function generates and triggers a rift closure battle.
---@param character CHARACTER_SCRIPT_INTERFACE #Character object to attack with the generated army.
---@param node_template string #Node template key.
---@param attacker_is_defender boolean #Optional. If the attacker must be setup as defender.
---@param defender_general_subtype string #Optional. If provided, the defender's army will be commanded by this general.
---@param unit_count integer #Optional. Amount of units in the spawned army.
function disaster_chaos_invasion:generate_rift_closure_battle(character, node_template, attacker_is_defender, defender_general_subtype, unit_count)
    if attacker_is_defender == nil then
        attacker_is_defender = false;
    end

    if unit_count == nil then
        unit_count = math.random(14, 20);
    end

    local mf = character:military_force();
    local faction = character:faction();
    local faction_name = faction:name();

    local rift_closure_battle_faction = self.rift_closure_force_data[node_template][1];
    local rift_closure_battle_units = dynamic_disasters:generate_random_army(self.teleportation_nodes_defender_army_templates[node_template], unit_count, self.rift_closure_force_data[node_template][2]);

    -- guard against invasion already existing
    invasion_manager:kill_invasion_by_key("ChaosInvasionRiftClosureArmy");

    -- Spawn the invasion, declare war on them and force them to do an attack of oportunity.
    ---@type invasion
    local invasion_1 = invasion_manager:new_invasion("ChaosInvasionRiftClosureArmy", rift_closure_battle_faction, rift_closure_battle_units, {character:logical_position_x(), character:logical_position_y()});
    invasion_1:set_target("CHARACTER", character:command_queue_index(), faction_name);
    invasion_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);

    if type(defender_general_subtype) == "string" then
        invasion_1:create_general(true, defender_general_subtype, nil, nil, nil, nil);
    end

    invasion_1:start_invasion(
        function(context2)
            core:add_listener(
                "ChaosInvasionRiftClosureBattleWarDeclared",
                "FactionLeaderDeclaresWar",
                function(context)
                    return context:character():faction():name() == rift_closure_battle_faction;
                end,
                function()
                    local attacker_mf = context2:get_general():military_force()
                    local attacker_cqi = attacker_mf:command_queue_index();             -- Invader.
                    local defender_cqi = mf:command_queue_index();                      -- Player.

                    -- Lock the AI army so it doesn't run away.
                    cm:set_force_has_retreated_this_turn(attacker_mf);
                    if attacker_is_defender then
                        cm:force_attack_of_opportunity(defender_cqi, attacker_cqi, false);
                    else
                        cm:force_attack_of_opportunity(attacker_cqi, defender_cqi, false);
                    end

                end,
                false
            );

            cm:force_declare_war(rift_closure_battle_faction, faction_name, false, false);
        end,
        false,
        false,
        false
    );
end

-- This function returns the proper trait for debuffing armies traveling the chaos realms.
---@param realm string #Realm corresponding to one of the rifts we're taversing.
---@param subculture string #Subculture key. If it's daemonic, it'll not receive their own trait.
---@param faction_key string #Faction key. Optional, to specify daemonic factions that don't match by subculture with one of the four chaos gods.
function disaster_chaos_invasion:get_chaos_trait_name(realm, subculture, faction_key)
    local trait = "wh3_main_trait_realm_" .. realm;
    if subculture == "wh3_main_sc_kho_khorne" or faction_key == "wh3_dlc20_chs_valkia" then
        if realm == "khorne" then
            return false;
        end;

        trait = trait .. "_daemons";
    elseif subculture == "wh3_main_sc_nur_nurgle" or faction_key == "wh3_dlc20_chs_festus" then
        if realm == "nurgle" then
            return false;
        end;

        trait = trait .. "_daemons";
    elseif subculture == "wh3_main_sc_sla_slaanesh" or faction_key == "wh3_dlc20_chs_azazel" then
        if realm == "slaanesh" then
            return false;
        end;

        trait = trait .. "_daemons";
    elseif subculture == "wh3_main_sc_tze_tzeentch" or faction_key == "wh3_dlc20_chs_vilitch" then
        if realm == "tzeentch" then
            return false;
        end;

        trait = trait .. "_daemons";
    elseif subculture == "wh3_main_sc_dae_daemons" or faction_key == "wh3_main_chs_shadow_legion" then
        trait = trait .. "_daemons";
    end;

    return trait;
end;

-- Get the corruption settings table for a given faction, based on which faction set that faction appears in.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object
---@return false|string #False in case of failure to get corruption, pooled resource key of the corruption if ok.
function disaster_chaos_invasion:favoured_corruption_for_faction(faction)
    local valid_corruptions_count = 0
    local pooled_resource = nil
    local valid_corruptions_string = ""

    for set_key, resource in pairs(self.favoured_corruptions) do
        if faction:is_contained_in_faction_set(set_key) then
            valid_corruptions_count = valid_corruptions_count + 1
            pooled_resource = resource
            valid_corruptions_string = valid_corruptions_string .. set_key .. ", "
        end
    end

    if valid_corruptions_count > 1 then
        out("Frodo45127: Faction '" .. faction:name() .. "' was found to be valid in multiple preferred corruption sets: " .. tostring(valid_corruptions_string) .. ". A faction should only ever be contained within one of these sets.")
        return false
    elseif valid_corruptions_count == 0 then
        out("Frodo45127: No corruptions found for faction " .. faction:name() .. ".")
        return false
    end

    return pooled_resource
end

-- Callback function to pass to a create_force function. It ties the spawned army to an invasion force and force it to attack an specific settlement.
---@param cqi integer #CQI of the army.
function chaos_invasion_spawn_armies_callback_sea(cqi)
    out("Frodo45127: Callback for force " .. tostring(cqi) .. " triggered.")

    local character = cm:char_lookup_str(cqi)
    cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
    cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
    cm:add_agent_experience(character, cm:random_number(25, 15), true)
    cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))

    local general = cm:get_character_by_cqi(cqi)
    local invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())

    if invasion == nil or invasion == false then
        return
    end

    -- Store all the disaster's cqis, so we can free them later.
    for i = 1, #dynamic_disasters.disasters do
        local disaster = dynamic_disasters.disasters[i];
        if disaster.name == "chaos_invasion" then
            local cqis = {};
            local targets = {};
            if disaster.settings.status == STATUS_TRIGGERED then
                cqis = disaster.settings.stage_1_data.cqis;
                targets = disaster.settings.stage_1_data.targets;
            elseif disaster.settings.status == STATUS_STAGE_1 then
                cqis = disaster.settings.stage_2_data.cqis;
                targets = disaster.settings.stage_2_data.targets;
            end
            out("\tFrodo45127: Army with cqi " .. cqi .. " created and added to the invasions force.")

            table.insert(cqis, cqi);

            local region_key = targets[#targets];
            local region = cm:get_region(region_key);

            if not region == false and region:is_null_interface() == false then
                local faction = region:owning_faction();
                if not faction == false and faction:is_null_interface() == false and faction:name() ~= "rebels" then
                    local faction_key = faction:name();

                    -- If the target is destroyed, or owned by one of the chaos factions or by rebels,
                    -- release the army from the invasion. Otherwise we'll get stuck armies at sea.
                    if faction:subculture() == "wh3_main_sc_dae_daemons" or
                        faction:subculture() == "wh3_main_sc_kho_khorne" or
                        faction:subculture() == "wh3_main_sc_nur_nurgle" or
                        faction:subculture() == "wh3_main_sc_sla_slaanesh" or
                        faction:subculture() == "wh3_main_sc_tze_tzeentch" or
                        faction:subculture() == "wh_dlc03_sc_bst_beastmen" or
                        faction:subculture() == "wh_dlc08_sc_nor_norsca" or
                        faction:subculture() == "wh_main_sc_chs_chaos" then
                        invasion:release();
                        return;
                    end

                    invasion:set_target("REGION", region_key, faction_key);
                    invasion:add_aggro_radius(15)

                    if invasion:has_target() then
                        out.design("\t\tFrodo45127: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to attack " .. region_key .. ".")
                        invasion:start_invasion(nil, false, false, false)
                    end

                -- If there is no owner (abandoned?) release the army and return.
                else
                    invasion:release();
                    return;
                end
            end
        end
    end
end

-- Function to restore the vortex after being removed.
function disaster_chaos_invasion:restore_vortex()
    self.settings.great_vortex_undone = false;

    -- Disable the extra infinite effect for losing the Vortex.
    local faction_list = cm:model():world():faction_list()

    -- Remove the Great Vortex undone effect from everyone.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        cm:remove_effect_bundle(self.great_vortex_undone_effect_key, faction:name());
    end

    --cm:add_vfx(dynamic_disasters.vortex_key, dynamic_disasters.vortex_vfx, 171.925, 431.5, 0)
end

-- Function to trigger the effects related with each stage of the chaos invasion.
---@param duration_global_effects integer #Duration of the effects, in turns.
---@param duration_buffs integer #Optional. Duration of the buffs, in turns.
function disaster_chaos_invasion:trigger_chaos_effects(duration_global_effects, duration_buffs)
    if duration_buffs == nil then
        duration_buffs = duration_global_effects;
    end

    local faction_list = cm:model():world():faction_list()

    -- Apply the corruption effects to all alive factions, except humans.
    -- Humans get this effect via payload with effect.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)

        if not faction:is_dead() and faction:is_human() == false then
            cm:apply_effect_bundle(self.effects_global_key, faction:name(), duration_global_effects)
        end
    end

    -- Apply attackers buffs to all alive attackers.
    for _, faction_key in pairs(self.settings.factions) do
        cm:apply_effect_bundle(self.attacker_buffs_key, faction_key, duration_buffs);
    end
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function disaster_chaos_invasion:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");

        local faction_list = cm:model():world():faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            cm:remove_effect_bundle(self.great_vortex_undone_effect_key, faction:name());
            cm:remove_effect_bundle(self.effects_global_key, faction:name());
        end

        -- Remove all the related listeners.
        core:remove_listener("ChaosInvasionRiftArmies");
        core:remove_listener("ChaosInvasionRespawnRiftsChaosWastes");
        core:remove_listener("ChaosInvasionRiftSwitchingTemplates");
        core:remove_listener("ChaosInvasionRiftClosingBattleQuery");
        core:remove_listener("ChaosInvasionRiftClosingBattle");
        core:remove_listener("ChaosInvasionRiftClosingBattleCleanup");
        core:remove_listener("ChaosInvasionRiftClosingBattleCleanupAfterRetreat");
        core:remove_listener("ChaosInvasionRiftEventBattleCleanup");
        core:remove_listener("ChaosInvasionRiftEventBattleCleanupAfterRetreat");
        core:remove_listener("ChaosInvasionRiftArmyTravelCompleted");
        core:remove_listener("ChaosInvasionRiftEventPendingBattle");
        core:remove_listener("ChaosInvasionRiftTraitRemover");
        core:remove_listener("ChaosInvasionFreeArmiesStage1");
        core:remove_listener("ChaosInvasionFreeArmiesStage2");
        core:remove_listener("ChaosInvasionGreatVortexUndoneAIEnd");
        core:remove_listener("ChaosInvasionGreatVortexUndoneTrigger");

        -- Close all the open rifts.
        cm:teleportation_network_close_all_nodes(self.teleportation_network);

        dynamic_disasters:finish_disaster(self);
    end
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function disaster_chaos_invasion:check_start_disaster_conditions()

    -- Update the potential factions for stage 1, removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers for stage 1.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Check that Archaon is alive or dead and non-confederated. It's needed to kickstart the disaster.
    local is_archaon_available = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction_key == "wh_main_chs_chaos" and faction:was_confederated() == false then
            is_archaon_available = true;
            break
        end
    end

    -- Do not start if Archaon is not available to use.
    if is_archaon_available == false then
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

    -- Base chance: 1/100 turns (1%).
    local base_chance = 0.01;
    if math.random() < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_chaos_invasion:check_end_disaster_conditions()

    -- Update the list of available factions and check if are all dead.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.default_settings.factions);
    local all_attackers_dead = true;

    if #self.settings.factions > 0 then
        for _, faction_key in pairs(self.settings.factions) do
            local faction = cm:get_faction(faction_key);
            if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
                all_attackers_dead = false;
            end
        end
    end

    -- If all chaos factions are dead, end the disaster. If not, check depending on the state we're about to trigger.
    if all_attackers_dead == true then
        return true;
    end

    -- If we haven't triggered the first stage, just check if Archaon is confederated. If so, we end the disaster here.
    if self.settings.status == STATUS_TRIGGERED then

        -- Update the list of available factions.
        self.settings.stage_1_data.factions = dynamic_disasters:remove_confederated_factions_from_list(self.default_settings.stage_1_data.factions);

        local faction_key = "wh_main_chs_chaos";
        local faction = cm:get_faction(faction_key);
        return faction == false or faction:is_null_interface() == true or faction:was_confederated() == true;
    end

    -- If we're on Stage 1, check if any of the factions we use is still available to use. We don't check for dead factions here.
    if self.settings.status == STATUS_STAGE_1 then

        -- Update the list of available factions.
        self.settings.stage_2_data.factions = dynamic_disasters:remove_confederated_factions_from_list(self.default_settings.stage_2_data.factions);
        local all_attackers_unavailable_stage_2 = true;

        if #self.settings.stage_2_data.factions > 0 then
            for _, faction_key in pairs(self.settings.stage_2_data.factions) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
                    all_attackers_unavailable_stage_2 = false;
                    break;
                end
            end
        end

        return all_attackers_unavailable_stage_2;
    end

    return false;
end

-- Return the disaster so the manager can read it.
return disaster_chaos_invasion
