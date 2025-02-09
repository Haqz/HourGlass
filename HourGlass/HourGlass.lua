-- Load dependencies
local _, HourGlass = ... -- Namespace table

-- Load modules
HourGlass.GUI = HourGlass.GUI or {} -- Ensure GUI table exists
HourGlass.Reputation = HourGlass.Reputation or {} -- Ensure Reputation table exists
HourGlass.Reputation.Logic = HourGlass.Reputation.Logic or {}
HourGlass.Reputation.GUI = HourGlass.Reputation.GUI or {}
-- Bootstrap
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UPDATE_FACTION")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "HourGlass" then
            HourGlass.GUI:CreateMinimapButton()
        end
    end
end)