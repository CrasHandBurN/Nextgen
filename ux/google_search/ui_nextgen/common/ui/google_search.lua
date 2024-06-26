LuaQ    ipxvyuo/google_search.lua           Z   $   d@      G   E@    ÅÀ  
 J Á  bA 	A	Ád  	AdÁ  	A\@ E@    Å@ 
 J A bA 	A	Ád 	AdA 	A\@ E@    Å 
 J  bA 	A	Ád 	AdÁ 	A\@ E@    ÅÀ 
 J Á bA 	A	Ád 	AdA 	A\@ E@    Å  
 J  bA 	A	Ád 	AdÁ 	A\@ d  G@ AÀ G d@     G  E@ KÄ ä \@EÀ KÄ äÀ \@        VW_GoogleOnlineSearch    createState 
   -replace-    st_FindAddressCountry    extends    google_search_isActive        enter    exit    st_FindAddressState    st_FindAddressCity    st_FindAddressStreet    st_FindAddressHNI    VW_GoogleGcoorToiGO    VW_Check_Clipboard_Id ÿÿÿÿ   VW_Check_Clipboard    hook_StartInit 	   register    hook_DebugSnapshot           c            @@ @ À@ @    @@ @  A @ @ E    \@ EÀ W Â  E@  \@ EÀ \@         MODEL    ui    lm_clipboard    clear    save 5  		------------------------------------------------------
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
		--build = luajava.bindClass("android.os.Build")
		--if build.VERSION.SDK_INT < build.VERSION_CODES.HONEYCOMB then

		--os.remove(userlists_path .. "/clipboard.txt")

		Context = luajava.bindClass("android.content.Context")

		clipboard = activity:getSystemService(Context.CLIPBOARD_SERVICE)

		ClipData = luajava.bindClass("android.content.ClipData")

		--clipboard:setText("")
		--clipboard:clearPrimaryClip()

		clip = ClipData:newPlainText("WordKeeper","")
		clipboard:setPrimaryClip(clip)

		act = pm:getLaunchIntentForPackage("com.google.android.apps.maps")
		application:startActivity(act)

		local ntime = os.time() + 60*5

		repeat until tostring(clipboard:getText()) ~= "" or os.time() > ntime

		if clipboard:hasPrimaryClip() then
			local item = clipboard:getPrimaryClip():getItemAt(0)

			local text = tostring(item:coerceToText()) --:toString() --!!!!!!!!!!!!!!
			--local text = tostring(item:getText())

			file_eapp = io.open(userlists_path .. "/clipboard.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!
			file_eapp:write(string.char(0xFF) .. string.char(0xFE) .. utf8_to_unicodeResult(text) .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00))
			file_eapp:close()

		else
			file_eapp = io.open(userlists_path .. "/clipboard.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!
			--file_eapp:write(string.char(0xFF) .. string.char(0xFE) .. utf8_to_unicodeResult("") .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00))
			file_eapp:close()
		end

		os.exit()
		    VW_runLuaJava    VW_Check_ClipboardId ÿÿÿÿ   killDelayed    VW_Check_Clipboard_Id    VW_Check_Clipboard                                      Z   \   \   \   ^   ^   ^   _   _   _   b   b   c         chunk               e   }     	      @@ @ À@ J    Á@ ¢@ I   Ê  Á A A Á â@ 
 d     Á ÁA  "A ¢@ I @         MODEL    screen    msgbox    create_from    line U   Please select the coordinate or postal address to be used as waypoint or destination    button    sc_ResumeMSGbox    Cancel        ico_cancel.svg    Google Online Search    ico_GoogleMaps.svg        r   u           @    @         sc_ResumeMSGbox        s   s   t   t   u             VW_GoogleOnlineSearchDo    f   f   f   f   f   g   i   i   i   j   j   l   m   n   p   p   p   u   u   v   w   y   y   z   z   f   }             VW_GoogleOnlineSearchDo                    @@ @ À@     @  E  FÁ 	@  	ÀA        MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result                                                                             @@ @ À@     À   E  FÁ 	@        MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive                                                                       @@ @ À@     @  E  FÁ 	@  	ÀA        MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result                                                                             @@ @ À@     À   E  FÁ 	@        MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive                                                        ¢   §            @@ @ À@     @  E  FÁ 	@  	ÀA        MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        £   £   £   £   £   £   £   ¤   ¤   ¤   ¤   ¥   ¥   §               ¨   ¬            @@ @ À@     À   E  FÁ 	@        MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        ©   ©   ©   ©   ©   ©   ©   ª   ª   ª   ª   ¬               ²   ·            @@ @ À@     @  E  FÁ 	@  	ÀA        MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        ³   ³   ³   ³   ³   ³   ³   ´   ´   ´   ´   µ   µ   ·               ¸   ¼            @@ @ À@     À   E  FÁ 	@        MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        ¹   ¹   ¹   ¹   ¹   ¹   ¹   º   º   º   º   ¼               Â   Ç            @@ @ À@     @  E  FÁ 	@  	ÀA        MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        Ã   Ã   Ã   Ã   Ã   Ã   Ã   Ä   Ä   Ä   Ä   Å   Å   Ç               È   Ì            @@ @ À@     À   E  FÁ 	@        MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        É   É   É   É   É   É   É   Ê   Ê   Ê   Ê   Ì               Ï   Û     
Z   E      \    E@  FÀ    Á Á\  ÀAÅ     Ü A @   Z   BÀ Â A  ÁA Á ÁAÀ     Á À ÁA  BÀ  AB     BÀÂ A  ÁA UÁ ÁAÀ     ÀÁ[A  BÀ AÂ  @ A  @Ê   @  É @ É @  ^          trim    GCOOR    new    lat        lon    string    find 	   tostring !   (-?%d+[.,]%d+),%s?(-?%d+[.,]%d+)    gsub    ,    .    °    ^%d    N    -    S    E    W    parse_gcoor     Z   Ð   Ð   Ð   Ð   Ñ   Ñ   Ñ   Ñ   Ñ   Ñ   Ò   Ò   Ò   Ò   Ò   Ò   Ò   Ó   Ó   Ó   Ó   Ô   Ô   Ô   Ô   Ô   Ô   Ô   Ô   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Õ   Ö   Ö   Ö   Ö   Ö   Ö   Ö   Ö   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ø   Ú   Û      
   gcoos_str     Y      G_coor 
   Y      _    Y      _    Y      lat    Y      lon    Y           Þ   ;    Ñ      @@ @ À@ @    @@ @       À/   @@ @  A @A A  AÀ @   @  @ À @   @ @ À À     @ Ê  AA  â@ EÁ FÅ  AÁAA\ @Á F@  AÆ  @Á F@  AÆÂ GÂ    G   A   @Á F@  AÇ   Á F@  AÇÁGÂ    G   A   @Á F@  Ç  Á F@  Ç   G   A   A  ÁGHA A E  A    EÁ FÅ  AÁAA\ W@@A  ÁGHÁ AÅ ÁÅ ÁÅÁ ÁÅ ÁÅA ÁÅ ÁA	 E  FAÀFÁÇFÁFAÁA    AIIÁIJ   ÁA
   B@@ABAA ¢A  IÊ Â
 A B Á âA 
 d     Â ÁB  "B J ¤B  ÁB C A bB ¢AIA    A@  À   7      MODEL    ui    lm_clipboard    load    list     
   clipboard    Google Map    street 	        city 	   postcode    state    country    gcoor    VW_GoogleGcoorToiGO 	&   ( . + ) , % s ? ( . + ) , % s ? ( . + ) , % s ? ( . + ) , % s ? ( % d + )   	   ( . + ) , % s ? ( . + ) , % s ? ( . + ) , % s ? ( % d + )   	   ( . + ) , % s ? ( . + ) , % s ? ( . + )      GCOOR    new    lat    lon    wstring    find       _    region 	                lm_android_contacts    clear    trim    add    place_name    sc_AC_ResolveContactAddress    screen    msgbox    create_from    line q   You can use "New Route" and the following data to quickly find your destination by long pressing the input field    button    sc_ResumeMSGbox    Cancel        ico_cancel.svg    Google Online Search    ico_GoogleMaps.svg 
   New Route    ico_route.svg    VW_Check_Clipboard_Id 
   doDelayed d      VW_Check_Clipboard                     @    @         sc_ResumeMSGbox                             VW_GoogleOnlineSearchDo     &  /     	       E@  FÀ FÀÀ F Á F@Á FÁ \ À E@  FÀ F Â F@Â \@ A    Á `E  FÂKÁÂÊA   É\A_ÀýE@ \@ E \@         wsplit    MODEL    ui    lm_clipboard    list     
   clipboard 	   % s ? , % s ?      lm_address_fields    clear       add    text    sc_TriggerAddressSearch    sc_ResumeMSGbox         '  '  '  '  '  '  '  '  '  '  )  )  )  )  )  *  *  *  *  +  +  +  +  +  +  +  *  -  -  .  .  /        t 
         (for index)          (for limit)          (for step)          i           Ñ   ß   ß   ß   ß   ß   à   à   à   à   à   à   á   á   á   á   á   á   á   ã   ä   ä   å   å   æ   æ   ç   ç   è   è   é   é   é   é   ë   í   î   ï   ñ   ñ   ó   ó   ó   ó   ó   ó   ó   ó   ó   ô   ô   ô   ô   ô   ô   ô   õ   õ   õ   õ   õ   õ   õ   õ   õ   õ   õ   õ   ö   ö   ö   ö   ö   ö   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ø   ø   ø   ø   ø   ø   ø   ø   ø   ø   ø   ù   ù   ù   ù   ù   ù   ú   ú   ú   ú   ú   ú   ú   û   û   û   û   û   û   û   û   û   û   ü   ü   ü   ü   ü                                                                         	  	                                                                          !  "  $  $  $  /  0  1  3  3  4  4    7  9  9  9  9  9  ;     
   clipboard    Ê      place_name    Ê      n "   Ê      pattern '   Ê         VW_GoogleOnlineSearchDo     =  H           A@  ¤   @     
   doDelayed X         ?  G     .      @@ @   	   @@ E   F@À F Á \    @@ A @A  @    À Á   U  	@ @ A À Á  A E   A@ÁC \  Õ@ E  @ ä       \@#           MODEL    lua    SDK_INT       list_to_delete        "    , "    google_search    sc_translate_VoiceOrLang -   Plugin %s for %s will be unloaded next start 	   " G o o g l e   s e a r c h "   	   A n d r o i d   	       
   towstring    VERSION_RELEASE 
   doDelayed È          D  D          D   @         sc_InfoNotification        D  D  D  D            msg .   @  @  @  @  @  @  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  C  C  C  C  C  C  C  C  C  C  C  C  C  D  D  D  D  D  D  G        msg '   ,          ?  ?  G  ?  H              J  O        @       A  @ AÁÀ  Á  UÀ 	@  	Â        UX_Name    plugin~google_search    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      end_ >   ****************************end******************************        K  K  M  M  M  M  M  M  M  M  M  N  N  O          Z   c   }   }   e                                                                                                                   ¡   §   §   ¬   ¬      ¯   ¯   ¯   ¯   °   °   °   °   ±   ·   ·   ¼   ¼   ¯   ¿   ¿   ¿   ¿   À   À   À   À   Á   Ç   Ç   Ì   Ì   ¿   Û   Ï   Ý   Ý   ;  ;  Þ   =  =  H  =  J  J  O  J  O        VW_GoogleOnlineSearchDo    Y       