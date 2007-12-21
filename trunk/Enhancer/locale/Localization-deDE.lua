local U = Enhancer_URLs; -- Read up URLs, " .. U["EJ"] .. "
local locale = "deDE";

local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations(locale, function() return {
	["translator"] = "Keadrish - Nathrezim.eu",
	
	["waterfall_cmd"] = "Waterfall",
	["waterfall_desc"] = "Waterfall-Konfigurationsmen\195\188 \195\182ffnen",
	
	["lock_cmd"] = "Lock",
	["lock_desc"] = "Sperrt bzw. entsperrt die Frames zum Positionieren",
	
	["reset_cmd"] = "Reset",
	["reset_desc"] = "Alle Positionen auf Standardwerte zur\195\188cksetzen",
	
	["resize_cmd"] = "Size",
	["resize_desc"] = "Framegr\195\182sse setzen",
	
	["element_group_cmd"] = "ElementFrames",
	["element_group_desc"] = "Elementframes anzeigen (an\/aus)",
	["earth_cmd"] = "Erde",
	["fire_cmd"] = "Feuer",
	["water_cmd"] = "Wasser",
	["air_cmd"] = "Luft",
	["element_desc"] = "Frame f\195\188r alle %s Totems aktivieren",
	
	["bonus_group_cmd"] = "BonusFrames",
	["bonus_group_desc"] = "Bonusanzeige (an\/aus)",
	["windfury_cmd"] = "Windfury",
	["windfury_desc"] = "Den \"versteckten\" Windfury-Cooldown anzeigen (an\/aus)",
	["reincarnation_cmd"] = "Reinkarnation",
	["reincarnation_desc"] = "Ankh-Cooldowns anzeigen (an\/aus)",
	
	["ep_cmd"] = "EP",
	["ep_desc"] = "Anzeige der Equivalence Points im Tooltip (an\/aus)",
	["ep_group_cmd"] = "EPTypes",
	["ep_group_desc"] = "Festlegen welche Equivalence Points angezeigt werden sollen",
	["ep_gemq_cmd"] = "GemQuality",
	["ep_gemq_desc"] = "Maximale Qualit\195\164t f\195\188r Edelsteine (1 = Keine, 2 = Selten, 3 = Rar, 4 = Episch)",
	["ep_gemm_cmd"] = "MetaGem",
	["ep_gemm_desc"] = "Metasockel mit in die Berechnung einbeziehen (an\/aus)",
	["ep_info_cmd"] = "Info",
	["ep_info_desc"] = "Mehr Informationen \195\188ber Equivalence Points",
	["ep_info_exec"] = "Einige Quellen die dir helfen  \"deine\" AEP zu finden:\rhttp://elitistjerks.com/f31/t13297-enhance_shaman_collected_works_theorycraft_vol_i/\rhttp://code.google.com/p/wowequipoptimizer\rhttp://www.discofiend.com/pater/\rhttp://elitbrus.tripod.com/",
	["epz_cmd"] = "EPNull",
	["epz_desc"] = "Equivalence Points anzeigen, selbst wenn die Summe Null ist",
	["aep_cmd"] = "AEP",
	["aep_desc"] = "Attackpower Equivalence Points im Tooltip anzeigen (an\/aus)",
	["aeph_cmd"] = "AEPwoH",
	["aeph_desc"] = "Attackpower Equivalence Points (ohne Trefferwertung) im Tooltip anzeigen (an\/aus)",
	["waep_cmd"] = "WAEP",
	["waep_desc"] = "Waffen Attackpower Equivalence Points (2.6 als Basis) im Tooltip anzeigen (an\/aus)",
	["hep_cmd"] = "HEP",
	["hep_desc"] = "Healing Equivalence Points (Heilung) im Tooltip anzeigen (an\/aus)",
	["dep_cmd"] = "DEP",
	["dep_desc"] = "SpellDamage Equivalence Points (Zauberschaden) im Tooltip anzeigen (an\/aus)",
	["deph_cmd"] = "DEPwoH",
	["deph_desc"] = "SpellDamage Equivalence Points (Zauberschaden ohne Zaubertrefferwertung) im Tooltip anzeigen (an\/aus)",
	["eip_cmd"] = "EIP",
	["eip_desc"] = "Enhancement Itemization Points im Tooltip anzeigen (an//aus)",
	["ep_numbers_cmd"] = "EPNumbers",
	["ep_numbers_desc"] = "Hier kannst du die Gewichtung f\195\188r die Berechnung der Punkte \195\164ndern (0 deaktiviert das entsprechende Attribut)",
	["ep_guess_cmd"] = "EPEstimates",
	["ep_guess_desc"] = "Sch\195\164tzungen nicht statischer Boni von Waffen (z.B. Benutzen/Trefferchance) mit in die Berechnung der EP einbeziehen (an\/aus)",
	["ep_gguess_cmd"] = "EPGemEstimates",
	["ep_gguess_desc"] = "Sch\195\164tzungen nicht statischer Boni von Edelsteinen mit in die Berechnung der EP einbeziehen (an\/aus)",
	["ep_expertisehack_cmd"] = "ExpertiseHack",
	["ep_expertisehack_desc"] = "Math.Floor(Waffenkundewertung / 15.8) * 15.8 vor der Berechnung f\195\188r Waffenkundewertung benutzen",
	["bestgem_cmd"] = "BestGem",
	["bestgem_desc"] = "Passende Edelsteine basierend auf deinen Einstellungen berechnen",
	["blue"] = "Blau",
	["yellow"] = "Gelb",
	["red"] = "Rot",
	["any"] = "Beliebig",
	
	["AGI"] = "Beweglichkeit",
	["ATTACKPOWER"] = "Angriffskraft",
	["CR_CRIT"] = "kritische Trefferwertung",
	["CR_HASTE"] = "Angriffstempowertung",
	["CR_HIT"] = "Trefferwertung",
	["CR_EXPERTISE"] = "Waffenkundewertung",
	["CR_SPELLCRIT"] = "kritsche Zaubertrefferwertung",
	["CR_SPELLHASTE"] = "Zaubertempowertung",
	["CR_SPELLHIT"] = "Zaubertrefferwertung",
	["CR_RESILIENCE"] = "Abh\195\164rtung",
	["DMG"] = "Zauberschaden",
	["HEAL"] = "Heilung",
	["IGNOREARMOR"] = "R\195\188stung ignorieren",
	["INT"] = "Intelligenz",
	["MANAREG"] = "MP5",
	["SPI"] = "Willenskraft",
	["STR"] = "St\195\164rke",
	["STA"] = "Ausdauer",
	["WEAPON_MIN"] = "Min. Waffenschaden",
	["WEAPON_MAX"] = "Max. Waffenschaden",
	["MH_DPS"] = "HhDPS",
	["OH_DPS"] = "NhDPS",
		
	["sound_cmd"] = "Sound",
	["sound_desc"] = "Sound beim Ablaufen eines Totems abspielen (an\/aus)",
	
	["growpulse_cmd"] = "GrowPulse",
	["growpulse_desc"] = "Bei Ticks das Icon vergr\195\182ssern (an\/aus)",
	
	["borderpulse_cmd"] = "BorderPulse",
	["borderpulse_desc"] = "Bei Ticks den Rand des Icons einf\195\164rben (an\/aus)",
	
	["alpha_cmd"] = "Alpha",
	["alpha_desc"] = "Frametransparenz festlegen",
	
	["alpha_ooc_active_cmd"] = "AktivAusdemKampf",
	["alpha_ooc_active_desc"] = "Alphawert f\195\188r die Frames die aktiv sind, ausserhalb eines Kampfes",
	
	["alpha_ooc_inactive_cmd"] = "InaktivAusdemKampf",
	["alpha_ooc_inactive_desc"] = "Alphawert f\195\188r die Frames die inaktiv sind, ausserhalb eines Kampfes",
	
	["alpha_ic_active_cmd"] = "AktivImKampf",
	["alpha_ic_active_desc"] = "Alphawert f\195\188r die Frames die aktiv sind, innerhalb eines Kampfes",
	
	["alpha_ic_inactive_cmd"] = "InaktivImKampf",
	["alpha_ic_inactive_desc"] = "Alphawert f\195\188r die Frames die inaktiv sind, innerhalb eines Kampfes",
	
	["specialalpha_cmd"] = "SpezialAlpha",
	["specialalpha_desc"] = "Spezieller Alphawert f\195\188r die \"Bonus\"-Frames (an\/aus)",
	
	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "Ziehen", --"Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s l\195\164uft gleich aus",
	["TotemSlain"] = "%s wurde zerst\195\182rt!!!",
	["TotemDeath"] = "%s ist ausgelaufen",
	
	--[[ Announcements ]]--
	["Announcement"] = "Enhancer wird st\195\164ndig weiter entwickelt, solltest du irgendwo einen Bug finden, oder das Gef\195\188hl haben etwas w\195\164re falsch, dann kannst du mir gerne eine EMail an dennis.hafstrom@gmail.com schicken (In Englisch bitte ;)",
	["Announcement_cmd"] = "Startmeldungen",
	["Announcement_desc"] = "Einstellungen f\195\188r die Startmeldung(en) (Der Spam beim Laden ;)",
	["a_show_cmd"] = "Anzeigen",
	["a_show_desc"] = "Meldungen(en) anzeigen",
	["a_disable_cmd"] = "Abschalten",
	["a_disable_desc"] = "Anzeige der Meldung(en) beim Start abschalten",
	
	[0] = "Rang 0",
	[1] = "Rang 1",
	[2] = "Rang 2",
	[3] = "Rang 3",
	[4] = "Rang 4",
	[5] = "Rang 5",
	[6] = "Rang 6",
	[7] = "Rang 7",
	[8] = "Rang 8",
	[9] = "Rang 9",
	[10] = "Rang 10",
	[11] = "Rang 11",
	[12] = "Rang 12",
	[13] = "Rang 13",
	[14] = "Rang 14",
	[15] = "Rang 15",
	[16] = "Rang 16",
	[17] = "Rang 17",
	[18] = "Rang 18",
	[19] = "Rang 19",
	[20] = "Rang 20",
	
	--[[ Modules ]]--
	["stormstrike_cmd"] = "Sturmschlag",
	["stormstrike_desc"] = "Anzeige f\195\188r Sturmschlag (an\/aus)",
	
	["shield_cmd"] = "Schild",
	["shield_desc"] = "Anzeige f\195\188r Schilde (an\/aus)",
	
	["eshield_cmd"] = "Erdschild",
	["eshield_desc"] = "Anzeige f\195\188r Erdschild (an\/aus)",
	["Lost track of Earth Shield"] = "true",
	["Earth Shield has expired"] = "Erdschild schwindet von euch",
	["Earth Shield is about to expire"] = "Erdschild l\195\164uft bald aus",
	
	["tench_cmd"] = "Verzauberungen",
	["tench_desc"] = "Anzeige der zeitlich begrenzten Verzauberungen (an\/aus)",
	
	["invigorated_cmd"] = "Invigorated",
	["invigorated_desc"] = "Toggle frame for showing when Invigorated is up (Untested)(an\/aus)",
	["Invigorated"] = "true",
	
	["hway_cmd"] = "PfadDerHeilung",
	["hway_desc"] = "Timer ff\195\188rr Pfad der Heilung (an\/aus)",
	["hway_yougain"] = "Ihr bekommt", -- as it appears in combat log when you gain a buff!
	["hway_anchortext"] = "Alt-Klick um den Anker zu bewegen",

	["aep_import_crazyshaman_cmd"] = "CrazyShamanImport",
	--["aep_import_crazyshaman_desc"] = "Import value string from Crazy Shaman's DPS & AEP calculator ( " .. U["CrazyShamanCalc"] .. " )",
	["aep_import_warning"] = "Einige AEP Werte konnten nicht erkannt werden, bitte \195\188berpr\195\188fe folgende Werte (%s)",
	
	["yard_group_cmd"] = "Entfernungseinstellungen",
	["yard_group_desc"] = "Totems verschwinden falls du dich zu weit von ihnen entfernst, hier k\195\182nnen die Einstellungen daf\195\188r getroffen werden",
	["yard_range_cmd"] = "Entfernung",
	["yard_range_desc"] = "Entfernung ab welcher angenommen wird, dass das Totem weg ist (Standardwert: 150, ein kurzer Test im Spiel hat gezeigt, dass es irgendwo n\195\164her bei 100 liegt)",
	["yard_active_cmd"] = "Aktiv",
	["yard_active_desc"] = "Frames basierend auf der Entfernung l\195\182schen (an\/aus)",
	
	["base_warn"] = " (Grundwert)",
	
	["windfurytotem_cmd"] = "WindfuryTotem",
	["windfurytotem_desc"] = "Timer f\195\188r Windfury Totem Twisting",
	
	["snap_cmd"] = "Einrasten",
	["snap_desc"] = "Anzeigen einrasten lassen, wenn sie nahe beieinander sind",
	
	["font_cmd"] = "Schriftart",
	["font_desc"] = "Einstellungen f\195\188r die Schriftarten",
	["fontabove_cmd"] = "\195\188ber",
	["fontabove_desc"] = "Einstellungen f\195\188r die Schriftart oberhalb des Frames",
	["fontcenter_cmd"] = "mitte",
	["fontcenter_desc"] = "Einstellungen f\195\188r die Schriftarten in der Mitte des Frames",
	["fontbelow_cmd"] = "unter",
	["fontbelow_desc"] = "Einstellungen f\195\188r die Schriftarten unterhalb des Frames",
	["fontname_cmd"] = "Schriftart",
	["fontname_desc"] = "Art der Schrift",
	["fontsize_cmd"] = "Gr\195\182sse",
	["fontsize_desc"] = "Gr\195\182sse der Schrift",
	["fontflag_cmd"] = "Umrandung",
	["fontflag_desc"] = "Rand um die Schrift (OUTLINE\|THICKOUTLINE\|NONE)",
	["Messages_cmd"] = "Nachrichten",
	["Messages_desc"] = "Einstellungen der Nachrichten",
	
	["roman_cmd"] = "Romanisch",
	["roman_desc"] = "F\195\188r die Ladungsanzeige von Schilden o.\195\164. r\195\182mische Ziffern benutzen (an\/aus)",
	
	["time_cmd"] = "Zeit",
	["time_desc"] = "Zeiteinstellungen",
	["pulse_cmd"] = "Pulse",
	["pulse_desc"] = "Pulseeinstellungen",
	["warning_cmd"] = "Warnungen",
	["warning_desc"] = "Warnungseinstellungen",
	
	["blizztime_cmd"] = "Blizzard",
	["blizztime_desc"] = "Blizzard's Zeit formatierung benutzen",
	["blizzssec_cmd"] = "SBenutzen",
	["blizzssec_desc"] = "Ein 's' an Sekunden anh\195\164ngen (an\/aus)",
	["warnExpire_cmd"] = "Ablaufen",
	["warnExpire_desc"] = "Vor dem Ablaufen warnen",
	["warnDeath_cmd"] = "Abgelaufen",
	["warnDeath_desc"] = "Beim Ablauf warnen",
	["warnSlain_cmd"] = "Zerst\195\182rt",
	["warnSlain_desc"] = "Warnen falls ein Totem zerst\195\182rt wird",
	["warnTime_cmd"] = "Zeitpunkt",
	["warnTime_desc"] = "Zeitpunkt der Warnung vor dem Ablaufen",
	["buffIndicator_cmd"] = "Buff Indikator",
	["buffIndicator_desc"] = "In welcher Ecke sollen deine Buffs angezeigt werden",
	["topleft"] = "Oben Links",
	["topright"] = "Oben Rechts",
	["bottomleft"] = "Unten Links",
	["bottomright"] = "Unten Rechts",
	["noindication"] = "Keine",
	
	["news_cmd"] = "News",
	["news_desc"] = "Die aktuellsten Neuigkeiten anzeigen (an\/aus)",
	["news_1"] = "Enhancer News & Ver\195\164nderungen!",
	["news_2"] = "Das Newsfenster wird nur einmal angezeigt - Solang die News noch neu sind",
	["news_3"] = "Newsfenster bis zu einem ungewissen Zeitpunkt deaktiviert - Danke f\195\188rs Lesen!",
	["news_4"] = "Kontakt",
	["news_5"] = "Bugs",
	["news_6"] = "sonstige Fehler",
	["news_7"] = "EMail an dennis.hafstrom@gmail.com",
	
	["Wizard Oil"] = "Zauber\195\182l",
	["Mana Oil"] = "Mana\195\182l",
	
	["Import_complete"] = "Import erfolgreich abgeschlossen",
	["low_cmd"] = "Niedrige Werte",
	["low_desc"] = "Werte importieren, die auf Ausr\195\188stung mit Kara/Heroic-Niveau abgestimmt sind",
	["medium_cmd"] = "Mittlere Werte",
	["medium_desc"] = "Werte importieren, die auf Ausr\195\188stung zwischen Kara/Heroic und Endgame Niveau abgestimmt sind",
	["high_cmd"] = "Hohe Werte",
	["high_desc"] = "Werte importieren, die auf Ausr\195\188stung mit Endgame-Niveau abgestimmt sind",
	
	["purge_cmd"] = "Reinigen",
	["purge_desc"] = "Gereinigte Buffs anzeigen (an\/aus)",
	["purge_info"] = "Reinigen: |cffff0000-|r%s|cffff0000-|r",
	["purge_info_long"] = "%s von %s gereinigt",
	["wshield_cmd"] = "Wasserschild",
	["wshield_desc"] = "Wasserschild erinnerung anzeigen (an\/aus)",
	["wshield_warn"] = "Schildanzeige abgeschaltet, da die Wasserschildanzeige aktiv ist",
	--["purger_cmd"] = "ReinigenEr",
	--["purger_desc"] = "Erinnerung f\195\188r Reinigen (an\/aus)",
}; end );

local L_EP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
L_EP:RegisterTranslations("deDE", function() return {
	
	--[[ ItemTypes ]]--
	["Armor"] = "R\195\188stung",
	["Gem"] = "Edelstein",
	["Weapon"] = "Waffe",
	["Projectile"] = "Munition",
	["Quiver"] = "K\195\182cher",
	["Recipe"] = "Rezept",
	
	--[[ Sockets as they appear on the tooltip has to include Socket as it's used for matching and lots of matches are possible with only color ]]--
	--["Red Socket"] = "Roter Sockel",
	--["Blue Socket"] = "Blauer Sockel",
	--["Yellow Socket"] = "Gelber Sockel",
	--["Meta Socket"] = "Metasockel",--
	
	--[[ This is used for matching so need all of it and exactly as it is on the tooltip ]]--
	["Chance on hit:"] = "Trefferchance:",
	
	--[[ Tooltip strings ]]--
	["eep_info"] = "Enhancer's Equivalence Points:",
	
	["aep_tooltip"] = string.rep(" ", 3) .. "AttackpowerEP (mit SdK):",
	["aep_info"] = "AEP model from Tornhoof/Pater", -- Not used atm
	["aeph_tooltip"] = string.rep(" ", 3) .. "AttackpowerEP ohne +Hit (mit SdK):",
	
	["waep_tooltip1"] = string.rep(" ", 3) .. "W-AEP HH%s: ",
	["waep_tooltip2"] = string.rep(" ", 3) .. "W-AEP NH%s:",
	
	["hep_tooltip"] = string.rep(" ", 3) .. "HeilungsEP (mit SdK):",
	["hep_info"] = "Werte von Leion (M\195\182glicherweise ziemlich ungenau, blos nicht f\195\188r bare M\195\188nze nehmen)", -- Not used atm
	
	["dep_tooltip"] = string.rep(" ", 3) .. "SchadensEP (mit SdK):",
	["dep_info"] = "Werte von Leion (M\195\182glicherweise ziemlich ungenau, blos nicht f\195\188r bare M\195\188nze nehmen)", -- Not used atm
	["deph_tooltip"] = string.rep(" ", 3) .. "SchadensEP ohne +Hit (mit SdK):",
	
	["ep_procsanduse"] = string.rep(" ", 3) .. "*) Die Grundlage f\195\188r die Procs/Benutzen Berechnung ist der durchschnittliche/zu erwartende Bonus!",
	["ep_procsandusemissing"] = string.rep(" ", 3) .. "^) Nicht alle m\195\182glichen Procs/Benutzen/Trefferchancen werden berechnet!",
	
	["eip_tooltip"] = "Enhancement Itemization Points",
	["eip_info"] = "Werte von Leion (M\195\182glicherweise ziemlich ungenau, blos nicht f\195\188r bare M\195\188nze nehmen)", -- Not used atm
	
	["ep_numbers1"] = "%d (%d)",  -- Lua string.format
	["ep_numbers2"] = "%.1f (%.1f)",  -- Lua string.format
	
	["bestgem_link"] = "Der beste (color %s) Edelstein f\195\188r die aktuellen Werte ist: %s mit %.1f und %s mit %.1f mit SdK",
	["bestgem_nolink"] = "Der beste (color %s) Edelstein f\195\188r die aktuellen Werte ist: %s mit %.1f und %s mit %.1f mit SdK",
	["Red"] = "rot",
	["Yellow"] = "gelb",
	["Blue"] = "blau",
	["Any"] = "beliebig",
	
}; end );