module("VOICE")

transform = {}

transform.roadname_abbrev_table = TRANSFORM.new({	
	{1,L"Tunnl",L"Тунел"},
	{1,L"Tunls",L"Тунел"},
	{1,L"Tunl",L"Тунел"},
	{1,L"Tunel",L"Тунел"},
	{1,L"Tunnel",L"Тунел"},
	{1,L"Avnue",L"Булевард"},
	{1,L"Avn",L"Булевард"},
	{1,L"Avenu",L"Булевард"},
	{1,L"Aven",L"Булевард"},
	{1,L"Ave",L"Булевард"},
	{1,L"Av",L"Булевард"},
	{1,L"Cntr",L"Център"},
	{1,L"Cnter",L"Център"},
	{1,L"Center",L"Център"},
	{1,L"Centre",L"Център"},
	{1,L"Centr",L"Център"},
	{1,L"Cent",L"Център"},
	{1,L"Centrum",L"Център"},
	{1,L"Ctr",L"Улица"},
	{1,L"Strt",L"Улица"},
	{1,L"Street",L"Улица"},
	{1,L"Str",L"Улица"},
	{1,L"St",L"Улица"},
	{1,L"unnamed",L"безименна"},
	{1,L"unnamed road",L"безименен път"},
	{1,L"Onto",L"Във"},
	{1,L"Неасфалт. път",L"Неасфалтиран път"},
	{1,L"Безименна",L"Безименна"},
	{1,L"Unnamed",L"безименен"},
	{1,L"Unnamed road",L"Път без име"},
	{1,L"Unnamed_Road",L"Път без име"},
	{1,L"В улицата без име",L"В улицата без име"},
	{1,L"към улицата без име",L""},
	{1,L"без име",L"пътя без име"},
	{1,L"към пътя без име",L""},
	{1,L"към пътя без име",L""},
	{1,L"към пътя без име",L""},
	{1,L"към пътя без име",L""},
	{1,L"към пътя без име",L""},
	{1,L"към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"в посока към пътя без име",L""},
	{1,L"във пътя без име",L""},
	{1,L"Път",L"път"},
	{1,L"път",L"път"},
	{1,L"път",L"път"},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"Път без име",L""},
	{1,L"102",L"Сто и втора"},
	{1,L"105",L"Сто и пета"},
	{1,L"1-Ва",L"Първа"},
	{1,L"1-Ви",L"Първи"},
	{1,L"10-Та",L"Десета"},
	{1,L"10-Ти",L"Десети"},
	{1,L"11-Та",L"Единайста"},
	{1,L"11-Ти",L"Единайсти"},
	{1,L"12-Та",L"Дванайста"},
	{1,L"12-Ти",L"Дванайсти"},
	{1,L"13-Та",L"Тринайста"},
	{1,L"13-Ти",L"Тринайсти"},
	{1,L"14-Та",L"Четиринайста"},
	{1,L"14-Ти",L"Четиринайсти"},
	{1,L"15-Та",L"Петнайста"},
	{1,L"15-Ти",L"Петнайсти"},
	{1,L"16-Та",L"Шестнайста"},
	{1,L"16-Ти",L"Шестнайсти"},
	{1,L"17-Та",L"Седемнайста"},
	{1,L"17-Ти",L"Седемнайсти"},
	{1,L"18-Та",L"Осемнайста"},
	{1,L"18-Ти",L"Осемнайсти"},
	{1,L"19-Та",L"Деветнайста"},
	{1,L"19-Ти",L"Деветнайсти"},
	{1,L"2-Ра",L"Втора"},
	{1,L"2-Ри",L"Втори"},
	{1,L"II",L"Втори"},
	{1,L"20 бора",L"Двайсетте бора"},
	{1,L"20-Та",L"двайста"},
	{1,L"20-Ти",L"двайсти"},
	{1,L"21-Ва",L"двайсет и първа"},
	{1,L"21-Ви",L"двайсет и първи"},
	{1,L"22-Ра",L"двайсет и втора"},
	{1,L"22-Ри",L"двайсет и втори"},
	{1,L"228-Ма",L"Двеста двайсет и осма"},
	{1,L"23-Та",L"двайсет и трета"},
	{1,L"23-Ти",L"двайсет и трети"},
	{1,L"24-Та",L"двайсет и четвърта"},
	{1,L"24-Ти",L"двайсет и четвърти"},
	{1,L"250-Та",L"двеста и петдесета"},
	{1,L"251-Ва",L"Двеста петдесет и първа"},
	{1,L"253-Та",L"Двеста петдесет и трета"},
	{1,L"255-Та",L"Двеста петдест и пета"},
	{1,L"256-Та",L"Двеста петдесет и шеста"},
	{1,L"259-Та",L"Двеста петдесет и девета"},
	{1,L"3-Та",L"Трета"},
	{1,L"3-Ти",L"Трети"},
	{1,L"III",L"Трети"},
	{1,L"31-Ви",L"Трийсет и първи"},
	{1,L"31-Vi",L"Трийсет и първи"},
	{1,L"339-Та",L"Триста трийсет и девета"},
	{1,L"397-Ма",L"Триста деветдесет и седма"},
	{1,L"398-Ма",L"Триста деветдесет и осма"},
	{1,L"4-Та",L"Четвърта"},
	{1,L"4-Ти",L"Четвърти"},
	{1,L"IV",L"Четвърти"},
	{1,L"40-Та",L"Четиреста"},
	{1,L"406-Та",L"Четиристотин и шеста"},
	{1,L"41-Ва",L"Четиресет и първа"},
	{1,L"485-Та",L"Четиристотин осемдесет и пета"},
	{1,L"494-Та",L"Четиристотин деветдесет и четвърта"},
	{1,L"5-Та",L"Пета"},
	{1,L"5-Ти",L"Пети"}, 
	{1,L"V",L"Пети"},
	{1,L"541-Ва",L"Петстотин четиресет и първа"},
	{1,L"554",L"Републикански път 554"},
	{1,L"6-Та",L"Шеста"},
	{1,L"6-Ти",L"Шести"},
	{1,L"63",L"Второкласен път номер 63"},
	{1,L"7-Ма",L"Седма"},
	{1,L"7-Ми",L"Седми"},
	{1,L"7-Ми Юли",L"Седми Юли"},
	{1,L"732-Ра",L"Седемстотин трийсет и втора"},
	{1,L"8-Ма",L"Осма"},
	{1,L"8-Ми",L"Осми"},
	{1,L"18",L"Републикански път номер 18"},
	{1,L"9-Та",L"Девета"},
	{1,L"9-Ти",L"Девети"},
	{1,L"9",L"Републикански път номер 9"},
	{1,L"94-Та",L"Деветдесет и четвърта"},
	{1,L"А1",L"Автомагистрала Тракия"},
	{1,L"А2",L"Автомагистрала Хемус"},
	{1,L"А3",L"Автомагистрала Струма"},
	{1,L"А4",L"Автомагистрала Марица"},
	{1,L"А6",L"Автомагистрала Люлин"},
	{1,L"А7",L"Автомагистрала Калотина"},
{1,L"А. Теодоров-Балан",L"Балан"},
{1,L"Акад.",L"Академик"},
{1,L"Ал. Батенберг",L"Александър Батенберг"},
{1,L"Ал. Константинов",L"Алеко Константинов"},
{1,L"Ал. Стамболийски",L"Александър Стамболийски"},
{1,L"Ал. Суворов",L"Суворов"},
{1,L"Алабин И. Вл.",L"Алабин"},
{1,L"Александър С. Пушкин",L"Пушкин"},
{1,L"Антим I",L"Антим Първи"},
{1,L"Антон П. Чехов",L"Чехов"},
{1,L"Арх.",L"Архитект"},
{1,L"Архиеп.",L"Архиепископ"},
{1,L"Аспарухов-Гунди",L"Аспарухов Гунди"},
{1,L"Б-19",L"Бе деветнайсет"},
{1,L"Б-18",L"Бе осемнайсет"},
{1,L"Б-5",L"Бе пет"},
{1,L"Б. Н. Найденов",L"Найденов"},
{1,L"Бакалов-Стубел",L"Бакалов Стубел"},
{1,L"Богдан Д. Дечев",L"Богдан Дечев"},
{1,L"Борис П. Петров",L"Борис Петров"},
{1,L"Ботунец 1",L"Ботунец едно"},
{1,L"Ботунец 2",L"Ботунец две"},
{1,L"Бул.",L"Булевард"},
{1,L"бл.",L"Блок"},
{1,L"Бл.",L"Блок"},
{1,L"В. Левски",L"Васил Левски"},
{1,L"В. Търново",L"Велико Търново"},
{1,L"Васил Д. Стоянов",L"Васил Стоянов"},
{1,L"Василев-Даскала",L"Василев Даскала"},
{1,L"Вл. Марков",L"Владимир Марков"},
{1,L"Г. Бенковски",L"Георги Бенковски"},
{1,L"Г. Брадистолов",L"Георги Брадистолов"},
{1,L"Г. Вълкович",L"Вълкович"},
{1,L"Г. Димитров",L"Георги Димитров"},
{1,L"Г. Дъбник",L"Горни Дъбник"},
{1,L"Г. М. Димитров",L"Ге Ме Димитров"},
{1,L"Г. С. Раковски",L"Георги Раковски"},
{1,L"Ген. Михаил Д. Скобелев",L"Генерал Скобелев"},
{1,L"Ген.",L"Генерал"},
{1,L"Генерал-Майор",L"Генерал Майор"},
{1,L"Георги С. Раковски",L"Георги Раковски"},
{1,L"Георги С. Тодоров",L"Георги Тодоров"},
{1,L"Георгиев-Гец",L"Георгиев Гец"},
{1,L"Д-р",L"Доктор"},
{1,L"Д-Р",L"Доктор"},
{1,L"Д. Дечев",L"Дечев"},
{1,L"Д. Дъбник",L"Долни Дъбник"},
{1,L"Д. Сотиров",L"Димитър Сотиров"},
{1,L"Д. Списаревски",L"Списаревски"},
{1,L"Д. Стоянов",L"Стоянов"},
{1,L"Данчов-Зографина",L"Данчов Зографина"},
{1,L"Деко Мл. Бобев",L"Деко Бобев"},
{1,L"Димитров-Куклата",L"Димитров Куклата"},
{1,L"Димитров-Майстора",L"Димитров Майстора"},
{1,L"Дружба I",L"Дружба едно"},
{1,L"Дружба II",L"Дружба две"},
{1,L"Е. И. Тотлебен",L"Тотлебен"},
{1,L"Е70",L"Е седемдесет"},
{1,L"Е772",L"Е седемстотин седемдесет и две"},
{1,L"Е773",L"Е седемстотин седемдесет и три"},
{1,L"Е79",L"Е седемдесет и девет"},
{1,L"Е80",L"Е осемдесет"},
{1,L"Е83",L"Е осемдесет и три"},
{1,L"Е85",L"Е осемдесет и пет"},
{1,L"Е87",L"Е осемдесет и седем"},
{1,L"Е871",L"Е осемстотин седемдесет и едно"},
{1,L"Жк",L"Же Ка"},
{1,L"Ж.К.",L"Же ка"},
{1,L"Захари А. Попов",L"Захари Попов"},
{1,L"Ив. Желязков",L"Иван Желязков"},
{1,L"Ив. И Ст. Параскевови",L"Иван и Стиляна Параскевови"},
{1,L"Иван Евст. Гешов",L"Иван Гешов"},
{1,L"Иван Евстатиев Гешов",L"Иван Гешов"},
{1,L"Иван Н. Денкоглу",L"Иван Денкоглу"},
{1,L"Иван Х. Денкоглу",L"Иван Денкоглу"},
{1,L"Иванов-Големия",L"Иванов Големия"},
{1,L"Илийчо П. Илиев",L"Илийчо Илиев"},
{1,L"Инж.",L"Инженер"},
{1,L"Инжинер",L"Инженер"},
{1,L"Й. Тодоров",L"Тодоров"},
{1,L"Йером.",L"Йеромонах"},
{1,L"Йордан-Венедиков",L"Йордан Венедиков"},
{1,L"Йосиф В. Гурко",L"Гурко"},
{1,L"К. Константинов",L"Константинов"},
{1,L"Кап.",L"Капитан"},
{1,L"Кв.",L"Квартал"},
{1,L"кв.",L"Квартал"},
{1,L"Кв",L"Квартал"},
{1,L"Кв. Средна кула",L"Квартал Средна кула"},
{1,L"Кл. Бояджиев",L"Бояджиев"},
{1,L"Княз Александър I",L"Княз Александър първи"},
{1,L"Княз Ал. Дондуков",L"Дундуков"},
{1,L"Княз Борис I",L"Княз Борис първи"},
{1,L"Крум Хр. Стоянов",L"Крум Стоянов"},
{1,L"Крушкин-Чолака",L"Крушкин Чолака"},
{1,L"Кръстевич",L"Кръстевич"},
{1,L"Л. В. Бетховен",L"Бетховен"},
{1,L"Л. Григорова",L"Григорова"},
{1,L"М-Р",L"Майор"},
{1,L"М. Бегов",L"Бегов"},
{1,L"М. Казашка",L"Казашка"},
{1,L"Малеева-Живкова",L"Малевева Живкова"},
{1,L"Милуш Ал. Станоев",L"Милуш Станоев"},
{1,L"Минков-Лотко",L"Минков Лотко"},
{1,L"Митроп.",L"Митрополит"},
{1,L"Мц",L"Медицински център"},
{1,L"Н. Вапцаров",L"Никола Вапцаров"},
{1,L"Н. Й. Вапцаров",L"Никола Вапцаров"},
{1,L"Никола Й. Вапцаров",L"Никола Вапцаров"},
{1,L"Н. Каменов",L"Каменов"},
{1,L"Н. Некрасов",L"Некрасов"},
{1,L"Н. Петков",L"Никола Петков"},
{1,L"Н. Столетов",L"Столетов"},
{1,L"Немирович-Данчеко",L"Немирович Данченко"},
{1,L"Николай В. Гогол",L"Гогол"},
{1,L"Николов-Сладура",L"Николов Сладура"},
{1,L"О'махони",L"О Махони"},
{1,L"Окр. Болница",L"Окръжна болница"},
{1,L"П. Д. Петков",L"Петко Де Петков"},
{1,L"П. К. Яворов",L"Пейо Яворов"},
{1,L"П. Младенов",L"Петър Младенов"},
{1,L"П. Николов",L"Николов"},
{1,L"П. Парчевич",L"Петър Парчевич"},
{1,L"П. Стайнов",L"Петко Стайнов"},
{1,L"Пейо К. Яворов",L"Пейо Яворов"},
{1,L"Петко Р. Славейков",L"Петко Славейков"},
{1,L"Петко Ю. Тодоров",L"Петко Тодоров"},
{1,L"Петков-Казанджията",L"Петков Казанджията"},
{1,L"Петров-Даскала",L"Петров Даскала"},
{1,L"Петър Хр. Стойнов",L"Петър Стойнов"},
{1,L"Й. Тодоров",L"Тодоров"},
{1,L"Подпор.",L"Подпоручик"},
{1,L"Пол.",L"Полковник"},
{1,L"Професор Др.",L"Професор Доктор"},
{1,L"Проф. Др.",L"Професор Доктор"},
{1,L"Проф.",L"Професор"},
{1,L"Професор А. Теодоров-Балан",L"Професор Балан"},
{1,L"Св. Врач",L"Свети Врач"},
{1,L"Св. Димитър Солунски",L"Свети Димитър Солунски"},
{1,L"Св. Климент",L"Свети Климент"},
{1,L"Св. Козма И Дамян",L"Свети Козма и Дамян"},
{1,L"Св. Петка",L"Света Петка"},
{1,L"Св. Св Кирил и Методий",L"Свети Кирил и Методий"},
{1,L"Св. Св.",L"Свети"},
{1,L"Св. Тома",L"Свети Тома"},
{1,L"С. Румянцев ",L"Сергей Румянцев"},
{1,L"скоростта",L"скороста"},
{1,L"Ст. Л.",L"Сте Ле"},
{1,L"Стефанов-Казака",L"Стефанов Казака"},
{1,L"Теод.",L"Теодор"},
{1,L"Тодор Г. Влайков",L"Тодор Влайков"},
{1,L"Тодор Ф. Чипев",L"Тодор Чипев"},
{1,L"Ф. М. Достоевски",L"Достоевски"},
{1,L"Хр. Ботев",L"Христо Ботев"},
{1,L"Хр. Попбожилов",L"Христо Попбожилов"},
{1,L"Хр. Смирненски",L"Христо Смирненски"},
{1,L"Ц. Гинчев",L"Гинчев"},
{1,L"Цар Асен I",L"Цар Асен първи"},
{1,L"Цар Борис I",L"Цар Борис първи"},
{1,L"Цар Борис III",L"Цар Борис трети"},
{1,L"Сл. Бряг",L"Слънчев Бряг"},
{1,L"Св. Влас",L"Свети Влас"},
	{1,L"I",L"първи"},
	{1,L"II",L"втори"},
	{1,L"III",L"трети"},
	{1,L"IV",L"четвърти"},
	{1,L"km",L"километра"},
	{1,L"км",L"километра"},
	{1,L"km/h",L"километра в час"},
	{1,L"км/ч",L"километра в час"},
	{1,L"км/час",L"километра в час"},
	{1,L"V",L"пети"},
	{2,L"\\s\\s+",L" "},
        {2,L",\\.",L","},
        {2,L"\\.,",L"."},
        {2,L",,+",L","},
        {2,L"\\.\\.+",L"."},
	{1,L"Acc",L""},
	{1,L"Afb",L""},
	{1,L"Aly",L""},
	{1,L"Appr",L""},
	{1,L"Arc",L""},
	{1,L"Av",L""},
	{1,L"Ave",L""},
	{1,L"Ay",L""},
	{1,L"Bch",L""},
	{1,L"Blvd",L""},
	{1,L"Bndgs",L""},
	{1,L"Bnk",L""},
	{1,L"Br",L""},
	{1,L"Brdge",L""},
	{1,L"Brdwy",L""},
	{1,L"Brg",L""},
	{1,L"Bri",L""},
	{1,L"Brk",L""},
	{1,L"Brks",L""},
	{1,L"Bros",L""},
	{1,L"By",L""},
	{1,L"Byp",L""},
	{1,L"Byps",L""},
	{1,L"Cem",L""},
	{1,L"Ch",L""},
	{1,L"Chas",L""},
	{1,L"Chyd",L""},
	{1,L"Cir",L""},
	{1,L"Cirs",L""},
	{1,L"Cl",L""},
	{1,L"Clb",L""},
	{1,L"Clf",L""},
	{1,L"Clfs",L""},
	{1,L"Cmn",L""},
	{1,L"Cmp",L""},
	{1,L"Cnl",L""},
	{1,L"Cnr",L""},
	{1,L"Co",L""},
	{1,L"Col",L""},
	{1,L"Com",L""},
	{1,L"Cor",L""},
	{1,L"Cors",L""},
	{1,L"Cotts",L""},
	{1,L"Cp",L""},
	{1,L"Cpc",L""},
	{1,L"Cpl",L""},
	{1,L"Cr",L""},
	{1,L"Cres",L""},
	{1,L"Crft",L""},
	{1,L"Crk",L""},
	{1,L"Crse",L""},
	{1,L"Crst",L""},
	{1,L"Crve",L""},
	{1,L"Cs",L""},
	{1,L"Cswy",L""},
	{1,L"Ct",L""},
	{1,L"Cts",L""},
	{1,L"Cty",L""},
	{1,L"Cv",L""},
	{1,L"Cvs",L""},
	{1,L"Dl",L""},
	{1,L"Dm",L""},
	{1,L"Dr",L""},
	{1,L"Dr",L""},
	{1,L"Dr",L""},
	{1,L"Embkt",L""},
	{1,L"Ent",L""},
	{1,L"Esq",L""},
	{1,L"Expy",L""},
	{1,L"Fd",L""},
	{1,L"Fld",L""},
	{1,L"Flds",L""},
	{1,L"Fls",L""},
	{1,L"Flt",L""},
	{1,L"Flts",L""},
	{1,L"Fm",L""},
	{1,L"Fr",L""},
	{1,L"Frd",L""},
	{1,L"Frds",L""},
	{1,L"Frg",L""},
	{1,L"Frgs",L""},
	{1,L"Frk",L""},
	{1,L"Frks",L""},
	{1,L"Frst",L""},
	{1,L"Frsts",L""},
	{1,L"Fry",L""},
	{1,L"Ft",L""},
	{1,L"Fwy",L""},
	{1,L"Gdn",L""},
	{1,L"Gdns",L""},
	{1,L"Gen",L""},
	{1,L"Gln",L""},
	{1,L"Glns",L""},
	{1,L"Gn",L""},
	{1,L"Grn",L""},
	{1,L"Grng",L""},
	{1,L"Grns",L""},
	{1,L"Grv",L""},
	{1,L"Grvs",L""},
	{1,L"Gt",L""},
	{1,L"Gy",L""},
	{1,L"Hd",L""},
	{1,L"Hl",L""},
	{1,L"Hllw",L""},
	{1,L"Hls",L""},
	{1,L"Hosp",L""},
	{1,L"Hs",L""},
	{1,L"Hse",L""},
	{1,L"Hts",L""},
	{1,L"Hvn",L""},
	{1,L"Hwy",L""},
	{1,L"Inlt",L""},
	{1,L"Is",L""},
	{1,L"Iss",L""},
	{1,L"Jct",L""},
	{1,L"Jcts",L""},
	{1,L"Knl",L""},
	{1,L"Knls",L""},
	{1,L"La",L""},
	{1,L"Lck",L""},
	{1,L"Lcks",L""},
	{1,L"Ldg",L""},
	{1,L"Lk",L""},
	{1,L"Lks",L""},
	{1,L"Ln",L""},
	{1,L"Ln",L""},
	{1,L"Lnd",L""},
	{1,L"Lp",L""},
	{1,L"Lt",L""},
	{1,L"Lwn",L""},
	{1,L"Sts",L""},
	{1,L"Ter",L""},
	{1,L"Trk",L""},
	{1,L"Trl",L""},
	{1,L"Tun",L""},
	{1,L"Tunl",L""},
	{1,L"Twr",L""},
	{1,L"Upas",L""},
	{1,L"Via",L""},
	{1,L"Vl",L""},
	{1,L"Vlg",L""},
	{1,L"Vlgs",L""},
	{1,L"Vls",L""},
	{1,L"Vly",L""},
	{1,L"Vlys",L""},
	{1,L"Vw",L""},
	{1,L"Vws",L""},
	{1,L"Whrf",L""},
	{1,L"Wk",L""},
	{1,L"Wl",L""},
	{1,L"Wl",L""},
	{1,L"Wls",L""},
	{1,L"Wy",L""},
	{1,L"Wys",L""},
	{1,L"Xing",L""},
	{1,L"Xrd",L""},
	{1,L"Yd",L""},
	})

transform.direction_abbrev = TRANSFORM.new({
	{1,L"M",L"магистрала"},
	{1,L"E",L"изток"},
	{1,L"W",L"запад"},
	{1,L"S",L"юг"},
	{1,L"N",L"север"},
	{1,L"NE",L"североизток"},
	{1,L"NW",L"северозапад"},
	{1,L"SE",L"югоизток"},
	{1,L"SW",L"югозапад"},
})

transform.direction_roadname_abbrev = TRANSFORM.new(transform.direction_abbrev, transform.roadname_abbrev_table)
