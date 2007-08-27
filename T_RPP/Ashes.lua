DEFAULT_CHAT_FRAME:AddMessage("|cffffff7fAshesRPP:|r /script T_RPP:LoadAshesRPP()")

local AshesRPP = {
	["22961"] = "125.00", -- Band of Reanimation
	["23036"] = "175.00", -- Necklace of Necropsy
	["22994"] = "125.00", -- Digested Hand of Power
	["22803"] = "250.00", -- Midnight Haze
	["23044"] = "275.00", -- Harbinger of Doom
	["22947"] = "150.00", -- Pendant of Forgotten Names
	["22940"] = "0.00", -- Icebane Pauldrons
	["22935"] = "0.00", -- Touch of Frost
	["23033"] = "0.00", -- Icy Scale Coif
	["22813"] = "325.00", -- Claymore of Unholy Might
	["22810"] = "150.00", -- Toxin Injector
	["23035"] = "200.00", -- Preceptor's Hat
	["22363"] = "200.00", -- Desecrated Girdle
	["22981"] = "100.00", -- Gluth's Missing Collar
	["22988"] = "300.00", -- The End of Dreams
	["22361"] = "200.00", -- Desecrated Spaulders
	["22820"] = "125.00", -- Wand of Fates
	["22356"] = "200.00", -- Desecrated Waistguard
	["23068"] = "200.00", -- Legplates of Carnage
	["23014"] = "275.00", -- Iblis, Blade of the Fallen Seraph
	["22368"] = "200.00", -- Desecrated Shoulderpads
	["22818"] = "200.00", -- The Plague Bearer
	["22371"] = "200.00", -- Desecrated Gloves
	["22355"] = "150.00", -- Desecrated Bracers
	["22816"] = "250.00", -- Hatchet of Sundered Bone
	["23221"] = "250.00", -- Misplaced Servo Arm
	["23219"] = "200.00", -- Girdle of the Mentor
	["23220"] = "200.00", -- Crystal Webbed Robe
	["22941"] = "0.00", -- Polar Shoulder Pads
	["22939"] = "125.00", -- Band of Unanswered Prayers
	["22967"] = "0.00", -- Icy Scale Spaulders
	["22815"] = "325.00", -- Severance
	["22354"] = "200.00", -- Desecrated Pauldrons
	["23031"] = "125.00", -- Band of the Inevitable
	["23009"] = "125.00", -- Wand of the Whispering Dead
	["22804"] = "300.00", -- Maexxna's Fang
	["23004"] = "100.00", -- Idol of Longevity
	["22365"] = "200.00", -- Desecrated Boots
	["23069"] = "0.00", -- Necro-Knight's Garb
	["22954"] = "200.00", -- Kiss of the Spider
	["22942"] = "250.00", -- The Widow's Embrace
	["23237"] = "150.00", -- Ring of the Eternal Flame
	["22936"] = "150.00", -- Wristguards of Vengeance
	["23666"] = "100.00", -- Belt of the Grand Crusader
	["22370"] = "200.00", -- Desecrated Belt
	["23006"] = "100.00", -- Libram of Light
	["23017"] = "150.00", -- Veil of Eclipse
	["22372"] = "200.00", -- Desecrated Sandals
	["22807"] = "300.00", -- Wraith Blade
	["22364"] = "200.00", -- Desecrated Handguards
	["22357"] = "200.00", -- Desecrated Gauntlets
	["22362"] = "150.00", -- Desecrated Wristguards
	["22806"] = "275.00", -- Widow's Remorse
	["23238"] = "25.00", -- Stygian Buckler
	["23226"] = "175.00", -- Ghoul Skin Tunic
	["22937"] = "0.00", -- Gem of Nerubis
	["22726"] = "0.00", -- Splinter of Atiesh
	["22369"] = "150.00", -- Desecrated Bindings
	["23667"] = "150.00", -- Spaulders of the Grand Crusader
	["21675"] = "125.00", -- Thick Qirajihide Belt
	["21837"] = "200.00", -- Anubisath Warhammer
	["21704"] = "150.00", -- Boots of the Redeemed Prophecy
	["21606"] = "125.00", -- Belt of the Fallen Emperor
	["21671"] = "150.00", -- Robes of the Battleguard
	["21836"] = "150.00", -- Ritssyn's Ring of Chaos
	["21707"] = "100.00", -- Ring of Swarming Thought
	["21602"] = "150.00", -- Qiraji Execution Bracers
	["21609"] = "125.00", -- Regenerating Belt of Vek'nilash
	["21617"] = "150.00", -- Wasphide Gauntlets
	["21639"] = "150.00", -- Pauldrons of the Unrelenting
	["21652"] = "0.00", -- Silithid Carapace Chestguard
	["21672"] = "150.00", -- Gloves of Enforcement
	["21597"] = "150.00", -- Royal Scepter of Vek'lor
	["21608"] = "150.00", -- Amulet of Vek'nilash
	["21618"] = "100.00", -- Hive Defiler Wristguards
	["21700"] = "125.00", -- Pendant of the Qiraji Guardian
	["21814"] = "200.00", -- Breastplate of Annihilation
	["21604"] = "100.00", -- Bracelets of Royal Redemption
	["21237"] = "250.00", -- Imperial Qiraji Regalia
	["21620"] = "150.00", -- Ring of the Martyr
	["21651"] = "150.00", -- Scaled Sand Reaver Leggings
	["21667"] = "150.00", -- Legplates of Blazing Light
	["21676"] = "150.00", -- Leggings of the Festering Swarm
	["21706"] = "100.00", -- Boots of the Unwavering Will
	["21627"] = "0.00", -- Cloak of Untold Secrets
	["21663"] = "200.00", -- Robes of the Guardian Saint
	["21669"] = "150.00", -- Creeping Vine Helm
	["21673"] = "200.00", -- Silithid Claw
	["21601"] = "150.00", -- Ring of Emperor Vek'lor
	["20930"] = "150.00", -- Vek'lor's Diadem
	["21679"] = "225.00", -- Kalimdor's Revenge
	["20926"] = "150.00", -- Vek'nilash's Circlet
	["21616"] = "125.00", -- Huhuran's Stinger
	["20928"] = "150.00", -- Qiraji Bindings of Command
	["20932"] = "150.00", -- Qiraji Bindings of Dominance
	["21665"] = "100.00", -- Mantle of Wicked Revenge
	["21232"] = "250.00", -- Imperial Qiraji Armaments
	["21647"] = "0.00", -- Fetish of the Sand Reaver
	["21648"] = "0.00", -- Recomposed Boots
	["21670"] = "25.00", -- Badge of the Swarmguard
	["21701"] = "100.00", -- Cloak of Concentrated Hatred
	["19394"] = "150.00", -- Drake Talon Pauldrons
	["19355"] = "150.00", -- Shadow Wing Focus Staff
	["19363"] = "250.00", -- Crul'shorukh, Edge of Chaos
	["19430"] = "150.00", -- Shroud of Pure Thought
	["19402"] = "150.00", -- Legguards of the Fallen Crusader
	["19350"] = "150.00", -- Heartstriker
	["16933"] = "150.00", -- Nemesis Belt
	["19368"] = "125.00", -- Dragonbreath Hand Cannon
	["19343"] = "100.00", -- Scrolls of Blinding Light
	["19351"] = "225.00", -- Maladath, Runed Blade of the Black Flight
	["16906"] = "150.00", -- Bloodfang Boots
	["16965"] = "150.00", -- Sabatons of Wrath
	["16902"] = "200.00", -- Stormrage Pauldrons
	["19391"] = "125.00", -- Shimmering Geta
	["19388"] = "100.00", -- Angelista's Grasp
	["16924"] = "200.00", -- Pauldrons of Transcendence
	["16966"] = "200.00", -- Breastplate of Wrath
	["19377"] = "150.00", -- Prestor's Talisman of Connivery
	["19379"] = "150.00", -- Neltharion's Tear
	["19406"] = "150.00", -- Drake Fang Talisman
	["16920"] = "150.00", -- Handguards of Transcendence
	["19341"] = "125.00", -- Lifegiving Gem
	["19335"] = "150.00", -- Spineshatter
	["19340"] = "50.00", -- Rune of Metamorphosis
	["19389"] = "125.00", -- Taut Dragonhide Shoulderpads
	["19403"] = "150.00", -- Band of Forced Concentration
	["16899"] = "150.00", -- Stormrage Handguards
	["19437"] = "150.00", -- Boots of Pure Thought
	["19346"] = "225.00", -- Dragonfang Blade
	["16903"] = "150.00", -- Stormrage Belt
	["16925"] = "150.00", -- Belt of Transcendence
	["19334"] = "225.00", -- The Untamed Blade
	["16923"] = "200.00", -- Robes of Transcendence
	["16953"] = "200.00", -- Judgement Spaulders
	["19357"] = "200.00", -- Herald of Woe
	["19405"] = "150.00", -- Malfurion's Blessed Bulwark
	["16907"] = "150.00", -- Bloodfang Gloves
	["19365"] = "200.00", -- Claw of the Black Drake
	["16913"] = "150.00", -- Netherwind Gloves
	["16898"] = "150.00", -- Stormrage Boots
	["19358"] = "150.00", -- Draconic Maul
	["19372"] = "175.00", -- Helm of Endless Rage
	["16818"] = "150.00", -- Netherwind Belt
	["16958"] = "200.00", -- Judgement Breastplate
	["19375"] = "200.00", -- Mish'undare, Circlet of the Mind Flayer
	["19382"] = "150.00", -- Pure Elementium Band
	["19386"] = "75.00", -- Elementium Threaded Cloak
	["19387"] = "150.00", -- Chromatic Boots
	["16917"] = "200.00", -- Netherwind Mantle
	["19432"] = "125.00", -- Circle of Applied Force
	["19396"] = "100.00", -- Taut Dragonhide Belt
	["19345"] = "25.00", -- Aegis of Preservation
	["16912"] = "150.00", -- Netherwind Boots
	["16904"] = "150.00", -- Stormrage Bracers
	["16910"] = "150.00", -- Bloodfang Belt
	["19376"] = "150.00", -- Archimtiros' Ring of Reckoning
	["16905"] = "200.00", -- Bloodfang Chestpiece
	["19356"] = "300.00", -- Staff of the Shadow Flame
	["16832"] = "200.00", -- Bloodfang Spaulders
	["19385"] = "200.00", -- Empowered Leggings
	["19392"] = "0.00", -- Girdle of the Fallen Crusader
	["19433"] = "0.00", -- Emberweave Leggings
	["19398"] = "125.00", -- Cloak of Firemaw
	["16956"] = "150.00", -- Judgement Gauntlets
	["16936"] = "0.00", -- Dragonstalker's Belt
	["16960"] = "0.00", -- Waistband of Wrath
	["19336"] = "0.00", -- Arcane Infused Gem
	["16926"] = "150.00", -- Bindings of Transcendence
	["16911"] = "150.00", -- Bloodfang Bracers
	["19003"] = "50.00", -- Head of Nefarian
	["19002"] = "50.00", -- Head of Nefarian
	["19381"] = "150.00", -- Boots of the Shadow Flame
	["16897"] = "200.00", -- Stormrage Chestguard
	["16916"] = "200.00", -- Netherwind Robes
	["19360"] = "250.00", -- Lok'amir il Romathis
	["19352"] = "275.00", -- Chromatically Tempered Sword
	["16961"] = "0.00", -- Pauldrons of Wrath
	["19431"] = "150.00", -- Styleen's Impeding Scarab
	["19400"] = "125.00", -- Firemaw's Clutch
	["19397"] = "100.00", -- Ring of Blackrock
	["19374"] = "100.00", -- Bracers of Arcane Accuracy
	["16957"] = "150.00", -- Judgement Sabatons
	["19371"] = "100.00", -- Pendant of the Fallen Dragon
}

function T_RPP:LoadAshesRPP()
	-- Purge current DB
	self.db.char.Items = { }
	
	-- Load up values!
	for itemID, RPP in AshesRPP do
		if (AshesRPP[itemID]) then
			self.db.char.Items[itemID] = RPP
		end
	end
	self:Print("AshesRPP loaded!")
end