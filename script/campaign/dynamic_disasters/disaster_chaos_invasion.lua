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
                - Targets:
                    - Archaon: Kislev, Praag, Erenburg.
                    - Sigvald: No particular target, just buildup of forces.
                    - Kholek: Zharr Naggrund, Firemouth.
                    - Valkia: Naggarond.
                - Spawn each faction's armies in provinces we expect they have by now.
                - Each attacker faction declares war on all non-chaos/non vassal of chaos owners of said provinces and on all its neightbours.
                - Trigger "Flow of the Polar Gates" incident (global chaos corruption).
                - Trigger "Chaos Rises" video.
                - Wait 6-10 turns for more info.
        - Stage 2:
            - Targets:
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
                - Vilich: Averheim (From Barak Varr).
                - Azzazel: Tor Sethai, Vaul's Anvil (Ulthuan), Lothern.

            - Spawn each faction's armies in provinces we expect they have by now, at sea, or near their objectives.
            - Each attacker faction declares war on all non-chaos/non vassal of chaos owners of said provinces and on all its neightbours.
            - Trigger "Flow of the Polar Gates" incident (global chaos corruption).
            - Trigger "Chaos Invasion" (Sarthorael's spawn) video.
            - Give all non player-controlled dark fortresses to chaos armies.
            - Wait 6-10 turns for more info.



    -- Reference: https://warhammerfantasy.fandom.com/wiki/End_Times_Timeline#Appendix_1_-_Chronology_of_the_End_Times
    Ideas:
        - If this has started, the great ascendancy has more probabilities of starting.
        - Requires archaon to be non-vassalized (maybe alive too?).
        - Warning 8-12 turns before (reuse wh1/2 stuff?).
        - First wave:
            - Spawn many armies for Archaon, Sigvald, Kholek and Valkia to lead the push through Norsca, the Mountains of Morne and Naggarond.
            - Force-vasallize any remaining norscan tribe by their closest chaos character. We need a chaos-tide.
            - Force all remaining chaos factions into war with ALL order/neutral factions.
            - Spawn rifts?
        - Second wave (only if kislev is still alive):
            - Spawn armies of Kairos near bretonia (year of misfortune).
            - Small global chaos corruptionincrease.
            - If chaos corruption goes above 75, spawn a rift on a province.
                - Said rift will spawn daemon armies each 10 turns + 1 an initial one.
            - Find Surtha Ek, attack kislev with him + multiple norscan armies from vasalized factions.
        - Second.5 wave (if vilich is usable);
            - If player is not cathayan, spawn a few armies to simulate vilich's attack to the great bastion.
            - If player is cathayan, increase a lot the bastion thread for the rest of the disaster.
        - Second.55 wave:
            - If Chaos captures all dark fortresses, you have a 50 countdown timer.
                - Put static reinforcements on ALL DARK FORTRESSES (1 ARMY OF EACH GOD?).
                - Take at least one back, or they'll open a great rift of Chaos and all will go to hell.
        - Third wave (only if NKari can be used):
            - Buff Nkari, give him armies and buff its corruption in the whole donut.
            - Message about the vortex dissapearing.
            - If player is the high elves, spawn a few armies near the gates, so they're used.
        - If chaos takes a certain amount of territories on Ulthuan:
            - Remove the vortex?
            - Trigger full chaos corruption accross the globe. Spawn more chaos armies.
            - Spawn daemonic armies at random provinces.
            - Spawn big daemonic armies north and south poles.
            - Give INCARNATION trait to certain characters?
            - SINK THE FUCKING DONUT, HIDING IT IN THE SHROUD.

        Stupid ideas and integrations:
            - If Miao Ying/Zharina are dead, vasalize them to Nkari/Azzazel.
            - If Naggarond is dead, vasalize them to Valkia.
            - If the high elves are dead, vasalize them to NKari.
            - If the empire is dead, vasalize it to Nurgle.
            - If grimgor is alive, trigger a separate disaster of him marching against Cathay.
            - Give the player (and every faction) a choice to swap sides and become part of the chaos tide, as a vassal of one of the chaos gods.
                - As an incentive, you may be able to recruit chaos armies and maybe get access to warband?
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;
local STATUS_STAGE_3 = 4;

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
    settings = {

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
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

        -- Disaster-specific data.
        base_army_unit_count = 19,
        stage_1_delay = 1,
        stage_2_delay = 1,
        stage_3_delay = 1,

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
            },

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
            },
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

            regions = {
                wh_main_chs_chaos = {
                    land = {
                        "wh3_main_combi_region_the_writhing_fortress",
                        "wh3_main_combi_region_the_howling_citadel",
                        "wh3_main_combi_region_the_crystal_spires",
                    }
                },
                wh3_dlc20_chs_kholek = {
                    land = {
                        "wh3_main_combi_region_the_challenge_stone",
                        "wh3_main_combi_region_the_volary",
                        "wh3_main_combi_region_icespewer",
                    }
                },
                wh3_dlc20_chs_sigvald = {
                    land = {
                        "wh3_main_combi_region_black_rock",
                        "wh3_main_combi_region_the_twisted_towers",
                        "wh3_main_combi_region_the_forest_of_decay",
                    }
                },
                wh3_main_dae_daemon_prince = {
                    land = {
                        "wh3_main_combi_region_the_forbidden_citadel",
                        "wh3_main_combi_region_sarl_encampment",
                        "wh3_main_combi_region_naglfari_plain",
                    },
                },
                wh3_main_chs_shadow_legion = {
                    land = {
                        "wh3_main_combi_region_konquata",
                        "wh3_main_combi_region_isle_of_wights",
                        "wh3_main_combi_region_citadel_of_lead",
                    },
                },
                wh3_dlc20_chs_valkia = {
                    land = {
                        "wh3_dlc20_combi_region_glacier_encampment",
                        "wh3_main_combi_region_dagraks_end",
                        "wh3_dlc20_combi_region_glacial_gardens",
                    },
                },
                wh3_dlc20_chs_festus = {
                    land = {
                        "wh3_main_combi_region_middenstag", --"wh3_main_combi_region_brass_keep", Brass keep alwasy fail to spawn armies, so we use Middenstag instead as spawning region.
                        "wh3_main_combi_region_hergig",
                        "wh3_dlc20_combi_region_krudenwald",
                    },
                },
                wh3_dlc20_chs_vilitch = {
                    sea = {
                        coords = {
                            {605, 465},
                            {563, 404},
                        },
                        region_key = "wh3_main_combi_region_barak_varr",
                    }
                },
                wh3_dlc20_chs_azazel = {
                    sea = {
                        coords = {
                            {278, 482},
                            {182, 519},
                            {221, 487},
                        },
                        region_key = "wh3_main_combi_region_lothern",
                    }
                },
                wh3_main_kho_exiles_of_khorne = {
                    land = {
                        "wh3_main_combi_region_infernius",
                    },
                },
                wh3_main_nur_poxmakers_of_nurgle = {
                    sea = {
                        coords = {
                            {332, 650},
                            {350, 615},
                            {370, 584},
                        },
                        region_key = "wh3_main_combi_region_mousillon",
                    }
                },
                wh3_main_tze_oracles_of_tzeentch = {
                    sea = {
                        coords = {
                            {381, 560},
                            {416, 501},
                            {397, 528},
                        },
                        region_key = "wh3_main_combi_region_castle_carcassonne",
                    }
                },
                wh3_main_tze_sarthoraels_watchers = {
                    sea = {
                        coords = {
                            {132, 412},
                            {181, 373},
                        },
                        region_key = "wh3_main_combi_region_the_high_sentinel",
                    }
                },
                wh3_main_sla_seducers_of_slaanesh = {
                    land = {
                        "wh3_main_combi_region_tor_achare",
                        "wh3_main_combi_region_elisia",
                        "wh3_main_combi_region_shrine_of_kurnous",
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

    stage_early_warning_incident_key = "dyn_dis_chaos_invasion_stage_early_warning",
    stage_1_incident_key = "dyn_dis_chaos_invasion_stage_1_trigger",
    stage_2_incident_key = "dyn_dis_chaos_invasion_stage_2_trigger",
    stage_3_incident_key = "dyn_dis_chaos_invasion_stage_3_trigger",
    finish_before_stage_1_event_key = "dyn_dis_chaos_invasion_finish_before_stage_1",
    finish_event_key = "dyn_dis_chaos_invasion_finish",

    endgame_mission_name = "endtimes_unfolding",

    attacker_buffs_key = "fro_dyn_dis_chaos_invasion_attacker_buffs",
    effects_global_key = "fro_dyn_dis_chaos_invasion_global_effects",
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_chaos_invasion:set_status(status)
    self.settings.status = status;

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
                    dynamic_disasters:execute_payload(self.finish_before_stage_1_event_key, nil, 0, nil);
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
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("ChaosInvasionStage2")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_2 then

        -- This triggers stage three of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "ChaosInvasionStage3",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay then
                    return true
                end
                return false;
            end,
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_3();
                end
                core:remove_listener("ChaosInvasionStage3")
            end,
            true
        );
    end
end

-- Function to trigger the disaster. From here until the end of the disaster, everything is managed by the disaster itself.
function disaster_chaos_invasion:trigger()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering first warning.");

    if dynamic_disasters.settings.debug == false then
        self.settings.stage_1_delay = math.random(8, 12);
    else
        self.settings.stage_1_delay = 1;
    end

    -- Initialize listeners.
    dynamic_disasters:execute_payload(self.stage_early_warning_incident_key, nil, self.settings.stage_1_delay, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_1()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering stage 1.");

    if dynamic_disasters.settings.debug == false then
        self.settings.stage_2_delay = math.random(6, 10);
    else
        self.settings.stage_2_delay = 1;
    end

    -- Spawn all the initial chaos armies.
    for _, faction_key in pairs(self.settings.stage_1_data.factions) do
        for _, region_key in pairs(self.settings.stage_1_data.regions[faction_key]) do
            local army_template = self.settings.stage_1_data.army_templates[faction_key];
            dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, self.settings.base_army_unit_count, false, math.ceil(3 * self.settings.difficulty_mod), self.name)
        end

        local faction = cm:get_faction(faction_key);
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.settings.stage_1_data.regions[faction_key], true, self.denied_for_sc)
    end

    -- Make sure every attacker is allied with each other. This is to ensure all of them are on the same chaos-tide.
    -- Further down the line they may fight each other, but for now we need them to push.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, true);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:execute_payload(self.stage_1_incident_key, self.effects_global_key, self.settings.stage_2_delay, nil);
    self:trigger_chaos_effects(self.settings.stage_2_delay);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_chs_chaos")
    cm:register_instant_movie("Warhammer/chs_rises");

    -- Advance status to stage 1.
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_2()

    if dynamic_disasters.settings.debug == false then
        self.settings.stage_3_delay = math.random(6, 10);
    else
        self.settings.stage_3_delay = 1;
    end

    -- Spawn all the stage 2 chaos armies. This is where hell breaks loose... literally.
    for _, faction_key in pairs(self.settings.stage_2_data.factions) do

        -- Land spawns are region-based, so we spawn them using their region key.
        if self.settings.stage_2_data.regions[faction_key]["land"] ~= nil then
            for _, region_key in pairs(self.settings.stage_2_data.regions[faction_key].land) do
                local army_template = self.settings.stage_2_data.army_templates[faction_key];
                dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, self.settings.base_army_unit_count, false, math.ceil(2 * self.settings.difficulty_mod), self.name)
            end

            -- Skarbrand has to spawn troops on its capital too.
            local faction = cm:get_faction(faction_key);
            if faction_key == "wh3_main_kho_exiles_of_khorne" then
                local region = faction:home_region();
                if not region == nil then
                    local army_template = self.settings.stage_2_data.army_templates[faction_key];
                    dynamic_disasters:create_scenario_force(faction_key, region:name(), army_template, self.settings.base_army_unit_count, false, math.ceil(2 * self.settings.difficulty_mod), self.name)
                end
            end

            endgame:no_peace_no_confederation_only_war(faction_key)
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.settings.stage_2_data.regions[faction_key].land, true, self.denied_for_sc)
        end

        -- Sea spawns are coordinate based with a region key of a land region nearby.
        if self.settings.stage_2_data.regions[faction_key]["sea"] ~= nil then
            for _, coords in pairs(self.settings.stage_2_data.regions[faction_key].sea.coords) do
                local army_template = self.settings.stage_2_data.army_templates[faction_key];
                local region_key =self.settings.stage_2_data.regions[faction_key].sea.region_key;

                dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, coords, army_template, self.settings.base_army_unit_count, false, math.ceil(2 * self.settings.difficulty_mod), self.name)
            end

            local faction = cm:get_faction(faction_key);
            endgame:no_peace_no_confederation_only_war(faction_key)
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, { self.settings.stage_2_data.regions[faction_key].sea.region_key }, true, self.denied_for_sc)
        end

        -- After spawning armies and declaring wars, try to give certain dark fortresses to specific factions.
        if self.dark_fortress_regions[faction_key] ~= nil then
            for i = 1, #self.dark_fortress_regions[faction_key] do
                local region_key = self.dark_fortress_regions[faction_key][i];
                local region = cm:get_region(region_key)
                if not region == false and region:is_null_interface() == false then
                    local region_owner = region:owning_faction()
                    if region_owner == false or region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false) then

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
                            for i = 1, #ignored_subcultures_for_transfer do
                                if region_owner:subculture() == ignored_subcultures_for_transfer[i] then
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

    -- Prepare the final mission objectives.
    for _, faction_key in pairs(self.settings.factions) do
        table.insert(self.objectives[1].conditions, "faction " .. faction_key)
    end

    -- Trigger the end game mission. TODO: Put the effect into an incident.
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.stage_2_incident_key, nil, self.settings.factions[1], self:trigger_end_disaster())

    dynamic_disasters:execute_payload(self.stage_2_incident_key, self.effects_global_key, self.settings.stage_3_delay, nil);
    self:trigger_chaos_effects(self.settings.stage_3_delay);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_chs_chaos")
    cm:register_instant_movie("Warhammer/chs_invasion");

    -- Advance status to stage 2.
    self:set_status(STATUS_STAGE_2);
end

-- Function to trigger the third stage of the Chaos Invasion.
function disaster_chaos_invasion:trigger_stage_3()


    -- Advance status to stage 3.
    self:set_status(STATUS_STAGE_3);
end

-- Function to trigger cleanup stuff after the disaster is over.
--
-- It has to call the dynamic_disasters:finish_disaster(self) at the end.
function disaster_chaos_invasion:trigger_end_disaster()
    dynamic_disasters:finish_disaster(self);
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
-- @return boolean If the disaster will be triggered or not.
function disaster_chaos_invasion:check_start_disaster_conditions()

    -- Update the potential factions for stage 1, removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Check if any of the attackers if actually alive.
    local attackers_still_alive = false;
    local is_archaon_available = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false then
            attackers_still_alive = true;
        end

        -- Check that Archaon is alive or dead and non-confederated. It's needed to kickstart the disaster.
        if faction_key == "wh_main_chs_chaos" and faction:was_confederated() == false then
            is_archaon_available = true;
        end

        -- Shortcut to exit the loop early.
        if attackers_still_alive == true and is_archaon_available == true then
            break;
        end
    end

    -- Do not start if Archaon is not available to use.
    if is_archaon_available == false then
        return false;
    end

    -- Do not start if we don't have attackers for stage 1.
    if #self.settings.factions == 0 or attackers_still_alive == false then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
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

-- Function to trigger the effects related with each stage of the chaos invasion.
---@param duration integer #Duration of the effects, in turns.
function disaster_chaos_invasion:trigger_chaos_effects(duration)
    local faction_list = cm:model():world():faction_list()

  -- Apply the corruption effects to all alive factions, except humans.
    -- Humans get this effect via payload with effect.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)

        if not faction:is_dead() and faction:is_human() == false then
            cm:apply_effect_bundle(self.effects_global_key, faction:name(), duration)
        end
    end

    -- Apply attackers buffs to all alive attackers.
    for _, faction_key in pairs(self.settings.factions) do
        cm:apply_effect_bundle(self.attacker_buffs_key, faction_key, duration);
    end
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_chaos_invasion:check_end_disaster_conditions()

    -- Update the list of available factions and check if are all dead.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);
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
        self.settings.stage_1_data.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.stage_1_data.factions);

        local faction_key = "wh_main_chs_chaos";
        local faction = cm:get_faction(faction_key);
        return faction == false or faction:is_null_interface() == true or faction:was_confederated() == true;
    end

    -- If we're on Stage 1, check if any of the factions we use is still available to use. We don't check for dead factions here.
    if self.settings.status == STATUS_STAGE_1 then

        -- Update the list of available factions.
        self.settings.stage_2_data.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.stage_2_data.factions);
        local all_attackers_unavailable = true;

        if #self.settings.stage_2_data.factions > 0 then
            for _, faction_key in pairs(self.settings.stage_2_data.factions) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
                    all_attackers_unavailable = false;
                    break;
                end
            end
        end

        return all_attackers_unavailable;
    end

    return false;
end

-- Return the disaster so the manager can read it.
return disaster_chaos_invasion
