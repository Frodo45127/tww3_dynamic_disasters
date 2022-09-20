--[[
    Example integration for mods to integrate their units into a dynamic disaster.
]]--

-- We initialize the integration on first tick, just after the main dynamic_disasters object has been initialized
out("\tFrodo45127: Trying to add units from integration (example).");

if dynamic_disasters then
    local error_message = false;
    error_message = dynamic_disasters:add_unit_to_army_template("vampires?", "lategame?", "example_unit?", 1); if is_string(error_message) then out("\t\t" .. error_message); end
end
