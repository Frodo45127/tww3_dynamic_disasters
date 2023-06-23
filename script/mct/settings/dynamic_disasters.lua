--[[-------------------------------------------------------------------------------------------------------------
    Script by Frodo45127 for the Dynamic Disasters mod.

    MCT Module, with support for both, MCT Legacy (for now) and MCT 0.9.
]]---------------------------------------------------------------------------------------------------------------

local loc_prefix = "mct_dyn_dis_";
local mct = get_mct()
local mod = mct:register_mod("dynamic_disasters");

--- This table holds all the information to build all the options on the MCT for both, the mod and all the official disasters.
--- What data is stored depends on the editor type:
--- - Checkbox: a boolean.
--- - Slider: A table with (in this order) default value, minimum value, maximum value and step size.
disaster_configs = {
    aztec_invasion = {
        description = loc_prefix .. "aztec_invasion" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    raiding_parties = {
        description = loc_prefix .. "raiding_parties" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    skaven_incursions = {
        description = loc_prefix .. "skaven_incursions" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},

        critical_mass = {
            setting_type = "slider",
            setting_data = {15, 5, 50, 1},
        },
    },
    the_great_bastion_improved = {
        description = loc_prefix .. "the_great_bastion_improved" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
    },
    chianchi_assault = {
        description = loc_prefix .. "chianchi_assault" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    bretonian_crusades = {
        description = loc_prefix .. "bretonian_crusades" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    chaos_invasion = {
        description = loc_prefix .. "chaos_invasion" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,

        enable_rifts = {
            setting_type = "checkbox",
            setting_data = true,
        },
    },
    dragon_emperors_wrath = {
        description = loc_prefix .. "dragon_emperors_wrath" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    for_the_motherland = {
        description = loc_prefix .. "for_the_motherland" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    the_greatest_crusade = {
        description = loc_prefix .. "the_greatest_crusade" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    empire_of_steel_and_faith = {
        description = loc_prefix .. "empire_of_steel_and_faith" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    last_stand = {
        description = loc_prefix .. "last_stand" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 1, 400, 5},
    },
    realm_divided = {
        description = loc_prefix .. "realm_divided" .. "_description",
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
    },
    the_vermintide = {
        description = loc_prefix .. "the_vermintide" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 13},
        min_turn_value = {130, 13, 390, 13},
        max_turn_value = {0, 0, 2000, 13},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    grudge_too_far = {
        description = loc_prefix .. "grudge_too_far" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    pyramid_of_nagash = {
        description = loc_prefix .. "pyramid_of_nagash" .. "_description",
        enable = true,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    vampires_rise = {
        description = loc_prefix .. "vampires_rise" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    waaagh = {
        description = loc_prefix .. "waaagh" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    wild_hunt = {
        description = loc_prefix .. "wild_hunt" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    --[[
    will_of_hashut = {
        description = loc_prefix .. "will_of_hashut" .. "_description",
        enable = true,
        revive_dead_factions = false,
        perimeter_war = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 2000, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    ]]
};

--[[-------------------------------------------------------------------------------------------------------------
    MCT setting generator helpers.

    This monster allow us to setup disaster settings just by adding them to the disaster_config object.
]]---------------------------------------------------------------------------------------------------------------

--- List of settings all disasters have.
--- Settings not in this list are considered "disaster-specific" settings.
local generic_settings = {
    {
        key = "enable",
        value = "checkbox",
        use_disaster_name_in_loc_key = true,
        disabled_by_autodifficulty = false
    },
    {
        key = "revive_dead_factions",
        value = "checkbox",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "perimeter_war",
        value = "checkbox",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "enable_diplomacy",
        value = "checkbox",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "difficulty_mod",
        value = "slider",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = true
    },
    {
        key = "min_turn_value",
        value = "slider",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "max_turn_value",
        value = "slider",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "short_victory_is_min_turn",
        value = "checkbox",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
    {
        key = "long_victory_is_min_turn",
        value = "checkbox",
        use_disaster_name_in_loc_key = false,
        disabled_by_autodifficulty = false
    },
}

local option_keys_disabled_by_autodifficulty = {};      -- List of options disabled by autodifficulty.
local disaster_sections = {};                           -- List of disaster sections.

--- Function to load checkbox settings.
---@param disaster_name string #Key of the disaster.
---@param setting_key string #Key of the setting we're loading.
---@param default_value boolean #Default value of the setting we're loading.
---@param use_disaster_name_in_loc_key boolean #If the loc key contains the disaster name.
---@param disabled_by_autodifficulty boolean #If the option should be disabled if autodifficulty is enabled.
function load_checkbox(disaster_name, setting_key, default_value, use_disaster_name_in_loc_key, disabled_by_autodifficulty)
    local setting = mod:add_new_option(disaster_name .. "_" .. setting_key, "checkbox")
    setting:set_default_value(default_value)

    if use_disaster_name_in_loc_key == true then
        setting:set_text(loc_prefix .. disaster_name .. "_" .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. disaster_name .. "_" .. setting_key .. "_tooltip", true)
    else
        setting:set_text(loc_prefix .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. setting_key .. "_tooltip", true)
    end

    if disabled_by_autodifficulty == true then
        option_keys_disabled_by_autodifficulty[disaster_name] = disaster_name .. "_" .. setting_key;
    end
end

--- Function to load checkbox settings.
---@param disaster_name string #Key of the disaster.
---@param setting_key string #Key of the setting we're loading.
---@param slider_data table #Indexed table with the data for the slider in this order: "default value, min, max, step side.
---@param use_disaster_name_in_loc_key boolean #If the loc key contains the disaster name.
---@param disabled_by_autodifficulty boolean #If the option should be disabled if autodifficulty is enabled.
function load_slider(disaster_name, setting_key, slider_data, use_disaster_name_in_loc_key, disabled_by_autodifficulty)
    if slider_data[1] == nil or slider_data[2] == nil or slider_data[3] == nil or slider_data[4] == nil then
        out(setting_key .. " setting for disaster " .. disaster_name .. " failed to load due to missing slider data");
        return;
    end

    local setting = mod:add_new_option(disaster_name .. "_" .. setting_key, "slider")
    setting:slider_set_min_max(slider_data[2], slider_data[3])
    setting:set_default_value(slider_data[1])
    setting:slider_set_step_size(slider_data[4])

    if use_disaster_name_in_loc_key == true then
        setting:set_text(loc_prefix .. disaster_name .. "_" .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. disaster_name .. "_" .. setting_key .. "_tooltip", true)
    else
        setting:set_text(loc_prefix .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. setting_key .. "_tooltip", true)
    end

    if disabled_by_autodifficulty == true then
        option_keys_disabled_by_autodifficulty[disaster_name] = disaster_name .. "_" .. setting_key;
    end
end

--- Function to load all disaster settings into a disaster-specific section.
---@param disaster_name string #Key of the disaster.
---@param disaster_data table #Table with the disaster's data.
function load_disaster(disaster_name, disaster_data)

    -- Config generator, idea grabbed from discusions I've read about on discord.
    -- Note: the trailing trues are for 0.8 compatibility (they're required for older MCT builds to pick up translations).
    local disaster_section = mod:add_new_section(disaster_name, loc_prefix .. disaster_name .. "_config", true)
    if mct:get_version() == "0.9-beta" or mct:get_version() == "0.9" then
        disaster_section:set_is_collapsible(true)
        disaster_section:set_visibility(false)

        if disaster_data["description"] then
            disaster_section:set_description(disaster_data["description"]);
        end

        disaster_sections[disaster_name] = disaster_section;
    end

    -- Load generic settings.
    local dummy_index = 0;
    for _, setting in ipairs(generic_settings) do
        local setting_key = setting["key"];
        local setting_type = setting["value"];
        local use_disaster_name_in_loc_key = setting["use_disaster_name_in_loc_key"];
        local disabled_by_autodifficulty = setting["disabled_by_autodifficulty"];

        if disaster_data[setting_key] ~= nil then
            if setting_type == "checkbox" then
                load_checkbox(disaster_name, setting_key, disaster_data[setting_key], use_disaster_name_in_loc_key, disabled_by_autodifficulty);
            elseif setting_type == "slider" then
                load_slider(disaster_name, setting_key, disaster_data[setting_key], use_disaster_name_in_loc_key, disabled_by_autodifficulty);
            end

        elseif not (mct:get_version() == "0.9-beta" or mct:get_version() == "0.9") then
            local setting = mod:add_new_option(disaster_name .. "_d " .. dummy_index, "dummy")
            setting:set_text(" ");
            dummy_index = dummy_index + 1;
        end
    end

    -- Load disaster-specific settings.
    for setting_key, setting_data in pairs(disaster_data) do
        local is_generic = false;
        for _, setting in ipairs(generic_settings) do
            if setting["key"] == setting_key then
                is_generic = true;
                break;
            end
        end

        if not is_generic then
            if setting_data["setting_type"] == "checkbox" then
                load_checkbox(disaster_name, setting_key, setting_data["setting_data"], true, false);
            elseif setting_data["setting_type"] == "slider" then
                load_slider(disaster_name, setting_key, setting_data["setting_data"], true, false);
            end
        end
    end
end

--- This function sets up automatic difficulty-related settings correctly.
---@param state boolean #Current state of the Automatic Difficulty feature.
local function setup_automatic_difficulty(state)
    local mct_mod = mct:get_mod_by_key("dynamic_disasters");

    -- If we're in a campaign, and we're locking it, instantly recalculate the difficulty values.
    if state == true then
        if dynamic_disasters then

            -- Manually set the state in the backend, so the recalculation can be done.
            dynamic_disasters.settings.automatic_difficulty = state;
            dynamic_disasters:recalculate_difficulty();
        end
    end
    for disaster_name, setting in pairs(option_keys_disabled_by_autodifficulty) do
        local other_option = mct_mod:get_option_by_key(setting)
        if state == true then

            -- Set the recalculated value in the UI if we're in a campaign.
            if dynamic_disasters then
                if disaster_name == "dynamic_disasters" then
                    other_option:set_selected_setting(dynamic_disasters.settings.max_endgames_at_the_same_time);
                else
                    for _, disaster in ipairs(dynamic_disasters.disasters) do
                        if disaster["name"] == disaster_name then
                            other_option:set_selected_setting(disaster.settings.difficulty_mod * 100);
                            break;
                        end
                    end
                end
            end

            other_option:set_locked(true, "Frodo45127: setting " .. setting .. " locked by automatic difficulty.");
        else
            other_option:set_locked(false, "Frodo45127: setting " .. setting .. " unlocked by disabled automatic difficulty.");
        end
    end
end

--[[-------------------------------------------------------------------------------------------------------------
    Disaster loading logic.

    Here is where we actually initialize and load the menu. If you make new disasters, remember to add them both
    at the big disaster_config table, and at the end of this file.
]]---------------------------------------------------------------------------------------------------------------

mod:set_author("Frodo45127")
mod:set_title(loc_prefix.."mod_title", true)
mod:set_description(loc_prefix.."mod_desc", true)

if mct:get_version() == "0.9-beta" or mct:get_version() == "0.9" then
    mod:set_workshop_id("2856219244");
    mod:set_version("1.2");
    mod:set_main_image("ui/mct/dynamic_disasters.png", 300, 300)
end

-- Global config section.

local disasters_global_config_section = mod:add_new_section("a_mod_config", loc_prefix.."mod_config", true)
if mct:get_version() == "0.9-beta" or mct:get_version() == "0.9" then
    disasters_global_config_section:set_is_collapsible(true)
    disasters_global_config_section:set_visibility(true)
end

load_checkbox("dynamic_disasters", "enable", true, false, false);
load_checkbox("dynamic_disasters", "disable_vanilla_endgames", true, false, false);
load_checkbox("dynamic_disasters", "automatic_difficulty_enable", true, false, false);
load_slider("dynamic_disasters", "max_simul", {3, 1, 50, 1}, false, true);
load_slider("dynamic_disasters", "max_total_endgames", {3, 1, 50, 1}, false, false);
load_checkbox("dynamic_disasters", "debug", false, false, false);

-- MCT doesn't support yet specifying in which side of the panel each section goes. So we do this to force all disasters to the right side.
if mct:get_version() == "0.9-beta" or mct:get_version() == "0.9" then
    local section_dummy = mod:add_new_section("dummy1", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy2", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy3", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy4", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy5", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy6", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy7", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy8", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy9", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy10", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy11", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy12", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy13", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy14", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy15", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy16", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy17", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy18", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy19", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy20", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy21", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy22", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy23", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy24", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy25", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy26", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy27", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy28", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy29", ""); section_dummy:set_hidden(true);
    local section_dummy = mod:add_new_section("dummy30", ""); section_dummy:set_hidden(true);
end

-- Disaster loading logic. Add new lines for each new disaster you make.
load_disaster("aztec_invasion", disaster_configs["aztec_invasion"]);
load_disaster("raiding_parties", disaster_configs["raiding_parties"]);
load_disaster("skaven_incursions", disaster_configs["skaven_incursions"]);
load_disaster("the_great_bastion_improved", disaster_configs["the_great_bastion_improved"]);
load_disaster("chianchi_assault", disaster_configs["chianchi_assault"]);
load_disaster("bretonian_crusades", disaster_configs["bretonian_crusades"]);
load_disaster("chaos_invasion", disaster_configs["chaos_invasion"]);
load_disaster("dragon_emperors_wrath", disaster_configs["dragon_emperors_wrath"]);
load_disaster("for_the_motherland", disaster_configs["for_the_motherland"]);
load_disaster("the_greatest_crusade", disaster_configs["the_greatest_crusade"]);
load_disaster("empire_of_steel_and_faith", disaster_configs["empire_of_steel_and_faith"]);
load_disaster("last_stand", disaster_configs["last_stand"]);
load_disaster("realm_divided", disaster_configs["realm_divided"]);
load_disaster("the_vermintide", disaster_configs["the_vermintide"]);
load_disaster("grudge_too_far", disaster_configs["grudge_too_far"]);
load_disaster("pyramid_of_nagash", disaster_configs["pyramid_of_nagash"]);
load_disaster("vampires_rise", disaster_configs["vampires_rise"]);
load_disaster("waaagh", disaster_configs["waaagh"]);
load_disaster("wild_hunt", disaster_configs["wild_hunt"]);
--load_disaster("will_of_hashut", disaster_configs["will_of_hashut"]);

-- Listener to lock/unlock relevant settings if autodifficulty is enabled/disabled.
core:add_listener(
    "automatic_difficulty_locking",
    "MctOptionSelectedSettingSet",
    function(context)
        return context:option():get_key() == "dynamic_disasters_automatic_difficulty_enable"
    end,
    function(context)
        setup_automatic_difficulty(context:option():get_selected_setting());
    end,
    true
);

-- Listener to initialize the MCT menu properly.
-- This includes:
-- - Setting up the initial locked/unlocked state of some options.
-- - In campaign, hiding unavailable disasters.
core:add_listener(
    "automatic_difficulty_locking",
    "MctPanelOpened",
    true,
    function(context)

        -- Setup the automatic difficulty updated values.
        setup_automatic_difficulty(context:mct():get_mod_by_key("dynamic_disasters"):get_option_by_key("dynamic_disasters_automatic_difficulty_enable"):get_selected_setting());

        -- Hide unavailable disasters if we're in a campaign.
        if dynamic_disasters then
            for disaster_name, disaster_section in pairs(disaster_sections) do
                local available = false;
                for _, disaster in ipairs(dynamic_disasters.disasters) do
                    if disaster.name == disaster_name then
                        available = true;
                        break;
                    end
                end

                disaster_section:set_hidden(not available);
            end
        end
    end,
    true
);
