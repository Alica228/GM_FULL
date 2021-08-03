
StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
  text = "Do you want to greet the world today?",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
      GreetTheWorld()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3
}

-- быстрое открытие меню по лвлу
local function myChatFilter(self, event, msg, author, ...)
	if     msg:find("Your account level is: 4") then
		view = 3
	elseif msg:find("Your account level is: 3") then
		view = 3
	elseif msg:find("Your account level is: 2") then
		view = 2
	elseif msg:find("Your account level is: 1") then
		view = 1
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter)



function OpenMain()
    if( view == nil ) then
        FullForm:Show();
    elseif( view == 1 ) then
        GMFirst:Show();
    elseif( view == 2 ) then
        GMSecond:Show();
    elseif( view == 3 ) then
        GMThird:Show();
    else
        FullForm:Show();
    end
end

-- при ЛКМ на кнопку около миникарты
function ToggleAddon()
	if( addonopen == 1 ) then
		FullForm:Hide()
		GMFirst:Hide()
		GMSecond:Hide()
		GMThird:Hide()
		TicketForm:Hide()
		TeleForm:Hide()
		NotesFu:Hide()
		MiscFormFirst:Hide()
		MiscFormSecond:Hide()
		MiscFormThird:Hide()
		QuickPortalForm:Hide()
		QuestForm:Hide()
		MorphForm:Hide()
		NPCForm:Hide()
		ModifyForm:Hide()
		RebootForm:Hide()
		AddForm:Hide()
		EventForm:Hide()
		BanForm:Hide()
		KalimdorForm:Hide()
		EasternForm:Hide()
		OutlandForm:Hide()
		NorthrendForm:Hide()
		AnnounceForm:Hide()
		ObjectForm:Hide()
		SearchForm:Hide()
		addonopen = 0;
	else
		OpenMain();
		addonopen = 1;
	end
end

function GMHelperOnLoad(self)
    self:SetMovable(true);
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
	self:SetScript("OnHide", self.StopMovingOrSizing)
end

function GMHelper_Loaded()
	UIErrorsFrame:AddMessage("GM Helper loaded!", 0.0, 1.0, 0.0, 53, 2);
	OpenMain();
	addonopen = 1;
end


-- показывает подсказку, если навести мышкой на кнопку у миникарты
function ShowGMHMinimap(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	GameTooltip:AddLine( "|cFF00FF00GM Helper|r" );
	GameTooltip:AddLine( "|cFF00FFCCЛКМ - показать/скрыть меню|r" );
	GameTooltip:AddLine( "|cFFFF0000ПКМ - двигать эту кнопку|r" );
	GameTooltip:Show();
end

-- менюшки в ПКМ на ник
UnitPopupButtons["MUTE_BUTTON"] = {text = "|cFFFFFF00Меню мутов|r", dist = 0}
UnitPopupButtons["BAN_BUTTON"] = {text = "|cFFFF0000Меню банов|r", dist = 0}
table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "MUTE_BUTTON")
table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "BAN_BUTTON")

local function testPlayerMenuButton(self)
    local name = FriendsDropDown.name;
	if self.value == "MUTE_BUTTON" then
		NotesFu:Show();
		MuteCharName:SetText(name)
	elseif self.value == "BAN_BUTTON" then
		BanForm:Show();
		BanName:SetText(name)
	end
end

hooksecurefunc("UnitPopup_OnClick",testPlayerMenuButton)
