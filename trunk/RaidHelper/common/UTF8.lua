RaidHelper.UTF8Data = {
	["\197\145"] = "o", -- LATIN SMALL LETTER O WITH DOUBLE ACUTE
	["\197\177"] = "u", -- LATIN SMALL LETTER U WITH DOUBLE ACUTE
	["\197\179"] = "u", -- LATIN SMALL LETTER U WITH OGONEK
	["\196\159"] = "g", -- LATIN SMALL LETTER G WITH BREVE
	["\196\155"] = "e", -- LATIN SMALL LETTER E WITH CARON
	["\195\188"] = "u", -- LATIN SMALL LETTER U WITH DIAERESIS
	["\195\169"] = "e", -- LATIN SMALL LETTER E WITH ACUTE
	["\195\162"] = "a", -- LATIN SMALL LETTER A WITH CIRCUMFLEX
	["\195\164"] = "a", -- LATIN SMALL LETTER A WITH DIAERESIS
	["\195\160"] = "a", -- LATIN SMALL LETTER A WITH GRAVE
	["\195\165"] = "a", -- LATIN SMALL LETTER A WITH RING ABOVE
	["\195\167"] = "c", -- LATIN SMALL LETTER C WITH CEDILLA
	["\195\170"] = "e", -- LATIN SMALL LETTER E WITH CIRCUMFLEX
	["\195\171"] = "e", -- LATIN SMALL LETTER E WITH DIAERESIS
	["\195\168"] = "e", -- LATIN SMALL LETTER E WITH GRAVE
	["\195\175"] = "i", -- LATIN SMALL LETTER I WITH DIAERESIS
	["\195\174"] = "i", -- LATIN SMALL LETTER I WITH CIRCUMFLEX
	["\195\172"] = "i", -- LATIN SMALL LETTER I WITH GRAVE
	["\195\166"] = "a", -- LATIN SMALL LETTER AE
	["\195\180"] = "o", -- LATIN SMALL LETTER O WITH CIRCUMFLEX
	["\195\182"] = "o", -- LATIN SMALL LETTER O WITH DIAERESIS
	["\195\178"] = "o", -- LATIN SMALL LETTER O WITH GRAVE
	["\195\187"] = "u", -- LATIN SMALL LETTER U WITH CIRCUMFLEX
	["\195\185"] = "u", -- LATIN SMALL LETTER U WITH GRAVE
	["\195\191"] = "y", -- LATIN SMALL LETTER Y WITH DIAERESIS
	["\197\165"] = "t", -- LATIN SMALL LETTER T WITH CARON
	["\197\159"] = "s", -- LATIN SMALL LETTER S WITH CEDILLA
	["\197\175"] = "u", -- LATIN SMALL LETTER U WITH RING ABOVE
	["\195\161"] = "a", -- LATIN SMALL LETTER A WITH ACUTE
	["\195\173"] = "i", -- LATIN SMALL LETTER I WITH ACUTE
	["\195\179"] = "o", -- LATIN SMALL LETTER O WITH ACUTE
	["\195\186"] = "u", -- LATIN SMALL LETTER U WITH ACUTE
	["\195\177"] = "n", -- LATIN SMALL LETTER N WITH TILDE
	["\196\141"] = "c", -- LATIN SMALL LETTER C WITH CARON
	["\197\153"] = "r", -- LATIN SMALL LETTER R WITH CARON
	["\197\190"] = "z", -- LATIN SMALL LETTER Z WITH CARON
	["\196\177"] = "i", -- LATIN SMALL LETTER DOTLESS I
	["\197\161"] = "s", -- LATIN SMALL LETTER S WITH CARON
	["\195\189"] = "y", -- LATIN SMALL LETTER Y WITH ACUTE
	["\195\190"] = "t", -- LATIN SMALL LETTER THORN
	["\195\159"] = "s", -- LATIN SMALL LETTER SHARP S
	["\196\131"] = "a", -- LATIN SMALL LETTER A WITH BREVE
	["\197\163"] = "t", -- LATIN SMALL LETTER T WITH CEDILLA
	["\195\184"] = "o", -- LATIN SMALL LETTER O WITH STROKE
	["\196\133"] = "a", -- LATIN SMALL LETTER A WITH OGONEK
	["\196\153"] = "e", -- LATIN SMALL LETTER E WITH OGONEK
	["\196\135"] = "c", -- LATIN SMALL LETTER C WITH ACUTE
	["\197\130"] = "l", -- LATIN SMALL LETTER L WITH STROKE
	["\197\132"] = "n", -- LATIN SMALL LETTER N WITH ACUTE
	["\197\155"] = "s", -- LATIN SMALL LETTER S WITH ACUTE
	["\197\186"] = "z", -- LATIN SMALL LETTER Z WITH ACUTE
	["\197\188"] = "z", -- LATIN SMALL LETTER Z WITH DOT ABOVE
	["\195\135"] = "C", -- LATIN CAPITAL LETTER C WITH CEDILLA
	["\195\132"] = "A", -- LATIN CAPITAL LETTER A WITH DIAERESIS
	["\195\133"] = "A", -- LATIN CAPITAL LETTER A WITH RING ABOVE
	["\195\137"] = "E", -- LATIN CAPITAL LETTER E WITH ACUTE
	["\195\134"] = "A", -- LATIN CAPITAL LETTER AE
	["\195\150"] = "O", -- LATIN CAPITAL LETTER O WITH DIAERESIS
	["\195\156"] = "U", -- LATIN CAPITAL LETTER U WITH DIAERESIS
	["\197\174"] = "U", -- LATIN CAPITAL LETTER U WITH RING ABOVE
	["\195\145"] = "N", -- LATIN CAPITAL LETTER N WITH TILDE
	["\196\140"] = "C", -- LATIN CAPITAL LETTER C WITH CARON
	["\197\152"] = "R", -- LATIN CAPITAL LETTER R WITH CARON
	["\197\160"] = "S", -- LATIN CAPITAL LETTER S WITH CARON
	["\197\189"] = "Z", -- LATIN CAPITAL LETTER Z WITH CARON
	["\195\158"] = "T", -- LATIN CAPITAL LETTER THORN
	["\197\187"] = "Z", -- LATIN CAPITAL LETTER Z WITH DOT ABOVE
	["\196\176"] = "I", -- LATIN CAPITAL LETTER I WITH DOT ABOVE
	["\196\134"] = "C", -- LATIN CAPITAL LETTER C WITH ACUTE
	["\197\129"] = "L", -- LATIN CAPITAL LETTER L WITH STROKE
	["\197\131"] = "N", -- LATIN CAPITAL LETTER N WITH ACUTE
	["\195\147"] = "O", -- LATIN CAPITAL LETTER O WITH ACUTE
	["\197\154"] = "S", -- LATIN CAPITAL LETTER S WITH ACUTE
	["\197\185"] = "Z", -- LATIN CAPITAL LETTER Z WITH ACUTE
	["\206\177"] = "a", -- GREEK SMALL LETTER ALPHA
	["\207\128"] = "p", -- GREEK SMALL LETTER PI
	["\207\131"] = "s", -- GREEK SMALL LETTER SIGMA
	["\206\179"] = "g", -- GREEK SMALL LETTER GAMMA
	["\206\180"] = "d", -- GREEK SMALL LETTER DELTA
	["\206\147"] = "G", -- GREEK CAPITAL LETTER GAMMA
	["\194\181"] = "u", -- MICRO SIGN
}

function RaidHelper:UTF8Replace(expression)
	local expressionRebuild = ""
	for uchar in string.gmatch(expression, "([%z\1-\127\194-\244][\128-\191]*)") do
		if (self.UTF8Data[uchar]) then
			expressionRebuild = expressionRebuild..self.UTF8Data[uchar]
		else
			expressionRebuild = expressionRebuild..uchar
		end
	end
	return expressionRebuild
end


















--[[
018[0x12]:137 o  -> 0151 &#337;  (0xc5 0x91 = 197 145) LATIN SMALL LETTER O WITH DOUBLE ACUTE
019[0x13]:134 u  -> 0171 &#369;  (0xc5 0xb1 = 197 177) LATIN SMALL LETTER U WITH DOUBLE ACUTE
022[0x16]:135 u  -> 0173 &#371;  (0xc5 0xb3 = 197 179) LATIN SMALL LETTER U WITH OGONEK
023[0x17]:133 g  -> 011F &#287;  (0xc4 0x9f = 196 159) LATIN SMALL LETTER G WITH BREVE
127[0x7f]:202 e  -> 011B &#283;  (0xc4 0x9b = 196 155) LATIN SMALL LETTER E WITH CARON
128[0x80]:199 �  -> 00C7 &#199;  (0xc3 0x87 = 195 135) LATIN CAPITAL LETTER C WITH CEDILLA
129[0x81]:252 �  -> 00FC &#252;  (0xc3 0xbc = 195 188) LATIN SMALL LETTER U WITH DIAERESIS
130[0x82]:233 �  -> 00E9 &#233;  (0xc3 0xa9 = 195 169) LATIN SMALL LETTER E WITH ACUTE
131[0x83]:226 �  -> 00E2 &#226;  (0xc3 0xa2 = 195 162) LATIN SMALL LETTER A WITH CIRCUMFLEX
132[0x84]:228 �  -> 00E4 &#228;  (0xc3 0xa4 = 195 164) LATIN SMALL LETTER A WITH DIAERESIS
133[0x85]:224 �  -> 00E0 &#224;  (0xc3 0xa0 = 195 160) LATIN SMALL LETTER A WITH GRAVE
134[0x86]:229 �  -> 00E5 &#229;  (0xc3 0xa5 = 195 165) LATIN SMALL LETTER A WITH RING ABOVE
135[0x87]:231 �  -> 00E7 &#231;  (0xc3 0xa7 = 195 167) LATIN SMALL LETTER C WITH CEDILLA
136[0x88]:234 �  -> 00EA &#234;  (0xc3 0xaa = 195 170) LATIN SMALL LETTER E WITH CIRCUMFLEX
137[0x89]:235 �  -> 00EB &#235;  (0xc3 0xab = 195 171) LATIN SMALL LETTER E WITH DIAERESIS
138[0x8a]:232 �  -> 00E8 &#232;  (0xc3 0xa8 = 195 168) LATIN SMALL LETTER E WITH GRAVE
139[0x8b]:239 �  -> 00EF &#239;  (0xc3 0xaf = 195 175) LATIN SMALL LETTER I WITH DIAERESIS
140[0x8c]:238 �  -> 00EE &#238;  (0xc3 0xae = 195 174) LATIN SMALL LETTER I WITH CIRCUMFLEX
141[0x8d]:236 �  -> 00EC &#236;  (0xc3 0xac = 195 172) LATIN SMALL LETTER I WITH GRAVE
142[0x8e]:196 �  -> 00C4 &#196;  (0xc3 0x84 = 195 132) LATIN CAPITAL LETTER A WITH DIAERESIS
143[0x8f]:197 �  -> 00C5 &#197;  (0xc3 0x85 = 195 133) LATIN CAPITAL LETTER A WITH RING ABOVE
144[0x90]:201 �  -> 00C9 &#201;  (0xc3 0x89 = 195 137) LATIN CAPITAL LETTER E WITH ACUTE
145[0x91]:230 �  -> 00E6 &#230;  (0xc3 0xa6 = 195 166) LATIN SMALL LETTER AE
146[0x92]:198 �  -> 00C6 &#198;  (0xc3 0x86 = 195 134) LATIN CAPITAL LETTER AE
147[0x93]:244 �  -> 00F4 &#244;  (0xc3 0xb4 = 195 180) LATIN SMALL LETTER O WITH CIRCUMFLEX
148[0x94]:246 �  -> 00F6 &#246;  (0xc3 0xb6 = 195 182) LATIN SMALL LETTER O WITH DIAERESIS
149[0x95]:242 �  -> 00F2 &#242;  (0xc3 0xb2 = 195 178) LATIN SMALL LETTER O WITH GRAVE
150[0x96]:251 �  -> 00FB &#251;  (0xc3 0xbb = 195 187) LATIN SMALL LETTER U WITH CIRCUMFLEX
151[0x97]:249 �  -> 00F9 &#249;  (0xc3 0xb9 = 195 185) LATIN SMALL LETTER U WITH GRAVE
152[0x98]:255 �  -> 00FF &#255;  (0xc3 0xbf = 195 191) LATIN SMALL LETTER Y WITH DIAERESIS
153[0x99]:214 �  -> 00D6 &#214;  (0xc3 0x96 = 195 150) LATIN CAPITAL LETTER O WITH DIAERESIS
154[0x9a]:220 �  -> 00DC &#220;  (0xc3 0x9c = 195 156) LATIN CAPITAL LETTER U WITH DIAERESIS
155[0x9b]:162 t  -> 0165 &#357;  (0xc5 0xa5 = 197 165) LATIN SMALL LETTER T WITH CARON
157[0x9d]:204 s  -> 015F &#351;  (0xc5 0x9f = 197 159) LATIN SMALL LETTER S WITH CEDILLA
158[0x9e]:195 u  -> 016F &#367;  (0xc5 0xaf = 197 175) LATIN SMALL LETTER U WITH RING ABOVE
159[0x9f]:221 U  -> 016E &#366;  (0xc5 0xae = 197 174) LATIN CAPITAL LETTER U WITH RING ABOVE
160[0xa0]:225 �  -> 00E1 &#225;  (0xc3 0xa1 = 195 161) LATIN SMALL LETTER A WITH ACUTE
161[0xa1]:237 �  -> 00ED &#237;  (0xc3 0xad = 195 173) LATIN SMALL LETTER I WITH ACUTE
162[0xa2]:243 �  -> 00F3 &#243;  (0xc3 0xb3 = 195 179) LATIN SMALL LETTER O WITH ACUTE
163[0xa3]:250 �  -> 00FA &#250;  (0xc3 0xba = 195 186) LATIN SMALL LETTER U WITH ACUTE
164[0xa4]:241 �  -> 00F1 &#241;  (0xc3 0xb1 = 195 177) LATIN SMALL LETTER N WITH TILDE
165[0xa5]:209 �  -> 00D1 &#209;  (0xc3 0x91 = 195 145) LATIN CAPITAL LETTER N WITH TILDE
166[0xa6]:208 C  -> 010C &#268;  (0xc4 0x8c = 196 140) LATIN CAPITAL LETTER C WITH CARON
167[0xa7]:240 c  -> 010D &#269;  (0xc4 0x8d = 196 141) LATIN SMALL LETTER C WITH CARON
168[0xa8]:194 r  -> 0159 &#345;  (0xc5 0x99 = 197 153) LATIN SMALL LETTER R WITH CARON
169[0xa9]:174 R  -> 0158 &#344;  (0xc5 0x98 = 197 152) LATIN CAPITAL LETTER R WITH CARON
171[0xab]:138 �  -> 0160 &#352;  (0xc5 0xa0 = 197 160) LATIN CAPITAL LETTER S WITH CARON
172[0xac]:154 �  -> 0161 &#353;  (0xc5 0xa1 = 197 161) LATIN SMALL LETTER S WITH CARON
173[0xad]:253 �  -> 00FD &#253;  (0xc3 0xbd = 195 189) LATIN SMALL LETTER Y WITH ACUTE
174[0xae]:219 �  -> 017D &#381;  (0xc5 0xbd = 197 189) LATIN CAPITAL LETTER Z WITH CARON
175[0xaf]:190 �  -> 017E &#382;  (0xc5 0xbe = 197 190) LATIN SMALL LETTER Z WITH CARON
176[0xb0]:185 i  -> 0131 &#305;  (0xc4 0xb1 = 196 177) LATIN SMALL LETTER DOTLESS I
177[0xb1]:222 �  -> 00DE &#222;  (0xc3 0x9e = 195 158) LATIN CAPITAL LETTER THORN
178[0xb2]:254 �  -> 00FE &#254;  (0xc3 0xbe = 195 190) LATIN SMALL LETTER THORN
224[0xe0]:151 a  -> 03B1 &#945;  (0xce 0xb1 = 206 177) GREEK SMALL LETTER ALPHA
225[0xe1]:223 �  -> 00DF &#223;  (0xc3 0x9f = 195 159) LATIN SMALL LETTER SHARP S
226[0xe2]:152 G  -> 0393 &#915;  (0xce 0x93 = 206 147) GREEK CAPITAL LETTER GAMMA
227[0xe3]:153 p  -> 03C0 &#960;  (0xcf 0x80 = 207 128) GREEK SMALL LETTER PI
228[0xe4]:188 a  -> 0103 &#259;  (0xc4 0x83 = 196 131) LATIN SMALL LETTER A WITH BREVE
229[0xe5]:155 s  -> 03C3 &#963;  (0xcf 0x83 = 207 131) GREEK SMALL LETTER SIGMA
230[0xe6]:181 �  -> 00B5 &#181;  (0xc2 0xb5 = 194 181) MICRO SIGN
231[0xe7]:177 ?  -> 03B3 &#947;  (0xce 0xb3 = 206 179) GREEK SMALL LETTER GAMMA
233[0xe9]:157 I  -> 0130 &#304;  (0xc4 0xb0 = 196 176) LATIN CAPITAL LETTER I WITH DOT ABOVE
234[0xea]:144 t  -> 0163 &#355;  (0xc5 0xa3 = 197 163) LATIN SMALL LETTER T WITH CEDILLA
235[0xeb]:147 d  -> 03B4 &#948;  (0xce 0xb4 = 206 180) GREEK SMALL LETTER DELTA
237[0xed]:248 �  -> 00F8 &#248;  (0xc3 0xb8 = 195 184) LATIN SMALL LETTER O WITH STROKE
238[0xee]:170 a  -> 0105 &#261;  (0xc4 0x85 = 196 133) LATIN SMALL LETTER A WITH OGONEK
239[0xef]:200 e  -> 0119 &#281;  (0xc4 0x99 = 196 153) LATIN SMALL LETTER E WITH OGONEK
240[0xf0]:206 C  -> 0106 &#262;  (0xc4 0x86 = 196 134) LATIN CAPITAL LETTER C WITH ACUTE
241[0xf1]:205 c  -> 0107 &#263;  (0xc4 0x87 = 196 135) LATIN SMALL LETTER C WITH ACUTE
242[0xf2]:217 L  -> 0141 &#321;  (0xc5 0x81 = 197 129) LATIN CAPITAL LETTER L WITH STROKE
243[0xf3]:218 l  -> 0142 &#322;  (0xc5 0x82 = 197 130) LATIN SMALL LETTER L WITH STROKE
244[0xf4]:213 N  -> 0143 &#323;  (0xc5 0x83 = 197 131) LATIN CAPITAL LETTER N WITH ACUTE
245[0xf5]:245 n  -> 0144 &#324;  (0xc5 0x84 = 197 132) LATIN SMALL LETTER N WITH ACUTE
246[0xf6]:211 �  -> 00D3 &#211;  (0xc3 0x93 = 195 147) LATIN CAPITAL LETTER O WITH ACUTE
247[0xf7]:192 S  -> 015A &#346;  (0xc5 0x9a = 197 154) LATIN CAPITAL LETTER S WITH ACUTE
249[0xf9]:193 s  -> 015B &#347;  (0xc5 0x9b = 197 155) LATIN SMALL LETTER S WITH ACUTE
251[0xfb]:212 Z  -> 0179 &#377;  (0xc5 0xb9 = 197 185) LATIN CAPITAL LETTER Z WITH ACUTE
252[0xfc]:210 z  -> 017A &#378;  (0xc5 0xba = 197 186) LATIN SMALL LETTER Z WITH ACUTE
253[0xfd]:203 Z  -> 017B &#379;  (0xc5 0xbb = 197 187) LATIN CAPITAL LETTER Z WITH DOT ABOVE
254[0xfe]:207 z  -> 017C &#380;  (0xc5 0xbc = 197 188) LATIN SMALL LETTER Z WITH DOT ABOVE
]]