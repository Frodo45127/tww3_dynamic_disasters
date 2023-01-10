--[[
	Script by Frodo45127 for the Dynamic Disasters mod.

    Large parts of it are extended functions from the endgames.lua files, for compatibility reasons.
]]

-- TODO: When an event triggers at the same time as this (turn 2->3), that event locks the game. Reproducible with bretonnia and empire on turns 2->5. It needs investigation.

-- Global Dynamic Disasters manager object, to keep track of all disasters.
dynamic_disasters = {
    settings = {},                                  -- Settings. To be populated later on.
    disasters = {},                                 -- List of disasters. This is populated on first tick.

    default_settings = {                            -- Default settings for the manager.
        enabled = true,                             -- If the entire Dynamic Disasters system is enabled.
        debug_2 = false,                            -- Debug mode. Forces all disasters to trigger and all in-between phase timers are reduced to 1 turn.
        automatic_difficulty = true,                -- If the difficulty must be chosen based on the campaign difficulty.
        disable_vanilla_endgames = true,            -- If this should disable the vanilla endgames, to avoid duplicated disasters. TODO: Fix issues with missions getting overwritten due to this.
        victory_condition_triggered = false,        -- If a disaster has already triggered a victory condition, as we can't have two at the same time.
        max_endgames_at_the_same_time = 3,          -- Max amount of endgame crisis one can trigger at the same time, to space them out a bit.
        currently_running_endgames = 0,             -- Amount of currently running endgames.
        max_endgames_per_campaign = 3,              -- Max amount of endgames that can trigger in a single campaign.
        endgames_triggered = 0,                     -- Amount of endgames triggered this campaign.
    },

    vortex_key = "dyn_dis_custom_vortex_ulthuan",   -- Vortex VFX name.
    vortex_vfx = "scripted_effect17",               -- Vortex effect key.
    regions_to_reveal = {},                         -- List of regions to reveal after processing disasters.
    army_templates = {},                            -- List of weigthed units used by the manager. Initialized on runtime.
};

-- Settings required for all disasters. If missing, this manager will add them to each disaster with these values.
local mandatory_settings = {
    enabled = true,                     -- If the disaster is enabled or not.
    started = false,                    -- If the disaster has been started.
    finished = false,                   -- If the disaster has been finished.
    repeteable = false,                 -- If the disaster can be repeated.
    is_endgame = true,                  -- If the disaster is an endgame.
    revive_dead_factions = true,        -- If true, dead factions will be revived if needed.
    enable_diplomacy = false,           -- If true, you will still be able to use diplomacy with disaster-related factions. Broken beyond believe, can make the game a cakewalk.
    min_turn = 60,                      -- Minimum turn required for the disaster to trigger.
    max_turn = 0,                       -- If the disaster hasn't trigger at this turn, we try to trigger it. Set to 0 to not check for max turn. Used only for some disasters.
    status = 0,                         -- Current status of the disaster. Used to re-initialize the disaster correctly on reload.
    last_triggered_turn = 0,            -- Turn when the disaster was last triggerd.
    last_finished_turn = 0,             -- Turn when the disaster was last finished.
    wait_turns_between_repeats = 0,     -- If repeteable, how many turns will need to pass after finished for the disaster to be available again.
    difficulty_mod = 1.5,               -- Difficulty multiplier used by the disaster (effects depend on the disaster).
    mct_settings = {}                   -- Extra settings this disaster may pull from MCT.
}

-- Function to setup the save/load from savegame logic for items.
--
-- Pretty much a reusable function to load data from save and set it to be saved on the next save.
---@param item table #Object/Table to save. It MUST CONTAIN a settings node, as that's what it really gets saved.
---@param save_key string #Unique key to identify the saved data.
local function setup_save(item, save_key)
    local old_data = cm:get_saved_value(save_key);
    if old_data ~= nil then
       item.settings = table.copy(old_data);
    end
    cm:set_saved_value(save_key, item.settings);
end

--[[
    MCT Helpers, so the users can configure the disasters as they want.
]]--

-- Listener to initialize the mod from the MCT settings, if available.
core:add_listener(
    "DynamicDisastersSettingsLoader",
    "MctInitialized",
    true,
    function(context)
        dynamic_disasters:load_from_mct(context:mct());
    end,
    true
)

-- Listener to update the mod mid-campaign from the MCT settings, if available.
core:add_listener(
    "DynamicDisastersSettingsMidCamnpaignLoader",
    "MctFinalized",
    true,
    function(context)
        dynamic_disasters:load_from_mct(context:mct());
    end,
    true
)

-- Function to load settings from the mct.
---@param mct userdata #MCT object.
function dynamic_disasters:load_from_mct(mct)
    local mod = mct:get_mod_by_key("dynamic_disasters")

    local dynamic_disasters_enable = mod:get_option_by_key("dynamic_disasters_enable")
    local dynamic_disasters_enable_setting = dynamic_disasters_enable:get_finalized_setting()
    self.settings.enabled = dynamic_disasters_enable_setting

    local dynamic_disasters_disable_vanilla_endgames = mod:get_option_by_key("dynamic_disasters_disable_vanilla_endgames")
    local dynamic_disasters_disable_vanilla_endgames_setting = dynamic_disasters_disable_vanilla_endgames:get_finalized_setting()
    self.settings.disable_vanilla_endgames = dynamic_disasters_disable_vanilla_endgames_setting
    if endgame ~= nil then
        endgame.settings.endgame_enabled = not self.settings.disable_vanilla_endgames;

        if endgame.settings.endgame_enabled == false then
            core:remove_listener("endgame_victory_trigger_listener")
            core:remove_listener("endgame_turn_trigger_listener")
        end
    end

    local dynamic_disasters_automatic_difficulty_enable = mod:get_option_by_key("dynamic_disasters_automatic_difficulty_enable")
    local dynamic_disasters_automatic_difficulty_enable_setting = dynamic_disasters_automatic_difficulty_enable:get_finalized_setting()
    self.settings.automatic_difficulty = dynamic_disasters_automatic_difficulty_enable_setting

    local dynamic_disasters_debug = mod:get_option_by_key("dynamic_disasters_debug")
    local dynamic_disasters_debug_setting = dynamic_disasters_debug:get_finalized_setting()
    self.settings.debug_2 = dynamic_disasters_debug_setting

    local dynamic_disasters_max_simul = mod:get_option_by_key("dynamic_disasters_max_simul")
    local dynamic_disasters_max_simul_setting = dynamic_disasters_max_simul:get_finalized_setting()
    self.settings.max_endgames_at_the_same_time = dynamic_disasters_max_simul_setting

    local dynamic_disasters_max_total_endgames = mod:get_option_by_key("dynamic_disasters_max_total_endgames")
    local dynamic_disasters_max_total_endgames_setting = dynamic_disasters_max_total_endgames:get_finalized_setting()
    self.settings.max_endgames_per_campaign = dynamic_disasters_max_total_endgames_setting

    for _, disaster in pairs(self.disasters) do
        local disaster_enable = mod:get_option_by_key(disaster.name .. "_enable");
        if not disaster_enable == false then
            local disaster_enable_setting = disaster_enable:get_finalized_setting();
            disaster.settings.enabled = disaster_enable_setting;
        end

        local min_turn = mod:get_option_by_key(disaster.name .. "_min_turn_value");
        if not min_turn == false then
            local min_turn_setting = min_turn:get_finalized_setting();
            disaster.settings.min_turn = min_turn_setting;
        end

        local max_turn = mod:get_option_by_key(disaster.name .. "_max_turn_value");
        if not max_turn == false then
            local max_turn_setting = max_turn:get_finalized_setting();
            disaster.settings.max_turn = max_turn_setting;
        end

        local difficulty_mod = mod:get_option_by_key(disaster.name .. "_difficulty_mod");
        if not difficulty_mod == false then
            local difficulty_mod_setting = difficulty_mod:get_finalized_setting();
            disaster.settings.difficulty_mod = difficulty_mod_setting / 100;
        end

        local revive_dead_factions = mod:get_option_by_key(disaster.name .. "_revive_dead_factions");
        if not revive_dead_factions == false then
            local revive_dead_factions_setting = revive_dead_factions:get_finalized_setting();
            disaster.settings.revive_dead_factions = revive_dead_factions_setting;
        end

        local enable_diplomacy = mod:get_option_by_key(disaster.name .. "_enable_diplomacy");
        if not enable_diplomacy == false then
            local enable_diplomacy_setting = enable_diplomacy:get_finalized_setting();
            disaster.settings.enable_diplomacy = enable_diplomacy_setting;
        end

        for i = 1, #disaster.settings.mct_settings do
            local setting = disaster.name .. "_" .. disaster.settings.mct_settings[i];
            out("Frodo45127: Trying to get setting " .. setting .. " from the MCT.")

            local option = mod:get_option_by_key(setting);
            if not option == false then
                local value = option:get_finalized_setting();
                disaster.settings[disaster.settings.mct_settings[i]] = value;

                out("Frodo45127: Setting " .. disaster.settings.mct_settings[i] .. " for disaster " .. disaster.name .. " to ".. tostring(value) .. ".")
            end
        end
    end
end

--[[
    End of MCT Helpers.
]]--

-- Initialise the disasters available, reading the files from the dynamic_disasters folder preparing the manager.
--
-- Extended from endgames.lua to keep things more or less compatible.
function dynamic_disasters:initialize()

    -- Initialize randomizer.
    math.randomseed(os.time())

    -- Before loading disasters, initialize the army templates.
    out("Frodo45127: Initializing army templates.");
    self.army_templates = table.copy(dyn_dis_army_templates);

    -- Look for dynamic disaster files and load them into the framework
    local disaster_files = core:get_filepaths_from_folder("/script/campaign/dynamic_disasters/", "*.lua")
    out("####################")
    out("Frodo45127: Loading the following disasters from /script/campaign/dynamic_disasters/:")
    local disasters_loaded = {}
    local env = core:get_env()

    for i = 1, #disaster_files do
        local disaster_filepath = disaster_files[i]
        local disaster_name = tostring(string.sub(disaster_filepath, 35, (string.len(disaster_filepath)-4)))

        -- Make sure the file is loaded correctly, skip its inclusion if not
        local loaded_file, load_error = loadfile(disaster_filepath)
        if loaded_file then

            -- Make sure the file is set as loaded
            package.loaded[disaster_filepath] = true

            -- Set the environment of the Lua chunk to the global environment
            -- Note to future me: removing this makes the disasters unable to load core listeners. Do not remove it.
            setfenv(loaded_file, env)

            -- Execute the loaded Lua chunk so the functions within are registered
            local disaster_executed_successfully, result = pcall(loaded_file)
            if not disaster_executed_successfully then
                out("\tFailed to execute loaded disaster file [" .. disaster_name .. "], error is: " .. tostring(result))
            else
                -- Add the disaster to our loaded disasters list.
                out("\t"..disaster_name.." loaded successfully")
                table.insert(disasters_loaded, result)
            end

        -- If the disaster failed to load, report it.
        else
            out("\tFailed to load disaster file [" .. disaster_name .. "], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:")
            local path_no_lua =  tostring(string.sub(disaster_filepath, 0, (string.len(disaster_filepath)-4)))
            local require_result, require_error = pcall(require, path_no_lua)

            if require_result then
                out("\tWARNING: require() seemed to be able to load file [" .. disaster_filepath .. "] with filename [" .. disaster_name .. "], where loadfile failed? Maybe the scenario is loaded, maybe it isn't - proceed with caution!")
            else
                -- strip tab and newline characters from error string
                out("\t\t" .. string.gsub(string.gsub(require_error, "\t", ""), "\n", ""))
            end

        end
    end

    -- Once loaded, we need to check if the disaster is available for our campaign/faction.
    local campaign_key = cm:get_campaign_name();
    local human_factions = cm:get_human_factions();
    for _, disaster in pairs(disasters_loaded) do
        out("\tFrodo45127: Trying to load disaster: " .. disaster.name .. ".")
        local disaster_is_valid = true;

        -- Make sure its valid for all human factions.
        for _, faction_name in pairs(human_factions) do
            local faction = cm:get_faction(faction_name);

            -- Check that the disaster supports the campaign we're loading into.
            -- Each disaster must manually specify which campaign map supports, as it will probably need custom tweaks for each map.
            local allowed_in_campaign = false;
            for _, campaign_supported in pairs(disaster.campaigns) do
                if campaign_supported == campaign_key then
                    allowed_in_campaign = true;
                    break;
                end
            end

            if allowed_in_campaign then

                -- Global disasters may be blacklisted for certain subcultures.
                if disaster.is_global == true then
                    local allowed = true;

                    for _, subculture in pairs(disaster.denied_for_sc) do
                        if subculture == faction:subculture() then
                            allowed = false;
                            break;
                        end
                    end

                    if allowed == false then
                        disaster_is_valid = false;
                    end

                -- If the disaster is not global, check if it's allowed and not denied for your subculture.
                else
                    local allowed = false;

                    for _, subculture in pairs(disaster.allowed_for_sc) do
                        if subculture == faction:subculture() then
                            allowed = true;
                            break;
                        end
                    end

                    if allowed == true then
                        for _, subculture in pairs(disaster.denied_for_sc) do
                            if subculture == faction:subculture() then
                                allowed = false;
                                break;
                            end
                        end
                    end

                    if allowed == false then
                        disaster_is_valid = false;
                    end
                end
            else
                disaster_is_valid = false;
            end
        end

        if disaster_is_valid then
            table.insert(self.disasters, disaster)
        end
    end

    if #self.disasters > 0 then
        out(#self.disasters.." total disasters loaded successfully.")
        out("####################")
    else
        out("0 disasters loaded.")
        out("####################")
        return
    end

    -- Once all the disasters are loaded, setup saving-restoring data from save.
    setup_save(self, "dynamic_disasters_settings")
    for _, disaster in ipairs(self.disasters) do
        setup_save(disaster, disaster.name .. "_settings");

        -- Initialize all missing disaster-specific settings on older saves to default values, to stop disasters from breaking on updates due to missing settings.
        for setting, value in pairs(disaster.default_settings) do
            if disaster.settings[setting] == nil then
                if is_table(value) then
                    disaster.settings[setting] = table.copy(value);
                else
                    disaster.settings[setting] = value;
                end
                out("\tFrodo45127: Disaster: "..disaster.name..". Missing disaster setting: ".. setting .. ". Initializing to default value.")
            end
        end

        -- Initialize all missing mandatory settings on older saves to default values, to stop disasters from breaking on updates due to missing mandatory settings.
        for setting, value in pairs(mandatory_settings) do
            if disaster.settings[setting] == nil then
                if is_table(value) then
                    disaster.settings[setting] = table.copy(value);
                else
                    disaster.settings[setting] = value;
                end
                out("\tFrodo45127: Disaster: "..disaster.name..". Missing mandatory setting: ".. setting .. ". Initializing to default value.")
            end
        end

        -- Make sure to initialize listeners of already in-progress disasters.
        if disaster.settings.started == true then
            disaster:set_status(disaster.settings.status);
        end
    end

    -- Once it loads, make sure to initialize new settings, so they're properly baked into the save.
    for setting, value in pairs(self.default_settings) do
        if self.settings[setting] == nil then
            if is_table(value) then
                self.settings[setting] = table.copy(value);
            else
                self.settings[setting] = value;
            end
            out("\tFrodo45127: Disaster's manager missing setting: ".. setting .. ". Initializing to default value.")
        end
    end

    -- Once all disasters are loaded, get their settings from the mct if available and apply it to them.
    if get_mct then
        self:load_from_mct(get_mct());
    end

    -- There's a thing going on with two different victory conditions getting triggered (it bugs out the victory missions panel)
    -- so we need to make sure that none of the vanilla endgames are triggered before allowing this to trigger victory conditions.
    if endgame ~= nil then
        endgame.settings.endgame_enabled = not self.settings.disable_vanilla_endgames;

        if endgame.settings.endgame_enabled == false then
            core:remove_listener("endgame_victory_trigger_listener")
            core:remove_listener("endgame_turn_trigger_listener")
        else
            self.settings.victory_condition_triggered = true;
        end
    end

    out("Frodo45127: Victory mission has been triggered: " .. tostring(self.settings.victory_condition_triggered) .. ".")

    -- After everything is loaded, initialize any integrations we have.
    self:initialize_integrations();

    -- We need to set the vortex status depending on the current disasters.
    --self:toggle_vortex();

    -- Listener to make sure the automatic difficulty works and it's kept updated.
    -- We CANNOT do this on initialization if we use the MCT, so we need to fallback to good ol listener on turn start.
    -- NOTE: leave the aaa in the name, so it triggers before anything else.
    core:add_listener(
        "DynamicDisastersAutoDifficultyCheck",
        "WorldStartRound",
        true,
        function ()

            -- If we have auto difficulty enabled, set the difficulty based on campaign difficulty.
            if self.settings.automatic_difficulty == true then
                local difficulty = cm:get_difficulty();
                self.settings.max_endgames_at_the_same_time = difficulty;
                out("\tFrodo45127: Automatic difficulty detected. Setting max concurrent endgame disasters to " .. self.settings.max_endgames_at_the_same_time ..", based on campaign difficulty.")
                for _, disaster in ipairs(self.disasters) do
                    disaster.settings.difficulty_mod = difficulty / 2.5;
                    out("\tFrodo45127: Automatic difficulty detected. Setting difficulty of disaster "..disaster.name.." to ".. disaster.settings.difficulty_mod .. ", based on campaign difficulty.")
                end

            -- If we have auto difficulty disabled but have MCT, load it from there.
            elseif get_mct then
                self:load_from_mct(get_mct());

            -- If not, load it from the default values.
            else
                self.settings.max_endgames_at_the_same_time = self.default_settings.max_endgames_at_the_same_time;
                for _, disaster in ipairs(self.disasters) do
                    disaster.settings.difficulty_mod = disaster.default_settings.difficulty_mod;
                end
            end
        end,
        true
    );

    -- Listener for evaluating if a disaster can be started or not. Triggered at the begining of each turn.
    core:add_listener(
        "DynamicDisastersMaybeDisasterTime",
        "WorldStartRound",
        true,
        function ()
            return self:process_disasters()
        end,
        true
    );

    -- Listener to check if the Vortex VFX should be enabled or not this turn. This has to trigger after all listeners to work properly.
    --core:add_listener(
    --    "zzzDynDisReenableVortex",
    --    "WorldStartRound",
    --    true,
    --    function ()
    --        return self:toggle_vortex();
    --    end,
    --    true
    --);
end

-- Function to initialize integration scripts.
function dynamic_disasters:initialize_integrations()
    local integration_files = core:get_filepaths_from_folder("/script/campaign/dynamic_disasters_integrations/", "*.lua")
    out("####################")
    out("Frodo45127: Loading the following dynamic disaster integrations from /script/campaign/dynamic_disasters_integrations/:")
    local env = core:get_env()

    for i = 1, #integration_files do
        local filepath = integration_files[i]
        local name = tostring(string.sub(filepath, 48))

        -- Make sure the file is loaded correctly, skip its inclusion if not
        local loaded_file, load_error = loadfile(filepath)
        if loaded_file then

            -- Make sure the file is set as loaded
            package.loaded[filepath] = true

            -- Set the environment of the Lua chunk to the global environment
            -- Note to future me: removing this makes the disasters unable to load core listeners. Do not remove it.
            setfenv(loaded_file, env)

            -- Execute the loaded Lua chunk so the functions within are registered
            local executed_successfully, result = pcall(loaded_file)
            if not executed_successfully then
                out("\tFailed to execute loaded disaster integration file [" .. name .. "], error is: " .. tostring(result))
            else
                out("\tIntegration "..name.." loaded successfully")
            end

        -- If the integration failed to load, report it.
        else
            out("\tFailed to load integration file [" .. name .. "], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:")
            local path_no_lua =  tostring(string.sub(filepath, 0, (string.len(filepath)-4)))
            local require_result, require_error = pcall(require, path_no_lua)

            if require_result then
                out("\tWARNING: require() seemed to be able to load file [" .. filepath .. "] with filename [" .. name .. "], where loadfile failed? Maybe the scenario is loaded, maybe it isn't - proceed with caution!")
            else
                -- strip tab and newline characters from error string
                out("\t\t" .. string.gsub(string.gsub(require_error, "\t", ""), "\n", ""))
            end

        end
    end

    out("####################")
end

-- Function to process all the disasters available and trigger them when they can be triggered.
--
-- This function only takes care of starting the disaster's own logic. Once it starts, this leaves the disaster do its thing.
function dynamic_disasters:process_disasters()

    -- Only process disasters if we enabled the mod.
    if self.settings.enabled == true then

        out("Frodo45127: Processing disasters on turn " .. cm:turn_number() .. ".");
        for _, disaster in ipairs(self.disasters) do
            out("Frodo45127: Processing disaster ".. disaster.name);
            if disaster.settings.enabled == true then

                -- If it's already done, check if it's repeteable.
                if disaster.settings.finished == true then

                    -- If it's repeteable, try to trigger it again.
                    if disaster.settings.repeteable == true then
                        if disaster.settings.last_finished_turn > 0 and cm:turn_number() - disaster.settings.last_finished_turn > disaster.settings.wait_turns_between_repeats then
                            if disaster.settings.is_endgame == false or (disaster.settings.is_endgame == true and self.settings.currently_running_endgames < self.settings.max_endgames_at_the_same_time and self.settings.max_endgames_per_campaign > self.settings.endgames_triggered) then

                                if disaster:check_start_disaster_conditions() then
                                    out("Frodo45127: Disaster " .. disaster.name .. " triggered (repeated trigger).");
                                    disaster.settings.finished = false;
                                    disaster.settings.started = true;
                                    disaster.settings.last_triggered_turn = cm:turn_number();

                                    if disaster.settings.is_endgame == true then
                                        self.settings.currently_running_endgames = self.settings.currently_running_endgames + 1;
                                        self.settings.endgames_triggered = self.settings.endgames_triggered + 1;
                                    end

                                    disaster:trigger();
                                end
                            end
                        end
                    end

                -- If it's not yet started, check if we have the minimum requirements to start it.
                elseif disaster.settings.started == false then
                    if cm:turn_number() >= disaster.settings.min_turn and (disaster.settings.is_endgame == false or (disaster.settings.is_endgame == true and self.settings.currently_running_endgames < self.settings.max_endgames_at_the_same_time and self.settings.max_endgames_per_campaign > self.settings.endgames_triggered)) then
                        if disaster:check_start_disaster_conditions() then
                            out("Frodo45127: Disaster " .. disaster.name .. " triggered (first trigger).");
                            disaster.settings.started = true;
                            disaster.settings.last_triggered_turn = cm:turn_number();

                            if disaster.settings.is_endgame == true then
                                self.settings.currently_running_endgames = self.settings.currently_running_endgames + 1;
                                self.settings.endgames_triggered = self.settings.endgames_triggered + 1;
                            end

                            disaster:trigger();
                        end
                    end
                end
            end
        end
    end

    -- Trigger the region reveal of all disasters together. Otherwise it bugs out for all but the last one.
    self:reveal_regions(nil);
end

-- Function to cleanup after a disaster has finished.
---@param disaster table #Object/table of the disaster to finish.
function dynamic_disasters:finish_disaster(disaster)
    disaster.settings.finished = true;
    disaster.settings.started = false;
    disaster:set_status(0);
    disaster.settings.last_finished_turn = cm:turn_number();

    if disaster.settings.is_endgame == true then
        self.settings.currently_running_endgames = self.settings.currently_running_endgames - 1;
    end
end

-- Function to trigger an incident for a phase of a disaster. It can have an associated effect and a payload that lasts the provided duration.
--
-- Deprecated. Use trigger_incident instead.
---@param incident_key string #Incident key for the incident this function will trigger. Must exists in the DB.
---@param effect_bundle_key string #Optional. Effect Bundle key for the effect bundle to trigger with this incident. Must exists in the DB.
---@param duration integer #Optional. Duration for the effect bundle.
---@param region_key string #Optional. Region key for the region this incident will allow to zoom in.
function dynamic_disasters:execute_payload(incident_key, effect_bundle_key, duration, region_key)
    self:trigger_incident(incident_key, effect_bundle_key, duration, region_key)
end

-- Function to trigger an incident for a disaster. It can have an associated effect and a payload that lasts the provided duration.
---@param incident_key string #Incident key for the incident this function will trigger. Must exists in the DB.
---@param effect_bundle_key string #Optional. Effect Bundle key for the effect bundle to trigger with this incident. Must exists in the DB.
---@param duration integer #Optional. Duration for the effect bundle.
---@param region_key string #Optional. Region key for the region this incident will allow to zoom in.
function dynamic_disasters:trigger_incident(incident_key, effect_bundle_key, duration, region_key)
    if duration == nil then
        duration = 0;
    end

    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        local incident_builder = cm:create_incident_builder(incident_key)
        local payload_builder = cm:create_payload()

        -- If we got no effect, just trigger the incident without payload.
        if effect_bundle_key ~= nil then
            local payload = cm:create_new_custom_effect_bundle(effect_bundle_key)
            payload:set_duration(duration)
            payload_builder:effect_bundle_to_faction(payload)
        end

        -- This doesn't work.
        if region_key ~= nil then
            incident_builder:add_target("default", cm:get_region(region_key));
        end

        out("Frodo45127: triggering incident " .. incident_key .. ", " .. tostring(incident_builder) .. ".")
        incident_builder:set_payload(payload_builder)
        cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(human_factions[i]))
    end
end

-- Function to trigger a dilemma with the provided choices and payloads.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object of the faction that will receive the dilemma.
---@param dilemma_key string #Key for the dilemma this function will trigger. Must exists in the DB.
---@param choices string #Key for the dilemma this function will trigger. Must exists in the DB and be ordered in the table.
---@param target_faction FACTION_SCRIPT_INTERFACE #Optional. Faction to use as target for the dilemma.
---@param secondary_faction FACTION_SCRIPT_INTERFACE #Optional. Secondary Faction to use as target for the dilemma.
---@param character FAMILY_MEMBER_SCRIPT_INTERFACE #Optional. Character to use as target for the dilemma.
---@param mf MILITARY_FORCE_SCRIPT_INTERFACE #Optional. Military force to use as target for the dilemma.
---@param region REGION_SCRIPT_INTERFACE #Optional. Region to use as target for the dilemma.
---@param settlement SETTLEMENT_SCRIPT_INTERFACE #Optional. Settlement to use as target for the dilemma.
function dynamic_disasters:trigger_dilemma(faction, dilemma_key, choices, target_faction, secondary_faction, character, mf, region, settlement)

    local dilemma_builder = cm:create_dilemma_builder(dilemma_key);
    local payload_builder = cm:create_payload();

    -- Targets
    if target_faction then
        dilemma_builder:add_target("default", target_faction);
    end
    if secondary_faction then
        dilemma_builder:add_target("target_faction_1", secondary_faction);
    end
    if character then
        dilemma_builder:add_target("default", character);
    end
    if mf then
        dilemma_builder:add_target("default", mf);
    end
    if region then
        dilemma_builder:add_target("default", region);
    end
    if settlement then
        dilemma_builder:add_target("default", settlement);
    end

    -- Choices
    for i = 1, #choices do
        if i == 5 then
            break;
        end

        local payloads = choices[i];
        if is_table(payloads) == true then
            for payload_type, payload_data in pairs(payloads) do
                if payload_type == "effect_bundle" then
                    payload_builder:effect_bundle_to_faction(payload_data);

                end

                if payload_type == "form_confederation" then
                    local confed_faction = cm:get_faction(payload_data);
                    if not confed_faction == false and confed_faction:is_null_interface() == false then
                        payload_builder:form_confederation(faction, confed_faction, true)
                    end
                end
            end
        end

        dilemma_builder:add_choice_payload("SCRIPTED_" .. i, payload_builder);
        payload_builder:clear();
    end

    out("Frodo45127: Triggering dilemma: " .. dilemma_key .. " with " .. #choices .. " choices.")
    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end

-- Function to add a mission for a disaster. Use this if you want to setup an incident with an associated mission for a disaster. Mission applies to all players.
---@param objectives table #List of objectives this mission should have.
---@param can_be_victory boolean #If we should try to set the mission as Campaing Victory mission. Will fail and set it as normal mission if there is already one campaign victory mission.
---@param disaster_name string #Name of the disaster that triggered this mission.
---@param mission_name string #Name of this mission.
---@param incident_key string #Key of the incident that will trigger this listener.
---@param target_region_key string #Optional. Key of a region to zoom in.
---@param target_faction_key string #Optional. Key of a faction to zoom in.
---@param success_callback function #Optional. Function to trigger when the mission is completed.
---@param do_not_trigger_incident boolean #Optional. If true the related incident will not be triggered, so it's up to you to trigger it manually later and trigger the mission with it..
function dynamic_disasters:add_mission(objectives, can_be_victory, disaster_name, mission_name, incident_key, target_region_key, target_faction_key, success_callback, do_not_trigger_incident)
    local target_region_cqi = 0;
    local target_faction_cqi = 0;

    if not target_region_key == nil then
        target_region_cqi = cm:get_region(target_region_key):cqi();
    end

    if not target_faction_key == nil then
        target_faction_cqi = cm:get_region(target_faction_key):cqi();
    end

    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        dynamic_disasters:add_mission_listener(human_factions[i], objectives, can_be_victory, disaster_name, mission_name, incident_key, success_callback)
        if not do_not_trigger_incident == true then
            cm:trigger_incident_with_targets(
                cm:get_faction(human_factions[i]):command_queue_index(),
                incident_key,
                target_faction_cqi,
                0,
                0,
                0,
                target_region_cqi,
                0
            )
        end
    end
end

-- Function to setup a listener to trigger a mission just after the player has seen the related incident.
---@param faction_key string #Faction that will receive the mission. Usually player factions.
---@param objectives table #List of objectives this mission should have.
---@param can_be_victory boolean #If we should try to set the mission as Campaing Victory mission. Will fail and set it as normal mission if there is already one campaign victory mission.
---@param disaster_name string #Name of the disaster that triggered this mission.
---@param mission_name string #Name of this mission.
---@param incident_key string #Key of the incident that will trigger this listener.
---@param success_callback function #Optional. Function to trigger when the mission is completed.
function dynamic_disasters:add_mission_listener(faction_key, objectives, can_be_victory, disaster_name, mission_name, incident_key, success_callback)
    core:add_listener(
        "dyn_dis_" .. disaster_name .. "_mission_listener_" .. faction_key .. "_" .. mission_name,
        "IncidentOccuredEvent",
        function(context)
            return context:dilemma() == incident_key and context:faction():name() == faction_key
        end,
        function()
            self:create_mission(faction_key, objectives, can_be_victory, disaster_name, mission_name, success_callback)
            core:remove_listener("dyn_dis_" .. disaster_name .. "_mission_listener_" .. faction_key .. "_" .. mission_name)
        end,
        true
    )
end


-- Function to create and trigger a mission for a disaster, based on objectives.
---@param faction_key string #Faction that will receive the mission. Usually player factions.
---@param objectives table #List of objectives this mission should have.
---@param can_be_victory boolean #If we should try to set the mission as Campaing Victory mission. Will fail and set it as normal mission if there is already one campaign victory mission.
---@param disaster_name string #Name of the disaster that triggered this mission.
---@param mission_name string #Name of this mission.
---@param success_callback function #Optional. Function to trigger when the mission is completed.
function dynamic_disasters:create_mission(faction_key, objectives, can_be_victory, disaster_name, mission_name, success_callback)

    if can_be_victory and self.settings.victory_condition_triggered == false then

        ---@type mission_manager
        local mm = mission_manager:new(faction_key, "dyn_dis_" .. disaster_name .. "_" .. mission_name .. "_1", success_callback);
        self:add_objectives_to_mission(mm, objectives, faction_key, false)
        mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
        mm:add_payload("game_victory")
        mm:set_victory_type("wh3_combi_victory_type_ultimate")
        mm:set_victory_mission(true)
        mm:set_show_mission(true)
        mm:trigger()
        self.settings.victory_condition_triggered = true;

    else
        -- For some reason, individual-non victory missions don't read more than the first objective. So we have to create a mission per objective.
        for i = 1, #objectives do

            ---@type mission_manager
            local mm = mission_manager:new(faction_key, "dyn_dis_" .. disaster_name .. "_" .. mission_name .. "_" .. i, success_callback);
            self:add_objectives_to_mission(mm, { objectives[i] }, faction_key, true)
            mm:set_show_mission(true)
            mm:trigger()
        end
    end
end

-- Takes the objectives generated by the victory-specific functions, and passes them through to the mission manager
---@param mm mission_manager #Mission manager that will receive the objectives.
---@param objectives table #Objectives to add to the mission.
---@param faction_key string #Key of the faction that will receive the objectives.
---@param add_payloads boolean #If we should add the payloads for each objective.
function dynamic_disasters:add_objectives_to_mission(mm, objectives, faction_key, add_payloads)

    for i1 = 1, #objectives do
        if objectives[i1].type ~= nil then
            mm:add_new_objective(objectives[i1].type)
            for i2 = 1, #objectives[i1].conditions do
                mm:add_condition(objectives[i1].conditions[i2])
            end

            -- Unlike all other objectives, construct buildings requires the performing faction key as well. These objectives will fail if we don't add them here
            if objectives[i1].type == "CONSTRUCT_N_BUILDINGS_FROM" or objectives[i1].type == "CONSTRUCT_N_BUILDINGS_INCLUDING" then
                mm:add_condition("faction "..faction_key)
            end

            if add_payloads == true then
                for i2 = 1, #objectives[i1].payloads do
                    mm:add_payload(objectives[i1].payloads[i2])
                end
            end
        end
    end

end

-- Function to spawn armies at a specific land region on the campaign map. This ensures the spawn position is valid within the region.
-- If passed an invalid/sea region, this function will fail.
---@param faction_key string #Faction key of the owner of the armies.
---@param region_key string #Land region key used for spawning and declaring war.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param declare_war boolean #If war should be declared between the owner of the armies and the owner of the region where they'll spawn.
---@param total_armies integer #Amount of armies to spawn. If not provided, it'll spawn 1.
---@param disaster_name string #Name of the disaster that will use this army.
---@param success_callback function #Optional. Custom success callback.
---@return boolean #If at least one army has been spawned, or all armies failed to spawn due to invalid coordinates.
function dynamic_disasters:create_scenario_force(faction_key, region_key, army_template, unit_count, declare_war, total_armies, disaster_name, success_callback)

    -- total_armies shouldn't be nil, but if it is assume we want a single army
    if total_armies == nil or total_armies < 1 then
        total_armies = 1
    end

    if success_callback == nil then
        success_callback = function(cqi)
            local character = cm:char_lookup_str(cqi)
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 0)
            cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
            cm:add_agent_experience(character, cm:random_number(25, 15), true)
            cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
        end
    end

    local army_spawn = false;

    for i = 1, total_armies do
        local unit_list = self:generate_random_army(army_template, unit_count, disaster_name)
        local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 5)

        -- In case no more valid positions are found, retry with a bigger radious.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn at region " .. region_key .. ". Retrying with bigger radious.");
            pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 10)
        end

        -- In case no more valid positions are found, retry with a much bigger radious.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn at region " .. region_key .. ". Retrying with much bigger radious.");
            pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 15)
        end

        -- If they're still invalid, we cannot spawn the army anymore.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn again. Returning without trying again.");
            break;
        end

        cm:create_force(
            faction_key,
            unit_list,
            region_key,
            pos_x,
            pos_y,
            false,
            success_callback
        )

        -- If we manage to spawn at least one army, take it as a win.
        army_spawn = true;
    end

    if declare_war then
        local region_owning_faction = cm:get_region(region_key):owning_faction()
        if not region_owning_faction == false and region_owning_faction:is_null_interface() == false then
            out("Frodo45127: Trying to declare war between " .. faction_key .. " and ".. region_owning_faction:name() .. " due to army spawn.")
            dynamic_disasters:declare_war(faction_key, region_owning_faction:name(), true, true)
        end
    end

    return army_spawn;
end

-- Function to spawn armies at specific coordinates on the campaign map. This ensures the spawn position is valid within 15 hex of the coordinates.
-- If passed a coordinate that has no valid position within range, this function will fail.
---@param faction_key string #Faction key of the owner of the armies.
---@param region_key string #Land region key used for spawning and declaring war. If spawning at sea, just provide a valid one.
---@param coords table #Table with X/Y coordinates around which the armies should spawn.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param declare_war boolean #If war should be declared between the owner of the armies and the owner of the region where they'll spawn.
---@param total_armies integer #Amount of armies to spawn. If not provided, it'll spawn 1.
---@param disaster_name string #Name of the disaster that will use this army.
---@param success_callback function #Optional. Custom success callback.
---@return boolean #If at least one army has been spawned, or all armies failed to spawn due to invalid coordinates.
function dynamic_disasters:create_scenario_force_at_coords(faction_key, region_key, coords, army_template, unit_count, declare_war, total_armies, disaster_name, success_callback)

    -- total_armies shouldn't be nil, but if it is assume we want a single army
    if total_armies == nil or total_armies < 1 then
        total_armies = 1
    end

    if success_callback == nil then
        success_callback = function(cqi)
            local character = cm:char_lookup_str(cqi)
            cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 0)
            cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
            cm:add_agent_experience(character, cm:random_number(25, 15), true)
            cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
        end
    end

    local army_spawn = false;

    for i = 1, total_armies do
        local unit_list = self:generate_random_army(army_template, unit_count, disaster_name)
        local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, coords[1], coords[2], false, 5);

        -- In case no more valid positions are found, retry with a bigger radious.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn near X:" .. coords[1] .. ", Y:" .. coords[2] .. ". Retrying with bigger radious.");
            pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, coords[1], coords[2], false, 10);
        end

        -- In case no more valid positions are found, retry with a much bigger radious.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn near X:" .. coords[1] .. ", Y:" .. coords[2] .. ". Retrying with much bigger radious.");
            pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, coords[1], coords[2], false, 15);
        end

        -- If they're still invalid, we cannot spawn the army anymore.
        if pos_x == -1 or pos_y == -1 then
            out("Frodo45127: Armies failed to spawn again. Returning without trying again.");
            break;
        end

        cm:create_force(
            faction_key,
            unit_list,
            region_key,
            pos_x,
            pos_y,
            false,
            success_callback
        )

        -- If we manage to spawn at least one army, take it as a win.
        army_spawn = true;
    end

    if declare_war then
        local region_owning_faction = cm:get_region(region_key):owning_faction()
        if not region_owning_faction == false and region_owning_faction:is_null_interface() == false then
            out("Frodo45127: Trying to declare war between "..faction_key.." and "..region_owning_faction:name() .. " due to army spawn.")
            dynamic_disasters:declare_war(faction_key, region_owning_faction:name(), true, true)
        end
    end

    return army_spawn;
end

-- Function to release invasion-controlled armies to the AI.
---@param cqis table #List of army CQI in the invasion.
---@param targets table #List of target regions in the invasion.
---@param max_turn integer #Max turn the invasion should keep control of the armies.
function dynamic_disasters:release_armies(cqis, targets, max_turn)
    out("\tFrodo45127: Max turn passed for army releases: " .. tostring(max_turn) .. ".")

    local indexes_to_delete = {};
    for i = 1, #cqis do
        local cqi = cqis[i];

        ---@type invasion
        local invasion = invasion_manager:get_invasion(tostring(cqi))
        if invasion == nil or invasion == false then
            out("\tFrodo45127: Army with cqi " .. cqi .. " has not been found on an invasion. Probably released after reaching its target. Queued for deletion from the disaster data.")
            table.insert(indexes_to_delete, i);
        elseif invasion:has_target() == false then
            out("\tFrodo45127: Army with cqi " .. cqi .. " has no target. Releasing.")
            invasion:release();
            table.insert(indexes_to_delete, i);
        end
    end

    -- To delete, reverse the table, because I don't know how reindexing works in lua. Doing it in reverse guarantees us that we're removing bottom to top.
    reverse = {}
    for i = #indexes_to_delete, 1, -1 do
        reverse[#reverse+1] = indexes_to_delete[i]
    end
    indexes_to_delete = reverse

    -- Be careful with always making sure that both tables are kept inline with each other.
    for i = 1, #indexes_to_delete do
        local index = indexes_to_delete[i]

        table.remove(cqis, index)
        table.remove(targets, index)
    end

    out("\tFrodo45127: Remaining armies: " .. #cqis .. ".")

    -- If we don't have more factions or we reached the end of the grace period, release the armies.
    if #cqis == 0 or cm:turn_number() == max_turn then
        if #cqis > 0 then

            out("\tFrodo45127: Releasing all " .. #cqis .. " remaining armies.")
            for i = 1, #cqis do
                local cqi = cqis[i];

                ---@type invasion
                local invasion = invasion_manager:get_invasion(tostring(cqi))
                if not invasion == nil and not invasion == false then
                    invasion:release();
                end
            end
        end
    end
end

-- Function add a bunch of regions to the list of revealed regions when disasters are processed.
---@param regions table #List of land region keys.
function dynamic_disasters:prepare_reveal_regions(regions)
    for i = 1, #regions do
        table.insert(self.regions_to_reveal, regions[i]);
    end
end

-- Function to reveal a bunch of regions for the players, if they can't see them yet.
--
-- NOTE: instead of this, use `dynamic_disasters:prepare_reveal_regions(regions)`. This gets bugged if multiple disasters trigger it at the same turn.
---@param regions table #List of land region keys.
function dynamic_disasters:reveal_regions(regions)
    if not regions == nil then
        self.regions_to_reveal = table.copy(regions)
    end

    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        for i2 = 1, #self.regions_to_reveal do

            out("Frodo45127: Lifting shroud from region: " .. self.regions_to_reveal[i2] .. ".");
            cm:make_region_visible_in_shroud(human_factions[i], self.regions_to_reveal[i2]);
        end
    end

    self.regions_to_reveal = {}
end

-- Function to declare wars between factions.
---@param attacker_key string #Attacker's faction key.
---@param defender_key string #Defender's faction key
---@param invite_attacker_allies boolean #Invite attacker allies to the war
---@param invite_defender_allies boolean #Invite defender allies to the war
function dynamic_disasters:declare_war(attacker_key, defender_key, invite_attacker_allies, invite_defender_allies)
    if defender_key == "rebels" then
        return
    end
    local defender_faction = cm:get_faction(defender_key)
    if defender_faction:is_null_interface() == false then
        if defender_faction:is_vassal() then
            defender_faction = defender_faction:master()
            defender_key = defender_faction:name()
        end
        if attacker_key ~= defender_key and cm:get_faction(attacker_key):at_war_with(defender_faction) == false then
            out("Frodo45127: Declaring war between "..attacker_key.." and "..defender_key)

            if invite_defender_allies == true then

                -- Note: if you're an ally of a defender (can't be of an attacker, and if it's, it's a bug in the disaster because all attackers must be already in war with the player)
                -- inviting defender allies at the beginning of your turn will bug out the camera. To avoid that, if a human is an ally we manually declare war on each of the allies,
                -- without inviting them. If there are no human allies there is no problem.
                local human_is_allied_of_defender = false;
                local human_factions = cm:get_human_factions();
                for _, human_faction_key in pairs(human_factions) do
                    local human_faction = cm:get_faction(human_faction_key);
                    if defender_faction:allied_with(human_faction) then
                        human_is_allied_of_defender = true;
                        break;
                    end
                end

                if human_is_allied_of_defender == true then
                    local allied_factions = defender_faction:factions_allied_with();
                    for i = 0, allied_factions:num_items() - 1 do
                        local defender_faction_ally = allied_factions:item_at(i);
                        if cm:get_faction(attacker_key):at_war_with(defender_faction_ally) == false then
                            out("Frodo45127: Human alliance involved, Declaring war between "..attacker_key.." and "..defender_faction_ally:name())

                            cm:force_declare_war(attacker_key, defender_faction_ally:name(), invite_attacker_allies, false)
                        end
                    end
                    cm:force_declare_war(attacker_key, defender_key, invite_attacker_allies, false)
                else
                    cm:force_declare_war(attacker_key, defender_key, invite_attacker_allies, invite_defender_allies)
                end
            else
                cm:force_declare_war(attacker_key, defender_key, invite_attacker_allies, invite_defender_allies)
            end
        end
    end
end

-- This function disables peace treaties with for the faction for all human players. It allows confederations.
---@param hostile_faction_key string #Faction that will get the war declaration.
---@param enable_diplomacy boolean #If we shall allow diplomacy between the players and the hostile faction.
function dynamic_disasters:no_peace_no_confederation_only_war(hostile_faction_key, enable_diplomacy)
    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        endgame:declare_war(hostile_faction_key, cm:get_faction(human_factions[i]):name())
    end

    if enable_diplomacy == true then
        cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "form confederation", false, false, true, false)
        cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "peace", false, false, true, false)
    end
end



-- This function disables peace treaties with for the faction for all human players. It allows confederations.
---@param hostile_faction_key string #Faction that will get the war declaration.
---@param enable_diplomacy boolean #If we shall allow diplomacy between the players and the hostile faction.
function dynamic_disasters:no_peace_only_war(hostile_faction_key, enable_diplomacy)
    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        dynamic_disasters:declare_war(hostile_faction_key, cm:get_faction(human_factions[i]):name(), true, true)
    end

    if enable_diplomacy == true then
        cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "peace", false, false, true, false)
    end
end

-- Function to force a peace between a list of factions.
---@param factions table #List of faction keys that must sign peace, if they're at war.
---@param force_alliance boolean #Force a military alliance between both factions.
function dynamic_disasters:force_peace_between_factions(factions, force_alliance)
    for _, src_faction_key in pairs(factions) do
        for _, dest_faction_key in pairs(factions) do
            if src_faction_key ~= dest_faction_key then
                cm:force_make_peace(src_faction_key, dest_faction_key);

                if force_alliance == true then
                    cm:force_alliance(src_faction_key, dest_faction_key, true);
                end
            end
        end
    end
end

-- Function to generate random armies based on a combination of templates. Allows combination between different templates.
--
-- NOTE: If you pass an invalid army template, it'll be reported in the logs.
---@param army_template table #Table with the faction->template format. The templates MUST exists in the dynamic_disasters object.
---@param unit_count integer #Amount of non-mandatory units on the army.
---@param disaster_name string #Name of the disaster that will use this army.
---@return string #A comma separated string of units to spawn in the army.
function dynamic_disasters:generate_random_army(army_template, unit_count, disaster_name)
    local ram = random_army_manager
    ram:remove_force(disaster_name)
    ram:new_force(disaster_name)

    for race, template_type in pairs(army_template) do
        if self.army_templates[race] == nil then
            out("Frodo45127: ERROR: You passed the race " .. tostring(race) .. " which doesn't have an army template!")
        elseif self.army_templates[race][template_type] == nil then
            out("Frodo45127: ERROR: You passed the template " .. tostring(template_type) .. " which doesn't exists for the race " .. tostring(race) .. "!")

        else
            for unit, weight in pairs(self.army_templates[race][template_type]) do
                ram:add_unit(disaster_name, unit, weight)
            end
        end

    end

    return ram:generate_force(disaster_name, unit_count, false);
end

-- Function to remove all confederated factions from the provided list of factions, returning the new faction key list.
---@param factions table #Faction keys to check for confederation.
---@return table #Indexed table with the non-confederated faction keys.
function dynamic_disasters:remove_confederated_factions_from_list(factions)
    local clean_factions = {};
    for i = 1, #factions do
        local faction = cm:get_faction(factions[i]);
        if not faction == false and faction:is_null_interface() == false and faction:was_confederated() == false then
           table.insert(clean_factions, factions[i]);
        end
    end

    return clean_factions;
end

-- Function to get the "base" region for a faction, being the home region/region with the faction leader, or a default one we pass.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object.
---@param default_region string #Region to use if we cannot use the capital/leader region.
function dynamic_disasters:base_region_for_faction(faction, default_region)
    if not faction == nil and faction:is_null_interface() == false and faction:is_dead() == false then
        if faction:has_home_region() then
            return faction:home_region():name()
        elseif faction:faction_leader():has_region() then
            return faction:faction_leader():region():name()
        end
    end

    return default_region;
end

-- Function to declare war on all region owners of provided regions, and optionally on all neigthbors of the provided faction.
--
-- TODO: Make this function allow to ignore allies when declaring war.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object
---@param regions table #Region keys to declare war to.
---@param attack_faction_neightbors boolean #If we should declare war on all the current faction neighbours too.
---@param subcultures_to_ignore table #List of subcultures to ignore on war declarations.
function dynamic_disasters:declare_war_for_owners_and_neightbours(faction, regions, attack_faction_neightbors, subcultures_to_ignore)
    if not faction == false and faction:is_null_interface() == false then

        -- First, declare war on the explicitly provided region owners and its neightbor regions.
        for _, region_key in pairs(regions) do
            local region = cm:get_region(region_key);
            if not region == false and region:is_null_interface() == false then

                -- Try to declare war on its neighbors first, so we don't depend on the status of the current region.
                self:declare_war_on_adjacent_region_owners(faction, region, subcultures_to_ignore)

                -- Then get if the current region is occupied and try to declare war on the owner.
                local region_owner = region:owning_faction()
                if not region_owner == false and region_owner:is_null_interface() == false then

                    -- Get if we should ignore the current region.
                    local region_subculture = region_owner:subculture();
                    local ignore_region = false;
                    for j = 1, #subcultures_to_ignore do
                        if subcultures_to_ignore[j] == region_subculture then
                            ignore_region = true;
                            break;
                        end
                    end

                    -- Make sure we don't declare wars on vassals of ignored subcultures.
                    if ignore_region == false then
                        local master = faction:master();
                        if not master == false and master:is_null_interface() == false then
                            for j = 1, #subcultures_to_ignore do
                                if subcultures_to_ignore[j] == master:subculture() then
                                    ignore_region = true;
                                    break;
                                end
                            end
                        end
                    end

                    -- If the current region is not to be ignored, declate war on the owner.
                    if ignore_region == false then
                        dynamic_disasters:declare_war(faction:name(), region_owner:name(), true, true)
                    end
                end
            end
        end

        -- If we also want to attack all the faction's physical neighbors, find all the faction's regions and declare war aplenty.
        if attack_faction_neightbors then
            local region_list = faction:region_list();
            for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i);

                -- Try to declare war on its neighbors first, so we don't depend on the status of the current region.
                self:declare_war_on_adjacent_region_owners(faction, region, subcultures_to_ignore)
            end
        end
    end
end

-- Function to declare war on all region owners of regions adjacent to a specific region.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object
---@param base_region REGION_SCRIPT_INTERFACE #Region object
---@param subcultures_to_ignore table #List of subcultures to ignore on war declarations.
function dynamic_disasters:declare_war_on_adjacent_region_owners(faction, base_region, subcultures_to_ignore)
    if not base_region == false and base_region:is_null_interface() == false then
        local adjacent_regions = base_region:adjacent_region_list()

        for i = 0, adjacent_regions:num_items() - 1 do
            local region = adjacent_regions:item_at(i)

            -- Ignore abandoned regions.
            if region:is_abandoned() == false then
                local region_owner = region:owning_faction()

                -- Ignore vassal's regions.
                if not region_owner == false and region_owner:is_null_interface() == false then

                    -- Get if we should ignore the current region.
                    local region_subculture = region_owner:subculture();
                    local ignore_region = false;
                    for j = 1, #subcultures_to_ignore do
                        if subcultures_to_ignore[j] == region_subculture then
                            ignore_region = true;
                            break;
                        end
                    end

                    -- Make sure we don't declare wars on vassals of ignored subcultures.
                    if ignore_region == false then
                        local master = faction:master();
                        if not master == false and master:is_null_interface() == false then
                            for j = 1, #subcultures_to_ignore do
                                if subcultures_to_ignore[j] == master:subculture() then
                                    ignore_region = true;
                                    break;
                                end
                            end
                        end
                    end

                    if ignore_region == false then
                        dynamic_disasters:declare_war(faction:name(), region_owner:name(), true, true)
                    end
                end
            end
        end
    end
end

-- This function kills a faction without the killin being reported in the events.
---@param faction_key string #Key of the faction to kill.
function dynamic_disasters:kill_faction_silently(faction_key)

    --check the faction key is a string
    if not is_string(faction_key) then
        script_error("ERROR: kill_faction() called but supplied region key [" .. tostring(faction_key) .. "] is not a string");
        return false;
    end;

    local faction = cm:model():world():faction_by_key(faction_key);

    if faction:is_null_interface() == false then
        cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")

        cm:kill_all_armies_for_faction(faction);

        local region_list = faction:region_list();

        for j = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(j):name();
            cm:set_region_abandoned(region);
        end;

        cm:callback(
            function()
                cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
                cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
            end,
            0.5
        );
    end;
end;

-- Returns if the faction can be used or not. Invalid are broken or nil objects, humans, confederated factions, rebels, and dead factions if we set can_be_dead to false.
---@param faction FACTION_SCRIPT_INTERFACE #Faction object to check.
---@param can_be_dead boolean #If a dead faction is valid (will be revived on army spawns).
function dynamic_disasters:check_faction_is_valid(faction, can_be_dead)
    return faction ~= nil and faction:is_null_interface() == false and faction:is_human() == false and faction:was_confederated() == false and faction:name() ~= "rebels" and (can_be_dead == true or faction:is_dead() == false)
end

-- Function to add a new army template to a specific race, so it can be used in disasters.
--
-- NOTE: If you pass an existing army template, it'll wipe out its contents.
---@param race string #Race owning the army template. Check the dyn_dis_army_templates object for valid races.
---@param template string #Key of the template we want to add. Must be unique and not exist already.
---@return boolean|string #True if the unit got added, an error message if there was an error while adding it.
function dynamic_disasters:add_army_template_to_race(race, template)
    if self.army_templates[race] == nil then
        return "ERROR: Race " .. tostring(race) .. " not found in the army templates.";
    else
        self.army_templates[race][template] = {};
    end

    return true;
end

-- Function to add new units to a specific template, so it's used by disasters using that template.
---@param race string #Race owning the army template. Check the dyn_dis_army_templates object for valid races.
---@param template string #Template of that race which will receive the unit.
---@param unit_key string #Key of the unit that will be added to the template. Must be a valid unit key from the DB.
---@param weight integer #Weight of that unit for army generation. 8-> will surely appear multiple times, 1-> will rarely appear more than once.
---@return boolean|string #True if the unit got added, an error message if there was an error while adding it.
function dynamic_disasters:add_unit_to_army_template(race, template, unit_key, weight)
    if self.army_templates[race] == nil then
        return "ERROR: Race " .. tostring(race) .. " not found in the army templates.";
    elseif self.army_templates[race][template] == nil then
        return "ERROR: Template " .. tostring(template) .. " not found in the army templates for race " .. tostring(race) .. ".";
    elseif common.get_localised_string("land_units_onscreen_name_" .. unit_key) == "" then
        return "ERROR: Unit " .. tostring(unit_key) .. " not found in the db. Maybe is for a mod not yet installed or integration needs updating?";
    else
        self.army_templates[race][template][unit_key] = weight;
    end

    return true;
end

-- Function to determine if a faction is currently considered an order faction or not.
---@param faction_key string #Faction key to check.
---@return boolean #If the faction is considered an order faction or not. Returns false if the key is invalid.
function dynamic_disasters:is_order_faction(faction_key)

    -- Make sure the faction is valid before proceeding.
    local faction = cm:get_faction(faction_key);
    if faction == false or faction:is_null_interface() == true then
        return false;
    end

    local subcultures = {
        "wh2_main_sc_hef_high_elves",
        "wh2_main_sc_lzd_lizardmen",
        "wh3_main_sc_cth_cathay",
        "wh3_main_sc_ksl_kislev",
        "wh_dlc05_sc_wef_wood_elves",
        "wh_main_sc_brt_bretonnia",
        "wh_main_sc_dwf_dwarfs",
        "wh_main_sc_emp_empire",
        "wh_main_sc_teb_teb",
    }

    local subculture = faction:subculture();
    for i = 1, #subcultures do
        if subcultures[i] == subculture then
            is_order_faction = true;
            break;
        end
    end

    return is_order_faction;
end

-- Function to determine if a faction is currently considered a neutral faction or not.
---@param faction_key string #Faction key to check.
---@return boolean #If the faction is considered a neutral faction or not. Returns false if the key is invalid.
function dynamic_disasters:is_neutral_faction(faction_key)
    return self:is_order_faction(faction_key) == false and self:is_chaos_faction(faction_key) == false;
end

-- Function to determine if a faction is currently considered a chaos faction or not.
---@param faction_key string #Faction key to check.
---@return boolean #If the faction is considered a chaos faction or not. Returns false if the key is invalid.
function dynamic_disasters:is_chaos_faction(faction_key)

    -- Make sure the faction is valid before proceeding.
    local faction = cm:get_faction(faction_key);
    if faction == false or faction:is_null_interface() == true then
        return false;
    end

    local subcultures = {
        "wh2_main_rogue_chaos",
        "wh2_main_sc_def_dark_elves",
        "wh2_main_sc_skv_skaven",
        "wh3_main_sc_dae_daemons",
        "wh3_main_sc_kho_khorne",
        "wh3_main_sc_nur_nurgle",
        "wh3_main_sc_sla_slaanesh",
        "wh3_main_sc_tze_tzeentch",
        "wh_dlc03_sc_bst_beastmen",
        "wh_dlc08_sc_nor_norsca",
        "wh_main_sc_chs_chaos",
    }

    local subculture = faction:subculture();
    for i = 1, #subcultures do
        if subcultures[i] == subculture then
            is_chaos_faction = true;
            break;
        end
    end

    return is_chaos_faction;
end

-- Function to toggle the Vortex VFX on and off depending on if a disaster has forced disabling it.
function dynamic_disasters:toggle_vortex()
    local is_vortex_removed_by_disaster = false;
    for i = 1, #self.disasters do
        if self.disasters[i].name == "chaos_invasion" and self.disasters[i].settings.enabled == true and self.disasters[i].settings.started == true and self.disasters[i].settings.great_vortex_undone == true then
            is_vortex_removed_by_disaster = true;
            break;
        end
    end
    out("Frodo45127: toggling Vortex VFX: " .. tostring(not is_vortex_removed_by_disaster));
    if not is_vortex_removed_by_disaster then
        --cm:remove_vfx(self.vortex_key);
        cm:add_vfx(self.vortex_key, self.vortex_vfx, 171.925, 431.5, 0)
    end
end

-- Once everything is initialized, initialize the whole mod on first tick.
cm:add_first_tick_callback(
    function ()
        dynamic_disasters:initialize()
    end
)
