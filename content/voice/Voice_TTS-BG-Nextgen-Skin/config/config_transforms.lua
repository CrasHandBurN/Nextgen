module("VOICE")

-----------------------------------------------------------------------------
---------------|  V O I C E   T R A N S F O R M   U T I L S  |---------------
-----------------------------------------------------------------------------

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

local preposition_tbl = {L"След",L"в Посока Към"}

local preposition_insert_tbl = {
	{L"в ",{L"Странична улица",L"Кръстовище",L"Път без изход"}},
	{L"по ",{L""}},
}

local preposition_insert_tbl_direction = {
	{L"по ",{L""}},
}

local main_streetnames = {L"Булевард",L"Странична улица",L"Площад",L"Авеню",L"Вилна зона",L"Улица"}

local mother_country = "_bul"

local settlement_preposition = L"в Посока Към"

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
	{L"^A +103([^0-9])",L"Щелковско Шосе%1"},
	{L"^M +1([^0-9])",L"Магистрала Москва Минск%1"},
	{L"^R +21([^0-9])",L"Път Санкт-Петербург Печенга%1"},
	--- Регионални пътища от drey95 - 11.07.19
	{L"^ +[0-9][0-9][^0-9]%-([0-9][0-9][0-9][^0-9])",L"Регионален път номер %1"},
	--- Европейски маршрути от drey95 - 16.07.19
	{L"^E +([1-9][0-9]?[0-9]?)",L"Магистрала Е %1"},
	--- Азиатски маршрути от drey95 - 11.07.19
	{L"^AN +([1-9][0-9]?)",L"Магистрала А Н %1"},
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
		local strroadtype = wstring.find(strroad, L"^М") and L" Магистрала " or L" Път "
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

	--- Тапи от drey95 - 12.01.20 - За да не се произнасят фразите
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

	--- Вложка от drey95 - 09.07.19: Декодиране на магистралите
 	{L"^ +Беларус +$",L"Магистрала М 1 Беларус "},

	--- Вложка от drey95 - 09.07.19: Декодиране на номера на пътища по първия номер
	{L"^ +[аА]103 +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Щелковское Шосе"},
	{L"^ +[мМ]1 +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Магистрала Москва Минск"},
	--- Регионални пътища от drey95 - 17.07.19
	{L"[0-9][0-9][^0-9]%-([0-9][0-9][0-9])",L"Регионален път номер %1"},
	--- Европейски маршрути от drey95 - 17.07.19
	{L"^ +[еЕ]([1-9][0-9]?[0-9]?) +%W* +[аАеЕмМрР]?[нН]?[0-9]?[0-9]?[0-9]? +$",L"Магистрала Е %1"},
	--- Азиатски маршрути от drey95 - 17.07.19
	{L"^ +[аА][нН]([1-9][0-9]?) +%W* +[аАеЕмМрР]?[0-9]?[0-9]?[0-9]? +$",L"Магистрала А Н %1"},
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
		local t = {L"Година", L"Януари", L"Февруари", L"Март", L"Април", L"Май", L"Юни", L"Юли", L"Август", L"Септември", L"Октомври", L"Ноември", L"Декември"}
		local suffix = L""
		for _,v in ipairs(t) do
			if s2==v then suffix = L"-а" break end
		end
		if s2==L"Километър" then suffix = L" " end
		if s2==L"Линия" then suffix = L" " end
		return s1..suffix..L" "..s2 end},
	{L"([^0-9]+) ([0-9]+) ([^0-9]+)", function (s1,s2,s3)
		local suffix = L""
		if wstring.find(s1..s3,L"Кръстовище") then suffix = L"-То" end
		return s1..L" "..s2..suffix..L" "..s3 end},

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
	-- Думите "голям“, "малък" и др. се преместват в началото на реда: "1-ва голяма улица" -> "голяма първа улица"
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
	{L"^(%S+)а$", L"%1а"},
	{L"^(%S+)я$", L"%1я"},
	{L"^Белая Калитва$", L"Белую Калитву"},
}

local replace_for_directions_inner = {
	{L"^ +Черен Път +$",L" Черения Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Крайбрежие ",L" Крайбрежието %1 "},
	{L"(.*) Кръстовище ",L" Кръстовището %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Магистрала ",L" Магистрала %1 "},
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
	{L"(.*) Магистрала ",L" Магистрала %1 "},
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
	{L"(.*) Магистрала ",L" Магистрала %1 "},
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

---------------------------------------------------------
---------------|  Р Ъ К О В О Д С Т В О  |---------------
---------------------------------------------------------

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
		dest = data[idx].road.name	--  amk data[idx].signpost.destination
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

local function signpost_settlement(data, idx)	--  в "напрвление" където е символът '>>'
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

local function signpost_roadnumber(data, idx)	--  име на трасето M1 ... Mx
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

------------------------------------------------------
---------------|  РЕЗЮМЕ НА МАРШРУТА  |---------------
------------------------------------------------------

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

-----------------------------------------------
---------------|  Т Р А Ф И К  |---------------
-----------------------------------------------

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

-----------------------------------------
---------------|  E T A  |---------------
-----------------------------------------
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

-- function eta(time,waypoint,currenttime)
	-- local head = currenttime and L"Сега е " or (waypoint and L" Надявам се да пристигнем в спирката във ") or L" Надявам се да пристигнем в дестинацията във "
	-- local hours, mins, tod = L"", L"", L""
	-- local hour = time.hour
	-- local min = time.min
	-- if hour == 0 then hour = 12 tod = L" - през нощта" end
	-- if hour == 1 then hours = L" час"
	-- else hours = format_numbers2text(hour) end
	-- if min == 0 then mins = L""
	-- elseif min < 10 then mins = L" нула" .. format_numbers2text(min)
	-- else mins = format_numbers2text(min) end
	-- if min == 0 and tod == L"" then mins = L" нула нула" end
	--Беше return head..hours..mins..tod -- Стана 01.11.19 от nik4m за правилно произношение на времето в TTS от Wiman
	-- return head..(currenttime and L" " or L" в ")..hours..mins..tod
-- end
function eta(time,waypoint,currenttime)
	local head = currenttime and L"В момента е " or (waypoint and L"В спирката ще пристигнете в " or L"Ще пристигнете дестинацията в ")
	local strmins,strhour
	local hour = time.hour
	local mins = time.min
	local wi_hour_table = {L"един часа и",L"два часа и",L"три часа и",L"четири часа и",L"пет часа и",L"шест часа и",L"седем часа и",L"осем часа и",L"девет часа и",L"десет часа и",L"единайсет часа и",L"дванайсет часа и",L"тринайсет часа и",L"четиринайсет часа и",L"петнайсе-т ч-ас-а и",L"шестнайсет часа и",L"седемнайсет часа и",L"осемнайсет часа и",L"деветнайсет часа и",L"двайсет часа и",L"двайсет и един часа и",L"двайсет и два часа и",L"двайсет и три часа и",L"нула часа и",}
	local wi_hour_table_cur = {L"един часа и",L"два часа и",L"три часа и",L"четири часа и",L"пет часа и",L"шест часа и",L"седем часа и",L"осем часа и",L"девет часа и",L"десет часа и",L"единайсет часа и",L"дванайсет часа и",L"тринайсет часа и",L"четиринайсет часа и",L"петнайсет часа и",L"шестнайсет часа и",L"седемнайсет часа и",L"осемнайсет часа и",L"деветнайсет часа и",L"двайсет часа и",L"двайсет и един часа и",L"двайсет и два часа и",L"двайсет и три часа и",L"нула часа и",}
	local wi_min_table = {L" една минута",L" две минути",L" три минути",L" четири минути",L" пет минути",L" шест минути",L" седем минути",L" осем минути",L" девет минути",L" десет минути",L" единайсет минути",L" дванайсет минути",L" тринайсет минути",L" четиринайсет минути",L" петнайсет минути",L" шестнайсет минути",L" седемнайсет минути",L" осемнайсет минути",L" деветнайсет минути",L" двайсет минути",L" двайсет и една минути",L" двайсет и две минути",L" двайсет и три минути",L" двайсет и четири минути",L" двайсет и пет минути",L" двайсет и шест минути",L" двайсет и седем минути",L" двайсет и осем минути",L" двайсет и девет минути",L" трийсет минути",L" трийсет и една минути",L" трийсет и две минути",L" трийсет и три минути",L" трийсет и четири минути",L" трийсет и пет минути",L" трийсет и шест минути",L" трийсет и седем минути",L" трийсет и осем минути",L" трийсет и девет минути",L" четиресет минути",L" четиресет и една минути",L" четиресет и две минути",L" четиресет и три минути",L" четиресет и четири минути",L" четиресет и пет минути",L" четиресет и шест минути",L" четиресет и седем минути",L" четиресет и осем минути",L" четиресет и девет минути",L" петдесет минути",L" петдесет и една минути",L" петдесет и две минути",L" петдесет и три минути",L" петдесет и четири минути",L" петдесет и пет минути",L" петдесет и шест минути",L" петдесет и седем минути",L" петдесет и осем минути",L" петдесет и девет минути"}

	if time.hour == 0 then
		if time.min == 0 then
			strhour = L"нула часа"
		else
			strhour = L"нула часа и"
		end
	else
		strhour = currenttime and wi_hour_table_cur[hour] or wi_hour_table[hour]
	end

	if time.min == 0 then
		strmins = L"нула нула"
	else
		strmins = wi_min_table[time.min]
	end
	return head .. strhour .. strmins
end

--- Вложка за скиновете на VICEWANDEL и Pongo - произнасяне на времето ---
--- Редактирано от VICEWANDEL 14.01.2020 ---
local time_patternts = {L" една", L" две"}

-- function format_timeto(timeto)
	-- local hour, min
	-- if type(timeto) == "wstring" then
		-- local hour_ = wstring.sub(timeto,1,-4)
		-- local min_  = wstring.sub(timeto,-2,-1)
		-- hour = tonumber(hour_)
		-- min = tonumber(min_)
	-- else
		-- local _, _, hour_, min_ = wstring.find(Format_Timespan(timeto, ETimespanFormat.HrMinRounded), L"(%d+):(%d+)")
		-- hour, min = tonumber(hour_), tonumber(min_)
-- end

-- local function time_to_phrase(number, hm)
	-- local sentence = L""
	-- if number ~= 0 then
		-- local number_10 = number % 10
		-- if number_10 == 1 and number ~= 11 then
			-- sentence = hm == "h" and L" часа " or L" минута "
		-- elseif number_10 > 4 or number_10 == 0 or (number > 10 and number < 20) then
			-- sentence = hm == "h" and L" часа " or L" минути "
		-- else
			-- sentence = hm == "h" and L" часа " or L" минути "
		-- end
		-- sentence = (((hm=="m")
			-- and(number_10 == 1 or number_10 == 2)
			-- and number ~= 11 and number ~= 12)
			-- and((number - number_10)
			-- and format_numbers2text(number - number_10) or L"") .. time_patternts[number_10]
			-- or format_numbers2text(number)) .. sentence
	-- end
	-- return sentence
-- end

--- Корекции на "hours" и "mins" от VICEWANDEL 14.01.2020 ---
-- local time_text = time_to_phrase(hour, "h") .. time_to_phrase(min, "m")
	-- if time_text == L"" then
		-- time_text = L"по-малко от една минута"
	-- end
	-- return time_text
-- end
--- Край на вложката за скиновете на VICEWANDEL и Pongo - произнасяне на времето ---
function format_timeto(timeto)
	local hournew, minsnew
	local hour = wstring.sub(timeto,1,-4)
	local mins = wstring.sub(timeto,-2,-1)
	local hournumber = tonumber(hour)
	local minsnumber = tonumber(mins)
	local replace_hourone = {{L"0",L" "},{L"1",L"един"},}
	local replace_hoursec = {{L"2",L"два"},{L"3",L"три"},{L"4",L"четири"},{L"5",L"пет"},{L"6",L"шест"},{L"7",L"седем"},{L"8",L"осем"},{L"9",L"девет"},{L"10",L"десет"},{L"11",L"единайсет"},{L"12",L"дванайсет"},{L"13",L"тринайсет"},{L"14",L"четиринайсет"},{L"15",L"петнайсет"},{L"16",L"шестнайсет"},{L"17",L"седемнайсет"},{L"18",L"осемнайсет"},{L"19",L"деветнайсет"},{L"20",L"двайсет"},{L"21",L"двайсет и един"},{L"22",L"двайсет и два"},{L"23",L"двайсет и три"},{L"24",L"двайсет и четири"},{L"25",L"двайсет и пет"},{L"26",L"двайсет и шест"},{L"27",L"двайсет и седем"},{L"28",L"двайсет и осем"},{L"29",L"двайсет и девет"},{L"30",L"трийсет"},{L"31",L"трийсет и един"},{L"32",L"трийсет и два"},{L"33",L"трийсет и три"},{L"34",L"трийсет и четири"},{L"35",L"трийсет и пет"},{L"36",L"трийсет и шест"},{L"37",L"трийсет и седем"},{L"38",L"трийсет и осем"},{L"39",L"трийсет и девет"},{L"40",L"четиресет"},{L"41",L"четиресет и един"},{L"42",L"четиресет и два"},{L"43",L"четиресет и три"},{L"44",L"четиресет и четири"},{L"45",L"четиресет и пет"},{L"46",L"четиресет и шест"},{L"47",L"четиресет и седем"},{L"48",L"четиресет и осем"},{L"49",L"четиресет и девет"},{L"50",L"петдесет"},{L"51",L"петдесет и един"},{L"52",L"петдесет и два"},{L"53",L"петдесет и три"},{L"54",L"петдесет и четири"},}
	local replace_mins = {{L"00",L""},{L"01",L"една"},{L"02",L"две"},{L"03",L"три"},{L"04",L"четири"},{L"05",L"пет"},{L"06",L"шест"},{L"07",L"седем"},{L"08",L"осем"},{L"09",L"девет"},{L"10",L"десет"},{L"11",L"единайсет"},{L"12",L"дванайсет"},{L"13",L"тринайсет"},{L"14",L"четиринайсет"},{L"15",L"петнайсет"},{L"16",L"шестнайсет"},{L"17",L"седемнайсет"},{L"18",L"осемнайсет"},{L"19",L"деветнайсет"},{L"20",L"двайсет"},{L"21",L"двайсет и една"},{L"22",L"двайсет и две"},{L"23",L"двайсет и три"},{L"24",L"двайсет и четири"},{L"25",L"двайсет и пет"},{L"26",L"двайсет и шест"},{L"27",L"двайсет и седем"},{L"28",L"двайсет и осем"},{L"29",L"двайсет и девет"},{L"30",L"трийсет"},{L"31",L"трийсет и една"},{L"32",L"трийсет и две"},{L"33",L"трийсет и три"},{L"34",L"трийсет и четири"},{L"35",L"трийсет и пет"},{L"36",L"трийсет и шест"},{L"37",L"трийсет и седем"},{L"38",L"трийсет и осем"},{L"39",L"трийсет и девет"},{L"40",L"четиресет"},{L"41",L"четиресет и една"},{L"42",L"четиресет и две"},{L"43",L"четиресет и три"},{L"44",L"четиресет и четири"},{L"45",L"четиресет и пет"},{L"46",L"четиресет и шест"},{L"47",L"четиресет и седем"},{L"48",L"четиресет и осем"},{L"49",L"четиресет и девет"},{L"50",L"петдесет"},{L"51",L"петдесет и една"},{L"52",L"петдесет и две"},{L"53",L"петдесет и три"},{L"54",L"петдесет и четири"},{L"55",L"петдесет и пет"},{L"56",L"петдесет и шест"},{L"57",L"петдесет и седем"},{L"58",L"петдесет и осем"},{L"59",L"петдесет и девет"},}
	if hournumber == 0 then
		hournew = transform_and_format(hour .. L" ",replace_hourone)
	elseif  hournumber == 1 then
	if minsnumber == 0 then
		hournew = transform_and_format(hour .. L" _час ",replace_hourone)
	else
		hournew = transform_and_format(hour .. L" _час и ",replace_hourone)
	end
	else
	if minsnumber == 0 then
		hournew = transform_and_format(hour .. L" _ча''с-a ",replace_hoursec)
	else
		hournew = transform_and_format(hour .. L" _ча''с-a и ",replace_hoursec)
	end
	end
	if minsnumber == 0 then
	if hournumber == 0 then
		minsnew = transform_and_format(mins .. L" по малко от ми_ну_-т'а ",replace_mins)
	else
		minsnew = transform_and_format(mins,replace_mins)
	end
	elseif  minsnumber == 1 then
		minsnew = transform_and_format(mins .. L" _минутa",replace_mins)
	else
		minsnew = transform_and_format(mins .. L" _минути",replace_mins)
	end
	return hournew .. minsnew
end


over_speed_limit = function()
	local key = m_i18n_voice("The speed limit is %s!")
	local speedunits = {"mph","km/h","mph"}
	if MODEL.regional.is_it_voice_localizable(key) then
		local correct = SysConfig:get("tts", "correct_speed_unit", true) and MODEL.regional.is_it_voice_localizable(m_i18n_voice("km/h")) and MODEL.regional.is_it_voice_localizable(m_i18n_voice("mph"))
		local announce = SysConfig:get("tts", "announce_speed_unit", true)
		local limitphrasepart = (correct or not announce) and 2 or 0
		local limitphraseunit = correct and announce and (L" " .. translate_voice(speedunits[MODEL.regional.units() + 1])) or L""
		return translated_voice_format(key, MODEL.other.format_speed(MODEL.warning.driveralert.speed_limit(), MODEL.regional.units(), 1, limitphrasepart) .. limitphraseunit)
	end
end

function format_lane_info(DescKey)
	voice_debug_log(L"TTS: DescKeyLaneinfo in: '"..DescKey..L"'", 3)
	local lane_info_str = DescKey
	if DescKey ~= L"" then
		if wstring.find(DescKey,L"far_left") then
			lane_info_str = L"Дръжте крайната лява лента."
		elseif wstring.find(DescKey,L"far_right") then
			lane_info_str = L"Дръжте крайната дясна лента."
		elseif wstring.find(DescKey,L"centre") then
			lane_info_str = L"Дръжте централната лента."
		elseif wstring.find(DescKey,L"any") then
			lane_info_str = L"Продължете по из''бр''ан'ата лента."
		else
			local numb = tonumber(wstring.sub(DescKey, 1, 1))
			local t = {{L"", L"двете", L"трите", L"чети-р-и_тЕ", L"петте", L"шестте", L"седемте", L"осемте", L"деветте"},{L"", L"вто-ра-та", L"трета-та", L"чет-въ-р-та-т-а", L"пета-та", L"шеста-та", L"седмата", L"осмата", L"деветата"}}
			if wstring.find(DescKey,L"side_c") then
				lane_info_str = L"Дръжте " .. t[1][numb] .. L" ленти по средата."
			elseif wstring.find(DescKey,L"side_r") or wstring.find(DescKey,L"side_l") then
				lane_info_str = wstring.find(DescKey,L"side_r") and L"Задръжте в дясно, без да заемате " or L"Задръжте в ляво, без да заемате "
				lane_info_str = numb == 1 and (lane_info_str .. L"крайната лента.") or (lane_info_str .. t[1][numb] .. L" крайните ленти.")
			elseif wstring.find(DescKey,L"left") then
				lane_info_str = L"Дръжте " .. t[1][numb] .. L" ленти отляво."
			elseif wstring.find(DescKey,L"right") then
				lane_info_str = L"Дръжте " .. t[1][numb] .. L" ленти отдясно."
			elseif wstring.find(DescKey,L"middle_l") then
				lane_info_str = L"Дръжте " .. t[2][numb] .. L" лента отляво."
			elseif wstring.find(DescKey,L"middle_r") then
				lane_info_str = L"Дръжте " .. t[2][numb] .. L" лента отдясно."
			end
		end
	end
	voice_debug_log(L"TTS: Laneinfo out: '"..lane_info_str..L"'", 3)
	return lane_info_str
end

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

wlocalized.countries = {"_bul"}
for _,v in pairs(wlocalized.countries) do
	wlocalized["loaded"..v] = false
end
if type(complete_POI_CAT_PRIO) == "function" then
	VOICE["complete_POI_CAT_PRIO"]()
	if not (fill_functions._PROC and condfun._PROC) then
		init_functions()
	end
end
