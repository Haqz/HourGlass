local _, HourGlassReputation = ...
local HourGlass = _HourGlassShared

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end


function HourGlass.Items.GUI:UpdateGUI()
    if not HourGlass.Items.GUI.contentFrame then
        -- Create the content frame for the Items module
        HourGlass.Items.GUI.contentFrame = CreateFrame("Frame", nil, HourGlass.GUI.contentFrame)
        HourGlass.Items.GUI.contentFrame:SetAllPoints(HourGlass.GUI.contentFrame)

        -- Create an input field for adding items
        HourGlass.Items.GUI.inputBox = CreateFrame("EditBox", nil, HourGlass.Items.GUI.contentFrame, "InputBoxTemplate")
        HourGlass.Items.GUI.inputBox:SetSize(150, 30)
        HourGlass.Items.GUI.inputBox:SetPoint("TOPLEFT", HourGlass.Items.GUI.contentFrame, "TOPLEFT", 10, -10)
        HourGlass.Items.GUI.inputBox:SetAutoFocus(false)
        HourGlass.Items.GUI.inputBox:SetText("Enter item name or ID")

        -- Create a button to submit the input
        HourGlass.Items.GUI.addButton = CreateFrame("Button", nil, HourGlass.Items.GUI.contentFrame, "GameMenuButtonTemplate")
        HourGlass.Items.GUI.addButton:SetSize(80, 30)
        HourGlass.Items.GUI.addButton:SetPoint("LEFT", HourGlass.Items.GUI.inputBox, "RIGHT", 10, 0)
        HourGlass.Items.GUI.addButton:SetText("Add Item")
        HourGlass.Items.GUI.addButton:SetScript("OnClick", function()
            local inputText = HourGlass.Items.GUI.inputBox:GetText()
            HourGlass.Items.Logic:AddItem(inputText)
            HourGlass.Items.GUI.inputBox:SetText("") -- Clear the input field
        end)

        -- Initialize a table to store remove buttons
        HourGlass.Items.GUI.removeButtons = {}
        -- Register the Items module with the GUI system
        HourGlass.GUI:RegisterModule("Items", HourGlass.Items.GUI.contentFrame)
    end

    -- Clear previous content
    if HourGlass.Items.GUI.contentFrame.content then
        for _, line in ipairs(HourGlass.Items.GUI.contentFrame.content) do
            line:Hide()
        end
    end

    -- Hide all existing remove buttons
    for _, button in pairs(HourGlass.Items.GUI.removeButtons) do
        button:Hide()
    end

    -- Populate the content frame with item data
    local offset = -50 -- Adjust offset to account for the input field
    for itemID, data in pairs(HourGlass.Items.itemData) do
        local itemName = GetItemInfo(itemID)
        if itemName then
            local line1 = HourGlass.GUI:CreateLine(
                string.format("%s: %.2f/hour", itemName, data.itemsPerHour),
                HourGlass.Items.GUI.contentFrame,
                HourGlass.GUI.contentFrame,
                10,
                offset
            )

            -- Create or reuse a remove button for the item
            local removeButton = HourGlass.Items.GUI.removeButtons[itemID]
            if not removeButton then
                removeButton = CreateFrame("Button", nil, HourGlass.Items.GUI.contentFrame, "GameMenuButtonTemplate")
                removeButton:SetSize(60, 20)
                removeButton:SetText("Remove")
                HourGlass.Items.GUI.removeButtons[itemID] = removeButton
            end
            removeButton:SetPoint("LEFT", line1, "RIGHT", 10, 0)
            removeButton:SetScript("OnClick", function()
                HourGlass.Items.Logic:RemoveItem(itemID)
                HourGlass.Items.GUI:UpdateGUI() -- Refresh the GUI
            end)
            removeButton:Show()

            table.insert(HourGlass.Items.GUI.contentFrame.content, line1)
            offset = offset - 20
        end
    end
end
