local _, HourGlassReputation = ...
local HourGlass = _HourGlassShared

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end


function HourGlass.Reputation.GUI:UpdateGUI()
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
            local line = HourGlass.Reputation.GUI.contentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            line:SetPoint("TOPLEFT", HourGlass.GUI.contentFrame, "TOPLEFT", 10, offset)
            line:SetText(string.format("%s: %.2f Rep/hour", factionName, data.repPerHour))
            line:SetJustifyH("LEFT")

            table.insert(HourGlass.Reputation.GUI.contentFrame.content, line)
            offset = offset - 20
        end
    end
end
