LuaQ    ipxvyuo/SkinChanger.lua           	1      @@ @ E  @ \ 	@   @@ @ E  @ \ 	@ $   AÀ ¤@            ä     Ç  äÀ  Ç@ Å Á JA  ÅA  ¢A IIÄIÄ ÁA  I¤ IÜ@ÅÀ Ë ÆdA Ü@ä Ç@         MODEL    SET    lua    SelectedSkin    CSTRING_MODEL    VW    SelectedSkin_radio    TTTT    VW_SelectSkin    VW_Change_Skin    createState    st_SelectSkin    extends    st_List    st_FooterMenu 	   listname    ui.list_Skin    footermenu    ui.lm_SelectSkin_footer    title    m_i18n    Skin Changer    enter    hook_StartInit 	   register    sc_btnSkinChange_OnRelease           "            E@     Á  \@       	local t, str, s_main
	file_skin_list = io.open(userlists_path .. "/SkinList.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!
	file_skin_list:write(string.char(0xFF) .. string.char(0xFE))
	local t_u = io.list(storage .. appname)
	for i_u, v_u in ipairs(t_u) do
		if string.find(v_u, "/ux") then
			t = io.list(v_u)
			for i, v in ipairs(t) do
				if string.find(v, "the_skin") then
					s_main = string.match(v, "the_skin_(.+)%.zip")
					if not s_main then
						s_main = "default"
					end
					str = v_u .. ";" .. s_main .. ";" .. s_main .. ";" .. s_main .. ".svg" .. ";lua.SelectedSkin_radio;RadioCustomIcon;1;1"
					--<userlist list_Skin ux="str" text="str" value="str" img="str" group="str" type="str" enable="bool" visible="bool" >
					str = string.gsub(str, ".", function(s) return s .. string.char(0x00) end) --utf16
					str = str .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00)
					file_skin_list:write(str)
					break
				end
			end
		end
	end
	file_skin_list:close()
	os.exit()
	    VW_runLuaJava 2             !   !   !   !   "         chunk               %   7     6         @@  E  FÀÀ F Á  A AFÁÁ\    A BEÁ ÁÁ \       A  @ A     CD  	A  CD  	A@ !@  ÷  @ @ A ¤   @À @ AÀ   @        gScanGivenFolder_done    ModelList_iter    MODEL    ui    ScanGivenFolderList    wstring    find    fname 	
   ^ t h e _ s k i n      string    match 	   tostring    ^the_skin_(.+)%.zip    default    lua    SelectedSkin_radio    SelectedSkin 
   doDelayed 2             3   3            E@    ÁÀ   @        sc_NextStateAnim    st_SelectSkin    fade               3   3   3   3   3   3   3           6   &   &   &   '   '   '   '   '   '   (   (   (   (   (   (   (   (   )   )   )   )   )   )   )   )   )   *   *   *   +   +   -   -   -   -   .   .   .   .   /   '   0   2   2   3   3   3   3   3   5   5   5   5   7         (for generator)    *      (for state)    *      (for control)    *      item 	   (         s_main    VW_AltSkin    VW_UXReady     9   A           @@    @  À  A  @ @   @  @ @À E  @ Á Á @        ui 
   list_Skin        sc_ScanGivenFolder 		   % a p p % / u x   	   f c a t e g o r y : 1      sc_back_to_cockpit    sc_NextStateAnim    st_SelectSkin    fade               :   :   :   :   :   ;   ;   ;   ;   <   <   =   =   =   ?   ?   ?   ?   ?   ?   A             VW_UXReady     C   l      N      Å@  ÆÀÆÀÀ @Á ÅA  ÆAÁÆÁÜ À ÁÁ    Á ÅA  ÆAÁÆÂÜ À ÁÁ @  ¡@  Àù@ À   EA  FAÁFÂ\ Á ÅA  ÆAÁÆÂÜ  @  B ÅB  ÆBÁÆÁÜ   Å@  Æ ÄÆ@ÄÆÄÁ A   ÅA  Ü Áä  ÁÜ ÇÀ Å  A Ü@ Å A  AAÁF dA     Ü@        ModelList_iter    MODEL    ui 
   list_Skin    text    lua    SelectedSkin_radio    ux    SelectedSkin K   	local ntime = os.time() + 5
	repeat until os.time() > ntime

	os.rename("    ", storage .. appname .. "/ux_ M   /")
	os.rename(storage .. appname .. "/save/", storage .. appname .. "/save_    /")

	os.rename(" Y   ", storage .. appname .. "/ux/")
	local r_code = os.rename(storage .. appname .. "/save_   /", storage .. appname .. "/save/")
	if not r_code then
		--local File = luajava.bindClass("java.io.File")
		--local f = luajava.new(File, storage .. appname .. "/save/")
		--f:mkdir()
	end

	act = pm:getLaunchIntentForPackage(packageName)
	activity:startActivity(act)

	os.exit()
	    gVoiceTTSID    sound    speech    say    voice.info    localized_sentence 
   translate    RESTARTING, PLEASE WAIT... 	   callback 
   NEXTSTATE    st_RestartState 
   doDelayed    RunLuaJavaDelay        d   h          @ A  G@             gVoiceTTSID            e   e   f   f   h         res                k   k           D   @  Å  @         VW_runLuaJava        EXIT        k   k   k   k   k   k             chunk N   E   E   E   E   E   E   F   F   F   F   F   F   F   F   G   G   G   I   I   I   I   I   I   I   I   J   J   J   E   K   Q   Q   Q   Q   Q   Q   Q   R   R   R   R   R   T   T   U   U   U   U   U   `   `   b   b   b   b   b   b   b   c   c   c   c   h   h   b   i   j   j   j   k   k   k   k   k   k   k   k   l      	   new_skin     M   	   old_skin     M      (for generator)          (for state)          (for control)          item          chunk 3   M           s   v            @@ @ À@ @    @@ @  A @         MODEL    ui 
   list_Skin    clear    load        t   t   t   t   t   u   u   u   u   u   v               y   {            @@ @ À@ @         MODEL    ui 
   list_Skin    clear        z   z   z   z   z   {               }         
.      @@ @  E   F@À FÀÀ \ W@      A @A A J    Á  ¢@ I  Ê   AÁ  Å  ÆAÀÆÀÜ B Õâ@ 
 d   Á   B@Â@ AB B"A ¢@ I@         MODEL    lua    SelectedSkin_radio    SelectedSkin    screen    msgbox    create_from    line 3   The program will restart. Do you want to continue?    button    VW_Change_Skin    Ok        .svg    Cancel                       @@ E   F@À FÀÀ \ 	@         MODEL    lua    SelectedSkin_radio    SelectedSkin                                        .   ~   ~   ~   ~   ~   ~   ~   ~   ~   ~                                                                                                                       1                                             "   $   7   7   7   7   A   A   9   l   C   n   n   n   o   o   o   o   o   p   q   r   r   r   r   v   v   n   y   y   {   y      }            VW_AltSkin    0      s_main    0      VW_UXReady    0       