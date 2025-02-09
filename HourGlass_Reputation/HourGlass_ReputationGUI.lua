local _, HourGlass = ...

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end
-- Ensure the Reputation.GUI table exists
HourGlass.Reputation = HourGlass.Reputation or {}
HourGlass.Reputation.GUI = HourGlass.Reputation.GUI or {}

function HourGlass.Reputation.GUI:UpdateGUI()
    if not HourGlass.Reputation.GUI.contentFrame then
        -- Create the content frame for the Reputation module
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
    for factionName, data in pairs(HourGlass.factionData) do
        if data.repGained > 0 then
            local line = HourGlass.Reputation.GUI.contentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            line:SetPoint("TOPLEFT", HourGlass.Reputation.GUI.contentFrame, "TOPLEFT", 10, offset)
            line:SetText(string.format("%s: %.2f Rep/hour", factionName, data.repPerHour))
            line:SetJustifyH("LEFT")

            table.insert(HourGlass.Reputation.GUI.contentFrame.content, line)
            offset = offset - 20
        end
    end
end
