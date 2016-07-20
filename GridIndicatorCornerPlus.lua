-- -------------------------------------------------------------------------- --
-- GridIndicatorCornerPlus by kunda                                           --
-- -------------------------------------------------------------------------- --

local addonName, prg = ...
if type(prg)   ~= "table" then print("ERROR", addonName) return end
if type(prg.L) ~= "table" then print("ERROR", addonName, "No localization table.") return end
for k, v in pairs(prg.L) do if type(v) ~= "string" then prg.L[k] = tostring(k) end end
local L = setmetatable(prg.L, {
	__index = function(t, k)
		t[k] = k
		--print(addonName, "prg.L:", k)
		return k
	end
})

local Grid = Grid
if not Grid.L then Grid.L = {} end
local LGrid = setmetatable(Grid.L, {
	__index = function(t, k)
		t[k] = k
		--print(addonName, "Grid.L:", k)
		return k
	end
})
local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorCornerPlus = GridFrame:NewModule("GridIndicatorCornerPlus")
local configMode = false

local BACKDROP = {
	bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true, tileSize = 8,
	edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1},
}

local function NewIndicator(frame)
	local square = CreateFrame("Frame", nil, frame)

--	local texture = square:CreateTexture(nil, "ARTWORK")
--	texture:SetPoint("CENTER", 0, 0)
--	square.texture = texture
	square:SetBackdrop(BACKDROP)
	square:SetBackdropBorderColor(0, 0, 0, 1)
	return square
end



local function ResetIndicator(self)
	local frame = self.__owner
	local indicator = self.__id
	local AddonProfile = GridIndicatorCornerPlus.db.profile
	local GridProfile = GridFrame.db.profile

	local wh = AddonProfile.CornerPlusSize
	if AddonProfile.CornerPlusOriginalSize then
		wh = GridProfile.cornerSize
	end

	local spacePositiv = wh-1 + AddonProfile.CornerPlusSpace
	local spaceNegativ = (wh-1 + AddonProfile.CornerPlusSpace) * -1

	self:SetWidth(wh)
	self:SetHeight(wh)
	self:SetParent(frame.indicators.bar)
	self:SetFrameLevel(frame.indicators.bar:GetFrameLevel() + 1)

	self:ClearAllPoints()
	if     indicator == "cornerPlusTLtopright"    then self:SetPoint("TOPLEFT", frame, "TOPLEFT", spacePositiv, -1)
	elseif indicator == "cornerPlusTLbottomleft"  then self:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, spaceNegativ)
	elseif indicator == "cornerPlusTLbottomright" then self:SetPoint("TOPLEFT", frame, "TOPLEFT", spacePositiv, spaceNegativ)
	elseif indicator == "cornerPlusTRtopleft"     then self:SetPoint("TOPRIGHT", frame, "TOPRIGHT", spaceNegativ, -1)
	elseif indicator == "cornerPlusTRbottomleft"  then self:SetPoint("TOPRIGHT", frame, "TOPRIGHT", spaceNegativ, spaceNegativ)
	elseif indicator == "cornerPlusTRbottomright" then self:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, spaceNegativ)
	elseif indicator == "cornerPlusBLtopleft"     then self:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, spacePositiv)
	elseif indicator == "cornerPlusBLtopright"    then self:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", spacePositiv, spacePositiv)
	elseif indicator == "cornerPlusBLbottomright" then self:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", spacePositiv, 1)
	elseif indicator == "cornerPlusBRtopleft"     then self:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", spaceNegativ, spacePositiv)
	elseif indicator == "cornerPlusBRtopright"    then self:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, spacePositiv)
	elseif indicator == "cornerPlusBRbottomleft"  then self:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", spaceNegativ, 1)
	end

--	self.texture:SetWidth(wh-2)
--	self.texture:SetHeight(wh-2)
end



local function SetIndicator(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
	if not color then return end
	self:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
	self:Show()
end



local function ClearIndicator(self)
	if configMode then return end
	self:Hide()
end



local function SetCornerSize(frame)
	ResetIndicator(frame.indicators.cornerPlusTLtopright)
	ResetIndicator(frame.indicators.cornerPlusTLbottomleft)
	ResetIndicator(frame.indicators.cornerPlusTLbottomright)
	ResetIndicator(frame.indicators.cornerPlusTRtopleft)
	ResetIndicator(frame.indicators.cornerPlusTRbottomleft)
	ResetIndicator(frame.indicators.cornerPlusTRbottomright)
	ResetIndicator(frame.indicators.cornerPlusBLtopleft)
	ResetIndicator(frame.indicators.cornerPlusBLtopright)
	ResetIndicator(frame.indicators.cornerPlusBLbottomright)
	ResetIndicator(frame.indicators.cornerPlusBRtopleft)
	ResetIndicator(frame.indicators.cornerPlusBRtopright)
	ResetIndicator(frame.indicators.cornerPlusBRbottomleft)
end



GridIndicatorCornerPlus.defaultDB = {
	CornerPlusSpace = 1,
	CornerPlusSize = 5,
	CornerPlusOriginalSize = true,
}



local options = {
	type = "group",
	--inline = true,
	icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TRTLBLBR",
	name = L["Corner Plus"],
	desc = format(LGrid["Options for %s indicator."], L["Corner Plus"]),
	order = -0.551,--480,
	args = {
		["configuration"] = {
			type = "toggle",
			name = L["Configuration Mode"],
			order = 5,
			get = function() return configMode end,
			set = function(_, v)
				configMode = v
				GridIndicatorCornerPlus:ConfigMode()
			end
		},
		["header1"] = {
			type = "header",
			order = 10,
			width = "full",
			name = "",
		},
		["cornerplusspace"] = {
			type = "range",
			name = LGrid["Spacing"],
			order = 20,
			min = 1,
			max = 10,
			step = 1,
			get = function() return GridIndicatorCornerPlus.db.profile.CornerPlusSpace end,
			set = function(_, v)
				GridIndicatorCornerPlus.db.profile.CornerPlusSpace = v
				for _, f in pairs(GridFrame.registeredFrames) do
					SetCornerSize(f)
				end
			end,
		},
		["dummy1"] = {
			type = "description",
			order = 21,
			width = "full",
			name = "",
		},
		["cornerplusoriginalsize"] = {
			type = "toggle",
			name = L["Same settings as Grid"],
			order = 30,
			width = "full",
			get = function() return GridIndicatorCornerPlus.db.profile.CornerPlusOriginalSize end,
			set = function(_, v)
				GridIndicatorCornerPlus.db.profile.CornerPlusOriginalSize = v
				for _, f in pairs(GridFrame.registeredFrames) do
					SetCornerSize(f)
				end
			end,
		},
		["dummy2"] = {
			type = "description",
			order = 31,
			width = "full",
			name = "",
		},
		["cornerplussize"] = {
			type = "range",
			name = L["Size"],
			order = 40,
			disabled = function() return GridIndicatorCornerPlus.db.profile.CornerPlusOriginalSize end,
			min = 1,
			max = 20,
			step = 1,
			get = function() return GridIndicatorCornerPlus.db.profile.CornerPlusSize end,
			set = function(_, v)
				GridIndicatorCornerPlus.db.profile.CornerPlusSize = v
				for _, f in pairs(GridFrame.registeredFrames) do
					SetCornerSize(f)
				end
			end,
		}
	}
}
Grid.options.args["GridIndicatorCornerPlus"] = options



local statusmap = GridFrame.db.profile.statusmap
if not statusmap["cornerPlusTLtopright"] then
	statusmap["cornerPlusTLtopright"] = {}
	statusmap["cornerPlusTLbottomleft"] = {}
	statusmap["cornerPlusTLbottomright"] = {}
	statusmap["cornerPlusTRtopleft"] = {}
	statusmap["cornerPlusTRbottomleft"] = {}
	statusmap["cornerPlusTRbottomright"] = {}
	statusmap["cornerPlusBLtopleft"] = {}
	statusmap["cornerPlusBLtopright"] = {}
	statusmap["cornerPlusBLbottomright"] = {}
	statusmap["cornerPlusBRtopleft"] = {}
	statusmap["cornerPlusBRtopright"] = {}
	statusmap["cornerPlusBRbottomleft"] = {}
end



function GridIndicatorCornerPlus:OnInitialize()
	if not self.db then
		self.db = Grid.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end
	GridFrame:RegisterIndicator("cornerPlusTLtopright",    LGrid["Top Right"],    NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusTLbottomleft",  LGrid["Bottom Left"],  NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusTLbottomright", LGrid["Bottom Right"], NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusTRtopleft",     LGrid["Top Left"],     NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusTRbottomleft",  LGrid["Bottom Left"],  NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusTRbottomright", LGrid["Bottom Right"], NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBLtopleft",     LGrid["Top Left"],     NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBLtopright",    LGrid["Top Right"],    NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBLbottomright", LGrid["Bottom Right"], NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBRtopleft",     LGrid["Top Left"],     NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBRtopright",    LGrid["Top Right"],    NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)
	GridFrame:RegisterIndicator("cornerPlusBRbottomleft",  LGrid["Bottom Left"],  NewIndicator, ResetIndicator, SetIndicator, ClearIndicator)

	hooksecurefunc(GridFrame, "UpdateOptionsMenu", self.ChangeOptionsMenu)
	GridIndicatorCornerPlus:ChangeOptionsMenu()
	GridIndicatorCornerPlus:CreateConfigFrame()
end



function GridIndicatorCornerPlus:OnEnable()
end



function GridIndicatorCornerPlus:OnDisable()
end



function GridIndicatorCornerPlus:Reset()
end



function GridIndicatorCornerPlus:ChangeOptionsMenu()
	if not GridIndicatorCornerPlus:IsEnabled() then return end
	if not Grid.options then return end
	if not Grid.options.args then return end
	local GridIndicator
	if     type(Grid.options.args.GridIndicator) == "table" then GridIndicator = "GridIndicator"
	elseif type(Grid.options.args.Indicators)    == "table" then GridIndicator = "Indicators" end
	if not Grid.options.args[GridIndicator] then return end
	if not Grid.options.args[GridIndicator].args then return end

	if not Grid.options.args[GridIndicator].args.cornerPlusTLtopright then return end

	Grid.options.args[GridIndicator].args.cornerPlusTL = {
		type = "group",
		icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TL",
		name = L["Corner Plus"].." ("..LGrid["Top Left"]..")",
		order = 9.1,
		args = {
			["cornerPlusTLtopright"]    = Grid.options.args[GridIndicator].args.cornerPlusTLtopright,
			["cornerPlusTLbottomleft"]  = Grid.options.args[GridIndicator].args.cornerPlusTLbottomleft,
			["cornerPlusTLbottomright"] = Grid.options.args[GridIndicator].args.cornerPlusTLbottomright
		}
	}
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLtopright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TL-TR"
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLbottomleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TL-BL"
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLbottomright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TL-BR"
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLtopright.order = 1
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLbottomleft.order = 2
	Grid.options.args[GridIndicator].args.cornerPlusTL.args.cornerPlusTLbottomright.order = 3
	Grid.options.args[GridIndicator].args.cornerPlusTLtopright = nil
	Grid.options.args[GridIndicator].args.cornerPlusTLbottomleft = nil
	Grid.options.args[GridIndicator].args.cornerPlusTLbottomright = nil

	Grid.options.args[GridIndicator].args.cornerPlusTR = {
		type = "group",
		icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TR",
		name = L["Corner Plus"].." ("..LGrid["Top Right"]..")",
		order = 10.1,
		args = {
			["cornerPlusTRtopleft"]     = Grid.options.args[GridIndicator].args.cornerPlusTRtopleft,
			["cornerPlusTRbottomleft"]  = Grid.options.args[GridIndicator].args.cornerPlusTRbottomleft,
			["cornerPlusTRbottomright"] = Grid.options.args[GridIndicator].args.cornerPlusTRbottomright
		}
	}
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRtopleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TR-TL"
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRbottomleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TR-BL"
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRbottomright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-TR-BR"
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRtopleft.order = 1
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRbottomleft.order = 2
	Grid.options.args[GridIndicator].args.cornerPlusTR.args.cornerPlusTRbottomright.order = 3
	Grid.options.args[GridIndicator].args.cornerPlusTRtopleft = nil
	Grid.options.args[GridIndicator].args.cornerPlusTRbottomleft = nil
	Grid.options.args[GridIndicator].args.cornerPlusTRbottomright = nil

	Grid.options.args[GridIndicator].args.cornerPlusBL = {
		type = "group",
		icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BL",
		name = L["Corner Plus"].." ("..LGrid["Bottom Left"]..")",
		order = 11.1,
		args = {
			["cornerPlusBLtopleft"]     = Grid.options.args[GridIndicator].args.cornerPlusBLtopleft,
			["cornerPlusBLtopright"]    = Grid.options.args[GridIndicator].args.cornerPlusBLtopright,
			["cornerPlusBLbottomright"] = Grid.options.args[GridIndicator].args.cornerPlusBLbottomright
		}
	}
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLtopleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BL-TL"
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLtopright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BL-TR"
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLbottomright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BL-BR"
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLtopleft.order = 1
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLtopright.order = 2
	Grid.options.args[GridIndicator].args.cornerPlusBL.args.cornerPlusBLbottomright.order = 3
	Grid.options.args[GridIndicator].args.cornerPlusBLtopleft = nil
	Grid.options.args[GridIndicator].args.cornerPlusBLtopright = nil
	Grid.options.args[GridIndicator].args.cornerPlusBLbottomright = nil

	Grid.options.args[GridIndicator].args.cornerPlusBR = {
		type = "group",
		icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BR",
		name = L["Corner Plus"].." ("..LGrid["Bottom Right"]..")",
		order = 12.1,
		args = {
			["cornerPlusBRtopleft"]    = Grid.options.args[GridIndicator].args.cornerPlusBRtopleft,
			["cornerPlusBRtopright"]   = Grid.options.args[GridIndicator].args.cornerPlusBRtopright,
			["cornerPlusBRbottomleft"] = Grid.options.args[GridIndicator].args.cornerPlusBRbottomleft
		}
	}
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRtopleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BR-TL"
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRtopright.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BR-TR"
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRbottomleft.icon = "Interface\\AddOns\\GridIndicatorCornerPlus\\GridIndicatorCornerPlus-icon-BR-BL"
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRtopleft.order = 1
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRtopright.order = 2
	Grid.options.args[GridIndicator].args.cornerPlusBR.args.cornerPlusBRbottomleft.order = 3
	Grid.options.args[GridIndicator].args.cornerPlusBRtopleft = nil
	Grid.options.args[GridIndicator].args.cornerPlusBRtopright = nil
	Grid.options.args[GridIndicator].args.cornerPlusBRbottomleft = nil
end



function GridIndicatorCornerPlus:CreateConfigFrame()
	GridIndicatorCornerPlus.ConfigWarningFrame = CreateFrame("Frame", nil, UIParent)
	local frame = GridIndicatorCornerPlus.ConfigWarningFrame
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetToplevel(true)
	frame:SetClampedToScreen(true)
	frame:SetHeight(100)
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = {left = 8, right = 8, top = 8, bottom = 8}
	})
	frame:SetPoint("LEFT", GridLayoutFrame, "RIGHT", 40, 0)
	frame:SetScript("OnMouseDown", function(self)
		self.isMoving = true
		self:StartMoving()
	end)
	frame:SetScript("OnMouseUp", function(self)
		if not self.isMoving then return end
		self.isMoving = nil
		self:StopMovingOrSizing()
	end)
	frame:Hide()

	local background = frame:CreateTexture(nil, "ARTWORK")
	background:SetPoint("TOP", 0, -15)
	background:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
	background:SetHeight(24)
	background:SetWidth(24)

	local txt = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	txt:SetPoint("TOP", background, "BOTTOM", 0, -5)
	txt:SetText("Grid - "..L["Corner Plus"].." - "..L["Configuration Mode"])
	txt:SetTextColor(1, 1, 1, 1)

	local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button:SetHeight(24)
	button:SetPoint("TOP", txt, "BOTTOM", 0, -5)
	button:SetText(CLOSE)
	button:SetScript("OnClick", function()
		configMode = false
		GridIndicatorCornerPlus:ConfigMode()
	end)

	local w = txt:GetStringWidth()
	button:SetWidth(w+50)
	frame:SetWidth(w+50+60)
end



function GridIndicatorCornerPlus:ConfigMode()
	if configMode then
		GridIndicatorCornerPlus.ConfigWarningFrame:Show()
		for _, frame in pairs(GridFrame.registeredFrames) do
			SetIndicator(frame.indicators.cornerPlusTLtopright,    {r=0.22, g=0.85, b=0.81, a=1})
			SetIndicator(frame.indicators.cornerPlusTLbottomleft,  {r=0.87, g=0.62, b=0.06, a=1})
			SetIndicator(frame.indicators.cornerPlusTLbottomright, {r=0.29, g=0.34, b=0.67, a=1})
			SetIndicator(frame.indicators.cornerPlusTRtopleft,     {r=0.12, g=0.46, b=0.97, a=1})
			SetIndicator(frame.indicators.cornerPlusTRbottomleft,  {r=0.42, g=0.07, b=0.24, a=1})
			SetIndicator(frame.indicators.cornerPlusTRbottomright, {r=0.17, g=0.65, b=0.33, a=1})
			SetIndicator(frame.indicators.cornerPlusBLtopleft,     {r=0.21, g=0.74, b=0.81, a=1})
			SetIndicator(frame.indicators.cornerPlusBLtopright,    {r=0.87, g=0.71, b=0.06, a=1})
			SetIndicator(frame.indicators.cornerPlusBLbottomright, {r=0.29, g=0.21, b=0.36, a=1})
			SetIndicator(frame.indicators.cornerPlusBRtopleft,     {r=0.31, g=0.46, b=0.97, a=1})
			SetIndicator(frame.indicators.cornerPlusBRtopright,    {r=0.42, g=0.77, b=0.85, a=1})
			SetIndicator(frame.indicators.cornerPlusBRbottomleft,  {r=0.65, g=0.65, b=0.89, a=1})
		end
	else
		GridIndicatorCornerPlus.ConfigWarningFrame:Hide()
		for _, frame in pairs(GridFrame.registeredFrames) do
			ClearIndicator(frame.indicators.cornerPlusTLtopright)
			ClearIndicator(frame.indicators.cornerPlusTLbottomleft)
			ClearIndicator(frame.indicators.cornerPlusTLbottomright)
			ClearIndicator(frame.indicators.cornerPlusTRtopleft)
			ClearIndicator(frame.indicators.cornerPlusTRbottomleft)
			ClearIndicator(frame.indicators.cornerPlusTRbottomright)
			ClearIndicator(frame.indicators.cornerPlusBLtopleft)
			ClearIndicator(frame.indicators.cornerPlusBLtopright)
			ClearIndicator(frame.indicators.cornerPlusBLbottomright)
			ClearIndicator(frame.indicators.cornerPlusBRtopleft)
			ClearIndicator(frame.indicators.cornerPlusBRtopright)
			ClearIndicator(frame.indicators.cornerPlusBRbottomleft)
		end
	end
end
