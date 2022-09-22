--[[ 
    Yin-Yin, the Sea Dragon & Warriors of the Jade Sea: https://steamcommunity.com/workshop/filedetails/?id=2809744514

    Last Updated: 22/09/2022
]]

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (Yin-Yin, the Sea Dragon & Warriors of the Jade Sea).");

if dynamic_disasters then
    local error_message = false

    -- Infantry
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_wokou", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_wokou_ds", 2); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_wokou_guns", 1); if is_string(error_message) then out("\t\t" .. error_message); end
    error_message = dynamic_disasters:add_unit_to_army_template("cathay", "earlygame", "cth_wokou_spears", 2); if is_string(error_message) then out("\t\t" .. error_message); end

end
