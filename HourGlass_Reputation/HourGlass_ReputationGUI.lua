local _, HourGlassReputation = ...
local HourGlass = _HourGlassShared

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end

function HourGlass.Reputation.GUI:UpdateGUI()
    if not HourGlass.Reputation.GUI.contentFrame then
        HourGlass.Reputation.GUI.contentFrame = CreateFrame("Frame", nil, HourGlass.GUI.contentFrame)
        HourGlass.Reputation.GUI.contentFrame:SetAllPoints(HourGlass.GUI.contentFrame)

        -- Register the Reputation module with the GUI system
        HourGlass.GUI:RegisterModule("Reputation", HourGlass.Reputation.GUI.contentFrame)
    end
    -- Clear previous content
    if HourGlass.Reputation.GUI.contentFrame.content then
        for _, line in ipairs(HourGlass.Reputation.GUI.contentFrame.content) do
            line:Hide()
        end
    end
    HourGlass.Reputation.GUI.contentFrame.content = {}

    -- Populate the content frame with reputation data

    local offset = -10
    for factionName, data in pairs(HourGlass.Reputation.factionData) do
        if data.repGained > 0 then
            local line1 = HourGlass.GUI:CreateLine(
                string.format("%s: %.2f Rep/hour", factionName, data.repPerHour),
                HourGlass.Reputation.GUI.contentFrame,
                HourGlass.GUI.contentFrame,
                10,
                offset
            )

            table.insert(HourGlass.Reputation.GUI.contentFrame.content, line1)
            offset = offset - 20
        end
    end
end
