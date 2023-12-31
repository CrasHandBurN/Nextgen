LuaQ    ipxvyuo/externalappconfig.lua           v      @@ @ E     \ 	@   @@ @ E     \ 	@$    $@  À $    $À  @ $      d@     G EÀ   ÊÀ  
 E Á "A É 
 AA "A É Á A  É \@d    ¤À    @ ¤   ¤@ À ¤    @ ¤À    ä  ÇÀ ÅÀ  JÁ Å B EÂ  ÅÂ ¢AIÁ ÁA  IIÁHIAIIÁI Á
 ¢A IIÊIÁJ¤A I¤ I¤Á    IÜ@ÅÀ Ë Ìd    Ü@ä@ Ç@ ÅÀ  J  ÅÁ Â ¢A IIMIÍ¤ IÜ@ÅÀ Ë ÌdÁ Ü@  8      MODEL    SETPERSISTENT    lua    ExternalAppButtonCockpit    BOOL_MODEL    ExternalAppButtonQuick    VW_LoadExternalAppList    VW_killBackgroundProcesses    sc_ResetExternalAppList    VW_GetQVName    VW_Manual_Selection    createState    st_Icon_Manual_Selection    extends 
   st_Common    st_Popover 
   useLayers    ui_Manual_SVG_Selection    title    m_i18n    Icon Manual Selection    sc_ReloadExternalAppList    VW_ExternalappconfigOnrelease    VW_RunAppNow    VW_App_iconReturn    VW_NextIndexID ÿÿÿÿ   VW_Filter_VarNameWstring    st_Externalappconfig    st_FooterMenu 	   st_Input    st_LocalMenu 
   emptytext    Enter an App name 
   localmenu    ui.lm_Externalappconfig 
   maxlength d   
   validator    none    ui_Externalappconfig    footermenu    ui.lm_Externalappconfig_footer    External app config    enter    done    exit    hook_StartInit 	   register %   sc_st_externalapp_settings_Onrelease    st_externalapp_settings    st_List     	   listname    ui.lm_externalapp_Settings    hook_DebugSnapshot           a      
      A@    @À  E     Á@ \@        sc_ScanGivenFolder 	)   % a p p % / u i _ n e x t g e n / r e s / c o m m o n / n o d p i / a p p s v g   	   f c a t e g o r y : 1   	  
------------------------------------------------------
local function utf8_to_unicode(utf8str, pos)
	-- pos = starting byte position inside input string
	local code, size = utf8str:byte(pos), 1
	if code >= 0xC0 and code < 0xFE then
		local mask = 64
		code = code - 128
		repeat
			local next_byte = utf8str:byte(pos + size)
			if next_byte and next_byte >= 0x80 and next_byte < 0xC0 then
				code, size = (code - mask - 2) * 64 + next_byte, size + 1
			else
				return nil
			end
			mask = mask * 32
		until code < mask
	elseif code >= 0x80 then
		return nil
	end
	-- returns code, number of bytes in this utf8 char
	return code, size
end

function utf8_to_unicodeResult(utf8str)
	local code_hex, code1, code2
	local code, size
	local pos, result_unicode = 1, {}
	while pos <= #utf8str do
		code, size = utf8_to_unicode(utf8str, pos)
		if code then
			pos = pos + size
			code_hex = string.format("%04X", code)
			code_hex = string.gsub(code_hex, "(%w%w)(%w%w)", function(s1, s2) return "0x" .. s1 .. "0x" .. s2 end)
			_, _, code1, code2 = string.find(code_hex, "(0x%w%w)(0x%w%w)")
			code1 = string.char(load("return " .. code1)())
			code2 = string.char(load("return " .. code2)())
		else
			return utf8str  -- wrong UTF-8 symbol, this is not a UTF-8 string, return original string
		end
		table.insert(result_unicode, code2 .. code1)
	end
	return table.concat(result_unicode)  -- return converted string
end
------------------------------------------------------

	file_eapp = io.open(userlists_path .. "/ExternalAppList.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!

	file_eapp:write(string.char(0xFF) .. string.char(0xFE))

	local pm = activity:getPackageManager()
	local packages = pm:getInstalledApplications(activity.GET_META_DATA)
	local size = packages:size()

	local packageInfo, packageName, ai, str

	for i=0,size-1 do
		packageInfo = packages:get(i)
		packageName = packageInfo.packageName
		ai = pm:getApplicationInfo(packageName)
		if ai and string.find(packageInfo.sourceDir, "^/data/app/") and pm:getLaunchIntentForPackage(packageName) then --nonSystem app
			str = ";" .. packageName --.. ";;0;1;1"
			str = string.gsub(str, ".", function(s) return s .. string.char(0x00) end) --utf16
			str = str .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00)
			file_eapp:write(utf8_to_unicodeResult(pm:getApplicationLabel(ai)) .. str)
		end
	end

	file_eapp:close()
	os.exit()
	    VW_runLuaJava K       
               ^   `   `   `   `   a         chunk    	           c   k     	   A      Á@  UÀ   À  Á  @     Y   	am = activity:getSystemService(activity.ACTIVITY_SERVICE)
	am:killBackgroundProcesses("    ")
	os.exit()
	    VW_runLuaJava K       	   f   f   h   h   j   j   j   j   k         packageName           chunk               m   q            E@  FÀ FÀÀ   FÁ  \A !  þ        ModelList_iter    MODEL    ui    lm_ExternalAppList    checked        n   n   n   n   n   n   o   o   o   n   o   q         (for generator)          (for state)          (for control)          item    	      index    	           t   v        E   F@À    Á  \Z@   E   F@À    ÁÀ  \^          string    match    _(%w+).    (%w+).        u   u   u   u   u   u   u   u   u   u   u   u   u   v         name                x   ~              @  E  À  Á  A @À  AÀ    @        gScanGivenFolder_done    sc_NextStateAnim    st_Icon_Manual_Selection    fade        
   doDelayed 
          y   y   y   z   z   z   z   z   z   z   |   |   |   |   ~          -   sc_IfFindInScanGivenSVGList_Manual_Selection                   A@   @  À   AÀ    @   @         sc_FindInScanGivenFolderList 	   i c o _ G m a i l . s v g      sc_ScanGivenFolder 	)   % a p p % / u i _ n e x t g e n / r e s / c o m m o n / n o d p i / a p p s v g   	   f c a t e g o r y : 1                                                     -   sc_IfFindInScanGivenSVGList_Manual_Selection        £     	-          	@  E  FÀÀ F Á  EA Á \  KÁÁÁ \Z  @ ÉÂÀEÁ  ÆÁÜ B \ Z  @ ÉÃ  ÉÂ!  ù  À@  A ÀC @ À   A@    @        gScanGivenFolder_done    ModelList_iter    MODEL    ui    lm_ExternalAppList 	   u16_ansi    name    find    [-ÿ]    bmp    ico_applications.svg    sc_FindInScanGivenFolderList 	   i c o _   	   . s v g      wandel.svg    save 
   doDelayed 
       -                                                                                                                           ¡   ¡   ¡   ¡   £         (for generator)    "      (for state)    "      (for control)    "      item 	          idx 	             sc_IfFindInScanGivenSVGList     ¥   ­           @@ @ À@ @   @ @ A ¤      @        MODEL    ui    lm_ExternalAppList    clear    VW_LoadExternalAppList 
   doDelayed È          ©   ¬           @@ @ À@ @    @         MODEL    ui    lm_ExternalAppList    load        ª   ª   ª   ª   ª   «   «   ¬             sc_IfFindInScanGivenSVGList    ¦   ¦   ¦   ¦   ¦   ¨   ¨   ©   ©   ¬   ¬   ©   ­             sc_IfFindInScanGivenSVGList     ¯   ±            E@    ÁÀ   @        sc_NextStateAnim    st_Externalappconfig    fade               °   °   °   °   °   °   ±               ³   µ        E   @  À      \ \@         loadstring (   java:call("android.startExternalApp", "    ")        ´   ´   ´   ´   ´   ´   ´   µ         packagename                ·   À           @@ @ @ÁÀ    A @              var    new    wandel.svg 	   a p p s v g / i c o _   	   . s v g          ¸   ¸   ¸   º   º   »   »   »   »   ¼   ¼   ¾   À         bmp           name        	   svg_path               Ä   É           @@ @       À   @@ @ E   F@À FÀ FÀÀ \ L Á    @@@  P 	@ AÀ    @         MODEL    ui    lm_ExternalAppList    index       VW_NextIndexID 
   doDelayed d          Å   Å   Å   Å   Å   Å   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Æ   Ç   Ç   Ç   Ç   Ç   É             VW_NextIndex     á   ç        E   F@À   Å   ÆÀÀ   Ü    Á    E  FÁÀA AÁA\   Õ \Z    B  ^  @ B   ^          wstring    find    sc_wstring_lower    lower 	   ^      ui 
   inp_Input    value        â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   â   ã   ã   ã   å   å   ç      	   variable                þ              E@  @   À@  A @A @   À@  A A @   À@  A    @  @ À @         killDelayed    VW_NextIndexID    MODEL    ui    lm_ExternalAppList    clear    load    sc_ReloadExternalAppList        ÿ   ÿ   ÿ                                                                       @@ @ 	 Á        MODEL    ui    lm_ExternalAppList    index                                  	            @@ 	À@   @ @A A @    @ @A ÀA @    @ @A  B @    @   	      ui 
   inp_Input    value 	        MODEL    lm_ExternalAppList    save    clear    load        
  
  
                                                VW_NextIndex                 @@ @ 	 Á AÀ    @  A  ¤   @  	      MODEL    ui    lm_ExternalAppList    index        VW_NextIndexID 
   doDelayed ,                         E@  FÀ FÀÀ F Á  ÀFAÁ\ Z  À E ÁÁ \A  !  @ý        ModelList_iter    MODEL    ui    lm_ExternalAppList    unfiltered_list    start    VW_RunAppNow    packagename                                                  (for generator)          (for state)          (for control)          item          idx                                                    VW_NextIndex     !  #           E@    ÁÀ   @        sc_NextStateAnim    st_externalapp_settings    fade               "  "  "  "  "  "  #              ,  .           E  FÀÀ F Á @  F FÁ \ 	@        SELF    title    ui    lm_ExternalAppList    list    AppIndexToChange    name        -  -  -  -  -  -  -  -  -  -  .              3  :        @       A  @ AÁÀ  Á  UÀ 	@  	Â        UX_Name    plugin~externalappconfig    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      end_ >   ****************************end******************************        4  4  6  6  6  6  6  6  6  6  6  9  9  :          v                                             a      k   c   q   m   v   t   ~   ~                                                               £   £   ­   ­   ¥   ±   ¯   µ   ³   À   ·   Â   Â   É   É   ç   á   é   é   é   ê   ë   ì   í   î   ð   ð   ð   ò   ò   ò   ò   ó   ô   õ   ø   ú   ú   ú   û   ü                 é             #  !  %  %  %  &  '  )  )  )  *  +  .  .  %  3  3  :  3  :     -   sc_IfFindInScanGivenSVGList_Manual_Selection    u      sc_IfFindInScanGivenSVGList .   u      VW_NextIndex ;   u       