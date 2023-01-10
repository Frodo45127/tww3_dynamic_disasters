# Dynamic Disasters

Dynamic Disasters is a mod/framework for Warhammer 3 which allows to easily build customizable disasters, with custom conditions/behaviors/missions... Kinda like endgames, but far more extensible.

# Documentation

Each disaster included in this mod has its behavior documented at the start of its script, in ***script/campaign/dynamic_disasters/***. If you want to know what each disaster does, go there and check it.

# How to make new disasters

This mod dinamically loads disasters from lua scripts present in the ***script/campaign/dynamic_disasters/*** folder. Files should be called **disaster_whateveryouwant.lua**. A disaster file needs to contain an lua object, a few associated functions, and must return the lua object at the end of the script. For an example, check ***disaster_example.lua***. It contains all the stuff needed to just run, with specific documentation about each thing in the script. A couple of extra things to take into account:

* The framework calls *disaster:set_status()* on load. Use it to initialize listeners.
* The framework calls *disaster:check_start_disaster_conditions()* at the beginning of each turn, if nothing else causes the disaster to not trigger, like not being at the minimum turn. Use it to put conditions on when to trigger the disaster.
* Remember to call *disaster_example:trigger_end_disaster()* to properly mark the disaster as finished.
* MCT integration is optional. MCT settings are updated when closing the MCT dialog or at the start of each turn, before processing disasters for that turn.
* To add custom MCT settings for a disaster, add the key of the setting to the *mct_settings* table and the framework will try to load any setting called **disaster_name_setting_key** into disaster.settings.setting_key when loading settings. For an example, check the "enable_rifts" setting in the chaos invasion disaster.

# Unit Mod integrations/Submods

For spawning armies, this mod uses hardcoded army templates (similar to what the endgames script uses). This means custom units will not appear by default in disaster-spawned armies. That can be solved by making a unit mod integration. Similar to how disasters are loaded, unit mod integrations are scripts dinamically loaded from ***script/campaign/dynamic_disasters_integrations/***. The script just needs one line per unit/template/faction calling ***dynamic_disasters:add_unit_to_army_template***. The framework will take care to ensure to only load the integration if the unit is valid, reporting any error to the logs. For more guidance, check the example.lua integration, or any of the other ones.

Currently, the framework has mod integrations with the following mods:

* Expanded Roster - Dark Elves
* Expanded Roster - Greenskins - Goblin Pack
* Expanded Roster - Greenskins - Orc Pack
* Expanded Roster - Norsca
* Expanded Roster - Vampire Counts
* Yin-Yin, the Sea Dragon & Warriors of the Jade Sea

The same goes for submods manipulating anything (including trigger conditions) of a disaster. You can overwrite any function of a disaster with your own, altering its behavior, using a lua script in the integrations folder. That's guaranteed to only load after Dynamic Disasters has been fully initialized.

# Credits

* Frodo45127: I made the whole mod.
* The guys at the CnC discord: they helped me with all the issues I had with lua.
