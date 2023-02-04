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


--[[
    Aztec Invasion Config
]]
local disasters_individual_config_section_aztec_invasion = mod:add_new_section("aztec_invasion", loc_prefix.."aztec_invasion_config", true)
local aztec_invasion_enable = mod:add_new_option("aztec_invasion_enable", "checkbox")
aztec_invasion_enable:set_default_value(true)
aztec_invasion_enable:set_text(loc_prefix.."aztec_invasion_enable", true)
aztec_invasion_enable:set_tooltip_text(loc_prefix.."aztec_invasion_enable_tooltip", true)

local aztec_invasion_revive_dead_factions = mod:add_new_option("aztec_invasion_revive_dead_factions", "checkbox")
aztec_invasion_revive_dead_factions:set_default_value(true)
aztec_invasion_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
aztec_invasion_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local aztec_invasion_enable_diplomacy = mod:add_new_option("aztec_invasion_enable_diplomacy", "checkbox")
aztec_invasion_enable_diplomacy:set_default_value(false)
aztec_invasion_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
aztec_invasion_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local aztec_invasion_difficulty_mod = mod:add_new_option("aztec_invasion_difficulty_mod", "slider")
aztec_invasion_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
aztec_invasion_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
aztec_invasion_difficulty_mod:slider_set_min_max(10, 500)
aztec_invasion_difficulty_mod:set_default_value(150)
aztec_invasion_difficulty_mod:slider_set_step_size(10)

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

local aztec_invasion_short_victory_is_min_turn = mod:add_new_option("aztec_invasion_short_victory_is_min_turn", "checkbox")
aztec_invasion_short_victory_is_min_turn:set_default_value(false)
aztec_invasion_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
aztec_invasion_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local aztec_invasion_long_victory_is_min_turn = mod:add_new_option("aztec_invasion_long_victory_is_min_turn", "checkbox")
aztec_invasion_long_victory_is_min_turn:set_default_value(true)
aztec_invasion_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
aztec_invasion_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Raiding Parties Config
]]
local disasters_individual_config_section_raiding_parties = mod:add_new_section("raiding_parties", loc_prefix.."raiding_parties_config", true)
local raiding_parties_enable = mod:add_new_option("raiding_parties_enable", "checkbox")
raiding_parties_enable:set_default_value(true)
raiding_parties_enable:set_text(loc_prefix.."raiding_parties_enable", true)
raiding_parties_enable:set_tooltip_text(loc_prefix.."raiding_parties_enable_tooltip", true)

local d = mod:add_new_option("d43299", "dummy")
d:set_text(" ");

local d = mod:add_new_option("d43388", "dummy")
d:set_text(" ");

local raiding_parties_difficulty_mod = mod:add_new_option("raiding_parties_difficulty_mod", "slider")
raiding_parties_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
raiding_parties_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
raiding_parties_difficulty_mod:slider_set_min_max(10, 500)
raiding_parties_difficulty_mod:set_default_value(150)
raiding_parties_difficulty_mod:slider_set_step_size(10)

local raiding_parties_min_turn_value = mod:add_new_option("raiding_parties_min_turn_value", "slider")
raiding_parties_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
raiding_parties_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
raiding_parties_min_turn_value:slider_set_min_max(10, 400)
raiding_parties_min_turn_value:set_default_value(30)
raiding_parties_min_turn_value:slider_set_step_size(10)

--[[
    Skaven Incursions Config
]]
local disasters_individual_config_section_skaven_incursions = mod:add_new_section("skaven_incursions", loc_prefix.."skaven_incursions_config", true)
local skaven_incursions_enable = mod:add_new_option("skaven_incursions_enable", "checkbox")
skaven_incursions_enable:set_default_value(true)
skaven_incursions_enable:set_text(loc_prefix.."skaven_incursions_enable", true)
skaven_incursions_enable:set_tooltip_text(loc_prefix.."skaven_incursions_enable_tooltip", true)

local d = mod:add_new_option("d432", "dummy")
d:set_text(" ");

local d = mod:add_new_option("d433", "dummy")
d:set_text(" ");

local skaven_incursions_difficulty_mod = mod:add_new_option("skaven_incursions_difficulty_mod", "slider")
skaven_incursions_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
skaven_incursions_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
skaven_incursions_difficulty_mod:slider_set_min_max(10, 500)
skaven_incursions_difficulty_mod:set_default_value(150)
skaven_incursions_difficulty_mod:slider_set_step_size(10)

local skaven_incursions_min_turn_value = mod:add_new_option("skaven_incursions_min_turn_value", "slider")
skaven_incursions_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
skaven_incursions_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
skaven_incursions_min_turn_value:slider_set_min_max(10, 400)
skaven_incursions_min_turn_value:set_default_value(30)
skaven_incursions_min_turn_value:slider_set_step_size(10)

local skaven_incursions_critical_mass = mod:add_new_option("skaven_incursions_critical_mass", "slider")
skaven_incursions_critical_mass:set_text(loc_prefix.."skaven_incursions_critical_mass", true)
skaven_incursions_critical_mass:set_tooltip_text(loc_prefix.."skaven_incursions_critical_mass_tooltip", true)
skaven_incursions_critical_mass:slider_set_min_max(5, 50)
skaven_incursions_critical_mass:set_default_value(15)
skaven_incursions_critical_mass:slider_set_step_size(1)

--[[
    Chi'an Chi Assault Config
]]
local disasters_individual_config_section_chianchi_assault = mod:add_new_section("chianchi_assault", loc_prefix.."chianchi_assault_config", true)
local chianchi_assault_enable = mod:add_new_option("chianchi_assault_enable", "checkbox")
chianchi_assault_enable:set_default_value(true)
chianchi_assault_enable:set_text(loc_prefix.."chianchi_assault_enable", true)
chianchi_assault_enable:set_tooltip_text(loc_prefix.."chianchi_assault_enable_tooltip", true)

local d = mod:add_new_option("d4322", "dummy")
d:set_text(" ");

local d = mod:add_new_option("d4331", "dummy")
d:set_text(" ");

local chianchi_assault_difficulty_mod = mod:add_new_option("chianchi_assault_difficulty_mod", "slider")
chianchi_assault_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
chianchi_assault_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
chianchi_assault_difficulty_mod:slider_set_min_max(10, 500)
chianchi_assault_difficulty_mod:set_default_value(150)
chianchi_assault_difficulty_mod:slider_set_step_size(10)

local chianchi_assault_min_turn_value = mod:add_new_option("chianchi_assault_min_turn_value", "slider")
chianchi_assault_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
chianchi_assault_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
chianchi_assault_min_turn_value:slider_set_min_max(10, 400)
chianchi_assault_min_turn_value:set_default_value(30)   -- This should teach people the Geat Bastion MUST BE DEFENDED.
chianchi_assault_min_turn_value:slider_set_step_size(10)


--[[
    Chaos Invasion Config
]]
local disasters_individual_config_section_chaos_invasion = mod:add_new_section("chaos_invasion", loc_prefix.."chaos_invasion_config", true)
local chaos_invasion_enable = mod:add_new_option("chaos_invasion_enable", "checkbox")
chaos_invasion_enable:set_default_value(true)
chaos_invasion_enable:set_text(loc_prefix.."chaos_invasion_enable", true)
chaos_invasion_enable:set_tooltip_text(loc_prefix.."chaos_invasion_enable_tooltip", true)

local chaos_invasion_revive_dead_factions = mod:add_new_option("chaos_invasion_revive_dead_factions", "checkbox")
chaos_invasion_revive_dead_factions:set_default_value(true)
chaos_invasion_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
chaos_invasion_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local chaos_invasion_enable_rifts = mod:add_new_option("chaos_invasion_enable_rifts", "checkbox")
chaos_invasion_enable_rifts:set_default_value(true)
chaos_invasion_enable_rifts:set_text(loc_prefix.."chaos_invasion_enable_rifts", true)
chaos_invasion_enable_rifts:set_tooltip_text(loc_prefix.."chaos_invasion_enable_rifts_tooltip", true)

local chaos_invasion_difficulty_mod = mod:add_new_option("chaos_invasion_difficulty_mod", "slider")
chaos_invasion_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
chaos_invasion_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
chaos_invasion_difficulty_mod:slider_set_min_max(10, 500)
chaos_invasion_difficulty_mod:set_default_value(150)
chaos_invasion_difficulty_mod:slider_set_step_size(10)

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

local chaos_invasion_short_victory_is_min_turn = mod:add_new_option("chaos_invasion_short_victory_is_min_turn", "checkbox")
chaos_invasion_short_victory_is_min_turn:set_default_value(false)
chaos_invasion_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
chaos_invasion_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local chaos_invasion_long_victory_is_min_turn = mod:add_new_option("chaos_invasion_long_victory_is_min_turn", "checkbox")
chaos_invasion_long_victory_is_min_turn:set_default_value(true)
chaos_invasion_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
chaos_invasion_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Dragon Emperor's Wrath Config
]]
local disasters_individual_config_section_dragon_emperors_wrath = mod:add_new_section("dragon_emperors_wrath", loc_prefix.."dragon_emperors_wrath_config", true)
local dragon_emperors_wrath_enable = mod:add_new_option("dragon_emperors_wrath_enable", "checkbox")
dragon_emperors_wrath_enable:set_default_value(true)
dragon_emperors_wrath_enable:set_text(loc_prefix.."dragon_emperors_wrath_enable", true)
dragon_emperors_wrath_enable:set_tooltip_text(loc_prefix.."dragon_emperors_wrath_enable_tooltip", true)

local dragon_emperors_wrath_revive_dead_factions = mod:add_new_option("dragon_emperors_wrath_revive_dead_factions", "checkbox")
dragon_emperors_wrath_revive_dead_factions:set_default_value(true)
dragon_emperors_wrath_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
dragon_emperors_wrath_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local dragon_emperors_wrath_enable_diplomacy = mod:add_new_option("dragon_emperors_wrath_enable_diplomacy", "checkbox")
dragon_emperors_wrath_enable_diplomacy:set_default_value(false)
dragon_emperors_wrath_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
dragon_emperors_wrath_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local dragon_emperors_wrath_difficulty_mod = mod:add_new_option("dragon_emperors_wrath_difficulty_mod", "slider")
dragon_emperors_wrath_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
dragon_emperors_wrath_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
dragon_emperors_wrath_difficulty_mod:slider_set_min_max(10, 500)
dragon_emperors_wrath_difficulty_mod:set_default_value(150)
dragon_emperors_wrath_difficulty_mod:slider_set_step_size(10)

local dragon_emperors_wrath_min_turn_value = mod:add_new_option("dragon_emperors_wrath_min_turn_value", "slider")
dragon_emperors_wrath_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
dragon_emperors_wrath_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
dragon_emperors_wrath_min_turn_value:slider_set_min_max(10, 400)
dragon_emperors_wrath_min_turn_value:set_default_value(100)
dragon_emperors_wrath_min_turn_value:slider_set_step_size(10)

local dragon_emperors_wrath_max_turn_value = mod:add_new_option("dragon_emperors_wrath_max_turn_value", "slider")
dragon_emperors_wrath_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
dragon_emperors_wrath_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
dragon_emperors_wrath_max_turn_value:slider_set_min_max(0, 600)
dragon_emperors_wrath_max_turn_value:set_default_value(0)
dragon_emperors_wrath_max_turn_value:slider_set_step_size(10)

local dragon_emperors_wrath_short_victory_is_min_turn = mod:add_new_option("dragon_emperors_wrath_short_victory_is_min_turn", "checkbox")
dragon_emperors_wrath_short_victory_is_min_turn:set_default_value(false)
dragon_emperors_wrath_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
dragon_emperors_wrath_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local dragon_emperors_wrath_long_victory_is_min_turn = mod:add_new_option("dragon_emperors_wrath_long_victory_is_min_turn", "checkbox")
dragon_emperors_wrath_long_victory_is_min_turn:set_default_value(true)
dragon_emperors_wrath_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
dragon_emperors_wrath_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    For The Motherland Config
]]
local disasters_individual_config_section_for_the_motherland = mod:add_new_section("for_the_motherland", loc_prefix.."for_the_motherland_config", true)
local for_the_motherland_enable = mod:add_new_option("for_the_motherland_enable", "checkbox")
for_the_motherland_enable:set_default_value(true)
for_the_motherland_enable:set_text(loc_prefix.."for_the_motherland_enable", true)
for_the_motherland_enable:set_tooltip_text(loc_prefix.."for_the_motherland_enable_tooltip", true)

local for_the_motherland_revive_dead_factions = mod:add_new_option("for_the_motherland_revive_dead_factions", "checkbox")
for_the_motherland_revive_dead_factions:set_default_value(true)
for_the_motherland_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
for_the_motherland_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local for_the_motherland_enable_diplomacy = mod:add_new_option("for_the_motherland_enable_diplomacy", "checkbox")
for_the_motherland_enable_diplomacy:set_default_value(false)
for_the_motherland_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
for_the_motherland_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local for_the_motherland_difficulty_mod = mod:add_new_option("for_the_motherland_difficulty_mod", "slider")
for_the_motherland_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
for_the_motherland_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
for_the_motherland_difficulty_mod:slider_set_min_max(10, 500)
for_the_motherland_difficulty_mod:set_default_value(150)
for_the_motherland_difficulty_mod:slider_set_step_size(10)

local for_the_motherland_min_turn_value = mod:add_new_option("for_the_motherland_min_turn_value", "slider")
for_the_motherland_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
for_the_motherland_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
for_the_motherland_min_turn_value:slider_set_min_max(10, 400)
for_the_motherland_min_turn_value:set_default_value(100)
for_the_motherland_min_turn_value:slider_set_step_size(10)

local for_the_motherland_max_turn_value = mod:add_new_option("for_the_motherland_max_turn_value", "slider")
for_the_motherland_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
for_the_motherland_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
for_the_motherland_max_turn_value:slider_set_min_max(0, 600)
for_the_motherland_max_turn_value:set_default_value(0)
for_the_motherland_max_turn_value:slider_set_step_size(10)

local for_the_motherland_short_victory_is_min_turn = mod:add_new_option("for_the_motherland_short_victory_is_min_turn", "checkbox")
for_the_motherland_short_victory_is_min_turn:set_default_value(false)
for_the_motherland_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
for_the_motherland_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local for_the_motherland_long_victory_is_min_turn = mod:add_new_option("for_the_motherland_long_victory_is_min_turn", "checkbox")
for_the_motherland_long_victory_is_min_turn:set_default_value(true)
for_the_motherland_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
for_the_motherland_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    The Greatest Crusade Config
]]
local disasters_individual_config_section_the_greatest_crusade = mod:add_new_section("the_greatest_crusade", loc_prefix.."the_greatest_crusade_config", true)
local the_greatest_crusade_enable = mod:add_new_option("the_greatest_crusade_enable", "checkbox")
the_greatest_crusade_enable:set_default_value(true)
the_greatest_crusade_enable:set_text(loc_prefix.."the_greatest_crusade_enable", true)
the_greatest_crusade_enable:set_tooltip_text(loc_prefix.."the_greatest_crusade_enable_tooltip", true)

local the_greatest_crusade_revive_dead_factions = mod:add_new_option("the_greatest_crusade_revive_dead_factions", "checkbox")
the_greatest_crusade_revive_dead_factions:set_default_value(true)
the_greatest_crusade_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
the_greatest_crusade_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local the_greatest_crusade_enable_diplomacy = mod:add_new_option("the_greatest_crusade_enable_diplomacy", "checkbox")
the_greatest_crusade_enable_diplomacy:set_default_value(false)
the_greatest_crusade_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
the_greatest_crusade_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local the_greatest_crusade_difficulty_mod = mod:add_new_option("the_greatest_crusade_difficulty_mod", "slider")
the_greatest_crusade_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
the_greatest_crusade_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
the_greatest_crusade_difficulty_mod:slider_set_min_max(10, 500)
the_greatest_crusade_difficulty_mod:set_default_value(150)
the_greatest_crusade_difficulty_mod:slider_set_step_size(10)

local the_greatest_crusade_min_turn_value = mod:add_new_option("the_greatest_crusade_min_turn_value", "slider")
the_greatest_crusade_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
the_greatest_crusade_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
the_greatest_crusade_min_turn_value:slider_set_min_max(10, 400)
the_greatest_crusade_min_turn_value:set_default_value(100)
the_greatest_crusade_min_turn_value:slider_set_step_size(10)

local the_greatest_crusade_max_turn_value = mod:add_new_option("the_greatest_crusade_max_turn_value", "slider")
the_greatest_crusade_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
the_greatest_crusade_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
the_greatest_crusade_max_turn_value:slider_set_min_max(0, 600)
the_greatest_crusade_max_turn_value:set_default_value(0)
the_greatest_crusade_max_turn_value:slider_set_step_size(10)

local the_greatest_crusade_short_victory_is_min_turn = mod:add_new_option("the_greatest_crusade_short_victory_is_min_turn", "checkbox")
the_greatest_crusade_short_victory_is_min_turn:set_default_value(false)
the_greatest_crusade_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
the_greatest_crusade_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local the_greatest_crusade_long_victory_is_min_turn = mod:add_new_option("the_greatest_crusade_long_victory_is_min_turn", "checkbox")
the_greatest_crusade_long_victory_is_min_turn:set_default_value(true)
the_greatest_crusade_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
the_greatest_crusade_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Empire of Steel and Faith Config
]]
local disasters_individual_config_section_the_greatest_crusade = mod:add_new_section("empire_of_steel_and_faith", loc_prefix.."empire_of_steel_and_faith_config", true)
local empire_of_steel_and_faith_enable = mod:add_new_option("empire_of_steel_and_faith_enable", "checkbox")
empire_of_steel_and_faith_enable:set_default_value(true)
empire_of_steel_and_faith_enable:set_text(loc_prefix.."empire_of_steel_and_faith_enable", true)
empire_of_steel_and_faith_enable:set_tooltip_text(loc_prefix.."empire_of_steel_and_faith_enable_tooltip", true)

local empire_of_steel_and_faith_revive_dead_factions = mod:add_new_option("empire_of_steel_and_faith_revive_dead_factions", "checkbox")
empire_of_steel_and_faith_revive_dead_factions:set_default_value(true)
empire_of_steel_and_faith_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
empire_of_steel_and_faith_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local empire_of_steel_and_faith_enable_diplomacy = mod:add_new_option("empire_of_steel_and_faith_enable_diplomacy", "checkbox")
empire_of_steel_and_faith_enable_diplomacy:set_default_value(false)
empire_of_steel_and_faith_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
empire_of_steel_and_faith_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local empire_of_steel_and_faith_difficulty_mod = mod:add_new_option("empire_of_steel_and_faith_difficulty_mod", "slider")
empire_of_steel_and_faith_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
empire_of_steel_and_faith_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
empire_of_steel_and_faith_difficulty_mod:slider_set_min_max(10, 500)
empire_of_steel_and_faith_difficulty_mod:set_default_value(150)
empire_of_steel_and_faith_difficulty_mod:slider_set_step_size(10)

local empire_of_steel_and_faith_min_turn_value = mod:add_new_option("empire_of_steel_and_faith_min_turn_value", "slider")
empire_of_steel_and_faith_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
empire_of_steel_and_faith_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
empire_of_steel_and_faith_min_turn_value:slider_set_min_max(10, 400)
empire_of_steel_and_faith_min_turn_value:set_default_value(100)
empire_of_steel_and_faith_min_turn_value:slider_set_step_size(10)

local empire_of_steel_and_faith_max_turn_value = mod:add_new_option("empire_of_steel_and_faith_max_turn_value", "slider")
empire_of_steel_and_faith_max_turn_value:set_text(loc_prefix.."max_turn_value", true)
empire_of_steel_and_faith_max_turn_value:set_tooltip_text(loc_prefix.."max_turn_value_tooltip", true)
empire_of_steel_and_faith_max_turn_value:slider_set_min_max(0, 600)
empire_of_steel_and_faith_max_turn_value:set_default_value(0)
empire_of_steel_and_faith_max_turn_value:slider_set_step_size(10)

local empire_of_steel_and_faith_short_victory_is_min_turn = mod:add_new_option("empire_of_steel_and_faith_short_victory_is_min_turn", "checkbox")
empire_of_steel_and_faith_short_victory_is_min_turn:set_default_value(false)
empire_of_steel_and_faith_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
empire_of_steel_and_faith_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local empire_of_steel_and_faith_long_victory_is_min_turn = mod:add_new_option("empire_of_steel_and_faith_long_victory_is_min_turn", "checkbox")
empire_of_steel_and_faith_long_victory_is_min_turn:set_default_value(true)
empire_of_steel_and_faith_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
empire_of_steel_and_faith_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Last Stand Config
]]
local disasters_individual_config_section_last_stand = mod:add_new_section("last_stand", loc_prefix.."last_stand_config", true)
local last_stand_enable = mod:add_new_option("last_stand_enable", "checkbox")
last_stand_enable:set_default_value(true)
last_stand_enable:set_text(loc_prefix.."last_stand_enable", true)
last_stand_enable:set_tooltip_text(loc_prefix.."last_stand_enable_tooltip", true)

local d = mod:add_new_option("dddd972", "dummy")
d:set_text(" ");

local d = mod:add_new_option("dddd9771", "dummy")
d:set_text(" ");

local last_stand_difficulty_mod = mod:add_new_option("last_stand_difficulty_mod", "slider")
last_stand_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
last_stand_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
last_stand_difficulty_mod:slider_set_min_max(10, 500)
last_stand_difficulty_mod:set_default_value(150)
last_stand_difficulty_mod:slider_set_step_size(10)

local last_stand_min_turn_value = mod:add_new_option("last_stand_min_turn_value", "slider")
last_stand_min_turn_value:set_text(loc_prefix.."min_turn_value", true)
last_stand_min_turn_value:set_tooltip_text(loc_prefix.."min_turn_value_tooltip", true)
last_stand_min_turn_value:slider_set_min_max(1, 400)
last_stand_min_turn_value:set_default_value(30)
last_stand_min_turn_value:slider_set_step_size(5)


--[[
    Realm Divided Config
]]
local disasters_individual_config_section_realm_divided = mod:add_new_section("realm_divided", loc_prefix.."realm_divided_config", true)
local realm_divided_enable = mod:add_new_option("realm_divided_enable", "checkbox")
realm_divided_enable:set_default_value(true)
realm_divided_enable:set_text(loc_prefix.."realm_divided_enable", true)
realm_divided_enable:set_tooltip_text(loc_prefix.."realm_divided_enable_tooltip", true)

local d = mod:add_new_option("dddd97", "dummy")
d:set_text(" ");

local d = mod:add_new_option("dddd977", "dummy")
d:set_text(" ");

local realm_divided_difficulty_mod = mod:add_new_option("realm_divided_difficulty_mod", "slider")
realm_divided_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
realm_divided_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
realm_divided_difficulty_mod:slider_set_min_max(10, 500)
realm_divided_difficulty_mod:set_default_value(150)
realm_divided_difficulty_mod:slider_set_step_size(10)

--[[
    The Vermintide Config
]]
local disasters_individual_config_section_the_vermintide = mod:add_new_section("the_vermintide", loc_prefix.."the_vermintide_config", true)
local the_vermintide_enable = mod:add_new_option("the_vermintide_enable", "checkbox")
the_vermintide_enable:set_default_value(true)
the_vermintide_enable:set_text(loc_prefix.."the_vermintide_enable", true)
the_vermintide_enable:set_tooltip_text(loc_prefix.."the_vermintide_enable_tooltip", true)

local the_vermintide_revive_dead_factions = mod:add_new_option("the_vermintide_revive_dead_factions", "checkbox")
the_vermintide_revive_dead_factions:set_default_value(false)
the_vermintide_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
the_vermintide_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local the_vermintide_enable_diplomacy = mod:add_new_option("the_vermintide_enable_diplomacy", "checkbox")
the_vermintide_enable_diplomacy:set_default_value(false)
the_vermintide_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
the_vermintide_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local the_vermintide_difficulty_mod = mod:add_new_option("the_vermintide_difficulty_mod", "slider")
the_vermintide_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
the_vermintide_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
the_vermintide_difficulty_mod:slider_set_min_max(10, 500)
the_vermintide_difficulty_mod:set_default_value(150)
the_vermintide_difficulty_mod:slider_set_step_size(13)

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

local the_vermintide_short_victory_is_min_turn = mod:add_new_option("the_vermintide_short_victory_is_min_turn", "checkbox")
the_vermintide_short_victory_is_min_turn:set_default_value(false)
the_vermintide_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
the_vermintide_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local the_vermintide_long_victory_is_min_turn = mod:add_new_option("the_vermintide_long_victory_is_min_turn", "checkbox")
the_vermintide_long_victory_is_min_turn:set_default_value(true)
the_vermintide_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
the_vermintide_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Vanilla Grudge Too Far Config
]]
local disasters_individual_config_section_grudge_too_far = mod:add_new_section("grudge_too_far", loc_prefix.."grudge_too_far_config", true)
local grudge_too_far_enable = mod:add_new_option("grudge_too_far_enable", "checkbox")
grudge_too_far_enable:set_default_value(true)
grudge_too_far_enable:set_text(loc_prefix.."grudge_too_far_enable", true)
grudge_too_far_enable:set_tooltip_text(loc_prefix.."grudge_too_far_enable_tooltip", true)

local grudge_too_far_revive_dead_factions = mod:add_new_option("grudge_too_far_revive_dead_factions", "checkbox")
grudge_too_far_revive_dead_factions:set_default_value(true)
grudge_too_far_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
grudge_too_far_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local grudge_too_far_enable_diplomacy = mod:add_new_option("grudge_too_far_enable_diplomacy", "checkbox")
grudge_too_far_enable_diplomacy:set_default_value(false)
grudge_too_far_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
grudge_too_far_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local grudge_too_far_difficulty_mod = mod:add_new_option("grudge_too_far_difficulty_mod", "slider")
grudge_too_far_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
grudge_too_far_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
grudge_too_far_difficulty_mod:slider_set_min_max(10, 500)
grudge_too_far_difficulty_mod:set_default_value(150)
grudge_too_far_difficulty_mod:slider_set_step_size(10)

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

local grudge_too_far_short_victory_is_min_turn = mod:add_new_option("grudge_too_far_short_victory_is_min_turn", "checkbox")
grudge_too_far_short_victory_is_min_turn:set_default_value(false)
grudge_too_far_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
grudge_too_far_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local grudge_too_far_long_victory_is_min_turn = mod:add_new_option("grudge_too_far_long_victory_is_min_turn", "checkbox")
grudge_too_far_long_victory_is_min_turn:set_default_value(true)
grudge_too_far_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
grudge_too_far_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Vanilla Pyramid of Nagash Config
]]
local disasters_individual_config_section_pyramid_of_nagash = mod:add_new_section("pyramid_of_nagash", loc_prefix.."pyramid_of_nagash_config", true)
local pyramid_of_nagash_enable = mod:add_new_option("pyramid_of_nagash_enable", "checkbox")
pyramid_of_nagash_enable:set_default_value(true)
pyramid_of_nagash_enable:set_text(loc_prefix.."pyramid_of_nagash_enable", true)
pyramid_of_nagash_enable:set_tooltip_text(loc_prefix.."pyramid_of_nagash_enable_tooltip", true)

local d = mod:add_new_option("d8", "dummy")
d:set_text(" ");

local pyramid_of_nagash_enable_diplomacy = mod:add_new_option("pyramid_of_nagash_enable_diplomacy", "checkbox")
pyramid_of_nagash_enable_diplomacy:set_default_value(false)
pyramid_of_nagash_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
pyramid_of_nagash_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local pyramid_of_nagash_difficulty_mod = mod:add_new_option("pyramid_of_nagash_difficulty_mod", "slider")
pyramid_of_nagash_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
pyramid_of_nagash_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
pyramid_of_nagash_difficulty_mod:slider_set_min_max(10, 500)
pyramid_of_nagash_difficulty_mod:set_default_value(150)
pyramid_of_nagash_difficulty_mod:slider_set_step_size(10)

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

local pyramid_of_nagash_short_victory_is_min_turn = mod:add_new_option("pyramid_of_nagash_short_victory_is_min_turn", "checkbox")
pyramid_of_nagash_short_victory_is_min_turn:set_default_value(false)
pyramid_of_nagash_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
pyramid_of_nagash_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local pyramid_of_nagash_long_victory_is_min_turn = mod:add_new_option("pyramid_of_nagash_long_victory_is_min_turn", "checkbox")
pyramid_of_nagash_long_victory_is_min_turn:set_default_value(true)
pyramid_of_nagash_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
pyramid_of_nagash_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Vanilla Vampires Rise Config
]]
local disasters_individual_config_section_vampires_rise = mod:add_new_section("vampires_rise", loc_prefix.."vampires_rise_config", true)
local vampires_rise_enable = mod:add_new_option("vampires_rise_enable", "checkbox")
vampires_rise_enable:set_default_value(true)
vampires_rise_enable:set_text(loc_prefix.."vampires_rise_enable", true)
vampires_rise_enable:set_tooltip_text(loc_prefix.."vampires_rise_enable_tooltip", true)

local vampires_rise_revive_dead_factions = mod:add_new_option("vampires_rise_revive_dead_factions", "checkbox")
vampires_rise_revive_dead_factions:set_default_value(true)
vampires_rise_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
vampires_rise_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local vampires_rise_enable_diplomacy = mod:add_new_option("vampires_rise_enable_diplomacy", "checkbox")
vampires_rise_enable_diplomacy:set_default_value(false)
vampires_rise_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
vampires_rise_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local vampires_rise_difficulty_mod = mod:add_new_option("vampires_rise_difficulty_mod", "slider")
vampires_rise_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
vampires_rise_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
vampires_rise_difficulty_mod:slider_set_min_max(10, 500)
vampires_rise_difficulty_mod:set_default_value(150)
vampires_rise_difficulty_mod:slider_set_step_size(10)

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

local vampires_rise_short_victory_is_min_turn = mod:add_new_option("vampires_rise_short_victory_is_min_turn", "checkbox")
vampires_rise_short_victory_is_min_turn:set_default_value(false)
vampires_rise_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
vampires_rise_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local vampires_rise_long_victory_is_min_turn = mod:add_new_option("vampires_rise_long_victory_is_min_turn", "checkbox")
vampires_rise_long_victory_is_min_turn:set_default_value(true)
vampires_rise_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
vampires_rise_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Vanilla Waaagh Config
]]
local disasters_individual_config_section_waaagh = mod:add_new_section("waaagh", loc_prefix.."waaagh_config", true)
local waaagh_enable = mod:add_new_option("waaagh_enable", "checkbox")
waaagh_enable:set_default_value(true)
waaagh_enable:set_text(loc_prefix.."waaagh_enable", true)
waaagh_enable:set_tooltip_text(loc_prefix.."waaagh_enable_tooltip", true)

local waaagh_revive_dead_factions = mod:add_new_option("waaagh_revive_dead_factions", "checkbox")
waaagh_revive_dead_factions:set_default_value(true)
waaagh_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
waaagh_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local waaagh_enable_diplomacy = mod:add_new_option("waaagh_enable_diplomacy", "checkbox")
waaagh_enable_diplomacy:set_default_value(false)
waaagh_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
waaagh_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local waaagh_difficulty_mod = mod:add_new_option("waaagh_difficulty_mod", "slider")
waaagh_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
waaagh_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
waaagh_difficulty_mod:slider_set_min_max(10, 500)
waaagh_difficulty_mod:set_default_value(150)
waaagh_difficulty_mod:slider_set_step_size(10)

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

local waaagh_short_victory_is_min_turn = mod:add_new_option("waaagh_short_victory_is_min_turn", "checkbox")
waaagh_short_victory_is_min_turn:set_default_value(false)
waaagh_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
waaagh_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local waaagh_long_victory_is_min_turn = mod:add_new_option("waaagh_long_victory_is_min_turn", "checkbox")
waaagh_long_victory_is_min_turn:set_default_value(true)
waaagh_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
waaagh_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)

--[[
    Vanilla Wild Hunt Config
]]
local disasters_individual_config_section_wild_hunt = mod:add_new_section("wild_hunt", loc_prefix.."wild_hunt_config", true)
local wild_hunt_enable = mod:add_new_option("wild_hunt_enable", "checkbox")
wild_hunt_enable:set_default_value(true)
wild_hunt_enable:set_text(loc_prefix.."wild_hunt_enable", true)
wild_hunt_enable:set_tooltip_text(loc_prefix.."wild_hunt_enable_tooltip", true)

local wild_hunt_revive_dead_factions = mod:add_new_option("wild_hunt_revive_dead_factions", "checkbox")
wild_hunt_revive_dead_factions:set_default_value(true)
wild_hunt_revive_dead_factions:set_text(loc_prefix.."revive_dead_factions", true)
wild_hunt_revive_dead_factions:set_tooltip_text(loc_prefix.."revive_dead_factions_tooltip", true)

local wild_hunt_enable_diplomacy = mod:add_new_option("wild_hunt_enable_diplomacy", "checkbox")
wild_hunt_enable_diplomacy:set_default_value(false)
wild_hunt_enable_diplomacy:set_text(loc_prefix.."enable_diplomacy", true)
wild_hunt_enable_diplomacy:set_tooltip_text(loc_prefix.."enable_diplomacy_tooltip", true)

local wild_hunt_difficulty_mod = mod:add_new_option("wild_hunt_difficulty_mod", "slider")
wild_hunt_difficulty_mod:set_text(loc_prefix.."difficulty_mod", true)
wild_hunt_difficulty_mod:set_tooltip_text(loc_prefix.."difficulty_mod_tooltip", true)
wild_hunt_difficulty_mod:slider_set_min_max(10, 500)
wild_hunt_difficulty_mod:set_default_value(150)
wild_hunt_difficulty_mod:slider_set_step_size(10)

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

local wild_hunt_short_victory_is_min_turn = mod:add_new_option("wild_hunt_short_victory_is_min_turn", "checkbox")
wild_hunt_short_victory_is_min_turn:set_default_value(false)
wild_hunt_short_victory_is_min_turn:set_text(loc_prefix.."short_victory_is_min_turn", true)
wild_hunt_short_victory_is_min_turn:set_tooltip_text(loc_prefix.."short_victory_is_min_turn_tooltip", true)

local wild_hunt_long_victory_is_min_turn = mod:add_new_option("wild_hunt_long_victory_is_min_turn", "checkbox")
wild_hunt_long_victory_is_min_turn:set_default_value(true)
wild_hunt_long_victory_is_min_turn:set_text(loc_prefix.."long_victory_is_min_turn", true)
wild_hunt_long_victory_is_min_turn:set_tooltip_text(loc_prefix.."long_victory_is_min_turn_tooltip", true)
