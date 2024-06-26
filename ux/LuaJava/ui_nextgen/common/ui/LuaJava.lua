LuaQ    ipxvyuo/LuaJava.lua              $      @  @ Ŕ@ E@  ÁŔ  AA   \  	@ Ŕ  $@            VW_runLuaJava    MODEL    SET    lua    RunLuaJavaDelay 
   INT_MODEL    sc_GetSysEntry    run_java_delay    delay       clipboard_chunk 
  		------------------------------------------------------
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

		if clipboard:hasPrimaryClip() then
			local item = clipboard:getPrimaryClip():getItemAt(0)

			local text = tostring(item:coerceToText()) --:toString()
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
		 	   VW_Paste                :     @   @@   @   @ Ŕ˙Z@    AŔ  Ú   @  @ @@  @ Ű@ Ŕ˙A AÁABA  ÁAABA   AA AÁAÁBA  AC ÁÁ A Ú     @A    Ŕ A @  A        type    string 	   ansi_u16 2   
   translate    MODEL    ui    lm_RunExtra    clear    add    chunk    save    java    call    android.startExternalApp    com.caharkness.lua    sc_InfoNotification 
   doDelayed     :                                                                                                               	   	   	   	   	   
   
   
   
   
                                             chunk     9      delay     9   
   f_restart     9      msg     9           a   i            E@  @   Ŕ@  A @A @  E  FŔÁ F Â \ ¤   @  	      VW_runLuaJava    clipboard_chunk    MODEL    ui    lm_clipboard    clear 
   doDelayed    lua    RunLuaJavaDelay        d   h            @@ @ Ŕ@ @   @A A E   F@Ŕ FŔ F Â F@Â FÂ \ 	@        MODEL    ui    lm_clipboard    load    States    CurrentState    InputControl    value    list     
   clipboard        e   e   e   e   e   f   f   f   f   f   f   f   f   f   f   f   h              b   b   b   c   c   c   c   c   d   d   d   d   d   h   d   i                                                     _   _   i   a   i           