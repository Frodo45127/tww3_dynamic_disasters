--[[
    The Great Uprising disaster, By Frodo45127.

    This disaster consists in the execution of the plan proposed to the Lords of Decay by Seerlord Kritislik.

    Requirements:
        - Random chance (0.005)
        - +0.005 for each skaven faction that has been wiped out.
        - At least turn 100 (so the player has already "prepared").
    Effects:
        - Trigger/First Warning:
            - Message of warning about men-sized rats in the sewers.
            - Wait 10 turns for more info.
        - Stage 1:
            - Buff skaven sorceries.
            - Increase skaven corruption all over the world.
            - Spawn armies in estalia and tilea if they're not already destroyed/under skaven hands.
            - Disable diplomacy for skaven.
            - Make them full agressive for the rest of the campaign.
            - If no other disaster has triggered a Victory Condition yet, this will trigger one.
            - Wait 6 turns, or until tilea and estalia are destroyed.
        - Stage 2:
            - Buff skaven sorceries.
            - Increase skaven corruption all over the world.
            - Spawn armies in araby provinces if they're not already destroyed/under skaven hands.
            - Spawn armies in empire provinces (nuln) if they're not already destroyed/under skaven hands.
            - Wait 4 turns, or until araby are destroyed.
        - Stage 3:
            - Buff skaven sorceries.
            - Increase skaven corruption all over the world.
            - Damage lustrian settlements? Meteorites?
            - If skaven are still alive, trigger the invasion of Lustria.
            - Spawn armies near Itza, Tlaxtlan and Xlanhuapec.
            - Wait 5 turns.
        - Stage 3.5:
            - Spawn even more armies in lustria.
        - Stage 4:
            - Buff skaven sorceries.
            - Increase skaven corruption all over the world.
            - Damage lustrian settlements? Meteorites?
            - If skaven are still alive, trigger the invasion of Karak Kadrin, Karak Azul, Barak Varr, Karak Hirn, Zhufbar and Karak 8 Peaks (check clans attacking in the endtimes).
            - Wait 10 turns.
        - Stage 5:
            - Buff skaven sorceries.
            - Increase skaven corruption all over the world.
            - Damage lustrian settlements? Meteorites?
            - If skaven are still alive, trigger the invasion of Karaz-a-Karak.


        - Finish:
            - All lizard factions destroyed.

    MAYBE:
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
        min_turn = 130,                     -- Minimum turn required for the disaster to trigger.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        campaigns = {                       -- Campaigns this disaster works on.
            "main_warhammer",
        },

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
        stage_1_warning_event_key = "fro_dyn_dis_great_uprising_stage_1_warning",
        stage_1_event_key = "fro_dyn_dis_great_uprising_stage_1_trigger",
        stage_2_event_key = "fro_dyn_dis_great_uprising_stage_2_trigger",
        stage_3_event_key = "fro_dyn_dis_great_uprising_stage_3_trigger",
        stage_4_event_key = "fro_dyn_dis_great_uprising_stage_4_trigger",
        stage_5_event_key = "fro_dyn_dis_great_uprising_stage_5_trigger",
        finish_before_stage_1_event_key = "fro_dyn_dis_great_uprising_finish_before_stage_1",
        finish_event_key = "fro_dyn_dis_great_uprising_finish",
        effects_global_key = "fro_dyn_dis_great_uprising_global_effects",
        attacker_buffs_key = "fro_dyn_dis_great_uprising_attacker_buffs",
        ai_personality = "fro_dyn_dis_wh3_combi_skaven_endgame",
    }
}

-- List of skaven factions that will participate in the uprising.
local skaven_factions = {

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
}

-- Regions to be invaded in stage 1.
local regions_stage_1 = {

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
}

-- Regions to be invaded in stage 2, empire.
local regions_stage_2_empire = {

    -- The Empire (random cities, this invasion must be smaller than the rest).
    "wh3_main_combi_region_wissenburg",
    "wh3_main_combi_region_ubersreik",
    "wh3_main_combi_region_middenheim",
}

-- Regions to be invaded in stage 2, araby.
local regions_stage_2_araby = {

    -- Araby
    "wh3_main_combi_region_al_haikk",
    "wh3_main_combi_region_copher",
    "wh3_main_combi_region_fyrus",
}

-- Regions to be invaded in stage 2, cathay.
local regions_stage_2_cathay = {

    -- Cathay. Mainly an Eshin invasion.
    "wh3_main_combi_region_xing_po",
    "wh3_main_combi_region_kunlan",
    "wh3_main_combi_region_jade_wind_mountain",
    "wh3_main_combi_region_village_of_the_moon",
    "wh3_main_combi_region_tai_tzu",
    "wh3_main_combi_region_shrine_of_the_alchemist",

}

-- Regions to be invaded in stage 3.
local regions_stage_3 = {

    -- Lustria
    "wh3_main_combi_region_xlanhuapec",
    "wh3_main_combi_region_itza",
    "wh3_main_combi_region_tlaxtlan",
}

-- Regions to be invaded in stage 4.
local regions_stage_4 = {

    -- Karaz Ankor
    "wh3_main_combi_region_karak_kadrin",
    "wh3_main_combi_region_karak_eight_peaks",
    "wh3_main_combi_region_karak_azul",
    "wh3_main_combi_region_karak_hirn",
    "wh3_main_combi_region_barak_varr",
    "wh3_main_combi_region_zhufbar",
}

-- Regions to be invaded in stage 5.
local regions_stage_5 = {

    -- Final battle of the Karaz Ankor.
    "wh3_main_combi_region_karaz_a_karak",
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
                    dynamic_disasters:execute_payload(self.settings.finish_before_stage_1_event_key, nil, 0);
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
                    dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
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
                    dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
                    self:trigger_end_disaster();
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
                    dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
                    self:trigger_end_disaster();
                else
                    self:trigger_stage_4();
                end
                core:remove_listener("GreatUprisingStage4")
            end,
            true
        );

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
                    dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
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
                    for _, faction_key in pairs(skaven_factions) do
                        local faction = cm:get_faction(faction_key);
                        self:declare_war_for_owners_and_neightbours(faction, regions_stage_3);
                    end
                end
                core:remove_listener("GreatUprisingStage3Reinforcements")
            end,
            true
        );
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
                    dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
                    self:trigger_end_disaster();
                else

                    local region = cm:get_region(regions_stage_5[1]);
                    local region_owner = region:owning_faction();

                    -- Stage 5 should only trigger if Karaz-a-Karak belongs to the dwarfs.
                    if region_owner:is_null_interface() == false and region_owner:subculture() == "wh_main_sc_dwf_dwarfs" then
                        self:trigger_stage_5();
                    end
                end
                core:remove_listener("GreatUprisingStage5")
            end,
            true
        );
    end

    if self.settings.status == STATUS_STAGE_4 or self.settings.status == STATUS_STAGE_5 then

        -- This ends the disaster once all rats are dead.
        core:add_listener(
            "GreatUprisingEnd",
            "WorldStartRound",
            function()
                return self:check_end_disaster_conditions()
            end,

            -- Once every skaven is dead, end it.
            function()
                dynamic_disasters:execute_payload(self.settings.finish_event_key, nil, 0);
                self:trigger_end_disaster();
                core:remove_listener("GreatUprisingEnd")
            end,
            true
        );
    end
end

-- Function to trigger the disaster.
function disaster_the_great_uprising:trigger()
    out("Frodo45127: Starting disaster: " .. self.name);

    -- Recalculate the delay to trigger this.
    self.settings.stage_1_delay = math.random(6, 10);
    dynamic_disasters:execute_payload(self.settings.stage_1_warning_event_key, nil, 0);

    -- Initialize listeners.
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger the first stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_1()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    self.settings.stage_2_delay = math.random(6, 10);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    dynamic_disasters:execute_payload(self.settings.stage_1_event_key, self.settings.effects_global_key, self.settings.stage_2_delay);

    -- Spawn a few skryre armies in estalia, tilea and sartosa. Enough so they're able to expand next.
    -- Also, declare war on all neightbours to ensure war continue and they don't just sit there or get relocated.
    local faction_key = "wh2_main_skv_clan_skryre";
    for _, region_key in pairs(regions_stage_1) do
        local faction = cm:get_faction(faction_key);
        local region = cm:get_region(region_key);

        if not faction == false and not region == false then
            endgame:declare_war_on_adjacent_region_owners(faction, region)
        end

        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(1.5 * self.settings.difficulty_mod), self.name)
    end

    -- Make sure every attacker is at peace with each other.
    for _, src_faction_key in pairs(skaven_factions) do
        for _, dest_faction_key in pairs(skaven_factions) do
            if src_faction_key ~= dest_faction_key then
                cm:force_make_peace(src_faction_key, dest_faction_key);
            end
        end

        -- Also, make sure they're added to the victory conditions.
        table.insert(self.objectives[1].conditions, "faction " .. src_faction_key)
    end

    -- Apply the relevant war declarations against the player and CAI changes.
    endgame:no_peace_no_confederation_only_war(faction_key)
    cm:force_change_cai_faction_personality(faction_key, self.settings.ai_personality)

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_2_delay);

    -- Advance status to stage 1.
    self:set_status(STATUS_STAGE_1);
end

-- Function to trigger the second stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_2()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    self.settings.stage_3_delay = math.random(4, 7);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")

    -- At this stage, we setup the victory conditions, if needed.
    if dynamic_disasters.settings.victory_condition_triggered == false then
        dynamic_disasters:add_victory_condition(self.settings.stage_2_event_key, self.objectives, nil, nil)
        local human_factions = cm:get_human_factions()
        for i = 1, #human_factions do
            cm:apply_effect_bundle(self.settings.effects_global_key, human_factions[i], self.settings.stage_3_delay)
        end
    else
        dynamic_disasters:execute_payload(self.settings.stage_2_event_key, self.settings.effects_global_key, self.settings.stage_3_delay);
    end

    local factions_empire_and_araby = {
        "wh3_main_skv_clan_carrion",        -- Clan Carrion
        "wh3_main_skv_clan_krizzor",        -- Clan Krizzor
        "wh3_main_skv_clan_morbidus",       -- Clan Morbidus
        "wh2_main_skv_clan_septik",         -- Clan Septik
        "wh2_dlc15_skv_clan_volkn",         -- Clan Volkn
    }

    local factions_cathay = {
        "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
    }

    -- Spawn a few armies in the Empire, the northern coast of Araby and Cathay.
    for _, region_key in pairs(regions_stage_2_empire) do
        local faction_key = factions_empire_and_araby[math.random(1, #factions_empire_and_araby)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(1.5 * self.settings.difficulty_mod), self.name)
    end

    for _, region_key in pairs(regions_stage_2_araby) do
        local faction_key = factions_empire_and_araby[math.random(1, #factions_empire_and_araby)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(2 * self.settings.difficulty_mod), self.name)
    end

    for _, region_key in pairs(regions_stage_2_cathay) do
        dynamic_disasters:create_scenario_force(factions_cathay[1], region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(2 * self.settings.difficulty_mod), self.name)
    end

    -- From this stage, we force all skaven on the map to declare war on everyone a single faction faces.
    -- This includes owners of the attacked region, and owners of nearby regions.
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false then
            self:declare_war_for_owners_and_neightbours(faction, regions_stage_2_empire);
            self:declare_war_for_owners_and_neightbours(faction, regions_stage_2_araby);
            self:declare_war_for_owners_and_neightbours(faction, regions_stage_2_cathay);

            -- Just in case, force war with no peace on the player.
            endgame:no_peace_no_confederation_only_war(faction_key)

            -- Apply the relevant buffs and CAI changes.
            cm:force_change_cai_faction_personality(faction_key, self.settings.ai_personality)
        end
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_3_delay);

    -- Advance status to stage 2.
    self:set_status(STATUS_STAGE_2);
end

-- Function to trigger the third stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_3()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    self.settings.stage_4_delay = math.random(4, 6);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    dynamic_disasters:execute_payload(self.settings.stage_3_event_key, self.settings.effects_global_key, self.settings.stage_4_delay);

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
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        self:declare_war_for_owners_and_neightbours(faction, regions_stage_3);
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_4_delay);

    -- Advance status to stage 3.
    self:set_status(STATUS_STAGE_3);
end

-- Function to trigger the fourth stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_4()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    self.settings.stage_5_delay = math.random(6, 10);
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    dynamic_disasters:execute_payload(self.settings.stage_4_event_key, self.settings.effects_global_key, self.settings.stage_5_delay);

    local factions = {

        -- Major factions
        "wh2_main_skv_clan_mors",           -- Clan Mors (Queek)
        "wh2_main_skv_clan_eshin",          -- Clan Eshin (Snikch)
        "wh2_main_skv_clan_moulder",        -- Clan Moulder (Throt)

        -- Minor factions
        "wh2_dlc15_skv_clan_ferrik",        -- Clan Ferrik
    }

    -- Spawn a few armies along the Karak Ankor.
    for _, region_key in pairs(regions_stage_4) do
        local faction_key = factions[math.random(1, #factions)];
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(2 * self.settings.difficulty_mod), self.name)
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        self:declare_war_for_owners_and_neightbours(faction, regions_stage_4);
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.stage_5_delay);

    -- Advance status to stage 4.
    self:set_status(STATUS_STAGE_4);
end

-- Function to trigger the fifth stage of the Great Uprising.
function disaster_the_great_uprising:trigger_stage_5()

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
    dynamic_disasters:execute_payload(self.settings.stage_5_event_key, self.settings.effects_global_key, self.settings.invasion_over_delay);

    -- Spawn a few armies in Karaz-a-Karak.
    for _, region_key in pairs(regions_stage_5) do
        local faction_key = "wh2_main_skv_clan_mors";
        dynamic_disasters:create_scenario_force(faction_key, region_key, self.settings.army_template, self.settings.base_army_unit_count, true, math.ceil(2 * self.settings.difficulty_mod), self.name)
    end

    -- Force war against every skaven faction for each faction the skaven attack.
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        self:declare_war_for_owners_and_neightbours(faction, regions_stage_4);
    end

    -- Trigger the effect about Morrslieb.
    self:morrslieb_gaze_is_upon_us(self.settings.invasion_over_delay);

    -- Advance status to stage 5.
    self:set_status(STATUS_STAGE_5);
end

-- Function to declare war to owners of a region and all neightbours.
function disaster_the_great_uprising:declare_war_for_owners_and_neightbours(faction, regions)
    if not faction == false then
        for _, region_key in pairs(regions) do
            local region = cm:get_region(region_key);
            local region_owner = region:owning_faction()

            if not region == false then
                endgame:declare_war_on_adjacent_region_owners(faction, region)

                if region_owner:is_null_interface() == false and region_owner:subculture() ~= "wh2_main_sc_skv_skaven" and region_owner:name() ~= "rebels" and not faction:at_war_with(region_owner) then
                    cm:force_declare_war(faction:name(), region_owner:name(), false, true)
                end
            end
        end
    end
end

-- Function to apply the Morrslieb effects to all factions.
function disaster_the_great_uprising:morrslieb_gaze_is_upon_us(duration)
    local faction_list = cm:model():world():faction_list()
    local province_list = cm:model():world():province_list();

    -- Apply the corruption effects to all alive factions, except humans.
    -- Humans get this effect via payload with effect.
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)

        if not faction:is_dead() and faction:is_human() == false then
            cm:apply_effect_bundle(self.settings.effects_global_key, faction:name(), duration)
        end
    end

    -- Apply the Storms of Magic to all provinces.
    for i = 0, province_list:num_items() - 1 do
        local province = province_list:item_at(i);
        local chance = math.random();
        if chance > 0.5 then
            cm:force_winds_of_magic_change(province:key(), "wom_strength_5");
        end
    end;

    -- Apply attackers buffs to all alive skaven factions.
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        if not faction == false then

            -- Just in case, force war with no peace on the player.
            endgame:no_peace_no_confederation_only_war(faction_key)

            -- Apply the relevant buffs and CAI changes.
            cm:apply_effect_bundle(self.settings.attacker_buffs_key, faction_key, duration);
        end

    end
end

-- Function to trigger cleanup stuff after the invasion is over.
function disaster_the_great_uprising:trigger_end_disaster()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering end invasion.");
    dynamic_disasters:finish_disaster(self);
end

--- Function to check if the disaster custom conditions are valid and can be trigger.
---@return boolean If the disaster will be triggered or not.
function disaster_the_great_uprising:check_start_disaster_conditions()
    local base_chance = 0.005;
    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and faction:is_dead() then
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
function disaster_the_great_uprising:check_end_disaster_conditions()
    local all_attackers_dead = true;

    for _, faction_key in pairs(skaven_factions) do
        local faction = cm:get_faction(faction_key);
        if faction ~= false and not faction:is_dead() then
            all_attackers_dead = false;
        end
    end

    return all_attackers_dead;
end

return disaster_the_great_uprising
