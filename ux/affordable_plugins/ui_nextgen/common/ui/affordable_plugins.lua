
local ux_could_be_deleted = {
"AF_speedcam",
"and_no_speedcam",
"anim_policeman",
"Attractions",
"audio_1058",
"back_speedcam",
"big_speed_cam",
"buttons_extra",
"button_average_speed",
"button_blind",
"button_day_night",
"button_mapview_changer",
"button_memory_usage",
"button_phone",
"button_sound",
"button_speedcam_alert",
"button_suspend_resume",
"button_theme_changer",
"button_toll_roads",
"button_trip_log",
"button_war",
"clipboard_read",
"colored_buttons",
"CommonRouteWarnings",
"compass",
"compass_vw",
"ContentChanger",
"country_flag",
"externalappconfig",
"FontChanger",
"free_text_vr",
"google_contacts",
"google_search",
"higher_speed_limit",
"left_big_button",
"LuaJava",
"msg_send_tracking",
"multiplan",
"MyHolidays",
"poi_around",
"quick_tip",
"route_from_list",
"safe_mode",
"save_restore",
"screen_saver",
"send_message",
"ShowDestination",
"SkinChanger",
"StateOverview",
"SysChanger",
"TachoGuard",
"take_a_break",
"toll_booth",
"user_fonts_Roboto",
"vr",
"wizard_extension",
"zoom_button",
--"aapp_colors_arimi",
--"address_search_classic",
--"affordable_plugins",
--"alpine_phone_search",
--"android_contacts",
--"android_settings",
--"appsandtools",
--"a_round_button_blue",
--"a_round_button_bw",
--"a_round_button_default",
--"a_round_button_gold",
--"a_round_button_green",
--"a_round_button_red",
--"battery_in_menu",
--"block_route",
--"button_add_speedcam",
--"button_favorites",
--"button_GPS_2D_3D",
--"button_spare_time",
--"button_voice_queue_cleaner",
--"cockpit_buttons_on_speed",
--"connected_error_handling",
--"connected_settings",
--"country_speed_tolerance",
--"current_content_provider",
--"cursor_position",
--"debugger",
--"device",
--"Discovery",
--"driveralerts",
--"eco_umwelt_zone",
--"enhanced_junctionview",
--"favorites_change",
--"favorites_search",
--"fuel_consumption",
--"garbage_button",
--"google_preview",
--"green",
--"help",
--"hwydrive",
--"iqs",
--"junctionview",
--"keyboard",
--"labs",
--"laneinfo_blue",
--"laneinfo_bw",
--"laneinfo_gold",
--"laneinfo_green",
--"laneinfo_red",
--"loading_page",
--"local_search",
--"mapcustom",
--"motrex-kia_blue",
--"motrex-kia_bw",
--"motrex-kia_gold",
--"motrex-kia_green",
--"motrex-kia_poi",
--"motrex-kia_red",
--"naviextras",
--"navtools",
--"next_maneuver_overview",
--"notifications",
--"poi_search",
--"poi_splitscreen",
--"RemoveStopover",
--"scheme_sky",
--"SetAudioSignal",
--"SetFileList",
--"SetOfTools",
--"smartnavi",
--"speedcam",
--"statman",
--"the_skin_wandel",
--"tilt_the_map",
--"tmc",
--"tmc_online",
--"tracking",
--"triplog",
--"truck",
--"ttspro",
--"turn_restriction",
--"vehicleoverspeed",
--"vehicle_selection",
--"visual_travel_planner",
--"VWTripComputer",
--"weather",
--"width_road_320",
--"width_road_480",
--"width_road_560",
--"width_road_x2",
}

local Common_group = ""
--[[
In Lua patterns, the character class %p represents all punctuation characters, the character class %c represents all control characters,
and the character class %s represents all whitespace characters. So you can represent all punctuation characters, all control characters,
and all whitespace characters with the set [%p%c%s].
str = str:gsub('[%p%c%s]', '')
]]--
local function VW_Add_Group(g1, g2)
	return g1 .. (g1 == "" and g2 or (g2 == "" and "" or ", " .. g2))
end

local function sc_IfFindInScanUXFolderList()
	if gScanGivenFolder_done then
		MODEL.ui.lm_Plugin_List.clear()
		local str
		local t = loadstring("return {" .. VW_Add_Group(MODEL.lua.list_to_delete(), Common_group) .. "}")()
		for item in ModelList_iter(MODEL.ui.ScanGivenFolderList) do
			str = string.gsub(tostring(item.fname()), "%.zip$", "" )
			if str:lower() ~= tostring(item.fname()):lower() and in_set(str, ux_could_be_deleted) then
				ui.lm_Plugin_List:add({text = "plugin~" .. str, visible = not in_set(str:lower(), t)})
			end
		end
		ui.lm_Plugin_List:sort("text")
	else
		doDelayed(5, sc_IfFindInScanUXFolderList)
	end
end

local function VW_Mark_group(group)
	if not string.find(Common_group, group) then
		Common_group = VW_Add_Group(Common_group, group)
		sc_IfFindInScanUXFolderList()
	end
end

local VR_group = [[
	"free_text_vr",
	"vr"
	]]
function VW_Mark_VR_group()
	VW_Mark_group(VR_group:gsub('[%c]', ''):lower())
end

local LuaJava_group = [[
	"clipboard_read",
	"ContentChanger",
	"externalappconfig",
	"FontChanger",
	"google_contacts",
	"google_search",
	"LuaJava",
	"route_from_list",
	"save_restore",
	"send_message",
	"SkinChanger",
	"SysChanger"
	]]
function VW_Mark_LuaJava_group()
	VW_Mark_group(LuaJava_group:gsub('[%c]', ''):lower())
end

local function ret(...)
	return '"' .. table.concat({...}, '","') .. '"'
end
local minimal_set = ret(unpack(ux_could_be_deleted))
function VW_Make_minimal_set()
	VW_Mark_group(minimal_set:lower())
end

function VW_Remove_For_Ever(text)
	text = text or MODEL["*"].text()
	local function VW_Remove_now(list)
		local t = {
			["Mark VR group"] = VR_group:gsub('[%c]', ''),
			["Mark LuaJava group"] = LuaJava_group:gsub('[%c]', ''),
			["Make minimal set"] = minimal_set,
		}
		local plugin_to_remove = "local plugin_to_remove = {" .. t[list]:gsub('[%c]', '') .. "}"
		local chunk =
			[[
			local path = storage .. appname
			]] .. plugin_to_remove .. [[
			for i=1, #plugin_to_remove do
				os.remove(path .. "/ux/" .. plugin_to_remove[i] .. ".zip")
				--print(path .. "/ux/" .. plugin_to_remove[i] .. ".zip")
			end

			local ntime = os.time() + 5
			repeat until os.time() > ntime

			act = pm:getLaunchIntentForPackage(packageName)
			application:startActivity(act)
			----
			os.exit()
			]]
		--VW_runLuaJava(chunk, delay, f_restart, msg)
		sc_Voice_TTS(sc_translate_VoiceOrLang("RESTARTING, PLEASE WAIT..."))
		NEXTSTATE(st_RestartState)
		doDelayed(MODEL.lua.RunLuaJavaDelay(), function() VW_runLuaJava(chunk,0 , EXIT) end)
	end
    MODEL.screen.msgbox.create_from({
        line = {
			text,
            "Are you sure you want to permanently remove these items from the list?",
        },
        button = {
            {
                function() VW_Remove_now(text) end,
                m_i18n("Delete"),
                "",
                 "ico_delete.svg"
            },
            {
                "",
                m_i18n("Cancel"),
                "",
                "ico_cancel.svg"
            }
        }
    })
end
--------------------------settings-------------------------------
createState("st_Plugin_selector", {
    extends = {
		st_Common,
		st_FooterMenu,
		st_LocalMenu,
	},
	title = translate"Plugins selector",
	localmenu = "ui.lm_LocalMenuPlugin_selector",
	footermenu = "ui.lm_Plugin_selector_footer",
	useLayers = {
        "ui_Plugin_List"
    },
	enter = function()
		Common_group = ""
	end,
	done = function()
		ui.lm_Plugin_List_filtered.filter:refresh()
		MODEL.lua.list_to_delete =  ""
		if #ui.lm_Plugin_List_filtered.filter then
			local item_text = ""
			for item in ModelList_iter(ui.lm_Plugin_List_filtered.filter) do
				item_text = string.gsub(item.text():lower(), "^plugin~", "" )
				MODEL.lua.list_to_delete = MODEL.lua.list_to_delete() .. (MODEL.lua.list_to_delete() == "" and '"' or '","') .. item_text
			end
			MODEL.lua.list_to_delete = MODEL.lua.list_to_delete() .. '"'
		end
	end,
	})

function VW_st_Plugin_selector_onrelease()
	sc_ScanGivenFolder(L"%app%/ux")
	sc_IfFindInScanUXFolderList()
	sc_NextStateAnim(st_Plugin_selector, "fade", 1, "" )
end

function VW_UX_Plugin_view(text)
	local s_text = string.gsub(text, "^plugin~", "" )
	local str = wstring.gsub(translate(text), L"^" .. towstring(s_text),
			function(s)
				return MODEL["*"].visible() and VW_InsertShield("blue", s) or VW_InsertShield("yellow", s)
			end)
	return str
end

MODEL.SET.lua.unloaded_plugins_count = INT_MODEL(0)
local function VW_unloaded_plugins_count()
	local t = sc_split(MODEL.lua.list_to_delete(), ",")
	if #t then
		doDelayed(50, function()
			MODEL.lua.unloaded_plugins_count = #t
			VW_LongTextToSay(sc_translate_VoiceOrLang("Attention!!! Unloaded %s Plugins. ", #t))
			doDelayed(50*10, "MODEL.lua.unloaded_plugins_count = 0")
		end)

		doDelayed(150, function()
			MODEL.lua.Loaded_Plugins = MODEL.lua.Loaded_Plugins() - #t --to count in fact loaded
		end)
	end
end

hook_StartInit:register(function()
	VW_unloaded_plugins_count()

	--to unload if necessary
	doDelayed(400, function()
		if (MODEL.gps.current_date() >= DATETYPE.new({day=1, month=4, year=MODEL.gps.current_date().year}) and MODEL.gps.current_date() < DATETYPE.new({day=1, month=11, year=MODEL.gps.current_date().year})) then
			MODEL.lua.list_to_delete = string.gsub(MODEL.lua.list_to_delete(), "[,]?%s?\"higher_speed_limit\"", "")
			--local msg = sc_translate_VoiceOrLang("Plugin %s for %s will be loaded next start", translate"Higher speed limit", sc_GetSysEntry("city_summer_speed", "city"))
			--doDelayed(200, function() sc_InfoNotification(msg) end)
			--VW_LongTextToSay(msg)
		end
	end)

end)
-------------------------------------------------------------------------
function sc_UXInvertVisible()
	for item in ModelList_iter(MODEL.ui.lm_Plugin_List.list) do
		builtin.invert(item.visible)
    end
	sc_back_to_cockpit()
	sc_NextStateAnim(st_Plugin_selector, "fade", 1, "" )
end
function sc_UXResetVisible()
	for item in ModelList_iter(MODEL.ui.lm_Plugin_List.list) do
        item.visible(true)
    end
	sc_back_to_cockpit()
	sc_NextStateAnim(st_Plugin_selector, "fade", 1, "" )
end
--------------------------------------------------------------------------
hook_DebugSnapshot:register(function()
	UX_Name = "plugin~affordable_plugins"

	VW_Debugger_Table.start = L"********************WANDEL" .. wstring.char(0x2122) .. L"********************"
	VW_Debugger_Table.list_to_delete = MODEL.lua.list_to_delete()
	VW_Debugger_Table.start = "****************************end******************************"

end)
