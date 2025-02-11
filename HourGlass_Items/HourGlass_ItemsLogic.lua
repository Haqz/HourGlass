local _, HourGlassReputation = ...
local HourGlass = _HourGlassShared

-- Ensure the Reputation.Logic table exists
HourGlass.Items = {}
HourGlass.Items.Logic = {}
HourGlass.Items.GUI = {}
HourGlass.Items.itemData = {}

if not HourGlass then
    error("HourGlass_Reputation requires the HourGlass addon to be enabled.")
    return
end

-- Initialize item data
function HourGlass.Items.Logic:Initialize()
    HourGlass.Item.itemData = HourGlass.Item.itemData or {}
end

-- Track item changes in bags
function HourGlass.Items.Logic:OnBagUpdate()
    for itemID, data in pairs(HourGlass.Items.itemData) do
        local newCount = GetItemCount(itemID)
        if newCount ~= data.lastCount then
            local timeNow = GetTime()
            local timeElapsed = (timeNow - data.startTime) / 3600 -- Convert to hours
            local itemsGained = newCount - data.startCount
            local itemsPerHour = (timeElapsed > 0) and (itemsGained / timeElapsed) or 0

            -- Update item data
            data.lastCount = newCount
            data.itemsGained = itemsGained
            data.itemsPerHour = itemsPerHour
        end
    end
end

-- Update item data periodically
function HourGlass.Items.Logic:UpdateItemData()
    for itemID, data in pairs(HourGlass.Items.itemData) do
        local newCount = GetItemCount(itemID)
        local timeNow = GetTime()
        local timeElapsed = (timeNow - data.startTime) / 3600 -- Convert to hours
        local itemsGained = newCount - data.startCount
        local itemsPerHour = (timeElapsed > 0) and (itemsGained / timeElapsed) or 0

        -- Update item data
        data.lastCount = newCount
        data.itemsGained = itemsGained
        data.itemsPerHour = itemsPerHour
    end

    -- Update the GUI
    HourGlass.Items.GUI:UpdateGUI()
end

function HourGlass.Items.Logic:AddItem(inputText)
    local itemID = tonumber(inputText) -- Check if the input is a number (item ID)
    if not itemID then
        -- itemID = HourGlass.Items.Logic:GetItemIDByName(inputText)
        return
    end

    if itemID and not HourGlass.Items.itemData[itemID] then
        HourGlass.Items.itemData[itemID] = {
            startCount = GetItemCount(itemID),
            lastCount = GetItemCount(itemID),
            startTime = GetTime(),
            itemsGained = 0,
            itemsPerHour = 0
        }
    end
end

-- Get the item ID from the item name
function HourGlass.Items.Logic:GetItemIDByName(itemName)
    for i = 1, 100000 do -- Iterate through possible item IDs
        local name = GetItemInfo(i)
        if name and name:lower() == itemName:lower() then
            return i
        end
    end
    return nil
end

-- Remove an item from tracking
function HourGlass.Items.Logic:RemoveItem(itemID)
    HourGlass.Items.itemData[itemID] = nil
    HourGlass.Items.GUI.removeButtons[itemID] = nil
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "BAG_UPDATE_DELAYED" then
        HourGlass.Items.Logic:OnBagUpdate()
    end
end)

C_Timer.NewTicker(2, function()
    HourGlass.Items.Logic:UpdateItemData()
end)