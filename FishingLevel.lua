--------------------------------------
-- 다국어 전역 변수
--------------------------------------
L = FISHINGLEVEL_L;

--------------------------------------
-- 단축키 변수
--------------------------------------
BINDING_HEADER_FISHINGLEVEL = L["Fishing Level"];
BINDING_NAME_FISHINGLEVEL_TOGGLE = L["Show/Hide"];

local profession;

--------------------------------------
-- 애드온 로드 시
--------------------------------------
function FishingLevel_OnLoad(self)
    self:RegisterEvent("PLAYER_LOGIN");
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
    self:RegisterEvent("SKILL_LINES_CHANGED");
end

--------------------------------------
-- 이벤트 발생 시
--------------------------------------
function FishingLevel_OnEvent(self, event, ...)
    --print(event);
    if (event == "PLAYER_LOGIN") then
        FishingLevel_Initialize();
    elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
        local spellId = select(5, ...)
        if (spellId == 131476) then
            FishingLevelFrame:Show();
        end
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        local spellId = select(5, ...)
        if (spellId == 131476) then
            FishingLevelFrame:Hide();
        end
    elseif (event == "SKILL_LINES_CHANGED") then
        FishingLevel_OnLevelUpdated();
    end
end

------------------------------------
-- 애드온 초기화하기
------------------------------------
function FishingLevel_Initialize()
    local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
    if (fishing) then
        local professionName, professionTexture, professionLevel, professionMaxLevel = GetProfessionInfo(fishing);
        local spellName, spellRank, spellTexture, spellCastTime, spellMinRange, spellMaxRange, spellId = GetSpellInfo(professionName);

        -- 버튼 설정하기
        local button = FishingLevelSpellButton;
        if (not profession) then
            button:SetAttribute("type", "spell");
            button:SetAttribute("spell", spellName);
            button:SetAttribute("id", spellId);
            button:SetNormalTexture(spellTexture);

            profession = fishing;
        end

        FishingLevelTitleText:SetText(professionName);

        FishingLevel_OnLevelUpdated();
    end
end

--------------------------------------
-- 레벨 출력하기
--------------------------------------
function FishingLevel_OnLevelUpdated()
    if (profession) then
        local professionName, professionTexture, professionLevel, professionMaxLevel = GetProfessionInfo(profession);
        --professionLevel = 7556;
        --professionMaxLevel = 3980;
        FishingLevelCurrentText:SetText(professionLevel);
        FishingLevelMaxText:SetText("/"..professionMaxLevel);

        if (professionMaxLevel >= 1000) then
            FishingLevelFrame:SetWidth(140);
        end
    end
end

--------------------------------------
-- "보이기/숨기기" 단축키 눌렀을 때
--------------------------------------
function FishingLevel_ToggleKey_OnPress()
    local f = FishingLevelFrame;
    if (f:IsVisible()) then
        HideUIPanel(f);
    else
        ShowUIPanel(f);
    end
end

--------------------------------------
-- "닫기"" 버튼 클릭 시
--------------------------------------
function FishingLevelCloseButton_OnClick()
    local f = FishingLevelFrame;
    HideUIPanel(f);
end