LuaQ    ipxvyuo/FontChanger.lua           '      @@ @ E  @ \ 	@$   E À Ê 
 EA "A É ÉÀBÉ@CÉÀC$A  É $      É \@J   ÁÀ b@ ¤À        ä     Ç  Å@ ËÅdA Ü@        MODEL    SETPERSISTENT    lua    SelectedFont    WSTRING_MODEL 	   D e f a u l t      createState    st_SelectFontVW    extends    st_List 	   listname    ui.list_FontsName    title    Font Changer    font_before 	        enter    exit    Droid Sans    Roboto, Black    VW_FontChanger    hook_DebugSnapshot 	   register           7      4      E@    À@ A  \    À@ A W@A@ À  Á @  À B @  À Ã @  @ À     À À     Å@  AÁ  Ü@  Å  A Ü@ Å   Á@ÁE d     Ü@         	   tostring    MODEL    lua    SelectedFont 	   D e f a u l t      [fonts]
default="    "
defaultbd="    "
defaultit="    "
tahomabd="    "
valuefont="    "
valuefontbd="    "    [[    ]] 1   		local path = storage .. appname
		local add =    		file_sys = io.open(path .. "/sys.txt", "r")
		local sys = file_sys:read("*a")
		file_sys:close()

		local prolog = ";;;START change fonts;;;"
		local epilog = ";;;END change fonts;;;"
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
		local ntime = os.time() + 3
		repeat until os.time() > ntime

		act = pm:getLaunchIntentForPackage(packageName)
		application:startActivity(act)
		----
		os.exit()
		    sc_Voice_TTS    sc_translate_VoiceOrLang    RESTARTING, PLEASE WAIT... 
   NEXTSTATE    st_RestartState 
   doDelayed    RunLuaJavaDelay        5   5           D   @  Å  @         VW_runLuaJava        EXIT        5   5   5   5   5   5             chunk 4                                          	   	   
   
                                                   1   1   3   3   3   3   3   4   4   4   5   5   5   5   5   5   5   5   7         add    3      font    3      chunk #   3           >   @            E  FÀÀ F Á \ 	@        SELF    font_before    MODEL    lua    SelectedFont        ?   ?   ?   ?   ?   ?   @               A   E           @@ E  FÀÀ F Á \ W@   @ A ¤      @        SELF    font_before    MODEL    lua    SelectedFont 
   doDelayed           C   C           @              C   C   C             VW_Change_Font    B   B   B   B   B   B   B   B   C   C   C   C   C   E             VW_Change_Font     K   Y     	<         À   E@    À@ A\ @EA FÁÁA Á B \   EA FÂÁA Á \Z  @EÁ  À   Ä  \Z  @EÁ  FAÃKÃÊA  É\Aa@  À÷EÀ  F@Ã KÃ Ê@  É Ä\@E@  ÁÀ  AA \@À  AÀ   @        gScanGivenFolder_done    ModelList_iter    MODEL    ui    ScanGivenFolderList    wstring    gsub    fname 	   % . t t f $   	        find    in_set 	   tostring    list_FontsName    add    text 	   D e f a u l t      sc_NextStateAnim    st_SelectFontVW    fade        
   doDelayed        <   L   L   L   M   N   N   N   N   N   N   O   O   O   O   O   O   O   O   P   P   P   P   P   P   P   P   P   P   P   P   P   P   P   P   Q   Q   Q   Q   Q   Q   N   R   T   T   T   T   T   T   U   U   U   U   U   U   U   W   W   W   W   Y         head    6      (for generator) 	   *      (for state) 	   *      (for control) 	   *      item 
   (         fonts_table    VW_FontsReady     [   c           @@    @  À  A  @ @   @  @ @À E  @ Á Á @        ui    list_FontsName        sc_ScanGivenFolder 	   % a p p % / u i _ n e x t g e n / f o n t s   	   f c a t e g o r y : 1      sc_back_to_cockpit    sc_NextStateAnim    st_SelectFontVW    fade               \   \   \   \   \   ]   ]   ]   ]   ^   ^   _   _   _   a   a   a   a   a   a   c             VW_FontsReady     g   m         @       A  @ AÁÀ  Á  UÀ 	@  	Â        UX_Name    plugin~FontChanger    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      end_ 2   ***********************end***********************        h   h   j   j   j   j   j   j   j   j   j   l   l   m           '                        7   9   9   9   :   :   :   :   ;   <   =   @   @   E   E   E   9   G   H   J   J   Y   Y   Y   c   c   [   g   g   m   g   m         VW_Change_Font    &      fonts_table    &      VW_FontsReady    &       