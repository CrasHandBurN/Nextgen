LuaQ    ipxvyuo/ContentChanger.lua           4      @@ @ E  @ \ 	@   @@ @ E  À \ 	@     B @ E À \ 	@$       d@      G  E@  Ê@ 
 E "A É ÉÄ AA  É $  É $Á  É \@d  ¤@      @ F$ @        MODEL    SET    lua    SelectedMapContent 
   INT_MODEL ÿÿÿÿ   SelectedMapContent_radio        SETPERSISTENT    SelectedMapContent_map    CSTRING_MODEL        sc_SelectMapContent    createState    st_SelectMapContent    extends    st_List 	   listname    ui.list_MapProvider    title    m_i18n    Content Changer    enter    exit    sc_btnMapChange_OnRelease    hook_DebugSnapshot 	   register           *     ¬      A@      @(    ÅÀ  Æ ÁÆ@ÁÆÁÁ Æ Æ ÂÜ    Á@  EÁ  FÁÂFÃ B CFÂÃ\     Ì@ÄB DFÂÃ\  ÁÂ     ÀD  A  @   EB FÄÂÃ Á Ã \   ÂE A U@ @      Â BFF B Å CÇ Ü  ÂÂ B  Â  ÂG	Â !A   ñÁ  ÁGH @B@Á AFAH	 Á AFAHE FÄ ÁÁ  \ 	AÁ  ÁGEÁ FAÆFAÈFÇ\ 	AÁ  ÁG	 	Á AFAHEÁ  FÁÇFÉ\  Å A ZA  À EÁ  FÁÇFÉ\ 	AÁ AFAHEÁ  FÁÇFÉ\  Å AA ZA   E FÄÁ  ÁGI ÁÁ  \ 	AÁ  ÁGEÁ  FÁÇFÈ\ 	A	 EÁ	 
 ÁA  AÀ @
 A
    @  +      sc_FindInScanGivenFolderList 	   m a p      VW_GetIconByIconID    MODEL    other 	   contents    list    current    prov_icon_id ÿÿÿÿ   ModelList_iter    ui    ScanGivenFolderList    wstring    find    fname 	   ^ m a p         gsub 	            Default 	   tostring    lower    .svg    list_MapProvider    add    text    img 
   frootpath    value    lua    SelectedMapContent        string    %..+$    SelectedMapContent_map    SelectedMapContent_radio    sc_NextStateAnim    st_SelectMapContent    fade 
   doDelayed        ¬                                                   	   
   
   
   
   
   
                                                                                                                                                                              
                                                                                                      !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   "   $   $   $   $   $   $   $   &   &   &   &   &   &   &   (   (   (   (   *         text    ¦      img    ¦   	   img_curr    ¦      indx    ¦      (for generator)    R      (for state)    R      (for control)    R      item    P         sc_ContentFoldersList     ,   B     ;      @@ @ À@ A  @ @ @  ÀA     B 	@ A À Á   W C E@ FÃ    ÁÀ \Z   ÀE@  Á   \ Z   ÀE@  Á@  \ À      E@    Á \@D   \@ EÀ \@ @  E@  Á  Á @        MODEL    other 	   contents    select_category_by_id       VW_ContentIndex    ui    list_MapProvider        sc_GetSysEntry    folders    content 	        wstring    find 	   d a t a / d a t a /      has_secondary_root    android_secondary_root_path 	   % a p p %   		   / c o n t e n t   	   % a p p % / c o n t e n t      sc_ScanGivenFolder 	   f c a t e g o r y : 0      sc_back_to_cockpit    sc_NextStateAnim    st_SelectMapContent    fade         ;   .   .   .   .   .   .   /   /   1   1   1   1   1   2   2   2   2   2   3   3   3   3   3   3   3   3   3   4   4   4   4   4   4   4   5   5   5   5   5   5   5   5   7   ;   ;   ;   ;   <   <   >   >   >   @   @   @   @   @   @   B         content    3         sc_ContentFoldersList     H   I                      I               J   L            @         sc_btnMapChange_OnRelease        K   K   L               O         #      @@ E  FÀÀ   @AA F FÀÁ \   Á@  A    ÁÀ UÀ   Å@  Ü  @  À Å  @ @ Å  Æ@ÁÆÄÜ $     @        string    gsub    ui    list_MapProvider    MODEL    lua    SelectedMapContent_radio 
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
   doDelayed    RunLuaJavaDelay                      D   @  Å  @         VW_runLuaJava        EXIT                                    chunk #   P   P   P   P   P   P   P   P   P   P   P   P   P   P   W   W   }   }                                                         	   map_path    "      chunk    "                   G      @@ @  E   F@À FÀÀ \ W@       A @A A J     Å  A Ü  ¢@  I  Ê $     E Á \  ÅA ÆÃ  B@@ ÆÆÁÃÜ â@  
dA   Á  Á B E  FÄFÂÄFÅB FFÅ\   "A  ¢@ I @    D ÀD ÀE E   F@À F Æ \  @  @ @         MODEL    lua    SelectedMapContent_radio    SelectedMapContent    screen    msgbox    create_from    line    m_i18n 3   The program will restart. Do you want to continue?    button    Ok        ui    list_MapProvider    img    Cancel    VW_GetIconByIconID    other 	   contents    list    current    prov_icon_id    select_category_by_id    contents_select_category_id    VW_ContentIndex                      @                                 VW_Change_Content                    @@ E   F@À FÀÀ \ 	@         MODEL    lua    SelectedMapContent_radio    SelectedMapContent                                        G                                                                                                                                                                                                                                  VW_Change_Content     £   ¯         @       A  @ AÁÀ  Á  UÀ 	@  E FÀÂ F@Â \ 	@  E FÀÂ F Ã \ 	@   E FÀÃ F Ä 	@  	Ä        UX_Name    plugin~ContentChanger    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      SelectedMapContent    MODEL    lua    SelectedMapContent_map    Release    ui 	   Buildnum    TEXT    end_ 2   ***********************end***********************        ¤   ¤   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ª   ª   ª   ª   ª   ª   «   «   «   «   «   «   ¬   ¬   ¬   ¬   ¬   ®   ®   ¯           4                                                                  *   *   B   B   ,   D   D   D   E   E   E   E   F   G   G   G   G   I   I   L   L   D               £   £   ¯   £   ¯         sc_ContentFoldersList    3      VW_Change_Content ,   3       