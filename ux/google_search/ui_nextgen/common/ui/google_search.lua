LuaQ    ipxvyuo/google_search.lua           V   $   d@      G   E@  ��  ��  
 J� ��  bA� 	A�	���d�  	A��d�  	A�\@ E@  ��  �@ 
 J� �A bA� 	A�	���d 	A��dA 	A�\@ E@  ��  ŀ 
 J� �� bA� 	A�	���d� 	A��d� 	A�\@ E@  ��  �� 
 J� �� bA� 	A�	���d 	A��dA 	A�\@ E@  ��  �  
 J� � bA� 	A�	���d� 	A��d� 	A�\@ d      G@ E� K�� �@ \@�E  K�� � \@� �       VW_GoogleOnlineSearch    createState 
   -replace-    st_FindAddressCountry    extends    google_search_isActive        enter    exit    st_FindAddressState    st_FindAddressCity    st_FindAddressStreet    st_FindAddressHNI    VW_Check_Clipboard    hook_StartInit 	   register    hook_DebugSnapshot           ^            @@ �@ �@ @�    @@ �@  A @� @ E� �   \@ E� \@�  �       MODEL    ui    lm_clipboard    clear    save 5  		------------------------------------------------------
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
		    VW_runLuaJava    VW_Check_Clipboard                                      Z   \   \   \   ]   ]   ^         chunk               `   x     	      @@ �@ �@ J�  � � �@ �@� I� ��  �  � A �A �� �@ 
 d     �� �A  "A �@ I� �@  �       MODEL    screen    msgbox    create_from    line L   Please select only the coordinates to be used as waypoints or destinations!    button    sc_ResumeMSGbox    Cancel        ico_cancel.svg    Google Online Search    ico_GoogleMaps.svg        m   p           @�    @�  �       sc_ResumeMSGbox        n   n   o   o   p             VW_GoogleOnlineSearchDo    a   a   a   a   a   b   d   d   d   e   e   g   h   i   k   k   k   p   p   q   r   t   t   u   u   a   x             VW_GoogleOnlineSearchDo     }   �            @@ �@ �@ ��    @�  E  F�� 	@��  	�A� �       MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        ~   ~   ~   ~   ~   ~   ~               �   �   �               �   �            @@ �@ �@ ��    � �  E  F�� 	@�� �       MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    @�  E  F�� 	@��  	�A� �       MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    � �  E  F�� 	@�� �       MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    @�  E  F�� 	@��  	�A� �       MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    � �  E  F�� 	@�� �       MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    @�  E  F�� 	@��  	�A� �       MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    � �  E  F�� 	@�� �       MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    @�  E  F�� 	@��  	�A� �       MODEL    ui    lm_address_fields    size    SELF    google_search_isActive 
   emptytext '   Long press to use Google Search result        �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ ��    � �  E  F�� 	@�� �       MODEL    ui    lm_address_fields    size    SELF 
   emptytext    google_search_isActive        �   �   �   �   �   �   �   �   �   �   �   �               �       �      @@ �@ �@ @�    @@ �@       �"�  @A E� �   �@@��@��A� B�@B� � \�  �� @��   ���   @� �B@ � �A � A� �@ AA@ �� ��   � @ A�@ �� �B@ �A �� � �   �B@�� �A � A� �@ AA@��� ��   �� @�A�@ �� �B@��A � � �  A �EJ�  � � �� I���� ���� I���� E  F��F��F�� \A EA \A� E� � �AHI���E� K��\A �
�  IAI�IJ�  �� �
   B@�@�ABBB� �A  I������ �
 A�
 � �B �A 
 d     �� � � "B J �B  �  AC bB �A�I���A � �� A� �  @� � 5      MODEL    ui    lm_clipboard    load    string    find 	   tostring    list     
   clipboard !   (-?%d+[.,]%d+),%s?(-?%d+[.,]%d+)    gsub    ,    .    �    ^%d    N    -    S    E    W    GCOOR    new    lat    parse_gcoor    lon    my    map    select_gcoor    VW_StopoverOrNewRoute    st_PointOnMap    poiselected    EPoiselected    poi    hook_ShowPointOnMap    trigger    screen    msgbox    create_from    line q   You can use "New Route" and the following data to quickly find your destination by long pressing the input field    button    sc_ResumeMSGbox    Cancel        ico_cancel.svg    Google Online Search    ico_GoogleMaps.svg 
   New Route    ico_route.svg 
   doDelayed 2      VW_Check_Clipboard        �   �           @�    @�  �       sc_ResumeMSGbox        �   �   �   �   �             VW_GoogleOnlineSearchDo     �   �      	       E@  F�� F�� F � F@� F�� \�� �� ��E@  F�� F � F@� \@� A� �   �� `��E�  F�K���A   ��\A�_��E@ \@� E� \@�  �       wsplit    MODEL    ui    lm_clipboard    list     
   clipboard 	   % s ? , % s ?      lm_address_fields    clear       add    text    sc_TriggerAddressSearch    sc_ResumeMSGbox         �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         t 
         (for index)          (for limit)          (for step)          i           �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                     _    �      _    �      lat    �      lon    �      G_coor ^   m         VW_GoogleOnlineSearchDo                  A@  �   @� �    
   doDelayed X         	       .      @@ �@ ��  ���	�   @@ E   F@� F � \�� �   �@@� A��� @A� ��� �@    ��� �  � U � 	@ �@ A� �� �  A E� �  �A@��C�� \�  �@�� E  �@ �       \@�#    �       MODEL    lua    SDK_INT       list_to_delete        "    , "    google_search    sc_translate_VoiceOrLang -   Plugin %s for %s will be unloaded next start 	   " G o o g l e   s e a r c h "   	   A n d r o i d   	       
   towstring    VERSION_RELEASE 
   doDelayed �                      D   @  �       sc_InfoNotification                          msg .   
  
  
  
  
  
                                                                                        msg '   ,          	  	    	                          @     �  A  �@ ��A�� �� �  U�� 	@���  	� �       UX_Name    plugin~google_search    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      end_ >   ****************************end******************************                                            V   ^   x   x   `   z   z   z   z   {   {   {   {   |   �   �   �   �   z   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �       �                           VW_GoogleOnlineSearchDo    U       