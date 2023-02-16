--[[-------------------------------------------------------------------------------------------------------------
    Script by Frodo45127 for the Dynamic Disasters mod.

    MCT Module, with support for both, MCT Legacy (for now) and MCT 0.9.
]]---------------------------------------------------------------------------------------------------------------

--- This table holds all the information to build all the options on the MCT for both, the mod and all the official disasters.
--- What data is stored depends on the editor type:
--- - Checkbox: a boolean.
--- - Slider: A table with (in this order) default value, minimum value, maximum value and step size.
disaster_configs = {
    aztec_invasion = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    raiding_parties = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    skaven_incursions = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},

        critical_mass = {
            setting_type = "slider",
            setting_data = {15, 5, 50, 1},
        },
    },
    chianchi_assault = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    bretonian_crusades = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 10, 400, 10},
    },
    chaos_invasion = {
        enable = true,
        revive_dead_factions = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,

        enable_rifts = {
            setting_type = "checkbox",
            setting_data = true,
        },
    },
    dragon_emperors_wrath = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    for_the_motherland = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    the_greatest_crusade = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    empire_of_steel_and_faith = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    last_stand = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {30, 1, 400, 5},
    },
    realm_divided = {
        enable = true,
        difficulty_mod = {150, 10, 500, 10},
    },
    the_vermintide = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 13},
        min_turn_value = {130, 13, 390, 13},
        max_turn_value = {0, 0, 600, 13},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    grudge_too_far = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    pyramid_of_nagash = {
        enable = true,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    vampires_rise = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    waaagh = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
    wild_hunt = {
        enable = true,
        revive_dead_factions = false,
        enable_diplomacy = false,
        difficulty_mod = {150, 10, 500, 10},
        min_turn_value = {100, 10, 400, 10},
        max_turn_value = {0, 0, 600, 10},
        short_victory_is_min_turn = false,
        long_victory_is_min_turn = true,
    },
};

local loc_prefix = "mct_dyn_dis_";
local mct = get_mct()
local mod = mct:register_mod("dynamic_disasters");

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
        use_disaster_name_in_loc_key = true
    },
    {
        key = "revive_dead_factions",
        value = "checkbox",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "enable_diplomacy",
        value = "checkbox",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "difficulty_mod",
        value = "slider",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "min_turn_value",
        value = "slider",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "max_turn_value",
        value = "slider",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "short_victory_is_min_turn",
        value = "checkbox",
        use_disaster_name_in_loc_key = false
    },
    {
        key = "long_victory_is_min_turn",
        value = "checkbox",
        use_disaster_name_in_loc_key = false
    },
}

--- Function to load checkbox settings.
---@param disaster_name string #Key of the disaster.
---@param setting_key string #Key of the setting we're loading.
---@param default_value boolean #Default value of the setting we're loading.
---@param use_disaster_name_in_loc_key boolean #If the loc key contains the disaster name.
function load_checkbox(disaster_name, setting_key, default_value, use_disaster_name_in_loc_key)
    out("loading setting_key");
    local setting = mod:add_new_option(disaster_name .. "_" .. setting_key, "checkbox")
    setting:set_default_value(default_value)

    if use_disaster_name_in_loc_key == true then
        setting:set_text(loc_prefix .. disaster_name .. "_" .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. disaster_name .. "_" .. setting_key .. "_tooltip", true)
    else
        setting:set_text(loc_prefix .. setting_key, true)
        setting:set_tooltip_text(loc_prefix .. setting_key .. "_tooltip", true)
    end
end

--- Function to load checkbox settings.
---@param disaster_name string #Key of the disaster.
---@param setting_key string #Key of the setting we're loading.
---@param slider_data table #Indexed table with the data for the slider in this order: "default value, min, max, step side.
---@param use_disaster_name_in_loc_key boolean #If the loc key contains the disaster name.
function load_slider(disaster_name, setting_key, slider_data, use_disaster_name_in_loc_key)
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
    end

    -- Load generic settings.
    local dummy_index = 0;
    for _, setting in ipairs(generic_settings) do
        local setting_key = setting["key"];
        local setting_type = setting["value"];
        local use_disaster_name_in_loc_key = setting["use_disaster_name_in_loc_key"];

        if disaster_data[setting_key] ~= nil then
            if setting_type == "checkbox" then
                load_checkbox(disaster_name, setting_key, disaster_data[setting_key], use_disaster_name_in_loc_key);
            elseif setting_type == "slider" then
                load_slider(disaster_name, setting_key, disaster_data[setting_key], use_disaster_name_in_loc_key);
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
                load_checkbox(disaster_name, setting_key, setting_data["setting_data"], true);
            elseif setting_data["setting_type"] == "slider" then
                load_slider(disaster_name, setting_key, setting_data["setting_data"], true);
            end
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
    mod:set_version("1.0");
    mod:set_main_image("ui/mct/dynamic_disasters.png", 300, 300)
end

-- Global config section.

local disasters_global_config_section = mod:add_new_section("a_mod_config", loc_prefix.."mod_config", true)
if mct:get_version() == "0.9-beta" or mct:get_version() == "0.9" then
    disasters_global_config_section:set_is_collapsible(true)
    disasters_global_config_section:set_visibility(true)
end

load_checkbox("dynamic_disasters", "enable", true, false);
load_checkbox("dynamic_disasters", "disable_vanilla_endgames", true, false);
load_checkbox("dynamic_disasters", "automatic_difficulty_enable", true, false);
load_slider("dynamic_disasters", "max_simul", {3, 1, 50, 1}, false);
load_slider("dynamic_disasters", "max_total_endgames", {3, 1, 50, 1}, false);
load_checkbox("dynamic_disasters", "debug", false, false);

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
end

-- Disaster loading logic. Add new lines for each new disaster you make.
load_disaster("aztec_invasion", disaster_configs["aztec_invasion"]);
load_disaster("raiding_parties", disaster_configs["raiding_parties"]);
load_disaster("skaven_incursions", disaster_configs["skaven_incursions"]);
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
