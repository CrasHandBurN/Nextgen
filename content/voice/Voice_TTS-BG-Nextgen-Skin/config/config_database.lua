module("VOICE")

connections = {
	65793, 131586, 197123, 262912, 263168, 328960, 394752, 460545, 526082, 591619, 657156, 722693, 460801, 526338, 591875, 788480, 395520, 461313, 526850, 592387, 657924, 723461, 461569, 527106, 592643, 789248,
	852225, 918018, 983555, 1049350, 1114887, 1180424, 1245961, 1049354, 1051654, 1117191, 1182728, 1051657, 1051658, 1051910, 1117447, 1182984, 1051913, 1051914, 1049606, 1115143, 1180680, 1246217, 1049610, 328960, 1312256, 1379841, 1445378, 1510915, 1576459, 1641996, 1380097, 1445634, 1511171, 1576717, 1642254, 1707783, 1773320, 1838863, 1904400, 1576721, 1642258, 1378305, 1443842, 1509379, 1968141, 1640462, 1705991, 1771528, 1837071, 1902608, 1968145, 2033682, 1313024, 1378817, 1444354, 1509891, 1575435, 1640972, 1379073, 1444610, 1510147, 1968909, 1641230, 1706759, 1772296, 1837839, 1903376, 1968913, 2034450,
	2097409, 2163202, 2228739, 2294534, 2360071, 2425608, 2491145, 2294538, 2296838, 2362375, 2427912, 2296841, 2296842, 2297094, 2362631, 2428168, 2297097, 2297098, 2294790, 2360327, 2425864, 2491401, 2294794, 328960, 2557440, 2625025, 2690562, 2756099, 2821643, 2887180, 2625281, 2690818, 2756355, 2821901, 2887438, 2952967, 3018504, 3084047, 3149584, 2821905, 2887442, 2623489, 2689026, 2754563, 3213325, 2885646, 2951175, 3016712, 3082255, 3147792, 3213329, 3278866, 2558208, 2624001, 2689538, 2755075, 2820619, 2886156, 2624257, 2689794, 2755331, 3214093, 2886414, 2951943, 3017480, 3083023, 3148560, 3214097, 3279634,
	3342593, 3408386, 3473923, 3539712, 3539968, 328960, 3606016, 3673601, 3739138, 3804675, 3870219, 3935756, 3673857, 3739394, 3804931, 3870475, 3936012, 3672065, 3737602, 3803139, 3999755, 4065292, 3606784, 3672577, 3738114, 3803651, 3869195, 3934732, 3672833, 3738370, 3803907, 4066048,
	4129025, 4195072, 4195328, 331776, 4264192, 4329985, 4395531, 4461068, 4330241, 4395787, 4461324, 4327425, 4524043, 4589580, 4262144, 4327937, 4393483, 4459020, 4330497, 4592640,
	4653824, 4654080, 328960, 4720128, 4785924, 4851461, 4917248, 4720896, 4786692, 4852229, 4918016,
	4981504, 4981760, 328960, 5047808, 5113604, 5179141, 5244928, 5048576, 5114372, 5179909, 5245696,
	5313792, 5376000,
	5439745, 5505538, 5571075, 5636864, 5637120, 328960, 5703168, 5768961, 5834498, 5900035, 5965568, 5769217, 5834754, 5900291, 6031360, 5703936, 5769729, 5835266, 5900803, 5966336, 5769985, 5835522, 5901059, 6032128,
	6095616, 6095872, 328960, 6161920, 6227731, 6293268, 6227733, 6293270, 6358807, 6424344, 6490137, 6490138, 6555675, 6162688, 6228499, 6294036, 6228501, 6294038, 6359575, 6425112, 6490905, 6490906, 6556443,
	6619904, 6620160, 328960, 6686208, 6752019, 6817556, 6752021, 6817558, 6883095, 6948632, 7014425, 7014426, 7079963, 6686976, 6752787, 6818324, 6752789, 6818326, 6883863, 6949400, 7015193, 7015194, 7080731,
	7144192, 7144448, 328960, 7210496, 7276307, 7341844, 7276309, 7341846, 7407383, 7472920, 7538713, 7538714, 7604251, 7211264, 7277075, 7342612, 7277077, 7342614, 7408151, 7473688, 7539481, 7539482, 7605019,
	7668480, 7668736, 328960, 7734784, 7800595, 7866132, 7800597, 7866134, 7931671, 7997208, 8063001, 8063002, 8128539, 7735552, 7801363, 7866900, 7801365, 7866902, 7932439, 7997976, 8063769, 8063770, 8129307,
	8197651, 8263188, 8197653, 8263190, 8328727, 6559256,
	8389376, 8389632, 328960, 8455680, 8521483, 8587020, 8652800, 8456448, 8522251, 8587788, 8653568,
	8717056, 8717312, 328960, 8783360, 8849156, 8914693, 8980480, 8784128, 8849924, 8915461, 8981248,
	9049867, 9115404, 333824, 9181451, 9246988, 9312779, 9378316, 9444107, 9509644, 9182219, 9247756, 9575691, 9379084, 9444875, 9510412,
	9639691, 4200204, 333824, 9705739, 4266252, 9771531, 9837068, 9902859, 9968396, 9706507, 4267020, 9772299, 9837836, 9903627, 9969164,
	10027776, 10028032, 328960, 10094080, 10159872, 10225664, 10094848, 10160640, 10226432,
	10293248, 10362624,
	10420992, 10421248, 328960, 10487296, 10553088, 10618880, 10488064, 10553856, 10619648,
	10683136, 10683392, 328960, 10749440, 10815232, 10881024, 10750208, 10816000, 10881792,
	10945280, 10945536, 328960, 11011584, 11077376, 11143168, 11012352, 11078144, 11143936,
	11207424, 11207680, 328960, 11273728, 11339520, 11405312, 11274496, 11340288, 11406080,
	11469568, 11471872, 11472128, 11469824, 328960, 11535872, 11608075, 11542540, 11669003, 11734540, 11800331, 11865868, 11864092, 11929609, 11864074, 1640704, 11799051, 11864588, 11864860, 11930377, 11864842,
	11994131, 12059668, 11994133, 12059670, 12125207, 6095896, 8197651, 8263188, 8197653, 8263190, 8328727, 6559256,
	}

rules = {
	{32, rangefun.common_then5_range_100, None, nil},
	{16, rangefun.common_then4_range_100, None, nil},
	{8, rangefun.common_then3_range_300, None, nil},
	{1, rangefun.common_then_range_100, None, nil},
	{16777217, rangefun.common_drive_range_3000, 254, true},
	{16777224, rangefun.common_pre_range_500, 240, true},
	{16777280, rangefun.common_app_range_100, 128, nil},
	{16777344, rangefun.common_now_range_0, 8388608, nil},
	{8, rangefun.common_pre_equal_800, 240, nil},
	{64, rangefun.common_app_equal_300, 128, nil},
	{128, rangefun.common_now_equal_30, 8388608, nil},
	{4, rangefun.common_then2_range_100, None, nil},
	{2, rangefun.common_then1_range_100, None, nil},
	{16777280, rangefun.common_app_range_120, 128, nil},
	{16777344, rangefun.common_now_range_60, 8388608, nil},
	{16777217, rangefun.common_drive_range_1000, 254, true},
	{16777224, rangefun.common_pre_range_500, 240, nil},
	{16777280, rangefun.common_app_range_170, 128, nil},
	{16777344, rangefun.common_now_range_80, 8388608, nil},
	{128, rangefun.common_now_equal_80, 8388608, nil},
	{1, rangefun.common_then_range_100000, None, nil},
	{16777344, rangefun.common_now_range_20, 8388608, nil},
	{8, rangefun.highway_then3_range_300, None, nil},
	{16777217, rangefun.highway_drive_range_5000, 254, true},
	{16777224, rangefun.highway_pre_range_2000, 240, nil},
	{16777280, rangefun.highway_app_range_500, 128, nil},
	{16777344, rangefun.highway_now_range_0, 8388608, nil},
	{8, rangefun.highway_pre_equal_3000, 240, nil},
	{64, rangefun.highway_app_equal_1000, 128, nil},
	{128, rangefun.highway_now_equal_300, 8388608, nil},
	{16777344, rangefun.common_now_range_0, 8388608, true},
	{16777280, rangefun.common_app_range_350, 128, nil},
}

conditions = {
	{condfun.poi},
	{condfun.nopoi, condfun.tL_e_2},
	{condfun.nopoi, condfun.tL_e_1},
	{condfun.streetname},
	{condfun.nostreetname},
	{condfun.X_g_3},
	{condfun.X_e_3},
	{condfun.X_e_2},
	{condfun.X_e_1},
	{condfun.X_e_0},
	{condfun.destname},
	{condfun.nodestname},
	{condfun.X_g_3, condfun.destname},
	{condfun.X_g_3, condfun.nodestname},
	{condfun.X_e_1, condfun.destname},
	{condfun.X_e_1, condfun.nodestname},
	{condfun.X_e_0, condfun.destname},
	{condfun.X_e_0, condfun.nodestname},
	{condfun.destname, condfun.exit_g_1},
	{condfun.exit_g_1, condfun.nodestname},
	{condfun.destname, condfun.exit_e_1},
	{condfun.exit_e_1, condfun.nodestname},
	{condfun.destname, condfun.exit_e_0},
	{condfun.exit_e_0, condfun.nodestname},
	{condfun.exit_g_1},
	{condfun.exit_e_1},
	{condfun.exit_e_0},
	{condfun.X_g_1},
}

id = {
	continue_left = 1,
	continue_right = 2,
	continue_sharp_left = 3,
	continue_sharp_right = 4,
	continue_uturn_left = 5,
	continue_uturn_right = 6,
	deformed_roundabout_exit = 7,
	exit_left = 8,
	exit_right = 9,
	ferry = 10,
	ferry_exit = 11,
	goal = 12,
	goal_left = 13,
	goal_right = 14,
	highway_enter = 15,
	highway_leave = 16,
	keep_left = 17,
	keep_left_b = 18,
	keep_left_hwy = 19,
	keep_left_shwy = 20,
	keep_right = 21,
	keep_right_b = 22,
	keep_right_hwy = 23,
	keep_right_shwy = 24,
	left = 25,
	left_end = 26,
	priority = 27,
	priority_left = 28,
	priority_right = 29,
	ramp_left = 30,
	ramp_right = 31,
	right = 32,
	right_end = 33,
	roundabout_back = 34,
	roundabout_exit = 35,
	roundabout_h = 36,
	roundabout_l = 37,
	roundabout_left = 38,
	roundabout_right = 39,
	roundabout_straight = 40,
	sharp_left = 41,
	sharp_right = 42,
	slight_left = 43,
	slight_right = 44,
	straight = 45,
	uturn = 46,
	uturn_left = 47,
	uturn_left_dual = 48,
	uturn_right = 49,
	uturn_right_dual = 50,
	via = 51,
	via_left = 52,
	via_right = 53,
}

parameters = {
	[id.continue_left] = {then_cnt = 1, CID = 7101463, L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.continue_right] = {then_cnt = 1, CID = 7101463, L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.continue_sharp_left] = {then_cnt = 1, CID = 25189399, L"рязко", L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.continue_sharp_right] = {then_cnt = 1, CID = 25189399, L"рязко", L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.continue_uturn_left] = {then_cnt = 1, CID = 25189399, L"рязко", L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.continue_uturn_right] = {then_cnt = 1, CID = 25189399, L"рязко", L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.deformed_roundabout_exit] = {then_cnt = 1, CID = 126618630, },
	[id.exit_left] = {then_cnt = 1, CID = 95162882, L"наляво", L"наляво", L"наляво"},
	[id.exit_right] = {then_cnt = 1, CID = 95162882, L"надясно", L"надясно", L"надясно"},
	[id.ferry] = {then_cnt = 1, CID = 108793346, },
	[id.ferry_exit] = {then_cnt = 1, CID = 111150080, },
	[id.goal] = {then_cnt = 1, CID = 114036226, },
	[id.goal_left] = {then_cnt = 1, CID = 118754818, L"отляво", L"отляво", L"отляво"},
	[id.goal_right] = {then_cnt = 1, CID = 118754818, L"отдясно", L"отдясно", L"отдясно"},
	[id.highway_enter] = {then_cnt = 1, CID = 98046466, },
	[id.highway_leave] = {then_cnt = 1, CID = 100932098, },
	[id.keep_left] = {then_cnt = 1, CID = 51651075, L"в ляво", L"в ляво", L"в ляво"},
	[id.keep_left_b] = {then_cnt = 1, CID = 51651075, L"в ляво", L"в ляво", L"в ляво"},
	[id.keep_left_hwy] = {then_cnt = 1, CID = 104864258, L"в ляво", L"в ляво", L"в ляво"},
	[id.keep_left_shwy] = {then_cnt = 1, CID = 104864258, L"в ляво", L"в ляво", L"в ляво"},
	[id.keep_right] = {then_cnt = 1, CID = 51651075, L"в дясно", L"в дясно", L"в дясно"},
	[id.keep_right_b] = {then_cnt = 1, CID = 51651075, L"в дясно", L"в дясно", L"в дясно"},
	[id.keep_right_hwy] = {then_cnt = 1, CID = 104864258, L"в дясно", L"в дясно", L"в дясно"},
	[id.keep_right_shwy] = {then_cnt = 1, CID = 104864258, L"в дясно", L"в дясно", L"в дясно"},
	[id.left] = {then_cnt = 1, CID = 7101463, L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.left_end] = {then_cnt = 1, CID = 121119236, L"наляво", L"наляво", L"наляво"},
	[id.priority] = {then_cnt = 1, CID = 56889858, },
	[id.priority_left] = {then_cnt = 1, CID = 59773442, L"в ляво", L"в ляво", L"в ляво"},
	[id.priority_right] = {then_cnt = 1, CID = 59773442, L"в дясно", L"в дясно", L"в дясно"},
	[id.ramp_left] = {then_cnt = 1, CID = 7101463, L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.ramp_right] = {then_cnt = 1, CID = 7101463, L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.right] = {then_cnt = 1, CID = 7101463, L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.right_end] = {then_cnt = 1, CID = 121119236, L"надясно", L"надясно", L"надясно"},
	[id.roundabout_back] = {then_cnt = 1, CID = 81537538, },
	[id.roundabout_exit] = {then_cnt = 1, CID = 93588480, },
	[id.roundabout_h] = {then_cnt = 1, CID = 69478914, },
	[id.roundabout_l] = {then_cnt = 1, CID = 69478914, },
	[id.roundabout_left] = {then_cnt = 1, CID = 75508226, L"наляво", L"наляво", L"наляво"},
	[id.roundabout_right] = {then_cnt = 1, CID = 75508226, L"надясно", L"надясно", L"надясно"},
	[id.roundabout_straight] = {then_cnt = 1, CID = 87566850, },
	[id.sharp_left] = {then_cnt = 1, CID = 25189399, L"рязко", L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.sharp_right] = {then_cnt = 1, CID = 25189399, L"рязко", L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.slight_left] = {then_cnt = 1, CID = 43267589, L"наляво", L"наляво", L"наляво"},
	[id.slight_right] = {then_cnt = 1, CID = 43267589, L"надясно", L"надясно", L"надясно"},
	[id.straight] = {then_cnt = 1, CID = 272901, },
	[id.uturn] = {then_cnt = 1, CID = 62652929, },
	[id.uturn_left] = {then_cnt = 1, CID = 25189399, L"рязко", L"наляво", L"наляво", L"наляво", L"на левият"},
	[id.uturn_left_dual] = {then_cnt = 1, CID = 63186437, },
	[id.uturn_right] = {then_cnt = 1, CID = 25189399, L"рязко", L"надясно", L"надясно", L"надясно", L"на десният"},
	[id.uturn_right_dual] = {then_cnt = 1, CID = 63186437, },
	[id.via] = {then_cnt = 1, CID = 111676930, },
	[id.via_left] = {then_cnt = 1, CID = 116395522, L"отляво", L"отляво", L"отляво"},
	[id.via_right] = {then_cnt = 1, CID = 116395522, L"отдясно", L"отдясно", L"отдясно"},
}

patterns = {
	L"След това %poi продължете направо, %destname",
	L"След това на втория светофар продължете направо, %destname",
	L"След това на светофара продължете направо, %destname",
	L"След това продължете направо.",
	L"Продъжете направо по главния път, следващата маневра е след %dist .",
	L"След %dist продължете направо по главния път.",			-- далече
	L"След %dist %poi продължете направо, %destname  %then4",
	L"След %dist На втория светофар продължете направо, %destname  %then5",
	L"След %dist На светофара продължете направо, %destname  %then5",
	L"След %dist продължете направо %streetname  %then",
	L"След %dist продължете направо %then",
	L"Продължете направо %then",
	L"след това %poi завийте %1 %destname",
	L"след това на втория светофар %1 %destname",
	L"след това на светофара %1 %destname",
	L"след това завийте %3.",
	L"след това на третата пресечка %3.",
	L"след това на втората пресечка %3.",
	L"след това на следващата пресечка %3.",
	L"След %dist завийте %3.",
	L"След %dist %poi завийте %1 %destname %then4",
	L"На втория светофар %1 %destname %then5",
	L"На светофара %1 %destname %then5",
	L"След %dist завийте %2 %destname %then1",
	L"След %dist завийте %3 %then1",
	L"След %dist %3 %then1",
	L"След %dist %3 %then1",
	L"Сега %2 %destname %then1",
	L"Сега %3 %then1",
	L"Завийте %3 %then1",
	L"Завийте %3 %then1",
	L"След това %poi рязко %2, %destname",
	L"След това на втория светофар рязко %2, %destname",
	L"След това на светофара рязко %2, %destname",
	L"След това завийте %1 %4.",
	L"След това на третата пресечка рязко %4.",
	L"След това на втората пресечка рязко %4.",
	L"След това завийте рязко %4.",
	L"След %dist завийте рязко %4.",				-- далече
	L"След %dist %poi завийте рязко %2, %destname  %then4",
	L"След %dist На втория светофар завийте рязко %2, %destname  %then5",
	L"След %dist На светофара завийте рязко %2, %destname  %then5",
	L"След %dist %1 завийте %3 %destname  %then1",
	L"След %dist %1 завийте %4 %then1",
	L"След %dist завийте рязко %4 %then1",
	L"След %dist завийте рязко %4 %then1",
	L"На пресечката %1 %3 %destname %then1",
	L"На пресечката %1 %4 %then1",
	L"Завийте %1 %3, %destname  %then1",
	L"Завийте %1 %4 %then1",
	L"След това %poi завийте плавно %1, %destname",
	L"След това на втория светофар завийте плавно %1, %destname",
	L"След това на светофара завийте плавно %1, %destname",
	L"След това завийте плавно %3.",
	L"След %dist завийте плавно %3.",				-- далече
	L"След %dist %poi завийте плавно %1, %destname  %then4",
	L"След %dist На втория светофар завийте плавно %1, %destname  %then5",
	L"След %dist На светофара завийте плавно %1, %destname  %then5",
	L"След %dist завийте плавно %2, %destname  %then",
	L"След %dist завийте плавно %3 %then",
	L"Плавно завийте %2, %destname  %then",
	L"Плавно завийте %3 %then",
	L"След това %poi дръжте %1, %destname",
	L"След това дръжте %3",
	L"След %dist дръжте %3",					-- далече
	L"След %dist %poi дръжте %1, %destname  %then4",
	L"След %dist дръжте %2 %destname  %then",
	L"След %dist дръжте %3 %then",
	L"Дръжте %2, %destname  %then",
	L"Дръжте %3 %then",
	L"След това по главният път.",
	L"След %dist продължете по главният път.",		-- далече
	L"След %dist продължете %streetname  %then",
	L"След %dist продължете по главният път %then",
	L"Продъжете по главният път %then",
	L"След това дръжте %1 по главният път.",
	L"След %dist дръжте %1 по главният път.",			-- далече
	L"След %dist %streetname  дръжте %3 %then",
	L"След %dist дръжте %3 по главният път, %then",
	L"Дръжте %1 по главният път %then",
	L"След това обърнете където е възможно.",
	L"Обърнете където е възможно %then",
	L"След това, обърнете %poi.",
	L"След това, обърнете на втория светофар.",
	L"След това, обърнете на светофара.",
	L"След това обърнете.",
	L"След %dist обърнете.",
	L"След %dist обърнете %poi %then4",
	L"След %dist обърнете на втория светофар %then5",
	L"След %dist обърнете на светофара %then5",
	L"След %dist обърнете %then",
	L"Обърнете %then",
	L"След това влезте в кръговото",
	L"След %dist влезте в кръговото.",
	L"След %dist на кръговото излезте от %exit изход %destname  %then",
	L"След %dist на кръговото излезте от %exit изход %then",
	L"След %dist влезте в кръговото  %destname  %then",
	L"След %dist влезте в кръговото %then",
	L"На кръговото, излезте от %exit изход %then",
	L"Влезте в кръговото %then",
	L"След това завийте %1 на кръговото.",
	L"След %dist на кръговото завийте %1.",
	L"След %dist на кръговото излезте %1 от %exit изход, %destname  %then",
	L"След %dist на кръговото излезте %1 от  %exit изход %then",
	L"След %dist на кръговото %1, %destname  %then",
	L"След %dist на кръговото %1 %then",
	L"На кръговото излезте %1 от %exit изход %then",
	L"На кръговото %1 %then",
	L"След това обърнете на кръговото.",
	L"След %dist обърнете на кръговото",			
	L"След %dist обърнете на кръговото, от %exit изход %destname  %then",
	L"След %dist обърнете на кръговото, от %exit изход %then",
	L"След %dist обърнете на кръговото, %destname  %then",
	L"След %dist обърнете на кръговото %then",
	L"Обърнете на кръговото от %exit изход %then",
	L"Обърнете на кръговото %then",
	L"След това продължете направо, преминавайки кръговото.",
	L"След %dist продължете направо, преминавайки кръговото, ",
	L"След %dist продължете направо, преминавайки кръговото от %exit изход, %destname  %then",
	L"След %dist продължете направо, преминавайки кръговото от %exit изход %then",
	L"След %dist продължете направо, преминавайки кръговото, %destname  %then",
	L"След %dist продължете направо, преминавайки кръговото %then",
	L"На кръговото излезте от %exit изход %then",
	L"Продъжете направо, преминавайки кръговото %then",
	L"Излезте от %exit изход, %destname  %then",
	L"Излезте от %exit изход %then",
	L"Излезте от кръговото, %destname  %then",
	L"След това излезте %3.",
	L"След %dist излезте %1.",				-- далече
	L"След %dist излезте %1 %destname  %then",
	L"След %dist излезте %3 %then",
	L"Излезте %3 %then",
	L"След това влезте в магистралата.",
	L"След %dist влезте в магистралата.",			-- далече
---	L"След %dist влезте %streetname %then3",			--- на основа от wwt-bull: иначе два пъти "на на"
	L"След %dist продължете %streetname %then3",			--- на основа от wwt-bull: иначе два пъти "на на"
	L"След %dist влезте в магистралата %then3",
	L"Влезте в магистралата %then3",
	L"След това, излезте %destname",
	L"След това, излезте с автомагистрали.",
	L"След %dist излезте %destname",				-- далече
	L"След %dist излезте от магистралата. ",			-- далече
	L"След %dist излезте %destname  %then3",
	L"След %dist излезте от магистралата %then3",
	L"Излезте %destname %then3",
	L"Излезте от магистралата %then3",
	L"След %dist съедьте %destname %then3",
	L"след това дръжте %2 %destname",
	L"След %dist дръжте %2 %destname",
	L"След %dist дръжте %2 %destname %then3",
	L"След %dist дръжте %3 %then3",
	L"Дръжте %2 %destname %then3",
	L"Дръжте %3 %then3",
	L"След това, се качете на ферибота.",
	L"След %dist се качете на ферибота.",				-- далече
	L"След %dist се качете на ферибота.",
	L"Качете се на ферибота.",
	L"Дължината на маршрута надвишава %dist",
	L"След %dist следте от ферибота %then",
	L"там е спирката.",
	L"След %dist е спирката ви %waypointname",
	L"След %dist е спирката ви %waypointname %then",
	L"Пристигнахте в спирката си %waypointname %then",
	L"там е дестинацията ви.",
	L"След %dist е дестинацията ви %waypointname",
	L"След %dist е дестинацията ви %waypointname",
	L"Пристигнахте дестинацията си %waypointname",
	L"там е спирката ви %3.",
	L"След %dist е спирката ви %waypointname %1.",
	L"След %dist е спирката ви %waypointname %1 %then",
	L"Пристигнахте в спирката си %waypointname %3 %then",
	L"там е дестинацията ви %3.",
	L"След %dist е дестинацията ви %waypointname %1.",
	L"След %dist е дестинацията ви %waypointname %1.",
	L"Пристигнахте дестинацията си %waypointname %3.",
	L"след това завийте %3 на пресечката.",
	L"След %dist завийте %3 %destname %then",
	L"След %dist завийте %2 %then",
	L"След %dist на пресечката, завийте %2 %destname  %then",
	L"След %dist завийте %3 на пресечката %then",
	L"Завийте %2 на пресечката %destname  %then",
	L"Завийте %3 %then, в края на пътя ",
	L"Завийте %3 %then",
	L"след това излезте от %exit изход %destname",
	L"след това излезте от %exit изход.",
	L"след това на кръговото %destname",
	L"след това %poi направо.",
	L"след това на втория светофар продължете направо.",
	L"след това на светофара продължете направо.",
	L"%poi продължете направо %destname %then4",
	L"%poi продължете направо %then4",
	L"На втория светофар продължете направо %then5",
	L"На светофара продължете направо %then5",
	L"след това %poi %1 %destname",
	L"след това %poi %1.",
	L"след това на втория светофар %1.",
	L"след това на светофара %1.",
	L"след това %3.",
	L"След %dist %3.",
	L"След %dist %poi %1 %destname %then4",
	L"%poi %1 %destname %then4",
	L"%poi %1 %then4",
	L"На втория светофар %1 %then5",
	L"На светофара %1 %then5",
	L"След %dist %2 %destname %then1",
	L"След %dist %2 %then1",
	L"Сега %2 %then1",
	L"след това %poi рязко %2.",
	L"след това на втория светофар рязко %2.",
	L"след това на светофара рязко %2.",
	L"след това %1 %4.",
	L"След %dist %poi рязко %2 %destname %then4",
	L"%poi рязко %2 %destname %then4",
	L"%poi рязко %2 %then4",
	L"На втория светофар рязко %2 %then5",
	L"На светофара рязко %2 %then5",
	L"След %dist %1 %3 %destname %then1",
	L"След %dist %1 %3 %then1",
	L"След %dist %1 %4 %then1",
	L"На пресечката %1 %3 %then1",
	L"Завийте %1 %3 %then1",
	L"след това %poi плавно %1.",
	L"след това на втория светофар плавно %1.",
	L"след това на светофара плавно %1.",
	L"%poi плавно %1 %destname %then4",
	L"%poi плавно %1 %then4",
	L"На втория светофар плавно %1 %then5",
	L"На светофара плавно %1 %then5",
	L"След %dist плавно %2 %then",
	L"Плавно %2 %then",
	L"след това %poi дръжте %1.",
	L"%poi дръжте %1 %destname %then4",
	L"%poi дръжте %1 %then4",
	L"След %dist дръжте %2 %then",
	L"Дръжте %2 %then",
	L"Обърнете %poi %then4",
	L"Обърнете на втория светофар %then5",
	L"след това %1 на кръговото",
	L"След %dist на кръговото %1.",
	L"Влезте в кръговото %then",
	L"След %dist излезте %1 %then",
	L"След %dist излезте %then3",
	L"След %dist дръжте %2.",
	L"След %dist дръжте %2 %then3",
	L"Дръжте %2 %then3",
	L"след това в края на пътя %3.",
	L"След %dist %3 %destname %then",
	L"След %dist %3 %then",
	L"След %dist %2 %then",
	L"След %dist в края на пътя %2 %destname %then",
	L"След %dist в края на пътя %2 %then",
	L"След %dist в края на пътя %3 %then",
	L"на пресечката %2 %destname %then",
	L"на пресечката %2 %then",
	L"на пресечката %3 %then",
}

local pattern_variations_table = {
	[1] = "\1\129\58",
	[2] = "\2\129\59",
	[3] = "\3\129\60",
	[7] = "\7\129\61\129\62",
	[8] = "\8\129\63",
	[9] = "\9\129\64",
	[10] = "\10\11",
	[13] = "\13\129\65\129\66",
	[14] = "\14\129\67",
	[15] = "\15\129\68",
	[16] = "\16\129\69",
	[20] = "\20\129\70",
	[21] = "\21\129\71\129\72\129\73",
	[22] = "\22\129\74",
	[23] = "\23\129\75",
	[24] = "\24\129\76\129\77",
	[25] = "\25\26",
	[28] = "\28\129\78",
	[32] = "\32\129\79",
	[33] = "\33\129\80",
	[34] = "\34\129\81",
	[35] = "\35\129\82",
	[40] = "\40\129\83\129\84\129\85",
	[41] = "\41\129\86",
	[42] = "\42\129\87",
	[43] = "\43\129\88\129\89",
	[44] = "\44\129\90",
	[47] = "\47\129\91",
	[49] = "\49\129\92",
	[51] = "\51\129\93",
	[52] = "\52\129\94",
	[53] = "\53\129\95",
	[56] = "\56\129\96\129\97",
	[57] = "\57\129\98",
	[58] = "\58\129\99",
	[59] = "\59\129\100",
	[61] = "\61\129\101",
	[63] = "\63\129\102",
	[66] = "\66\129\103\129\104",
	[67] = "\67\129\105",
	[69] = "\69\129\106",
	[78] = "\78\68",
	[88] = "\88\129\107",
	[89] = "\89\129\108",
	[95] = "\95\96\99",
	[96] = "\96\99",
	[97] = "\97\98",
	[101] = "\101\129\109",
	[102] = "\102\129\110",
	[103] = "\103\104\107",
	[104] = "\104\107",
	[105] = "\105\106\108",
	[106] = "\106\108",
	[111] = "\111\112\115\116",
	[112] = "\112\115\116",
	[113] = "\113\114\116",
	[114] = "\114\116",
	[115] = "\115\116",
	[119] = "\119\120\124",
	[120] = "\120\124",
	[121] = "\121\122\124",
	[122] = "\122\124",
	[125] = "\125\126",
	[127] = "\127\129\111",
	[130] = "\129\2\129\112",
	[142] = "\129\14\129\113",
	[146] = "\129\18\129\113",
	[148] = "\129\20\129\114",
	[149] = "\129\21\129\115",
	[151] = "\129\23\129\116",
	[175] = "\129\47\129\117",
	[176] = "\129\48\129\118\129\119",
	[177] = "\129\49\129\120",
	[178] = "\129\50\129\121\129\122",
	[179] = "\129\51\129\123",
	[180] = "\129\52\129\124\129\125",
	[181] = "\129\53\129\126",
	[183] = "\129\55\129\56",
	[185] = "\129\57\93",
}
function set_pattern_variations()
	pattern_variations = sentence_variations and pattern_variations_table or {}
end

poi = {
	{cat="Accommodation\1Hotel_or_Motel",after=L"след хотела",before=L"преди хотела",by=L"при хотела",},
	{cat="Airport\1Airport_Ground",after=L"след летището",before=L"преди летището",by=L"при летището",},
	{cat="Automotive\1Car_Service",after=L"след авто сервиза",before=L"преди авто сервиза",by=L"при авто сервиза",},
	{cat="Automotive\1Dealer",after=L"след авто магазина",before=L"преди авто магазина",by=L"при авто магазина",},
	{cat="Bridge",after=L"след моста",before=L"преди моста",fromContent=0,},	
	{cat="Business\1Business_Facility",after=L"след офис сградата",before=L"преди офис сградата",by=L"при офис сградата",},
	{cat="Business\1Company",after=L"след бизнес сградата",before=L"преди бизнес сградата",by=L"при бизнес сградата",},
	{cat="Business\1Exhibition_and_Convention_Center",after=L"след изложбения център",before=L"преди изложбения център",by=L"при изложбения център",},
	{cat="Cafe_or_Bar",after=L"след кафенето",before=L"преди кафенето",by=L"при кафенето",},
	{cat="Community\1Education\1College_University",after=L"след университета",before=L"преди университета",by=L"при университета",},
	{cat="Community\1Education\1School",after=L"след училището",before=L"преди училището",by=L"при училището",},
	{cat="Community\1Government\1City_Hall",after=L"след общината",before=L"преди общината",by=L"при общината",},
	{cat="Community\1Government\1Courthouse",after=L"след сградата на съда",before=L"преди сградата на съда",by=L"при сградата на съда",},
	{cat="Community\1Government\1Embassies_and_Consulates",after=L"след посолството",before=L"преди посолството",by=L"при посолството",},
	{cat="Community\1Government\1Government_Office",after=L"след административната сграда",before=L"преди административната сграда",by=L"при административната сграда",},
	{cat="Community\1Place_of_Worship\1Church",after=L"след църквата",before=L"преди църквата",by=L"при църквата",},
	{cat="Community\1Place_of_Worship\1Mosque",after=L"след джамията",before=L"преди джамията",by=L"при джамията",},
	{cat="Community\1Place_of_Worship\1Synagogue",after=L"след синагогата",before=L"преди синагогата",by=L"при синагогата",},
	{cat="Community\1Public_Services\1Cemetery",after=L"след гробищния парк",before=L"преди гробищния парк",by=L"при гробищния парк",},
	{cat="Community\1Public_Services\1Crematorium",after=L"след крематориума",before=L"преди крематориума",by=L"при крематориума",},
	{cat="Community\1Public_Services\1Police_Station",after=L"след полицейския участък",before=L"преди полицейския участък",by=L"при полицейския участък",},
	{cat="Community\1Public_Services\1Post_Office",after=L"след пощата",before=L"преди пощата",by=L"при пощата",},
	{cat="Finance\1Bank",after=L"след банката",before=L"преди банката",by=L"при банката",},
	{cat="Leisure\1Culture\1Library",after=L"след библиотеката",before=L"преди библиотеката",by=L"при библиотеката",},
	{cat="Leisure\1Culture\1Museum",after=L"след музея",before=L"преди музея",by=L"при музея",},
	{cat="Leisure\1Culture\1Theater",after=L"след театъра",before=L"преди театъра",by=L"при театъра",},
	{cat="Leisure\1Entertainment\1Cinema",after=L"след киното",before=L"преди киното",by=L"при киното",},
	{cat="Leisure\1Entertainment\1Zoo",after=L"след зоопарка",before=L"преди зоопарка",by=L"при зоопарка",},
	{cat="Leisure\1Park_and_Recreation_Area",after=L"след парка или зоната за отдих",before=L"преди парка или зоната за отдих",by=L"при парка или зоната за отдих",},
	{cat="Leisure\1Park_and_Recreation_Area",after=L"след парка",before=L"преди парка",by=L"при парка",},
	{cat="Medical\1Hospital_or_Polyclinic",after=L"след болницата",before=L"преди болницата",by=L"при болницата",},
	{cat="Medical\1Pharmacy",after=L"след аптеката",before=L"преди аптеката",by=L"при аптеката",},
	{cat="Parking\1Open_Parking_Area",after=L"след безплатния паркинг",before=L"преди безплатния паркинг",by=L"при безплатния паркинг",},
	{cat="Parking\1Park_and_Ride",after=L"след паркинга",before=L"преди паркинга",by=L"при паркинга",},
	{cat="Parking\1Parking_Garage",after=L"след закрития паркинг",before=L"преди закрития паркинг",by=L"при закрития паркинг",},
	{cat="Parking\1Rest_Area",after=L"след мястото за почивка",before=L"преди мястото за почивка",by=L"при мястото за почивка",},
	{cat="Petrol_Station",after=L"след бензиностанцията",before=L"преди бензиностанцията",by=L"на бензиностанцията",},
	{cat="Petrol_Station\1Bp",after=L"след бензиностанцията Би Пи",before=L"преди заправкой Би Пи",by=L"при бензиностанцията Би Пи",},
	{cat="Petrol_Station\1Eco'",after=L"след бензиностанцията Еко",before=L"преди бензиностанцията Еко",by=L"при бензиностанцията",},
	{cat="Petrol_Station\1Gazprom",after=L"след Газпром",before=L"преди Газпром",by=L"при Газпром",},
	{cat="Petrol_Station\1Gazprom",after=L"след бензиностанцията Газ Пром",before=L"преди заправкой Газ Пром",by=L"при бензиностанцията Газ Пром",},
	{cat="Petrol_Station\1Gazpromneft'",after=L"след бензиностанцията Газ Пром Нефт'",before=L"преди заправкой Газ Пром Нефт'",by=L"при бензиностанцията Газ Пром Нефт'",},
	{cat="Petrol_Station\1Lukoil'",after=L"след Лукойл",before=L"преди Лукойл",by=L"при Лукойл",},
	{cat="Petrol_Station\1Mtk",after=L"след бензиностанцията Ем Те Ка",before=L"преди заправкой Ем Те Ка",by=L"при бензиностанцията Ем Те Ка",},
	{cat="Petrol_Station\1OMV'",after=L"след бензиностанцията О Ем Ви",before=L"преди бензиностанцията О Ем Ви",by=L"при бензиностанцията О Ем Ви",},
	{cat="Petrol_Station\1Petrol",after=L"след Петрол",before=L"преди Петрол",by=L"при Петрол",},
	{cat="Petrol_Station\1Rompetrol",after=L"след Ромпетрол",before=L"преди Ромпетрол",by=L"при Ромпетрол",},
	{cat="Petrol_Station\1Rosneft'",after=L"след бензиностанцията Рос Нефт'",before=L"преди бензиностанцията Рос Нефт'",by=L"при бензиностанцията Рос Нефт'",},
	{cat="Petrol_Station\1Rostneft'",after=L"след бензиностанцията Рост Нефт'",before=L"преди заправкой Рост Нефт'",by=L"при бензиностанцията Рост Нефт'",},
	{cat="Petrol_Station\1Shell'",after=L"след бензиностанцията Шел",before=L"преди бензиностанцията Шел",by=L"при бензиностанцията Шел",},
	{cat="Petrol_Station\1Tnk",after=L"след бензиностанцията Те Ен Ка",before=L"преди заправкой Те Ен Ка",by=L"при бензиностанцията Те Ен Ка",},
	{cat="Police Posts",after=L"след полицейския пост",before=L"преди полицейския пост",by=L"при полицейския пост",},
	{cat="Restaurant\1Fast_Food\1McDonald's",after=L"след Макдоналдс",before=L"преди Макдоналдс",by=L"при Макдоналдс",},
	{cat="Restaurant\1Fast_Food\1Subway",after=L"след Суб Вей",before=L"преди Суб Вей",by=L"при Суб Вей",},
	{cat="Shopping\1Shop",after=L"след магазина",before=L"преди магазина",by=L"при магазина",},
	{cat="Shopping\1Shop\1Convenience_Store",after=L"след денонощния магазин",before=L"преди денонощния магазин",by=L"при денонощния магазин",},
	{cat="Shopping\1Shop\1Drug_store",after=L"след аптеката",before=L"преди аптеката",by=L"при аптеката",},
	{cat="Shopping\1Shop\1Electrical_Office_and_IT",after=L"след електромагазина",before=L"преди електромагазина",by=L"при електромагазина",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Auchan",after=L"след магазина Ашан",before=L"преди магазина Ашан",by=L"при магазина Ашан",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Billa",after=L"след магазина Била",before=L"преди магазина Била",by=L"при магазина Била",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Jumbo",after=L"след магазина Джъмбо",before=L"преди магазина Джъмбо",by=L"при магазина Джъмбо",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Kaufland",after=L"след магазина Кауфланд",before=L"преди магазина Кауфланд",by=L"при магазина Кауфланд",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Lidl",after=L"след магазина магазина Лидъл",before=L"преди магазина Лидъл",by=L"при магазина Лидъл",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Metro",after=L"след магазина Метро",before=L"преди магазина Метро",by=L"при магазина Метро",},
	{cat="Shopping\1Shop\1Food_and_Drink\1Praktiker",after=L"след магазина Практикер",before=L"преди магазина Практикер",by=L"при магазина Практикер",},
	{cat="Shopping\1Shop\1Gifts_Cards_Novelties_and_Souvenirs",after=L"след магазина за подаръци",before=L"преди магазина за подаръци",by=L"при магазина за подаръци",},
	{cat="Shopping\1Shopping_Center",after=L"след търговския център",before=L"преди търговския център",by=L"при търговския център",},
	{cat="Shopping\1Super_Market_and_Hypermarket",after=L"след супермаркета",before=L"преди супермаркета",by=L"при супермаркета",},
	{cat="Shopping\1Warehouse",after=L"след склада",before=L"преди склада",by=L"при склада",},
	{cat="Sports\1Stadium",after=L"след стадиона",before=L"преди стадиона",by=L"при стадиона",},
	{cat="Sports\1Swimming_Pool",after=L"след басейна",before=L"преди басейна",by=L"при басейна",},
	{cat="Subway_Station",after=L"след метростанцията",before=L"преди метростанцията",by=L"при метростанцията",},
	{cat="Traffic light",after=L"след светофара",before=L"преди светофара",by=L"на светофара",},
	{cat="Transport\1Ground_Transport\1Bus_Terminal",after=L"след автогарата",before=L"преди автогарата",by=L"при автогарата",},
	{cat="Transport\1Public_Transport\1Bus_Stop",after=L"след автобусната спирка",before=L"преди автобусната спирка",by=L"при автобусната спирка",},
	{cat="Tunnel",after=L"след тунела",before=L"преди тунела",fromContent=0,},
}


sentence_types = {
	app = 64,
	app1 = 32,
	app2 = 16,
	drive = 1,
	more = 16777216,
	now = 128,
	pre = 8,
	pre1 = 4,
	pre2 = 2,
	stop = 8388608,
}

then_types = {
	["then"] = 1,
	["then1"] = 3,
	["then2"] = 5,
	["then3"] = 9,
	["then4"] = 17,
	["then5"] = 33,
}

