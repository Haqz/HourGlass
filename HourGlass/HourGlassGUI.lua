-- Load dependencies
local _, HourGlass = ... -- Namespace table

_HourGlassShared.GUI.modules = {}

function _HourGlassShared.GUI:CreateGUI()
    -- Main Frame
    _HourGlassShared.GUI.guiFrame = CreateFrame("Frame", "HourGlassFrame", UIParent, "BasicFrameTemplateWithInset")
    _HourGlassShared.GUI.guiFrame:SetSize(400, 300)
    _HourGlassShared.GUI.guiFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    _HourGlassShared.GUI.guiFrame:SetMovable(true)
    _HourGlassShared.GUI.guiFrame:EnableMouse(true)
    _HourGlassShared.GUI.guiFrame:RegisterForDrag("LeftButton")
    _HourGlassShared.GUI.guiFrame:SetScript("OnDragStart", _HourGlassShared.GUI.guiFrame.StartMoving)
    _HourGlassShared.GUI.guiFrame:SetScript("OnDragStop", _HourGlassShared.GUI.guiFrame.StopMovingOrSizing)
    _HourGlassShared.GUI.guiFrame:SetFrameStrata("BACKGROUND")

    -- Title
    _HourGlassShared.GUI.guiFrame.title = _HourGlassShared.GUI.guiFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    _HourGlassShared.GUI.guiFrame.title:SetPoint("CENTER", _HourGlassShared.GUI.guiFrame.TitleBg, "CENTER", 0, 0)
    _HourGlassShared.GUI.guiFrame.title:SetText("HourGlass")

    -- Content Frame (for module-specific content)
    _HourGlassShared.GUI.contentFrame = CreateFrame("Frame", nil, _HourGlassShared.GUI.guiFrame)
    _HourGlassShared.GUI.contentFrame:SetPoint("TOPLEFT", _HourGlassShared.GUI.guiFrame, "TOPLEFT", 10, -30)
    _HourGlassShared.GUI.contentFrame:SetPoint("BOTTOMRIGHT", _HourGlassShared.GUI.guiFrame, "BOTTOMRIGHT", -10, 40)
    _HourGlassShared.GUI.contentFrame:SetFrameStrata("HIGH")

    -- Tab Container (for tabs at the bottom)
    _HourGlassShared.GUI.tabContainer = CreateFrame("Frame", nil, _HourGlassShared.GUI.guiFrame)
    _HourGlassShared.GUI.tabContainer:SetPoint("BOTTOMLEFT", _HourGlassShared.GUI.guiFrame, "BOTTOMLEFT", 10, 10)
    _HourGlassShared.GUI.tabContainer:SetPoint("BOTTOMRIGHT", _HourGlassShared.GUI.guiFrame, "BOTTOMRIGHT", -10, 10)
    _HourGlassShared.GUI.tabContainer:SetHeight(30)

    -- Initialize Tabs
    _HourGlassShared.GUI.tabs = {}
    _HourGlassShared.GUI:CreateTab("Reputation")
    _HourGlassShared.GUI:CreateTab("Gold")
    -- Add more tabs here as needed, e.g., HourGlass.GUI:CreateTab("Gold")
end

function _HourGlassShared.GUI:CreateTab(name)
    local tab = CreateFrame("Button", nil, _HourGlassShared.GUI.tabContainer)
    tab:SetSize(80, 25)
    tab:SetText(name)
    tab:SetNormalFontObject("GameFontNormal")
    tab:SetHighlightFontObject("GameFontHighlight")

    -- Position the tab
    if #_HourGlassShared.GUI.tabs == 0 then
        tab:SetPoint("LEFT", _HourGlassShared.GUI.tabContainer, "LEFT", 0, 0)
    else
        tab:SetPoint("LEFT", _HourGlassShared.GUI.tabs[#_HourGlassShared.GUI.tabs], "RIGHT", 5, 0)
    end

    -- Store the tab in the table
    table.insert(_HourGlassShared.GUI.tabs, tab)

    -- Set the click handler
    tab:SetScript("OnClick", function()
        _HourGlassShared.GUI:SwitchTab(name)
    end)
end

function _HourGlassShared.GUI:SwitchTab(name)
    -- Hide all content
    for _, module in pairs(_HourGlassShared.GUI.modules) do
        if module.content then
            module.content:Hide()
        end
    end

    -- Show the selected module's content
    if _HourGlassShared.GUI.modules[name] and _HourGlassShared.GUI.modules[name].content then

        _HourGlassShared.GUI.modules[name].content:Show()
    end
end


function _HourGlassShared.GUI:RegisterModule(name, contentFrame)
    _HourGlassShared.GUI.modules[name] = {
        content = contentFrame
    }
    contentFrame:SetParent(_HourGlassShared.GUI.contentFrame)
    contentFrame:SetAllPoints(_HourGlassShared.GUI.contentFrame)
    contentFrame:Hide() -- Hide by default
end

function _HourGlassShared.GUI:UpdateModuleContent(name, contentFrame)
    _HourGlassShared.GUI.modules[name] = {
        content = contentFrame
    }
end

function _HourGlassShared.GUI:CreateMinimapButton()
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
        if _HourGlassShared.GUI.guiFrame then
            if _HourGlassShared.GUI.guiFrame:IsShown() then
                _HourGlassShared.GUI.guiFrame:Hide()
            else
                _HourGlassShared.GUI.guiFrame:Show()
            end
        else
            _HourGlassShared.GUI:CreateGUI()
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