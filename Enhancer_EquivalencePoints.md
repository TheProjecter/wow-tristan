# Equivalence Points #
Spec: **Enhancement**, **Restoration**, **Elemental**


## Personalized AEP values ##
[Crazy Shaman's DPS & AEP calculator (c) Yo](http://theorycraft.narod.ru/)


### Attackpower Equivalence Points (AEP) ###
This tries to convert all stats on an item, consumable or gem into Attack Power and present that as a number. There is an alternative without hit as well since you could be hit capped or w/e


### Weapon Attackpower Equivalence Points (WAEP) ###
Tries to calculate WAEP from weapon speed and top/low damage work to this was again done in a thread on Elitist Jerks that I can not find atm.

### Healing Equivalence Points (HEP) ###
Same as above but converts to +1 Healing Spells. No without hit as healing spells can't miss anyway.


### Damage Equivalence Points (DEP) ###
Same as above but converts to +1 Spell Damage. Alternatively without hit if you are hit capped or w/e.

### Enhancer Itemization Points ###
This uses the AEP values to figure out what stats you _"care"_ about. It then calculates the Itemization Points spent onto stats that you _"care"_ about and presents it in the tooltip. This only shows wich item was more expensive to make for you. An Item Level of sorts that ignores stats we don't want. More info here: [Item Values on WoWWiki](http://www.wowwiki.com/Formulas:Item_values)

### Usefull info ###
Enabling Expertise Hack will make Enhancer only acknowledge the amount of expertise rating on an item that is divisible with 3.95. Since you only get Expertise for full 3.95 Expertise Rating this will make sure the EP is not overestimated.

Enabling EPGemEstimates will give items such as Relentless Earthstorm Diamond an EP bonus for the uncalculatable bonus. _Not complete_.

Enabling EPEstimates will give items with a use function or proc a calculated flat EP bonus. _Not complete_.

The High / Medium / Low settings for EP are used to import a default set of values that was calculated in a post on Elitist Jerks forums.

Things marked as _Not complete_ still have trinkets/gems that needs to be calculated most of the important ones for enhancement is done as that's my spec.


### Usefull Commands ###
| AEP On/Off: | ´/enh EPTypes AEP´ |
|:------------|:-------------------|
| AEP without Hit On/Off: | ´/enh EPTypes AEPwoH´ |
| WeaponAEP On/Off: | ´/enh EPTypes WAEP´ |
| HEP On/Off: | ´/enh EPTypes HEP´ |
| DEP On/Off: | ´/enh EPTypes DEP´ |
| DEP without Hit On/Off: | ´/enh EPTypes DEPwoH´ |
| EIP On/Off: | ´/enh EPTypes EIP´ |
| Import from Crazy Shaman: | ´/enh EPNumbers AEP CrazyShamanImport 

&lt;String&gt;

´ |
| Best Gem with your values: | ´/enh EPNumbers AEP/HEP/DEP BestGem Any´ |
| Best Blue Gem with your values: | ´/enh EPNumbers AEP/HEP/DEP BestGem Blue´ |
| Set Gem Quality for epic gear: | ´/enh EPNumbers GemQuality 

&lt;Num&gt;

´ |
| Set Gem Quality for non epic gear: | ´/enh EPNumbers GemQualityNonEpic

&lt;Num&gt;

´ |

Back to [Main Page](Enhancer.md)