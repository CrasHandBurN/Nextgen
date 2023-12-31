LuaQ    ipxvyuo/google_contacts.lua           2   $      @  @ À@ E@  \ 	@ $@  À @    AÀ @ Ê  A E Á Å â@ À Ê   â@ À ÅÅ ÆÆÆ@GFä  ÀäÀ  À ä  Àä@ À @$ À $À  	 $  @	   &      VW_LoadContactsList    MODEL    SET    lua    ContactType    CSTRING_MODEL    Phone    VW_Filter_contacts    gContact_phrase    contact    createState    st_SimpleInputContact    extends 	   st_Input    st_CommonList    st_FooterMenu    st_Popover 
   useLayers    ui_ContactVisibilityList    footermenu    ui.lm_Contacts_footer 
   emptytext     
   maxlength <      smallInput    autoOpenKeyboard    contact_index        doneKeyButton    keydone    enter    done    exit    VW_PhoneMark    VW_EmailMark    sc_ReloadContactsList 	          s            E@     \@        
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

	file_contacts = io.open(userlists_path .. "/contacts.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!

	file_contacts:write(string.char(0xFF) .. string.char(0xFE))
	----------------------------
	local cr = activity:getContentResolver()
	local contacts = luajava.bindClass("android.provider.ContactsContract")
	local Build = luajava.bindClass("android.os.Build")
	local D_Name = Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB and contacts.Contacts.DISPLAY_NAME_PRIMARY or contacts.Contacts.DISPLAY_NAME
	--str = luajava.bindClass("java.lang.String")

	local cur = cr:query(contacts.Contacts.CONTENT_URI)
	local count = cur and cur:getCount() or -1

	if cur and count > 0 then
		local name, id, pCur, phoneNo, phone_str, str_len, str
		while cur:moveToNext() do
			id = cur:getString(cur:getColumnIndex(contacts.Contacts._ID))
			name = cur:getString(cur:getColumnIndex(D_Name))
			phone_str = ""
			email_str = ""

			if cur:getInt(cur:getColumnIndex(contacts.Contacts.HAS_PHONE_NUMBER)) > 0 then
				pCur = cr:query(contacts.CommonDataKinds.Phone.CONTENT_URI, nil, contacts.CommonDataKinds.Phone.CONTACT_ID .. " = ?", ({id}), nil)
				while pCur:moveToNext() do
					phoneNoOrig = pCur:getString(pCur:getColumnIndex(contacts.CommonDataKinds.Phone.NUMBER))
					phoneNo = string.gsub(phoneNoOrig, "%D", "")
					if string.sub(phoneNoOrig, 1, 1) == "+" then
						phoneNo = "+" .. phoneNo
					end
					str_len = #phone_str
					phone_str = phone_str .. (string.match(phone_str, phoneNo) and "" or ( (str_len == 0 and "" or ", ") .. phoneNo ) )
				end
				pCur:close()
			end

			pCur = cr:query(contacts.CommonDataKinds.Email.CONTENT_URI, nil, contacts.CommonDataKinds.Email.CONTACT_ID .. " = ?", ({id}), nil)
			if pCur then
				while pCur:moveToNext() do
					email = pCur:getString(pCur:getColumnIndex(contacts.CommonDataKinds.Email.DATA))
					str_len = #email_str
					email_str = email_str .. (string.match(email_str, email) and "" or ( (str_len == 0 and "" or ", ") .. email ) )
				end
			end
			pCur:close()

			if #phone_str > 0 or #email_str > 0 then
				str = ";1;1"
				str = string.gsub(str, ".", function(s) return s .. string.char(0x00) end) --utf16
				str = str .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00)
				str = utf8_to_unicodeResult(name) .. ";" .. string.char(0x00) .. utf8_to_unicodeResult(phone_str) .. ";" .. string.char(0x00) .. utf8_to_unicodeResult(email_str) .. str --utf16
				file_contacts:write(str)
			end
		end
	end
	if cur then
		cur:close()
	end
	----------------------------

	file_contacts:close()
	os.exit()
	    VW_runLuaJava        p   r   r   r   s         chunk               x   ~        E   F@À   Å   ÆÀÀ   Ü    Å    Á@E FAÁFÁ Ü   \  Z    B  ^  @ B   ^          wstring    find    sc_wstring_lower    lower    ui 
   inp_Input    value        y   y   y   y   y   y   y   y   y   y   y   y   y   y   y   y   y   y   y   z   z   z   |   |   ~         name                         H      @@ E  À  U   @AAÀA   Á@  @    Å  Æ@ÁÆÁÀ 	    @@ E  À U    @@ C @C   @AA@     @@Å  Á Õ À  	    @@ E   U    @@ C ÀC   @AA@     @@Å   Õ À  	   @         MODEL    lua    gContact_phrase    _Name    ui 
   inp_Input    value 	     
   translate    Off 	   #      _Phone    ContactType    Phone    _Email    Email    sc_back     H                                                                                                                                                                                                                                       ¢   ©      "      E  À  Å  Æ@ÁÆÁÜ  \  	@  ÀA  B @B @   ÀA  B B @   ÀA  B    @  ÀÀ ÀB  C     @ @ @         SELF 
   emptytext    translated_format ,   Enter contact name or %s an press 'keydone'    MODEL    lua    ContactType    ui    lm_contacts    clear    load    LuaJava    LuaJavaActive    sc_ReloadContactsList     "   £   £   £   £   £   £   £   £   £   ¤   ¤   ¤   ¤   ¤   ¥   ¥   ¥   ¥   ¥   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   ¦   §   §   ©               ª   ¬            @         FORCE_RENDER_SCREEN        «   «   ¬               ­   ±            @@ @ À@ @    @@ @  A @         MODEL    ui    lm_contacts    clear    load        ¯   ¯   ¯   ¯   ¯   °   °   °   °   °   ±               ´   Å     	K   E   F@À FÀ À  Á  À F \ Z   @E   FÀ À  Á  À F \   ÀE@    Á \À Ô  Á    ÁA B I@þ À  Á     E  F@Ã  À    Å   @EÁ   UA Ü   \  Z   @EÀ F Ä    Å   ÆÀÁ  A AÆ Ü $  \ ^  À   @ A@ ^          MODEL    EXISTS    lua    gContact_phrase    _Phone    wsplit 	   , % s ?         VW_InsertShield    yellow    wjoin 	   ,        string    match 	   tostring    wstring    gsub 	            ½   ½        E   @  À   ] ^           VW_InsertShield    yellow        ½   ½   ½   ½   ½   ½         p            K   µ   µ   µ   µ   µ   µ   µ   µ   µ   µ   ¶   ¶   ¶   ¶   ¶   ¶   ¶   ¶   ¶   ·   ·   ·   ·   ¸   ¸   ¸   ¸   ¹   ¹   ¹   ¹   ¹   ¸   »   »   »   »   »   »   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ½   ¾   ¾   À   Á   Ã   Ã   Å         phone     J      t    &      (for index)    !      (for limit)    !      (for step)    !      i           p_s D   E           Ç   Ø     	K   E   F@À FÀ À  Á  À F \ Z   @E   FÀ À  Á  À F \   ÀE@    Á \À Ô  Á    ÁA B I@þ À  Á     E  F@Ã  À    Å   @EÁ   UA Ü   \  Z   @EÀ F Ä    Å   ÆÀÁ  A AÆ Ü $  \ ^  À   @ A@ ^          MODEL    EXISTS    lua    gContact_phrase    _Email    wsplit 	   , % s ?         VW_InsertShield    yellow    wjoin 	   ,        string    match 	   tostring    wstring    gsub 	            Ð   Ð        E   @  À   ] ^           VW_InsertShield    yellow        Ð   Ð   Ð   Ð   Ð   Ð         p            K   È   È   È   È   È   È   È   È   È   È   É   É   É   É   É   É   É   É   É   Ê   Ê   Ê   Ê   Ë   Ë   Ë   Ë   Ì   Ì   Ì   Ì   Ì   Ë   Î   Î   Î   Î   Î   Î   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ï   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ð   Ñ   Ñ   Ó   Ô   Ö   Ö   Ø         email     J      t    &      (for index)    !      (for limit)    !      (for step)    !      i           p_s D   E           Ú   á            @@ @ À@ @   @ @ A ¤   @        MODEL    ui    lm_contacts    clear    VW_LoadContactsList 
   doDelayed          Þ   à            @@ @ À@ @         MODEL    ui    lm_contacts    load        ß   ß   ß   ß   ß   à              Û   Û   Û   Û   Û   Ý   Ý   Þ   Þ   à   Þ   á           2   s      v   v   v   v   v   v   v   ~   x                                                                              ©   ©   ¬   ¬   ±   ±      Å   ´   Ø   Ç   á   Ú   á           