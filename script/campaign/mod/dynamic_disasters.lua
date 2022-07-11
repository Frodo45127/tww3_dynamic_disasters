--[[
	Script by Frodo45127 for the Dynamic Disasters mod.
]]

--[[
    Utility functions, by Vandy.
]]

--- ie. load_module("test", "script/my_folder/") to load script/my_folder/test.lua
local function load_module(file_name, file_path)
    local full_path = file_path.. file_name.. ".lua"
    local file, load_error = loadfile(full_path)

    if not file then
        out("Attempted to load module with name ["..file_name.."], but loadfile had an error: ".. load_error .."")
    else
        out("Loading module with name [" .. file_name.. ".lua]")

        local global_env = core:get_env()
        setfenv(file, global_env)
        local lua_module = file(file_name)

        if lua_module ~= false then
            out("[" .. file_name.. ".lua] loaded successfully!")
        end

        return lua_module
    end

    -- run "require" to see what the specific error is
    local ok, msg = pcall(function() require(file_path .. file_name) end)

    if not ok then
        out("Tried to load module with name [" .. file_name .. ".lua], failed on runtime. Error below:")
        out(msg)
        return false
    end
end

-- ie. load_modules("script/my_folder/") to load everything in ?.pack/script/my_folder/
local function load_modules(path)
  local search_override = "*.lua" -- search for all files that end in .lua within this path
  local file_str = common.filesystem_lookup(path, search_override)

    for filename in string.gmatch(file_str, '([^,]+)') do
        local filename_for_out = filename

        local pointer = 1
        while true do
            local next_sep = string.find(filename, "\\", pointer) or string.find(filename, "/", pointer)

            if next_sep then
                pointer = next_sep + 1
            else
                if pointer > 1 then
                    filename = string.sub(filename, pointer)
                end
                break
            end
        end

        local suffix = string.sub(filename, string.len(filename) - 3)

        if string.lower(suffix) == ".lua" then
            filename = string.sub(filename, 1, string.len(filename) -4)
        end


        load_module(filename, string.gsub(filename_for_out, filename..".lua", ""))
    end
end

-- Function to setup the save/load from savegame logic for disasters.
local function setup_save(disaster)

    -- Get the disaster from the save, and immediately mark it for saving.
    local old_data = cm:get_saved_value(disaster.save_key);
    if old_data ~= nil then
       disaster.inner = old_data;
    end
    cm:set_saved_value(disaster.save_key, disaster.inner);
end

--[[
    End of utility functions.
    Global tables definitions.
]]

-- This line loads all the scripts in this subfolder, which should contain all the disasters.
load_modules("script/campaign/dynamic_disasters/");

-- Global Dynamic Disasters manager object, to keep track of 
DynamicDisastersManager = {
    save_key = "DynamicDisastersManagerState",
    inner = {
        enabled = false,
    	faction_name = "",
        faction_culture = "",
        faction_subculture = "",
    },
    disasters = {},
};

-- List of possible disasters to trigger, separated by factions subcultures.
-- Each disaster may have it's own secondary conditions to trigger.
-- Also, each subfaction may have have some global disasters disabled for lore reasons.
DynamicDisasters = {
    
    -- Disasters that may affect all factions.
    ["global"] = {
        --"disaster_global_chaos" = { repeteable = false },
        ["disaster_global_aztec_invasion"] = DisasterAztecInvasion,
        --"disaster_global_hypnotoads_revenge" = { repeteable = false },
        --"disaster_global_wuxing_manipulation" = { repeteable = false }
    },

    -- Cathay-only disasters.
	["wh3_main_sc_cth_cathay"] = {
        allow = {
            --"disaster_cathay_enemies_at_the_gates" = { repeteable = false },
        },
        deny = {
            "disaster_global_wuxing_manipulation",
        },
    },
    
    -- Daemons of chaos-only disasters.
	["wh3_main_sc_dae_daemons"] = {
        allow = {},
        deny = {
            "disaster_global_chaos"
        },
    },
    
    -- Khorne-only disasters.
	["wh3_main_sc_kho_khorne"] = {
        allow = {
            --"disaster_cathay_enemies_at_the_gates" = { repeteable = false },
        },
        deny = {
            "disaster_global_chaos"
        },
    },
    
    -- Kislev-only disasters.
	["wh3_main_sc_ksl_kislev"] = {
        allow = {
            --"disaster_global_cold_embrace" = { repeteable = false },
        },
        deny = {},
    },
    
    -- Nurgle-only disasters.
	["wh3_main_sc_nur_nurgle"] = {
        allow = {},
        deny = {
            "disaster_global_chaos"
        },
    },
    
    -- Ogres-only disasters.
	["wh3_main_sc_ogr_ogre_kingdoms"] = {
        allow = {},
        deny = {},
    },
    
    -- Slanessh-only disasters.
	["wh3_main_sc_sla_slaanesh"] = {
        allow = {},
        deny = {
            "disaster_global_chaos"
        },
    },
    
    -- Tzeentch-only disasters.
	["wh3_main_sc_tze_tzeentch"] = {
        allow = {},
        deny = {
            "disaster_global_chaos"
        },
    },
};

function dynamic_disasters()
    DynamicDisastersManager.initialize();
end

--[[
	Associated functions for the Global Dynamic Disasters Manager.
]]

-- Function to initialize the Dynamic Disasters Manager, so it can be used to trigger disasters based on faction's behaviors.
function DynamicDisastersManager.initialize()
    out("Frodo45127: Global dynamic_disasters_manager initializing...");

    -- Get the manager from the save, and immediately mark it for saving.
    setup_save(DynamicDisastersManager);

    if DynamicDisastersManager.inner.enabled == false then
        out("Frodo45127: No previous manager data found or manager disabled, initializing.");

    	-- Enable it only on single-player, for now.
    	if cm:is_multiplayer() == false then
            out("Frodo45127: SinglePlayer detected, enabling dynamic_disasters_manager.");
            DynamicDisastersManager.inner.enabled = true;
            DynamicDisastersManager.inner.faction_name = cm:get_local_faction_name();

            local faction = cm:get_faction(DynamicDisastersManager.inner.faction_name);
            DynamicDisastersManager.inner.faction_culture = faction:culture();
            DynamicDisastersManager.inner.faction_subculture = faction:subculture();

            DynamicDisastersManager.setup_disasters();
        else
            out("Frodo45127: Multiplayer detected, disabling dynamic_disasters_manager.");
    	end

    -- If we have stats data from before, just report it and continue.
    else
        out("Frodo45127: Previous manager data found and loaded. Loading disasters data...");
        DynamicDisastersManager.setup_disasters();
    end

    -- Listener for evaluating if a disaster can be started or not. Triggered at the begining of each turn.
    cm:add_faction_turn_start_listener_by_name(
        "ScriptEventMaybeDisasterTime",
        DynamicDisastersManager.inner.faction_name,
        DynamicDisastersManager.process_disasters,
        true
    );
end

-- Function to prepare the list of available disasters. Used for initialization.
function DynamicDisastersManager.setup_disasters()
    out("Frodo45127: Getting disasters available for the faction " .. DynamicDisastersManager.inner.faction_name);
    local available_disasters = {};

    for _, disaster in pairs(DynamicDisasters['global']) do
        out("Frodo45127: Added global disaster " .. disaster.name);
        table.insert(available_disasters, disaster);
    end

    for _, disaster in pairs(DynamicDisasters[DynamicDisastersManager.inner.faction_subculture].allow) do
        out("Frodo45127: Added faction-specific disaster " .. disaster.name);
        table.insert(available_disasters, disaster);
    end

    local disasters_to_remove = {};
    for _, disaster_name in ipairs(DynamicDisasters[DynamicDisastersManager.inner.faction_subculture].deny) do
        for index, added_disaster in ipairs(available_disasters) do
            if added_disaster.name == disaster_name then
                out("Frodo45127: Removed faction-specific disaster " .. added_disaster.name);
                table.insert(disasters_to_remove, index);
            end
        end
    end

    for i = #disasters_to_remove, 1, -1 do
        table.remove(available_disasters, disasters_to_remove[i]);
    end

    DynamicDisastersManager.disasters = available_disasters;

    for name, disaster in ipairs(DynamicDisastersManager.disasters) do
        setup_save(disaster);
        out("Frodo45127: Disaster available: " .. name .. ".");
    end
end

-- Function to process all the disasters available and trigger them when they can be triggered.
-- This function is triggered at the start of each turn.
-- TODO: check for other conditions, and randomize the turns.
function DynamicDisastersManager.process_disasters()
    out("Frodo45127: Processing disasters on turn " .. cm:turn_number() .. ".");
    for _, disaster in ipairs(DynamicDisastersManager.disasters) do
        out("Frodo45127: Processing disaster ".. disaster.name);

        -- If it's already done, check if it's repeteable.
        if disaster.inner.finished == true then

            -- If it's repeteable, try to trigger it again.
            if disaster.inner.repeteable == true then
                if cm:turn_number() - disaster.inner.last_finished_turn > disaster.inner.wait_turns_between_repeats then
                    if disaster.check_disaster_conditions() then
                        out("Frodo45127: Disaster " .. disaster.name .. " triggered (repeated trigger).");
                        disaster.trigger_start_disaster();
                    end
                end
            end

        -- If it's not yet started, check if we have the minimum requirements to start it.
        elseif disaster.inner.started == false then
            if cm:turn_number() >= disaster.inner.turns_to_trigger_from_campaign_start then
                if disaster.check_disaster_conditions() then
                    out("Frodo45127: Disaster " .. disaster.name .. " triggered (first trigger).");
                    disaster.trigger_start_disaster();
                end
            end
        end
    end
end

-- Function to cleanup after a disaster has finished.
function DynamicDisastersManager.finish_disaster(disaster)
    disaster.inner.finished = true;
    disaster.inner.started = false;
    disaster.inner.last_finished_turn = cm:turn_number();
end

