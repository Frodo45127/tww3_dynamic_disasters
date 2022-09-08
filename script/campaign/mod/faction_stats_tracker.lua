--[[
    Script by Frodo45127 for the Dynamic Disasters mod.

    Faction-wide stats tracker. To be used to weight disasters against certain factions based on how the player fought agaisnt them.
]]

-- Faction-wide stats tracker.
faction_stats_tracker = {
    stats = {},                     -- Contains per-player faction stats.
}

-- Stats of a player vs a single faction.
local stats_vs_faction = {
    battle_results = {                      -- Battle results against a faction, separated by result type.
        heroic_victory = 0,                 -- Amount of heroic victories against said faction.
        decisive_victory = 0,               -- Amount of decisive victories against said faction.
        close_victory = 0,                  -- Amount of close victories against said faction.
        pyrrhic_victory = 0,                -- Amount of pyrrhic victories against said faction.
        valiant_defeat = 0,                 -- Amount of valiant defeats against said faction.
        close_defeat = 0,                   -- Amount of close defeats against said faction.
        decisive_defeat = 0,                -- Amount of decisive defeats against said faction.
        crushing_defeat = 0,                -- Amount of crushing defeats against said faction.
    },
    battles_won = 0,                        -- Amount of battles won against said faction.
    battles_lost = 0,                       -- Amount of battles lost against said faction.
};

-- Function to setup the save/load from savegame logic for items. Copied from dynamic_disasters.
--
-- Pretty much a reusable function to load data from save and set it to be saved on the next save.
---@param item table #Object/Table to save. It MUST CONTAIN a stats node, as that's what it really gets saved.
---@param save_key string #Unique key to identify the saved data.
local function setup_save(item, save_key)
    local old_data = cm:get_saved_value(save_key);
    if old_data ~= nil then
       item.stats = old_data;
    end
    cm:set_saved_value(save_key, item.stats);
end

-- Initialise the faction-wide stats tracker on first tick.
cm:add_first_tick_callback(
    function()
        out("Frodo45127: Initializing faction-wide stats tracker.")
        setup_save(faction_stats_tracker, "faction_stats_tracker")
    end
)
-- Aggression-by-battle tracker.
core:add_listener(
    "TrackerBattleCompleted",
    "BattleCompleted",
    function() return cm:model():pending_battle():has_been_fought() end,
    function(_) faction_stats_tracker:battle_completed() end,
    true
);

--[[
    Helper functions.
]]

-- Function to track aggression due to battles fought against a specific faction.
function faction_stats_tracker:battle_completed()
    local num_attackers = cm:pending_battle_cache_num_attackers();
    local num_defenders = cm:pending_battle_cache_num_defenders();

    if num_attackers < 1 or num_defenders < 1 then
        return;
    end

    -- Get the attackers and defenders, and identify the human players.
    local attackers = {};
    local defenders = {};
    local humans = {
        attackers = {},
        defenders = {},
    };

    for i = 1, num_attackers do
        local _, _, attacker_name = cm:pending_battle_cache_get_attacker(i);
        attackers[attacker_name] = true;

        local attacker = cm:get_faction(attacker_name);
        if not attacker == false and attacker:is_null_interface() == false and attacker:is_human() == true then
            humans.attackers[attacker_name] = true;
        end
    end

    for i = 1, num_defenders do
        local _, _, defender_name = cm:pending_battle_cache_get_defender(i);
        defenders[defender_name] = true;

        local defender = cm:get_faction(defender_name);
        if not defender == false and defender:is_null_interface() == false and defender:is_human() == true then
            humans.defenders[defender_name] = true;
        end
    end

    -- Check who won and who lost.
    local pending_battle = cm:model():pending_battle();
    local attacker_won = pending_battle:attacker_won();
    local attacker_result = pending_battle:attacker_battle_result();
    local defender_result = pending_battle:defender_battle_result();

    -- For each player attacking, record their victories/defeats.
    for human_faction_key, _ in pairs(humans.attackers) do
        local human_stats = self.stats[human_faction_key];
        out("Frodo45127: Tracking battle result of player " .. human_faction_key .." attacking.")

        if human_stats == nil then
            human_stats = {};
        end

        for defender_faction_key, _ in pairs(defenders) do
            out("Frodo45127: Tracking battle result against" .. defender_faction_key ..".")

            local human_stats_vs_faction = human_stats[defender_faction_key];
            if human_stats_vs_faction == nil then
                human_stats_vs_faction = stats_vs_faction;
            end

            -- Track battles won/lost.
            if attacker_won == true then
                human_stats_vs_faction.battles_won = human_stats_vs_faction.battles_won + 1;
            else
                human_stats_vs_faction.battles_lost = human_stats_vs_faction.battles_lost + 1;
            end

            out("Frodo45127: Player " .. human_faction_key .. " has won " .. human_stats_vs_faction.battles_won .. " battles against " .. defender_faction_key ..".")
            out("Frodo45127: Player " .. human_faction_key .. " has lost " .. human_stats_vs_faction.battles_lost .. " battles against " .. defender_faction_key ..".")

            -- Track battle results.
            human_stats_vs_faction.battle_results[attacker_result] = human_stats_vs_faction.battle_results[attacker_result] + 1;

            -- Save the updated stats.
            human_stats[defender_faction_key] = human_stats_vs_faction;
        end

        -- Save the updated stats into the stats section.
        self.stats[human_faction_key] = human_stats;
    end

    -- Same thing for human defenders.
    for human_faction_key, _ in pairs(humans.defenders) do
        local human_stats = self.stats[human_faction_key];
        out("Frodo45127: Tracking battle result of player " .. human_faction_key .." defending.")

        if human_stats == nil then
            human_stats = {};
        end

        for attacker_faction_key, _ in pairs(attackers) do
            out("Frodo45127: Tracking battle result against " .. attacker_faction_key ..".")

            local human_stats_vs_faction = human_stats[attacker_faction_key];
            if human_stats_vs_faction == nil then
                human_stats_vs_faction = stats_vs_faction;
            end

            -- Track battles won/lost.
            if attacker_won == false then
                human_stats_vs_faction.battles_won = human_stats_vs_faction.battles_won + 1;
            else
                human_stats_vs_faction.battles_lost = human_stats_vs_faction.battles_lost + 1;
            end

            -- Track battle results.
            human_stats_vs_faction.battle_results[defender_result] = human_stats_vs_faction.battle_results[defender_result] + 1;
            out("Frodo45127: Player " .. human_faction_key .. " has won " .. human_stats_vs_faction.battles_won .. " battles against " .. attacker_faction_key ..".")
            out("Frodo45127: Player " .. human_faction_key .. " has lost " .. human_stats_vs_faction.battles_lost .. " battles against " .. attacker_faction_key ..".")

            -- Save the updated stats.
            human_stats[attacker_faction_key] = human_stats_vs_faction;
        end

        -- Save the updated stats into the stats section.
        self.stats[human_faction_key] = human_stats;
    end
end
