--[[ Want to translate?

	Make a copy of this file in the same folder and rename the end into the locale you want to translate for, also remove this header

	The following are allready referenced in the .toc file:
	Localization-deDE.lua, Localization-frFR.lua, Localization-koKR.lua, Localization-zhCN.lua, Localization-zhTW.lua, Localization-esES.lua
	if I missed yours you need to add it manually for testing

	Translate the row below that looks like this: local locale = "enUS";
	Change enUS to whatever locale you are using

	Translate the right hand side of everything, German example:
		["lock_cmd"] = "Sperren",
		...
		["eep_info"] = "Enhancer's Vergleichspunkte:",

	Anything ending with _cmd is used as a console commmand and I usually try to keep those as one word.

	Once you are done mail it to me at dennis.hafstrom@gmail.com and I'll add it to the distributed file :)
]]--

local U = Enhancer_URLs; -- Read up URLs, " .. U["EJ"] .. "
local locale = "koKR";

local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations(locale, function() return {
--	["translator"] = "Leion - Frostmane.eu",

	["waterfall_cmd"] = "GUI 설정",
	["waterfall_desc"] = "GUI 설정 창을 엽니다.",

	["lock_cmd"] = "잠금",
	["lock_desc"] = "현재 위치의 창을 고정시키거나 이동시킵니다.",

	["reset_cmd"] = "초기화",
	["reset_desc"] = "모든 위치를 기본값으로 초기화 합니다.",

	["resize_cmd"] = "크기",
	["resize_desc"] = "창의 크기를 설정합니다.",

	["element_group_cmd"] = "속성 창",
	["element_group_desc"] = "속성 창을 켜거나 끔니다.",
	["earth_cmd"] = "대지",
	["fire_cmd"] = "불",
	["water_cmd"] = "물",
	["air_cmd"] = "바람",
	["element_desc"] = "%s의 토템을 위한 창을 사용합니다.",

	["bonus_group_cmd"] = "보너스 창",
	["bonus_group_desc"] = "보너스 창을 켜거나 끔니다.",
	["windfury_cmd"] = "질풍",
	["windfury_desc"] = "\"숨겨진\" 질풍 대기시간을 표시하기 위한 창을 사용합니다.",
	["reincarnation_cmd"] = "윤회",
	["reincarnation_desc"] = "윤회 대기시간을 표시하기 위한 창을 사용합니다.",

	["ep_cmd"] = "등가 평가치(EP)",
	["ep_desc"] = "툴팁에 등가 평가 수치를 표시합니다.",
	["ep_group_cmd"] = "등가 평가치 형태(EPTypes)",
	["ep_group_desc"] = "등가 평가 수치 표시에 대한 설정을 합니다.",
	["ep_gemq_cmd"] = "보석 품질(GemQuality)",
	["ep_gemq_desc"] = "보석의 최고 품질을 설정합니다. (1 = 일반, 2 = 고급, 3 = 희귀, 4 = 영웅)",
	["ep_gemqn_cmd"] = "GemQualityNonEpic",
	["ep_gemqn_desc"] = "Set Max Quality for Gems (0 = same as Epic, 1 = None, 2 = Uncommon, 3 = Rare, 4 = Epic) to use in non-epic gear",
	["ep_gemm_cmd"] = "얼개 보석(MetaGem)",
	["ep_gemm_desc"] = "얼개 보석을 계산에 포함 시킵니다.",
	["ep_info_cmd"] = "정보(Info)",
	["ep_info_desc"] = "등가 평가 수치에 대한 더 많은 정보를 표시합니다.",
	["ep_info_exec"] = "Some sources for finding \"your\" AEP:\r1) " .. U["CrazyShamanCalc"] .. "\r2) " .. U["EJ"] .. "\r3) " .. U["WoWEquipO"] .. "\r4) " .. U["Pater"] .. "\rDefault AEP are from Tornhoof/Pater",
	["epz_cmd"] = "등가 평가치 없음(EPZero)",
	["epz_desc"] = "등가 평가치가 없더라도 표시합니다.",
	["aep_cmd"] = "전투력 등가 평가치(AEP)",
	["aep_desc"] = "전투력의 등가 평가 수치를 툴팁에 표시합니다.",
	["aeph_cmd"] = "적중 제외 전투력 등가 평가치(AEPwoH)",
	["aeph_desc"] = "적중 제외 전투력의 등가 평가 수치를 툴팁에 표시합니다.",
	["hep_cmd"] = "치유 등가 평가치(HEP)",
	["hep_desc"] = "치유의 등가 평가 수치를 툴팁에 표시합니다.",
	["dep_cmd"] = "주문 공격력 등가 평가치(DEP)",
	["dep_desc"] = "주문 공격력의 등가 평가 수치를 툴팁에 표시합니다.",
	["deph_cmd"] = "적중 제외 주문 공격력 등가 평가치(DEPwoH)",
	["deph_desc"] = "적중 제외 주문 공격력의 등가 평가 수치를 툴팁에 표시합니다.",
	["eip_cmd"] = "고양 아이템 평점(EIP)",
	["eip_desc"] = "고양 아이템 평점을 툴팁에 표시합니다.",
	["ep_numbers_cmd"] = "등가 평가치 세부 설정(EPNumbers)",
	["ep_numbers_desc"] = "등가 평가치의 세부 옵션의 수치를 변경합니다. (0일시 사용 안함)",
	["ep_guess_cmd"] = "등가 평가치 추정(EPEstimates)",
	["ep_guess_desc"] = "등가 평가치에 무기의 발동이나 사용효과등의 비고정적 가치를 추정합니다.",
	["ep_gguess_cmd"] = "EPGemEstimates",
	["ep_gguess_desc"] = "Include guesstimates of non static bonuses on gems for EP",
	["bestgem_cmd"] = "가장 좋은 보석(BestGem)",
	["bestgem_desc"] = "당신의 세팅에 기초를 둔 가장 좋은 보석을 계산합니다.",
	["blue"] = "파랑",
	["yellow"] = "노랑",
	["red"] = "빨강",
	["any"] = "기타",

	["AGI"] = "민첩성",
	["ATTACKPOWER"] = "전투력",
	["CR_CRIT"] = "근접 치명타",
	["CR_HASTE"] = "공격 가속도",
	["CR_HIT"] = "근접 적중도",
	["CR_EXPERTISE"] = "무기 전문가",
	["CR_SPELLCRIT"] = "주문 극대화",
	["CR_SPELLHASTE"] = "주문 시전 가속도",
	["CR_SPELLHIT"] = "주문 적중도",
	["CR_RESILIENCE"] = "탄력도",
	["DMG"] = "주문 공격력",
	["HEAL"] = "주문 치유량",
	["IGNOREARMOR"] = "방어도 무시",
	["INT"] = "지능",
	["MANAREG"] = "5초당 마나 회복량",
	["SPI"] = "정신력",
	["STR"] = "힘",
	["STA"] = "체력",
	["WEAPON_MIN"] = "무기 민뎀",
	["WEAPON_MAX"] = "무기 맥뎀",

	["sound_cmd"] = "소리",
	["sound_desc"] = "토템의 지속시간이 만료될 시 효과음을 재생합니다.",

	["growpulse_cmd"] = "주기 알림 (창크기)",
	["growpulse_desc"] = "\"토템의 효과 발생 주기시\" 창이 커졌다 작아집니다.",

	["borderpulse_cmd"] = "주기 알림 (테두리)",
	["borderpulse_desc"] = "\"토템의 효과 발생 주기시\" 화면의 가장자리가 점멸됩니다.",

	["alpha_cmd"] = "투명도",
	["alpha_desc"] = "창의 투명도를 설정합니다.",

	["alpha_ooc_active_cmd"] = "비전투 상태일 때 사용",
	["alpha_ooc_active_desc"] = "비전투 상태일 때 창의 투명도를 사용합니다.",

	["alpha_ooc_inactive_cmd"] = "비전투 상태일 때 사용 안함",
	["alpha_ooc_inactive_desc"] = "비전투 상태일 때 창의 투명도를 사용하지 않습니다.",

	["alpha_ic_active_cmd"] = "전투 상태일 때 사용",
	["alpha_ic_active_desc"] = "전투 상태일 때 창의 투명도를 사용합니다.",

	["alpha_ic_inactive_cmd"] = "전투 상태일 때 사용 안함",
	["alpha_ic_inactive_desc"] = "전투 상태일 때 창의 투명도를 사용하지 않습니다.",

	["specialalpha_cmd"] = "기타 투명도",  -- Special Alpha
	["specialalpha_desc"] = "\"보너스\" 창의 특별한 투명도 설정을 사용합니다.",

	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "이동", --"Click and drag to move frame",

	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s)|1이;가; 곧 사라집니다.",
	["TotemSlain"] = "%s (%s)|1이;가; 파괴되었습니다!!!",
	["TotemDeath"] = "%s (%s)|1이;가; 사라집니다.",

	--[[ Announcements ]]--
	["Announcement"] = "만약 당신이 Enhancer를 사용하던중 오류가 발견되거나 틀린 부분이 있다고 생각을 한다면 자유롭게 dennis.hafstrom@gmail.com로 나에게 이메일을 보내십시오",
	["Announcement_cmd"] = "알림",
	["Announcement_desc"] = "알림을 설정합니다. (설정시 스팸 메시지가 발생할 수 있습니다.)",
	["a_show_cmd"] = "표시",
	["a_show_desc"] = "알림을 표시합니다.",
	["a_disable_cmd"] = "사용 안함",
	["a_disable_desc"] = "알림을 사용하지 않습니다.",

	[0] = "0 레벨",
	[1] = "1 레벨",
	[2] = "2 레벨",
	[3] = "3 레벨",
	[4] = "4 레벨",
	[5] = "5 레벨",
	[6] = "6 레벨",
	[7] = "7 레벨",
	[8] = "8 레벨",
	[9] = "9 레벨",
	[10] = "10 레벨",
	[11] = "11 레벨",
	[12] = "12 레벨",
	[13] = "13 레벨",
	[14] = "14 레벨",
	[15] = "15 레벨",
	[16] = "16 레벨",
	[17] = "17 레벨",
	[18] = "18 레벨",
	[19] = "19 레벨",
	[20] = "20 레벨",

	["stormstrike_cmd"] = "폭풍의 일격",
	["stormstrike_desc"] = "폭풍의 일격을 위한 창을 표시합니다.",

	["shield_cmd"] = "보호막",
	["shield_desc"] = "보호막을 표시하기 위한 창을 사용합니다.",

	["eshield_cmd"] = "대지의 보호막",
	["eshield_desc"] = "대지의 보호막을 위한 창을 표시합니다.",
	["Lost track of Earth Shield"] = "대지의 보호막 사라짐 추적",
	["Earth Shield has expired"] = "대지의 보호막이 사라집니다.",
	["Earth Shield is about to expire"] = "대지의 보호막이 곧 사라집니다.",

	["tench_cmd"] = "무기 버프",
	["tench_desc"] = "임시적으로 무기 버프를 표시하기 위한 창을 사용합니다.",

	["invigorated_cmd"] = "고무",
	["invigorated_desc"] = "고무 효과 발동시 표시하기 위한 창을 사용합니다. (테스트 안됨)",
	["Invigorated"] = "고무",

	["hway_cmd"] = "치유의 길",
	["hway_desc"] = "치유의 길을 위한 CandyBars를 사용합니다.",
	["hway_yougain"] = "효과를 얻었습니다.", -- as it appears in combat log when you gain a buff!
	["hway_anchortext"] = "Alt-클릭을 통해 앵커를 이동할 수 있습니다.",

	["aep_import_crazyshaman_cmd"] = "CrazyShamanImport",
	["aep_import_crazyshaman_desc"] = "CrazyShaman의 DPS & AEP의 계산 수치를 받아옵니다. ( " .. U["CrazyShamanCalc"] .. " )",
	["aep_import_warning"] = "전투력 등가 평가치 값이 포함되지 않았습니다, 다음 전투력 등가 평가치 값을 체크하십시오 : (%s)",

	["yard_group_cmd"] = "거리 설정",
	["yard_group_desc"] = "토템이 사거리에서 멀리 떨어질 때 토템이 사라지는 것에 대한 설정을 합니다.",
	["yard_range_cmd"] = "거리",
	["yard_range_desc"] = " 토템이 사라질 추정 거리를 설정합니다. (기본값: 150)",  -- What range to assume the totem is gone (Default: 150, Quick in-game testing showed closer to 100)
	["yard_active_cmd"] = "사용",
	["yard_active_desc"] = "거리 설정의 사용 여부를 정합니다.",  -- Toggle destroy frame on range active or not

	["base_warn"] = " (기본 값)",

	["windfurytotem_cmd"] = "질풍의 토템",
	["windfurytotem_desc"] = "질풍/은총의 토템 스왑을 위한 타이머를 사용합니다.",

	["snap_cmd"] = "창 붙임",
	["snap_desc"] = "창 끼리 서로 근접했을 때 자동으로 보기 좋게 정렬하여 붙여줍니다.",

	["font_cmd"] = "글꼴",
	["font_desc"] = "글꼴 설정",
	["fontabove_cmd"] = "상단",
	["fontabove_desc"] = "창의 상단 문자를 위한 글꼴을 설정합니다.",
	["fontcenter_cmd"] = "중앙",
	["fontcenter_desc"] = "창의 중앙 문자를 위한 글꼴을 설정합니다.",
	["fontbelow_cmd"] = "하단",
	["fontbelow_desc"] = "창의 하단 문자를 위한 글꼴을 설정합니다.",
	["fontname_cmd"] = "글꼴",
	["fontname_desc"] = "글꼴체",
	["fontsize_cmd"] = "크기",
	["fontsize_desc"] = "글꼴 크기",
	["fontflag_cmd"] = "외각선",
	["fontflag_desc"] = "글꼴의 외각선을 설정합니다. (OUTLINE\|THICKOUTLINE\|NONE)",
	["Messages_cmd"] = "메시지",
	["Messages_desc"] = "메시지를 설정합니다.",

	["roman_cmd"] = "로마 숫자",
	["roman_desc"] = "무기 버프 및 보호막, 기타등에 로마 숫자로 표기합니다.",

	["time_cmd"] = "타이머",
	["time_desc"] = "타이머에 대한 설정을 합니다.",
	["pulse_cmd"] = "주기 알림",
	["pulse_desc"] = "토템의 효과 발생 주기에 대한 설정을 합니다.",
	["warning_cmd"] = "경고",
	["warning_desc"] = "경고에 대한 설정을 합니다.",

	["blizztime_cmd"] = "블리자드",
	["blizztime_desc"] = "Enhancer에 블리자드의 시간 형식을 사용합니다.",
	["blizzssec_cmd"] = "초 단위 사용",
	["blizzssec_desc"] = "단위에 '초'를 사용합니다.",
	["warnExpire_cmd"] = "만료 경고",
	["warnExpire_desc"] = "토템이 사라지기 전 경고합니다.",
	["warnDeath_cmd"] = "사라짐 경고",
	["warnDeath_desc"] = "토템이 사라지면 경고합니다.",
	["warnSlain_cmd"] = "파괴 경고",
	["warnSlain_desc"] = "토템이 파괴되면 경고합니다.",
	["warnTime_cmd"] = "시간",
	["warnTime_desc"] = "사라지기 이전 경고할 초를 설정합니다. (변경하여도 기존의 토템에 영향을 미치지 않습니다.)",
	["buffIndicator_cmd"] = "버프 지시기",
	["buffIndicator_desc"] = "당신이 시전한 토템의 영향권을 표시하기 위한 표시를 합니다.",
	["topleft"] = "좌측 상단",
	["topright"] = "우측 상단",
	["bottomleft"] = "좌측 하단",
	["bottomright"] = "우측 하단",
	["noindication"] = "없음",

	["news_cmd"] = "뉴스",
	["news_desc"] = "최신 뉴스를 표시합니다.",
	["news_1"] = "Enhancer 뉴스 & 변경!",
	["news_2"] = "News popup will only be shown ONCE when there are new news!",
	["news_3"] = "Disabling news for a distant future, thank you for reading!",
	["news_4"] = "연락",
	["news_5"] = "버그",
	["news_6"] = "문제",
	["news_7"] = "E-mail : dennis.hafstrom@gmail.com",

	["Wizard Oil"] = "마법사 오일",
	["Mana Oil"] = "마나 오일",

	["Import_complete"] = "불러들이기가 성공적으로 완료되었습니다.",  -- Import completed successfully
	["low_cmd"] = "낮은 세팅",
	["low_desc"] = "카라잔/영웅 던전급 장비를 위한 설정을 불러옵니다.",  -- Import settings tuned for Kara/Heroic gear
	["medium_cmd"] = "중간 세팅",
	["medium_desc"] = "4~5티어급 장비를 위한 설정을 불러옵니다.",  -- Import settings tuned for gear between Kara/Heroic gear and end game
	["high_cmd"] = "높은 세팅",
	["high_desc"] = "5~6티어급 장비를 위한 설정을 불러옵니다.",  -- Import settings tuned for end game gear
}; end );

local L_EP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
L_EP:RegisterTranslations(locale, function() return {

	--[[ ItemTypes ]]--
	["Armor"] = "방어구",
	["Gem"] = "보석",
	["Weapon"] = "무기",
	["Projectile"] = "투사체",
	["Quiver"] = "화살통",
	["Recipe"] = "조제법",

	--[[ This is used for matching so need all of it and exactly as it is on the tooltip ]]--
	["Chance on hit:"] = "발동 효과:",  -- Chance on hit

	--[[ Tooltip strings ]]--
	["eep_info"] = "Enhancer's 등가 평가치%s:",  -- Enhancer's Equivalence Points%s

	["aep_tooltip"] = string.rep(" ", 3) .. "전투력 증가 등가 평가치 (왕축시 상승량)%s:",
	["aep_info"] = "AEP model from Tornhoof/Pater", -- Not used atm
	["aeph_tooltip"] = string.rep(" ", 3) .. "적중 제외 전투력 등가 평가치 (왕축시 상승량):",

	["hep_tooltip"] = string.rep(" ", 3) .. "치유 등가 평가치 (왕축시 상승량)%s:",
	["hep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be taken as gospel)", -- Not used atm

	["dep_tooltip"] = string.rep(" ", 3) .. "주문 피해 등가 평가치 (왕축시 상승량)%s:",
	["dep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be taken as gospel)", -- Not used atm
	["deph_tooltip"] = string.rep(" ", 3) .. "적중 제외 주문 피해 등가 평가치 (왕축시 상승량):",

	["ep_procsanduse"] = string.rep(" ", 3) .. "*) Procs/Use basis is average/expected bonus!",
	["ep_procsandusemissing"] = string.rep(" ", 3) .. "^) Not all Procs/Use/Chance are calculated!",

	["eip_tooltip"] = "고양 아이템 평점%s:",
	["eip_info"] = "Leion에 의하여 계산된 값", -- Not used atm

	["ep_numbers1"] = "%d (%d)",  -- Lua string.format
	["ep_numbers2"] = "%.1f (%.1f)",  -- Lua string.format

	["bestgem_link"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["bestgem_nolink"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["Red"] = "빨강",
	["Yellow"] = "노랑",
	["Blue"] = "파랑",
	["Any"] = "기타",

}; end );