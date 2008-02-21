local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end

AddOn.InfoStorage.GemsVersion = "2.3.3";
-- Gems need a prio (if they end up at the same value some pure stats should probably be choosen)
AddOn.InfoStorage.Gems = {
	[32212] = {
		["Name"] = "Shifting Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 5,
			["STA"] = 7,
		},
	},
	[23096] = {
		["Name"] = "Runed Blood Garnet",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["DMG"] = 7,
		},
	},
	[23097] = {
		["Name"] = "Delicate Blood Garnet",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 6,
		},
	},
	[23094] = {
		["Name"] = "Teardrop Blood Garnet",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["HEAL"] = 13,
			["DMG"] = 5,
		},
	},
	[23095] = {
		["Name"] = "Bold Blood Garnet",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["STR"] = 6,
		},
	},
	[32218] = {
		["Name"] = "Potent Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 5,
			["DMG"] = 6,
		},
	},
	[28465] = {
		["Name"] = "Lustrous Zircon",
		["Rarity"] = 1,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 1,
		},
	},
	[23098] = {
		["Name"] = "Inscribed Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["STR"] = 3,
			["CR_CRIT"] = 3,
		},
	},
	[23099] = {
		["Name"] = "Luminous Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["INT"] = 3,
			["HEAL"] = 7,
			["DMG"] = 3,
		},
	},
	[23114] = {
		["Name"] = "Gleaming Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 6,
		},
	},
	[23115] = {
		["Name"] = "Thick Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_DEFENSE"] = 6,
		},
	},
	[23116] = {
		["Name"] = "Rigid Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_HIT"] = 6,
		},
	},
	[23110] = {
		["Name"] = "Shifting Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 3,
			["STA"] = 4,
		},
	},
	[23113] = {
		["Name"] = "Brilliant Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 6,
		},
	},
	[23118] = {
		["Name"] = "Solid Azure Moonstone",
		["Rarity"] = 2,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 9,
		},
	},
	[23119] = {
		["Name"] = "Sparkling Azure Moonstone",
		["Rarity"] = 2,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 6,
		},
	},
	[23109] = {
		["Name"] = "Royal Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 1,
			["HEAL"] = 7,
			["DMG"] = 3,
		},
	},
	[24027] = {
		["Name"] = "Bold Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["STR"] = 8,
		},
	},
	[22459] = {
		["Name"] = "Void Sphere",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ALLRES"] = 4,
		},
	},
	[31860] = {
		["Name"] = "Great Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 6,
		},
	},
	[31869] = {
		["Name"] = "Wicked Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 6,
			["CR_CRIT"] = 3,
		},
	},
	[23120] = {
		["Name"] = "Stormy Azure Moonstone",
		["Rarity"] = 2,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 8,
		},
	},
	[23121] = {
		["Name"] = "Lustrous Azure Moonstone",
		["Rarity"] = 2,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 2,
		},
	},
	[28290] = {
		["Name"] = "Smooth Golden Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 6,
		},
	},
	[31118] = {
		["Name"] = "Pulsing Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 10,
			["STA"] = 6,
		},
	},
	[25901] = {
		["Name"] = "Insightful Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["INT"] = 12,
		},
		["Bonus Special"] = {
			["Chance to restore mana on spellcast"] = true, -- Special Bonus
		},
	},
	[32641] = {
		["Name"] = "Imbued Unstable Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["DMG"] = 14,
		},
		["Bonus Special"] = {
			["5% Stun Resistance"] = true, -- Special Bonus
		},
	},
	[32640] = {
		["Name"] = "Potent Unstable Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 24,
		},
		["Bonus Special"] = {
			["5% Stun Resistance"] = true, -- Special Bonus
		},
	},
	[23111] = {
		["Name"] = "Sovereign Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STR"] = 3,
			["STA"] = 4,
		},
	},
	[28464] = {
		["Name"] = "Sparkling Zircon",
		["Rarity"] = 1,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 4,
		},
	},
	[28466] = {
		["Name"] = "Brilliant Amber",
		["Rarity"] = 1,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 4,
		},
	},
	[28467] = {
		["Name"] = "Smooth Amber",
		["Rarity"] = 1,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 4,
		},
	},
	[28460] = {
		["Name"] = "Teardrop Tourmaline",
		["Rarity"] = 1,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["HEAL"] = 9,
			["DMG"] = 3,
		},
	},
	[24054] = {
		["Name"] = "Sovereign Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STR"] = 4,
			["STA"] = 6,
		},
	},
	[24056] = {
		["Name"] = "Glowing Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
			["DMG"] = 5,
		},
	},
	[24057] = {
		["Name"] = "Royal Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 2,
			["HEAL"] = 9,
			["DMG"] = 3,
		},
	},
	[24050] = {
		["Name"] = "Gleaming Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 8,
		},
	},
	[24051] = {
		["Name"] = "Rigid Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_HIT"] = 8,
		},
	},
	[24052] = {
		["Name"] = "Thick Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_DEFENSE"] = 8,
		},
	},
	[24053] = {
		["Name"] = "Mystic Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_RESILIENCE"] = 8,
		},
	},
	[24058] = {
		["Name"] = "Inscribed Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["STR"] = 4,
			["CR_CRIT"] = 4,
		},
	},
	[24059] = {
		["Name"] = "Potent Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 4,
			["DMG"] = 5,
		},
	},
	[24048] = {
		["Name"] = "Smooth Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 8,
		},
	},
	[23103] = {
		["Name"] = "Radiant Deep Peridot",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 4,
			["CR_SPELLCRIT"] = 3,
		},
	},
	[28469] = {
		["Name"] = "Gleaming Amber",
		["Rarity"] = 1,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 4,
		},
	},
	--[[
	[32735] = {
		["Name"] = "Radiant Spencerite",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 20,
		},
	},
	]]
	[32836] = {
		["Name"] = "Purified Shadow Pearl",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 4,
			["HEAL"] = 9,
			["DMG"] = 3,
		},
	},
	[28470] = {
		["Name"] = "Thick Amber",
		["Rarity"] = 1,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_DEFENSE"] = 4,
		},
	},
	[32833] = {
		["Name"] = "Purified Jaggal Pearl",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 3,
			["HEAL"] = 7,
			["DMG"] = 3,
		},
	},
	[32409] = {
		["Name"] = "Relentless Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 12,
		},
		["Bonus Special"] = {
			["3% Increased Critical Damage"] = true, -- Special Bonus
		},
	},
	[24066] = {
		["Name"] = "Radiant Talasite",
		["Rarity"] = 3,
		["Color"] = {
			["BLUE"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 5,
			["CR_SPELLCRIT"] = 4,
		},
	},
	[24067] = {
		["Name"] = "Jagged Talasite",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 4,
			["STA"] = 6,
		},
	},
	[24060] = {
		["Name"] = "Luminous Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 4,
			["HEAL"] = 9,
			["DMG"] = 3,
		},
	},
	[24061] = {
		["Name"] = "Glinting Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 4,
			["CR_HIT"] = 4,
		},
	},
	[24062] = {
		["Name"] = "Enduring Talasite",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
			["CR_DEFENSE"] = 4,
		},
	},
	[24065] = {
		["Name"] = "Dazzling Talasite",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["INT"] = 4,
			["MANAREG"] = 2,
		},
	},
	[32205] = {
		["Name"] = "Smooth Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 10,
		},
	},
	[32204] = {
		["Name"] = "Brilliant Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 10,
		},
	},
	[32207] = {
		["Name"] = "Gleaming Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 10,
		},
	},
	[32206] = {
		["Name"] = "Rigid Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_HIT"] = 10,
		},
	},
	[32201] = {
		["Name"] = "Sparkling Empyrean Sapphire",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 10,
		},
	},
	[32200] = {
		["Name"] = "Solid Empyrean Sapphire",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 15,
		},
	},
	[32203] = {
		["Name"] = "Stormy Empyrean Sapphire",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 13,
		},
	},
	[32202] = {
		["Name"] = "Lustrous Empyrean Sapphire",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 4,
		},
	},
	[32209] = {
		["Name"] = "Mystic Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_RESILIENCE"] = 10,
		},
	},
	[32208] = {
		["Name"] = "Thick Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_DEFENSE"] = 10,
		},
	},
	[32195] = {
		["Name"] = "Teardrop Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["HEAL"] = 22,
			["DMG"] = 8,
		},
	},
	[32194] = {
		["Name"] = "Delicate Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 10,
		},
	},
	[32197] = {
		["Name"] = "Bright Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 20,
		},
	},
	[32196] = {
		["Name"] = "Runed Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["DMG"] = 12,
		},
	},
	[32193] = {
		["Name"] = "Bold Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["STR"] = 10,
		},
	},
	[24028] = {
		["Name"] = "Delicate Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 8,
		},
	},
	[24029] = {
		["Name"] = "Teardrop Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["HEAL"] = 18,
			["DMG"] = 6,
		},
	},
	[32199] = {
		["Name"] = "Flashing Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["CR_PARRY"] = 10,
		},
	},
	[32198] = {
		["Name"] = "Subtle Crimson Spinel",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["CR_DODGE"] = 10,
		},
	},
	[33782] = {
		["Name"] = "Steady Talasite",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
			["CR_RESILIENCE"] = 4,
		},
	},
	[32215] = {
		["Name"] = "Glowing Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 7,
			["DMG"] = 6,
		},
	},
	[32216] = {
		["Name"] = "Royal Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 2,
			["HEAL"] = 11,
			["DMG"] = 4,
		},
	},
	[32210] = {
		["Name"] = "Great Lionseye",
		["Rarity"] = 4,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 10,
		},
	},
	[32219] = {
		["Name"] = "Luminous Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 5,
			["HEAL"] = 11,
			["DMG"] = 4,
		},
	},
	[23106] = {
		["Name"] = "Dazzling Deep Peridot",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["INT"] = 3,
			["MANAREG"] = 1,
		},
	},
	[32410] = {
		["Name"] = "Thundering Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus Special"] = {
			["Chance to Increase Melee/Ranged Attack Speed"] = true, -- Special Bonus
		},
	},
	[28461] = {
		["Name"] = "Runed Tourmaline",
		["Rarity"] = 1,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["DMG"] = 5,
		},
	},
	[28462] = {
		["Name"] = "Bright Tourmaline",
		["Rarity"] = 1,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 8,
		},
	},
	[28463] = {
		["Name"] = "Solid Zircon",
		["Rarity"] = 1,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
		},
	},
	[24035] = {
		["Name"] = "Sparkling Star of Elune",
		["Rarity"] = 3,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPI"] = 8,
		},
	},
	[24036] = {
		["Name"] = "Flashing Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["CR_PARRY"] = 8,
		},
	},
	[24037] = {
		["Name"] = "Lustrous Star of Elune",
		["Rarity"] = 3,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["MANAREG"] = 3,
		},
	},
	[24030] = {
		["Name"] = "Runed Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["DMG"] = 9,
		},
	},
	[24031] = {
		["Name"] = "Bright Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 16,
		},
	},
	[24032] = {
		["Name"] = "Subtle Living Ruby",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["CR_DODGE"] = 8,
		},
	},
	[24033] = {
		["Name"] = "Solid Star of Elune",
		["Rarity"] = 3,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 12,
		},
	},
	[24039] = {
		["Name"] = "Stormy Star of Elune",
		["Rarity"] = 3,
		["Color"] = {
			["BLUE"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 10,
		},
	},
	[28595] = {
		["Name"] = "Bright Blood Garnet",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 12,
		},
	},
	[22460] = {
		["Name"] = "Prismatic Sphere",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ALLRES"] = 3,
		},
	},
	[28468] = {
		["Name"] = "Rigid Amber",
		["Rarity"] = 1,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_HIT"] = 4,
		},
	},
	[32225] = {
		["Name"] = "Dazzling Seaspray Emerald",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 5,
			["MANAREG"] = 2,
		},
	},
	[32224] = {
		["Name"] = "Radiant Seaspray Emerald",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["SPELLPEN"] = 6,
			["CR_SPELLCRIT"] = 5,
		},
	},
	[32226] = {
		["Name"] = "Jagged Seaspray Emerald",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 5,
			["STA"] = 7,
		},
	},
	[32221] = {
		["Name"] = "Veiled Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 5,
			["DMG"] = 6,
		},
	},
	[32220] = {
		["Name"] = "Glinting Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 5,
			["CR_HIT"] = 5,
		},
	},
	[32223] = {
		["Name"] = "Enduring Seaspray Emerald",
		["Rarity"] = 4,
		["Color"] = {
			["BLUE"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["STA"] = 7,
			["CR_DEFENSE"] = 5,
		},
	},
	[32222] = {
		["Name"] = "Wicked Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 10,
			["CR_CRIT"] = 5,
		},
	},
	[31865] = {
		["Name"] = "Infused Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 8,
			["MANAREG"] = 2,
		},
	},
	[31867] = {
		["Name"] = "Veiled Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 4,
			["DMG"] = 5,
		},
	},
	[31861] = {
		["Name"] = "Great Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 8,
		},
	},
	[31863] = {
		["Name"] = "Balanced Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 8,
			["STA"] = 6,
		},
	},
	[31862] = {
		["Name"] = "Balanced Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 6,
			["STA"] = 4,
		},
	},
	[31868] = {
		["Name"] = "Wicked Noble Topaz",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 8,
			["CR_CRIT"] = 4,
		},
	},
	[24047] = {
		["Name"] = "Brilliant Dawnstone",
		["Rarity"] = 3,
		["Color"] = {
			["YELLOW"] = true, 
		},
		["Bonus"] = {
			["INT"] = 8,
		},
	},
	[28458] = {
		["Name"] = "Bold Tourmaline",
		["Rarity"] = 1,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["STR"] = 4,
		},
	},
	[28459] = {
		["Name"] = "Delicate Tourmaline",
		["Rarity"] = 1,
		["Color"] = {
			["RED"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 4,
		},
	},
	[34220] = {
		["Name"] = "Chaotic Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 12,
		},
		["Bonus Special"] = {
			["3% Increased Critical Damage"] = true, -- Special Bonus
		},
	},
	[24055] = {
		["Name"] = "Shifting Nightseye",
		["Rarity"] = 3,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 4,
			["STA"] = 6,
		},
	},
	[23104] = {
		["Name"] = "Jagged Deep Peridot",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 3,
			["STA"] = 4,
		},
	},
	[23105] = {
		["Name"] = "Enduring Deep Peridot",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 4,
			["CR_DEFENSE"] = 3,
		},
	},
	[31117] = {
		["Name"] = "Soothing Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
			["HEAL"] = 11,
		},
	},
	[31116] = {
		["Name"] = "Infused Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 6,
			["DMG"] = 6,
		},
	},
	[23100] = {
		["Name"] = "Glinting Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["AGI"] = 3,
			["CR_HIT"] = 3,
		},
	},
	[23101] = {
		["Name"] = "Potent Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 3,
			["DMG"] = 4,
		},
	},
	[25894] = {
		["Name"] = "Swift Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 24,
		},
		["Bonus Special"] = {
			["Minor Run Speed Increase"] = true, -- Special Bonus
		},
	},
	[25895] = {
		["Name"] = "Enigmatic Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["CR_CRIT"] = 12,
		},
		["Bonus Special"] = {
			["5% Snare and Root Resist"] = true, -- Special Bonus
		},
	},
	[25896] = {
		["Name"] = "Powerful Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["STA"] = 18,
		},
		["Bonus Special"] = {
			["5% Stun Resist"] = true, -- Special Bonus
		},
	},
	[25897] = {
		["Name"] = "Bracing Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["HEAL"] = 26,
			["DMG"] = 9,
		},
		["Bonus Special"] = {
			["2% Reduced Threat"] = true, -- Special Bonus
		},
	},
	[25890] = {
		["Name"] = "Destructive Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLCRIT"] = 14,
		},
		["Bonus Special"] = {
			["1% Spell Reflect"] = true, -- Special Bonus
		},
	},
	[23108] = {
		["Name"] = "Glowing Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STA"] = 4,
			["DMG"] = 4,
		},
	},
	[25893] = {
		["Name"] = "Mystical Skyfire Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus Special"] = {
			["Chance on spellcast - next spell cast in half time"] = true, -- Special Bonus
		},
	},
	[25898] = {
		["Name"] = "Tenacious Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus"] = {
			["CR_DEFENSE"] = 12,
		},
		["Bonus Special"] = {
			["Chance to Restore Health on hit"] = true, -- Special Bonus
		},
	},
	[25899] = {
		["Name"] = "Brutal Earthstorm Diamond",
		["Rarity"] = 3,
		["Color"] = {
			["META"] = true, 
		},
		["Bonus Special"] = {
			["+3 Melee Damage & Chance to Stun Target"] = true, -- Special Bonus
		},
	},
	[31864] = {
		["Name"] = "Infused Shadow Draenite",
		["Rarity"] = 2,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 6,
			["MANAREG"] = 1,
		},
	},
	[31866] = {
		["Name"] = "Veiled Flame Spessarite",
		["Rarity"] = 2,
		["Color"] = {
			["YELLOW"] = true, ["RED"] = true, 
		},
		["Bonus"] = {
			["CR_SPELLHIT"] = 3,
			["DMG"] = 4,
		},
	},
	[32214] = {
		["Name"] = "Infused Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 10,
			["MANAREG"] = 2,
		},
	},
	[32217] = {
		["Name"] = "Inscribed Pyrestone",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["YELLOW"] = true, 
		},
		["Bonus"] = {
			["STR"] = 5,
			["CR_CRIT"] = 5,
		},
	},
	[32211] = {
		["Name"] = "Sovereign Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["STR"] = 5,
			["STA"] = 7,
		},
	},
	[32213] = {
		["Name"] = "Balanced Shadowsong Amethyst",
		["Rarity"] = 4,
		["Color"] = {
			["RED"] = true, ["BLUE"] = true, 
		},
		["Bonus"] = {
			["ATTACKPOWER"] = 10,
			["STA"] = 7,
		},
	},
};