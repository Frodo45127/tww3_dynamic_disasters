--[[
    The Great Uprising/The Great Ascendancy/The Vermintide disaster, By Frodo45127.

    This disaster consists in the execution of the plan proposed to the Lords of Decay by Seerlord Kritislik.

    Classified as Endgame, can trigger final mission. Supports debug mode.

    Requirements:
        - Random chance: 0.25% (1/400 turns).
        - +0.25% for each Skaven faction that has been wiped out (not confederated).
        - If the chaos invasion disaster has been triggered, chance of this disaster triggering increases by 10%.
        - At least turn 130 (so the player has already "prepared").
        - Clan Skryre must be not confederated (it's the one it starts the invasion).
    Effects:
        - Trigger/Early Warning:
            - Message about Morrslieb increasing in size.
            - Wait 6-10 turns for more info.
        - Stage 1:
            - If Clan Skryre has been confederated, end the disaster here.
            - If not:
                - Targets: Estalia, Tilea and Sartosa.
                - Spawn Clan Skyre armies on Estalia, Tilea and Sartosa.
                - Clan Skryre declares war on all non-skaven owners of said provinces and on all its neightbours.
                - Clan Skryre gets disabled diplomacy and full-retard AI.
                - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
                - Wait 6-10 turns for more info.
        - Stage 2:
            - Targets: The Empire, Araby's North Coast and Cathay's Hearthlands.
            - Spawn random skaven factions's armies on the Empire and Araby's North Coast.
            - If Eshin has not been confederated:
                - Spawn Clan Eshin armies on Cathay's Hearthlands.
            - All major and minot non-confederated skaven factions declare war on owner of attacked provinces and adjacent regions if not skaven.
            - All major and minot non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 4-7 turns for more info.
        - Stage 3:
            - Targets: Xlanhuapec, Itza and Tlaxtlan (Lustria).
            - Spawn Clans Pestilens and Skryre armies in Lustria.
            - All major and minot non-confederated skaven factions declare war on owner of attacked provinces and adjacent regions if not skaven.
            - All major and minot non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 4-6 turns for more info.
        - Stage 4:
            - Targets: Major settlments of the Karaz Ankor.
            - Spawn a mix of clans armies on settlements of the Karaz Ankor.
            - All major and minot non-confederated skaven factions declare war on owner of attacked provinces and adjacent regions if not skaven.
            - All major and minot non-confederated skaven factions gets disabled diplomacy and full-retard AI.
            - Trigger "The Green Shine of MorrsLieb" effect (50% Probability of Storm of Magic).
            - Wait 6-10 turns for more info.
        - Stage 5 (Optional):
            - Target: Karaz-a-Karak.
            - Clan Mors must be alive and not confederated.
            - Kazaz-a-Karak must be controlled by a dwarven faction.
            - Spawn a few Clan Mors armies in Karaz-a-Karak.
            - All major and minot non-confederated skaven factions declare war on owner of attacked provinces and adjacent regions if not skaven.
            - All major and minot non-confederated skaven factions gets disabled diplomacy and full-retard AI.
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

]]


-- Status list for this disaster.
local STATUS_TRIGGERED = 1;
local STATUS_STAGE_1 = 2;
local STATUS_STAGE_2 = 3;
local STATUS_STAGE_3 = 4;
local STATUS_STAGE_4 = 5;
local STATUS_STAGE_5 = 6;

-- Object representing the disaster.
disaster_the_great_uprising = {
    name = "the_great_uprising",

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
                "confederation_valid"
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
        min_turn = 130,                     -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).

        -- Disaster-specific data.
        army_template = {
            skaven = "lategame",
        },
        base_army_unit_count = 19,
        stage_1_delay = 1,
        stage_2_delay = 1,
        stage_3_delay = 1,
        stage_4_delay = 1,
        stage_5_delay = 1,
        invasion_over_delay = 10,


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

    stage_1_warning_event_key = "fro_dyn_dis_great_uprising_stage_1_warning",
    stage_1_warning_effect_key = "dyn_dis_the_great_uprising_early_warning",
    stage_1_event_key = "fro_dyn_dis_great_uprising_stage_1_trigger",
    stage_2_event_key = "fro_dyn_dis_great_uprising_stage_2_trigger",
    stage_3_event_key = "fro_dyn_dis_great_uprising_stage_3_trigger",
    stage_4_event_key = "fro_dyn_dis_great_uprising_stage_4_trigger",
    stage_5_event_key = "fro_dyn_dis_great_uprising_stage_5_trigger",
    finish_before_stage_1_event_key = "fro_dyn_dis_great_uprising_finish_before_stage_1",
    finish_event_key = "fro_dyn_dis_great_uprising_finish",
    endgame_mission_name = "the_great_ascendancy",
    effects_global_key = "fro_dyn_dis_great_uprising_global_effects",
    attacker_buffs_key = "fro_dyn_dis_great_uprising_attacker_buffs",
    ai_personality = "fro_dyn_dis_wh3_combi_skaven_endgame",
}

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_the_great_uprising:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- This triggers stage one of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage1",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, proceed with stage 1.
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_before_stage_1_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_1();
                end
                core:remove_listener("GreatUprisingStage1")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_1 then

        -- This triggers stage two of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage2",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, proceed with stage 2.
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_2();
                end
                core:remove_listener("GreatUprisingStage2")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_2 then

        -- This triggers stage three of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage3",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, proceed with stage 3.
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                else
                    self:trigger_stage_3();
                end
                core:remove_listener("GreatUprisingStage3")
            end,
            true
        );
    end

    -- TODO: Spawn reinforcements in lustria after a few turns.
    if self.settings.status == STATUS_STAGE_3 then

        -- This triggers stage four of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage4",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay + self.settings.stage_4_delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, proceed with stage 4.
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                else
                    self:trigger_stage_4();
                end
                core:remove_listener("GreatUprisingStage4")
            end,
            true
        );

        --[[
        -- This triggers stage three reinforcements if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage3Reinforcements",
            "WorldStartRound",
            function()

                -- Make sure there is at least one turn before the reinforcements arrive.
                local delay = math.floor(self.settings.stage_4_delay / 2);
                if delay < 1 then
                    delay = 1;
                end

                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay + delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, trigger the reinforcements
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                    self:trigger_end_disaster();
                else

                    local factions = {
                        "wh2_main_skv_clan_pestilens",      -- Clan Pestilens (Skrolk)
                        "wh2_main_skv_clan_skryre",         -- Clan Skryre (Ikit Claw)
                    }

                    -- Spawn a few armies in Lustria.
                    for _, region_key in pairs(regions_stage_3) do
                        local faction_key = factions[math.random(1, #factions)];
                        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(2.5 * self.settings.difficulty_mod), self.name)
                    end

                    -- Force war against every skaven faction for each faction the skaven attack.
                    for _, faction_key in pairs(factions) do
                        local faction = cm:get_faction(faction_key);
                        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, regions_stage_3);
                    end
                end
                core:remove_listener("GreatUprisingStage3Reinforcements")
            end,
            true
        );
        ]]--
    end

    if self.settings.status == STATUS_STAGE_4 then

        -- This triggers stage five of the disaster if the disaster hasn't been cancelled.
        core:add_listener(
            "GreatUprisingStage5",
            "WorldStartRound",
            function()
                if cm:turn_number() == self.settings.last_triggered_turn + self.settings.stage_1_delay + self.settings.stage_2_delay + self.settings.stage_3_delay + self.settings.stage_4_delay + self.settings.stage_5_delay then
                    return true
                end
                return false;
            end,

            -- If there are skaven alive, proceed with stage 5.
            function()
                if self:check_end_disaster_conditions() == true then
                    dynamic_disasters:execute_payload(self.finish_event_key, nil, 0, nil);
                else
                    self:trigger_stage_5();
                end
                core:remove_listener("GreatUprisingStage5")
            end,
            true
        );
    end

    -- No need to have a specific listener to end the disaster after no more stages can be triggered, as that's controlled by a mission.
end

-- Function to trigger the disaster.
function disaster_the_great_uprising:trigger()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay to trigger this.
    if dynamic_disasters.settings.debug == true then
        self.settings.stage_1_delay = 1;
    else
        self.settings.stage_1_delay = math.random(6, 10);
    end

    -- Initialize listeners.
    dynamic_disasters:execute_payload(self.stage_1_warning_event_key, self.stage_1_warning_effect_key, 0, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_1()
    if dynamic_disasters.settings.debug == true then
        self.settings.stage_2_delay = 1;
    else
        self.settings.stage_2_delay = math.random(6, 10);
    end

    -- Spawn a few Skryre armies in Estalia, Tilea and Sartosa. Enough so they're able to expand next.
    local army_count = math.floor(1.5 * self.settings.difficulty_mod)
    for _, faction_key in pairs(self.settings.factions_stage_1) do
        for _, region_key in pairs(self.regions_stage_1) do
            dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count, self.name)
        end

        -- Apply the relevant CAI changes only to Clan Skryre and declare the appropiate wars.
        local faction = cm:get_faction(faction_key);
        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_1, true, {"wh2_main_sc_skv_skaven"})
    end

    -- Make sure every attacker is at peace with each other.
    dynamic_disasters:force_peace_between_factions(self.settings.factions, false);

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_2_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:execute_payload(self.stage_1_event_key, self.effects_global_key, self.settings.stage_2_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_2()

    if dynamic_disasters.settings.debug == true then
        self.settings.stage_3_delay = 1;
    else
        self.settings.stage_3_delay = math.random(4, 7);
    end

    -- Spawn a few armies in the Empire, the northern coast of Araby and Cathay.
    local army_count_empire = math.ceil(1.5 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_2_empire) do
        local faction_key = self.settings.factions_stage_2_empire_and_araby[math.random(1, #self.settings.factions_stage_2_empire_and_araby)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count_empire, self.name)
    end

    local army_count_araby = math.ceil(2 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_2_araby) do
        local faction_key = self.settings.factions_stage_2_empire_and_araby[math.random(1, #self.settings.factions_stage_2_empire_and_araby)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count_araby, self.name)
    end

    -- The Attack on Cathay depends on Eshin being available to spawn.
    if #self.settings.factions_stage_2_cathay > 0 then
        local army_count_cathay = math.ceil(2 * self.settings.difficulty_mod)
        for _, region_key in pairs(self.regions_stage_2_cathay) do
            local faction_key = self.settings.factions_stage_2_cathay[math.random(1, #self.settings.factions_stage_2_cathay)];
            dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count_cathay, self.name)
        end
    end

    -- From this stage, we force all skaven on the map to declare war on everyone a single faction faces.
    -- This includes owners of the attacked region, and owners of nearby regions. Even if its Skaven.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
        endgame:no_peace_no_confederation_only_war(faction_key)
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_2_empire, true, {"wh2_main_sc_skv_skaven"});
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_2_araby, true, {"wh2_main_sc_skv_skaven"});
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_2_cathay, true, {"wh2_main_sc_skv_skaven"});
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_3_delay);

    -- Also, make sure they're added to the victory conditions.
    for _, faction_key in pairs(self.settings.factions) do
        table.insert(self.objectives[1].conditions, "faction " .. faction_key)
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:add_mission(self.objectives, true, self.name, self.endgame_mission_name, self.stage_2_event_key, nil, self.settings.factions[1], function () self:trigger_end_disaster() end, true)
    dynamic_disasters:execute_payload(self.stage_2_event_key, self.effects_global_key, self.settings.stage_3_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_2);
end

-- Function to trigger the third stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_3()

    if dynamic_disasters.settings.debug == true then
        self.settings.stage_4_delay = 1;
    else
        self.settings.stage_4_delay = math.random(4, 6);
    end

    -- Spawn a few armies in Lustria.
    local army_count = math.ceil(2.5 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_3) do
        local faction_key = self.settings.factions_stage_3_lustria[math.random(1, #self.settings.factions_stage_3_lustria)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count, self.name)
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_3, true, {"wh2_main_sc_skv_skaven"});
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_4_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:execute_payload(self.stage_3_event_key, self.effects_global_key, self.settings.stage_4_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_3);
end

-- Function to trigger the fourth stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_4()

    if dynamic_disasters.settings.debug == true then
        self.settings.stage_5_delay = 1;
    else
        self.settings.stage_5_delay = math.random(6, 10);
    end

    -- Spawn a few armies along the Karak Ankor.
    local army_count = math.ceil(2 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_4) do
        local faction_key = self.settings.factions_stage_4_karaz_ankor[math.random(1, #self.settings.factions_stage_4_karaz_ankor)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count, self.name)
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_4, true, {"wh2_main_sc_skv_skaven"});
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_5_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:execute_payload(self.stage_4_event_key, self.effects_global_key, self.settings.stage_5_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_4);
end

-- Function to trigger the fifth stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_5()

    -- Spawn a few armies in Karaz-a-Karak.
    local army_count = math.ceil(2 * self.settings.difficulty_mod)
    for _, region_key in pairs(self.regions_stage_5) do
        local faction_key = self.settings.factions_stage_5_karaz_a_karak[math.random(1, #self.settings.factions_stage_5_karaz_a_karak)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, false, army_count, self.name)
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        dynamic_disasters:declare_war_for_owners_and_neightbours(faction, self.regions_stage_5, true, {"wh2_main_sc_skv_skaven"});
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.invasion_over_delay);

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    dynamic_disasters:execute_payload(self.stage_5_event_key, self.effects_global_key, self.settings.invasion_over_delay, nil);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    self:set_status(STATUS_STAGE_5);
end

-- Function to apply the Morrslieb effects to all factions.
---@param duration integer #Duration of the effects, in turns.
function disaster_the_great_uprising:morrslieb_gaze_is_upon_us(duration)
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
    local base_chance = self.settings.status / 10;
    for i = 0, province_list:num_items() - 1 do
        local province = province_list:item_at(i);
        local chance = math.random();
        if chance > base_chance then
            cm:force_winds_of_magic_change(province:key(), "wom_strength_5");
        end
    end;

    -- Apply attackers buffs to all alive skaven factions.
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction:is_dead() == false then
            cm:apply_effect_bundle(self.attacker_buffs_key, faction_key, duration);
        end
    end
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_the_great_uprising:trigger_end_disaster()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
        dynamic_disasters:finish_disaster(self);
    end
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_the_great_uprising:check_start_disaster_conditions()

    -- Update the potential factions removing the confederated ones.
    self.settings.factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions);

    -- Do not start if we don't have attackers for stage 1.
    if #self.settings.factions == 0 then
        return false;
    end

    -- Check that Clan Skryre is alive or dead and non-confederated. It's needed to kickstart the disaster.
    local is_skryre_available = false;
    for _, faction_key in pairs(self.settings.factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false and faction:is_null_interface() == false and faction_key == "wh2_main_skv_clan_skryre" and faction:was_confederated() == false then
            is_skryre_available = true;
            break
        end
    end

    -- Do not start if Clan Skryre is not available to use.
    if is_skryre_available == false then
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

    if math.random() < base_chance then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_the_great_uprising:check_end_disaster_conditions()

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

    -- If all skaven factions are dead, end the disaster. If not, check depending on the state we're about to trigger.
    if all_attackers_dead == true then
        return true;
    end

    -- If we haven't triggered the first stage, just check if Skryre is dead. If so, we end the disaster here.
    if self.settings.status == STATUS_TRIGGERED then
        self.settings.factions_stage_1 = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_1);
        local all_attackers_unavailable_stage_1 = true;

        if #self.settings.factions_stage_1 > 0 then
            for _, faction_key in pairs(self.settings.factions_stage_1) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
                    all_attackers_unavailable_stage_1 = false;
                end
            end
        end

        return all_attackers_unavailable_stage_1;
    end

    -- If we're about to trigger Stage 2, make sure we have minor factions to do it. Otherwise, end the invasion here.
    if self.settings.status == STATUS_STAGE_1 then

        -- Update the list of available factions. Ignore cathay for ending the disaster as it's optional.
        self.settings.factions_stage_2_empire_and_araby = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_2_empire_and_araby);
        self.settings.factions_stage_2_cathay = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_2_cathay);
        local all_attackers_unavailable_stage_2 = true;

        if #self.settings.factions_stage_2_empire_and_araby > 0 then
            for _, faction_key in pairs(self.settings.factions_stage_2_empire_and_araby) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
                    all_attackers_unavailable_stage_2 = false;
                end
            end
        end

        return all_attackers_unavailable_stage_2;
    end

    -- If we're about to trigger Stage 3, make sure either Skryre or Pestilens are still alive.
    if self.settings.status == STATUS_STAGE_2 then
        self.settings.factions_stage_3_lustria = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_3_lustria);
        local all_attackers_unavailable_stage_3 = true;

        if #self.settings.factions_stage_3_lustria > 0 then
            for _, faction_key in pairs(self.settings.factions_stage_3_lustria) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
                    all_attackers_unavailable_stage_3 = false;
                end
            end
        end

        return all_attackers_unavailable_stage_3;
    end

    -- If we're about to trigger Stage 4, make sure we have factions for it.
    if self.settings.status == STATUS_STAGE_3 then
        self.settings.factions_stage_4_karaz_ankor = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_4_karaz_ankor);
        local all_attackers_unavailable_stage_4 = true;

        if #self.settings.factions_stage_4_karaz_ankor > 0 then
            for _, faction_key in pairs(self.settings.factions_stage_4_karaz_ankor) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
                    all_attackers_unavailable_stage_4 = false;
                end
            end
        end

        return all_attackers_unavailable_stage_4;
    end

    -- If we're about to trigger Stage 5, make sure Clan Mors is still alive.
    if self.settings.status == STATUS_STAGE_4 then
        self.settings.factions_stage_5_karaz_a_karak = dynamic_disasters:remove_confederated_factions_from_list(self.settings.factions_stage_5_karaz_a_karak);
        local all_attackers_unavailable_stage_5 = true;

        if #self.settings.factions_stage_5_karaz_a_karak > 0 then
            for _, faction_key in pairs(self.settings.factions_stage_5_karaz_a_karak) do
                local faction = cm:get_faction(faction_key);
                if not faction == false and faction:is_null_interface() == false and not faction:is_dead() then
                    all_attackers_unavailable_stage_5 = false;
                end
            end
        end

        if all_attackers_unavailable_stage_5 == true then
            return true
        end

        -- Also check Karaz-a-Karak belongs to the Dawi.
        local region = cm:get_region(self.regions_stage_5[1]);
        if not region == false and region:is_null_interface() then
            local region_owner = region:owning_faction();

            -- Stage 5 should only trigger if Karaz-a-Karak belongs to the dwarfs.
            if not region_owner == false and region_owner:is_null_interface() == false and region_owner:subculture() == "wh_main_sc_dwf_dwarfs" then
                return false
            end

        end

        -- If we reached this, we got no more to do.
        return true;
    end

    return false;
end

return disaster_the_great_uprising
