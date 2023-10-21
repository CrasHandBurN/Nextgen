module("VOICE", package.seeall)

function init()
	dofile(L"%app%/config/config_numbers.lua")					-- Tavolsag string tabla
	dofile(L"%app%/config/config_condfun.lua")					-- Rules feltetel fuggvenytablak
	init_functions()
	dofile(L"%app%/config/config_database.lua")					-- Osszerendelese a ruleokank, conditionoknek es a patterneknek
	dofile(L"%app%/config/config_transform_tables.lua")			-- Transzformacio tablak
	dofile(L"%app%/config/config_transforms.lua")				-- Transzformacio kod
end

engine = L"engine_1_1"