if not (MODEL.regional.current_language.lcid() == MODEL.regional.current_voice.lcid() and MODEL.regional.current_language.lcid() == sc_GetSysEntry("city_summer_speed", "lcid", 1058)) then
	ui.Plugin:unload("higher_speed_limit")
end
