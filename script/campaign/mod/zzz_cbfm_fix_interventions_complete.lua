--[[
Fix for when multiple interventions trigger and somehow they break the event feed.
]]--

out("Frodo45127: Fixing interventions breaking the event feed.")

-- called when all enqueued interventions complete (for whatever reason) - this releases the UI/events/etc
function intervention_manager:all_interventions_completed()
    local separator_str = "==============================================================================================================";

    -- don't do anything if the intervention system is not active
    if not self.intervention_currently_active then
        if self.intervention_system_debug then
            self:out("");
            self:out("");
            self:out(separator_str);
            self:out("intervention_manager:all_interventions_completed() called but no intervention currently active, returning");

            -- ensure that the ui is unlocked at this point
            self:lock_ui(false);

            self:out(separator_str);

        end;

        -- Frodo45127: Unsupress all event messages BEFORE exiting.
        self:suppress_all_event_feed_messages(false);

        return;
    end;

    if self.intervention_system_debug then
        local output_stamp = self:get_next_output_stamp();

        out("###### intervention_manager:all_interventions_completed() called, output_stamp is [" .. output_stamp .. "] - see interventions tab for more output ######");
        self:out("");
        self:out("");
        self:out(separator_str);
        self:out("intervention_manager:all_interventions_completed() called, output_stamp is [" .. output_stamp .. "]");
        self:inc_tab();
    end;

    -- unsuppress event feed messages
    self:suppress_all_event_feed_messages(false);

    -- allow the game to be saved again
    cm:disable_saving_game(false);

    -- unlock ui
    self:lock_ui(false);

    -- stop any running context change monitor
    self:stop_context_change_monitor("all interventions completed");

    -- reset values
    if self.intervention_system_debug then
        self:out("resetting cost values - current expenditure is now [0], max expenditure is now [" .. cm.campaign_intervention_max_cost_points_per_session .. "]");
    end;

    self.num_interventions_in_current_sequence = 0;
    self.current_expenditure = 0;
    self.current_max_session_cost = cm.campaign_intervention_max_cost_points_per_session;

    self.intervention_currently_active = false;

    -- pan camera back up to altitude if it's not been moved by the player
    if self.camera_cache_position_set and not self:camera_has_moved_from_cached() then
        if self.intervention_system_debug then
            self:out("camera moved at some point during the intervention sequence, restoring");
        end;

        local x, y = cm:get_camera_position();
        local d = 14;
        local b = 0;
        local h = d * 1.25;

        CampaignUI.ZoomToSmooth(x, y, d, b, h);

        self:reset_cached_camera_position();
    end;

    if self.intervention_system_debug then
        if not self.camera_cache_position_set then
            self:out("no cached camera position, not restoring camera");
        else
            self:out("camera has moved from cached position, not restoring");
        end;
    end;

    if self.intervention_system_debug then
        self:dec_tab();
        self:out(separator_str);
    end;
end;
