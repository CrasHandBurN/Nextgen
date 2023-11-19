module("VOICE")

distance_definitions = {
	["0"] = {0,0,0},
	["100"] = {100,101,91},
	["1000"] = {1000,805,805},
	["100000"] = {100000,96561,96561},
	["120"] = {120,119,122},
	["170"] = {170,165,183},
	["20"] = {20,18,15},
	["2000"] = {2000,2414,2414},
	["30"] = {30,27,30},
	["300"] = {300,293,305},
	["3000"] = {3000,3219,3219},
	["350"] = {350,347,402},
	["500"] = {500,644,644},
	["5000"] = {5000,4828,4828},
	["60"] = {60,64,61},
	["80"] = {80,82,91},
	["800"] = {800,805,805},
}

rangefun = {
	common_app_equal_300 = -1,
	common_app_range_100 = -1,
	common_app_range_120 = -1,
	common_app_range_170 = -1,
	common_app_range_350 = -1,
	common_drive_range_1000 = -1,
	common_drive_range_3000 = -1,
	common_now_equal_30 = -1,
	common_now_equal_80 = -1,
	common_now_range_0 = -1,
	common_now_range_20 = -1,
	common_now_range_60 = -1,
	common_now_range_80 = -1,
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
	highway_app_equal_300 = -1,
	highway_app_range_100 = -1,
	highway_app_range_500 = -1,
	highway_drive_range_3000 = -1,
	highway_drive_range_5000 = -1,
	highway_now_equal_30 = -1,
	highway_now_equal_300 = -1,
	highway_now_range_0 = -1,
	highway_pre_equal_3000 = -1,
	highway_pre_equal_800 = -1,
	highway_pre_range_2000 = -1,
	highway_pre_range_500 = -1,
	highway_then3_range_300 = -1,
	highway_then_range_100 = -1,
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
	fill_dist = -1,
	fill_dist2 = -1,
	fill_dist3 = -1,
	fill_exit = -1,
	fill_poi = -1,
	fill_streetname = -1,
}
