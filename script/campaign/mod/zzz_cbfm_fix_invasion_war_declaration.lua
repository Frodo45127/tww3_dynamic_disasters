
--[[
Fix for invasions spamming war declarations to the same factions on the same turn.
]]--

out("Frodo45127: Fixing invasion war declaration spamming.")

---- Internal - Advances the invasion, moving or attacking their target if there is one
function invasion:advance()
    out.invasions("Invasion: Advancing Invasion for '"..self.key.."'...");
    local force = self:get_force();
    local should_remove = false;

    if force:is_null_interface() == false then
        local general = self:get_general();

        if general:is_null_interface() == false then
            local general_cqi = general:command_queue_index();
            local general_lookup = "character_cqi:"..general_cqi;
            out.invasions("\tGeneral Lookup: "..general_lookup);
            out.invasions("\tTarget: "..tostring(self.target_type).." ["..tostring(self.target).."]");

            if self.maintain_army == true then
                out.invasions("\tMaintaining army...");
                if force:unit_list():num_items() < #self.unit_list_table then
                    out.invasions("\t\tArmy is missing units: "..force:unit_list():num_items().."/"..#self.unit_list_table);
                    if cm:model():random_percent(self.maintain_army_chance) then
                        out.invasions("\t\tArmy succeeded its maintain chance of "..self.maintain_army_chance.."%");
                        -- Go through the initial force and the current force to compare the units in both
                        local multiple_units = {};
                        multiple_units["initial"] = {};
                        multiple_units["current"] = {};

                        for i = 1, #self.unit_list_table do
                            local initial_unit = self.unit_list_table[i];
                            multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] or 0;
                            multiple_units["initial"][initial_unit] = multiple_units["initial"][initial_unit] + 1;
                        end
                        for i = 0, force:unit_list():num_items() - 1 do
                            local current_unit = force:unit_list():item_at(i):unit_key();
                            multiple_units["current"][current_unit] = multiple_units["current"][current_unit] or 0;
                            multiple_units["current"][current_unit] = multiple_units["current"][current_unit] + 1;
                        end

                        for initial_unit, initial_number in pairs(multiple_units["initial"]) do
                            for current_unit, current_number in pairs(multiple_units["current"]) do
                                if initial_unit == current_unit then
                                    if current_number < initial_number then
                                        -- There are not enough of this unit in the army
                                        cm:grant_unit_to_character(general_lookup, initial_unit);
                                        out.invasions("\t\tAdding unit to army: "..initial_unit);
                                    end
                                end
                            end
                        end
                    else
                        out.invasions("\t\tArmy failed its maintain chance of "..self.maintain_army_chance.."%");
                    end
                end
            end

            if self.target_type ~= "NONE" then
                out.invasions("\tDisabling movement for invasion general");
                cm:cai_disable_movement_for_character(general_lookup);

                if self.target_faction ~= nil then
                    out.invasions("\tOn advance, "..self.faction.." declares war on "..self.target_faction);

                    -- Fix for duplicated war declarations.
                    local faction = cm:get_faction(self.faction);
                    local target_faction = cm:get_faction(self.target_faction);
                    if not faction == false and faction:is_null_interface() == false and not target_faction == false and target_faction:is_null_interface() == false and not faction:at_war_with(target_faction) then
                        cm:force_declare_war(self.faction, self.target_faction, true, true);
                    end
                end

                if self.aggro_enabled == true then
                    if self.aggro_target_cqi ~= nil then
                        out.invasions("\tAggro target already in progress");
                        -- We have an aggro target already
                        local still_valid = true;
                        local target_char = cm:model():character_for_command_queue_index(self.aggro_target_cqi);

                        -- Check if the target is still valid
                        still_valid = target_char:is_null_interface() == false;
                        still_valid = still_valid and target_char:has_military_force() == true;
                        still_valid = still_valid and target_char:in_settlement() == false;
                        still_valid = still_valid and target_char:is_at_sea() == general:is_at_sea();

                        if still_valid == true then
                            -- This check prevents Black Arks from causing naval attacks to end up on land
                            if general:is_at_sea() == true and target_char:in_settlement() == true then
                                still_valid = false;
                            end
                        end
                        -- Check if the invasion has been chasing this aggro target for too long
                        still_valid = still_valid and self.aggro_turn_abort_value < self.aggro_turn_abort;

                        if still_valid then
                            out.invasions("\tAggro target already in progress ("..tostring(self.aggro_target_cqi).." - "..target_char:faction():name()..")");
                        else
                            out.invasions("\tTarget is no longer valid!");
                            self.aggro_target_cqi = nil;
                            self.aggro_cooldown_value = self.aggro_cooldown;
                        end
                    end

                    if self.aggro_target_cqi == nil then
                        out.invasions("\tAggro is enabled - Targets:");
                        for tar = 1, #self.aggro_targets do
                            if self.aggro_targets[1] == "war" then
                                out.invasions("\t\tAny factions at war");
                            else
                                out.invasions("\t\t'"..tostring(self.aggro_targets[tar]).."'");
                            end;
                        end

                        -- We don't have an aggro target
                        if self.aggro_cooldown_value > 0 then
                            -- Invasion is in aggro cooldown
                            self.aggro_cooldown_value = self.aggro_cooldown_value - 1;
                            out.invasions("\t\tAggro cooldown is in effect ("..tostring(self.aggro_cooldown_value)..")");
                        else
                            out.invasions("\t\tAttempting to find target in aggro radius ("..tostring(self.aggro_radius)..")");
                            local aggro_target_cqi, aggro_target_faction_name = self:find_aggro_target();

                            if aggro_target_cqi ~= nil then
                                out.invasions("\t\t\tFound target: "..tostring(aggro_target_cqi).." in faction " ..tostring(aggro_target_faction_name));
                                self.aggro_target_cqi = aggro_target_cqi;
                            else
                                out.invasions("\t\t\tCouldn't find target");
                            end
                        end
                    end
                end

                if self.aggro_enabled == true and self.aggro_target_cqi ~= nil then
                    ----------------------------------------------------------------------------------
                    ---- AGGRO TARGET ----------------------------------------------------------------
                    ----------------------------------------------------------------------------------
                    ---- Invasion force found a target within its aggro radius and will attack it ----
                    ----------------------------------------------------------------------------------
                    local char_obj = cm:model():character_for_command_queue_index(self.aggro_target_cqi);

                    if char_obj:is_null_interface() == false then
                        local target_character_lookup = "character_cqi:"..self.aggro_target_cqi;
                        out.invasions("\tAttacking aggro target: "..tostring(self.aggro_target_cqi));
                        cm:cai_disable_movement_for_character(general_lookup);
                        cm:enable_movement_for_character(general_lookup);
                        cm:replenish_action_points(general_lookup);
                        cm:force_declare_war(char_obj:faction():name(), general:faction():name(), false, false);
                        cm:attack_queued(general_lookup, target_character_lookup);
                        self.aggro_turn_abort_value = self.aggro_turn_abort_value + 1;
                        out.invasions("\t\tTurns spent in aggro: "..tostring(self.aggro_turn_abort_value));
                    else
                        script_error("ERROR: Aggro Target CQI is set but interface was null");
                    end
                elseif self.target_type == "LOCATION" then
                    --------------------------------------------------------------------------------
                    ---- LOCATION ------------------------------------------------------------------
                    --------------------------------------------------------------------------------
                    ---- Move to a location and then release the army when it gets close enough ----
                    --------------------------------------------------------------------------------
                    out.invasions("\tMoving to Location... ["..self.target.x..", "..self.target.y.."]");
                    local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target.x, self.target.y);
                    out.invasions("\tDistance from target = "..distance_from_target);

                    if distance_from_target < 2 then
                        out.invasions("\tArrived at Location!");
                        self.target_type = "NONE";
                    else
                        out.invasions("\tMoving...");
                        cm:move_to_queued(general_lookup, self.target.x, self.target.y);
                    end
                elseif self.target_type == "CHARACTER" then
                    -------------------------------------------------------------------------------------
                    ---- CHARACTER ----------------------------------------------------------------------
                    -------------------------------------------------------------------------------------
                    ---- Attack a character as long as they aren't a null interface and have a force ----
                    -------------------------------------------------------------------------------------
                    local target_character_cqi = self.target;
                    local target_character_lookup = "character_cqi:"..target_character_cqi;
                    local tagert_character_obj = cm:model():character_for_command_queue_index(target_character_cqi);

                    if tagert_character_obj:is_null_interface() == false and tagert_character_obj:has_military_force() then
                        out.invasions("\tAttacking Character...");
                        cm:cai_disable_movement_for_character(general_lookup);
                        cm:enable_movement_for_character(general_lookup);
                        cm:replenish_action_points(general_lookup);
                        cm:attack_queued(general_lookup, target_character_lookup);
                    else
                        out.invasions("\tCouldn't find target... releasing force!");
                        self.target_type = "NONE";
                    end
                elseif self.target_type == "REGION" then
                    -----------------------------------------------------------------------------------
                    ---- REGION -----------------------------------------------------------------------
                    -----------------------------------------------------------------------------------
                    ---- Attack a region providing it is not a null interface and is not abandoned ----
                    -----------------------------------------------------------------------------------
                    local target_region_key = self.target;
                    local target_region_obj = cm:model():world():region_manager():region_by_key(target_region_key);

                    if target_region_obj:is_null_interface() == false and target_region_obj:is_abandoned() == false then
                        local region_owner = target_region_obj:owning_faction():name();

                        if region_owner == self.target_faction then
                            out.invasions("\tAttacking Region...");
                            cm:cai_disable_movement_for_character(general_lookup);
                            cm:enable_movement_for_character(general_lookup);
                            cm:replenish_action_points(general_lookup);
                            cm:attack_region(general_lookup, target_region_key);
                        else
                            out.invasions("\tTarget Region owner is no longer initial faction target:");
                            out.invasions("\t\tInitial: "..tostring(self.target_faction));
                            out.invasions("\t\tCurrent: "..region_owner);

                            if self.target_owner_abort == false then
                                out.invasions("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Switching Target Faction!");
                                self.target_faction = region_owner;

                                -- Fix for duplicated war declarations.
                                local faction = cm:get_faction(self.faction);
                                local target_faction = cm:get_faction(self.target_faction);
                                if not faction == false and faction:is_null_interface() == false and not target_faction == false and target_faction:is_null_interface() == false and not faction:at_war_with(target_faction) then
                                    cm:force_declare_war(self.faction, self.target_faction, true, true);
                                end
                            else
                                out.invasions("\ttarget_owner_abort is "..tostring(self.target_owner_abort).." - Aborting Invasion!");
                                self.target_type = "NONE";
                            end
                        end
                    else
                        out.invasions("\tCouldn't find target... releasing force!");
                        self.target_type = "NONE";
                    end
                elseif self.target_type == "FORCE" then
                    -------------------------------------------------------------------------------
                    ---- FORCE --------------------------------------------------------------------
                    -------------------------------------------------------------------------------
                    ---- Attack a force providing it is not a null interface and has a general ----
                    -------------------------------------------------------------------------------
                    local target_force_cqi = self.target;
                    local target_force_obj = cm:model():military_force_for_command_queue_index(target_force_cqi);

                    if target_force_obj:is_null_interface() == false then
                        if target_force_obj:has_general() == true then
                            local enemy_general_cqi = target_force_obj:general_character():command_queue_index();
                            local enemy_general_lookup = "character_cqi:"..enemy_general_cqi;

                            out.invasions("\tAttacking Force...");
                            cm:cai_disable_movement_for_character(general_lookup);
                            cm:enable_movement_for_character(general_lookup);
                            cm:replenish_action_points(general_lookup);
                            cm:attack_queued(general_lookup, enemy_general_lookup);
                        end
                    else
                        out.invasions("\tCouldn't find target... releasing force!");
                        self.target_type = "NONE";
                    end
                elseif self.target_type == "PATROL" then
                    ------------------------------------------------------------------------------------
                    ---- PATROL ------------------------------------------------------------------------
                    ------------------------------------------------------------------------------------
                    ---- Walks to a set of coordinates indefinitely until destroyed or told to stop ----
                    ------------------------------------------------------------------------------------
                    out.invasions("\tFollowing patrol route...");
                    out.invasions("\tNext patrol point: #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
                    local distance_from_target = distance_squared(general:logical_position_x(), general:logical_position_y(), self.target[self.patrol_position].x, self.target[self.patrol_position].y);
                    out.invasions("\tDistance from next patrol point " .. general:logical_position_x() .. ", " .. general:logical_position_y() .. " -> " .. self.target[self.patrol_position].x .. ", " .. self.target[self.patrol_position].y .. " = "..distance_from_target);

                    if distance_from_target < 2 then
                        out.invasions("\tArrived at patrol location #"..self.patrol_position);

                        if self.patrol_position == #self.target then
                            out.invasions("\t\tLast patrol position reached...");

                            if self.stop_at_end == true then
                                out.invasions("\t\t\tStopping!");
                                self.target_type = "NONE";
                                self.patrol_position = 0;
                            else
                                self.patrol_position = 1;
                                out.invasions("\t\t\tRestarting patrol and moving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
                                cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
                            end
                        elseif self.target[self.patrol_position + 1] ~= nil then
                            self.patrol_position = self.patrol_position + 1;
                            out.invasions("\t\tMoving to next patrol point... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
                            cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
                        else
                            out.invasions("\t\t\tAborting?!");
                            self.target_type = "NONE";
                            self.patrol_position = 0;
                        end
                    else
                        out.invasions("\tMoving... #"..self.patrol_position.." ["..self.target[self.patrol_position].x..", "..self.target[self.patrol_position].y.."]");
                        cm:move_to_queued(general_lookup, self.target[self.patrol_position].x, self.target[self.patrol_position].y);
                    end
                elseif self.target_type == "TZEENTCH_COORDS" then
                    ----------------------------------------------------------------------------------------------------------------------------------
                    ---- TZEENTCH_COORDS -------------------------------------------------------------------------------------------------------------
                    ----------------------------------------------------------------------------------------------------------------------------------
                    ---- Walks to the nearest coordinate (within the same region as the general) found within the supplied table of coordinates ------
                    ----------------------------------------------------------------------------------------------------------------------------------
                    out.invasions("\tFinding nearest coordinate...");

                    local closest_distance = 500000;
                    local desired_position = {};
                    local general_position_x = general:logical_position_x();
                    local general_position_y = general:logical_position_y();
                    local general_region = general:region_data():key();
                    local world = cm:model():world();

                    for i = 1, #self.target do
                        local current_x = self.target[i][1];
                        local current_y = self.target[i][2];

                        if general_position_x ~= current_x and general_position_y ~= current_y and general_region ~= world:region_data_at_position(current_x, current_y) then
                            local current_distance = distance_squared(general_position_x, general_position_y, current_x, current_y);

                            if current_distance < closest_distance then
                                closest_distance = current_distance;
                                desired_position.x = current_x;
                                desired_position.y = current_y;
                            end;
                        end;
                    end;

                    out.invasions("\tMoving... ["..desired_position.x..", "..desired_position.y.."]");
                    cm:move_to_queued(general_lookup, desired_position.x, desired_position.y);
                end
            end
        end
    else
        -- This invasion force is a null interface, likely meaning it is dead
        out.invasions("\tForce is a null interface, assuming it has died...");

        if self.respawn == true then
            self:attempt_respawn();
        else
            self.target_type = "NONE";
            should_remove = true;
        end
    end

    if self.target_type == "NONE" then
        local general = self:get_general();

        if general:is_null_interface() == false then
            local general_cqi = general:command_queue_index();
            local general_lookup = "character_cqi:"..general_cqi;

            if self.stop_at_end == true then
                out.invasions("\tInvasion has been told to stop after completion");
                out.invasions("\tDisabling movement for invasion general");
                cm:cai_disable_movement_for_character(general_lookup);
            else
                out.invasions("\tEnabling movement for invasion general ["..general_lookup.."]");
                cm:cai_enable_movement_for_character(general_lookup);
                cm:enable_movement_for_character(general_lookup);
                should_remove = true;
            end
        end

        if should_remove == true then
            invasion_manager:remove_invasion(self.key);
        end
    end
end
