module("VOICE")

ASSERT(type(voice_debug_log) == "function", "Missing voice_debug_log function.")
ASSERT(type(voice_debug_log_table) == "function", "Missing voice_debug_log_table function.")
ASSERT(type(wjoin) == "function", "Missing wjoin function.")
ASSERT(type(wsplit) == "function", "Missing wsplit function.")
ASSERT(type(getFirstNChar) == "function", "Missing getFirstNChar function.")
ASSERT(type(getLastNChar) == "function", "Missing getLastNChar function.")
ASSERT(type(transform_and_format) == "function", "Missing transform_and_format function.")
ASSERT(type(transform_chain) == "function", "Missing transform_chain function.")
ASSERT(type(table_concat) == "function", "Missing table_concat function.")
ASSERT(type(transform_pattern_match) == "function", "Missing transform_pattern_match function.")

local use_dativ_for_sameroad = SysConfig:get("tts", "dativ_for_sameroad", 1)
local use_announce_tollgate_maneuvers = SysConfig:get("tts", "announce_tollgate_maneuvers", 0)
local use_announce_tunnel_maneuvers = SysConfig:get("tts", "announce_tunnel_maneuvers", 0)
local use_announce_merge_maneuvers = SysConfig:get("tts", "announce_merge_maneuvers", 0)
local use_announce_waypointname = SysConfig:get("tts", "announce_waypointname", 0)
local short_tmc_message = SysConfig:get("tts", "short_tmc_message", 0)
local announce_avg_traffic_speed = SysConfig:get("tts", "announce_avg_traffic_speed", 1)
local announce_traffic_delay = SysConfig:get("tts", "announce_traffic_delay", 0)
local announce_speed_unit = SysConfig:get("tts", "announce_speed_unit", 1)

wtollgatesentencetable = {L"След tollgate_distance пункт за плащане на пътни такси", L"tollgate_distance до пункта за плащане на пътни такси", L"След пункта за плащане на пътни такси "}
wtunnelsentencetable = {L"След tunnel_distance тунел", L"tunnel_distance до тунела", L"tunnel_distance до края на тунела", L"След влизане в тунела"}
wmergesentencetable = {L"След merge_distance сливане на пътищата отдясно", L"merge_distance до сливането на пътищата отдясно", L"След merge_distance сливане на пътищата", L"merge_distance до сливането на пътищата", L"След merge_distance", L"merge_distance до сливането на пътищата", L"След сливането на пътищата"}
wtunnelmaneuver_enter = false
wtunnelmaneuver_leave = false
wtollgatemaneuver = false
wmergemaneuver_right = false
wmergemaneuver_left = false
wmergemaneuver_both = false
wnew_manouver = false
waypointname = L""

local function check_waypoint_maneuvers(mapinfo)
	local t_used_manouvers = {L"^goal", L"^via"}
	if mapinfo[1].manouver and transform_pattern_match(towstring(mapinfo[1].manouver),t_used_manouvers) and mapinfo[1].way_point and mapinfo[1].way_point.poi_name then
		waypointname = mapinfo[1].way_point.poi_name.text
	else
		waypointname = L""
	end
end

local guidance_orig = guidance
guidance = function(mapinfo, events)
	if events.new_manouver then wnew_manouver = true else wnew_manouver = false end
	if use_announce_tollgate_maneuvers then wtollgatemaneuver = string.find(mapinfo[1].manouver, "tollgate") end
	if use_announce_waypointname then check_waypoint_maneuvers(mapinfo) end
	if use_announce_tunnel_maneuvers then
		wtunnelmaneuver_enter = string.find(mapinfo[1].manouver, "enter_tunnel")
		wtunnelmaneuver_leave = string.find(mapinfo[1].manouver, "leave_tunnel")
	end
	if use_announce_merge_maneuvers then
		wmergemaneuver_right = string.find(mapinfo[1].manouver, "merge_right")
		wmergemaneuver_left = string.find(mapinfo[1].manouver, "merge_left")
		wmergemaneuver_both = string.find(mapinfo[1].manouver, "merge_both")
	end
	return guidance_orig(mapinfo, events)
end

local preposition_tbl = {L"След",L"в Направление Към"}

local preposition_insert_tbl = {
	{L"в ",{L"Странична Улица ",L"Кръстовище ",L"Път без изход "}},
	{L"по ",{L""}},
}

local preposition_insert_tbl_direction = {
	{L"по ",{L""}},
}

local main_streetnames = {L"Булевард",L"Улица",L"Базар",L"Странична Улица",L"Площад",L"Авеню"}

local settlement_preposition = L"в направление към"

local exit_preposition = L"на изхода"

local replace_roadnumber = {
	{L"^ +",L""},
	{L"(.*)",L"%1/"},
	{wstring.char(160),L""},
	{L"/",L""},
	--------- ако не е в списъка -------------------------------------
	{L"^А *([1-9][0-9][0-9][^0-9])",L"Път А %1"},
	{L"^М *([1-9][0-9]?[^0-9])",L"Трасе М %1"},
	{L"^Р *([1-9][0-9]?[0-9]?[^0-9])",L"Път Р %1"},
	--------- европейски маршрути ----------------------------------
	{L"^Е *([1-9][0-9]?[0-9]?[^0-9])",L"Трасе Е %1"},
	--------- азиатски маршрути --------------------------------------
	{L"^АН *([1-9][0-9]?[^0-9])",L"Трасе А Н %1"},
	--------- регионални пътища -------------------------------------
	{L"^[0-9][0-9][А-Я]?%-.+",L"Път Без Име"},
	{L"/",L""},
}

local replace_roadname = replace_roadnumber

local replace_address = {
	{L"([0-9])([А-Я])",L"%1 %2"},
}

local replace_mapinfo = {
	{L"(.*)",L" %1 "},
	{L",",L" , "},
	{L"%([%S ]+%)",L" "},
	{L" [0-9]+%.[0-9]+ ",L" "},
	{L" ([0-9]+)",L"  %1"},
	{L" (%S)%.( ?)(%S)%. ", function (s1, s2, s3)
		if smart_lower_case_get_codegroup(wstring.byte(s1,1)) and smart_lower_case_get_codegroup(wstring.byte(s3,1)) then return L" " end
		return L" "..s1..L"."..s2..s3..L". " end},
	{L"Буле?в?%.",L"Булевард "},
	{L"Ули%.",L"Улица "},
	{L"Неасф%.",L"Неасфалтиран "},
	{L"Път Без Име",L" "},
	{L"Железоп%.",L"Железопътен "},
	{L"Им%.",L"Име "},
	{L"Км%.",L"Километър "},
	{L"Микр%.",L"Микрорайон "},
	{L"Наб%.",L"Кей "},
	{L"Пл%.",L"Площад "},
	{L"Пров%.",L"Странична Улица "},
	{L"Авен%.",L"Авеню "},
	{L"Филтриращи Полета",L"Филтриращи_ Полета"},
	{L"Хх%-",L"20-"},
	{L"Alle[%.y][%. ]",L"Алея "},
	{L"Ave[%. ]",L"Авеню "},
	{L"Blvd[%. ]",L"Булевард "},
	{L"Boul[%. ]",L"Булевард "},
	{L"Hotel Ibis Kiev Shevchenko Bd",L"Хотел Ибис"},
	{L"Hotel Paradisson Sas",L"Хотел Radisson Sas"},
	{L"Prov[%. ]",L"Странична Улица "},
	{L"Railway Station",L"Железопътна гара"},
	{L"Royal Grand Hotel",L"Роял Гранд Хотел"},
	{L"Royal Hotel De Paris",L"Хотел Royal De Paris"},
	{L"Side%-Street[%. ]",L"Странична Улица "},
	{L"Улц[%. ]",L"Улица "},
	{L"Str[%. ]",L"Улица "},
	{L"Vul[%. ]",L"Улица "},
	{L"|",L""},

}

local mapinfo_numbers = {
	{L"", L"втори", L"трети", L"четвърти", L"пети", L"шести", L"седми", L"осми", L"девети"},
	{L"един", L"две", L"три", L"четири", L"пет", L"шест", L"седем", L"осем", L"девет"},
	{L"", L"двадесет", L"тридесет", L"четиридесет", L"петдесет", L"шестдесет", L"седемдесет", L"осемдесет", L"деветдесет"},
	{L"сто", L"двеста", L"триста", L"четиристотин", L"петстотин", L"шестстотин", L"седемстотин", L"осемстотин", L"деветстотин"},
	{L"хиляда", L"две хиляди", L"три хиляди", L"четири хиляди", L"пет хиляди", L"шест хиляди", L"седем хиляди", L"осем хиляди", L"девет хиляди"},
}

local replace_mapinfo_numbers = {}

local replace_mapinfo_end = {
	{L"(.*)|(.*)|(.*)",L" %2 %1 %3 "},
	{L" (%S)%.", function (s) if smart_lower_case_get_codegroup(wstring.byte(s,1)) then return L" " end return L" "..s..L". " end},
	{L"^([А-Я])([А-Я])[ ?]*([0-9]+)",L"%1.%2. %3"},
	{L"%-([0-9]+)",L" %1"},
	{L"([0-9])([а-яА-Я])",L"%1 %2"},
	{L"([а-яА-Я])([0-9])",L"%1 %2"},
	{L"([еЕ])([0-9])",L"Е %2"},
	{L"([нН])([0-9])",L"ен %2"},
	{L"([мМ])([0-9])",L"ем %2"},
	{L"([рР])([0-9])",L"ер %2"},
	{L"//",L", "},
	{L" +,",L","},
	{L",+",L", "},
	{L" +",L" "},
	{L"^ ",L""},
	{L" $",L""},
}
----------------------------------done-----------------------

local replace_for_turns = {
	{L"(.*)",L" %1 "},
}

local replace_for_turns_end = {
	{L" +",L" "},
	{L"^ ",L""},
	{L" $",L""},
}

local replace_for_traffic_end = {
	{L"/",L", "},
	{L" +,",L","},
	{L",+",L", "},
	{L" +",L" "},
	{L"^ ",L""},
	{L" $",L""},
}

local replace_sentence={
	{L" [пП]осле ",L", после "},
	{L" [тТ]ам ",L", там "},
	{L"/",L", "},
	{L" +",L" "},
}

local replace_cities_for_turns = {
	{L"%.", L""},
	{L"^(%S+)а$", L"%1а"},
	{L"^(%S+)я$", L"%1ю"},
	{L"^Біла Церква$", L"Бяла Черква"},
	{L"^Гола Пристань$", L"Голу Пристан"},
	{L"^Мала Виска$", L"Малу Виску"},
	{L"^Нова Каховка$", L"Нова Каховка"},
	{L"^Нова Одеса$", L"Нова Одеса"},
	{L"^Стара Вижівка$", L"Стара Виживка"},
	{L"^Судова Вишня$", L"Съдебна Череша"},
	{L"^Запоріжжю$", L"Запорожие"},
	{L"^Зимогір'ю$", L"Зимохиря"},
	{L"^Білопіллю$", L"Билопиля"},
	{L"^Добропіллю$", L"Добропила"},
	{L"^Привіллю$", L"Привилегия"},
	{L"^Щастю$", L"Щастие"},
}

local replace_for_turns_inner = {
	{L"^ +Неасфалтиран Път +$",L" Неасфалтиран Път "},
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Кей ",L" Кея %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
	{L"^ +Околовръстен Път ",L" Околовръстния Път "},
	{L"^ +Скоростен Път ",L" Скоростния Път "},
	{L"(.*) Път ",L" Пътя %1 "},
	{L"(.*) Скоростен Път ",L" Скоростния Път %1 "},
}

local replace_for_turns_inner2 = {
	{L"(.*) Алея ",L" Алея %1 "},
	{L"(.*) Булевард ",L" Булевард %1 "},
	{L"(.*) Изход ",L" Изход %1 "},
	{L"(.*) Улица ",L" Улица %1 "},
	{L"(.*) Вход ",L" Вход %1 "},
	{L"(.*) Базар ",L" Базар %1 "},
	{L"(.*) Микрорайон ",L" Микрорайон %1 "},
	{L"(.*) Прелез ",L" Прелез %1 "},
	{L"(.*) Странична Улица ",L" Странична Улица %1 "},
	{L"(.*) Площад ",L" Площад %1 "},
	{L"(.*) Авеню ",L" Авеню %1 "},
	{L"(.*) Спускане ",L" Спускане %1 "},
	{L"(.*) Трасе ",L" Трасе %1 "},
	{L"(.*) Път без изход ",L" Път без изход %1 "},
}

local replace_for_directions_inner = {
	{L"^ +Неасфалтиран Път +$",L" Неасфалтирания Път "},
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Кей ",L" Кея %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Станция ",L" Станцята %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
	{L"^ +Околовръстен Път ",L" Околовръстния Път "},
	{L"^ +Скоростен Път ",L" Скоростния Път "},
	{L"^ +(%S+)и +(%S+)и +Полупръстен +$", L" %1ят %2ят Полупръстен "},
	{L"^ +(%S+)и +Полупръстен +$", L" %1ят Полупръстен "},
	{L"^ +(%S+)и +(%S+)и +Пръстен +$", L" %1ят %2ят Пръстен "},
	{L"^ +(%S+)и +Пръстен +$", L" %1и Пръстен "},
	{L"^ + [Тт] трети ", L" Третият "},
	{L"(.*) Път ",L" Път %1 "},
	{L"(.*) Скоростен Път ",L" Скоростния Път %1 "},
}

local replace_for_directions_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Улица ",L" Улицата %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Базар ",L" Базара %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична Улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя без изход %1 "},
}

local replace_for_traffic_fromto_inner = {
	{L"^ +Неасфалтиран Път +$",L" Неасфалтирания Път "},
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Кей ",L" Кея %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Район ",L" Района %1 "},
	{L"(.*) Спускане ",L" Спусканеането %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
	{L"^ +Околовръстен Път ",L" Околовръстния Път "},
	{L"^ +Скоростен Път ",L" Скоростния Път "},
	{L"^ +(%S+)и +(%S+)и +ПолуПръстен +$", L" %1ят %2ят ПолуПръстен "},
	{L"^ +(%S+)и +ПолуПръстен +$", L" %1ят ПолуПръстен "},
	{L"^ +(%S+)и +(%S+)и +Пръстен +$", L" %1ят %2ят Пръстен "},
	{L"^ +(%S+)и +Пръстен +$", L" %1ят Пръстен "},
	{L"^ + [Тт] трето ", L" Третото "},
	{L"(.*) Път ",L" Пътя %1 "},
}

local replace_for_traffic_fromto_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Улица ",L" Улицата %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Базар ",L" Базара %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична Улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя без изход %1 "},
}

local replace_for_traffic_on_inner = {
	{L"^ +Неасфалтиран Път +$",L" Неасфалтирания Път "},
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Мост ",L" Моста %1 "},
	{L"(.*) Кей ",L" Кея %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Район ",L" Района %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Станция ",L" Станцията %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Шосе ",L" Шосето %1 "},
	{L"^ +Околовръстен Път ",L" Околовръстния Път "},
	{L"^ +Скоростен Път ",L" Скоростния Път "},
	{L"^ +(%S+)о +(%S+)о +ПолуОколовръстно +$", L" %1то %2то ПолуОколовръстно "},
	{L"^ +(%S+)о +ПолуОколовръстно +$", L" %1то Полуоколовръстно "},
	{L"^ +(%S+)о +(%S+)о +Околовръстно +$", L" %1то %2то Околовръстно "},
	{L"^ +(%S+)и +Пръстен +$", L" %1ят Пръстен "},
	{L"^ + [Тт] трети ", L" Третия "},
	{L"(.*) Път ",L" Пътя %1 "},
}

local replace_for_traffic_on_inner2 = {
	{L"(.*) Алея ",L" Алеята %1 "},
	{L"(.*) Булевард ",L" Булеварда %1 "},
	{L"(.*) Изход ",L" Изхода %1 "},
	{L"(.*) Улица ",L" Улицата %1 "},
	{L"(.*) Вход ",L" Входа %1 "},
	{L"(.*) Базар ",L" Базара %1 "},
	{L"(.*) Микрорайон ",L" Микрорайона %1 "},
	{L"(.*) Прелез ",L" Прелеза %1 "},
	{L"(.*) Странична Улица ",L" Страничната Улица %1 "},
	{L"(.*) Площад ",L" Площада %1 "},
	{L"(.*) Авеню ",L" Авенюто %1 "},
	{L"(.*) Спускане ",L" Спускането %1 "},
	{L"(.*) Трасе ",L" Трасето %1 "},
	{L"(.*) Път без изход ",L" Пътя без изход %1 "},
}

local replace_for_summary_inner = {
	{L"(.*) Път ",L" Път %1 "},
	{L"(.*) Алея ",L" Алея %1 "},
	{L"(.*) Вход ",L" Вход %1 "},
	{L"(.*) Изход ",L" Изход %1 "},
	{L"(.*) Микрорайон ",L" Микрорайон %1 "},
	{L"(.*) Мост ",L" Мост %1 "},
	{L"(.*) Кей ",L" Кей %1 "},
	{L"(.*) Прелез ",L" Прелез %1 "},
	{L"(.*) Спускане ",L" Спускане %1 "},
	{L"(.*) Станция ",L" Станция %1 "},
	{L"(.*) Трасе ",L" Трасе %1 "},
	{L"(.*) Шосе ",L" Шосе %1 "},
}

local replace_for_summary_inner2 = {
	{L"(.*) Булевард ",L" Булевард %1 "},
	{L"(.*) Вилна Зона ",L" Вилна Зона %1 "},
	{L"(.*) Странична Улица ",L" Странична Улица %1 "},
	{L"(.*) Площад ",L" Площад %1 "},
	{L"(.*) Кръстовище ",L" Кръстовище %1 "},
	{L"(.*) Авеню ",L" Авеню %1 "},
	{L"(.*) Път без изход ",L" Път без изход %1 "},
	{L"(.*) Улица ",L" Улица %1 "},
}

local function format_tbl(str, tbl)
	for key, value in ipairs(tbl) do
		str = wstring.gsub(str,value[1],value[2])
	end
	return str
end

local function get_preposition(str, tbl)
	for k,value in ipairs(tbl) do
		for _,pattern in ipairs(tbl[k][2]) do
			if wstring.find(str,pattern) then
				return tbl[k][1]
			end
		end
	end
end

local function not_settlement(str, direction)
	if transform_pattern_match(str,preposition_tbl) then
		return L""
	end
	return get_preposition(str, direction and preposition_insert_tbl_direction or preposition_insert_tbl)
end

local function format_mapinfo(str)
	str = smart_lower_case(str)
	str = format_tbl(str, replace_roadname)
	str = format_tbl(str, replace_mapinfo)
	local replace_mapinfo_numbers_need = wstring.find(str,L"[0-9]")
	if replace_mapinfo_numbers_need then
		str = format_tbl(str, replace_mapinfo_numbers)
	end
	return format_tbl(str, replace_mapinfo_end)
end

local function format_roadnumber(number)
	voice_debug_log(L"TTS: roadnumber in: '"..number..L"'", 3)
	local str = format_tbl(number, replace_roadnumber)
	voice_debug_log(L"TTS: roadnumber out: '"..str..L"'", 3)
	return format_all_numbers2text(str)
end

local function format_cases(str, case, mapinfo)
	str=format_tbl(str, replace_for_turns)
	local str_input = str
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
	if not transform_pattern_match(str, main_streetnames) then
		str = format_tbl(str, t_inner)
	end
	local matched = 0
	for _,v in ipairs(main_streetnames) do
		if wstring.find(str,v) then wstring.gsub(str, v, function() matched = matched + 1 end) end
	end
	if matched < 2 then
		str = format_tbl(str, t_inner2)
	elseif matched == 2 and wstring.find(str,L"Улица") then
		str = wstring.gsub(str,L"Улица",L"")
		str = format_tbl(str, t_inner2)
	end
	str = format_tbl(str, replace_for_turns_end)
	if wstring.find(str,L"[0-9]$") then str = format_all_numbers2text(str) end
	if mapinfo == nil or str == L"" or case == "for_summary" or case == "for_traffic_fromto" then
		return str
	else
		return not_settlement(str_input, case == "for_directions") .. str
	end
end

local function signpost_exit(data, idx)
	local exitname = data[idx].signpost.exitname
	if exitname then
		local exit_str = exitname.text
		voice_debug_log(L"TTS: signpost_exit in: '"..exit_str..L"'", 3)
		exit_str = exit_preposition .. L" " .. format_cases(format_mapinfo(exit_str), "for_turns")
		voice_debug_log(L"TTS: signpost_exit out: '"..exit_str..L"'", 3)
		return exit_str
	end
end

local function signpost_roadnumber(data, idx)
	local roadnumber = data[idx].signpost.roadnumber
	if roadnumber then
		local str=roadnumber.text
		voice_debug_log(L"TTS: signpost_roadnumber in: '"..str..L"'", 3)
		str = format_cases(format_roadnumber(str), "for_turns")
		if not wstring.find(roadnumber.text,settlement_preposition) then
			str=settlement_preposition .. L" " .. str
		end
		voice_debug_log(L"TTS: signpost_roadnumber out: '"..str..L"'", 3)
		return str
	end
end

local function signpost_destination(data, idx)
	local destination
	if data[idx].signpost.destination and data[idx].signpost.destination.langcode == "BUL" then
		destination = data[idx].signpost.destination
	end
	if destination then
		local str=destination.text
		voice_debug_log(L"TTS: signpost_destination in: '"..str..L"'", 3)
		str = format_cases(format_tbl(format_mapinfo(str), replace_cities_for_turns), "for_turns", true)
		voice_debug_log(L"TTS: signpost_destination out: '"..str..L"'", 3)
		if str ~= L"" then return str end

	end
end

local function signpost_settlement(data, idx)
	local settlement
	if data[idx].signpost.settlement and data[idx].signpost.settlement.langcode == "BUL" then
		settlement = data[idx].signpost.settlement
	end
	if settlement then
		local str=settlement.text
		voice_debug_log(L"TTS: signpost_settlement in: '"..str..L"'", 3)
		str = format_cases(format_tbl(format_mapinfo(str), replace_cities_for_turns), "for_turns")
		if not wstring.find(settlement.text,settlement_preposition) then
			str=settlement_preposition .. L" " .. str
		end
		voice_debug_log(L"TTS: signpost_settlement out: '"..str..L"'", 3)
		return str
	end
end

local function road_number_name(data, idx)
	local number = data[idx].road.number
	local name = data[idx].road.name
	local t_for_turns = "for_turns"
	local road_str = L""
	local road_changed
	if name then
		road_str=name.text
		road_changed = name.change
		if use_dativ_for_sameroad and road_changed ~= nil and not road_changed then t_for_turns = "for_directions" end
		voice_debug_log(L"TTS: road_name in: '"..road_str..L"'", 3)
		road_str = format_cases(format_mapinfo(road_str), t_for_turns, true)
		voice_debug_log(L"TTS: road_name out: '"..road_str..L"'", 3)
	elseif number then
		road_str=number.text
		road_changed = number.change
		if use_dativ_for_sameroad and road_changed ~= nil and not road_changed then t_for_turns = "for_directions" end
		voice_debug_log(L"TTS: road_number in: '"..road_str..L"'", 3)
		road_str = format_cases(format_roadnumber(road_str), t_for_turns, true)
		voice_debug_log(L"TTS: road_number out: '"..road_str..L"'", 3)
	end
	return road_str
end

local function transform_tollgate_maneuvers(str)
	if wtollgatemaneuver then
		local idx = wnew_manouver and 1 or 2
		local distance_tollgate = RESULTS[1].announcePoint
		if wnew_manouver or (wstring.find(str, L"RESULT1") and distance_tollgate > 290) then
			str = wstring.gsub(wtollgatesentencetable[idx], L"tollgate_distance", getDistanceFromVoice(distance_tollgate,1))
		else
			str = wtollgatesentencetable[3]..str
		end
	end
	return str
end

local function transform_tunnel_maneuvers(str)
	if wtunnelmaneuver_enter or wtunnelmaneuver_leave then
		local idx = wtunnelmaneuver_enter and (wnew_manouver and 1 or 2) or 3
		local distance_tunnel = RESULTS[1].announcePoint
		if wnew_manouver or (wstring.find(str, L"RESULT1") and distance_tunnel > 290) then str = wstring.gsub(wtunnelsentencetable[idx], L"tunnel_distance", getDistanceFromVoice(distance_tunnel,1))
		elseif wtunnelmaneuver_enter then
			str = wtunnelsentencetable[4]..str
		end
	end
	return str
end

local function transform_merge_maneuvers(str)
	if wmergemaneuver_right or wmergemaneuver_left or wmergemaneuver_both then
		local idx = wnew_manouver and (wmergemaneuver_right and 1 or (wmergemaneuver_left and 3 or 5)) or (wmergemaneuver_right and 2 or (wmergemaneuver_left and 4 or 6))
		local distance_merge = RESULTS[1].announcePoint
		if wnew_manouver or (wstring.find(str, L"RESULT1") and distance_merge > 290) then str = wstring.gsub(wmergesentencetable[idx], L"merge_distance", getDistanceFromVoice(distance_merge,1))
		else
			str = wmergesentencetable[7]..str
		end
	end
	return str
end

local function format_replace_shield(str)
	str = wstring.gsub(str, L"[%(](.+)[%)]",L"")
	return wstring.gsub(str, L"[%/](.+)",L"")
end

local function format_replace_shield2(str)
	for i=4190, 4200 do
		str = wstring.gsub(str, wstring.char(i),L"")
	end
	str = wstring.gsub(str, wstring.char(4244),L"")
	str = wstring.gsub(str, wstring.char(4255),L"")
	str = wstring.gsub(str, wstring.char(256),L"")
	str = wstring.gsub(str, wstring.char(1),L"")
	return str
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
	str = L" " .. format_tbl(str, replace_sentence) .. L" "
	str = wstring.gsub(str, L" [`'](%S+)[`'] ", L" %1 ")
	str = wstring.gsub(str, L"(%S)`(.*)", smart_lower_case_inner1)
	str = wstring.gsub(str, L"(%S)'(.*)", smart_lower_case_inner2)
	local out = L" "
	for i = 2, #str-1 do
		out = out .. smart_lower_case_inner3(wstring.byte(str,i-1),wstring.byte(str,i),wstring.byte(str,i+1))
	end
	return out .. L" "
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
			wstring.gsub(streetname, L"([^/]+)/?", function(s) if s ~= L"" then table.insert(t, s) end end)
			if #t then streetname = t[1] end
		end
		streetname = format_mapinfo(streetname)
		local matched = 0
		for _,v in ipairs(main_streetnames) do
			streetname = wstring.gsub(streetname, v, function()
				matched = matched + 1
				if matched > 1 then return L"/"..v
				else return v end
			end)
		end
		t = {}
		if wstring.find(streetname, L"/") then
			wstring.gsub(streetname, L"([^/]+)/?", function(s) if s ~= L"" then table.insert(t, s) end end)
			if #t then streetname = t[1] end
		end
		streetname = sett_preposition .. format_cases(streetname, "for_turns", no_settlement)
	else
		streetname = format_cases(format_mapinfo(streetname), "for_summary")
	end
	voice_debug_log(L"TTS: streetname from skin out: '"..streetname..L"'", 3)
	return streetname
end

function format_destname(data, idx)
	local destname_str = L""
	if data[idx].signpost then
		local signpost_exit_str = signpost_exit(data, idx)
		local roadnumber_str = signpost_roadnumber(data, idx)
		local destination_str = signpost_destination(data, idx)
		local settlement_str = signpost_settlement(data, idx)
		if destination_str and settlement_str and wstring.find(settlement_str,destination_str) then settlement_str = nil end
		if signpost_exit_str then destname_str = signpost_exit_str end
		if destination_str then destname_str = destname_str ~= L"" and destname_str .. L", " .. destination_str or destination_str end
		if roadnumber_str and settlement_str then
			destname_str = destname_str ~= L"" and destname_str .. L", " .. settlement_str or settlement_str
		elseif roadnumber_str then
			destname_str = destname_str ~= L"" and destname_str .. L", " .. roadnumber_str or roadnumber_str
		elseif settlement_str then
			destname_str = destname_str ~= L"" and destname_str .. L", " .. settlement_str or settlement_str
		end
	elseif data[idx].road then
		destname_str = road_number_name(data, idx)
	end
	return destname_str
end

function format_streetname(data, idx)
	local streetname_str = L""
	if data[idx].road then streetname_str = road_number_name(data, idx) end
	return streetname_str
end

function format_sentence(str)
	voice_debug_log(L"TTS: format_sentence in: '"..str..L"'", 3)
	if use_announce_tollgate_maneuvers then str = transform_tollgate_maneuvers(str) end
	if use_announce_tunnel_maneuvers then str = transform_tunnel_maneuvers(str) end
	if use_announce_merge_maneuvers then str = transform_merge_maneuvers(str) end
	str = wstring.gsub(str, L"waypointname", waypointname)
	if use_announce_waypointname then str = format_tbl(str, replace_address) end
	str = format_tbl(str, replace_sentence)
	voice_debug_log(L"TTS: format_sentence out: '"..str..L"'", 3)
	return str
end

----------------------------------------------------------------------------------------------------
-----------------------------------|  РЕЗЮМЕ НА МАРШРУТА  |----------------------------------
----------------------------------------------------------------------------------------------------

function route_summary_format_road_name(data)
	local str = data.text
	voice_debug_log(L"TTS: summary roadnumber in: '"..str..L"'", 3)
	str = format_roadnumber(str)
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

function format_address(str,postcode)
	str = wstring.gsub(str, L"\n", L", ")
	str = wstring.gsub(str, L"/", L", Фракция ")
	if postcode then str = wstring.gsub(str, L"([0-9][0-9][0-9])([0-9][0-9][0-9])", L"%1%-%2")
	else str = wstring.gsub(str, L"[0-9][0-9][0-9][0-9][0-9][0-9]", L"") end
	str = format_tbl(str, replace_address)
	return str
end

local function traffic_fromto_format_func(str)
	return wstring.gsub(str,L"^ ?(%S) ?[0-9]+$",
		function (s)
			if smart_lower_case_get_codegroup(wstring.byte(s,1)) then return L"" else return s end
		end) == L"" and format_roadnumber or format_mapinfo
end

local function transform_traffic_fromto(fromto, str, roadname)
	local t = {}
	wstring.gsub(str, L"([^,]+),?", function(s) if s ~= L"" then table.insert(t, format_tbl(s, replace_for_turns_end)) end end)
	for k in ipairs(t) do
		if roadname ~= L"" and t[k+1] and (wstring.find(roadname, t[k+1]) or roadname==t[k+1]) then table.remove(t, k+1) end
	end
	if roadname ~= L"" and (wstring.find(roadname, t[1]) or roadname==t[1]) then table.remove(t, 1) end
	if #t then
		str = t[1]
		if wstring.find(str, L"/") then
			t = {}
			wstring.gsub(str, L"([^/]+)/?", function(s) if s ~= L"" then table.insert(t, format_tbl(s, replace_for_turns_end)) end end)
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
	return L" "
end

function traffic_event_supported()
	return true
end

function format_tmc_description(str)
	local wtmc_units = {"km/h", "mph"}
	for _,v in pairs(wtmc_units) do
		local value = announce_speed_unit and (MODEL.regional.is_it_voice_localizable(m_i18n_voice(v)) and translate_voice(v) or translate(v)) or L""
		str = wstring.gsub(str, L"([0-9]+) -"..translate(v),L"%1 "..value)
	end
	if not announce_avg_traffic_speed then str = wstring.gsub(str, L"[,](.+)",L", ") end
	return str
end

function traffic_event(DescKey, data)
	if MODEL.lua.sound.Mode() == 0 then return end
	ASSERT(MODEL.regional.is_it_voice_localizable(DescKey), "Missing TrafficEvent dictionary.voice key:" .. DescKey)
	local traffic_on, traffic_roadnumber, traffic_roadname, traffic_from, traffic_to, voice_from, voice_to = L"", L"", L"", L"", L"", L"", L""
	if data.roadnumber and data.roadnumber ~= L"" then
		traffic_roadnumber = transform_and_format(data.roadnumber)
		voice_debug_log(L"TTS: traffic on roadnumber in: '"..traffic_roadnumber..L"'", 3)
		traffic_on = format_cases(format_roadnumber(format_replace_shield2(traffic_roadnumber)), "for_traffic_on",true)
		voice_debug_log(L"TTS: traffic on roadnumber out: '"..traffic_on..L"'", 3)
	end
	if data.roadname and data.roadname ~= L"" then
		traffic_roadname = transform_and_format(data.roadname)
		if short_tmc_message then
			traffic_roadname = wstring.gsub(traffic_roadname, L"(.+)[%/]",L"")
		end
		voice_debug_log(L"TTS: traffic on roadname in: '"..traffic_roadname..L"'", 3)
		if wstring.find(traffic_roadname, L"/") then
			local t = {}
			wstring.gsub(traffic_roadname, L"([^/]+)/?", function(s) if s~=L"" then table.insert(t, format_tbl(s, replace_for_turns_end)) end end)
			if #t then traffic_on = format_cases(format_mapinfo(t[1]), "for_traffic_on", true) end
			if #t>1 then traffic_on = traffic_on .. L" в района " .. format_cases(format_mapinfo(t[2]), "for_traffic_fromto") end
		else
			traffic_on = format_cases(format_mapinfo(traffic_roadname), "for_traffic_on", true)
		end
		voice_debug_log(L"TTS: traffic on roadname out: '"..traffic_on..L"'", 3)
	end
	if data.roadname then traffic_roadname = transform_and_format(data.roadname) end
	if traffic_on ~= L"" then traffic_on = L" " .. traffic_on end
	if data.from and data.from ~= L"" then
		voice_from = transform_and_format(data.from)
		if short_tmc_message then
			voice_from = wstring.gsub(voice_from, L"(.+)[%/]",L"")
		end
		voice_debug_log(L"TTS: traffic from in: '"..voice_from..L"'", 3)
		traffic_from = transform_traffic_fromto(((data.to and data.to ~= L"") and L" , от" or L" , в района"), voice_from, traffic_roadname)
		voice_debug_log(L"TTS: traffic from out: '"..traffic_from..L"'", 3)
	end
	if data.to and data.to ~= L"" then
		voice_to = transform_and_format(data.to)
		if short_tmc_message then
			voice_to = wstring.gsub(voice_to, L"(.+)[%/]",L"")
		end
		voice_debug_log(L"TTS: traffic to in: '"..voice_to..L"'", 3)
		traffic_to = transform_traffic_fromto(((data.from and data.from ~= L"") and L" , до" or L" , в района"), voice_to, traffic_roadname)
		voice_debug_log(L"TTS: traffic to out: '"..traffic_to..L"'", 3)
	end
	local traffic_description, traffic_distance, traffic_delay = translate_voice(DescKey), L"", L""
	local traffic_description_on = transform_pattern_match(towstring(DescKey), {L"ahead", L"blocked"})
	if traffic_description_on and (data.roadname or data.from or data.to) then
		local current
		local event_flag
		for i = 0, #MODEL.traffic.events.significant_events - 1 do
			current = MODEL.traffic.events.significant_events[i]
			event_flag = true
			if data.roadname then event_flag = transform_and_format(data.roadname) == current.road_name() end
			if event_flag and data.from then event_flag = transform_and_format(data.from) == current.location_from() end
			if event_flag and data.to then event_flag = transform_and_format(data.to) == current.location_to() end
			if event_flag then
				if current.description() ~= L"" then traffic_description = format_tmc_description(current.description()) end
				if data.distance and data.distance > 200 then traffic_distance = L"След " .. getDistanceFromVoice(data.distance,1) .. L" "
				elseif current.description() ~= L"" then traffic_description = L"Предстои " .. traffic_description end
				local event_delay = current.delay()
				if event_delay and announce_traffic_delay then traffic_delay = L", Забавяне " .. format_timeto(event_delay) end
				break
			end
			if i>30 then break end
		end
	end
	return format_tbl(traffic_distance .. traffic_description .. traffic_on .. traffic_from .. traffic_to .. traffic_delay, replace_for_traffic_end)
end

local all_numbers_patternts = {
	{L"сто",L"двеста",L"триста",L"четиристотин",L"петстотин",L"шестстотин",L"седемстотин",L"осемстотин",L"деветстотин"},
	{L"десет",L"двадесет",L"тридесет",L"четиресет",L"петдесет",L"шестдесет",L"седемдесет",L"осемдесет",L"деветдесет"},
	{L"едно",L"две",L"три",L"четири",L"пет",L"шест",L"седем",L"осем",L"девет",L"десет" ,L"единадесет",L"дванадесет",L"тринадесет",L"четиринадесет",L"петнадесет",L"шестнадесет",L"седемнадесет",L"осемнадесет",L"деветнадесет"}
}

----------------------------------------------------------------------------------------------------
---------------------------------------------|  E T A  |--------------------------------------------
----------------------------------------------------------------------------------------------------
function format_numbers2text(number)
	local str = towstring(number)
	if #str > 3 then return L" " .. str end
	if str == L"0" then return L" нула" end
	local t = {}
	local out = L""
	for i = 1, #str do
		table.insert(t, tonumber(wstring.sub(str, i, i)))
	end
	for i = 1, (3 - #str) do
		table.insert(t, 1, 0)
	end
	if (10 * t[2] + t[3]) < 20 then
		t[3] = 10 * t[2] + t[3]
		t[2] = 0
	end
	for i = 1, #t do
		if t[i] then
			out = out .. L" " .. all_numbers_patternts[i][t[i]]
		end
	end
	return out
end

function format_all_numbers2text(str,spell)
	return wstring.gsub(str, L"([0-9]+)", function(s)
		local inner = L""
		if #s > 3 or wstring.find(s, L"^0") or spell then
			for i = 1, #s do inner = inner .. format_numbers2text(tonumber(wstring.sub(s, i, i))) end
		else inner = format_numbers2text(tonumber(s)) end
		return inner .. L" "
	end)
end

local time_patternts = {L" една", L" две"}

local timedifference_patternts = {L" една", L" две"}

local function time_to_phrase(number, hm)
	local sentence = L""
	if number ~= 0 then
		local number_10 = number % 10
		if number_10 == 1 and number ~= 11 then
			sentence = hm == "h" and L" час " or L" минута "
		elseif number_10 > 4 or number_10 == 0 or (number > 10 and number < 20) then
			sentence = hm == "h" and L" часа " or L" минути "
		else
			sentence = hm == "h" and L" часа " or L" минути "
		end
		sentence = (((hm=="m")
			and (number_10 == 1 or number_10 == 2)
			and number ~= 11 and number ~= 12)
			and ((number - number_10)
			and format_numbers2text(number - number_10) or L"") .. time_patternts[number_10]
			or format_numbers2text(number)) .. sentence
	end
	return sentence
end

local function timedifference_to_phrase(number, hm)
	local sentence = L""
	if number ~= 0 then
		local number_10 = number % 10
		if number_10 == 1 and number ~= 11 then
			sentence = hm == "h" and L" час " or L" минута "
		elseif number_10 > 4 or number_10 == 0 or (number > 10 and number < 20) then
			sentence = hm == "h" and L" часа " or L" минути "
		else
			sentence = hm == "h" and L" часа " or L" минути "
		end
		sentence = (((hm=="m")
			and (number_10 == 1 or number_10 == 2)
			and number ~= 11 and number ~= 12)
			and ((number - number_10)
			and format_numbers2text(number - number_10) or L"") .. timedifference_patternts[number_10]
			or format_numbers2text(number)) .. sentence
	end
	return sentence
end

function eta(time,waypoint)
	local head = waypoint and L"Пристигане в спирката" or L"Пристигане в дестинацията"
	local hours, mins, tod = L"", L"", L""
	local hour = time.hour
	local min = time.min
	if hour == 0 then hour = 12 tod = L" - през нощта" end
	if hour == 1 then hours = L" в първата"
	else hours = L" в" .. format_numbers2text(hour) end
	if min == 0 then mins = L""
	elseif min < 10 then mins = L" нула" .. format_numbers2text(min)
	else mins = format_numbers2text(min) end
	if min == 0 and tod == L"" then mins = L" нула нула" end
	return head..hours..mins..tod
end

--~ 	VW
function format_timeto(timeto)
	local hour, min
	if type(timeto) == "wstring" then
		local hour_ = wstring.sub(timeto,1,-4)
		local min_ = wstring.sub(timeto,-2,-1)
		hour = tonumber(hour_)
		min = tonumber(min_)
	else
		local _, _, hour_, min_ = wstring.find(Format_Timespan(timeto, ETimespanFormat.HrMinRounded), L"(%d+):(%d+)")
		hour, min = tonumber(hour_), tonumber(min_)
	end
	local time_text = time_to_phrase(hour, "h") .. time_to_phrase(min, "m")
	if time_text == L"" then
		time_text = L"по-малко от минута"
	end
	return time_text
end

function format_timedifference(hour,min)
	local time_text = timedifference_to_phrase(hour, "h") .. timedifference_to_phrase(min, "m")
	if time_text == L"" then time_text = L"няколко секунди" end
	return time_text
end

function format_lane_info(DescKey)
	voice_debug_log(L"TTS: DescKeyLaneinfo in: '"..DescKey..L"'", 3)
	local lane_info_str = L""
	if DescKey ~= L"" then
		if wstring.find(DescKey,L"far_left") then
			lane_info_str = L"Придържайте се в крайната лява лента."
		elseif wstring.find(DescKey,L"far_right") then
			lane_info_str = L"Придържайте се в крайната дясна лента."
		elseif wstring.find(DescKey,L"centre") then
			lane_info_str = L"Придържайте се в централната лента."
		elseif wstring.find(DescKey,L"any") then
			lane_info_str = L"Карайте във всяка лента."
		else
			local numb = tonumber(wstring.sub(DescKey, 1, 1))
			local t = {{L"", L"двете", L"трите", L"четирите", L"петте", L"шестте", L"седемте", L"осемте", L"деветте"}, {L"", L"втори", L"трети", L"четвърти", L"пети", L"шети", L"седми", L"осми", L"девети"}}
			if wstring.find(DescKey,L"side_c") then
				lane_info_str = L"Дръжте се " .. t[1][numb] .. L" лентата в средата на пътя."
			elseif wstring.find(DescKey,L"side_r") or wstring.find(DescKey,L"side_l") then
				lane_info_str = wstring.find(DescKey,L"side_r") and L"Придържайте се вдясно, без да заемате " or L"Придържайте се вляво, без да вземате "
				lane_info_str = numb == 1 and (lane_info_str .. L"крайната лента.") or (lane_info_str .. t[1][numb] .. L" крайните ленти.")
			elseif wstring.find(DescKey,L"left") then
				lane_info_str = L"Дръжте " .. t[1][numb] .. L" леви ленти."
			elseif wstring.find(DescKey,L"right") then
				lane_info_str = L"Дръжте " .. t[1][numb] .. L" десни ленти."
			elseif wstring.find(DescKey,L"middle_l") then
				lane_info_str = L"Дръжте " .. t[2][numb] .. L" ленти отляво."
			elseif wstring.find(DescKey,L"middle_r") then
				lane_info_str = L"Дръжте " .. t[2][numb] .. L" ленти отдясно."
			end
		end
	end
	voice_debug_log(L"TTS: Laneinfo out: '"..lane_info_str..L"'", 3)
	return lane_info_str
end