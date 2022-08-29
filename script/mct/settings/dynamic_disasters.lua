local mct = get_mct()
local loc_prefix = "mct_dyn_dis_"

local mod = mct:register_mod("dynamic_disasters")
mod:set_author("Frodo45127")
mod:set_title(loc_prefix.."mod_title", true)
mod:set_description(loc_prefix.."mod_desc", true)

--[[
    Global Config
]]

local section_disasters_global_config = mod:add_new_section("mod_config", loc_prefix.."mod_config", true)
local enable_dynamic_disasters = mod:add_new_option("enable_dynamic_disasters", "checkbox")
enable_dynamic_disasters:set_default_value(true)
enable_dynamic_disasters:set_text(loc_prefix.."enable_dynamic_disasters", true)
enable_dynamic_disasters:set_tooltip_text(loc_prefix.."enable_dynamic_disasters_tooltip", true)


local section_disasters_individual_config = mod:add_new_section("disasters_config", loc_prefix.."disasters_config", true)


--[[
    Aztec Invasion Config
]]
local aztec_invasion_enable = mod:add_new_option("aztec_invasion_enable", "checkbox")
aztec_invasion_enable:set_default_value(true)
aztec_invasion_enable:set_text(loc_prefix.."aztec_invasion_enable", true)
aztec_invasion_enable:set_tooltip_text(loc_prefix.."aztec_invasion_enable_tooltip", true)

local aztec_invasion_min_turn_value = mod:add_new_option("aztec_invasion_min_turn_value", "slider")
aztec_invasion_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
aztec_invasion_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
aztec_invasion_min_turn_value:slider_set_min_max(10, 400)
aztec_invasion_min_turn_value:set_default_value(100)
aztec_invasion_min_turn_value:slider_set_step_size(1)

local aztec_invasion_difficulty_mod = mod:add_new_option("aztec_invasion_difficulty_mod", "slider")
aztec_invasion_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
aztec_invasion_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
aztec_invasion_difficulty_mod:slider_set_min_max(10, 500)
aztec_invasion_difficulty_mod:set_default_value(150)
aztec_invasion_difficulty_mod:slider_set_step_size(1)

--[[
    Raiding Parties Config
]]
local raiding_parties_enable = mod:add_new_option("raiding_parties_enable", "checkbox")
raiding_parties_enable:set_default_value(true)
raiding_parties_enable:set_text(loc_prefix.."raiding_parties_enable", true)
raiding_parties_enable:set_tooltip_text(loc_prefix.."raiding_parties_enable_tooltip", true)

local raiding_parties_min_turn_value = mod:add_new_option("raiding_parties_min_turn_value", "slider")
raiding_parties_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
raiding_parties_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
raiding_parties_min_turn_value:slider_set_min_max(10, 400)
raiding_parties_min_turn_value:set_default_value(30)
raiding_parties_min_turn_value:slider_set_step_size(1)

local raiding_parties_difficulty_mod = mod:add_new_option("raiding_parties_difficulty_mod", "slider")
raiding_parties_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
raiding_parties_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
raiding_parties_difficulty_mod:slider_set_min_max(10, 500)
raiding_parties_difficulty_mod:set_default_value(150)
raiding_parties_difficulty_mod:slider_set_step_size(1)

--[[
    Chi'an Chi Assault Config
]]
local chianchi_assault_enable = mod:add_new_option("chianchi_assault_enable", "checkbox")
chianchi_assault_enable:set_default_value(true)
chianchi_assault_enable:set_text(loc_prefix.."chianchi_assault_enable", true)
chianchi_assault_enable:set_tooltip_text(loc_prefix.."chianchi_assault_enable_tooltip", true)

local chianchi_assault_min_turn_value = mod:add_new_option("chianchi_assault_min_turn_value", "slider")
chianchi_assault_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
chianchi_assault_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
chianchi_assault_min_turn_value:slider_set_min_max(10, 400)
chianchi_assault_min_turn_value:set_default_value(30)   -- This should teach people the Geat Bastion MUST BE DEFENDED.
chianchi_assault_min_turn_value:slider_set_step_size(1)

local chianchi_assault_difficulty_mod = mod:add_new_option("chianchi_assault_difficulty_mod", "slider")
chianchi_assault_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
chianchi_assault_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
chianchi_assault_difficulty_mod:slider_set_min_max(10, 500)
chianchi_assault_difficulty_mod:set_default_value(150)
chianchi_assault_difficulty_mod:slider_set_step_size(1)

--[[
    The Great Uprising Config
]]
local the_great_uprising_enable = mod:add_new_option("the_great_uprising_enable", "checkbox")
the_great_uprising_enable:set_default_value(true)
the_great_uprising_enable:set_text(loc_prefix.."the_great_uprising_enable", true)
the_great_uprising_enable:set_tooltip_text(loc_prefix.."the_great_uprising_enable_tooltip", true)

local the_great_uprising_min_turn_value = mod:add_new_option("the_great_uprising_min_turn_value", "slider")
the_great_uprising_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
the_great_uprising_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
the_great_uprising_min_turn_value:slider_set_min_max(10, 400)
the_great_uprising_min_turn_value:set_default_value(120)
the_great_uprising_min_turn_value:slider_set_step_size(1)

local the_great_uprising_difficulty_mod = mod:add_new_option("the_great_uprising_difficulty_mod", "slider")
the_great_uprising_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
the_great_uprising_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
the_great_uprising_difficulty_mod:slider_set_min_max(10, 500)
the_great_uprising_difficulty_mod:set_default_value(150)
the_great_uprising_difficulty_mod:slider_set_step_size(1)


--[[
    Vanilla Grudge Too Far Config
]]
local grudge_too_far_enable = mod:add_new_option("grudge_too_far_enable", "checkbox")
grudge_too_far_enable:set_default_value(true)
grudge_too_far_enable:set_text(loc_prefix.."grudge_too_far_enable", true)
grudge_too_far_enable:set_tooltip_text(loc_prefix.."grudge_too_far_enable_tooltip", true)

local grudge_too_far_min_turn_value = mod:add_new_option("grudge_too_far_min_turn_value", "slider")
grudge_too_far_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
grudge_too_far_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
grudge_too_far_min_turn_value:slider_set_min_max(10, 400)
grudge_too_far_min_turn_value:set_default_value(100)
grudge_too_far_min_turn_value:slider_set_step_size(1)

local grudge_too_far_difficulty_mod = mod:add_new_option("grudge_too_far_difficulty_mod", "slider")
grudge_too_far_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
grudge_too_far_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
grudge_too_far_difficulty_mod:slider_set_min_max(10, 500)
grudge_too_far_difficulty_mod:set_default_value(150)
grudge_too_far_difficulty_mod:slider_set_step_size(1)

--[[
    Vanilla Pyramid of Nagash Config
]]
local pyramid_of_nagash_enable = mod:add_new_option("pyramid_of_nagash_enable", "checkbox")
pyramid_of_nagash_enable:set_default_value(true)
pyramid_of_nagash_enable:set_text(loc_prefix.."pyramid_of_nagash_enable", true)
pyramid_of_nagash_enable:set_tooltip_text(loc_prefix.."pyramid_of_nagash_enable_tooltip", true)

local pyramid_of_nagash_min_turn_value = mod:add_new_option("pyramid_of_nagash_min_turn_value", "slider")
pyramid_of_nagash_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
pyramid_of_nagash_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
pyramid_of_nagash_min_turn_value:slider_set_min_max(10, 400)
pyramid_of_nagash_min_turn_value:set_default_value(100)
pyramid_of_nagash_min_turn_value:slider_set_step_size(1)

local pyramid_of_nagash_difficulty_mod = mod:add_new_option("pyramid_of_nagash_difficulty_mod", "slider")
pyramid_of_nagash_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
pyramid_of_nagash_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
pyramid_of_nagash_difficulty_mod:slider_set_min_max(10, 500)
pyramid_of_nagash_difficulty_mod:set_default_value(150)
pyramid_of_nagash_difficulty_mod:slider_set_step_size(1)

--[[
    Vanilla Vampires Rise Config
]]
local vampires_rise_enable = mod:add_new_option("vampires_rise_enable", "checkbox")
vampires_rise_enable:set_default_value(true)
vampires_rise_enable:set_text(loc_prefix.."vampires_rise_enable", true)
vampires_rise_enable:set_tooltip_text(loc_prefix.."vampires_rise_enable_tooltip", true)

local vampires_rise_min_turn_value = mod:add_new_option("vampires_rise_min_turn_value", "slider")
vampires_rise_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
vampires_rise_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
vampires_rise_min_turn_value:slider_set_min_max(10, 400)
vampires_rise_min_turn_value:set_default_value(100)
vampires_rise_min_turn_value:slider_set_step_size(1)

local vampires_rise_difficulty_mod = mod:add_new_option("vampires_rise_difficulty_mod", "slider")
vampires_rise_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
vampires_rise_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
vampires_rise_difficulty_mod:slider_set_min_max(10, 500)
vampires_rise_difficulty_mod:set_default_value(150)
vampires_rise_difficulty_mod:slider_set_step_size(1)

--[[
    Vanilla Waaagh Config
]]
local waaagh_enable = mod:add_new_option("waaagh_enable", "checkbox")
waaagh_enable:set_default_value(true)
waaagh_enable:set_text(loc_prefix.."waaagh_enable", true)
waaagh_enable:set_tooltip_text(loc_prefix.."waaagh_enable_tooltip", true)

local waaagh_min_turn_value = mod:add_new_option("waaagh_min_turn_value", "slider")
waaagh_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
waaagh_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
waaagh_min_turn_value:slider_set_min_max(10, 400)
waaagh_min_turn_value:set_default_value(100)
waaagh_min_turn_value:slider_set_step_size(1)

local waaagh_difficulty_mod = mod:add_new_option("waaagh_difficulty_mod", "slider")
waaagh_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
waaagh_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
waaagh_difficulty_mod:slider_set_min_max(10, 500)
waaagh_difficulty_mod:set_default_value(150)
waaagh_difficulty_mod:slider_set_step_size(1)

--[[
    Vanilla Wild Hunt Config
]]
local wild_hunt_enable = mod:add_new_option("wild_hunt_enable", "checkbox")
wild_hunt_enable:set_default_value(true)
wild_hunt_enable:set_text(loc_prefix.."wild_hunt_enable", true)
wild_hunt_enable:set_tooltip_text(loc_prefix.."wild_hunt_enable_tooltip", true)

local wild_hunt_min_turn_value = mod:add_new_option("wild_hunt_min_turn_value", "slider")
wild_hunt_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
wild_hunt_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
wild_hunt_min_turn_value:slider_set_min_max(10, 400)
wild_hunt_min_turn_value:set_default_value(100)
wild_hunt_min_turn_value:slider_set_step_size(1)

local wild_hunt_difficulty_mod = mod:add_new_option("wild_hunt_difficulty_mod", "slider")
wild_hunt_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
wild_hunt_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
wild_hunt_difficulty_mod:slider_set_min_max(10, 500)
wild_hunt_difficulty_mod:set_default_value(150)
wild_hunt_difficulty_mod:slider_set_step_size(1)
