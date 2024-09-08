------------------------WANDEL™------------------------
MODEL.SET.lua.higher_speed_limitActive = BOOL_MODEL(false)
--sc_GetAdvancedSpeedLimitPhase = sc_GetAdvancedSpeedLimit_Phase --due to ui used. No replacement is working. Now all are in ui
local VW_SpeedLimitFunction_Orig = VW_SpeedLimitFunction

function VW_ReturnPosition(lat_, lon_)
	return GCOOR.new({lat = parse_gcoor(lat_), lon = parse_gcoor(lon_)})
end

Kyiv = GCOOR.new({lat = parse_gcoor("N50.438122"), lon = parse_gcoor("E30.547404")})

local speed_limit_extra, current_index
local timer = 10
function VW_higher_speed_limit()
	local current_street = MODEL.navigation.car.current_street()
	if (MODEL.gps.current_date() >= DATETYPE.new({day=1, month=4, year=MODEL.gps.current_date().year}) and MODEL.gps.current_date() < DATETYPE.new({day=1, month=11, year=MODEL.gps.current_date().year})) then
		if #current_street then
			local list = MODEL.ui.lm_higher_speed_limit_StreetList
			for i=0, #list - 1 do --!!!!!!!!!!!!becouse of sort_by
				if wstring.find(current_street, list[i].street(), 1, true) then
					current_index = i
					speed_limit_extra = list[i].speed_limit()
					VW_SpeedLimitFunction = function()
						if MODEL.lua.VehicleOverspeed() then
							local maxspeed = MODEL.mydata.vehicle_profile.list[MODEL.mydata.vehicle_profile.selected_profile()].maxspeed()
							if maxspeed > 0 and maxspeed < speed_limit_extra then
								return maxspeed
							end
						end
						return speed_limit_extra
					end
					VW_RegisterDistortion(timer, MODEL.lua.SpeedLimitValueTrigger)
					MODEL.lua.higher_speed_limitActive = true
					return
				end
			end
			VW_SpeedLimitFunction = VW_SpeedLimitFunction_Orig
			VW_RegisterDistortion(timer, MODEL.lua.SpeedLimitValueTrigger)
			MODEL.lua.higher_speed_limitActive = false
		end
	else
		hook_Street_changed:unregister(VW_higher_speed_limit)
		VW_SpeedLimitFunction = VW_SpeedLimitFunction_Orig
		VW_RegisterDistortion(timer, MODEL.lua.SpeedLimitValueTrigger)
		MODEL.lua.higher_speed_limitActive = false
	end
end

function VW_higher_speed_limit_Off() --new 26.07.2020
	MODEL.ui.lm_higher_speed_limit_StreetList.list[current_index].visible = 0
	VW_higher_speed_limit()
end

hook_City_changed:register(function()
	if VW_GetIconByIconID(MODEL.other.contents.list[current].prov_icon_id()) == "here.svg" and
		MODEL.navigation.car.address.city() == sc_GetSysEntry("city_summer_speed", "city") and
		MODEL.regional.current_language.lcid() == MODEL.regional.current_voice.lcid() and
		MODEL.regional.current_language.lcid() == sc_GetSysEntry("city_summer_speed", "lcid", 1058) and
		(MODEL.gps.current_date() >= DATETYPE.new({day=1, month=4, year=MODEL.gps.current_date().year}) and MODEL.gps.current_date() < DATETYPE.new({day=1, month=11, year=MODEL.gps.current_date().year}))
	then
		hook_Street_changed:register(VW_higher_speed_limit)
	elseif #MODEL.navigation.car.address.city() then
		hook_Street_changed:unregister(VW_higher_speed_limit)
		VW_SpeedLimitFunction = VW_SpeedLimitFunction_Orig
		VW_RegisterDistortion(timer, MODEL.lua.SpeedLimitValueTrigger)
		MODEL.lua.higher_speed_limitActive = false
	end
end)

hook_StartInit:register(function()
	local t = wsplit(sc_GetSysEntry("city_summer_speed", "streets", L""), L",%s?")
	local t2 = {}
	if #t then
		MODEL.ui.lm_higher_speed_limit_StreetList.clear()
		for i=1, #t do
			t2 = wsplit(t[i], L":")
			ui.lm_higher_speed_limit_StreetList:add({
				street = t2[1],
				speed_limit = tonumber(t2[2]) or nil,
				from_gcoor = ( t2[3] and t2[4] ) and VW_ReturnPosition(tostring(t2[3]), tostring(t2[4])) or nil,
				to_gcoor = ( t2[5] and t2[6] ) and VW_ReturnPosition(tostring(t2[3]), tostring(t2[4])) or nil,
				})
		end
	end

	--to unload if necessary
	doDelayed(400, function()
		if not (MODEL.gps.current_date() >= DATETYPE.new({day=1, month=4, year=MODEL.gps.current_date().year}) and MODEL.gps.current_date() < DATETYPE.new({day=1, month=11, year=MODEL.gps.current_date().year})) then
			MODEL.lua.list_to_delete = MODEL.lua.list_to_delete() .. (MODEL.lua.list_to_delete() == "" and '"' or ', "') .. "higher_speed_limit" .. '"'
			local msg = sc_translate_VoiceOrLang("Plugin %s for %s will be unloaded next start", translate"Higher speed limit", sc_GetSysEntry("city_summer_speed", "city"))
			doDelayed(200, function() sc_InfoNotification(msg) end)
			--VW_LongTextToSay(msg)
		end
	end)

end)

createState("st_higher_speed_limit", {
    extends = {
		st_Common,
	},
	title = translate"Higher speed limit" .. L": " .. sc_GetSysEntry("city_summer_speed", "city"),
	useLayers = {
        "ui_higher_speed_limit"
    },
})

function VW_ShowStreets()
	sc_NextStateAnim(st_higher_speed_limit, "fade", 1, "" )
end

createState("st_MapOverviewOnStreet", {
    extends = {
		st_CommonMap,
		},
    useLayers = {
        "ui_MapOverviewOnStreet"
    },
    mapstate = "overviewmap",
    onmapclick = sc_EmptyMapClick,
	title = "",
    getFitbox = function()
        return ui.fitbox_MapOverviewOnStreet.X, ui.fitbox_MapOverviewOnStreet.Y, ui.fitbox_MapOverviewOnStreet.W, ui.fitbox_MapOverviewOnStreet.H
    end,
	enter = function()
		SELF.title = MODEL["*"].street() or MODEL.ui.lm_higher_speed_limit_StreetList.list[current_index].street()
	end,
    init = function()
        local mapLayer = MODEL.map.primary
        mapLayer.highlight_color = "planned_road_alt3"
        sc_SelectMapProfile(gMinimalColor_Name, gMinimalColorNight_Name)
        --MODEL.map.primary.route_model = "nonexistent,quickdetour:2,navigated:1"

        sc_Fit_To_Screen(
			MODEL["*"].from_gcoor() or MODEL.ui.lm_higher_speed_limit_StreetList.list[current_index].from_gcoor(),
			MODEL["*"].to_gcoor() or MODEL.ui.lm_higher_speed_limit_StreetList.list[current_index].to_gcoor()
			)
    end,
    done = function()
        local primary = MODEL.map.primary
        --primary.route_model = ""
        primary.highlight_color = ""
        sc_SelectOriginalMapProfile()
        MODEL.lua.MapHeaderMode = "normal"
    end,
})

function VW_ShowStreetOnMap()
	sc_NextStateAnim(st_MapOverviewOnStreet, "fade", 1, "")
end

---------------------------------debugger--------------------------------
hook_DebugSnapshot:register(function()
	UX_Name = "plugin~higher_speed_limit"

	VW_Debugger_Table.start = L"********************WANDEL" .. wstring.char(0x2122) .. L"********************"
	VW_Debugger_Table.higher_speed_limitActive = MODEL.lua.higher_speed_limitActive()
	VW_Debugger_Table.end_ = "****************************end******************************"

end)
