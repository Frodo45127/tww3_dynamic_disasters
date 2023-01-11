local mct = get_mct()
local loc_prefix = "mct_dyn_dis_"

local mod = mct:register_mod("dynamic_disasters")
mod:set_author("Frodo45127")
mod:set_title(loc_prefix.."mod_title", true)
mod:set_description(loc_prefix.."mod_desc", true)

--[[
    Global Config
]]

local disasters_global_config_section = mod:add_new_section("a_mod_config", loc_prefix.."mod_config", true)

local dynamic_disasters_enable = mod:add_new_option("dynamic_disasters_enable", "checkbox")
dynamic_disasters_enable:set_default_value(true)
dynamic_disasters_enable:set_text(loc_prefix.."enable", true)
dynamic_disasters_enable:set_tooltip_text(loc_prefix.."enable_tooltip", true)

local dynamic_disasters_disable_vanilla_endgames = mod:add_new_option("dynamic_disasters_disable_vanilla_endgames", "checkbox")
dynamic_disasters_disable_vanilla_endgames:set_default_value(true)
dynamic_disasters_disable_vanilla_endgames:set_text(loc_prefix.."disable_vanilla_endgames", true)
dynamic_disasters_disable_vanilla_endgames:set_tooltip_text(loc_prefix.."disable_vanilla_endgames_tooltip", true)

local dynamic_disasters_automatic_difficulty_enable = mod:add_new_option("dynamic_disasters_automatic_difficulty_enable", "checkbox")
dynamic_disasters_automatic_difficulty_enable:set_default_value(true)
dynamic_disasters_automatic_difficulty_enable:set_text(loc_prefix.."automatic_difficulty_enable", true)
dynamic_disasters_automatic_difficulty_enable:set_tooltip_text(loc_prefix.."automatic_difficulty_enable_tooltip", true)

local dynamic_disasters_max_simul = mod:add_new_option("dynamic_disasters_max_simul", "slider")
dynamic_disasters_max_simul:set_text(loc_prefix.."max_simul", true)
dynamic_disasters_max_simul:set_tooltip_text(loc_prefix.."max_simul_tooltip", true)
dynamic_disasters_max_simul:slider_set_min_max(1, 50)
dynamic_disasters_max_simul:set_default_value(3)
dynamic_disasters_max_simul:slider_set_step_size(1)

local dynamic_disasters_max_total_endgames = mod:add_new_option("dynamic_disasters_max_total_endgames", "slider")
dynamic_disasters_max_total_endgames:set_text(loc_prefix.."max_total_endgames", true)
dynamic_disasters_max_total_endgames:set_tooltip_text(loc_prefix.."max_total_endgames_tooltip", true)
dynamic_disasters_max_total_endgames:slider_set_min_max(1, 50)
dynamic_disasters_max_total_endgames:set_default_value(3)
dynamic_disasters_max_total_endgames:slider_set_step_size(1)

local dynamic_disasters_debug = mod:add_new_option("dynamic_disasters_debug", "checkbox")
dynamic_disasters_debug:set_default_value(false)
dynamic_disasters_debug:set_text(loc_prefix.."debug", true)
dynamic_disasters_debug:set_tooltip_text(loc_prefix.."debug_tooltip", true)

local disasters_individual_config_section = mod:add_new_section("z_disasters_config", loc_prefix.."disasters_config", true)


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
aztec_invasion_min_turn_value:slider_set_step_size(10)

local aztec_invasion_max_turn_value = mod:add_new_option("aztec_invasion_max_turn_value", "slider")
aztec_invasion_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
aztec_invasion_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
aztec_invasion_max_turn_value:slider_set_min_max(0, 600)
aztec_invasion_max_turn_value:set_default_value(0)
aztec_invasion_max_turn_value:slider_set_step_size(10)

local aztec_invasion_difficulty_mod = mod:add_new_option("aztec_invasion_difficulty_mod", "slider")
aztec_invasion_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
aztec_invasion_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
aztec_invasion_difficulty_mod:slider_set_min_max(10, 500)
aztec_invasion_difficulty_mod:set_default_value(150)
aztec_invasion_difficulty_mod:slider_set_step_size(10)

local aztec_invasion_enable_diplomacy = mod:add_new_option("aztec_invasion_enable_diplomacy", "checkbox")
aztec_invasion_enable_diplomacy:set_default_value(false)
aztec_invasion_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
aztec_invasion_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local d = mod:add_new_option("d2", "dummy")
d:set_text(" ");

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
raiding_parties_min_turn_value:slider_set_step_size(10)

local raiding_parties_difficulty_mod = mod:add_new_option("raiding_parties_difficulty_mod", "slider")
raiding_parties_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
raiding_parties_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
raiding_parties_difficulty_mod:slider_set_min_max(10, 500)
raiding_parties_difficulty_mod:set_default_value(150)
raiding_parties_difficulty_mod:slider_set_step_size(10)

--[[
    Skaven Incursions Config
]]
local skaven_incursions_enable = mod:add_new_option("skaven_incursions_enable", "checkbox")
skaven_incursions_enable:set_default_value(true)
skaven_incursions_enable:set_text(loc_prefix.."skaven_incursions_enable", true)
skaven_incursions_enable:set_tooltip_text(loc_prefix.."skaven_incursions_enable_tooltip", true)

local skaven_incursions_min_turn_value = mod:add_new_option("skaven_incursions_min_turn_value", "slider")
skaven_incursions_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
skaven_incursions_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
skaven_incursions_min_turn_value:slider_set_min_max(10, 400)
skaven_incursions_min_turn_value:set_default_value(30)
skaven_incursions_min_turn_value:slider_set_step_size(10)

local skaven_incursions_difficulty_mod = mod:add_new_option("skaven_incursions_difficulty_mod", "slider")
skaven_incursions_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
skaven_incursions_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
skaven_incursions_difficulty_mod:slider_set_min_max(10, 500)
skaven_incursions_difficulty_mod:set_default_value(150)
skaven_incursions_difficulty_mod:slider_set_step_size(10)

local skaven_incursions_critical_mass = mod:add_new_option("skaven_incursions_critical_mass", "slider")
skaven_incursions_critical_mass:set_text(loc_prefix.."skaven_incursions_critical_mass", true)
skaven_incursions_critical_mass:set_tooltip_text(loc_prefix.."skaven_incursions_critical_mass_tooltip", true)
skaven_incursions_critical_mass:slider_set_min_max(5, 50)
skaven_incursions_critical_mass:set_default_value(15)
skaven_incursions_critical_mass:slider_set_step_size(1)

local d = mod:add_new_option("d432", "dummy")
d:set_text(" ");

local d = mod:add_new_option("d433", "dummy")
d:set_text(" ");
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
chianchi_assault_min_turn_value:slider_set_step_size(10)

local chianchi_assault_difficulty_mod = mod:add_new_option("chianchi_assault_difficulty_mod", "slider")
chianchi_assault_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
chianchi_assault_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
chianchi_assault_difficulty_mod:slider_set_min_max(10, 500)
chianchi_assault_difficulty_mod:set_default_value(150)
chianchi_assault_difficulty_mod:slider_set_step_size(10)

--[[
    The Great Ascendancy Config
]]
local the_great_uprising_enable = mod:add_new_option("the_great_uprising_enable", "checkbox")
the_great_uprising_enable:set_default_value(false)
the_great_uprising_enable:set_text(loc_prefix.."the_great_uprising_enable", true)
the_great_uprising_enable:set_tooltip_text(loc_prefix.."the_great_uprising_enable_tooltip", true)

local the_great_uprising_min_turn_value = mod:add_new_option("the_great_uprising_min_turn_value", "slider")
the_great_uprising_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
the_great_uprising_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
the_great_uprising_min_turn_value:slider_set_min_max(13, 390)
the_great_uprising_min_turn_value:set_default_value(130)
the_great_uprising_min_turn_value:slider_set_step_size(13)

local the_great_uprising_max_turn_value = mod:add_new_option("the_great_uprising_max_turn_value", "slider")
the_great_uprising_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
the_great_uprising_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
the_great_uprising_max_turn_value:slider_set_min_max(0, 600)
the_great_uprising_max_turn_value:set_default_value(0)
the_great_uprising_max_turn_value:slider_set_step_size(13)

local the_great_uprising_difficulty_mod = mod:add_new_option("the_great_uprising_difficulty_mod", "slider")
the_great_uprising_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
the_great_uprising_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
the_great_uprising_difficulty_mod:slider_set_min_max(10, 500)
the_great_uprising_difficulty_mod:set_default_value(150)
the_great_uprising_difficulty_mod:slider_set_step_size(13)
local d = mod:add_new_option("d3", "dummy")
d:set_text(" ");

local d = mod:add_new_option("d4", "dummy")
d:set_text(" ");

--[[
    Chaos Invasion Config
]]
local chaos_invasion_enable = mod:add_new_option("chaos_invasion_enable", "checkbox")
chaos_invasion_enable:set_default_value(true)
chaos_invasion_enable:set_text(loc_prefix.."chaos_invasion_enable", true)
chaos_invasion_enable:set_tooltip_text(loc_prefix.."chaos_invasion_enable_tooltip", true)

local chaos_invasion_min_turn_value = mod:add_new_option("chaos_invasion_min_turn_value", "slider")
chaos_invasion_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
chaos_invasion_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
chaos_invasion_min_turn_value:slider_set_min_max(10, 400)
chaos_invasion_min_turn_value:set_default_value(100)
chaos_invasion_min_turn_value:slider_set_step_size(10)

local chaos_invasion_max_turn_value = mod:add_new_option("chaos_invasion_max_turn_value", "slider")
chaos_invasion_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
chaos_invasion_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
chaos_invasion_max_turn_value:slider_set_min_max(0, 600)
chaos_invasion_max_turn_value:set_default_value(0)
chaos_invasion_max_turn_value:slider_set_step_size(10)

local chaos_invasion_difficulty_mod = mod:add_new_option("chaos_invasion_difficulty_mod", "slider")
chaos_invasion_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
chaos_invasion_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
chaos_invasion_difficulty_mod:slider_set_min_max(10, 500)
chaos_invasion_difficulty_mod:set_default_value(150)
chaos_invasion_difficulty_mod:slider_set_step_size(10)

local chaos_invasion_enable_rifts = mod:add_new_option("chaos_invasion_enable_rifts", "checkbox")
chaos_invasion_enable_rifts:set_default_value(true)
chaos_invasion_enable_rifts:set_text(loc_prefix.."chaos_invasion_enable_rifts", true)
chaos_invasion_enable_rifts:set_tooltip_text(loc_prefix.."chaos_invasion_enable_rifts_tooltip", true)

local d = mod:add_new_option("d98", "dummy")
d:set_text(" ");


--[[
    Last Stand Config
]]
local last_stance_enable = mod:add_new_option("last_stance_enable", "checkbox")
last_stance_enable:set_default_value(true)
last_stance_enable:set_text(loc_prefix.."last_stance_enable", true)
last_stance_enable:set_tooltip_text(loc_prefix.."last_stance_enable_tooltip", true)

local last_stance_difficulty_mod = mod:add_new_option("last_stance_difficulty_mod", "slider")
last_stance_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
last_stance_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
last_stance_difficulty_mod:slider_set_min_max(10, 500)
last_stance_difficulty_mod:set_default_value(150)
last_stance_difficulty_mod:slider_set_step_size(10)

local d = mod:add_new_option("dd97", "dummy")
d:set_text(" ");

--[[
    Realm Divided Config
]]
local realm_divided_enable = mod:add_new_option("realm_divided_enable", "checkbox")
realm_divided_enable:set_default_value(true)
realm_divided_enable:set_text(loc_prefix.."realm_divided_enable", true)
realm_divided_enable:set_tooltip_text(loc_prefix.."realm_divided_enable_tooltip", true)

local realm_divided_difficulty_mod = mod:add_new_option("realm_divided_difficulty_mod", "slider")
realm_divided_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
realm_divided_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
realm_divided_difficulty_mod:slider_set_min_max(10, 500)
realm_divided_difficulty_mod:set_default_value(150)
realm_divided_difficulty_mod:slider_set_step_size(10)

local d = mod:add_new_option("dddd97", "dummy")
d:set_text(" ");

--[[
    The Vermintide Config
]]
local the_vermintide_enable = mod:add_new_option("the_vermintide_enable", "checkbox")
the_vermintide_enable:set_default_value(true)
the_vermintide_enable:set_text(loc_prefix.."the_vermintide_enable", true)
the_vermintide_enable:set_tooltip_text(loc_prefix.."the_vermintide_enable_tooltip", true)

local the_vermintide_min_turn_value = mod:add_new_option("the_vermintide_min_turn_value", "slider")
the_vermintide_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
the_vermintide_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
the_vermintide_min_turn_value:slider_set_min_max(13, 390)
the_vermintide_min_turn_value:set_default_value(130)
the_vermintide_min_turn_value:slider_set_step_size(13)

local the_vermintide_max_turn_value = mod:add_new_option("the_vermintide_max_turn_value", "slider")
the_vermintide_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
the_vermintide_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
the_vermintide_max_turn_value:slider_set_min_max(0, 600)
the_vermintide_max_turn_value:set_default_value(0)
the_vermintide_max_turn_value:slider_set_step_size(13)

local the_vermintide_difficulty_mod = mod:add_new_option("the_vermintide_difficulty_mod", "slider")
the_vermintide_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
the_vermintide_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
the_vermintide_difficulty_mod:slider_set_min_max(10, 500)
the_vermintide_difficulty_mod:set_default_value(150)
the_vermintide_difficulty_mod:slider_set_step_size(13)

local the_vermintide_enable_diplomacy = mod:add_new_option("the_vermintide_enable_diplomacy", "checkbox")
the_vermintide_enable_diplomacy:set_default_value(false)
the_vermintide_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
the_vermintide_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local d = mod:add_new_option("d112", "dummy")
d:set_text(" ");

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
grudge_too_far_min_turn_value:slider_set_step_size(10)

local grudge_too_far_max_turn_value = mod:add_new_option("grudge_too_far_max_turn_value", "slider")
grudge_too_far_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
grudge_too_far_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
grudge_too_far_max_turn_value:slider_set_min_max(0, 600)
grudge_too_far_max_turn_value:set_default_value(0)
grudge_too_far_max_turn_value:slider_set_step_size(10)

local grudge_too_far_difficulty_mod = mod:add_new_option("grudge_too_far_difficulty_mod", "slider")
grudge_too_far_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
grudge_too_far_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
grudge_too_far_difficulty_mod:slider_set_min_max(10, 500)
grudge_too_far_difficulty_mod:set_default_value(150)
grudge_too_far_difficulty_mod:slider_set_step_size(10)

local grudge_too_far_enable_diplomacy = mod:add_new_option("grudge_too_far_enable_diplomacy", "checkbox")
grudge_too_far_enable_diplomacy:set_default_value(false)
grudge_too_far_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
grudge_too_far_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local d = mod:add_new_option("d6", "dummy")
d:set_text(" ");

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
pyramid_of_nagash_min_turn_value:slider_set_step_size(10)

local pyramid_of_nagash_max_turn_value = mod:add_new_option("pyramid_of_nagash_max_turn_value", "slider")
pyramid_of_nagash_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
pyramid_of_nagash_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
pyramid_of_nagash_max_turn_value:slider_set_min_max(0, 600)
pyramid_of_nagash_max_turn_value:set_default_value(0)
pyramid_of_nagash_max_turn_value:slider_set_step_size(10)

local pyramid_of_nagash_difficulty_mod = mod:add_new_option("pyramid_of_nagash_difficulty_mod", "slider")
pyramid_of_nagash_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
pyramid_of_nagash_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
pyramid_of_nagash_difficulty_mod:slider_set_min_max(10, 500)
pyramid_of_nagash_difficulty_mod:set_default_value(150)
pyramid_of_nagash_difficulty_mod:slider_set_step_size(10)

local pyramid_of_nagash_enable_diplomacy = mod:add_new_option("pyramid_of_nagash_enable_diplomacy", "checkbox")
pyramid_of_nagash_enable_diplomacy:set_default_value(false)
pyramid_of_nagash_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
pyramid_of_nagash_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local d = mod:add_new_option("d8", "dummy")
d:set_text(" ");

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
vampires_rise_min_turn_value:slider_set_step_size(10)

local vampires_rise_max_turn_value = mod:add_new_option("vampires_rise_max_turn_value", "slider")
vampires_rise_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
vampires_rise_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
vampires_rise_max_turn_value:slider_set_min_max(0, 600)
vampires_rise_max_turn_value:set_default_value(0)
vampires_rise_max_turn_value:slider_set_step_size(10)

local vampires_rise_difficulty_mod = mod:add_new_option("vampires_rise_difficulty_mod", "slider")
vampires_rise_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
vampires_rise_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
vampires_rise_difficulty_mod:slider_set_min_max(10, 500)
vampires_rise_difficulty_mod:set_default_value(150)
vampires_rise_difficulty_mod:slider_set_step_size(10)

local vampires_rise_revive_dead_factions = mod:add_new_option("vampires_rise_revive_dead_factions", "checkbox")
vampires_rise_revive_dead_factions:set_default_value(true)
vampires_rise_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
vampires_rise_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local vampires_rise_enable_diplomacy = mod:add_new_option("vampires_rise_enable_diplomacy", "checkbox")
vampires_rise_enable_diplomacy:set_default_value(false)
vampires_rise_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
vampires_rise_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

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
waaagh_min_turn_value:slider_set_step_size(10)

local waaagh_max_turn_value = mod:add_new_option("waaagh_max_turn_value", "slider")
waaagh_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
waaagh_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
waaagh_max_turn_value:slider_set_min_max(0, 600)
waaagh_max_turn_value:set_default_value(0)
waaagh_max_turn_value:slider_set_step_size(10)

local waaagh_difficulty_mod = mod:add_new_option("waaagh_difficulty_mod", "slider")
waaagh_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
waaagh_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
waaagh_difficulty_mod:slider_set_min_max(10, 500)
waaagh_difficulty_mod:set_default_value(150)
waaagh_difficulty_mod:slider_set_step_size(10)

local waaagh_enable_diplomacy = mod:add_new_option("waaagh_enable_diplomacy", "checkbox")
waaagh_enable_diplomacy:set_default_value(false)
waaagh_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
waaagh_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local d = mod:add_new_option("d12", "dummy")
d:set_text(" ");

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
wild_hunt_min_turn_value:slider_set_step_size(10)

local wild_hunt_max_turn_value = mod:add_new_option("wild_hunt_max_turn_value", "slider")
wild_hunt_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
wild_hunt_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
wild_hunt_max_turn_value:slider_set_min_max(0, 600)
wild_hunt_max_turn_value:set_default_value(0)
wild_hunt_max_turn_value:slider_set_step_size(10)

local wild_hunt_difficulty_mod = mod:add_new_option("wild_hunt_difficulty_mod", "slider")
wild_hunt_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
wild_hunt_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
wild_hunt_difficulty_mod:slider_set_min_max(10, 500)
wild_hunt_difficulty_mod:set_default_value(150)
wild_hunt_difficulty_mod:slider_set_step_size(10)

local wild_hunt_revive_dead_factions = mod:add_new_option("wild_hunt_revive_dead_factions", "checkbox")
wild_hunt_revive_dead_factions:set_default_value(true)
wild_hunt_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
wild_hunt_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local wild_hunt_enable_diplomacy = mod:add_new_option("wild_hunt_enable_diplomacy", "checkbox")
wild_hunt_enable_diplomacy:set_default_value(false)
wild_hunt_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
wild_hunt_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)
