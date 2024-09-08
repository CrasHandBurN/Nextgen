local lcid = {
	ua=1058,
	ru=1049,
	}

function TEXT_days_between_dates()
	local days = days_between_dates(DATETYPE.new({day=24, month=02, year=2022}), MODEL.gps.current_date())
	--WAR--
	if MODEL.regional.current_voice.lcid() == lcid.ua then
		ui.War = ansi_u16("Сьогодні ") .. days .. ansi_u16("-й день війни з російскими загарбниками. Ворог буде розбитий - перемога буде за нами. ")
	elseif MODEL.regional.current_voice.lcid() == lcid.ru then
		ui.War = ansi_u16("Сегодня ") .. days .. ansi_u16("-й день войны с русскими захватчиками. Враг будет разбит - победа будет за нами. ")
	end
	--WAR--
	--[[
	local year_month_day_date_dif = MODEL.gps.current_date() - DATETYPE.new({day=24, month=02, year=2022})
	local year_month_day_date = DATETYPE.new(year_month_day_date_dif)
	VW_Debugger(year_month_day_date.year, year_month_day_date.month, year_month_day_date.day)
	]]--
	return tostring(days)
end

--hook_CountryChanged:register(function()
hook_StartInit:register(function()
	if MODEL.regional.current_voice.lcid() == lcid.ru then
		doDelayed(400, function()
			--ui_RUSSIA:SHOW()
			doDelayed(400, function()
				ui.Notification_saved_text = War()
				ui.Notification_bg_index=2
				VW_LongTextToSay(Notification_saved_text())
				sc_InfoNotification(Notification_saved_text())
			end)
		end)
	end
end)

