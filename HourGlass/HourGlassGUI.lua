-- Load dependencies
local _, HourGlass = ... -- Namespace table

function HourGlass.GUI:CreateGUI()
    -- Main Frame
    HourGlass.GUI.guiFrame = CreateFrame("Frame", "HourGlassFrame", UIParent, "BasicFrameTemplateWithInset")
    HourGlass.GUI.guiFrame:SetSize(400, 300)
    HourGlass.GUI.guiFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    HourGlass.GUI.guiFrame:SetMovable(true)
    HourGlass.GUI.guiFrame:EnableMouse(true)
    HourGlass.GUI.guiFrame:RegisterForDrag("LeftButton")
    HourGlass.GUI.guiFrame:SetScript("OnDragStart", HourGlass.GUI.guiFrame.StartMoving)
    HourGlass.GUI.guiFrame:SetScript("OnDragStop", HourGlass.GUI.guiFrame.StopMovingOrSizing)

    -- Title
    HourGlass.GUI.guiFrame.title = HourGlass.GUI.guiFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    HourGlass.GUI.guiFrame.title:SetPoint("CENTER", HourGlass.GUI.guiFrame.TitleBg, "CENTER", 0, 0)
    HourGlass.GUI.guiFrame.title:SetText("HourGlass")

    -- Content Frame (for module-specific content)
    HourGlass.GUI.contentFrame = CreateFrame("Frame", nil, HourGlass.GUI.guiFrame)
    HourGlass.GUI.contentFrame:SetPoint("TOPLEFT", HourGlass.GUI.guiFrame, "TOPLEFT", 10, -30)
    HourGlass.GUI.contentFrame:SetPoint("BOTTOMRIGHT", HourGlass.GUI.guiFrame, "BOTTOMRIGHT", -10, 40)
    HourGlass.GUI.contentFrame:SetFrameLevel(HourGlass.GUI.guiFrame:GetFrameLevel() + 1)

    -- Tab Container (for tabs at the bottom)
    HourGlass.GUI.tabContainer = CreateFrame("Frame", nil, HourGlass.GUI.guiFrame)
    HourGlass.GUI.tabContainer:SetPoint("BOTTOMLEFT", HourGlass.GUI.guiFrame, "BOTTOMLEFT", 10, 10)
    HourGlass.GUI.tabContainer:SetPoint("BOTTOMRIGHT", HourGlass.GUI.guiFrame, "BOTTOMRIGHT", -10, 10)
    HourGlass.GUI.tabContainer:SetHeight(30)

    -- Initialize Tabs
    HourGlass.GUI.tabs = {}
    HourGlass.GUI:CreateTab("Reputation")
    -- Add more tabs here as needed, e.g., HourGlass.GUI:CreateTab("Gold")
end

function HourGlass.GUI:CreateTab(name)
    local tab = CreateFrame("Button", nil, HourGlass.GUI.tabContainer)
    tab:SetSize(80, 25)
    tab:SetText(name)
    tab:SetNormalFontObject("GameFontNormal")
    tab:SetHighlightFontObject("GameFontHighlight")

    -- Position the tab
    if #HourGlass.GUI.tabs == 0 then
        tab:SetPoint("LEFT", HourGlass.GUI.tabContainer, "LEFT", 0, 0)
    else
        tab:SetPoint("LEFT", HourGlass.GUI.tabs[#HourGlass.GUI.tabs], "RIGHT", 5, 0)
    end

    -- Store the tab in the table
    table.insert(HourGlass.GUI.tabs, tab)

    -- Set the click handler
    tab:SetScript("OnClick", function()
        HourGlass.GUI:SwitchTab(name)
    end)
end

function HourGlass.GUI:SwitchTab(name)
    -- Hide all content
    for _, module in pairs(HourGlass.GUI.modules) do
        if module.content then
            module.content:Hide()
        end
    end

    -- Highlight the selected tab
    for _, tab in pairs(HourGlass.GUI.tabs) do
        if tab:GetText() == name then
            tab:SetTextColor(1, 1, 0) -- Yellow for selected tab
        else
            tab:SetTextColor(1, 1, 1) -- White for unselected tabs
        end
    end

    -- Show the selected module's content
    if HourGlass.GUI.modules[name] and HourGlass.GUI.modules[name].content then
        HourGlass.GUI.modules[name].content:Show()
    end
end

HourGlass.GUI.modules = {}

function HourGlass.GUI:RegisterModule(name, contentFrame)
    HourGlass.GUI.modules[name] = {
        content = contentFrame
    }
    contentFrame:SetParent(HourGlass.GUI.contentFrame)
    contentFrame:SetAllPoints(HourGlass.GUI.contentFrame)
    contentFrame:Hide() -- Hide by default
end

function HourGlass.GUI:CreateMinimapButton()
    local button = CreateFrame("Button", "HourGlassMinimapButton", Minimap)
    button:SetFrameStrata("MEDIUM")
    button:SetSize(32, 32)
    button:SetMovable(true)

    -- Set default position (Top Right of Minimap)
    button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    -- Add a mask texture
    local mask = button:CreateMaskTexture()
    mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask") -- Circle mask (can use other shapes)
    mask:SetSize(22, 22) -- Match the button size
    mask:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3) -- Anchor to the top-left corner of the button

    -- Set the icon texture
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\ICONS\\Trade_Archaeology_GemmedDrinkingCup") -- The archaeology icon
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3) -- Anchor to the top-left corner of the button
    icon:SetSize(22, 22) -- Scale the icon (smaller than the button)
    icon:AddMaskTexture(mask) -- Apply the mask to constrain the texture

    -- Add a border texture
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder") -- Blizzard's built-in border
    border:SetSize(54, 54) -- Adjust size to match the button
    border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)

    -- Button Script: Toggle GUI on Click
    button:SetScript("OnClick", function()
        if HourGlass.GUI.guiFrame then
            if HourGlass.GUI.guiFrame:IsShown() then
                HourGlass.GUI.guiFrame:Hide()
            else
                HourGlass.GUI.guiFrame:Show()
            end
        else
            HourGlass.GUI:CreateGUI()
        end
    end)

    -- Dragging the Button
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    -- Save reference
    self.minimapButton = button
end