LuaQ    ipxvyuo/google_contacts.lua           7   $      @  �@ �@ E@ �� \� 	@ �$@  � @   � A� �  �  A E� �� � �@ �� �� � � �@� ����� ŉ��Ŋ� Ƌ��ƌ��ƍ�@G���F��  ������  �� ��  ����@�$@ � $� � $�  	 @	 d        � �@   � ��	  � '      VW_LoadContactsList    MODEL    SET    lua    ContactType    CSTRING_MODEL    Phone    VW_Filter_contacts    gContact_phrase    contact    createState    st_SimpleInputContact    extends 	   st_Input    st_CommonList    st_FooterMenu    st_Popover 
   useLayers    ui_ContactVisibilityList    footermenu    ui.lm_Contacts_footer 
   emptytext     
   maxlength <      smallInput    autoOpenKeyboard    contact_index        doneKeyButton    keydone    init    enter     sc_contact_Phone_email_callback    VW_PhoneMark    VW_EmailMark ����   sc_ReloadContactsList 
          �        E   �@  \� �   �   �� �   �  ܀ U�� ��  � � �@  �    
   towstring �  
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

	local function getContactNameById(contactId)
		local ContactsContract = luajava.bindClass("android.provider.ContactsContract")
		local contentResolver = activity:getContentResolver()
		local uri = ContactsContract.Contacts.CONTENT_URI
		local projection = {ContactsContract.Contacts.DISPLAY_NAME}

		local cursor = contentResolver:query(uri, projection, ContactsContract.Contacts._ID .. " = ?", {tostring(contactId)}, nil)
		if cursor and cursor:moveToFirst() then
			local name = cursor:getString(cursor:getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))
			cursor:close()
			return name
		end

		return nil
	end

	local function getContactPHONE_NUMBERById(contactId)
		local cr = activity:getContentResolver()
		local contacts = luajava.bindClass("android.provider.ContactsContract")

		local pCur = cr:query(contacts.CommonDataKinds.Phone.CONTENT_URI, nil, contacts.CommonDataKinds.Phone.CONTACT_ID .. " = ?", ({tostring(contactId)}), nil)
		local t = {
			name = getContactNameById(contactId),
			phone = {},
		}
		while pCur:moveToNext() do
			local phoneNo = pCur:getString(pCur:getColumnIndex(contacts.CommonDataKinds.Phone.NUMBER))
			--local phoneType = pCur:getInt(pCur:getColumnIndex(contacts.CommonDataKinds.Phone.TYPE))
			--local phoneLabel = pCur:getString(pCur:getColumnIndex(contacts.CommonDataKinds.Phone.LABEL))

			table.insert(t.phone, (phoneNo or nil))

			--print("Phone Number: " .. (phoneNo or "NO PHONE"))
			--print("Phone Type: " .. (phoneType or "NO TYPE"))
			--print("Phone Label: " .. (phoneLabel or "no LABEL"))
		end

		pCur:close()
		return t
	end
	local function getContactEmailById(contactId)
		local cr = activity:getContentResolver()
		local contacts = luajava.bindClass("android.provider.ContactsContract")

		local eCur = cr:query(contacts.CommonDataKinds.Email.CONTENT_URI, nil, contacts.CommonDataKinds.Email.CONTACT_ID .. " = ?", ({tostring(contactId)}), nil)
		local t = {
			name = getContactNameById(contactId),
			email = {},
		}
		while eCur:moveToNext() do
			local email = eCur:getString(eCur:getColumnIndex(contacts.CommonDataKinds.Email.DATA))
			--local emailType = eCur:getInt(eCur:getColumnIndex(contacts.CommonDataKinds.Email.TYPE))
			--local emailLabel = eCur:getString(eCur:getColumnIndex(contacts.CommonDataKinds.Email.LABEL))
			table.insert(t.email, (email or nil))
			--print("Email: " .. (email or "NO EMAIL"))
			--print("Email Type: " .. (emailType or "NO TYPE"))
			--print("Email Label: " .. (emailLabel or "NO LABEL"))
		end

		eCur:close()
		return t
	end

	local function in_set(value, tbl)
		for k, v in ipairs(tbl) do
			if v == value then
				return true
			end
		end
		return false
	end

	file_contacts = io.open(userlists_path .. "/contacts.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!
	file_contacts:write(string.char(0xFF) .. string.char(0xFE))

	local id = " }  "
	----------------------------
	local t_phone_str = getContactPHONE_NUMBERById(id)
	for i=1, #t_phone_str.phone do
		t_phone_str.phone[i] = string.gsub(t_phone_str.phone[i], "%D", function(s) return (s == "+" and s or "") end)
	end

	--double removing
	local hash = {}
	local res = {}
	for _, v in ipairs(t_phone_str.phone) do
		if (not hash[v]) then
			res[#res + 1] = v
			hash[v] = true
		end
	end
	t_phone_str.phone = res

	local phone_str = table.concat(t_phone_str.phone, ", ")

	local email_str = table.concat(getContactEmailById(id).email, ", ")
	----------------------------
	if #phone_str > 0 or #email_str > 0 then
		str = ";1;1"
		str = string.gsub(str, ".", function(s) return s .. string.char(0x00) end) .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00) --tail
		str = utf8_to_unicodeResult(t_phone_str.name) .. ";" .. string.char(0x00) ..
			utf8_to_unicodeResult(phone_str) .. ";" .. string.char(0x00) ..
			utf8_to_unicodeResult(email_str) .. ";" .. string.char(0x00) ..
			utf8_to_unicodeResult(tostring(id)) ..
			str --utf16
		file_contacts:write(str)
	end

	file_contacts:close()
	os.exit()
	    VW_runLuaJava           |   |   |   |   |   |   �   �   �   �   �   �   �         id           chunk 
              �   �        E   F@� ��  �   ���   �  ��  ŀ    �@E FA�F�� �   \�  Z   � �B � ^  @ �B   ^   �       wstring    find    sc_wstring_lower    lower    ui 
   inp_Input    value        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         name                �   �      H      @@ E�  ��  U�� �  �@A��A�A ��  �@ �� �@   ��� �  �@�ƀ��� 	��    @@ E�  �� U�� �   �@@� C��� @C ��  �@A��A�@  ���   �@@ŀ  � � ��� ��� 	��    @@ E�  �� U�� �   �@@� C��� �C ��  �@A��A�@  ���   �@@ŀ  � � ��� ��� 	��   @�  �       MODEL    lua    gContact_phrase    _Name    ui 
   inp_Input    value 	     
   translate    Off 	   #      _Phone    ContactType    Phone    _Email    Email    sc_back     H   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ @�    @@ �@  A @�  �       MODEL    ui    lm_contacts    clear    save        �   �   �   �   �   �   �   �   �   �   �               �   �            @@ ��  ��  @    @@ �  @�@ E� �  �@ ƀ����� � \�  	@ � �       java    call    android.contacts.set_callback     sc_contact_Phone_email_callback    android.contact.showAll    SELF 
   emptytext    translated_format ,   Enter contact name or %s an press 'keydone'    MODEL    lua    ContactType        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            ��   �@@��@��� �   � ���  � � �@  �       ui    LuaJava    LuaJavaActive    sc_ReloadContactsList        �   �   �   �   �   �   �   �   �   �   �   �         succ        
   contactid                �   �     	K   E   F@� F�� ��  �  �� F�� \�� Z   @�E   F�� ��  �  �� F�� \��  � ��E@ �   �� \���� � � � � �� �A B� ���I���@��� � � � � ��   ��E  F@� �� �   �� ŀ   �@E�  � U��A� �   \�  Z   @�E� F � �   �   ƀ��  A A� �܀� $  \� ^  � �  @ �A@ ^   �       MODEL    EXISTS    lua    gContact_phrase    _Phone    wsplit 	   , % s ?         VW_InsertShield    yellow    wjoin 	   ,        string    match 	   tostring    wstring    gsub 	            �   �        E   �@  �   ] �^    �       VW_InsertShield    yellow        �   �   �   �   �   �         p            K   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         phone     J      t    &      (for index)    !      (for limit)    !      (for step)    !      i           p_s D   E           �       	K   E   F@� F�� ��  �  �� F�� \�� Z   @�E   F�� ��  �  �� F�� \��  � ��E@ �   �� \���� � � � � �� �A B� ���I���@��� � � � � ��   ��E  F@� �� �   �� ŀ   �@E�  � U��A� �   \�  Z   @�E� F � �   �   ƀ��  A A� �܀� $  \� ^  � �  @ �A@ ^   �       MODEL    EXISTS    lua    gContact_phrase    _Email    wsplit 	   , % s ?         VW_InsertShield    yellow    wjoin 	   ,        string    match 	   tostring    wstring    gsub 	            �   �        E   �@  �   ] �^    �       VW_InsertShield    yellow        �   �   �   �   �   �         p            K   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �               email     J      t    &      (for index)    !      (for limit)    !      (for step)    !      i           p_s D   E                       @@ �@       �  A  �       � @� �       MODEL    ui    lm_contacts 
   doDelayed d                      @@ �@ �@ @�    @@ �@  A @�    E   F@� F�� T � W@  @ � � @�  �       MODEL    ui    lm_contacts    clear    load        	  	  	  	  	  
  
  
  
  
                                contacts_size    VW_LoadControl                                      contacts_size    VW_LoadControl             E   F@� F�� F�� \@� E  �   \@ E@ �� �      \@� �       MODEL    ui    lm_contacts    clear    VW_LoadContactsList 
   doDelayed �                      @@ �@ �@ @�    @�  �       MODEL    ui    lm_contacts    load                                  VW_LoadControl                                      id              VW_LoadControl 7   �      �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �     �                         contacts_size 0   6      VW_LoadControl 3   6       