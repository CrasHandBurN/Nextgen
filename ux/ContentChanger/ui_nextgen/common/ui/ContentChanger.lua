LuaQ    ipxvyuo/ContentChanger.lua           9      @@ @ E  @ \ 	@   A @ E    \ 	@   A @ E À \ 	@   A @ E @ \ 	@ $   d@     ¤      ¤À      À   Á@ 
 J Á bA 	A	AEEÁ  \ 	AEÁ 	A@ ÀF$ @        MODEL    SET    lua    SelectedMapContent 
   INT_MODEL ÿÿÿÿ   SETPERSISTENT    SelectedMapContent_radio        SelectedMapContent_img    CSTRING_MODEL        SelectedMapContent_Default    unknown    sc_SelectMapContent    sc_btnMapChange_OnRelease    createState    st_SelectMapContent    extends    st_List 	   listname    ui.list_MapProvider    title    m_i18n    Content Changer    exit    hook_DebugSnapshot 	   register           9      #      @@ E  FÀÀ   @AA F FÀÁ \   Á@  A    ÁÀ UÀ   Å@  Ü  @  À Å  @ @ Å  Æ@ÁÆÄÜ $     @        string    gsub    ui    list_MapProvider    MODEL    lua    SelectedMapContent_radio 
   frootpath 
   ^%%root%%     ¦   		local path = storage .. appname
		file_sys = io.open(path .. "/sys.txt", "r")
		local sys = file_sys:read("*a")
		file_sys:close()
		local map_path = string.gsub(" ¥  ", "%%app%%", path)
		local add = ""
		file_sys = io.open(map_path .. "/add.txt", "r")
		if file_sys then
			add = file_sys:read("*a")
			file_sys:close()
		end

		local l_adds

		local prolog = ";;;START change provider;;;"
		local epilog = ";;;END change provider;;;"
		if add ~= "" then
			add = prolog .. string.char(0x0A) .. add .. string.char(0x0A) .. epilog
		end
		sys, l_adds = string.gsub(sys, prolog .. ".+" .. epilog,  add)

		if l_adds == 0 then
			sys = sys .. add
		end

		file_sys = io.open(path .. "/sys.txt", "w")
		file_sys:write(sys)

		file_sys:close()

		----
		local ntime = os.time() + 5
		repeat until os.time() > ntime

		--to remove "poi_visiblities.txt" as it is different in each content
		os.remove(path .. "/save/poi_visiblities.txt")
		os.remove(path .. "/save/profiles/01/poi_visiblities.txt")

		act = pm:getLaunchIntentForPackage(packageName)
		application:startActivity(act)
		----
		os.exit()
		    sc_Voice_TTS    sc_translate_VoiceOrLang    RESTARTING, PLEASE WAIT... 
   NEXTSTATE    st_RestartState 
   doDelayed    RunLuaJavaDelay        8   8           D   @  Å  @         VW_runLuaJava        EXIT        8   8   8   8   8   8             chunk #                                                   4   4   6   6   6   6   6   7   7   7   8   8   8   8   8   8   8   8   9      	   map_path    "      chunk    "           ;   a     £      A@       &    ÅÀ  Æ ÁÆ@ÁÆÁÁ Æ Æ ÂÜ    Á@  EÁ  FÁÂFÃB CFÂÃ\    Ì@ÄB DFÂÃ\  ÁÂ     ÀD @Â  EBE E AÂ U@Â  EBE      EB FÄÂÃ Á Ã \   E AÂ U@ @      Â BFF B Å CÇ Ü  ÂÂ B À Â  E	Â@ C@ B   Â  EEÂ  FÅFÈ\ 	B!A  êÁ  EÁG @B 	Á  EEÁ FAÆFÁÈFÇ\ 	AÁ  EE FÄ Á	 B	 \ 	AÁ AFÁHEÁ  FÅFAÅ\ KÅ\ Á U	AÁ AFÁHEÁ  FÅFAÅ\ 	A	 EÁ	 
 ÁA B	 AÀ @
 A
    @  +      sc_FindInScanGivenFolderList 	   m a p      VW_GetIconByIconID    MODEL    other 	   contents    list    current    prov_icon_id ÿÿÿÿ   ModelList_iter    ui    ScanGivenFolderList    wstring    find    fname 	   ^ m a p         gsub 	        lua    SelectedMapContent_Default    lower    .svg 	   tostring    list_MapProvider    add    text    img 
   frootpath    value    SelectedMapContent    string    images/provider/    SelectedMapContent_radio        %..+$        sc_NextStateAnim    st_SelectMapContent    fade 
   doDelayed        £   <   <   <   <   <   =   >   >   >   >   >   >   >   >   >   >   @   A   A   A   A   A   A   B   B   B   B   B   B   B   B   C   D   D   D   D   D   D   D   D   E   E   F   F   F   F   F   F   F   F   G   G   G   G   G   G   I   I   I   I   I   I   I   I   I   I   I   I   I   J   J   J   J   L   L   L   L   L   L   L   L   L   L   L   L   L   M   M   N   N   N   N   O   O   O   O   O   O   O   P   P   P   P   P   P   P   A   R   U   U   U   U   U   U   V   V   V   V   V   V   V   V   W   W   W   W   W   W   W   W   W   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Z   Z   Z   Z   Z   Z   Z   Z   ]   ]   ]   ]   ]   ]   ]   _   _   _   _   a         text          img       	   img_curr          indx          (for generator)    l      (for state)    l      (for control)    l      item    j         sc_ContentFoldersList     c   y     ;      @@ @ À@ A  @ @ @  ÀA     B 	@ A À Á   W C E@ FÃ    ÁÀ \Z   ÀE@  Á   \ Z   ÀE@  Á@  \ À      E@    Á \@D   \@ EÀ \@ @  E@  Á  Á @        MODEL    other 	   contents    select_category_by_id       VW_ContentIndex    ui    list_MapProvider        sc_GetSysEntry    folders    content 	        wstring    find 	   d a t a / d a t a /      has_secondary_root    android_secondary_root_path 	   % a p p %   		   / c o n t e n t   	   % a p p % / c o n t e n t      sc_ScanGivenFolder 	   f c a t e g o r y : 0      sc_back_to_cockpit    sc_NextStateAnim    st_SelectMapContent    fade         ;   e   e   e   e   e   e   f   f   h   h   h   h   h   i   i   i   i   i   j   j   j   j   j   j   j   j   j   k   k   k   k   k   k   k   l   l   l   l   l   l   l   l   n   r   r   r   r   s   s   u   u   u   w   w   w   w   w   w   y         content    3         sc_ContentFoldersList     {        
F      @@ @  E   F@À FÀÀ \ W@  À    A @A A J     Å  A Ü  ¢@  I  Ê $     E Á \  ÅA ÆÃ  B@@ ÆÆÁÃÜ â@  
dA   Á  Á B CE  FBÀFÂÀ\ BÂC "A  ¢@ I @    @D D ÀD E   F@À F Å \  @  @ @         MODEL    lua    SelectedMapContent_radio    SelectedMapContent    screen    msgbox    create_from    line    m_i18n 3   The program will restart. Do you want to continue?    button    Ok        ui    list_MapProvider    img    Cancel    other 	   contents    select_category_by_id    contents_select_category_id    VW_ContentIndex                      @@ EÀ  F Á    @@@A F FÁ \ 	@    @         MODEL    lua    SelectedMapContent_img    ui    list_MapProvider    SelectedMapContent_radio    img                                                               VW_Change_Content                    @@ E   F@À FÀÀ \ 	@         MODEL    lua    SelectedMapContent_radio    SelectedMapContent                                        F   |   |   |   |   |   |   |   |   |   |   }   }   }   }   }   ~                                                                                                                              }                                                 VW_Change_Content     ¢   ¯         @       A  @ AÁÀ  Á  UÀ 	@  E FÀÂ F@Â \ 	@  	@C        UX_Name    plugin~ContentChanger    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      SelectedMapContent    MODEL    lua    end_ 2   ***********************end***********************        £   £   ¥   ¥   ¥   ¥   ¥   ¥   ¥   ¥   ¥   ©   ©   ©   ©   ©   ©   ®   ®   ¯           9                                                                                       9   a   a   y   y   c         {                                                ¢   ¢   ¯   ¢   ¯         VW_Change_Content    8      sc_ContentFoldersList    8       