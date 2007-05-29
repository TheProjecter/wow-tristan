local L = AceLibrary("AceLocale-2.2"):new("FuBar_RLAssistFu")

L:RegisterTranslations("enUS", function() return {
	["addonname"] = "|cffffffffRLAssist|r|cff00ff00Fu|r |cff7fff7f -Ace2-|r",
	["addonnameFu"] = "RLAssist",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = { "/rla" },
	
	["confirm_name"] = "Use confirmation",
	["confirm_desc"] = "Toggles whether you have to confirm each click (to avoid clicking by misstake)",
	["resetpos_name"] = "Reset positions",
	["resetpos_desc"] = "Resets all positions to default\nUsefull if you lost a button",
	["messages_name"] = "Edit messages",
	["messages_desc"] = "Here you can customize your messages",
	["countdownMessage_name"] = "Countdown message",
	["countdownMessage_desc"] = "The actual countdown, {n} will be replaced by time left in secs",
	["countdownGoMessage_name"] = "Go (\"charge\") message",
	["countdownGoMessage_desc"] = "The message that you shout when the action should start",
	["countdownAbortMessage_name"] = "Abort message",
	["countdownAbortMessage_desc"] = "The message that you shout when an abort is called",
	["pullingMessage_name"] = "Pull message",
	["pullingMessage_desc"] = "The message that announces a pull",
	["resettxt_name"] = "Reset texts",
	["resettxt_desc"] = "Resets all texts to the default",
	
	["LeaveParty"] = "Stuck in a group that won't show?",
	["LeaveParty_confirm"] = "Leave group?\n\nThis will help if you are bugged and people inviting you get the 'Allready in a group' Error even though you can't see a group!",
	["Countdown"] = "Start /rw or /ra Countdown ({n})",
	["Countdown_confirm"] = "You will start a countdown from {n} in /rw or /ra depending on your status in raid\n\n(Includes a \"charge\" message on 0)",
	["PullButton"] = "Show pull button",
	
	["Countdown_message"] = "Going in {n} sec",
	["Countdown_GO"] = "-------> GO GO GO <-------",
	["Countdown_Abort"] = "<> ABORT <> ABORT <> ABORT <>",
	["Countdown_AllreadyRunning"] = "Countdown running allready, can't start another untill finished or aborted!",
	
	["Pulling_message"] = "-------> PUOLLING <-------", -- Yes it's PUOLLING on purpose!
	
	["AbortButtonText"] = "Abort Countdown",
	["AbortButtonTooltip"] = "Click to cancel countdown\nAlt-Left-Click to reposition",
	["PullingButtonText"] = "Pull",
	["PullingButtonTooltip"] = "Left-Click to announce pull\nAlt-Left-Click to move\nRight-Click to hide",
	
	["Yes"] = true,
	["No"] = true,
	["Ok"] = true,
	
	["FuBarHint"] = "Various functions",
	
} end)

L:RegisterTranslations("koKR", function() return {
	["addonname"] = "|cffffffffRLAssist|r|cff00ff00Fu|r |cff7fff7f -Ace2-|r",
	["addonnameFu"] = "RLAssist",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = { "/rla" },
	
	["confirm_name"] = "확인창 사용",
	["confirm_desc"] = "확인창을 사용합니다(실수로 클릭하는 것을 막아줍니다)",
	["resetpos_name"] = "위치 초기화",
	["resetpos_desc"] = "모든 위치를 기본값으로 되돌립니다\n버튼이 화면밖으로 벗어난 경우에 사용하세요",
	["messages_name"] = "편집 메시지",
	["messages_desc"] = "당신의 메시지를 사용자의 요구에 맞추 수 있다",
	["countdownMessage_name"] = "카운트다운 메시지",
	["countdownMessage_desc"] = "실제 카운트다운을 설정합니다, {n} 초전",
	["countdownGoMessage_name"] = "시작 (\"공격\") 메시지",
	["countdownGoMessage_desc"] = "시작할때 당신이 외칠 메시지를 설정합니다",
	["countdownAbortMessage_name"] = "중지 메시지",
	["countdownAbortMessage_desc"] = "중지할때 당신이 외칠 메시지를 설정합니다",
	["pullingMessage_name"] = "풀링 메시지",
	["pullingMessage_desc"] = "풀링할때의 메시지를 설정합니다",
	["resettxt_name"] = "텍스트 초기화",
	["resettxt_desc"] = "모든 텍스트를 기본값으로 초기화합니다",
	
	["LeaveParty"] = "보이지 않는 파티에 묶여있습니까?",
	["LeaveParty_confirm"] = "파티를 떠나시겠습니까?\n\n파티에 속해 있지 않지만 \"이미 파티에 속해있습니다\"라는 메세지와 함께 파티 초대를 받을 수 없을 때에 사용합니다!",
	["Countdown"] = "공격대 경보(공격대 대화)로 {n}초 카운트다운 시작",
	["Countdown_confirm"] = "공격대에 속해 있다면 공격대 경보 또는 공격대 대화로 {n}초의 카운트다운을 시작합니다\n\n(0초에 \"공격\"메세지)",
	["PullButton"] = "풀링 버튼 표시",
	
	["Countdown_message"] = "{n} 초 전",
	["Countdown_GO"] = "-------> GO GO GO <-------",
	["Countdown_Abort"] = "<> 중지 <> 중지 <> 중지 <>",
	["Countdown_AllreadyRunning"] = "카운트다운이 이미 실행중입니다. 카운트다운이 종료되거나 중지하지 않으면 새로운 카운트다운을 실행할 수 없습니다!",
	
	["Pulling_message"] = "-------> 풀링 <-------", -- Yes it's PUOLLING on purpose!
	
	["AbortButtonText"] = "카운트다운 중지",
	["AbortButtonTooltip"] = "클릭시 카운트다운을 취소합니다\nAlt 클릭시 위치를 초기화 합니다\n카운트다운이 종료 되거나 취소될 때 버튼은 사라집니다",
	["PullingButtonText"] = "풀링",
	["PullingButtonTooltip"] = "클릭시 풀링 메세지를 방송합니다\nAlt 드래그로 이동할 수 있습니다\n우클릭시 버튼을 숨깁니다",
	
	["Yes"] = "예",
	["No"] = "아니오",
	["Ok"] = "확인",
	
	["FuBarHint"] = "다양한 기능",
	
} end)