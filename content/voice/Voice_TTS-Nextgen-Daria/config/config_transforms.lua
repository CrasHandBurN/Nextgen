module("VOICE")

----------------------------------------------------------------------------------------------------
---------------------------|  V O I C E   T R A N S F O R M   U T I L S  |--------------------------
----------------------------------------------------------------------------------------------------

-----------------------------------------------
-- ASSERT a konyvtari transform fuggvenyekre --
-----------------------------------------------
fill_functions.fill_waypointname = function (idx) return format_waypointname(info, idx) end
wprevroadtable = {L"-1", L"-1", L"-1"}
wsameroadname = false
wprevpointtable = {L"-1", L"-1"}
waypointname = L""
local use_dativ_for_sameroad = SysConfig:get("tts", "dativ_for_sameroad", 1)
local function get_full_roadname(road)
	local roadname = road.name
	local roadnumber = road.number
	local roadtext = L""
	if roadname and roadnumber then roadtext = roadname.text .. L"|" .. roadnumber.text
	elseif roadnumber then roadtext = roadnumber.text
	elseif roadname then roadtext = roadname.text end
	return roadtext
end
local function check_same_maneuvers_done(data, idx, prevroadtable)
	local same = true
	local t = {L"-1", L"-1", L"-1"}
	local roadtext = get_full_roadname(data[idx].road)
	local t_unused_manouvers = {L"^roundabout", L"^goal", L"^uturn", L"^via"}
	if transform_pattern_match(towstring(data[idx].manouver),t_unused_manouvers) then same = false
	elseif prevroadtable[1] ~= roadtext then same = false
	elseif prevroadtable[2] ~= data[idx].manouver then same = false
	elseif prevroadtable[3] ~= roadtext then same = false end
	t[1] = roadtext == L"" and L"-1" or roadtext
	if #data > idx then
		t[2] = data[idx+1].manouver
		if data[idx+1].road then
			roadtext = get_full_roadname(data[idx+1].road)
			t[3] = roadtext == L"" and L"-1" or roadtext
		end
	end
	return same, t
end
local function check_same_maneuvers(mapinfo, events)
	if events.new_manouver then
		if mapinfo[1].road then wsameroadname, wprevroadtable = check_same_maneuvers_done(mapinfo, 1, wprevroadtable)
		else wsameroadname = false wprevroadtable = {L"-1", L"-1", L"-1"} end
		local match = wsameroadname and L"same" or L"other"
		local str = table_concat(wprevroadtable, L"|")
		voice_debug_log(L"TTS: sameroadname: " .. match .. L" road'"..str..L"'", 3)
	end
end
local function check_waypoint_maneuvers(mapinfo, events)
	local t_used_manouvers = {L"^goal", L"^via"}
	if transform_pattern_match(towstring(mapinfo[1].manouver),t_used_manouvers) then
		local via_type = wstring.find(towstring(mapinfo[1].manouver), L"^via")
		if events.new_manouver or via_type and waypointname == L"" then
			local str, str_index = L"", L""
			if via_type then
				local way_points = MODEL[SysConfig:get("tts", "waypoints_list", "route.list.navigated.waypoints.list")]
				for i = 0, #way_points - 1 do
					if MODEL.navigation.distance_to_destination() > (way_points[#way_points - 1].total_length() - way_points[i].total_length()) then str = way_points[i].name() str_index = towstring(#way_points - i) break end
				end
				if wprevpointtable[1] == str or wprevpointtable[2] == str_index then str = L"" end
			else
				str, str_index = MODEL.navigation.destination_name_short(), L"0"
			end
			wprevpointtable[1] = str == L"" and L"-1" or str
			wprevpointtable[2] = str_index == L"" and L"-1" or str_index
			waypointname = str
			str = (events.new_manouver and L"new" or L"old")..L" maneuver"..L"|"..str_index..L"|"..waypointname
			voice_debug_log(L"TTS: waypointname check: '"..str..L"'", 3)
		end
	else
		wprevpointtable = {L"-1", L"-1"}
		waypointname = L""
	end
end
local guidance_orig = guidance
guidance = function(mapinfo, events)
	if use_dativ_for_sameroad then check_same_maneuvers(mapinfo, events) end
	if announce_waypointname then check_waypoint_maneuvers(mapinfo, events) end
	return guidance_orig(mapinfo, events)
end
function set_announce_waypoint()
	if MODEL.EXISTS.lua.tts.announce_waypointname() then announce_waypointname = MODEL.lua["tts.announce_waypointname"]()
	else announce_waypointname = SysConfig:get("tts", "announce_waypointname", 0) end
end
function set_tts_settings()
	if MODEL.EXISTS.lua.tts.numbers_mode() then numbers_mode = MODEL.lua["tts.numbers_mode"]()
	else numbers_mode = SysConfig:get("tts", "numbers_mode", 1) end
	set_distances_meters()
	set_distances_ttspro_meters()
	local unit_names = {"yards","meters","feet"}
	dist_table = distances[unit_names[MODEL.regional.units() + 1]]
	if MODEL.EXISTS.lua.tts.sentence_variations() then sentence_variations = MODEL.lua["tts.sentence_variations"]()
	else sentence_variations = SysConfig:get("tts", "sentence_variations", 1) end
	set_pattern_variations()
	if MODEL.EXISTS.lua.tts.roadnumber_mode() then roadnumber_mode = MODEL.lua["tts.roadnumber_mode"]()
	else roadnumber_mode = SysConfig:get("tts", "roadnumber_mode", 1) end
	if MODEL.EXISTS.lua.tts.traffic_events_description() then traffic_events_description = MODEL.lua["tts.traffic_events_description"]()
	else traffic_events_description = SysConfig:get("tts", "traffic_events_description", 1) end
	if MODEL.EXISTS.lua.tts.traffic_events_distance() then traffic_events_distance = MODEL.lua["tts.traffic_events_distance"]()
	else traffic_events_distance = SysConfig:get("tts", "traffic_events_distance", 0) end
	set_announce_waypoint()
end
set_tts_settings()

assert(type(transform_and_format) == "function")
assert(type(transform_pattern_match) == "function")
assert(type(transform_chain) == "function")
assert(type(transform_format_roadnumber_eu) == "function")

local preposition_tbl = {L"След",L"в Направление Към"}

local preposition_insert_tbl = {
	{L"в ",{L"Странична улица",L"Кръстовище",L"Път без изход"}},
	{L"по ",{L""}},
}

local preposition_insert_tbl_direction = {
	{L"по ",{L""}},
}

local main_streetnames = {L"Булевард",L"Странична улица",L"Площад",L"Авеню",L"Вилна зона",L"Улица"}

local mother_country = "_bul"

local settlement_preposition = L"в направление към"

local exit_preposition = L"на Изход"

local replace_roadnumber_prepare = {
	{L"^ ",L""},
	{wstring.char(160),L""},
	{L"[еЕ]",L"E"},
	{L"[мМ]",L"M"},
	{L"[nHН]",L"N"},
	{L"[рPР]",L"R"},
	{L"[tтТ]",L"T"},
	{L"[аА]",L"A"},
}

---  Нови регистрационни номера на автомобилни пътища от drey95 - 05.07.19
VOICE["replace_roadnumber" .. mother_country] = {
	{L"(.*)",L"%1/"},
	{L"^A +103([^0-9])",L"Щелковское Шосе%1"},
	{L"^M +1([^0-9])",L"Трасе Москва Минск%1"},
	{L"^R +21([^0-9])",L"Път Санкт-Петербург Печенга%1"},
--- Регионални пътища от drey95 - 11.07.19
	{L"^ +[0-9][0-9][^0-9]%-([0-9][0-9][0-9][^0-9])",L"Регионален път номер %1"},
--- Европейски маршрути от drey95 - 16.07.19
	{L"^E +([1-9][0-9]?[0-9]?)",L"Трасе Е %1"},
--- Азиатски маршрути от drey95 - 11.07.19
	{L"^AN +([1-9][0-9]?)",L"Трасе А Н %1"},
	{L"/",L""},
}

VOICE["replace_mapinfo_roadnumber_name" .. mother_country] = {
	{L"^ +(%S+) +$", function (s)
		local strroad
		local t_roads = {
			{L"Беларус",L"М 1"},
	}
		for _,roads in ipairs(t_roads) do if roads[1] == s then strroad = roads[2] break end end
		if strroad == nil then return L" "..s..L" " end
		local strroadtype = wstring.find(strroad, L"^М") and L" Трасе " or L" Път "
		return strroadtype..strroad..L" "..s..L" " end},
}

VOICE["replace_mapinfo" .. mother_country] = {
	{L"(.*)",L" %1 "},
	{L",",L" , "},
	{L"%([%S ]+%)",L" "},
	{L" [0-9]+%.[0-9]+ ",L" "},
	{L" ([0-9]+)",L"  %1"},
	{L" (%S)%.( ?)(%S)%. ", function (s1, s2, s3)
		if smart_lower_case_get_codegroup(wstring.byte(s1,1)) and smart_lower_case_get_codegroup(wstring.byte(s3,1)) then return L" " end
		return L" "..s1..L"."..s2..s3..L". " end},
		
	--- Заглушки от drey95 - 12.01.20 - За да не се произнасят фразите
	{L"Път Без Име",L" "},
	{L"^ +Изход +$",L""},
	{L"^ +Кръгово Движение +$",L""},
	{L"^ +Черен Път +$",L""},
	
	--- Съкращения от drey95 - 09.07.19
	{L"Екад ",L"Околовръстнен Път "},
	{L"Кад ",L"Околовръстнен Път "},
  	{L"Зсд ",L"Западен Скоростен Диаметър "},
	{L"Ав%.",L"Авеню "}, 
  	{L"Снт ",L"Вилна зона "},
	{L"Ст%.",L"Станция "},
  	{L"Ст ",L"Вилна зона "},
  	{L"Кп ",L"Вилна зона "},
  	{L"Ул[^а-я^ё]",L"Улица "},
	{L" Ор ",L"Общински Район "},
	{L"-ОР ",L"Общински Район "},
	
	--- Вложка от drey95 - 09.07.19: Декодиране на трасетата
 	{L"^ +Беларус +$",L"Трасе М 1 Беларус "},
	
	--- Вложка от drey95 - 09.07.19: Декодиране на номера на пътища по първия номер
	{L"^ +[аА]103 +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Щелковское Шосе"},
	{L"^ +[мМ]1 +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Трасе Москва Минск"},
	--- Регионални пътища от drey95 - 17.07.19
	{L"[0-9][0-9][^0-9]%-([0-9][0-9][0-9])",L"Регионален път номер %1"},
	--- Европейски маршрути от drey95 - 17.07.19
	{L"^ +[еЕ]([1-9][0-9]?[0-9]?) +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Трасе Е %1"},
	--- Азиатски маршрути от drey95 - 17.07.19
	{L"^ +[аА][нН]([1-9][0-9]?) +%W* +[аАеЕмМрР]?[0-9]?[0-9]?[0-9]? +$",L"Трасе А Н %1"},
	--- Премахване на нулите преди числото [1-9] от drey95 - 09.07.19 (записът трябва да е в края на раздела)
	{L"[^1-9]0+([1-9])",L"%1"},
	{L"|",L""},
}

local mapinfo_numbers = {
	{L"", L"втори", L"трети", L"четвърти", L"пети", L"шести", L"седми", L"осми", L"девети"},
	{L"едно", L"две", L"три", L"четири", L"пет", L"шест", L"седем", L"осем", L"девет"},
	{L"", L"двадесет", L"тридесет", L"четиридесет", L"петдесет", L"шестдесет", L"седемдесет", L"осемдесет", L"деветдесет"},
	{L"сто", L"двеста", L"триста", L"четиристотин", L"петстотин", L"шестстотин", L"седемстотин", L"осемстотин", L"деветстотин"},
	{L"хиляда", L"две хиляди", L"три хиляди", L"четири хиляди", L"пет хиляди", L"шест хиляди", L"седем хиляди", L"осем хиляди", L"девет хиляди"},
}

VOICE["replace_mapinfo_numbers" .. mother_country] = {
	{L" 26[%- ]?Т?и? Бакинских ",L" двадесет и шести Бакински "},
	{L" ([0-9]+)%-А линия",L" %1 Линия "},
	{L" ([0-9]+)%-Т?и Летия ",L" %1 Летия "},
	{L"%-й Конна Лахта",L"-А Конна Лахта"},
	{L"(.*)", function (s)
		local matched = 0
		wstring.gsub(s, L"([0-9]+)", function() matched = matched + 1 end)
		return (matched >= 2 and L"||" or L"")..wstring.gsub(s, L"Имени ", L"|Имени ") end},
	{L"([0-9]+) +(%S+)", function (s1,s2)
		local t = {L"Година", L"Партсъезда", L"Януари", L"Февруари", L"Март", L"Април", L"Май", L"Юни", L"Юли", L"Август", L"Септември", L"Октомври", L"Ноември", L"Декември"}
		local suffix = L""
		for _,v in ipairs(t) do
			if s2==v then suffix = L"-о" break end
		end
		if s2==L"Километър" then suffix = L" " end
		if s2==L"Линия" then suffix = L" " end
		if s2==L"Петилетка" then suffix = L" " end
		return s1..suffix..L" "..s2 end},
	{L"([^0-9]+) ([0-9]+) ([^0-9]+)", function (s1,s2,s3)
		local suffix = L""
		if wstring.find(s1..s3,L"Кръстовище") then suffix = L"-То" end
		if wstring.find(s3,L"Дивизия") then suffix = L" " end
		return s1..L" "..s2..suffix..L" "..s3 end},
	{L"([0-9]+)-й ([^0-9]+)", function (s1,s2)
		local t = {L"Дивизия", L"Армия", L"Батарея", L"Линия"}
		local suffix = L"-я"
		for _,v in ipairs(t) do
			if wstring.find(s2,v) then suffix = L" " break end
		end
		return s1..suffix..L" "..s2 end},

	{L" ([0-9])000[%- ]?А?я ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"тысячная| " end},
	{L" ([0-9])000[%- ]?Ой ", function (s) return L" "..mapinfo_numbers[1][tonumber(s)]..L"тысячной " end},
	{L" ([0-9])000[%- ]?Ы?й ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"тысячный| " end},
	{L" ([0-9])000[%- ]?О?е ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"тысячное| " end},
	{L" ([0-9])000[%- ]?Г?о ", function (s) return L" "..mapinfo_numbers[1][tonumber(s)]..L"тысячного " end},
	{L" ([0-9])000[%- ]?Летия ", function (s) return L" "..mapinfo_numbers[1][tonumber(s)]..L"тысячелетия " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?[АЬ]?я ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" |"..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-я " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?[ОЕ]й ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" |"..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-Ой " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?[ЫИ]?й ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" |"..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-й " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?[ОЬ]?е ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" |"..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-е " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?Г?о ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" "..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-о " end},
	{L" ([0-9])([0-9])([0-9])([0-9])[%- ]?Летия ", function (s1,s2,s3,s4) if s2==L"0" then s2=L"" if s3==L"0" then s3=L"" end end return L" "..mapinfo_numbers[5][tonumber(s1)]..L" "..s2..s3..s4..L"-Летия " end},
	{L" ([0-9])00[%- ]?А?я ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"сотая| " end},
	{L" ([0-9])00[%- ]?Ой ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"сотой| " end},
	{L" ([0-9])00[%- ]?Ы?й ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"сотый| " end},
	{L" ([0-9])00[%- ]?О?е ", function (s) return L" |"..mapinfo_numbers[1][tonumber(s)]..L"сотое| " end},
	{L" ([0-9])00[%- ]?Г?о ", function (s) return L" "..mapinfo_numbers[1][tonumber(s)]..L"сотого " end},
	{L" ([0-9])00[%- ]?Летия ", function (s)
		local t = {L"сто", L"двухсот", L"трёхсот", L"четырёхсот", L"пятьсот", L"шестьсот", L"семьсот", L"восемьсот", L"девятьсот"}
		return L" "..t[tonumber(s)]..L"летия " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?[АЬ]?я ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" |"..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-я " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?[ОЕ]й ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" |"..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-Ой " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?[ЫИ]?й ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" |"..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-й " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?[ОЬ]?е ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" |"..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-е " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?Г?о ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" "..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-о " end},
	{L" ([0-9])([0-9])([0-9])[%- ]?Летия ", function (s1,s2,s3) if s2==L"0" then s2=L"" end return L" "..mapinfo_numbers[4][tonumber(s1)]..L" "..s2..s3..L"-Летия " end},
	{L" ([0-9])0[%- ]?А?я ", function (s)
		local t = {L"десятая", L"двадцатая", L"тридцатая", L"сороковая", L"пятидесятая", L"шестидесятая", L"семидесятая", L"восьмидесятая", L"девяностая"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])0[%- ]?Ой ", function (s)
		local t = {L"десятой", L"двадцатой", L"тридцатой", L"сороковой", L"пятидесятой", L"шестидесятой", L"семидесятой", L"восьмидесятой", L"девяностой"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])0[%- ]?Ы?й ", function (s)
		local t = {L"десятый", L"двадцатый", L"тридцатый", L"сороковой", L"пятидесятый", L"шестидесятый", L"семидесятый", L"восьмидесятый", L"девяностый"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])0[%- ]?О?е ", function (s)
		local t = {L"десятое", L"двадцатое", L"тридцатое", L"сороковое", L"пятидесятое", L"шестидесятое", L"семидесятое", L"восьмидесятое", L"девяностое"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])0[%- ]?Г?о ", function (s)
		local t = {L"десятого", L"двадцатого", L"тридцатого", L"сорокового", L"пятидесятого", L"шестидесятого", L"семидесятого", L"восьмидесятого", L"девяностого"}
		return L" "..t[tonumber(s)]..L" " end},
	{L" ([0-9])0[%- ]?Летия ", function (s)
		local t = {L"десяти", L"двадцати", L"тридцати", L"сорока", L"пятидесяти", L"шестидесяти", L"семидесяти", L"восьмидесяти", L"девяносто"}
		return L" "..t[tonumber(s)]..L"летия " end},
	{L" 1([0-9])[%- ]?А?я ", function (s) return L" |"..mapinfo_numbers[2][tonumber(s)]..L"надцатая| " end},
	{L" 1([0-9])[%- ]?Ой ", function (s) return L" |"..mapinfo_numbers[2][tonumber(s)]..L"надцатой| " end},
	{L" 1([0-9])[%- ]?Ы?й ", function (s) return L" |"..mapinfo_numbers[2][tonumber(s)]..L"надцатый| " end},
	{L" 1([0-9])[%- ]?О?е ", function (s) return L" |"..mapinfo_numbers[2][tonumber(s)]..L"надцатое| " end},
	{L" 1([0-9])[%- ]?Г?о ", function (s) return L" "..mapinfo_numbers[2][tonumber(s)]..L"надцатого " end},
	{L" 1([0-9])[%- ]?Летия ", function (s)
		local t = {L"одиннадцати", L"двенадцати", L"тринадцати", L"четырнадцати", L"пятнадцати", L"шестнадцати", L"семнадцати", L"восемнадцати", L"девятнадцати"}
		return L" "..t[tonumber(s)]..L"летия " end},
	{L" ([0-9])([0-9])[%- ]?[АЬ]?я ", function (s1,s2) return L" |"..mapinfo_numbers[3][tonumber(s1)]..L" "..s2..L"-я " end},
	{L" ([0-9])([0-9])[%- ]?[ОЕ]й ", function (s1,s2) return L" |"..mapinfo_numbers[3][tonumber(s1)]..L" "..s2..L"-Ой " end},
	{L" ([0-9])([0-9])[%- ]?[ЫИ]?й ", function (s1,s2) return L" |"..mapinfo_numbers[3][tonumber(s1)]..L" "..s2..L"-й " end},
	{L" ([0-9])([0-9])[%- ]?[ОЬ]?е ", function (s1,s2) return L" |"..mapinfo_numbers[3][tonumber(s1)]..L" "..s2..L"-е " end},
	{L" ([0-9])([0-9])[%- ]?Г?о ", function (s1,s2) return L" "..mapinfo_numbers[3][tonumber(s1)]..L" "..s2..L"-о " end},
	{L" ([0-9])([0-9])[%- ]?Летия ", function (s1,s2)
		local t = {L"", L"двадцати", L"тридцати", L"сорока", L"пятидесяти", L"шестидесяти", L"семидесяти", L"восьмидесяти", L"девяносто"}
		return L" "..t[tonumber(s1)]..L" "..s2..L"-Летия " end},
	{L" ([0-9])[%- ]?[АЬ]?я ", function (s)
		local t = {L"первая", L"вторая", L"третья", L"четвёртая", L"пятая", L"шестая", L"седьмая", L"восьмая", L"девятая"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])[%- ]?[ОЕ]й ", function (s)
		local t = {L"первой", L"второй", L"третьей", L"четвёртой", L"пятой", L"шестой", L"седьмой", L"восьмой", L"девятой"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])[%- ]?[ЫИ]?й ", function (s)
		local t = {L"первый", L"второй", L"третий", L"четвёртый", L"пятый", L"шестой", L"седьмой", L"восьмой", L"девятый"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])[%- ]?[ОЬ]?е ", function (s)
		local t = {L"первое", L"второе", L"третье", L"четвёртое", L"пятое", L"шестое", L"седьмое", L"восьмое", L"девятое"}
		return L" |"..t[tonumber(s)]..L"| " end},
	{L" ([0-9])[%- ]?Г?о ", function (s)
		local t = {L"первого", L"второго", L"третьего", L"четвёртого", L"пятого", L"шестого", L"седьмого", L"восьмого", L"девятого"}
		return L" "..t[tonumber(s)]..L" " end},
	{L" ([0-9])[%- ]?Летия ", function (s)
		local t = {L"одно", L"двух", L"трёх", L"четырёх", L"пяти", L"шести", L"семи", L"восьми", L"девяти"}
		return L" "..t[tonumber(s)]..L"летия " end},

	{L"^||(.*)",function (s) return wstring.gsub(s, L"|", L"") end},
	{L"|(.*)|", function (s) return L"|"..wstring.gsub(s, L"|",L"")..L"|" end},
}

VOICE["replace_mapinfo_end" .. mother_country] = {
	{L" +м[%. ]+(.* +Улица) +",L" Малка %1 "},
	{L" +г[%. ]+(.* +Улица) +",L" Голяма %1 "},
	{L" +м[%. ]+(.* +Странична улица) +",L" Голяма %1 "},
	{L" +г[%. ]+(.* +Странична улица) +",L" Голяма %1 "},
	{L" +м[%. ]+(.* +Път без изход) +",L" Малък %1 "},
	{L" +г[%. ]+(.* +Път без изход) +",L" Голям %1 "},
	{L" +м[%. ]+(.* +Кръстовище) +",L" Малко %1 "},
	{L" +г[%. ]+(.* +Кръстовище) +",L" Голямо %1 "},
	{L" +г[%. ]+(.* +Улица) +",L" Горна %1 "},
	{L" +д[%. ]+(.* +Улица) +",L" Долна %1 "},
	{L" +г[%. ]+(.* +Странична улица) +",L" Горна %1 "},
	{L" +д[%. ]+(.* +Странична улица) +",L" Долна %1 "},
	{L" +г[%. ]+(.* +Кръстовище) +",L" Горно %1 "},
	{L" +д[%. ]+(.* +Кръстовище) +",L" Долно %1 "},
-- Думите „голям“, „малък“ и др. се преместват в началото на реда: "1-ва голяма улица" -> "голяма първа улица"
	{L"(.*) +(Голям) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Голяма) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Голямо) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Голями) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Малък) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Малка) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Малко) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Малки) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Горен) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Горна) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Горно) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Горни) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Долен) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Долна) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Долно) +(.*)",L" %2 %1 %3 "},
	{L"(.*) +(Долни) +(.*)",L" %2 %1 %3 "},
-- Думите "първи", "втори" и т.н. се преместват в началото на реда: "българска 1-ва улица" -> "първата българска улица", "улица българска 1-ва" -> "първа улица българска"
	{L"(.*)|(.*)|(.*)",L" %2 %1 %3 "},
	{L" (%S)%.", function (s) if smart_lower_case_get_codegroup(wstring.byte(s,1)) then return L" " end return L" "..s..L". " end},
	{L"^([A-Z])([A-Z])[ ?]*([0-9]+)",L"%1.%2. %3"},
	{L"%-([0-9]+)",L" %1"},
	{L"([0-9])([a-zA-Z])",L"%1 %2"},
	{L"([a-zA-Z])([0-9])",L"%1 %2"},
	{L"//",L", "},
	{L" +",L" "},
	{L"^ ",L""},
	{L" $",L""},
}

VOICE["replace_mapinfo_inner" .. mother_country] = {}

VOICE["replace_mapinfo_inner2" .. mother_country] = {}

VOICE["match_inner" .. mother_country] = {}

VOICE["replace_tmc_description" .. mother_country] = {}

local replace_for_turns = {
	{L"(.*)",L" %1 "},
}

local replace_for_turns_end = {
	{L" +",L" "},
	{L"^ ",L""},
	{L" $",L""},
}

local replace_for_turns_inner = {
	{L"^ +Черен Път +$",L" Черения Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежието %1 "},
	{L"(.*) Кръстовище ",L" Кръстовището %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
}

local replace_for_turns_inner2 = {
	{L"(.*) Алея ",L" Алея %1 "},
	{L"(.*) Булевард ",L" Булевард %1 "},
	{L"(.*) Изход ",L" Изход %1 "},
	{L"(.*) Вход ",L" Вход %1 "},
	{L"(.*) Микрорайон ",L" Микрорайон %1 "},
	{L"(.*) Прелез ",L" Прелез %1 "},
	{L"(.*) Странична улица ",L" Странична улица %1 "},
	{L"(.*) Площад ",L" Площад %1 "},
	{L"(.*) Авеню ",L" Авеню %1 "},
	{L"(.*) Вилна зона ",L" Вилна зона %1 "},
	{L"(.*) Спускане ",L" Спускане %1 "},
	{L"(.*) Трасе ",L" Трасе %1 "},
	{L"(.*) Път без изход ",L" Път без изход %1 "},
	{L"(.*) Улица ",L" Улица %1 "},
	{L"^ +Околовръстно Шосе +$",L" Околовръстно Шосе "},
}

VOICE["replace_cities_for_turns" .. mother_country] = {
	{L"^(%S+)ая$", L"%1ую"},
	{L"^(%S+)яя$", L"%1юю"},
	{L"^(%S+)а$", L"%1у"},
	{L"^(%S+)я$", L"%1ю"},
	{L"^Белая Калитва$", L"Белую Калитву"},
}

local replace_for_directions_inner = {
	{L"^ +Черен Път +$",L" Черения Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежието %1 "},
	{L"(.*) Кръстовище ",L" Кръстовището %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
}

local replace_for_directions_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична Улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Вилна зона ",L" Вилната Зона %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя без изход %1 "},
	{L"(.*) Улица ",L" Улицата Ветрен %1 "},
	{L"^ +(%S+)о +Кръгово +$", L" %1то Кръгово "},
	{L"^ +(%S+)о +(%S+)о +Кръгово +$", L" %1то %2то Кръгово "},
	{L"^ +Околовръстно Шосе +$",L" Околовръстното Шосе "},
	{L"^ +[Тт]рето (.*)",L" Третото %1 "},
}

local replace_for_traffic_fromto_inner = {
	{L"^ +Черен Път +$",L" Черения Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежието %1 "},
	{L"(.*) Кръстовище ",L" Кръстовището %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
}

local replace_for_traffic_fromto_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Вилна зона ",L" Вилната Зона %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя Без Изход %1 "},
	{L"(.*) Улица ",L" Улицата %1 "},
	{L"^ +(%S+)о +Кръгово +$", L" %1то Кръгово "},
	{L"^ +(%S+)о +(%S+)о +Кръгово +$", L" %1то %2то Кръгово "},
	{L"^ +Околовръстно Шосе +$",L" Околовръстното Шосе "},
	{L"^ +[Тт]рето (.*)",L" Третото %1 "},
}

local replace_for_traffic_on_inner = {
	{L"^ +Черен Път +$",L" Черния Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежието %1 "},
	{L"(.*) Кръстовище ",L" Кръстовището %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
}

local replace_for_traffic_on_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична Улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Вилна зона ",L" Вилната Зона %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя без изход %1 "},
	{L"(.*) Улица ",L" Улицата %1 "},
	{L"^ +(%S+)о +Кръгово +$", L" %1то Кръгово "},
	{L"^ +(%S+)о +(%S+)о +Кръгово +$", L" %1то %2то Кръгово "},
	{L"^ +Околовръстно Шосе +$",L" Околовръстното Шосе "},
	{L"^ +[Тт]рети (.*)",L" Третият %1 "},
}

local replace_for_summary_inner = {
	{L"(.*) Път ",L" Път %1 "},
	{L"(.*) Мост ",L" Мост %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежие %1 "},
	{L"(.*) Кръстовище ",L" Кръстовище %1 "},
	{L"(.*) Станция ",L" Станция %1 "},
}

local replace_for_summary_inner2 = {
	{L"(.*) Алея ",L" Алея %1 "},
	{L"(.*) Булевард ",L" Булевард %1 "},
	{L"(.*) Изход ",L" Изход %1 "},
	{L"(.*) Вход ",L" Вход %1 "},
	{L"(.*) Микрорайон ",L" Микрорайон %1 "},
	{L"(.*) Прелез ",L" Прелез %1 "},
	{L"(.*) Странична улица ",L" Странична улица %1 "},
	{L"(.*) Площад ",L" Площад %1 "},
	{L"(.*) Авеню ",L" Авеню %1 "},
	{L"(.*) Вилна зона ",L" Вилна зона %1 "},
	{L"(.*) Спускане ",L" Спускане %1 "},
	{L"(.*) Трасе ",L" Трасе %1 "},
	{L"(.*) Път без изход ",L" Път без изход %1 "},
	{L"(.*) Улица ",L" Улица %1 "},
}

local replace_sentence={
    {L"/",L" , "},
	{L" +",L" "},
	{L" след това ",L" , след това "},
	{L" там ",L" , там "},
}

local function get_preposition(str, tbl)
	for k,value in ipairs(tbl) do
		for _,pattern in ipairs(tbl[k][2]) do
			if wstring.find(str,pattern) then
				return tbl[k][1]
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
----------------------------------------|  РЪКОВОДСТВО  |---------------------------------------
----------------------------------------------------------------------------------------------------

local function not_settlement(str, direction)
	if transform_pattern_match(str,preposition_tbl) then return L"" end
        return get_preposition(str, direction and preposition_insert_tbl_direction or preposition_insert_tbl)
end

local function wlocalize_table(tname,tcountry)
	if tcountry == mother_country then return VOICE[tname .. mother_country] end
	local localized = ""
	for _,v in pairs(wlocalized.countries) do
		if v == tcountry then localized = v break end
	end
	local need_load = localized ~= ""
	if need_load then need_load = not wlocalized["loaded"..localized] end
	if need_load then pcall(dofile, L"%app%/config/config_transforms"..towstring(localized)..L".lua") end
	if type(VOICE[tname .. localized]) ~= "table" then localized = mother_country end
	return VOICE[tname .. localized]
end

local function check_unknown_country(country)
	if country == nil then
		MODEL.other.country_info.select_country_by_pos(MODEL.navigation.car.position())
		local countryindex = MODEL.other.country_info.list.index()
		if countryindex ~= nil then
			country = MODEL.other.country_info.list[countryindex].name()
		end
	end
	return string.lower(country)
end

local function format_mapinfo(str, country, roadnumber_name)
	country = check_unknown_country(country)
	str = smart_lower_case(str)
	if roadnumber_name then str = transform_and_format(str, wlocalize_table("replace_mapinfo_roadnumber_name",country)) end
	local replace_mapinfo_inner_need = transform_pattern_match(str..L" ",wlocalize_table("match_inner",country))
	str = transform_and_format(transform_and_format(transform_and_format(str, wlocalize_table("replace_mapinfo",country)), replace_mapinfo_inner_need and wlocalize_table("replace_mapinfo_inner",country)), wlocalize_table("replace_mapinfo_inner2",country))
	local replace_mapinfo_numbers_need = wstring.find(str,L"[0-9]")
	return transform_and_format(transform_and_format(str, replace_mapinfo_numbers_need and wlocalize_table("replace_mapinfo_numbers",country)), wlocalize_table("replace_mapinfo_end",country))
end

local function format_roadnumber(number, country)
	country = check_unknown_country(country)
	local str = transform_format_roadnumber_eu(transform_and_format(number, replace_roadnumber_prepare))
	local need2text = roadnumber_mode
	if VOICE["replace_roadnumber" .. mother_country] == wlocalize_table("replace_roadnumber",country) and need2text then need2text = country == mother_country end
	local str1 = transform_and_format(str, need2text and wlocalize_table("replace_roadnumber",country))
	if str1 == str then
		str1 = wstring.gsub(str1,L"E +",L"Е ")
		str1 = wstring.gsub(str1,L",",L" , ")
	elseif wstring.find(number,L"/") then
		str1 = wstring.gsub(str1,L"(.*),(.*)",L"%1")
	end
	return format_all_numbers2text(str1)
end

local function format_cases(str, case, mapinfo)
	local str_input = str
	str=transform_and_format(str, replace_for_turns)
	local t_inner = replace_for_turns_inner
	local t_inner2 = replace_for_turns_inner2
	if case == "for_directions" then
		t_inner = replace_for_directions_inner
		t_inner2 = replace_for_directions_inner2
	elseif case == "for_summary" then
		t_inner = replace_for_summary_inner
		t_inner2 = replace_for_summary_inner2
	elseif case == "for_traffic_on" then
		t_inner = replace_for_traffic_on_inner
		t_inner2 = replace_for_traffic_on_inner2
	elseif case == "for_traffic_fromto" then
		t_inner = replace_for_traffic_fromto_inner
		t_inner2 = replace_for_traffic_fromto_inner2
	end
	if not transform_pattern_match(str, main_streetnames) then str = transform_and_format(str, t_inner) end
	local matched = 0
	for _,v in ipairs(main_streetnames) do
		if wstring.find(str,v) then wstring.gsub(str, v, function() matched = matched + 1 end) end
	end
	if matched < 2 then str = transform_and_format(str, t_inner2) end
	str = transform_and_format(str, replace_for_turns_end)
	if wstring.find(str,L"[0-9]$") then str = format_all_numbers2text(str) end
	if mapinfo == nil or str == L"" or case == "for_summary" or case == "for_traffic_fromto" then
		return str
	else
		return not_settlement(str_input, case == "for_directions") .. str
	end
end

function format_tmc_description(str, country)
	country = check_unknown_country(country)
	local announce = SysConfig:get("tts", "announce_speed_unit", true)
	local wtmc_units = {"km/h", "mph"}
	str = transform_and_format(str, wlocalize_table("replace_tmc_description",country))
	for _,v in pairs(wtmc_units) do
		local value = announce and (MODEL.regional.is_it_voice_localizable(m_i18n_voice(v)) and translate_voice(v) or translate(v)) or L""
		str = wstring.gsub(str, L"([0-9]+) -"..translate(v),L"%1 "..value)
	end
	return str
end

local function signpost_exit(data, idx)
	local exitnumber = data[idx].signpost.exitnumber
	local exitname = data[idx].signpost.exitname
	local strnumber, strname = L"", L""
	local preposition_name = true
	if exitnumber then
		strnumber = wstring.gsub(exitnumber.text,L"([0-9]+)",L"%1 ")
		strnumber = format_all_numbers2text(strnumber)
		preposition_name = nil
	end
	if exitname then
		strname=exitname.text
		voice_debug_log(L"TTS: signpost_exitname in: '"..strname..L"'", 3)
		strname = format_cases(format_mapinfo(strname, data[idx].signpost.country), "for_turns", preposition_name)
		voice_debug_log(L"TTS: signpost_exitname out: '"..strname..L"'", 3)
	end
	if exitnumber or exitname then
		return exit_preposition .. L" " .. strnumber .. (exitnumber and exitname and L"/" or L"") .. strname
	end
end

local function signpost_destination(data, idx)
	local dest
	if not ( data[idx].signpost and data[idx].road ) then return end
	if data[idx].signpost.destination and wstring.find( data[idx].signpost.destination.text, L"[A-z]" ) and data[idx].road then
		dest = data[idx].road.name --amk data[idx].signpost.destination
	else
		dest = data[idx].signpost.destination
	end
	if dest then
		local str=dest.text
		voice_debug_log(L"TTS: signpost_destination in: '"..str..L"'", 3)
		str = format_cases(transform_and_format(format_mapinfo(str, data[idx].signpost.country), wlocalize_table("replace_cities_for_turns",check_unknown_country(data[idx].signpost.country))), "for_turns", true)
		voice_debug_log(L"TTS: signpost_destination out: '"..str..L"'", 3)
		return str
	end
end

local function signpost_settlement(data, idx) 			--  в "напрвление" където е символът '>>'
	local settlement = data[idx].signpost.settlement
	if settlement then
		local str=settlement.text
		voice_debug_log(L"TTS: signpost_settlement in: '"..str..L"'", 3)
		str = format_cases(transform_and_format(format_mapinfo(str, data[idx].signpost.country),wlocalize_table("replace_cities_for_turns",check_unknown_country(data[idx].signpost.country))), "for_turns")
		if not wstring.find(settlement.text,settlement_preposition) then
			str=settlement_preposition .. L" " .. str
		end
		voice_debug_log(L"TTS: signpost_settlement out: '"..str..L"'", 3)
		return str
	end
end

local function signpost_roadnumber(data, idx)    		--  име на трасето M1 ... Mx
	local roadnumber = data[idx].signpost.roadnumber
	if roadnumber then
		local str=roadnumber.text
		voice_debug_log(L"TTS: signpost_roadnumber in: '"..str..L"'", 3)
		str = format_cases(format_roadnumber(str, data[idx].signpost.country), "for_turns", true)
		voice_debug_log(L"TTS: signpost_roadnumber out: '"..str..L"'", 3)
		return str
	end
end

local function road_number_name(data, idx)
	local number = data[idx].road.number
	local name = data[idx].road.name
	local country = data[idx].road.country
	local road_changed, strnumber, strname
	local t_for_turns = "for_turns"
	if number then road_changed = number.change
	elseif name then road_changed = name.change end
	if not use_dativ_for_sameroad then
	elseif road_changed ~= nil then t_for_turns = not road_changed and "for_directions" or "for_turns"
	elseif idx == 1 then t_for_turns = wsameroadname and "for_directions" or "for_turns"
	elseif idx == 2 then
		t_for_turns = check_same_maneuvers_done(data, idx, wprevroadtable) and "for_directions" or "for_turns"
		local match = t_for_turns == "for_directions" and L"same" or L"other"
		local str = get_full_roadname(data[idx].road)
		voice_debug_log(L"TTS: sameroadname then: " .. match .. L" road'"..str..L"'", 3)
	end
	if number and name then
		strnumber=number.text
		strname=name.text
		voice_debug_log(L"TTS: road_number in: '"..strnumber..L"'", 3)
		voice_debug_log(L"TTS: road_name in: '"..strname..L"'", 3)
		strnumber = format_cases(format_roadnumber(strnumber, country), t_for_turns, true)
		strname = format_cases(format_mapinfo(strname, country, true), t_for_turns)
		voice_debug_log(L"TTS: road_number out: '"..strnumber..L"'", 3)
		voice_debug_log(L"TTS: road_name out: '"..strname..L"'", 3)
		return strnumber .. L"/" .. strname
	elseif number then
		strnumber=number.text
		voice_debug_log(L"TTS: road_number in: '"..strnumber..L"'", 3)
		strnumber = format_cases(format_roadnumber(strnumber, country), t_for_turns, true)
		voice_debug_log(L"TTS: road_number out: '"..strnumber..L"'", 3)
		return strnumber
	elseif name then
		strname=name.text
		voice_debug_log(L"TTS: road_name in: '"..strname..L"'", 3)
		strname = format_cases(format_mapinfo(strname, country, true), t_for_turns, true)
		voice_debug_log(L"TTS: road_name out: '"..strname..L"'", 3)
		return strname
	end
end

function format_destname(data, idx)
	local t
	if data[idx].signpost then
		t = transform_chain({}, signpost_exit, 	data, idx)
		t = transform_chain(t,  signpost_roadnumber,data, idx)
		t = transform_chain(t,  signpost_destination,	data, idx)
		t = transform_chain(t,  signpost_settlement, 	data, idx)
	elseif data[idx].road then
		t = transform_chain({}, road_number_name, 	data, idx)
	end
	return table_concat(t, L"/")
end

function format_streetname(data, idx)
	local t = {}
	if data[idx].road then t = transform_chain({}, road_number_name, data, idx) end
	return table_concat(t, L"/")
end

function format_sentence(str)
	for key, value in ipairs(replace_sentence) do
		str = wstring.gsub(str,value[1],value[2])
	end
	return str
end

local function format_replace_shield(str)
	for i=4190, 4200 do
		str = wstring.gsub(str, wstring.char(i),L"|")
	end
	str = wstring.gsub(str, wstring.char(4244),L"|")
	str = wstring.gsub(str, wstring.char(4255),L"|")
	str = wstring.gsub(str, L"|(.*)|",L"")
	return wstring.gsub(str, L"|",L"")
end

function format_street_name(streetname)
	voice_debug_log(L"TTS: streetname from skin in: '"..streetname..L"'", 3)
	streetname = format_replace_shield(streetname)
	if wstring.sub(streetname, 1, 9) == L"for_turns" then
		local no_settlement = true
		local sett_preposition = L""
		streetname = wstring.sub(streetname, 10)
		if wstring.find(streetname, wstring.char(187)) then
			no_settlement = nil
			sett_preposition = settlement_preposition .. L" "
			streetname = wstring.gsub(streetname, wstring.char(187),L"")
		end
		streetname = wstring.gsub(streetname, L",", L"/")
		local t = {}
		if wstring.find(streetname, L"/") then
			wstring.gsub(streetname, L"([^/]+)/?", function(s) if s~=L"" then table.insert(t, s) end end)
			if #t then streetname = t[1] end
		end
		streetname = format_mapinfo(streetname)
		local matched = 0
		for _,v in ipairs(main_streetnames) do
			streetname = wstring.gsub(streetname, v,  function()
				matched = matched + 1
				if matched > 1 then return L"/"..v
				else return v end
			end)
		end
		t = {}
		if wstring.find(streetname, L"/") then
			wstring.gsub(streetname, L"([^/]+)/?", function(s) if s~=L"" then table.insert(t, s) end end)
			if #t then streetname = t[1] end
		end
		streetname = sett_preposition .. format_cases(streetname, "for_turns", no_settlement)
	else
		streetname = format_cases(format_mapinfo(streetname), "for_summary")
	end
	voice_debug_log(L"TTS: streetname from skin out: '"..streetname..L"'", 3)
	return streetname
end

function format_waypointname(data, idx)
        local str = L""
	if announce_waypointname and waypointname ~= L"" and idx == 1 then
		str = format_replace_shield(waypointname)
		voice_debug_log(L"TTS: waypointname in: '"..str..L"'", 3)
		str = wstring.gsub(str, L"([0-9]+)(%S)[ +]?$", function (s1,s2)
			if smart_lower_case_get_codegroup(wstring.byte(s2,1)) > 2 then return s1..wstring.char(2200)..s2 end
			return s1..s2 end)
	        local m_sign = wstring.char(215)
		local t = {}
		if wstring.find(str, m_sign) then
			wstring.gsub(str, L"([^"..m_sign..L"]+)"..m_sign..L"?", function(s) if wstring.gsub(s,L" ",L"")~=L"" then table.insert(t, transform_and_format(s, replace_for_turns_end)) end end)
			for k,v in ipairs(t) do t[k] = format_cases(format_mapinfo(v), "for_traffic_fromto") end
		end
		if #t > 1 then str = L" кръстовището " .. table_concat(t, L" и ")
		else str = format_cases(format_mapinfo(str), "for_summary") end
		str = wstring.gsub(str, wstring.char(2200), L" ")
		voice_debug_log(L"TTS: waypointname out: '"..str..L"'", 3)
	end
	return str
end

local transform_roadnumber_explode_eu_origvoice = transform_roadnumber_explode_eu
transform_roadnumber_explode_eu = function(str)
	local t = transform_roadnumber_explode_eu_origvoice(str)
	for k in ipairs(t) do
		if t[k+1] and wstring.gsub(t[k], L" ", L"") == wstring.gsub(t[k+1], L" ", L"") then
			table.remove(t, k+1)
		end
	end
	return t
end

----------------------------------------------------------------------------------------------------
-----------------------------------|  РЕЗЮМЕ НА МАРШРУТА  |----------------------------------
----------------------------------------------------------------------------------------------------

function route_summary_format_road_name(data)
        local str = data.text
	voice_debug_log(L"TTS: summary roadnumber in: '"..str..L"'", 3)
	str = format_roadnumber(str,"")
	voice_debug_log(L"TTS: summary roadnumber out: '"..str..L"'", 3)
	return str
end

function route_summary_format_street_name(data)
        local str = data.text
	voice_debug_log(L"TTS: summary streetname in: '"..str..L"'", 3)
	str = format_cases(format_mapinfo(str), "for_summary")
	voice_debug_log(L"TTS: summary streetname out: '"..str..L"'", 3)
	return str
end

function route_summary_format_bridge_tunnel(data)
        local str = data.text
	voice_debug_log(L"TTS: summary bridge_tunnel in: '"..str..L"'", 3)
	str = format_cases(format_mapinfo(str), "for_summary")
	voice_debug_log(L"TTS: summary bridge_tunnel out: '"..str..L"'", 3)
	return str
end

function route_summary_format_order(data)
        local str = data.text
	voice_debug_log(L"TTS: summary order in: '"..str..L"'", 3)
	str = format_cases(format_mapinfo(str), "for_summary")
	voice_debug_log(L"TTS: summary order out: '"..str..L"'", 3)
	return str
end

----------------------------------------------------------------------------------------------------
local function format_string2unicode(str)
	if not SysConfig:get("tts", "voice_log_to_unicode_chars", 0) then return str end
	local out, uni_code, repl_str
	out = L""
	for i = 1, #str do
		uni_code = wstring.byte(str, i)
		if uni_code >= 1025 and uni_code <= 1111 then repl_str = L"|"..wstring.sub(towstring(uni_code),2,4)
		else repl_str = wstring.sub(str,i,i) end
		out = out .. repl_str
	end
	return out
end

local voice_debug_log_origvoice = voice_debug_log
voice_debug_log = function(message, level)
	message = format_string2unicode(towstring(message))
	voice_debug_log_origvoice(message, level)
end

function smart_lower_case_get_codegroup(s)
	return s>=65 and s<=90 and 1 or (s>=97 and s<=122 and 2 or (s>=1040 and s<=1071 and 3 or (s>=1072 and s<=1103 and 4 or (s>=1025 and s<=1031 and 5 or (s>=1105 and s<=1111 and 6 or 0)))))
end

function smart_lower_case_inner1(s1, s3)
	local s2 = smart_lower_case_get_codegroup(wstring.byte(s1,1)) and (smart_lower_case_get_codegroup(wstring.byte(s3,1)) or wstring.byte(s3,1) == 32) and L"ь" or L"`"
	return s1..s2..s3
end

function smart_lower_case_inner2(s1, s3)
	local s2 = smart_lower_case_get_codegroup(wstring.byte(s1,1)) and (smart_lower_case_get_codegroup(wstring.byte(s3,1)) or wstring.byte(s3,1) == 32) and L"ъ" or L"'"
	return s1..s2..s3
end

function smart_lower_case_inner3(s1,s2,s3)
	local upper_shift = {0,-32,0,-32,0,-80}
	local lower_shift = {32,0,32,0,80,0}
	local shift, group1, group2, group3 = 0, smart_lower_case_get_codegroup(s1), smart_lower_case_get_codegroup(s2), smart_lower_case_get_codegroup(s3)
	if group2 then
		if not group1 and not group3 or group1 then shift = lower_shift[group2] end
		if not group1 and group3 then shift = upper_shift[group2] end
	end
	return wstring.char(s2+shift)
end

function smart_lower_case(str)
	str = wstring.gsub(str, wstring.char(4244),L" ")
	str = wstring.gsub(str, wstring.char(4255),L" ")
	str = L" " .. format_sentence(str) .. L" "
	str = wstring.gsub(str, L" [`'](%S+)[`'] ", L" %1 ")
	str = wstring.gsub(str, L"(%S)`(.*)", smart_lower_case_inner1)
	str = wstring.gsub(str, L"(%S)'(.*)",  smart_lower_case_inner2)
	local out = L" "
	for i = 2, #str-1 do
		out = out .. smart_lower_case_inner3(wstring.byte(str,i-1),wstring.byte(str,i),wstring.byte(str,i+1))
	end
	return out .. L" "
end

----------------------------------------------------------------------------------------------------
-----------------------------------------|  ТРАФИК  |----------------------------------------
----------------------------------------------------------------------------------------------------

-- 1. Zar az M0 uton, Martonvasar kozeleben. = in die Strasse Numer A1, in der Nahe von Martonvasar./ in der Nahe von der HaupStrasse Numer 33.
-- 2. Zar az M0 uton, Martonvasar es Velence kozt. = in die Strasse Numer A1, zwischen Martonvasar und Velence.
-- 3. Zar a Budai uton, a Budai ut Fiskalis ut keresztezodesben = in der/dem (lsd tabla) Budai ut, in der Kreuzung Budai ut und Fiskalis ut.
-- 4. Zar a Budai uton, Fiskalis ut es 8. ut kozott. = in der/dem Budai ut, zwischen Fiskalis ut und 8. ut.

function traffic_event_supported()
	return true
end

local function traffic_fromto_format_func(str)
	return wstring.gsub(str,L"^ ?(%S) ?[0-9]+$",
		function (s)
			if smart_lower_case_get_codegroup(wstring.byte(s,1)) then return L"" else return s end
		end) == L"" and format_roadnumber or format_mapinfo
end

local function transform_traffic_fromto(fromto, str, roadname)
	local t = {}
	wstring.gsub(str, L"([^,]+),?", function(s) if s~=L"" then table.insert(t, transform_and_format(s, replace_for_turns_end)) end end)
	for k in ipairs(t) do
		if roadname~=L"" and t[k+1] and (wstring.find(roadname, t[k+1]) or roadname==t[k+1]) then table.remove(t, k+1) end
	end
	if roadname~=L"" and (wstring.find(roadname, t[1]) or roadname==t[1]) then table.remove(t, 1) end
	if #t then
		str = t[1]
		if wstring.find(str, L"/") then
			t = {}
			wstring.gsub(str, L"([^/]+)/?", function(s) if s~=L"" then table.insert(t, transform_and_format(s, replace_for_turns_end)) end end)
			local str_format_function, str_is_number = nil, false
			for k,v in ipairs(t) do
				str_format_function = traffic_fromto_format_func(v)
				if str_format_function == format_roadnumber then str_is_number = true end
				t[k] = format_cases(str_format_function(v), "for_traffic_fromto")
			end
			if str_is_number then
				for k in ipairs(t) do
					if t[k+1] and wstring.gsub(t[k], L" ", L"") == wstring.gsub(t[k+1], L" ", L"") then table.remove(t, k+1) end
				end
			end
			return fromto .. (#t > 1 and L" кръстовището " or L" ") .. table_concat(t, L" и ")
		else
			return fromto .. L" " .. format_cases(traffic_fromto_format_func(str)(str), "for_traffic_fromto")
		end
	end
	return L""
end

local function traffic_event_distance_get(dist)
	local unit_names = {"yards","meters","feet"}
	dist_table = distances[unit_names[MODEL.regional.units() + 1]]
	local _, _, f_dist = distance_formatter(dist)
	local dist_idx = search_distance_index(f_dist)
	local code_string
	if f_dist == dist_table[dist_idx] then code_string = dist_table[dist_idx + 1]
	else code_string = dist_table[search_distance_index(dist) + 1] end
	return decode_string(code_string, 1)
end

function traffic_event(DescKey, data)
	ASSERT(MODEL.regional.is_it_voice_localizable(DescKey), "Missing TrafficEvent dictionary.voice key:" .. DescKey)
	local traffic_on, traffic_roadnumber, traffic_roadname, traffic_from, traffic_to, voice_from, voice_to = L"", L"", L"", L"", L"", L"", L""
	if data.roadnumber then
		traffic_roadnumber = data.roadnumber.text
		voice_debug_log(L"TTS: traffic on roadnumber in: '"..traffic_roadnumber..L"'", 3)
		traffic_on = format_cases(format_roadnumber(traffic_roadnumber), "for_traffic_on",true)
		voice_debug_log(L"TTS: traffic on roadnumber out: '"..traffic_on..L"'", 3)
	end
	if data.roadname then
		local roadnumber_nonexist = true
		if traffic_on ~= L"" then traffic_on = traffic_on .. L"/" roadnumber_nonexist = nil end
		traffic_roadname = data.roadname.text
		voice_debug_log(L"TTS: traffic on roadname in: '"..traffic_roadname..L"'", 3)
		if wstring.find(traffic_roadname, L"/") then
			local t = {}
			wstring.gsub(traffic_roadname, L"([^/]+)/?", function(s) if s~=L"" then table.insert(t, transform_and_format(s, replace_for_turns_end)) end end)
			if #t then traffic_on = traffic_on .. format_cases(format_mapinfo(t[1]), "for_traffic_on", roadnumber_nonexist) end
			if #t>1 then traffic_on =  traffic_on .. L" в районе " .. format_cases(format_mapinfo(t[2]), "for_traffic_fromto") end
		else
			traffic_on = traffic_on .. format_cases(format_mapinfo(traffic_roadname), "for_traffic_on", roadnumber_nonexist)
		end
		voice_debug_log(L"TTS: traffic on roadname out: '"..traffic_on..L"'", 3)
	end
	if data.roadname then traffic_roadname = data.roadname.text end
	if traffic_on ~= L"" then traffic_on = L" " .. traffic_on end
	if data.from then
		voice_from = data.from.text
		voice_debug_log(L"TTS: traffic from in: '"..voice_from..L"'", 3)
		traffic_from = transform_traffic_fromto((data.to and L" , от" or L" , около"), voice_from, traffic_roadname)
		voice_debug_log(L"TTS: traffic from out: '"..traffic_from..L"'", 3)
	end
	if data.to then
		voice_to = data.to.text
		voice_debug_log(L"TTS: traffic to in: '"..voice_to..L"'", 3)
		traffic_to = transform_traffic_fromto(L" , до", voice_to, traffic_roadname)
		voice_debug_log(L"TTS: traffic to out: '"..traffic_to..L"'", 3)
	end
	local traffic_description, traffic_distance = translate_voice(DescKey), L""
	local traffic_description_on = traffic_events_description and MODEL.regional.current_language.lcid() == MODEL.regional.current_voice.lcid()
	if traffic_description_on then traffic_description_on = transform_pattern_match(towstring(DescKey), {L"ahead", L"blocked"}) end
	if (traffic_description_on or traffic_events_distance) and (data.roadnumber or data.roadname or data.from or data.to) then
		local current
		for i = 0, #MODEL.traffic.events.significant_events - 1 do
			current = MODEL.traffic.events.significant_events[i]
			local roadnumber_str = current.roadnumber_enc()
			if roadnumber_str ~= L"" and roadnumber_str ~= nil then roadnumber_str = wstring.gsub(L" "..roadnumber_str..L" ", L"(.*)([a-zA-Z]+)[%- ]?([0-9]+)(.*)",L"%2%3")
			else roadnumber_str = L"" end
			if traffic_roadnumber == roadnumber_str and traffic_roadname == current.road_name() and voice_to == current.location_to() and voice_from == current.location_from() then
				if current.description() ~= L"" and traffic_description_on then traffic_description = format_tmc_description(current.description()) voice_debug_log(L"TTS: traffic description out: '"..traffic_description..L"'", 3) end
				if current.distance() and traffic_events_distance then traffic_distance = translated_voice_format(m_i18n_voice("After %s"), traffic_event_distance_get(current.distance())) ..  L" " end
				break
			end
			if i>30 then break end
		end
	end
	return format_sentence(traffic_distance .. traffic_description .. traffic_on .. traffic_from .. traffic_to)
end

----------------------------------------------------------------------------------------------------
---------------------------------------------|  E T A  |--------------------------------------------
----------------------------------------------------------------------------------------------------
function format_all_numbers2text(str,spell)
	return wstring.gsub(str, L"([0-9]+)", function(s)
		local inner = L""
		if #s > 3 or wstring.find(s, L"^0") or spell then
			for i = 1, #s do inner = inner .. format_numbers2text(tonumber(wstring.sub(s, i, i))) end
		else inner = format_numbers2text(tonumber(s)) end
		return inner .. L" "
	end)
end

function format_numbers2text(number)
	local index = {{39,9,43,49,33,53,37,4,13},
		{14,8,42,38,32,52,36,3,12},
		{25,5,40,47,30,50,34,1,10,14,26,7,41,48,31,51,35,2,11}}
	local str = towstring(number)
	if #str > 3 then return L" " .. str end
	if str == L"0" then return L" нула" end
	local t = {}
	local out = L""
	for i = 1, #str do
		table.insert(t, tonumber(wstring.sub(str, i, i)))
	end
	for i = 1, (3 - #str)  do
		table.insert(t, 1, 0)
	end
	if (10 * t[2] + t[3]) < 20 then
		t[3] = 10 * t[2] + t[3]
		t[2] = 0
	end
	for i = 1, #t do
		if t[i] then
			out = out .. L" " .. distances.patterns[index[i][t[i]]]
		end
	end
	return out
end

function eta(time,waypoint,currenttime)
	local head = currenttime and L"Сега е " or (waypoint and L" Надявам се да пристигнем в спирката във ") or L" Надявам се да пристигнем в дестинацията във "
	local hours, mins, tod = L"", L"", L""
	local hour = time.hour
	local min = time.min
	if hour == 0 then hour = 12 tod = L" - през нощта" end
	if hour == 1 then hours = L" час"
	else hours = format_numbers2text(hour) end
	if min == 0 then mins = L""
	elseif min < 10 then mins = L" нула" .. format_numbers2text(min)
	else mins = format_numbers2text(min) end
	if min == 0 and tod == L"" then mins = L" нула нула" end
-- Беше return head..hours..mins..tod -- Стана 01.11.19 от nik4m за правилно произношение на времето в TTS от Wiman
	return head..(currenttime and L" " or L" в ")..hours..mins..tod
end

--- Вложка за скиновете на VICEWANDEL и Pongo - произнасяне на времето ---
--- Редактирано от VICEWANDEL 14.01.2020 ---
local time_patternts = {L" една", L" две"}

function format_timeto(timeto)
	local hour, min
	if type(timeto) == "wstring" then
		local hour_ = wstring.sub(timeto,1,-4)
		local min_  = wstring.sub(timeto,-2,-1)
		hour = tonumber(hour_)
		min = tonumber(min_)
	else
		local _, _, hour_, min_ = wstring.find(Format_Timespan(timeto, ETimespanFormat.HrMinRounded), L"(%d+):(%d+)")
		hour, min = tonumber(hour_), tonumber(min_)
end

local function time_to_phrase(number, hm)
	local sentence = L""
	if number ~= 0 then
		local number_10 = number % 10
		if number_10 == 1 and number ~= 11 then
			sentence = hm == "h" and L" часа " or L" минута "
		elseif number_10 > 4 or number_10 == 0 or (number > 10 and number < 20) then
			sentence = hm == "h" and L" часа " or L" минути "
		else
			sentence = hm == "h" and L" часа " or L" минути "
		end
		sentence = (((hm=="m")
			and(number_10 == 1 or number_10 == 2)
			and number ~= 11 and number ~= 12)
			and((number - number_10)
			and format_numbers2text(number - number_10) or L"") .. time_patternts[number_10]
			or format_numbers2text(number)) .. sentence
	end
	return sentence
end

--- Корекции на "hours" и "mins" от VICEWANDEL 14.01.2020 ---
local time_text = time_to_phrase(hour, "h") .. time_to_phrase(min, "m")
	if time_text == L"" then
		time_text = L"по-малко от една минута"
	end
	return time_text
end
--- Край на вложката за скиновете на VICEWANDEL и Pongo - произнасяне на времето ---

--- Вложка от Cat 18.04.19. --- С тази вложка скоростта на пътя се обявява преди населеното място, а не в него
--- over_speed_limit = function()
--- 	local key = m_i18n_voice("The speed limit is %s!")
--- 	if MODEL.regional.is_it_voice_localizable(key) then
--- 		local speedunits = {"mph","km/h","mph"}
--- 		local correct = SysConfig:get("tts", "correct_speed_unit", true) and MODEL.regional.is_it_voice_localizable(m_i18n_voice("km/h")) and MODEL.regional.is_it_voice_localizable(m_i18n_voice("mph"))
--- 		local announce = SysConfig:get("tts", "announce_speed_unit", true)
--- 		local limitphrasepart = (correct or not announce) and 2 or 0
--- 		local limitphraseunit = correct and announce and (L" " .. translate_voice(speedunits[MODEL.regional.units() + 1])) or L""
--- 		local limitphrase = MODEL.other.format_speed(MODEL.warning.driveralert.speed_limit(), MODEL.regional.units(), 1, limitphrasepart)
--- 		if correct and announce then
--- 			limitphrase = format_all_numbers2text(limitphrase)
--- 		end
--- 		return translated_voice_format(key, limitphrase .. limitphraseunit)
--- 	end
--- end
--- Край на вложката от Cat 18.04.19. ---

wlocalized = {}
wlocalized.countries = {"_ukr"}
for _,v in pairs(wlocalized.countries) do
	wlocalized["loaded"..v] = false
end
if type(complete_POI_CAT_PRIO) == "function" then
	VOICE["complete_POI_CAT_PRIO"]()
	if not (fill_functions._PROC and condfun._PROC) then
		init_functions()
	end
end
