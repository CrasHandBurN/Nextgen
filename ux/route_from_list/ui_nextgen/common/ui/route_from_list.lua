LuaQ    ipxvyuo/route_from_list.lua           ,      @@ �@ E  �   \� 	@��   @@ �@ E  �   \� 	@��   �A �A d   G  d@        � ��         �@ � A� � �A � A� �@�$�        �  �    �  AD� A� �       MODEL    SETPERSISTENT    lua    RouteFromListCockpit    BOOL_MODEL    RouteFromListQuick    ui    lm_clipboard    VW_GCOOR_to_gcoor �  		-- experimental support for LuaJava
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
		local p = storage .. appname .. "/    sc_GetSysEntry    route    route_file_name 
   route.txt �  "
		local route = ""
		if path.exists(p) then
			file_route = io.open(p, "r")
			route = file_route:read("*a")
			file_route:close()
		end
		file_eapp = io.open(userlists_path .. "/clipboard.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!
		file_eapp:write(string.char(0xFF) .. string.char(0xFE) .. utf8_to_unicodeResult(route) .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00))
		file_eapp:close()

		os.exit()
		    VW_Check_Clipboard_for_list    hook_DebugSnapshot 	   register                	R   E   F@� ��  �   �� ��  \@��@   �E  FA���  �  �� � \A�  � ��  � ��   ��  @�E  FA����� � \� � Հ�E  FA����A \��Z   �A� ��U���@���E  FA�����  \� � �E  FA�� �� � \� � ��E  FA�� �A \��Z   �AA � U��A���E  FA�� �� � \�  �@�� ^� �       string    find 	   tostring !   ([NS]%d+%.%d+),%s?([EW]%d+%.%d+) !   (-?%d+[.,]%d+),%s?(-?%d+[.,]%d+)    gsub    ,    .    �    ^%d    N    -    S    E    W     R   	   	   	   	   	   	   	   
   
                                                                                                                                                                                                                                    like_GCOOR     Q      _    Q      _    Q      lat    Q      lon    Q              #     5            ��   @@ @  �	��  D   F�� F � F@� \ � �     ��Z    ��� ��A� B�@Bŀ ���
�  EA �  \� 	A�EA �� \� 	A��  �@  �� ��C�@ ƀ��� ��� � E�@ �   �@E�  �@ � A� � � @� �       st_PointOnMap 
   isEntered    VW_GCOOR_to_gcoor    list     
   clipboard    MODEL    my    map    select_gcoor    GCOOR    new    lat    parse_gcoor    lon    lua    RoutePlanType    ERoutePlanType 	   Stopover    hook_ShowPointOnMap    trigger    remove 
   doDelayed 2       5                                                                                                                                                   !   !   !   !   #         lat    0      lon    0         lm_clipboard    VW_step_by_step     %   5     9            ��   @@ @  �
� � ��  �   � ��  �@���  �  �������A��� ��  @ �      @�Z   ���� ��A�B�ABŁ ���
�  EB �  \� 	B�EB �� \� 	B�� �A  �� �D�A � ��@ �@� � �� A� � � @� �       st_PointOnMap 
   isEntered       VW_GCOOR_to_gcoor    list 
   clipboard    MODEL    my    map    select_gcoor    GCOOR    new    lat    parse_gcoor    lon    hook_AddStopover    trigger    sc_ShowRouteOverView 
   doDelayed 2       9   &   &   &   &   '   '   '   '   (   )   )   )   )   )   *   *   *   *   *   *   *   *   *   *   +   +   +   +   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   )   0   0   0   2   2   2   2   5         lat 	   3      lon 	   3      (for index)    1      (for limit)    1      (for step)    1      i    0         lm_clipboard    VW_all_at_once     �   �     $      W@@ � �   W�@   �@   � D   F�� \@� D   F � \@� E   �� � �E@ �� \@ � �E@ � � \@ E� �  �@B��B��� �             �\@� �       index           clear    save    VW_runLuaJava    clipboard_chunk 
   doDelayed    MODEL    lua    RunLuaJavaDelay        �   �     [       @ @�          ��@  �@ �@ �� @   � � �  �   �@�   �A� ����� � ��  @ �   �   � B�   � �̀��@    ��   @�Z   �
��@  �@B�� � ��� ��@  �@C��C��C�  �@�
�  E� �  \� 	A�E� �� \� 	A��  �@  �@  �@B�  �@�
�  E� �  \� 	A�E� �� \� 	A�܀ ������ ��E�@ �  �@ $  �@� �    � �  @� @ � �@�  �       load    MODEL    navigation 
   has_route    VW_GCOOR_to_gcoor    list    
   clipboard    remove    lua    RoutePlanType    ERoutePlanType    New    my    map    select_gcoor    GCOOR    new    lat    parse_gcoor    lon    gcoor_to_find    hook_ShowPointOnMap    trigger 
   doDelayed 2          �   �            @@ @  �       ui_Send_Information    SHOW        �   �   �   �           [   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         lat    R      lon    R         lm_clipboard    s    VW_step_by_step    VW_all_at_once $   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         s    #         lm_clipboard    filecopy_chunk    VW_step_by_step    VW_all_at_once     	          @     �  A  �@ ��A�� �� �  U�� 	@���  	� �       UX_Name    plugin~route_from_list    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *      end_ >   ****************************end******************************        
  
                                  ,                                                            #   #   #   5   5   5   �   �   �   �   �   �   �   �   �   �   �   �   �   �   	  	    	          lm_clipboard    +      VW_step_by_step    +      VW_all_at_once    +      filecopy_chunk !   +       