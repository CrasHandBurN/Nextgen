LuaQ    ipxvyuo/UpdateSysTXT.lua              $   d@      G    �       VW_UpdateSysTXT                   �   �    � � ��� �@  ƀ�  E�  �� \� � ܀ � � A� ��  �@  � ��@   � ��   �    
   translate    wstring    gsub 
   towstring 	     	     ;                                                                                        p1           p2           tr                  \    �   @    �   A@   @ @�A�  ��  �  A �A�AB� ���AB܁� W��	��� � E� �BB�� \�  � �  C FCB\� ܂  � E� ��C�� \�  �� � �� �� DD� ܃  � A� � D  �� ��C�� \�  �� � �� U���AB܁� � ����� � F�C\� �  E� � \� �� �BD�� ��  �� � ܂   A� ��C�� �  E� � \� U@��@  @�� � � AA � U �� � � A� � U ���A� �  �@ ƀ����� �� @������ W@@@��� �� B ܁ � FB�\� �  E� �� \� �� ����� ��  �� � ܂ � FC�\� �  E� �� \� U@�@  ��� � �  U� � � �� A ܀ U� �� ��  �  �@  �@ ŀ �@ �� �@ � ��@�܀� $    � �@� � &      new 	     	
   s y s   =   [ [ 
          ModelList_iter    MODEL    ui    lm_SysParameters    list    section 	   
 [   
   towstring 	   ]     	   section~ 	   
      item    ="    value    "     item~    
    
]]
 k  			local File = luajava.bindClass("java.io.File")
			local function file(s)
				return luajava.new(File,s)
			end
			if not file(storage .. appname .. "/sysOriginal.txt"):exists() then
				os.rename(storage .. appname .. "/sys.txt", storage .. appname .. "/sysOriginal.txt")
			end

			local path = storage .. appname .. "/sys.txt"
			file_sys = io.open(path, "w")
			file_sys:write(sys)
			file_sys:close()
			------------------------------
			local ntime = os.time() + 3
			repeat until os.time() > ntime

			act = pm:getLaunchIntentForPackage(packageName)
			application:startActivity(act)
			----

			os.exit()
			 	   t _ u p d a t e   =   { 
      value_orig    {"    ", "    "},
 	   } 
     			local path = storage .. appname .. "/sys.txt"
			file_sys = io.open(path, "r")
			local sys = file_sys:read("*a")
			file_sys:close()
			local line1, line2, patrn
			for i, line in ipairs(t_update) do
				line1 = string.gsub(line[1], "[%(%)%.%%%+%-%*%?%[%^%$]", "%%%1")
				line2 = string.gsub(line[2], "[%(%)%.%%%+%-%*%?%[%^%$]", "%%%1")
				patrn = "(%[" .. line1 .. "%].-" .. string.char(0x0A) .. line2 .. "=)(.-);?" .. string.char(0x0A)
				sys = string.gsub(sys, patrn, function(s, s2) local str = s .. '"' .. line[3] .. '"' .. string.char(0x0A) return str end)
			end

			file_sys = io.open(path, "w")
			file_sys:write(sys)
			file_sys:close()

			----------------------------------
			local ntime = os.time() + 3
			repeat until os.time() > ntime

			--am = activity:getSystemService(activity.ACTIVITY_SERVICE)
			--am:killBackgroundProcesses(packageName)
			--am:restartPackage(packageName) --no more

			act = pm:getLaunchIntentForPackage(packageName)
			application:startActivity(act)
			----

			os.exit()
			    sc_Voice_TTS    sc_translate_VoiceOrLang    RESTARTING, PLEASE WAIT... 
   NEXTSTATE    st_RestartState 
   doDelayed    lua    RunLuaJavaDelay        [   [           D   �@  ŀ  @  �       VW_runLuaJava        EXIT        [   [   [   [   [   [             chunk �            	   
   
                                                                                                                                                                                                                                                                     -      -   -   /   0   0   0   0   0   0   0   1   1   1   1   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   2   0   3   5   5   5   7   7   U   7   U   X   X   X   X   X   Y   Y   Y   [   [   [   [   [   [   [   [   \      	   sys_type     �      chunk    �      section    _      (for generator)    U      (for state)    U      (for control)    U      item    S      (for generator) g   �      (for state) g   �      (for control) g   �      item h   �         VW_PrepareComment       \   \      \         VW_PrepareComment           