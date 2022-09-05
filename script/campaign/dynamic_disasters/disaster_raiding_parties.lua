--[[
    Raiding Parties disaster, By Frodo45127.

    This disaster consists on limited coastal attacks by either Vampire Coast armies, Norscan or Dark Elven fleets.

    Supports debug mode.

    NOTE: This disaster can use the three factions, except the ones sharing subculture with the player.

    Requirements:
        - Random chance: 2% (1/50 turns).
        - +1% for each possible attacker faction that has been wiped out (not confederated).
        - At least turn 30 (so the player has a coast).
        - At least one of the potential attackers must be alive (you can end this disaster by killing them all).
        - At least 10 turns have passed since the last pirate raid.
    Effects:
        - Trigger/First Warning:
            - Message of warning about ships with black and tattered sails.
            - Wait 4-10 turns for more info.
        - Invasion:
            - Get some random coastal areas, weigthed a bit considering the provinces the player owns.
            - Pick one random faction and give them some armies on the coast nearby.
            - Invasion is canceled (storm event) if attacker's faction is wiped out before the invasion begins.
        - Finish:
            - Once everything is spawned, it's up to the AI to attack.

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
        army_template = {},
        base_army_unit_count = 19,

        faction = "",
        subculture = "",
        potential_attack_factions_alive = {},
        potential_attack_subcultures_alive = {},
    },
    warning_event_key = "fro_dyn_dis_raiding_parties_warning",
    raiding_event_key = "fro_dyn_dis_raiding_parties_trigger",
    raiding_cancel_event_key = "fro_dyn_dis_raiding_parties_early_end",
    raiding_raiders_effect_key = "fro_dyn_dis_raiding_parties_invader_buffs",
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
        "wh2_main_def_naggarond",               -- Malekith
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

    -- Get the army template to use, based on the subculture and turn.
    local current_turn = cm:turn_number();
    local template = "earlygame";
    if current_turn < 50 then
        template = "earlygame";
    end

    if current_turn >= 50 and current_turn < 100 then
        template = "midgame";
    end

    if current_turn >= 100 then
        template = "lategame";
    end

    if self.settings.subculture == "wh2_dlc11_sc_cst_vampire_coast" then
        self.settings.army_template.vampire_coast = template;
    end

    if self.settings.subculture == "wh_dlc08_sc_nor_norsca" then
        self.settings.army_template.norsca = template;
    end

    if self.settings.subculture == "wh2_main_sc_def_dark_elves" then
        self.settings.army_template.dark_elves = template;
    end

    -- Recalculate the delay for further executions.
    if dynamic_disasters.settings.debug == false then
        self.settings.warning_delay = math.random(4, 10);
        self.settings.wait_turns_between_repeats = self.settings.warning_delay + 10;
    else
        self.settings.warning_delay = 1;
        self.settings.wait_turns_between_repeats = 1;
    end

    self:set_status(STATUS_TRIGGERED);
    dynamic_disasters:execute_payload(self.warning_event_key, nil, 0, nil);
end

-- Function to trigger the raid itself.
function disaster_raiding_parties:trigger_raiding_parties()
    out("Frodo45127: Disaster: " .. self.name .. ". Triggering invasion.");

    -- Get all the coastal regions (as in region with a port) to attack by weight.
    local attack_vectors = {};
    local avg = 0;
    local count = 0;

    -- Calculate the weight of each attack region.
    for coast, regions in pairs(potential_coasts) do
        attack_vectors[coast] = 0;
        count = count + 1;

        for _, sea_region in pairs(regions) do
            local sea_region_data = dyn_dis_sea_potential_attack_vectors[sea_region];

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

    -- If no coast to attack has been found, or we wiped out the entire faction, just cancel the attack.
    local faction = cm:get_faction(self.settings.faction);
    if #coasts_to_attack < 1 or (faction:is_null_interface() == true or faction:is_dead() or faction:was_confederated()) then
        cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
        dynamic_disasters:execute_payload(self.raiding_cancel_event_key, nil, 0, nil);
        return
    end

    -- Get the region at random from the top half of the coasts.
    local coast_to_attack = coasts_to_attack[math.random(1, #coasts_to_attack)];
    local first_sea_region = nil;
    for _, sea_region in pairs(potential_coasts[coast_to_attack]) do
        first_sea_region = sea_region;

        -- Scale is an optional value for manually increasing/decreasing armies in one region.
        -- By default it's 1 (no change in amount of armies).
        local scale = 1;
        if dyn_dis_sea_potential_attack_vectors[sea_region].scale ~= nil then
            scale = dyn_dis_sea_potential_attack_vectors[sea_region].scale;
        end

        -- Armies calculation.
        local armies_to_spawn = math.ceil(self.settings.difficulty_mod) * math.ceil(#dyn_dis_sea_potential_attack_vectors[sea_region].coastal_regions * 0.5) * scale;
        local armies_to_spawn_in_each_spawn_point = armies_to_spawn / #dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions;
        out("Frodo45127: Armies to spawn: " .. tostring(armies_to_spawn_in_each_spawn_point) .. " per region.");

        -- Spawn armies at sea.
        for i = 1, #dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions do
            local spawn_pos = dyn_dis_sea_potential_attack_vectors[sea_region].spawn_positions[i];
            dynamic_disasters:create_scenario_force_at_coords(self.settings.faction, dyn_dis_sea_potential_attack_vectors[sea_region].coastal_regions[1], spawn_pos, self.settings.army_template, self.settings.base_army_unit_count, true, armies_to_spawn_in_each_spawn_point, self.name);
        end
    end

    -- Trigger all the stuff related to the invasion (missions, effects,...).
    cm:activate_music_trigger("ScriptedEvent_Negative", self.settings.subculture)
    dynamic_disasters:execute_payload(self.raiding_event_key, nil, 0, dyn_dis_sea_potential_attack_vectors[first_sea_region].coastal_regions[1]);

    -- Set diplomacy.
    if faction:is_null_interface() == false and not faction:is_dead() then

        -- Apply buffs to the attackers, so they can at least push one province into player territory.
        cm:apply_effect_bundle(self.raiding_raiders_effect_key, self.settings.faction, 10)

        -- Make every attacking faction go full retard against the owner of the coastal provinces.
        for _, sea_region in pairs(potential_coasts[coast_to_attack]) do
            dynamic_disasters:declare_war_for_owners_and_neightbours(faction, dyn_dis_sea_potential_attack_vectors[sea_region].coastal_regions, false, {self.settings.subculture});
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

        -- Update the potential factions removing the confederated ones.
        factions = dynamic_disasters:remove_confederated_factions_from_list(factions);

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
                local faction = cm:get_faction(faction_key, true);
                if faction:is_null_interface() == false and not faction:is_dead() then
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

    -- Debug mode support.
    if dynamic_disasters.settings.debug == true then
        return true;
    end

    -- Base chance: 1/50 turns (2%).
    local base_chance = 0.02;

    -- Increase the change of starting based on how many attackers are already dead.
    -- In theory, no need to remove again confederated factions.
    for _, factions in pairs(potential_attack_factions) do
        for _, faction_key in pairs(factions) do
            local faction = cm:get_faction(faction_key);
            if faction:is_null_interface() == false and faction:is_dead() then

                -- Increase in 1% the chance of triggering for each dead attacker.
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
