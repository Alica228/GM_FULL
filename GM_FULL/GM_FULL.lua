-- глобальные переменные
gmModEnabled = false
gmVisEnabled = false
MAX_MORPH = 85063

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
	if msg:find("["..UnitName("player").."]'s Fly Mode on") then
		gmFlyEnabled = true
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly Off|r");
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly Off|r");
	elseif msg:find("["..UnitName("player").."]'s Fly Mode off") then
		gmFlyEnabled = false
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly On|r");
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly On|r");
	elseif msg:find("Your account level is:") then
		gmLevel = tonumber(msg:match("Your account level is: (\d+)"))
	elseif msg:find("Ticket entry") then
		res, _ = msg:gsub("%D+", "")
		SendChatMessage(".ticket viewid "..res, "GUILD", nil, nil);
		if TicketForm:IsShown() then
			TicketID:SetText(tonumber(res))
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter)



function OpenMain()
    if( gmLevel == nil ) then
        FullForm:Show();
    elseif( gmLevel == 1 ) then
        GMFirst:Show();
    elseif( gmLevel == 2 ) then
        GMSecond:Show();
    elseif( gmLevel >= 3 ) then
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
		MutesFirst:Hide()
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
	gmFlyButtonOnLoad()
	gmModButtonOnLoad()
	gmVisButtonOnLoad()
end

function GMHelper_Loaded()
	UIErrorsFrame:AddMessage("Доброго времени суток!", 0.0, 1.0, 0.0, 53, 2);
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


-- менюшки в ПКМ на себя
UnitPopupButtons["TELE_BUTTON"] = {text = "|cFFFFFF00Телепорты|r", dist = 0}
table.insert(UnitPopupMenus["TELE_BUTTON"], #UnitPopupMenus["TELE_BUTTON"]-1, "TELE_BUTTON")

-- менюшки в ПКМ на ник в чате
UnitPopupButtons["MUTE_BUTTON"] = {text = "|cFFFFFF00Меню мутов|r", dist = 0}
UnitPopupButtons["BAN_BUTTON"] = {text = "|cFFFF0000Меню банов|r", dist = 0}
table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "MUTE_BUTTON")
table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"]-1, "BAN_BUTTON")

local function friendsButtonsOnClick(self)
    local name = FriendsDropDown.name;
	if self.value == "MUTE_BUTTON" then
		MutesFirst:Show();
		MuteCharName:SetText(name)
	elseif self.value == "BAN_BUTTON" then
		BanForm:Show();
		BanInfoBox:SetText(name)
	elseif self.value == "TELE_BUTTON" then
		print("here")
	end
end
hooksecurefunc("UnitPopup_OnClick",friendsButtonsOnClick)


GameTooltip:SetScript("OnEvent", function(self, event, errorType, message)
	if event == "UI_ERROR_MESSAGE" then
		if 	   message:find("invisible") then
			gmVisEnabled = true
			gmModEnabled = true
			gmModButtonSecondLvl:SetText("|cFF00FF00GM Off|r");
			gmVisButtonSecondLvl:SetText("|cFF00FF00Vis Off|r");
			gmModButtonThirdLvl:SetText("|cFF00FF00GM Off|r");
			gmVisButtonThirdLvl:SetText("|cFF00FF00Vis Off|r");
		elseif message:find("visible") then
			gmVisEnabled = false
			gmVisButtonSecondLvl:SetText("|cFF00FF00Vis On|r");
			gmVisButtonThirdLvl:SetText("|cFF00FF00Vis On|r");
		elseif message:find("GM mode is ON") then
			gmModEnabled = true
			gmModButtonSecondLvl:SetText("|cFF00FF00GM Off|r");
			gmModButtonThirdLvl:SetText("|cFF00FF00GM Off|r");
		elseif message:find("GM mode is OFF") then
			gmModEnabled = false
			gmModButtonSecondLvl:SetText("|cFF00FF00GM On|r");
			gmModButtonThirdLvl:SetText("|cFF00FF00GM On|r");
		end
	end
end)
GameTooltip:RegisterEvent("UI_ERROR_MESSAGE")


function gmModButtonOnLoad()
	if gmModEnabled then
		gmModButtonSecondLvl:SetText("|cFF00FF00GM Off|r");
		gmModButtonThirdLvl:SetText("|cFF00FF00GM Off|r");
	else
		gmModButtonSecondLvl:SetText("|cFF00FF00GM On|r");
		gmModButtonThirdLvl:SetText("|cFF00FF00GM On|r");
	end
end


function gmModButtonOnClick()
	if gmModEnabled then
		SendChatMessage(".gm off", "GUILD")
		SendChatMessage(".gm chat off", "GUILD")
		gmModButtonSecondLvl:SetText("|cFF00FF00GM On|r")
		gmModButtonThirdLvl:SetText("|cFF00FF00GM On|r")
	else
		SendChatMessage(".gm on", "GUILD")
		SendChatMessage(".gm chat on", "GUILD")
		gmModButtonSecondLvl:SetText("|cFF00FF00GM Off|r")
		gmModButtonThirdLvl:SetText("|cFF00FF00GM Off|r")
	end;
	gmModEnabled = not gmModEnabled
end


function gmVisButtonOnLoad()
	if UnitAura("player", "Прозрачность (50%)", nil, "PLAYER|HARMFUL") then
		gmVisEnabled = true;
		gmVisButtonSecondLvl:SetText("|cFF00FF00Vis Off|r");
		gmVisButtonThirdLvl:SetText("|cFF00FF00Vis Off|r");
	else
		gmVisEnabled = false;
		gmVisButtonSecondLvl:SetText("|cFF00FF00Vis On|r");
		gmVisButtonThirdLvl:SetText("|cFF00FF00Vis On|r");
	end
end


function gmVisButtonOnClick()
	if gmVisEnabled then
		SendChatMessage(".gm vis on", "GUILD")
		gmVisButtonSecondLvl:SetText("|cFF00FF00Vis On|r")
		gmVisButtonThirdLvl:SetText("|cFF00FF00Vis On|r")
	else
		gmModEnabled = true
		SendChatMessage(".gm vis off", "GUILD")
		gmVisButtonSecondLvl:SetText("|cFF00FF00Vis Off|r")
		gmVisButtonThirdLvl:SetText("|cFF00FF00Vis Off|r")
		gmModButtonSecondLvl:SetText("|cFF00FF00GM Off|r")
	end;
	gmVisEnabled = not gmVisEnabled;
end


function gmFlyButtonOnLoad()
	if UnitAura("player", "Полет", nil, "PLAYER|HELPFUL") then
		gmFlyEnabled = true;
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly Off|r");
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly Off|r");
	else
		gmVisEnabled = false;
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly On|r");
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly On|r");
	end
end


function gmFlyButtonOnClick()
	if gmFlyEnabled then
		SendChatMessage(".gm fly off", "GUILD")
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly On|r")
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly On|r")
	else
		SendChatMessage(".gm fly on", "GUILD")
		gmFlyButtonSecondLvl:SetText("|cFF00FF00Fly Off|r")
		gmFlyButtonThirdLvl:SetText("|cFF00FF00Fly Off|r")
	end
	gmFlyEnabled = not gmFlyEnabled
end


function MorphButton()
	if not MorphForm:IsShown() then
		return
	end
	if MutePlayerNameBox:GetText() == nil then
		SendChatMessage(".demorph", "GUILD", nil, nil)
	else
		SendChatMessage(".morph "..MorphIDBox:GetText(), "GUILD", nil, nil)
	end
end


function QuestCheckButtonOnClick()
	if not QuestForm:IsShown() then
		return
	end
	if QuestIDBox:GetNumLetters() < 1 then
		SendChatMessage(".look quest "..QuestNameBox:GetText(), "GUILD", nil, nil);
	elseif QuestNameBox:GetNumLetters() < 1 then
		SendChatMessage(".quest status "..QuestIDBox:GetText(), "GUILD", nil, nil);
	else
		SendChatMessage(".look quest "..QuestNameBox:GetText(), "GUILD", nil, nil);
		SendChatMessage(".quest status "..QuestIDBox:GetText(), "GUILD", nil, nil);
	end
	QuestNameBox:ClearFocus()
	QuestIDBox:ClearFocus()
end


function QuestActionButtonOnClick(action)
	if not QuestForm:IsShown() then
		return
	end
	local questTable = {}
	for questID in string.gmatch(QuestIDBox:GetText(), "([^"..",".."]+)") do
		table.insert(questTable, questID)
	end
	for i = 1, #questTable do
		C_Timer.After(0.001*i, function()
			SendChatMessage(".quest "..action.." "..questTable[i], "GUILD", nil, nil)
		end)
	end
	QuestIDBox:ClearFocus()
end


function DoOrderHallButtonOnClick()
	if not QuestForm:IsShown() then
		return
	end
	local localizedClass, englishClass, classIndex = UnitClass("target");
	if 		englishClass == "WARRIOR" 	then
		questTable = {41105,40043,39191,42814,41052,42815,38904,39654,40579,40582,40581,40580,39530,39192,39214,40585,42597,42598,42606,42605,42607,42609,42610,42611,43750,42193,42194,42650,42651,42107,42614,42110,42202,42204,43585,43975,43586,43604,43090,42616,42618,42918,44667,43506,43577,42974,42619,43425,46173,44849,44850,45118,45834,45128,44889,45634,45648,45632,45649,45647,45650,45633,46267,45876,45873,46208,46207};
	elseif 	englishClass == "PALADIN" 	then
		questTable = {42231,42120,42000,42002,42005,42017,42770,42772,42771,42773,42774,38376,38710,40408,40410,40411,40409,42812,38576,42811,42812,38576,42811,38566,39722,38933,39756,42844,39696,42846,42847,42848,42849,42867,42850,42919,42136,42960,42135,42961,42885,42966,42967,42968,42885,42966,42967,42968,42136,42960,42135,42961,42886,42887,43462,42888,42890,42852,42851,43494,43486,43487,43488,43535,43493,43489,43490,43491,43540,43541,43492,43934,43933,43699,43698,43534,43700,43697,43785,43424,43701,47137,45143,45890,46259,45145,45146,45147,45148,45149,46045,24707,24707,45773,45561,45562,45565,45566,45567,45568,45644,45645,45813,46069,46070,46071,46083,46074,45770};
	elseif 	englishClass == "HUNTER" 		then
		questTable = {41541,41574,42158,42185,41540,40392,40419,41542,39427,40385,40384,41415,40618,40621,40620,40619,41009,40952,41008,41009,40952,41008,40953,40954,40955,41053,41047,40958,40959,44090,42519,40957,42409,42523,42524,42525,42526,42384,42385,42386,42387,42388,42389,42391,42411,42393,42390,43335,42392,42410,42395,42134,42394,42436,42403,42413,42414,42397,42398,42412,42399,42400,42401,42404,42689,42691,42406,42407,42402,44680,42405,42408,43182,42654,42655,42656,42657,42658,42133,42659,42415,43423,45551,45552,45553,45554,45555,45556,45557,46060,46235,46048,46336,46337};
	elseif 	englishClass == "ROGUE" 		then
		questTable = {42501,42502,42503,42539,42568,42504,42627,40847,40849,41919,41920,41921,41922,41924,40832,40839,40840,40842,40843,40844,40950,40994,40995,40996,40997,43007,42139,43261,43262,42140,43013,43014,43015,43958,43829,44041,44116,44155,44117,44177,44183,43841,43852,44181,42730,44178,44180,43468,42684,43253,44252,43249,43250,43251,43252,42678,42680,42800,43469,43470,43479,43485,43508,37666,37448,37494,37689,43723,43724,44215,43422,47137,45833,46322,45835,46324,44758,46323,45073,45848,45836,46326,45571,45573,45576,45628,45629,46260,46827,46059,46058,46103,46089,46178};
	elseif 	englishClass == "PRIEST" 		then
		questTable = {41625,41626,41627,41628,41629,41630,41631,41632,41957,41966,41967,41993,42074,40710,40705,40706,40709,40708,40707,40938,41015,41017,41019,44100,43270,43271,43272,43273,43275,43276,43277,43371,43372,43373,43374,43375,43376,42137,42138,43378,43379,43851,43377,43384,43383,43380,43385,43386,43387,43388,43389,43381,43390,43391,43392,43382,43393,43394,43396,43395,43397,43797,43400,43399,43832,43401,43402,43398,43420,45343,45344,45346,45345,45347,45348,45349,45350,45342,46145,46034,45788,45789};
	elseif 	englishClass == "SHAMAN" 		then
		questTable = {43334,43338,39771,42931,42932,42933,42935,42936,42937,40224,43644,43645,40341,39746,41335,41329,41328,41330,40225,40276,41510,44544,42188,42114,42198,42197,42383,42141,42142,41741,41740,42184,42977,43002,41770,41771,41776,41901,41742,41743,44465,42986,42996,42983,42984,42200,41775,42068,41777,41897,41898,41899,42065,41900,41746,41747,42988,42997,42208,42989,42995,43003,42990,41772,41773,41934,41888,41744,43418,41745,45652,45706,45723,45725,45724,44800,45763,45971,45767,45765,45883,45769,46258,46057,46791,46792};
	elseif 	englishClass == "MAGE" 		then
		questTable = {42001,42006,42007,42008,42009,42010,42011,40267,40270,11997,42452,42455,42476,42477,42479,41035,41036,41085,41079,41080,41081,41114,41125,41112,41113,41124,41141,42175,42663,42662,42685,42703,42126,42127,42687,42696,42433,42418,42434,42435,42166,42206,42149,42171,42222,42706,44098,42416,42705,42423,42424,42451,42954,42955,42956,42959,42704,42508,42494,42521,42493,42520,42702,42707,42940,44689,42734,42917,42914,43415,45437,44766,46335,46338,45207,46705,46339,46345,44768,44770,46351,45251,45614,45586,46000,46290,46043,45615,45630,46722,46723,46724,45844,45845,45846,45847,45354};
	elseif 	englishClass == "WARLOCK" 	then
		questTable = {40495,40588,40604,40606,40611,40623,40712,42128,42168,42125,43100,43153,43254,40716,40729,40684,40686,40688,40687,40731,40821,40823,40824,44099,41750,41748,42608,42603,41797,42602,42601,42097,41759,39179,39389,39142,40218,41767,41752,41753,42100,41798,42098,41768,41769,41781,41780,41784,41754,41751,44682,42660,42103,42102,41785,41788,41787,41793,41755,41795,41756,41796,43414,45021,45024,45025,45026,45794,45027,45028,46020,46047,46237,46238,46239,46240,46241,46242,46243};
	elseif 	englishClass == "MONK" 		then
		questTable = {42762,42766,42767,42957,42868,42765,40569,40633,40634,40570,41003,12103,40236,40636,40640,40639,40638,40698,40793,40795,42186,42187,40704,41115,41945,41946,42210,42191,41905,41728,41729,41730,41731,41732,41733,41734,41735,43319,41907,43062,41909,43054,41849,41850,41852,41853,41851,41854,41737,41738,41736,41038,41039,41040,41910,41086,41911,41059,43151,32442,41087,41739,43359,45440,45404,45459,45574,45449,45545,46320,45442,45771,45790,46353,46341,46342,46343,46344,46346,46347,46348,46349,46350};
	elseif 	englishClass == "DRUID" 		then
		questTable = {40783,40784,40785,40834,40835,40837,40838,42428,42438,42439,42440,42430,41468,41782,41783,41790,41791,41792,40647,41918,40649,41422,41449,41436,41690,41689,40643,41106,40644,40645,40646,40781,40701,40702,40703,41255,40651,41332,40652,40653,42516,42583,40650,42096,42584,42585,42586,42588,42032,42031,42033,42034,42035,42036,42038,42039,43991,40654,42037,44077,44076,44075,44074,42040,42042,42043,42041,42044,42045,42046,42048,42047,42129,42719,43365,43368,42049,42365,43403,42051,42050,42053,42054,42055,42432,42056,43409,44869,44877,45532,44888,44921,45498,45528,46924,45426,46674,46676,46675,46677,45425,46044,46317,46318,46319};
	elseif 	englishClass == "DEMONHUNTER" then
		questTable = {40077,40378,39279,38759,39049,40379,39050,38765,38766,38813,39262,39495,38727,38725,38819,40222,40051,39517,39518,39663,38728,38729,38672,39742,38689,38690,39517,39518,39682,39684,39685,39686,40373,40374,40375,44663,41804,41806,41807,42869,42872,41064,41066,42679,42681,42683,42682,37447,42510,42522,42593,42594,42801,42131,42802,42731,42808,42787,42735,42736,42737,42739,42738,42749,42752,42775,42776,42701,42777,42669,44694,42733,42732,42754,42810,42132,43184,43185,43186,44214,43412,46159,45301,45330,45329,45339,45385,45764,46725,45798,46266,45391,46334};
	elseif 	englishClass == "DEATHKNIGHT" then
		questTable = {40740,38990,40930,40931,40932,40933,40934,40935,40714,40715,40722,40723,40724,39757,39761,39832,39799,42449,42484,44550,43264,39818,39816,43265,43266,43267,43539,43268,42533,42534,42535,42536,42537,44243,42708,44244,44082,43899,43571,43572,44217,42818,42882,42821,42823,42824,44245,43573,43928,44286,44246,44282,44247,44690,43574,43686,44248,43407,45240,45399,45398,45331,44775,44783,46305,44787,45243,45103,46050,46719,46720,46812,46813};
	else										
		questTable = nil;
	end
	if questTable == nil then
		print("You don't have target")
	else
		for i = 1 ,#questTable do
			SendChatMessage(".quest add "..questTable[i],"GUILD", nil, nil);
			SendChatMessage(".quest complete "..questTable[i],"GUILD", nil, nil);
			SendChatMessage(".quest reward "..questTable[i],"GUILD", nil, nil);
		end
	end
end


function AddButtonOnClick(subcommand)
	if not AddForm:IsShown() then
		return
	end
	local addTable = {}
	if 		subcommand == "currency" then
		addCount = CurrencyCountBox:GetText() or "1"
		for addID in string.gmatch(CurrencyIDBox:GetText(), "([^"..",".."]+)") do
			table.insert(addTable, addID)
		end
		for i = 1, #addTable do
			C_Timer.After(0.001*i, function()
				SendChatMessage(".modify "..subcommand.." "..addTable[i].." "..addCount, "GUILD", nil, nil);
			end)
		end
	elseif 	subcommand == "reputation" then
		addCount = FactionCountBox:GetText() or "1"
		for addID in string.gmatch(FactionIDBox:GetText(), "([^"..",".."]+)") do
			table.insert(addTable, addID)
		end
		for i = 1, #addTable do
			C_Timer.After(0.001*i, function()
				SendChatMessage(".modify "..subcommand.." "..addTable[i].." "..addCount, "GUILD", nil, nil);
			end)
		end
	elseif 	subcommand == "item" then
		addCount = ItemCountBox:GetText() or "1"
		addBonuses = ItemBonusBox:GetText() or ""
		for addID in string.gmatch(ItemIDBox:GetText(), "([^"..",".."]+)") do
			table.insert(addTable, addID)
		end
		for i = 1, #addTable do
			C_Timer.After(0.001*i, function()
				SendChatMessage(".additem "..addTable[i].." "..addCount.." "..addBonuses, "GUILD", nil, nil);
			end)
		end
	end
	AddEditBox:ClearFocus()
	FactionIDBox:ClearFocus()
	FactionCountBox:ClearFocus()
	CurrencyIDBox:ClearFocus()
	CurrencyCountBox:ClearFocus()
	ItemIDBox:ClearFocus()
	ItemCountBox:ClearFocus()
	ItemBonusBox:ClearFocus()
end


function NPCTeleIDButtonOnClick(subcommand)
	if not NPCForm:IsShown() then
		return
	end
	local waitTime = 6 -- секунды
	local npcTable = {}
	for npcID in string.gmatch(NPCIDBox:GetText(), "([^"..",".."]+)") do
		table.insert(npcTable, npcID)
	end
	for i=1, #npcTable do
		C_Timer.After(waitTime*(i-1), function()
			SendChatMessage(".go creature"..subcommand.." "..npcTable[i], "GUILD", nil, nil)
		end)
	end
	NPCIDBox:ClearFocus()
end


function MutePlayer()
	if not MutesFirst:IsShown() then
		return
	end
	if MutePlayerNameBox:GetNumLetters() < 1 or MuteTimeBox:GetNumLetters() < 1 or MuteReasonBox:GetNumLetters() < 1 then
		ShowMessage( "Заполните все необходимые поля!", "FF0000", 1 );
	else
		MutePlayerNameBox:ClearFocus();
		MuteReasonBox:ClearFocus();
		MuteTimeBox:ClearFocus();
		SendChatMessage(".mute "..MutePlayerNameBox:GetText().." "..MuteTimeBox:GetText().." "..MuteReasonBox:GetText(), "GUILD", nil, nil); 
	end
end


function BanPlayer(subcommand)
	if not BanForm:IsShown() then
		return
	end
	if BanInfoBox:GetNumLetters() < 1 or BanTimeBox:GetNumLetters()< 1 or BanReasonBox:GetNumLetters() < 1 then
		ShowMessage( "Заполните все необходимые поля!", "FF0000", 1 );
	else
		SendChatMessage(".ban "..subcommand.." "..BanInfoBox:GetText().." "..BanTimeBox:GetText().." "..BanReasonBox:GetText(), "GUILD", nil, nil);
	end
	BanInfoBox:ClearFocus()
	BanTimeBox:ClearFocus()
	BanReasonBox:ClearFocus()
end


function UnMutePlayer()
	if not MutesFirst:IsShown() then
		return
	end
	if MutePlayerNameBox:GetText() == nil then
		SendChatMessage(".unmute", "GUILD", nil, nil);
	else
		SendChatMessage(".unmute "..MutePlayerNameBox:GetText(), "GUILD", nil, nil); 
	end
end
