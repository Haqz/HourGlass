local _, HourGlassReputation = ...
local HourGlass = _HourGlassShared

-- Ensure the Reputation.Logic table exists
HourGlass.Reputation = {}
HourGlass.Reputation.factionData = {}
HourGlass.Reputation.Logic = {}
HourGlass.Reputation.GUI = {}

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end

local function FormatTime(hours)
    if not hours or hours < 0 then
        return "∞"
    end
    local totalMinutes = math.floor(hours * 60)
    local h = math.floor(totalMinutes / 60)
    local m = totalMinutes % 60
    return string.format("%02d:%02d", h, m)
end

HourGlass.Reputation.Logic.FormatTime = FormatTime

function HourGlass.Reputation.Logic:OnFactionUpdate()
    local factionData = HourGlass.Reputation.factionData

    for i = 1, GetNumFactions() do
        local name, _, _, _, _, earnedValue, _, _, isHeader = GetFactionInfo(i)
        if name and not isHeader then
            if not factionData[name] then
                -- Initialize data for new faction
                factionData[name] = {
                    startReputation = earnedValue,
                    startTime = GetTime(),
                    repGained = 0,
                    repPerHour = 0,
                    timeToExalted = nil
                }
            else
                -- Update reputation data
                local data = factionData[name]
                local repGained = earnedValue - data.startReputation
                local elapsedTime = (GetTime() - data.startTime) / 3600
                local repPerHour = (elapsedTime > 0) and (repGained / elapsedTime) or 0

                -- Calculate time to Exalted
                local remainingRep = 42000 - earnedValue
                local timeToExalted = (repPerHour > 0) and (remainingRep / repPerHour) or nil

                -- Update stored data
                data.repGained = repGained
                data.repPerHour = repPerHour
                data.timeToExalted = timeToExalted
            end
        end
    end

    -- Update the GUI after processing reputation data
    HourGlass.Reputation.GUI:UpdateGUI()
end

function HourGlass.Reputation.Logic:UpdateFactionData()
    local factionData = HourGlass.Reputation.factionData

    for factionName, data in pairs(factionData) do
        if data.repGained > 0 then
            -- Calculate elapsed time
            local elapsedTime = (GetTime() - data.startTime) / 3600
            local repPerHour = (elapsedTime > 0) and (data.repGained / elapsedTime) or 0

            -- Update time to Exalted
            local remainingRep = 42000 - (data.startReputation + data.repGained)
            local timeToExalted = (repPerHour > 0) and (remainingRep / repPerHour) or nil

            -- Update faction data
            data.repPerHour = repPerHour
            data.timeToExalted = timeToExalted
        end
    end

    -- Refresh the GUI
    HourGlass.Reputation.GUI:UpdateGUI()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_FACTION")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "UPDATE_FACTION" then
        HourGlass.Reputation.Logic:OnFactionUpdate()
    elseif event == "ADDON_LOADED" then
        if not HourGlass.Reputation.GUI.contentFrame then
            -- Create the content frame for the Reputation module
            HourGlass.Reputation.GUI.contentFrame = CreateFrame("Frame", nil, HourGlass.GUI.contentFrame)
            HourGlass.Reputation.GUI.contentFrame:SetAllPoints(HourGlass.GUI.contentFrame)

            -- Register the Reputation module with the GUI system
            HourGlass.GUI:RegisterModule("Reputation", HourGlass.Reputation.GUI.contentFrame)
        end
    end
end)

C_Timer.NewTicker(2, function()
    HourGlass.Reputation.Logic:UpdateFactionData()
end)