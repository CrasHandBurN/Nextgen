module("VOICE")


----------------------------------------------------------------------------------------------------
---------------------------|  V O I C E   T R A N S F O R M   U T I L S  |--------------------------
----------------------------------------------------------------------------------------------------


local destname = {
    EXITNAME    = L"изход към %s",
    EXITNUMBER  = L"изход %s",
    ROADNAME    = L"по %s",
    DESTINATION = L"към %s",
    SETTLEMENT  = L"в посока към %s",
}

local number_formatter_2 = {
    -- 0x => o x
    { L"0(%d)", L"o %1" },
}

local number_formatter_3 = {
    -- 100-900 => x hundred
    { L"([1-9])00", L"%1 сто и" },
    -- 110,120...980,990
    { L"([1-9])(%d)0", L"%1 %20" },
    -- xyz => x y z
    { L"(%d)(%d)(%d)", L"%1 %2 %3" },
}

local number_formatter_4 = {
    -- 1-9000
    { L"([1-9])000", L"%1 хиляди и" },
    -- xx00
    { L"([1-9][1-9])00", L"%1 сто и" },
    -- xxx0
    { L"([1-9])([1-9])(%d)0", L"%1 %2 %30"},
    -- xyzw => x y z w
    { L"(%d)(%d)(%d)(%d)", L"%1 %2 %3 %4"},
}

-- Attol fugg hany szamjegyu a szam
local number_formatters = {
    [2] = number_formatter_2,
    [3] = number_formatter_3,
    [4] = number_formatter_4,
}

-- '0' => 'oh'
local oh_formatters = {
    {L"^0$",L"o"},
    {L"^0 ",L"o "},
    {L" 0$",L" o"},
    {L" 0 ",L" o "},
}

local function format_number(str)
    if type(str) ~= "wstring" then
        ASSERT(FALSE, "The input of format_number must be wstring. Type: "..type(str))
        return L""
    end
    local formatter = number_formatters[#str]
    if formatter then
        local rep
        for _,v in ipairs(formatter) do
            str, rep = wstring.gsub(str, v[1], v[2])
            if rep > 0 then break end
        end
        for _,v in ipairs(oh_formatters) do
	    rep = 1
            while rep > 0 do
                str, rep = wstring.gsub(str, v[1], v[2])
            end
        end
    end
    return str
end

-- 55, A55, ST45
local roadnumber_typ_patterns = {
    L"^%d+ ",
    L"^%a%d+ ",
    L"^%a%a%d+ ",
}

-- Ugy nez ki mint ha utszam lenne?
local function is_road_number(str)
    return transform_pattern_match(str, roadnumber_typ_patterns)
end

--[[
-- Ugy nez ki mint ha utszam lenne?
local function is_road_number(str)
    -- Kotojelet kivesszuk
    str = wstring.gsub(str, L"(%a)-(%a)", L"%1 %2")
    -- Szetszedjuk head (A,B,M), number (32) es tail reszekre (N)
    local _,_, head, num, tail = wstring.find(str, L"^(%a?)(%d+)(.*)$")
    if num then return true
    else return false end
end
]]

local tail_replace_map = {
	{L"%(E%)",L"Източно"},
	{L"%(W%)",L"Западно"},
	{L"%(S%)",L"Южно"},
	{L"%(N%)",L"Северно"},
	{L"%(NE%)",L"Североизточно"},
	{L"%(NW%)",L"Северозападно"},
	{L"%(SE%)",L"Югоизточно"},
	{L"%(SW%)",L"Югозападно"},
	{L"%(M%)",L"Магистрала"},
}

local function format_road_number(roadnum)
    local res
    if is_road_number(roadnum) then
        roads = transform_roadnumber_explode_eu(roadnum)
        for k, str in ipairs(roads) do
            -- Nagybetu
            str = wstring.upper(str)
            -- Kotojelbol space
            str = wstring.gsub(str, L"(%a)-(%a)", L"%1 %2")
            _,_,head,num,tail = wstring.find(str, L"^(.-)(%d+)(.-)$")
            --
            if head == L"A" then head = L"α" end
            -- Szam formazas
            num = format_number(num)
            -- Tail formazas
            tail = transform.direction_abbrev:transform(tail)
            -- Osszerakjuk
            str = table_concat({head,num,tail}, L" ")
            -- Dupla space ki
            str = wstring.gsub(str, L"%s%s+", L" ")
            -- Eltesszuk
            roads[k] = str
        end
        res = table_concat(roads, L"; ")
    else
        res = transform.roadname_abbrev_table:transform(roadnum)
    end
    return res
end

local function format_road_name(str)
    if is_road_number(str) then
    -- Ha utszamnak nez ki, akkor akkent formazzuk
        str = format_road_number(str)
    else
    -- Kulonben siman utnevnek
        str = transform.roadname_abbrev_table:transform(str)
    end
    return str
end

----------------------------------------------------------------------------------------------------
----------------------------------------|  G U I D A N C E  |---------------------------------------
----------------------------------------------------------------------------------------------------

local function format_signpost_exitnumber(str)
	local _, _, prefix, num, postfix = wstring.find(str, L"^(.-)(%d+)(.-)$")
	ASSERT(num, L"No number in format_signpost_exitnumber: "..str)
	if num then num = format_number(num) end
	-- Prefixbol kivesszuk az EXIT-et
	if prefix then prefix = wstring.gsub(wstring.upper(prefix), L"EXIT%s*", L"") end
	-- Ha van postfix (pl "140A-B" esetben)
	if postfix then postfix = wstring.gsub(postfix, L"[/-]+", L", ") end
        -- Osszefuzzuk es kesz
	return table_concat({prefix, num, postfix}, L" ")
end

local function signpost_exitnumber(data, idx)
    return transform_and_format(data[idx].signpost.exitnumber, format_signpost_exitnumber, destname.EXITNUMBER)
end

local function signpost_exitname(data, idx)
    return transform_and_format(data[idx].signpost.exitname, nil, destname.EXITNAME)
end

local function signpost_destination(data, idx)
    return transform_and_format(data[idx].signpost.destination, transform.roadname_abbrev_table,destname.DESTINATION)
end

local function signpost_settlement(data, idx)
        return transform_and_format(data[idx].signpost.settlement, transform.direction_abbrev, destname.SETTLEMENT)
end

local function signpost_roadnumber(data, idx)
    local format
    if data[idx].signpost.sign_road_branch then format = destname.ROADNAME
    else format = destname.SETTLEMENT end

    return transform_and_format(data[idx].signpost.roadnumber, format_road_number, format)
end

local function road_name(data, idx)
    return transform_and_format(data[idx].road.name, format_road_name)
end

local function road_number(data, idx)
    return transform_and_format(data[idx].road.number, format_road_number)
end

------------------------------------------|  O U T P U T  |-----------------------------------------

function format_destname(data, idx)
    local t = {}
    local out = L""
    if data[idx].signpost then
        t = transform_chain({}, signpost_exitname, 	data, idx)
	t = transform_chain(t,  signpost_exitnumber, 	data, idx)
	t = transform_chain(t,  signpost_roadnumber, 	data, idx)
	t = transform_chain(t,  signpost_destination,	data, idx)
	t = transform_chain(t,  signpost_settlement, 	data, idx)
        out = table_concat(t, L", ")
    elseif data[idx].road then
	t = transform_chain({}, road_number, data, idx)
	t = transform_chain(t,  road_name,   data, idx)
        out = wstring.format(destname.ROADNAME, table_concat(t, L", "))
    end
    return out
end

function format_streetname(data, idx)
    local t = {}
    t = transform_chain({}, road_number, 	data, idx)
    t = transform_chain(t,  road_name, 	data, idx)
    return table_concat(t, L", ")
end

----------------------------------------------------------------------------------------------------
-----------------------------------|  R O U T E   S U M M A R Y  |----------------------------------
----------------------------------------------------------------------------------------------------

function route_summary_format_road_name(data)
        return transform_and_format(data, format_road_number)
end

function route_summary_format_street_name(data)
        return transform_and_format(data, transform.roadname_abbrev_table)
end

function route_summary_format_bridge_tunnel(data)
        return transform_and_format(data, transform.roadname_abbrev_table)
end

function route_summary_format_order(data)
        return transform_and_format(data, transform.roadname_abbrev_table)
end

----------------------------------------------------------------------------------------------------
-----------------------------------------|  T R A F F I C  |----------------------------------------
----------------------------------------------------------------------------------------------------

function traffic_event_supported()
	return true
end

function traffic_event(DescKey, data)
	local str = translate_voice(DescKey)
	ASSERT(MODEL.regional.is_it_voice_localizable(DescKey), "Missing TrafficEvent dictionary.voice key:" .. DescKey)
	---- Roadnumber prioritas
	if data.roadnumber then 
		local road = transform_and_format(data.roadnumber, format_road_number, L" след %s")
		if data.from and not data.to then
		-- M7 uton Martonvasar kozeleben
			str =  str..road..L" близо до "..transform_and_format(data.from)
		elseif data.from and data.to then 
		-- M7 uton, Martonvasar es Velence kozott 
			str =  str..road..L", между "..transform_and_format(data.from)..L" и "..transform_and_format(data.to)
		else
		-- Egyeb: M7 uton
			str = str..road
		end
	---- Roadname
	elseif data.roadname then
		local road = transform_and_format(data.roadname, transform.roadname_abbrev_table, L" след %s")
		if data.from and not data.to then
			-- "," menten robbantunk
			local _,_, from, to = wstring.find(data.from.text, L"^([^,]+),(.+)$")
			if from and to then 
				str = str..road..L", в кръстовището на "..from..L" и "..to
			else 
				str = str..road..L", на кръстовището от "..transform_and_format(data.from)
			end
		elseif data.from and data.to then
			str = str..road..L", между "..transform_and_format(data.from)..L" и "..transform_and_format(data.to)
		else
			str = str..road
		end
	---- Nincs se roadnumber, se roadname 
	else
		if data.from and not data.to then
		-- Martonvasar kozeleben
			str =  str..L" близо "..transform_and_format(data.from)
		elseif data.from and data.to then 
		-- Martonvasar es Velence kozott 
			str =  str..L" между "..transform_and_format(data.from)..L" и "..transform_and_format(data.to)
		else
		-- Egyeb: semmi
		end
	end
	str = str..L"."
	return str
end



----------------------------------------------------------------------------------------------------
------------------------------------------|  D E T O U R  |-----------------------------------------
----------------------------------------------------------------------------------------------------

function format_street_name (streetname)
    if wstring.sub (streetname, 1, 9) == L "for_turns" then
        return transform_and_format (wstring.sub (streetname, 10), transform.roadname_abbrev_table, destname.ROADNAME)
    else
        return transform_and_format (streetname, transform.roadname_abbrev_table)
    end
end


----------------------------------------------------------------------------------------------------
------------------------------------------|   W I M A N   |-----------------------------------------
----------------------------------------------------------------------------------------------------

function eta(time,waypoint,currenttime)
    local head = currenttime and L"В момента е " or (waypoint and L"В междинната точка ще пристигнете в " or L"Ще пристигнете в ")
    local strmins,strhour
    local hour = time.hour
    local mins = time.min
    local wi_hour_table = {L"един часа и",L"два часа и",L"три часа и",L"четири часа и",L"пет часа и",L"шест часа и",L"седем часа и",L"осем часа и",L"девет часа и",L"десет часа и",L"единайсет часа и",L"дванайсет часа и",L"тринайсет часа и",L"четиринайсет часа и",L"петнайсет часа и",L"шестнайсет часа и",L"седемнайсет часа и",L"осемнайсет часа и",L"деветнайсет часа и",L"двайсет часа и",L"двайсет и един часа и",L"двайсет и два часа и",L"двайсет и три часа и",L"нула часа и",}
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

function timeto(timeto)
    local hournew, minsnew
    local hour = wstring.sub(timeto,1,-4)
    local mins = wstring.sub(timeto,-2,-1)
    local hournumber = tonumber(hour)
    local minsnumber = tonumber(mins)
    local replace_hourone = {
        {L"0",L" "},
        {L"1",L"един"},}
    local replace_hoursec = {
        {L"2",L"два"},
        {L"3",L"три"},
        {L"4",L"четири"},
        {L"5",L"пет"},
        {L"6",L"шест"},
        {L"7",L"седем"},
        {L"8",L"осем"},
        {L"9",L"девет"},
        {L"10",L"десет"},
        {L"11",L"единайсет"},
        {L"12",L"дванайсет"},
        {L"13",L"тринайсет"},
        {L"14",L"четиринайсет"},
        {L"15",L"петнайсет"},
        {L"16",L"шестнайсет"},
        {L"17",L"седемнайсет"},
        {L"18",L"осемнайсет"},
        {L"19",L"деветнайсет"},
        {L"20",L"двайсет"},
        {L"21",L"двайсет и един"},
        {L"22",L"двайсет и два"},
        {L"23",L"двайсет и три"},
        {L"24",L"двайсет и четири"},
        {L"25",L"двайсет и пет"},
        {L"26",L"двайсет и шест"},
        {L"27",L"двайсет и седем"},
        {L"28",L"двайсет и осем"},
        {L"29",L"двайсет и девет"},
        {L"30",L"трийсет"},
        {L"31",L"трийсет и един"},
        {L"32",L"трийсет и два"},
        {L"33",L"трийсет и три"},
        {L"34",L"трийсет и четири"},
        {L"35",L"трийсет и пет"},
        {L"36",L"трийсет и шест"},
        {L"37",L"трийсет и седем"},
        {L"38",L"трийсет и осем"},
        {L"39",L"трийсет и девет"},
        {L"40",L"четиресет"},
        {L"41",L"четиресет и един"},
        {L"42",L"четиресет и два"},
        {L"43",L"четиресет и три"},
        {L"44",L"четиресет и четири"},   
        {L"45",L"четиресет и пет"},   
        {L"46",L"четиресет и шест"},   
        {L"47",L"четиресет и седем"},   
        {L"48",L"четиресет и осем"},   
        {L"49",L"четиресет и девет"},   
        {L"50",L"петдесет"},
        {L"51",L"петдесет и един"},
        {L"52",L"петдесет и два"},
        {L"53",L"петдесет и три"},
        {L"54",L"петдесет и четири"},}
    local replace_mins = {
        {L"00",L""},
        {L"01",L"една"},
        {L"02",L"две"},
        {L"03",L"три"},
        {L"04",L"четири"},
        {L"05",L"пет"},   
        {L"06",L"шест"},       
        {L"07",L"седем"},       
        {L"08",L"осем"},
        {L"09",L"девет"},
        {L"10",L"десет"},
        {L"11",L"единайсет"},
        {L"12",L"дванайсет"},
        {L"13",L"тринайсет"},
        {L"14",L"четиринайсет"},
        {L"15",L"петнайсет"},
        {L"16",L"шестнайсет"},
        {L"17",L"седемнайсет"},
        {L"18",L"осемнайсет"},
        {L"19",L"деветнайсет"},
        {L"20",L"двайсет"},
        {L"21",L"двайсет и една"},
        {L"22",L"двайсет и две"},
        {L"23",L"двайсет и три"},
        {L"24",L"двайсет и четири"},
        {L"25",L"двайсет и пет"},
        {L"26",L"двайсет и шест"},
        {L"27",L"двайсет и седем"},
        {L"28",L"двайсет и осем"},
        {L"29",L"двайсет и девет"},
        {L"30",L"трийсет"},
        {L"31",L"трийсет и една"},
        {L"32",L"трийсет и две"},
        {L"33",L"трийсет и три"},
        {L"34",L"трийсет и четири"},
        {L"35",L"трийсет и пет"},
        {L"36",L"трийсет и шест"},
        {L"37",L"трийсет и седем"},
        {L"38",L"трийсет и осем"},
        {L"39",L"трийсет и девет"},
        {L"40",L"четиресет"},
        {L"41",L"четиресет и една"},
        {L"42",L"четиресет и две"},
        {L"43",L"четиресет и три"},
        {L"44",L"четиресет и четири"},
        {L"45",L"четиресет и пет"},
        {L"46",L"четиресет и шест"},
        {L"47",L"четиресет и седем"},
        {L"48",L"четиресет и осем"},
        {L"49",L"четиресет и девет"},
        {L"50",L"петдесет"},
        {L"51",L"петдесет и една"},
        {L"52",L"петдесет и две"},
        {L"53",L"петдесет и три"},
        {L"54",L"петдесет и четири"},       
        {L"55",L"петдесет и пет"},
        {L"56",L"петдесет и шест"},
        {L"57",L"петдесет и седем"},
        {L"58",L"петдесет и осем"},
        {L"59",L"петдесет и девет"},}
    if hournumber == 0 then
        hournew = transform_and_format(hour .. L" ",replace_hourone)
    elseif  hournumber == 1 then
	if minsnumber == 0 then
	    hournew = transform_and_format(hour .. L" час ",replace_hourone)
	else
	    hournew = transform_and_format(hour .. L" час и ",replace_hourone)
	end
    else
	if minsnumber == 0 then
	    hournew = transform_and_format(hour .. L" часa ",replace_hoursec)
	else
	    hournew = transform_and_format(hour .. L" часa и ",replace_hoursec)
	end
    end
    if minsnumber == 0 then
	if hournumber == 0 then
	    minsnew = transform_and_format(mins .. L"по малко от минутa",replace_mins)
	else
	    minsnew = transform_and_format(mins,replace_mins)
	end
    elseif  minsnumber == 1 then
        minsnew = transform_and_format(mins .. L" минутa",replace_mins)
    else
        minsnew = transform_and_format(mins .. L" минути",replace_mins)
    end
    return hournew .. minsnew
end
