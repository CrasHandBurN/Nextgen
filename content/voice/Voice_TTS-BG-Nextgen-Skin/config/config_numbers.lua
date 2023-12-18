module("VOICE")

distances = {}

distances.patterns = {
	L"осем",
	L"осемнадесет",
	L"осемдесет",
	L"осемстотин",
	L"два",
	L"две",
	L"дванадесет",
	L"двадесет",
	L"двеста",
	L"девет",
	L"деветнадесет",
	L"деветдесет",
	L"деветстотин",
	L"десет",
	L"и половина",
	L"и",
	L"километър ",
	L"километра ",
	L"километра ",
	L"километра ",
	L"метра ",
	L"мили ",
	L"мили ",
	L"миля ",
	L"един",
	L"единадесет",
	L"една",
	L"един и половина",
	L"половин миля",
	L"пет",
	L"петнадесет",
	L"петдесет",
	L"петстотин",
	L"седем",
	L"седемнадесет",
	L"седемдесет",
	L"седемстотин",
	L"четиридесет",
	L"сто",
	L"три",
	L"тринадесет",
	L"тридесет",
	L"триста",
	L"хиляда",
	L"фута",
	L"четвърт",
	L"четири",
	L"четиринадесет",
	L"четиристотин",
	L"шест",
	L"шестнадесет",
	L"шестдесет",
	L"шестстотин",
	L"ярда",
	L"една десета",
	L"две десети",
	L"3 десети",
	L"4 десети",
	L"5 десети",
	L"6 десети",
	L"7 десети",
	L"8 десети",
	L"9 десети",
}

function set_distances_meters()
	distances.meters = {
	10, "\14\21\0",
	20, "\8\21\0",
	30, "\42\21\0",
	40, "\38\21\0",
	50, "\32\21\0",
	60, "\52\21\0",
	70, "\36\21\0",
	80, "\3\21\0",
	90, "\12\21\0",
	100, "\39\21\0",
	200, "\9\21\0",
	300, "\43\21\0",
	400, "\49\21\0",
	500, "\33\21\0",
	600, "\53\21\0",
	700, "\37\21\0",
	800, "\4\21\0",
	900, "\13\21\0",
	1000, "\25\17\0",
	1100, (numbers_mode and "\25\16\56\18\0" or "\25\17\39\21\0"),
	1200, (numbers_mode and "\25\16\57\18\0" or "\25\17\9\21\0"),
	1300, (numbers_mode and "\25\16\58\18\0" or "\25\17\43\21\0"),
	1400, (numbers_mode and "\25\16\59\18\0" or "\25\17\49\21\0"),
	1500, (numbers_mode and "\28\18\0" or "\25\17\33\21\0"),
	1600, (numbers_mode and "\25\16\60\18\0" or "\25\17\53\21\0"),
	1700, (numbers_mode and "\25\16\61\18\0" or "\25\17\37\21\0"),
	1800, (numbers_mode and "\25\16\62\18\0" or "\25\17\4\21\0"),
	1900, (numbers_mode and "\25\16\63\18\0" or "\25\17\13\21\0"),
	2000, "\5\20\0",
	2100, (numbers_mode and "\5\16\56\18\0" or "\5\20\39\21\0"),
	2200, (numbers_mode and "\5\16\57\18\0" or "\5\20\9\21\0"),
	2300, (numbers_mode and "\5\16\58\18\0" or "\5\20\43\21\0"),
	2400, (numbers_mode and "\5\16\59\18\0" or "\5\20\49\21\0"),
	2500, (numbers_mode and "\5\15\20\0" or "\5\20\33\21\0"),
	2600, (numbers_mode and "\5\16\60\18\0" or "\5\20\53\21\0"),
	2700, (numbers_mode and "\5\16\61\18\0" or "\5\20\37\21\0"),
	2800, (numbers_mode and "\5\16\62\18\0" or "\5\20\4\21\0"),
	2900, (numbers_mode and "\5\16\63\18\0" or "\5\20\13\21\0"),
	3000, "\40\20\0",
	3100, (numbers_mode and "\40\16\56\18\0" or "\40\20\39\21\0"),
	3200, (numbers_mode and "\40\16\57\18\0" or "\40\20\9\21\0"),
	3300, (numbers_mode and "\40\16\58\18\0" or "\40\20\43\21\0"),
	3400, (numbers_mode and "\40\16\59\18\0" or "\40\20\49\21\0"),
	3500, (numbers_mode and "\40\15\20\0" or "\40\20\33\21\0"),
	3600, (numbers_mode and "\40\16\60\18\0" or "\40\20\53\21\0"),
	3700, (numbers_mode and "\40\16\61\18\0" or "\40\20\37\21\0"),
	3800, (numbers_mode and "\40\16\62\18\0" or "\40\20\4\21\0"),
	3900, (numbers_mode and "\40\16\63\18\0" or "\40\20\13\21\0"),
	4000, "\47\20\0",
	4100, (numbers_mode and "\47\16\56\18\0" or "\47\20\39\21\0"),
	4200, (numbers_mode and "\47\16\57\18\0" or "\47\20\9\21\0"),
	4300, (numbers_mode and "\47\16\58\18\0" or "\47\20\43\21\0"),
	4400, (numbers_mode and "\47\16\59\18\0" or "\47\20\49\21\0"),
	4500, (numbers_mode and "\47\15\20\0" or "\47\20\33\21\0"),
	4600, (numbers_mode and "\47\16\60\18\0" or "\47\20\53\21\0"),
	4700, (numbers_mode and "\47\16\61\18\0" or "\47\20\37\21\0"),
	4800, (numbers_mode and "\47\16\62\18\0" or "\47\20\4\21\0"),
	4900, (numbers_mode and "\47\16\63\18\0" or "\47\20\13\21\0"),
	5000, "\30\19\0",
	5100, (numbers_mode and "\30\16\56\18\0" or "\30\19\39\21\0"),
	5200, (numbers_mode and "\30\16\57\18\0" or "\30\19\9\21\0"),
	5300, (numbers_mode and "\30\16\58\18\0" or "\30\19\43\21\0"),
	5400, (numbers_mode and "\30\16\59\18\0" or "\30\19\49\21\0"),
	5500, (numbers_mode and "\30\15\19\0" or "\30\19\33\21\0"),
	5600, (numbers_mode and "\30\16\60\18\0" or "\30\19\53\21\0"),
	5700, (numbers_mode and "\30\16\61\18\0" or "\30\19\37\21\0"),
	5800, (numbers_mode and "\30\16\62\18\0" or "\30\19\4\21\0"),
	5900, (numbers_mode and "\30\16\63\18\0" or "\30\19\13\21\0"),
	6000, "\50\19\0",
	6100, (numbers_mode and "\50\16\56\18\0" or "\50\19\39\21\0"),
	6200, (numbers_mode and "\50\16\57\18\0" or "\50\19\9\21\0"),
	6300, (numbers_mode and "\50\16\58\18\0" or "\50\19\43\21\0"),
	6400, (numbers_mode and "\50\16\59\18\0" or "\50\19\49\21\0"),
	6500, (numbers_mode and "\50\15\19\0" or "\50\19\33\21\0"),
	6600, (numbers_mode and "\50\16\60\18\0" or "\50\19\53\21\0"),
	6700, (numbers_mode and "\50\16\61\18\0" or "\50\19\37\21\0"),
	6800, (numbers_mode and "\50\16\62\18\0" or "\50\19\4\21\0"),
	6900, (numbers_mode and "\50\16\63\18\0" or "\50\19\13\21\0"),
	7000, "\34\19\0",
	7100, (numbers_mode and "\34\16\56\18\0" or "\34\19\39\21\0"),
	7200, (numbers_mode and "\34\16\57\18\0" or "\34\19\9\21\0"),
	7300, (numbers_mode and "\34\16\58\18\0" or "\34\19\43\21\0"),
	7400, (numbers_mode and "\34\16\59\18\0" or "\34\19\49\21\0"),
	7500, (numbers_mode and "\34\15\19\0" or "\34\19\33\21\0"),
	7600, (numbers_mode and "\34\16\60\18\0" or "\34\19\53\21\0"),
	7700, (numbers_mode and "\34\16\61\18\0" or "\34\19\37\21\0"),
	7800, (numbers_mode and "\34\16\62\18\0" or "\34\19\4\21\0"),
	7900, (numbers_mode and "\34\16\63\18\0" or "\34\19\13\21\0"),
	8000, "\1\19\0",
	8100, (numbers_mode and "\1\16\56\18\0" or "\1\19\39\21\0"),
	8200, (numbers_mode and "\1\16\57\18\0" or "\1\19\9\21\0"),
	8300, (numbers_mode and "\1\16\58\18\0" or "\1\19\43\21\0"),
	8400, (numbers_mode and "\1\16\59\18\0" or "\1\19\49\21\0"),
	8500, (numbers_mode and "\1\15\19\0" or "\1\19\33\21\0"),
	8600, (numbers_mode and "\1\16\60\18\0" or "\1\19\53\21\0"),
	8700, (numbers_mode and "\1\16\61\18\0" or "\1\19\37\21\0"),
	8800, (numbers_mode and "\1\16\62\18\0" or "\1\19\4\21\0"),
	8900, (numbers_mode and "\1\16\63\18\0" or "\1\19\13\21\0"),
	9000, "\10\19\0",
	9100, (numbers_mode and "\10\16\56\18\0" or "\10\19\39\21\0"),
	9200, (numbers_mode and "\10\16\57\18\0" or "\10\19\9\21\0"),
	9300, (numbers_mode and "\10\16\58\18\0" or "\10\19\43\21\0"),
	9400, (numbers_mode and "\10\16\59\18\0" or "\10\19\49\21\0"),
	9500, (numbers_mode and "\10\15\19\0" or "\10\19\33\21\0"),
	9600, (numbers_mode and "\10\16\60\18\0" or "\10\19\53\21\0"),
	9700, (numbers_mode and "\10\16\61\18\0" or "\10\19\37\21\0"),
	9800, (numbers_mode and "\10\16\62\18\0" or "\10\19\4\21\0"),
	9900, (numbers_mode and "\10\16\63\18\0" or "\10\19\13\21\0"),
	10000, "\14\19\0",
	11000, "\26\19\0",
	12000, "\7\19\0",
	13000, "\41\19\0",
	14000, "\48\19\0",
	15000, "\31\19\0",
	16000, "\51\19\0",
	17000, "\35\19\0",
	18000, "\2\19\0",
	19000, "\11\19\0",
	20000, "\8\19\0",
	21000, "\8\25\17\0",
	22000, "\8\5\20\0",
	23000, "\8\40\20\0",
	24000, "\8\47\20\0",
	25000, "\8\30\19\0",
	26000, "\8\50\19\0",
	27000, "\8\34\19\0",
	28000, "\8\1\19\0",
	29000, "\8\10\19\0",
	30000, "\42\19\0",
	31000, "\42\25\17\0",
	32000, "\42\5\20\0",
	33000, "\42\40\20\0",
	34000, "\42\47\20\0",
	35000, "\42\30\19\0",
	36000, "\42\50\19\0",
	37000, "\42\34\19\0",
	38000, "\42\1\19\0",
	39000, "\42\10\19\0",
	40000, "\38\19\0",
	41000, "\38\25\17\0",
	42000, "\38\5\20\0",
	43000, "\38\40\20\0",
	44000, "\38\47\20\0",
	45000, "\38\30\19\0",
	46000, "\38\50\19\0",
	47000, "\38\34\19\0",
	48000, "\38\1\19\0",
	49000, "\38\10\19\0",
	50000, "\32\19\0",
	51000, "\32\25\17\0",
	52000, "\32\5\20\0",
	53000, "\32\40\20\0",
	54000, "\32\47\20\0",
	55000, "\32\30\19\0",
	56000, "\32\50\19\0",
	57000, "\32\34\19\0",
	58000, "\32\1\19\0",
	59000, "\32\10\19\0",
	60000, "\52\19\0",
	61000, "\52\25\17\0",
	62000, "\52\5\20\0",
	63000, "\52\40\20\0",
	64000, "\52\47\20\0",
	65000, "\52\30\19\0",
	66000, "\52\50\19\0",
	67000, "\52\34\19\0",
	68000, "\52\1\19\0",
	69000, "\52\10\19\0",
	70000, "\36\19\0",
	71000, "\36\25\17\0",
	72000, "\36\5\20\0",
	73000, "\36\40\20\0",
	74000, "\36\47\20\0",
	75000, "\36\30\19\0",
	76000, "\36\50\19\0",
	77000, "\36\34\19\0",
	78000, "\36\1\19\0",
	79000, "\36\10\19\0",
	80000, "\3\19\0",
	81000, "\3\25\17\0",
	82000, "\3\5\20\0",
	83000, "\3\40\20\0",
	84000, "\3\47\20\0",
	85000, "\3\30\19\0",
	86000, "\3\50\19\0",
	87000, "\3\34\19\0",
	88000, "\3\1\19\0",
	89000, "\3\10\19\0",
	90000, "\12\19\0",
	91000, "\12\25\17\0",
	92000, "\12\5\20\0",
	93000, "\12\40\20\0",
	94000, "\12\47\20\0",
	95000, "\12\30\19\0",
	96000, "\12\50\19\0",
	97000, "\12\34\19\0",
	98000, "\12\1\19\0",
	99000, "\12\10\19\0",
	100000, "\39\19\0",
	110000, "\39\14\19\0",
	120000, "\39\8\19\0",
	130000, "\39\42\19\0",
	140000, "\39\38\19\0",
	150000, "\39\32\19\0",
	160000, "\39\52\19\0",
	170000, "\39\36\19\0",
	180000, "\39\3\19\0",
	190000, "\39\12\19\0",
	200000, "\9\19\0",
	210000, "\9\14\19\0",
	220000, "\9\8\19\0",
	230000, "\9\42\19\0",
	240000, "\9\38\19\0",
	250000, "\9\32\19\0",
	260000, "\9\52\19\0",
	270000, "\9\36\19\0",
	280000, "\9\3\19\0",
	290000, "\9\12\19\0",
	300000, "\43\19\0",
	310000, "\43\14\19\0",
	320000, "\43\8\19\0",
	330000, "\43\42\19\0",
	340000, "\43\38\19\0",
	350000, "\43\32\19\0",
	360000, "\43\52\19\0",
	370000, "\43\36\19\0",
	380000, "\43\3\19\0",
	390000, "\43\12\19\0",
	400000, "\49\19\0",
	410000, "\49\14\19\0",
	420000, "\49\8\19\0",
	430000, "\49\42\19\0",
	440000, "\49\38\19\0",
	450000, "\49\32\19\0",
	460000, "\49\52\19\0",
	470000, "\49\36\19\0",
	480000, "\49\3\19\0",
	490000, "\49\12\19\0",
	500000, "\33\19\0",
	510000, "\33\14\19\0",
	}
end

distances.feet = {
	15, "\32\45\0",
	30, "\39\45\0",
	46, "\39\32\45\0",
	61, "\9\45\0",
	91, "\43\45\0",
	122, "\49\45\0",
	152, "\33\45\0",
	183, "\53\45\0",
	213, "\37\45\0",
	244, "\4\45\0",
	274, "\13\45\0",
	305, "\44\45\0",
	402, "\46\22\0",
	644, "\47\55\22\0",
	805, "\29\0",
	966, "\50\55\22\0",
	1127, "\34\55\22\0",
	1448, "\10\55\22\0",
	1609, "\27\24\0",
	1770, "\27\16\27\22\0",
	1931, "\27\16\6\22\0",
	2092, "\27\16\40\22\0",
	2253, "\27\16\47\22\0",
	2414, "\27\16\30\22\0",
	2575, "\27\16\50\22\0",
	2736, "\27\16\34\22\0",
	2897, "\27\16\1\22\0",
	3058, "\27\16\10\22\0",
	3219, "\6\22\0",
	3380, "\6\16\27\22\0",
	3541, "\6\16\6\22\0",
	3701, "\6\16\40\22\0",
	3862, "\6\16\47\22\0",
	4023, "\6\16\30\22\0",
	4184, "\6\16\50\22\0",
	4345, "\6\16\34\22\0",
	4506, "\6\16\1\22\0",
	4667, "\6\16\10\22\0",
	4828, "\40\22\0",
	4989, "\40\16\27\22\0",
	5150, "\40\16\6\22\0",
	5311, "\40\16\40\22\0",
	5472, "\40\16\47\22\0",
	5633, "\40\16\30\22\0",
	5794, "\40\16\50\22\0",
	5955, "\40\16\34\22\0",
	6116, "\40\16\1\22\0",
	6276, "\40\16\10\22\0",
	6437, "\47\22\0",
	6598, "\47\16\27\22\0",
	6759, "\47\16\6\22\0",
	6920, "\47\16\40\22\0",
	7081, "\47\16\47\22\0",
	7242, "\47\16\30\22\0",
	7403, "\47\16\50\22\0",
	7564, "\47\16\34\22\0",
	7725, "\47\16\1\22\0",
	7886, "\47\16\10\22\0",
	8047, "\30\23\0",
	8208, "\30\16\27\22\0",
	8369, "\30\16\6\22\0",
	8530, "\30\16\40\22\0",
	8690, "\30\16\47\22\0",
	8851, "\30\16\30\22\0",
	9012, "\30\16\50\22\0",
	9173, "\30\16\34\22\0",
	9334, "\30\16\1\22\0",
	9495, "\30\16\10\22\0",
	9656, "\50\23\0",
	9817, "\50\16\27\22\0",
	9978, "\50\16\6\22\0",
	10139, "\50\16\40\22\0",
	10300, "\50\16\47\22\0",
	10461, "\50\16\30\22\0",
	10622, "\50\16\50\22\0",
	10783, "\50\16\34\22\0",
	10944, "\50\16\1\22\0",
	11104, "\50\16\10\22\0",
	11265, "\34\23\0",
	11426, "\34\16\27\22\0",
	11587, "\34\16\6\22\0",
	11748, "\34\16\40\22\0",
	11909, "\34\16\47\22\0",
	12070, "\34\16\30\22\0",
	12231, "\34\16\50\22\0",
	12392, "\34\16\34\22\0",
	12553, "\34\16\1\22\0",
	12714, "\34\16\10\22\0",
	12875, "\1\23\0",
	13036, "\1\16\27\22\0",
	13197, "\1\16\6\22\0",
	13358, "\1\16\40\22\0",
	13518, "\1\16\47\22\0",
	13679, "\1\16\30\22\0",
	13840, "\1\16\50\22\0",
	14001, "\1\16\34\22\0",
	14162, "\1\16\1\22\0",
	14323, "\1\16\10\22\0",
	14484, "\10\23\0",
	14645, "\10\16\27\22\0",
	14806, "\10\16\6\22\0",
	14967, "\10\16\40\22\0",
	15128, "\10\16\47\22\0",
	15289, "\10\16\30\22\0",
	15450, "\10\16\50\22\0",
	15611, "\10\16\34\22\0",
	15772, "\10\16\1\22\0",
	15933, "\10\16\10\22\0",
	16093, "\14\23\0",
	17703, "\26\23\0",
	19312, "\7\23\0",
	20921, "\41\23\0",
	22531, "\48\23\0",
	24140, "\31\23\0",
	25750, "\51\23\0",
	27359, "\35\23\0",
	28968, "\2\23\0",
	30578, "\11\23\0",
	32187, "\8\23\0",
	33796, "\8\27\24\0",
	35406, "\8\6\22\0",
	37015, "\8\40\22\0",
	38624, "\8\47\22\0",
	40234, "\8\30\23\0",
	41843, "\8\50\23\0",
	43452, "\8\34\23\0",
	45062, "\8\1\23\0",
	46671, "\8\10\23\0",
	48280, "\42\23\0",
	49890, "\42\27\24\0",
	51499, "\42\6\22\0",
	53108, "\42\40\22\0",
	54718, "\42\47\22\0",
	56327, "\42\30\23\0",
	57936, "\42\50\23\0",
	59546, "\42\34\23\0",
	61155, "\42\1\23\0",
	62764, "\42\10\23\0",
	64374, "\38\23\0",
	65983, "\38\27\24\0",
	67592, "\38\6\22\0",
	69202, "\38\40\22\0",
	70811, "\38\47\22\0",
	72420, "\38\30\23\0",
	74030, "\38\50\23\0",
	75639, "\38\34\23\0",
	77249, "\38\1\23\0",
	78858, "\38\10\23\0",
	80467, "\32\23\0",
	82077, "\32\27\24\0",
	83686, "\32\6\22\0",
	85295, "\32\40\22\0",
	86905, "\32\47\22\0",
	88514, "\32\30\23\0",
	90123, "\32\50\23\0",
	91733, "\32\34\23\0",
	93342, "\32\1\23\0",
	94951, "\32\10\23\0",
	96561, "\52\23\0",
	98170, "\52\27\24\0",
	99779, "\52\6\22\0",
	101389, "\52\40\22\0",
	102998, "\52\47\22\0",
	104607, "\52\30\23\0",
	106217, "\52\50\23\0",
	107826, "\52\34\23\0",
	109435, "\52\1\23\0",
	111045, "\52\10\23\0",
	112654, "\36\23\0",
	114263, "\36\27\24\0",
	115873, "\36\6\22\0",
	117482, "\36\40\22\0",
	119091, "\36\47\22\0",
	120701, "\36\30\23\0",
	122310, "\36\50\23\0",
	123919, "\36\34\23\0",
	125529, "\36\1\23\0",
	127138, "\36\10\23\0",
	128748, "\3\23\0",
	130357, "\3\27\24\0",
	131966, "\3\6\22\0",
	133576, "\3\40\22\0",
	135185, "\3\47\22\0",
	136794, "\3\30\23\0",
	138404, "\3\50\23\0",
	140013, "\3\34\23\0",
	141622, "\3\1\23\0",
	143232, "\3\10\23\0",
	144841, "\12\23\0",
	146450, "\12\27\24\0",
	148060, "\12\6\22\0",
	149669, "\12\40\22\0",
	151278, "\12\47\22\0",
	152888, "\12\30\23\0",
	154497, "\12\50\23\0",
	156106, "\12\34\23\0",
	157716, "\12\1\23\0",
	159325, "\12\10\23\0",
	160934, "\39\23\0",
	177028, "\39\14\23\0",
	193121, "\39\8\23\0",
	209215, "\39\42\23\0",
	225308, "\39\38\23\0",
	241402, "\39\32\23\0",
	257495, "\39\52\23\0",
	273588, "\39\36\23\0",
	289682, "\39\3\23\0",
	305775, "\39\12\23\0",
	321869, "\9\23\0",
	337962, "\9\14\23\0",
	354056, "\9\8\23\0",
	370149, "\9\42\23\0",
	386243, "\9\38\23\0",
	402336, "\9\32\23\0",
	418429, "\9\52\23\0",
	434523, "\9\36\23\0",
	450616, "\9\3\23\0",
	466710, "\9\12\23\0",
	482803, "\43\23\0",
	498897, "\43\14\23\0",
	514990, "\43\8\23\0",
	531084, "\43\42\23\0",
	547177, "\43\38\23\0",
	563270, "\43\32\23\0",
	579364, "\43\52\23\0",
	595457, "\43\36\23\0",
	611551, "\43\3\23\0",
	627644, "\43\12\23\0",
	643738, "\49\23\0",
	659831, "\49\14\23\0",
	675924, "\49\8\23\0",
	692018, "\49\42\23\0",
	708111, "\49\38\23\0",
	724205, "\49\32\23\0",
	740298, "\49\52\23\0",
	756392, "\49\36\23\0",
	772485, "\49\3\23\0",
	788579, "\49\12\23\0",
	804672, "\33\23\0",
	820765, "\33\14\23\0",
}

distances.yards = {
	9, "\14\54\0",
	18, "\8\54\0",
	27, "\42\54\0",
	37, "\38\54\0",
	46, "\32\54\0",
	55, "\52\54\0",
	64, "\36\54\0",
	73, "\3\54\0",
	82, "\12\54\0",
	91, "\39\54\0",
	101, "\39\14\54\0",
	110, "\39\8\54\0",
	119, "\39\42\54\0",
	128, "\39\38\54\0",
	137, "\39\32\54\0",
	146, "\39\52\54\0",
	155, "\39\36\54\0",
	165, "\39\3\54\0",
	174, "\39\12\54\0",
	183, "\9\54\0",
	192, "\9\14\54\0",
	201, "\9\8\54\0",
	210, "\9\42\54\0",
	219, "\9\38\54\0",
	229, "\9\32\54\0",
	238, "\9\52\54\0",
	247, "\9\36\54\0",
	256, "\9\3\54\0",
	265, "\9\12\54\0",
	274, "\43\54\0",
	283, "\43\14\54\0",
	293, "\43\8\54\0",
	302, "\43\42\54\0",
	311, "\43\38\54\0",
	320, "\43\32\54\0",
	329, "\43\52\54\0",
	338, "\43\36\54\0",
	347, "\43\3\54\0",
	357, "\43\12\54\0",
	366, "\49\54\0",
	402, "\46\22\0",
	644, "\47\55\22\0",
	805, "\29\0",
	966, "\50\55\22\0",
	1127, "\34\55\22\0",
	1448, "\10\55\22\0",
	1609, "\27\24\0",
	1770, "\27\16\27\22\0",
	1931, "\27\16\6\22\0",
	2092, "\27\16\40\22\0",
	2253, "\27\16\47\22\0",
	2414, "\27\16\30\22\0",
	2575, "\27\16\50\22\0",
	2736, "\27\16\34\22\0",
	2897, "\27\16\1\22\0",
	3058, "\27\16\10\22\0",
	3219, "\6\22\0",
	3380, "\6\16\27\22\0",
	3541, "\6\16\6\22\0",
	3701, "\6\16\40\22\0",
	3862, "\6\16\47\22\0",
	4023, "\6\16\30\22\0",
	4184, "\6\16\50\22\0",
	4345, "\6\16\34\22\0",
	4506, "\6\16\1\22\0",
	4667, "\6\16\10\22\0",
	4828, "\40\22\0",
	4989, "\40\16\27\22\0",
	5150, "\40\16\6\22\0",
	5311, "\40\16\40\22\0",
	5472, "\40\16\47\22\0",
	5633, "\40\16\30\22\0",
	5794, "\40\16\50\22\0",
	5955, "\40\16\34\22\0",
	6116, "\40\16\1\22\0",
	6276, "\40\16\10\22\0",
	6437, "\47\22\0",
	6598, "\47\16\27\22\0",
	6759, "\47\16\6\22\0",
	6920, "\47\16\40\22\0",
	7081, "\47\16\47\22\0",
	7242, "\47\16\30\22\0",
	7403, "\47\16\50\22\0",
	7564, "\47\16\34\22\0",
	7725, "\47\16\1\22\0",
	7886, "\47\16\10\22\0",
	8047, "\30\23\0",
	8208, "\30\16\27\22\0",
	8369, "\30\16\6\22\0",
	8530, "\30\16\40\22\0",
	8690, "\30\16\47\22\0",
	8851, "\30\16\30\22\0",
	9012, "\30\16\50\22\0",
	9173, "\30\16\34\22\0",
	9334, "\30\16\1\22\0",
	9495, "\30\16\10\22\0",
	9656, "\50\23\0",
	9817, "\50\16\27\22\0",
	9978, "\50\16\6\22\0",
	10139, "\50\16\40\22\0",
	10300, "\50\16\47\22\0",
	10461, "\50\16\30\22\0",
	10622, "\50\16\50\22\0",
	10783, "\50\16\34\22\0",
	10944, "\50\16\1\22\0",
	11104, "\50\16\10\22\0",
	11265, "\34\23\0",
	11426, "\34\16\27\22\0",
	11587, "\34\16\6\22\0",
	11748, "\34\16\40\22\0",
	11909, "\34\16\47\22\0",
	12070, "\34\16\30\22\0",
	12231, "\34\16\50\22\0",
	12392, "\34\16\34\22\0",
	12553, "\34\16\1\22\0",
	12714, "\34\16\10\22\0",
	12875, "\1\23\0",
	13036, "\1\16\27\22\0",
	13197, "\1\16\6\22\0",
	13358, "\1\16\40\22\0",
	13518, "\1\16\47\22\0",
	13679, "\1\16\30\22\0",
	13840, "\1\16\50\22\0",
	14001, "\1\16\34\22\0",
	14162, "\1\16\1\22\0",
	14323, "\1\16\10\22\0",
	14484, "\10\23\0",
	14645, "\10\16\27\22\0",
	14806, "\10\16\6\22\0",
	14967, "\10\16\40\22\0",
	15128, "\10\16\47\22\0",
	15289, "\10\16\30\22\0",
	15450, "\10\16\50\22\0",
	15611, "\10\16\34\22\0",
	15772, "\10\16\1\22\0",
	15933, "\10\16\10\22\0",
	16093, "\14\23\0",
	17703, "\26\23\0",
	19312, "\7\23\0",
	20921, "\41\23\0",
	22531, "\48\23\0",
	24140, "\31\23\0",
	25750, "\51\23\0",
	27359, "\35\23\0",
	28968, "\2\23\0",
	30578, "\11\23\0",
	32187, "\8\23\0",
	33796, "\8\27\24\0",
	35406, "\8\6\22\0",
	37015, "\8\40\22\0",
	38624, "\8\47\22\0",
	40234, "\8\30\23\0",
	41843, "\8\50\23\0",
	43452, "\8\34\23\0",
	45062, "\8\1\23\0",
	46671, "\8\10\23\0",
	48280, "\42\23\0",
	49890, "\42\27\24\0",
	51499, "\42\6\22\0",
	53108, "\42\40\22\0",
	54718, "\42\47\22\0",
	56327, "\42\30\23\0",
	57936, "\42\50\23\0",
	59546, "\42\34\23\0",
	61155, "\42\1\23\0",
	62764, "\42\10\23\0",
	64374, "\38\23\0",
	65983, "\38\27\24\0",
	67592, "\38\6\22\0",
	69202, "\38\40\22\0",
	70811, "\38\47\22\0",
	72420, "\38\30\23\0",
	74030, "\38\50\23\0",
	75639, "\38\34\23\0",
	77249, "\38\1\23\0",
	78858, "\38\10\23\0",
	80467, "\32\23\0",
	82077, "\32\27\24\0",
	83686, "\32\6\22\0",
	85295, "\32\40\22\0",
	86905, "\32\47\22\0",
	88514, "\32\30\23\0",
	90123, "\32\50\23\0",
	91733, "\32\34\23\0",
	93342, "\32\1\23\0",
	94951, "\32\10\23\0",
	96561, "\52\23\0",
	98170, "\52\27\24\0",
	99779, "\52\6\22\0",
	101389, "\52\40\22\0",
	102998, "\52\47\22\0",
	104607, "\52\30\23\0",
	106217, "\52\50\23\0",
	107826, "\52\34\23\0",
	109435, "\52\1\23\0",
	111045, "\52\10\23\0",
	112654, "\36\23\0",
	114263, "\36\27\24\0",
	115873, "\36\6\22\0",
	117482, "\36\40\22\0",
	119091, "\36\47\22\0",
	120701, "\36\30\23\0",
	122310, "\36\50\23\0",
	123919, "\36\34\23\0",
	125529, "\36\1\23\0",
	127138, "\36\10\23\0",
	128748, "\3\23\0",
	130357, "\3\27\24\0",
	131966, "\3\6\22\0",
	133576, "\3\40\22\0",
	135185, "\3\47\22\0",
	136794, "\3\30\23\0",
	138404, "\3\50\23\0",
	140013, "\3\34\23\0",
	141622, "\3\1\23\0",
	143232, "\3\10\23\0",
	144841, "\12\23\0",
	146450, "\12\27\24\0",
	148060, "\12\6\22\0",
	149669, "\12\40\22\0",
	151278, "\12\47\22\0",
	152888, "\12\30\23\0",
	154497, "\12\50\23\0",
	156106, "\12\34\23\0",
	157716, "\12\1\23\0",
	159325, "\12\10\23\0",
	160934, "\39\23\0",
	177028, "\39\14\23\0",
	193121, "\39\8\23\0",
	209215, "\39\42\23\0",
	225308, "\39\38\23\0",
	241402, "\39\32\23\0",
	257495, "\39\52\23\0",
	273588, "\39\36\23\0",
	289682, "\39\3\23\0",
	305775, "\39\12\23\0",
	321869, "\9\23\0",
	337962, "\9\14\23\0",
	354056, "\9\8\23\0",
	370149, "\9\42\23\0",
	386243, "\9\38\23\0",
	402336, "\9\32\23\0",
	418429, "\9\52\23\0",
	434523, "\9\36\23\0",
	450616, "\9\3\23\0",
	466710, "\9\12\23\0",
	482803, "\43\23\0",
	498897, "\43\14\23\0",
	514990, "\43\8\23\0",
	531084, "\43\42\23\0",
	547177, "\43\38\23\0",
	563270, "\43\32\23\0",
	579364, "\43\52\23\0",
	595457, "\43\36\23\0",
	611551, "\43\3\23\0",
	627644, "\43\12\23\0",
	643738, "\49\23\0",
	659831, "\49\14\23\0",
	675924, "\49\8\23\0",
	692018, "\49\42\23\0",
	708111, "\49\38\23\0",
	724205, "\49\32\23\0",
	740298, "\49\52\23\0",
	756392, "\49\36\23\0",
	772485, "\49\3\23\0",
	788579, "\49\12\23\0",
	804672, "\33\23\0",
	820765, "\33\14\23\0",
}

function set_distances_ttspro_meters()
	distances.ttspro_meters = {
	10, "\14\21\0",
	20, "\8\21\0",
	30, "\42\21\0",
	40, "\38\21\0",
	50, "\32\21\0",
	60, "\52\21\0",
	70, "\36\21\0",
	80, "\3\21\0",
	90, "\12\21\0",
	100, "\39\21\0",
	110, "\39\14\21\0",
	120, "\39\8\21\0",
	130, "\39\42\21\0",
	140, "\39\38\21\0",
	150, "\39\32\21\0",
	160, "\39\52\21\0",
	170, "\39\36\21\0",
	180, "\39\3\21\0",
	190, "\39\12\21\0",
	200, "\9\21\0",
	210, "\9\14\21\0",
	220, "\9\8\21\0",
	230, "\9\42\21\0",
	240, "\9\38\21\0",
	250, "\9\32\21\0",
	300, "\43\21\0",
	350, "\43\32\21\0",
	400, "\49\21\0",
	450, "\49\32\21\0",
	500, "\33\21\0",
	550, "\33\32\21\0",
	600, "\53\21\0",
	650, "\53\32\21\0",
	700, "\37\21\0",
	750, "\37\32\21\0",
	800, "\4\21\0",
	900, "\13\21\0",
	1000, "\25\17\0",
	1100, (numbers_mode and "\25\16\56\18\0" or "\25\17\39\21\0"),
	1200, (numbers_mode and "\25\16\57\18\0" or "\25\17\9\21\0"),
	1300, (numbers_mode and "\25\16\58\18\0" or "\25\17\43\21\0"),
	1400, (numbers_mode and "\25\16\59\18\0" or "\25\17\49\21\0"),
	1500, (numbers_mode and "\28\18\0" or "\25\17\33\21\0"),
	1600, (numbers_mode and "\25\16\60\18\0" or "\25\17\53\21\0"),
	1700, (numbers_mode and "\25\16\61\18\0" or "\25\17\37\21\0"),
	1800, (numbers_mode and "\25\16\62\18\0" or "\25\17\4\21\0"),
	1900, (numbers_mode and "\25\16\63\18\0" or "\25\17\13\21\0"),
	2000, "\5\20\0",
	2100, (numbers_mode and "\5\16\56\18\0" or "\5\20\39\21\0"),
	2200, (numbers_mode and "\5\16\57\18\0" or "\5\20\9\21\0"),
	2300, (numbers_mode and "\5\16\58\18\0" or "\5\20\43\21\0"),
	2400, (numbers_mode and "\5\16\59\18\0" or "\5\20\49\21\0"),
	2500, (numbers_mode and "\5\15\20\0" or "\5\20\33\21\0"),
	2600, (numbers_mode and "\5\16\60\18\0" or "\5\20\53\21\0"),
	2700, (numbers_mode and "\5\16\61\18\0" or "\5\20\37\21\0"),
	2800, (numbers_mode and "\5\16\62\18\0" or "\5\20\4\21\0"),
	2900, (numbers_mode and "\5\16\63\18\0" or "\5\20\13\21\0"),
	3000, "\40\20\0",
	3100, (numbers_mode and "\40\16\56\18\0" or "\40\20\39\21\0"),
	3200, (numbers_mode and "\40\16\57\18\0" or "\40\20\9\21\0"),
	3300, (numbers_mode and "\40\16\58\18\0" or "\40\20\43\21\0"),
	3400, (numbers_mode and "\40\16\59\18\0" or "\40\20\49\21\0"),
	3500, (numbers_mode and "\40\15\20\0" or "\40\20\33\21\0"),
	3600, (numbers_mode and "\40\16\60\18\0" or "\40\20\53\21\0"),
	3700, (numbers_mode and "\40\16\61\18\0" or "\40\20\37\21\0"),
	3800, (numbers_mode and "\40\16\62\18\0" or "\40\20\4\21\0"),
	3900, (numbers_mode and "\40\16\63\18\0" or "\40\20\13\21\0"),
	4000, "\47\20\0",
	4100, (numbers_mode and "\47\16\56\18\0" or "\47\20\39\21\0"),
	4200, (numbers_mode and "\47\16\57\18\0" or "\47\20\9\21\0"),
	4300, (numbers_mode and "\47\16\58\18\0" or "\47\20\43\21\0"),
	4400, (numbers_mode and "\47\16\59\18\0" or "\47\20\49\21\0"),
	4500, (numbers_mode and "\47\15\20\0" or "\47\20\33\21\0"),
	4600, (numbers_mode and "\47\16\60\18\0" or "\47\20\53\21\0"),
	4700, (numbers_mode and "\47\16\61\18\0" or "\47\20\37\21\0"),
	4800, (numbers_mode and "\47\16\62\18\0" or "\47\20\4\21\0"),
	4900, (numbers_mode and "\47\16\63\18\0" or "\47\20\13\21\0"),
	5000, "\30\19\0",
	5100, (numbers_mode and "\30\16\56\18\0" or "\30\19\39\21\0"),
	5200, (numbers_mode and "\30\16\57\18\0" or "\30\19\9\21\0"),
	5300, (numbers_mode and "\30\16\58\18\0" or "\30\19\43\21\0"),
	5400, (numbers_mode and "\30\16\59\18\0" or "\30\19\49\21\0"),
	5500, (numbers_mode and "\30\15\19\0" or "\30\19\33\21\0"),
	5600, (numbers_mode and "\30\16\60\18\0" or "\30\19\53\21\0"),
	5700, (numbers_mode and "\30\16\61\18\0" or "\30\19\37\21\0"),
	5800, (numbers_mode and "\30\16\62\18\0" or "\30\19\4\21\0"),
	5900, (numbers_mode and "\30\16\63\18\0" or "\30\19\13\21\0"),
	6000, "\50\19\0",
	6100, (numbers_mode and "\50\16\56\18\0" or "\50\19\39\21\0"),
	6200, (numbers_mode and "\50\16\57\18\0" or "\50\19\9\21\0"),
	6300, (numbers_mode and "\50\16\58\18\0" or "\50\19\43\21\0"),
	6400, (numbers_mode and "\50\16\59\18\0" or "\50\19\49\21\0"),
	6500, (numbers_mode and "\50\15\19\0" or "\50\19\33\21\0"),
	6600, (numbers_mode and "\50\16\60\18\0" or "\50\19\53\21\0"),
	6700, (numbers_mode and "\50\16\61\18\0" or "\50\19\37\21\0"),
	6800, (numbers_mode and "\50\16\62\18\0" or "\50\19\4\21\0"),
	6900, (numbers_mode and "\50\16\63\18\0" or "\50\19\13\21\0"),
	7000, "\34\19\0",
	7100, (numbers_mode and "\34\16\56\18\0" or "\34\19\39\21\0"),
	7200, (numbers_mode and "\34\16\57\18\0" or "\34\19\9\21\0"),
	7300, (numbers_mode and "\34\16\58\18\0" or "\34\19\43\21\0"),
	7400, (numbers_mode and "\34\16\59\18\0" or "\34\19\49\21\0"),
	7500, (numbers_mode and "\34\15\19\0" or "\34\19\33\21\0"),
	7600, (numbers_mode and "\34\16\60\18\0" or "\34\19\53\21\0"),
	7700, (numbers_mode and "\34\16\61\18\0" or "\34\19\37\21\0"),
	7800, (numbers_mode and "\34\16\62\18\0" or "\34\19\4\21\0"),
	7900, (numbers_mode and "\34\16\63\18\0" or "\34\19\13\21\0"),
	8000, "\1\19\0",
	8100, (numbers_mode and "\1\16\56\18\0" or "\1\19\39\21\0"),
	8200, (numbers_mode and "\1\16\57\18\0" or "\1\19\9\21\0"),
	8300, (numbers_mode and "\1\16\58\18\0" or "\1\19\43\21\0"),
	8400, (numbers_mode and "\1\16\59\18\0" or "\1\19\49\21\0"),
	8500, (numbers_mode and "\1\15\19\0" or "\1\19\33\21\0"),
	8600, (numbers_mode and "\1\16\60\18\0" or "\1\19\53\21\0"),
	8700, (numbers_mode and "\1\16\61\18\0" or "\1\19\37\21\0"),
	8800, (numbers_mode and "\1\16\62\18\0" or "\1\19\4\21\0"),
	8900, (numbers_mode and "\1\16\63\18\0" or "\1\19\13\21\0"),
	9000, "\10\19\0",
	9100, (numbers_mode and "\10\16\56\18\0" or "\10\19\39\21\0"),
	9200, (numbers_mode and "\10\16\57\18\0" or "\10\19\9\21\0"),
	9300, (numbers_mode and "\10\16\58\18\0" or "\10\19\43\21\0"),
	9400, (numbers_mode and "\10\16\59\18\0" or "\10\19\49\21\0"),
	9500, (numbers_mode and "\10\15\19\0" or "\10\19\33\21\0"),
	9600, (numbers_mode and "\10\16\60\18\0" or "\10\19\53\21\0"),
	9700, (numbers_mode and "\10\16\61\18\0" or "\10\19\37\21\0"),
	9800, (numbers_mode and "\10\16\62\18\0" or "\10\19\4\21\0"),
	9900, (numbers_mode and "\10\16\63\18\0" or "\10\19\13\21\0"),
	}
end

ordinals = {
	{L"първи", nil, nil},
	{L"втори", nil, nil},
	{L"трети", nil, nil},
	{L"четвърти", nil, nil},
	{L"пети", nil, nil},
	{L"шести", nil, nil},
	{L"седми", nil, nil},
	{L"осми", nil, nil},
	{L"девети", nil, nil},
	{L"десети", nil, nil},
	{L"единадесети", nil, nil},
	{L"дванадесети", nil, nil},
	{L"тринадесети", nil, nil},
	{L"четиринадесети", nil, nil},
	{L"петнадесети", nil, nil},
	{L"шестнадесети", nil, nil},
	{L"седемнадесети", nil, nil},
	{L"осемнадесети", nil, nil},
	{L"деветнадесети", nil, nil},
	{L"двадесети", nil, nil},
}