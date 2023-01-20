--[[
    Realm Divided disaster, By Frodo45127.

    This disaster consists on a "Realm Divided" situation, similar to the one in Shogun 2. Once you take half of Cathay, every other cathayan faction will declare war on you.

    Supports debug mode. ONLY FOR SINGLEPLAYER.

    Requirements:
        - Player must own 45% of Cathay (20 provinces) before turn 35.
    Effects:
        - Trigger:
            - Trigger "Realm Divided" incident.
            - Ally every other Cathayan faction together.
            - Force every other Cathayan faction to declare war on you (except if they're human).
            - Spawn armies in their capitals, and buff them for 10 turns.
            - When a faction is killed, trigger a dilemma about their leaders coming to your service, which confederates them.

    IDEAS (Because thinking is free, but can get decided on how to do all this stuff):
        This disaster consists on a massive rebelion on Cathay. It can take multiple routes:
            - For northern provinces:
                - If Zhao Ming is still alive, you'll get a dilemma asking to side with him, with the Caravan Lords or with Wei-Jin.
                    - If you go with Zhao Ming, you get an alliance with him to take down the Caravan Lords and Wei-Jin, with a confederation possibility at the end.
                    - If you go with the Caravan Lords, you get an alliance with them to take down the Zhao Ming and Wei-Jin (with buffs to caravans?).
                    - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Zhao Ming and the Caravan Lords, and increased bonus from the compass.
            - For western provinces:
                - if Miao Ying is still alive, you'll get a dilemma asking to side with her, with the Caravan Lords or with Wei-Jin.
                    - If you go with Miao Ying, you get an alliance with him to take down the Caravan Lords and Wei-Jin, with a confederation possibility at the end.
                    - If you go with the Caravan Lords, you get an alliance with them to take down the Miao Ying and Wei-Jin (with buffs to caravans?).
                    - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Miao Ying and the Caravan Lords, and increased bonus from the compass.
            - Civil war will broke out.
            - Ends when the player anahilates all other non-allied cathayan factions.
            - Rewards:
                - For northern provinces:
                    - Zhao Ming route:
                        - Global buffs to melee infantry.
                    - Wei-Jin route:
                        - Buff buildup of the compass.
                        - Reduce drop progrees of the compass.
                        - Reduce time to re-use the compass.
                    - Caravan Lords route:
                        - Increase cap to allied recruitment by 100%.
                        - Increase load capacity of caravans by 50%.
                        - Increase value of caravans by 50%.
                        - Increase allieanece buildup by 50%.
                        - Increase Trade Tarifs by 25%.
                        - If possible:
                            - Add bretonians to the avaliable units for caravans.
                            - Add norscan raiders to the available units for caravans (Why the fuck not?).
                            - Unlock more nodes to travel.
                    - Lonesome route:

                        - If you go with the Caravan Lords, you get an alliance with them to take down the Zhao Ming and Wei-Jin (with buffs to caravans?).
                        - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Zhao Ming and the Caravan Lords, and increased bonus from the compass.
                - For western provinces:
                    - if Miao Ying is still alive, you'll get a dilemma asking to side with her, with the Caravan Lords or with Wei-Jin.
                        - If you go with Miao Ying, you get an alliance with him to take down the Caravan Lords and Wei-Jin, with a confederation possibility at the end.
                        - If you go with the Caravan Lords, you get an alliance with them to take down the Miao Ying and Wei-Jin (with buffs to caravans?).
                        - If you go with Wei-Jin, you get an alliance with them if they're still alive to take down the Miao Ying and the Caravan Lords, and increased bonus from the compass.

        Caravan lord armies will consist on a mix of Cathayan, Ogre, Kislevitan, Empire and Bretonian units.
        Bonus for with for each alliance:
            - Miao Ying/Zhao Ming: Confederation. Gains the faction buffs of the other one.
            - Wei-Jin: Gains brutal anti-corruption bonuses (useful for the Endtimes and Great Ascendancy disasters) and faster turn times/filling for the compass (maybe add bonuses).
            - Caravan Lords: Gains a lot more money. All caravan armies gain some units. Caravan lords gains buffs. Better relations with human/ogre factions. If multiple caravans can be enabled, enable them. If more nodes can be added, add them.

        Conditions to trigger:
            - Player must be a Cathayan faction.
            - Player must control at least half of Cathay.
            - From Cathay, only the two playable factions must be alive.
]]

-- Status list for this disaster.
local STATUS_TRIGGERED = 1;

-- Object representing the disaster.
disaster_realm_divided = {
    name = "realm_divided",

    -- Values for categorizing the disaster.
    is_global = false;
    allowed_for_sc = { "wh3_main_sc_cth_cathay" },
    denied_for_sc = {},
    campaigns = {                       -- Campaigns this disaster works on.
        "main_warhammer",
    },

    -- If the disaster is an endgame scenario, define here the objectives to pass to the function that creates the victory condition.
    objectives = {
        {
            type = "CONTROL_N_REGIONS_FROM",
            conditions = {},
            payloads = {
                "money 10000"
            }
        },
        {
            type = "DESTROY_FACTION",
            conditions = {
                "confederation_valid",
                "vassalization_valid"
            },
            payloads = {
                "money 20000"
            }
        },
    },

    -- Settings of the disaster that will be stored in a save.
    settings = {},
    default_settings = {

        -- Common data for all disasters.
        enabled = true,                    -- If the disaster is enabled or not.
        started = false,                    -- If the disaster has been started.
        finished = false,                   -- If the disaster has been finished.
        repeteable = false,                 -- If the disaster can be repeated.
        is_endgame = false,                 -- If the disaster is an endgame.
        revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
        enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
        min_turn = 0,                       -- Minimum turn required for the disaster to trigger.
        max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
        status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
        last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
        last_finished_turn = 0,             -- Turn when the disaster was last finished.
        wait_turns_between_repeats = 5,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
        difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
        mct_settings = {},                  -- Extra settings this disaster may pull from MCT.
        incompatible_disasters = {},        -- List of disasters this disaster cannot run along with. To not trigger 2 disasters affecting the same faction at the same time.

        -- Disaster-specific data.
        cathayan_factions = {},
        cathayan_factions_to_delete = {},
    },

    unit_count = 19,
    army_template = {
        cathay = "earlygame"
    },

    catay_regions = {
        "wh3_main_combi_region_nan_gau",
        "wh3_main_combi_region_nan_li",

        "wh3_main_combi_region_terracotta_graveyard",
        "wh3_main_combi_region_po_mei",
        "wh3_main_combi_region_weng_chang",

        "wh3_main_combi_region_dragon_gate",
        "wh3_main_combi_region_snake_gate",
        "wh3_main_combi_region_turtle_gate",

        "wh3_main_combi_region_wei_jin",
        "wh3_main_combi_region_ming_zhu",
        "wh3_main_combi_region_city_of_the_shugengan",

        "wh3_main_combi_region_haichai",
        "wh3_main_combi_region_zhizhu",

        "wh3_main_combi_region_kunlan",
        "wh3_main_combi_region_xing_po",
        "wh3_main_combi_region_village_of_the_moon",
        "wh3_main_combi_region_jade_wind_mountain",

        "wh3_main_combi_region_celestial_monastery",
        "wh3_main_combi_region_zhanshi",

        "wh3_main_combi_region_chimai",
        "wh3_main_combi_region_fu_chow",
        "wh3_main_combi_region_beichai",

        "wh3_main_combi_region_shrine_of_the_alchemist",
        "wh3_main_combi_region_shang_yang",
        "wh3_main_combi_region_tai_tzu",

        "wh3_main_combi_region_xen_wu",
        "wh3_main_combi_region_hanyu_port",
        "wh3_main_combi_region_qiang",

        "wh3_main_combi_region_shang_wu",
        "wh3_main_combi_region_bridge_of_heaven",
        "wh3_main_combi_region_shi_long",
        "wh3_main_combi_region_baleful_hills",

        "wh3_main_combi_region_nonchang",
        "wh3_main_combi_region_shiyamas_rest",

        "wh3_main_combi_region_li_temple",
        "wh3_main_combi_region_li_zhu",
        "wh3_main_combi_region_shi_wu",

        "wh3_main_combi_region_dai_cheng",
        "wh3_main_combi_region_tower_of_ashung",

        "wh3_main_combi_region_jungles_of_chian",

        "wh3_main_combi_region_bamboo_crossing",
        "wh3_main_combi_region_waili_village",

        "wh3_main_combi_region_fu_hung",
        "wh3_main_combi_region_temple_of_elemental_winds",
        "wh3_main_combi_region_village_of_the_tigermen",
    },

    realm_divided_incident_key = "dyn_dis_realm_divided_trigger",
    realm_divided_attacker_buffs = "dyn_dis_realm_divided_attacker_buffs",

    mission_name = "united_we_stand",
    miao_yin_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_miao_yin",
    zhao_ming_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_zhao_ming",
    generic_ai_personality = "dyn_dis_wh3_combi_cathay_realm_divided_generic",

    confederation_dilemma_key = "dyn_dis_realm_divided_confederation_dilemma"
}

--[[-------------------------------------------------------------------------------------------------------------

    Mandatory functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to set the status of the disaster, initializing the needed listeners in the process.
function disaster_realm_divided:set_status(status)
    self.settings.status = status;

    if self.settings.status == STATUS_TRIGGERED then

        -- Populate the list of cathayan factions that are still alive.
        self:generate_factions_list();

        out("Frodo45127: Cathayan factions left to confederate: " .. #self.settings.cathayan_factions .. ".")
        out("Frodo45127: Cathayan factions to confederate next turn: " .. #self.settings.cathayan_factions_to_delete .. ".")

        -- Listener for the confederation dilemma. It should trigger the turn after a faction is killed.
        core:remove_listener("RealmDividedConfederationOnFactionDead");
        core:add_listener(
            "RealmDividedConfederationOnFactionDead",
            "WorldStartRound",
            function()
                local should_finish = self:check_finish();

                for i = 1, #self.settings.cathayan_factions do
                    local faction = cm:get_faction(self.settings.cathayan_factions[i])

                    if not faction == false and faction:is_null_interface() == false and faction:is_dead() then
                        table.insert(self.settings.cathayan_factions_to_delete, i)
                    end
                end

                out("Frodo45127: Cathayan factions to process this turn: " .. #self.settings.cathayan_factions_to_delete .. ".")
                return #self.settings.cathayan_factions_to_delete > 0 or should_finish;
            end,
            function()

                -- If things got weird and we ran out of factions, finish.
                if self:check_finish() then
                    self:finish();

                -- Otherwise, trigger one dilemma for each faction to delete from the available list.
                else
                    for _, i in pairs(self.settings.cathayan_factions_to_delete) do
                        local faction = cm:get_faction(self.settings.cathayan_factions[i]);
                        local choices = {
                            {
                                form_confederation = faction:name(),
                            },
                            ""
                        };

                        local human_faction = cm:get_human_factions()[1];
                        dynamic_disasters:trigger_dilemma(cm:get_faction(human_faction), self.confederation_dilemma_key, choices, faction, nil, nil, nil, nil, nil)
                    end

                    -- Once done with dilemmas, remove the faction from the list in reverse.
                    reverse = {}
                    for i = #self.settings.cathayan_factions_to_delete, 1, -1 do
                        reverse[#reverse+1] = self.settings.cathayan_factions_to_delete[i]
                    end
                    self.settings.cathayan_factions_to_delete = reverse

                    for i = 1, #self.settings.cathayan_factions_to_delete do
                        local index = self.settings.cathayan_factions_to_delete[i]
                        table.remove(self.settings.cathayan_factions, index)
                    end

                    -- Cleanp the list of factions before continuing.
                    self.settings.cathayan_factions_to_delete = {};

                    -- Remove the listener and end the disaster if we ran out of factions to confederate.
                    if #self.settings.cathayan_factions == 0 then
                        self:finish();
                    end
                end
            end,
            true
        );
    end
end

-- Function to trigger the disaster. From here until the end of the disaster, everything is managed by the disaster itself.
function disaster_realm_divided:start()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering disaster.");

    -- Force all Cathayan factions to ally and declare war on you.
    local player_faction_key = cm:get_human_factions()[1];
    local faction_list = cm:model():world():faction_list()
    local factions = {};
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)

        -- Spawn armies for fations that are still alive and are not a player.
        if not faction == false and
            faction:is_null_interface() == false and
            faction:was_confederated() == false and
            faction:is_dead() == false and
            faction:subculture() == "wh3_main_sc_cth_cathay" and
            faction:name() ~= player_faction_key then

            local army_count = math.ceil(1 * self.settings.difficulty_mod);
            dynamic_disasters:create_scenario_force_with_backup_plan(faction:name(), nil, self.army_template, self.unit_count, false, army_count, self.name, nil, nil);

            -- Regardless of armies spawned, declare war and buff the AI.
            dynamic_disasters:no_peace_only_war(faction:name(), self.settings.enable_diplomacy);

            if faction:name() == "wh3_main_cth_the_northern_provinces" then
                cm:force_change_cai_faction_personality(faction:name(), self.miao_yin_ai_personality)
            elseif faction:name() == "wh3_main_cth_the_western_provinces" then
                cm:force_change_cai_faction_personality(faction:name(), self.zhao_ming_ai_personality)
            else
                cm:force_change_cai_faction_personality(faction:name(), self.generic_ai_personality)
            end

            cm:apply_effect_bundle(self.realm_divided_attacker_buffs, faction:name(), 10);
            table.insert(factions, faction:name())
        end
    end

    -- Prepare the mission/disaster data.
    table.insert(self.objectives[1].conditions, "total " .. #self.catay_regions)
    for i = 1, #self.catay_regions do
        table.insert(self.objectives[1].conditions, "region " .. self.catay_regions[i])
    end

    for _, faction_key in pairs(factions) do
        table.insert(self.objectives[2].conditions, "faction " .. faction_key)
    end

    -- Force an alliance between all cathayan factions against you.
    dynamic_disasters:force_peace_between_factions(factions, true);
    dynamic_disasters:add_mission(self.objectives, false, self.name, self.mission_name, self.realm_divided_incident_key, nil, factions[1], nil, true)
    dynamic_disasters:trigger_incident(self.realm_divided_incident_key, nil, nil, nil, nil, nil);
    self:set_status(STATUS_TRIGGERED);
end

-- Function to trigger cleanup stuff after the disaster is over.
function disaster_realm_divided:finish()
    if self.settings.started == true then
        out("Frodo45127: Disaster: " .. self.name .. ". Triggering end disaster.");
        core:remove_listener("RealmDividedConfederationOnFactionDead")
        dynamic_disasters:finish_disaster(self);
    end
end

-- Function to check if the disaster conditions are valid and can be trigger.
-- Checks for min turn are already done in the manager, so they're not needed here.
--
---@return boolean If the disaster will be triggered or not.
function disaster_realm_divided:check_start()

    -- This one is locked only for single-player, due to issues regarding triggering it if there are two cathayan players.
    if cm:is_multiplayer() then
        return false;
    end

    -- Debug mode support.
    if dynamic_disasters.settings.debug_2 == true then
        return true;
    end

    local regions_owned = 0;
    for _, region_key in pairs(self.catay_regions) do
        local region = cm:get_region(region_key);
        if not region == false and region:is_null_interface() == false and region:is_abandoned() == false then
            local region_owner = region:owning_faction()
            if not region_owner == false and region_owner:is_null_interface() == false and (region_owner:is_human() or (region_owner:is_vassal() and region_owner:master():is_human())) then
                regions_owned = regions_owned + 1;
            end
        end
    end

    -- If we own more than 45% of Cathay before turn 35, trigger this.
    if math.ceil(regions_owned * 100 / #self.catay_regions) >= 45 and cm:turn_number() <= 35 then
        return true;
    end

    return false;
end

--- Function to check if the conditions to declare the disaster as "finished" are fulfilled.
---@return boolean If the disaster will be finished or not.
function disaster_realm_divided:check_finish()

    -- Update the potential factions removing the confederated ones and check if we still have factions to use.
    self.settings.cathayan_factions = dynamic_disasters:remove_confederated_factions_from_list(self.settings.cathayan_factions);
    return #self.settings.cathayan_factions == 0 or not dynamic_disasters:is_any_faction_alive_from_list(self.settings.cathayan_factions);
end

--[[-------------------------------------------------------------------------------------------------------------

    Disaster-specific functions.

]]---------------------------------------------------------------------------------------------------------------

-- Function to initialize the list of cathayan factions to confederate with dilemma.
function disaster_realm_divided:generate_factions_list()
    self.settings.cathayan_factions = {};
    self.settings.cathayan_factions_to_delete = {};

    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if not faction == false and faction:is_null_interface() == false and
            faction:is_dead() == false and
            faction:was_confederated() == false and
            faction:is_human() == false and
            faction:can_be_human() == true and
            faction:subculture() == "wh3_main_sc_cth_cathay" then
            table.insert(self.settings.cathayan_factions, faction:name());
        end
    end
end

-- Return the disaster so the manager can read it.
return disaster_realm_divided
