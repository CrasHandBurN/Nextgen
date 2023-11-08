module("VOICE", package.seeall)

engine = L"engine_1_1"

function init()
	dofile(L"%app%/config/config_numbers.lua")
	dofile(L"%app%/config/config_condfun.lua")
	init_functions()
	dofile(L"%app%/config/config_database.lua")
	dofile(L"%app%/config/config_transform_tables.lua")
	dofile(L"%app%/config/config_transforms.lua")
end
