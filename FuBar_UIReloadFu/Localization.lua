local L = AceLibrary("AceLocale-2.2"):new("FuBar_UIReloadFu")

L:RegisterTranslations("enUS", function() return {
	["addonname"] = "|cffffffffUIReload|r|cff00ff00Fu|r |cff7fff7f -Ace2-|r",
	["addonnameFu"] = "UIReload",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = { "/uir" },
	
	["confirm_name"] = "Use confirmation",
	["confirm_desc"] = "Toggles whether you have to confirm each click (to avoid clicking by misstake)",
	["resetpos_name"] = "Reset positions",
	["resetpos_desc"] = "Resets all positions to default\nUsefull if you lost a button",
	
	["ReloadUI"] = "Reload User Interface",
	["ReloadUI_confirm"] = "Do you really want to Reload the User Interface?\n\nSome changes may get lost!",
	["LeaveParty"] = "Stuck in a group that won't show?",
	["LeaveParty_confirm"] = "Leave group?\n\nThis will help if you are bugged and people inviting you get the 'Allready in a group' Error even though you can't see a group!",
	["Yes"] = true,
	["No"] = true,
	["Ok"] = true,
	
	["FuBarHint"] = "Click to ReloadUI\n\n(Some other handy options in the dropdown)",
	
} end)


L:RegisterTranslations("koKR", function() return {
	["addonname"] = "|cffffffffUIReload|r|cff00ff00Fu|r |cff7fff7f -Ace2-|r",
	["addonnameFu"] = "UIReload",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "우리말 작업: Damjau - www.widz.info",
	["consolecommands"] = { "/uir" },
	
	["confirm_name"] = "확인창 사용",
	["confirm_desc"] = "확인창을 사용합니다(실수로 클릭하는 것을 막아줍니다)",
	["resetpos_name"] = "위치 초기화",
	["resetpos_desc"] = "모든 위치를 기본값으로 되돌립니다\n버튼이 화면밖으로 벗어난 경우에 사용하세요",
	
	["ReloadUI"] = "UI 리로딩",
	["ReloadUI_confirm"] = "정말로 UI를 리로딩 하시겠습니까?\n\n몇몇 변경사항이 저장되지 않을 수 있습니다!",
	["LeaveParty"] = "보이지 않는 파티에 묶여있습니까?",
	["LeaveParty_confirm"] = "파티를 떠나시겠습니까?\n\n파티에 속해 있지 않지만 \"이미 파티에 속해있습니다\"라는 메세지와 함께 파티 초대를 받을 수 없을 때에 사용합니다!",
	["Yes"] = "예",
	["No"] = "아니오",
	["Ok"] = "확인",
	
	["FuBarHint"] = "클릭시 UI를 리로딩합니다\n\n(우클릭시 설정창을 표시합니다)",
	
} end)