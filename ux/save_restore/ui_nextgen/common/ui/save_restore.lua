LuaQ    ipxvyuo/save_restore.lua           	>   @       AÀ    Â   d       ¤@  @ ¤   À äÀ         Ç  ä         Ç@ Å ÆÀÂÆ Ã EÁ  \   É Å@  J  Å B ¢A IÁ Á  IIÆ¤A IÜ@ä   $Á          d        G EA KÇäA \A        gsaved_files_list        sc_GetSysEntry    other.driver_profile    enabled    join    VW_SavedList       VW_SaveSettings    VW_RestoreSettings    MODEL    SETPERSISTENT    lua    date_of_file_birth    WSTRING_MODEL 
   translate    NOT SAVED YET    createState    st_save_restore_settings    extends    st_List    st_Popover    title    m_i18n    Save/Restore Settings 	   listname    ui.lm_save_restore_settings    enter    VW_ScanFilesInSave    hook_DebugSnapshot 	   register 
                     D   Z    A@  Z@    A  À    E     \@      ä  		-- experimental support for LuaJava
		--
		local path = {}

		path.link_attrib = nil

		local File = luajava.bindClass("java.io.File")
		local Array = luajava.bindClass("java.lang.reflect.Array")

		local function file(s)
			return luajava.new(File,s)
		end

		function path.dir(P)
			local ls = file(P):list()
			--print(ls)
			local idx,n = -1,Array:getLength(ls)
			return function ()
				idx = idx + 1
				if idx == n then
					return nil
				else
					return Array:get(ls,idx)
				end
			end
		end

		function path.mkdir(P)
			return file(P):mkdir()
		end

		function path.rmdir(P)
			return file(P):delete()
		end

		--- is this a directory?
		-- @param P A file path
		function path.isdir(P)
			if P:match("\\$") then
				P = P:sub(1,-2)
			end
			return file(P):isDirectory()
		end

		--- is this a file?.
		-- @param P A file path
		function path.isfile(P)
			return file(P):isFile()
		end

		-- is this a symbolic link?
		-- Direct support for symbolic links is not provided.
		-- see http://stackoverflow.com/questions/813710/java-1-6-determine-symbolic-links
		-- and the caveats therein.
		-- @param P A file path
		function path.islink(P)
			local f = file(P)
			local canon
			local parent = f:getParent()
			if not parent then
				canon = f
			else
				parent = f.getParentFile():getCanonicalFile()
				canon = luajava.new(File,parent,f:getName())
			end
			return canon:getCanonicalFile() ~= canon:getAbsoluteFile()
		end

		--- return size of a file.
		-- @param P A file path
		function path.getsize(P)
			return file(P):length()
		end

		--- does a path exist?.
		-- @param P A file path
		-- @return the file path if it exists, nil otherwise
		function path.exists(P)
			return file(P):exists() --and P
		end

		--- Return the time of last access as the number of seconds since the epoch.
		-- @param P A file path
		function path.getatime(P)
			return path.getmtime(P)
		end

		--- Return the time of last modification
		-- @param P A file path
		function path.getmtime(P)
			-- Java time is no. of millisec since the epoch
			return file(P):lastModified()
		end

		---Return the system's ctime.
		-- @param P A file path
		function path.getctime(P)
			return path.getmtime(P)
		end

		--return path
		local path_saved = storage .. appname .. "/save/"     .. "profiles/01/" ..      ..  &  "system.ini.saved"

		local data = 'MODEL.lua.date_of_file_birth = L"NOT SAVED YET"'

		if path.exists(path_saved) then

			local t = path.getmtime(path_saved)
			--print(t)
			local c = luajava.bindClass("java.sql.Timestamp")

			local tc = luajava.new(c, t)

			local time = tc:getTime()
			--print(time)

			local time_str = tc:toString(time)

			data = 'MODEL.lua.date_of_file_birth = L"' .. time_str .. '"'
		end

		file_save = io.open(storage .. appname .. "/save/get_data.lua", "w")
		file_save:write(data)
		file_save:close()

		os.exit()
		    VW_runLuaJava        n   n   n   n   n   n   n   n                           chunk 
            profile                    @@ Á@  Þ  Æ@ Á  @    Á  @ Â ÕþÞ                                                                                     table        
   separator           len          str          (for index) 	         (for limit) 	         (for step) 	         i 
                 ¢            E@    ÁÀ  À \ \               wjoin    loadstring    gsaved_files_list w   		local t = {}
		for i=1, #file_name do
			table.insert(t, VW_InsertShield("green", file_name[i]))
		end
		return t
		 	                       ¡   ¡      ¡   ¡      ¡   ¢               ¦   á     	9      @@ EÀ      A@A  \   ÅÀ   AB Ü  UÀ 	@    @B B ÀB JÀ    Å@  D  ÜÁ ¢@ I   Ê  A E Á \  ÁÁ  ÁA â@ 
 d     Á  ÁÁ  "A ¢@ I     I@         MODEL    lua    date_of_file_birth    sc_ShowDateTool    gps    current_date 	     |        sc_ShowDayTimeTool    current_time    screen    msgbox    create_from    line    sc_translate_VoiceOrLang H   Saving will be canceled in %s seconds.
Please select "Save" or "Cancel" 1   If done, the program will restart in two seconds    button    sc_back    m_i18n    Cancel    vr_cmd    ico_cancel.svg    Save        ico_saverestore.svg    timeout è         ·   Ù     '      E@    Ä   Ú    ÁÀ  Ú@    Á  A D  Z   A ZA    A Á  E  @ Á   \@  EÀ   \@ E@  ÀC D ä       \@E@ \@      N   						local ntime = os.time() + 4
						repeat until os.time() > ntime
						    gsaved_files_list    						local path = storage .. appname
						local file
						for i= 1, #file_name do
							file_save = io.open(path .. "/save/"     .. "profiles/01/" ..      ..  §   file_name[i], "rb")
							if file_save then
								file = file_save:read("*a")
								file_save:close()

								file_save = io.open(storage .. appname .. "/save/"    .. "profiles/01/" ..  à   file_name[i] .. ".saved", "wb")
								file_save:write(file)
								file_save:close()
							end
						end

						act = pm:getLaunchIntentForPackage(packageName)
						application:startActivity(act)
						os.exit()
						    sc_Voice_TTS    sc_translate_VoiceOrLang    RESTARTING, PLEASE WAIT... 
   NEXTSTATE    st_RestartState 
   doDelayed    MODEL    lua    RunLuaJavaDelay    sc_ResumeMSGbox        Ö   Ö           D   @  Å  Á  @        VW_runLuaJava        EXIT $   Settings are saving. Please wait...        Ö   Ö   Ö   Ö   Ö   Ö   Ö             chunk '   ½   ½   Ã   Ã   Ã   Ã   Ã   Ã   Ã   Ã   È   È   È   È   È   È   È   È   Ñ   Ñ   Ó   Ó   Ó   Ó   Ó   Õ   Õ   Õ   Ö   Ö   Ö   Ö   Ö   Ö   Ö   Ö   Ø   Ø   Ù         chunk    &         profile 9   §   §   §   §   §   §   §   §   §   §   §   §   §   §   §   §   §   ©   ©   ©   ©   ©   ª   «   «   «   «   ®   ®   ®   ¯   ¯   ±   ²   ²   ²   ³   ³   ³   µ   µ   µ   Ù   Ù   Ú   Ú   Ú   Û   Ý   Ý   Þ   Þ   ß   ß   ß   ©   á             delay    profile     ã       	(      @@ @ À@ JÀ    Å@  D  ÜÁ ¢@ I   Ê  A E Á \  ÁÁ  ÁA â@ 
 d     Á  ÁÁ  "A ¢@ I     I@         MODEL    screen    msgbox    create_from    line    sc_translate_VoiceOrLang N   Restoring will be canceled in %s seconds.
Please select "Restore" or "Cancel" 1   If done, the program will restart in two seconds    button    sc_back    m_i18n    Cancel    vr_cmd    ico_cancel.svg    Restore        ico_saverestore.svg    timeout è         ò       '      E@    Ä   Ú    ÁÀ  Ú@    Á  A D  Z   AÁ  ZA    A   EÀ   Á@   \@  E À \@ E  @ CÀC ä       \@E  \@      N   						local ntime = os.time() + 4
						repeat until os.time() > ntime
						    gsaved_files_list    						local path = storage .. appname
						local file
						for i= 1, #file_name do
							file_save = io.open(path .. "/save/"     .. "profiles/01/" ..      ..  ³   file_name[i] .. ".saved", "rb")
							if file_save then
								file = file_save:read("*a")
								file_save:close()

								file_save = io.open(storage .. appname .. "/save/" Ô   file_name[i], "wb")
								file_save:write(file)
								file_save:close()
							end
						end

						act = pm:getLaunchIntentForPackage(packageName)
						application:startActivity(act)
						os.exit()
						    sc_Voice_TTS    sc_translate_VoiceOrLang    RESTARTING, PLEASE WAIT... 
   NEXTSTATE    st_RestartState 
   doDelayed    MODEL    lua    RunLuaJavaDelay    sc_ResumeMSGbox                    D   @  Å  Á  @        VW_runLuaJava        EXIT '   Settings are restoring. Please wait...                                chunk '   ø   ø   þ   þ   þ   þ   þ   þ   þ   þ                                                                   chunk    &         profile (   ä   ä   ä   ä   ä   å   æ   æ   æ   æ   é   é   é   ê   ê   ì   í   í   í   î   î   î   ð   ð   ð                             ä               delay    profile     &  (           @         VW_ScanFilesInSave        '  '  (              ,  :    	/         	   E  FÀÀ @  Á  A \ G@  E À  B@B\ @E FÁÀÁB Á B \   W@C ÀEA   ÅÁ    Ü  UGA  a@  ÀúE@  @ U G@  À  AÀ    @        gScanGivenFolder_done    gsaved_files_list    string    gsub    }$        ModelList_iter    MODEL    ui    ScanGivenFolderList    wstring    fname 		   % . s a v e d $   	        "userlists/ 	   tostring    ",     } 
   doDelayed        /   -  -  -  .  /  /  /  /  /  /  /  0  0  0  0  0  0  1  1  1  1  1  1  1  1  2  2  3  3  3  3  3  3  3  3  0  4  6  6  6  6  6  8  8  8  8  :        str    )      (for generator)    %      (for state)    %      (for control)    %      item    #      $   sc_IfFindInScanFilesInSaveUserlists     <  L    	8         À   A  G@  EÀ    @AA\ @EÁ FÂAB Á Â \   WÀB ÀEA   ÅA    Ü  UGA  a@  ÀúE@  À U G@  E  @ Ä   Ú    Á Ú@    ÁÀ Á  \@ D  \@ À   A@   @        gScanGivenFolder_done    gsaved_files_list    local file_name = {    ModelList_iter    MODEL    ui    ScanGivenFolderList    wstring    gsub    fname 		   % . s a v e d $   	        " 	   tostring    ",     }    sc_ScanGivenFolder 	   % a p p % / s a v e /   	   p r o f i l e s / 0 1 /   	
   u s e r l i s t s   
   doDelayed        8   =  =  =  >  ?  ?  @  @  @  @  @  @  A  A  A  A  A  A  A  A  B  B  C  C  C  C  C  C  C  C  @  D  F  F  F  F  G  G  G  G  G  G  G  G  G  G  G  G  H  H  H  J  J  J  J  L        str    2      (for generator)           (for state)           (for control)           item             profile $   sc_IfFindInScanFilesInSaveUserlists    sc_IfFindInScanFilesInSave     N  Q          A@           @    À  U @   @         sc_ScanGivenFolder 	   % a p p % / s a v e   	   / p r o f i l e s / 0 1   	            O  O  O  O  O  O  O  O  O  O  O  P  P  Q            profile    sc_IfFindInScanFilesInSave     S  \        @       A  @ AÁÀ  Á  UÀ 	@@       À  E @ ÁÀ À \ \ 	@  	 Ã        UX_Name    plugin~save_restore    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      gsaved_files_list    loadstring    ; return file_name >   ****************************end******************************        T  T  V  V  V  V  V  V  V  V  V  W  W  W  W  X  X  X  X  X  X  X  X  Z  Z  \          >                                    ¢      ¤   á   á   á   ¦         ã                              !  #  #  #  $  $  $  $  %  (  (    :  :  L  L  L  L  Q  Q  Q  N  S  S  \  S  \        profile    =      VW_LastSavingDate 	   =      delay    =   $   sc_IfFindInScanFilesInSaveUserlists 1   =      sc_IfFindInScanFilesInSave 5   =       