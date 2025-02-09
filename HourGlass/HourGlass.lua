-- Load dependencies
local _, HourGlass = ... -- Namespace table

_HourGlassShared = {}
_HourGlassShared.GUI = {}


-- Bootstrap
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UPDATE_FACTION")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "HourGlass" then
            _HourGlassShared.GUI:CreateMinimapButton()
        end
    end
end)