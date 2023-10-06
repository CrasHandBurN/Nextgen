module("VOICE")



distance_definitions = {
	["0"] = {0,0,0},
	["100"] = {100,100,100},
	["1000"] = {1000,1000,1000},
	["100000"] = {100000,100000,100000},
	["250"] = {250,250,250},
	["280"] = {280,280,280},
	["40"] = {40,40,40},
	["2000"] = {2000,2000,2000},
	["30"] = {30,30,30},
	["300"] = {300,300,300},
	["3000"] = {3000,3000,3000},
	["350"] = {350,350,350},
	["500"] = {500,500,500},
	["5000"] = {5000,5000,5000},
	["70"] = {70,70,70},
	["90"] = {90,90,90},
	["800"] = {800,800,800},
}



rangefun = {
	common_app_equal_300 = -1,
	common_app_range_100 = -1,
	common_app_range_250 = -1,
	common_app_range_280 = -1,
	common_app_range_350 = -1,
	common_drive_range_1000 = -1,
	common_drive_range_3000 = -1,
	common_now_equal_30 = -1,
	common_now_equal_70 = -1,
	common_now_range_0 = -1,
	common_now_range_40 = -1,
	common_now_range_70 = -1,
	common_now_range_90 = -1,
	common_pre_equal_800 = -1,
	common_pre_range_500 = -1,
	common_then1_range_100 = -1,
	common_then2_range_100 = -1,
	common_then3_range_300 = -1,
	common_then4_range_100 = -1,
	common_then5_range_100 = -1,
	common_then_range_100 = -1,
	common_then_range_100000 = -1,
	highway_app_equal_1000 = -1,
	highway_app_range_500 = -1,
	highway_drive_range_5000 = -1,
	highway_now_equal_300 = -1,
	highway_now_range_0 = -1,
	highway_pre_equal_3000 = -1,
	highway_pre_range_2000 = -1,
	highway_then3_range_300 = -1,
}



condfun = {
	X_e_0 = -1,
	X_e_1 = -1,
	X_e_2 = -1,
	X_e_3 = -1,
	X_g_1 = -1,
	X_g_3 = -1,
	destname = -1,
	exit_e_0 = -1,
	exit_e_1 = -1,
	exit_g_1 = -1,
	nodestname = -1,
	nopoi = -1,
	nostreetname = -1,
	poi = -1,
	streetname = -1,
	tL_e_1 = -1,
	tL_e_2 = -1,
}

fill_functions = {
	fill_destname = -1,
	fill_dist2 = -1,
	fill_dist3 = -1,
	fill_exit = -1,
	fill_poi = -1,
	fill_streetname = -1,
}
