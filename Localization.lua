FISHINGLEVEL_L = GetLocale() == "koKR" and {
	["Fishing Level"] = "낚시 레벨",
	["Level"] = "Level",
	["Show/Hide"] = "보이기/숨기기"
--[[
} or GetLocale() == "zhCN" and {
	["Close"] = "닫기"
]]--
} or { }

setmetatable(FISHINGLEVEL_L, {__index = function(self, key) rawset(self, key, key); return key; end})