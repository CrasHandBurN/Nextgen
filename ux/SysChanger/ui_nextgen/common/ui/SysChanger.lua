LuaQ    ipxvyuo/SysChanger.lua           	�   $      @  A�  �@        � ��  �@  �     �  ��  �@ �      ǀ �� � ��@�� B� � � ��� � ��@�� A� � � ���� � ��@�� AA � � ��� � ��@�� A � � ��� � ��@�� AA  � � ���� � ��@�� AA  � � ��� � ��@�� AA  � � ���� � ��@�� A�  � � ��� � ��@�� A�  � � ��ŀ ���� �AA �A �@ ŀ ���d� �@��  A J� � �� 	 �A I���� ��	 �A� I���Iʓ��
 ��
 �� I���IAK�I�K��@���    �  �  A J �� �� �A� I���� �� �A� I���IA��� I����@��@ �  � �@ �� � ��@�� A� � � ��   J �� �	 �A� I����
 �A �� I����� �� �A� I�����
 �� �� I���IAO�IAK�I�K��� I��IП� I����A I����� I���@��  � J� �� �� �A� I��� � B �A I�����
 �� �� I����� I���� I����A I���@�� �� �� �  �  A J� � Ł � �A I����
 � �� I���I�Ӧ��  �T���Ԩ�թI���� I����A I����@�� ǀ �� �� �  ���d �@� � Y      VW_Field_View            VW_View_Section    VW_View_Item    VW_LoadSysParameters    VW_ChangeSysParameters    MODEL    SETPERSISTENT    lua    label_in_cockpit    BOOL_MODEL    SET    ApplicationLabel    CSTRING_MODEL    WAIT 	   iGO_Path    /storage/emulated/0/iGo_Pal    SDK_INT 
   INT_MODEL        VERSION_RELEASE    packageName    data_folder_name    heightPixels    widthPixels    ui    screen    add_event_listener    orientation_change_ended    hook_StartInit 	   register    createState    st_SysParametersSection    extends 
   st_Common 	   st_Input 
   useLayers    ui_SysParametersSection    title    Sections list 
   emptytext    m_i18n    Enter a section or item name 
   validator    none    keyboardName 	   Q W E R T Y      VW_SysParametersItem    st_SysParametersItem    ui_SysParametersItem    enter    VW_SysParametersReady    VW_ItemEdit    SystemValueIndex ����   st_SysItemCharsValue    Edit value    ui_CharsValue    Enter a char value 
   maxlength d      keydone    doneKeyButton    init    done    st_SysItemDigitsValue    ui_DigitsValue    ui_InputDigisValue    Edit Value    sc_ItemDigitsValue_UpdateKeys    sc_Item_SetValue    st_SysDataSettingsList    st_List    st_Popover    Sys Data Settings 	   listname    ui.lm_SysDataSettingsList 
   separator    Attention!!!       Route Events as Maneuver       Miscellaneous    exit    VW_getDataIndex    VW_putBinaryValueToSys    hook_DebugSnapshot                   �   �@@� � �  A�  �� �  �@�A @  �� U��� A� �� � �� U���  ܀ �   �       string    gsub    [%(%)%.%%%+%-%*%?%[%^%$]    %%%1    wstring 
   translate 	   ^   
   towstring                   E   �@  �   ] �^    �       VW_InsertShield    blue                                s                                                                                       prefix           text           ptrn          str                  "    s   D   @   �E   F@� F�� � � F�� �   �@@��@� � �� ��@��� �    A@�@EA A�A�� � I���B   ^  @�E@  F�� F � Z   ��E@ F�� �@ ��B�   �� �@ ��� EA  F��F� �   \�  Z@  ��E@ F�� �@ ��B�   �@�ƀ�A � ����� � ��  �@ ��� EA  F��F� �   \�  Z   ��   E@ H � E   F@� F�� � � F�� �   �@@��@�@ �� ��A��� I���B � ^  @�   B   ^  @�   E@ H � E   F@� F�� � � F�� �   �@@��@�@ �� ��A��� I���B � ^   �       MODEL    ui    lm_SysParameters    details     |     index    item 
   inp_Input    value    string    find    lower 	   tostring     s                                                                                                                                                                                                                                                                                                                                                         "         s     r         section    indx     %   +    	   D   @  � �B � ^  @ �B   ^   �         	   &   &   &   '   '   '   )   )   +         s              item     :   �            E@  �   \@  �      	local function parse_ini(filepath)
		local t = {}
		local str, str2, section, ptrn
		for line in io.lines(filepath) do
			str = string.gsub(line, "^%s+", "")
			str = string.gsub(str, ";.-$", "")
			if str ~= "" then
				str2 = string.gsub(str, "^%b[]", function(s)
						s = string.gsub(s, "[%]%[]", "")
						--print(s)
						t[s] = t[s] or {}
						section = s
						return s
					end)
				if str == str2 then
					ptrn = string.find(str, '"') and '(.+)%s-=%s-(%b"")' or '(.+)%s-=%s-(.+)'
					_ = string.gsub(str, ptrn, function(s1, s2)
							s2 = string.gsub(s2, '^"', "")
							s2 = string.gsub(s2, '"$', "")
							--print(s1, s2)
							t[section][s1] = tonumber(s2) or s2
						end)
				end
			end
		end
		return t
	end

	local function serialize(o)
		str_serialize = str_serialize or "" --need to just it is
		if o == nil then
			str_serialize = str_serialize.."nil"
			return
		end
		if type(o) == "number" then
			str_serialize = str_serialize .. o
		elseif type(o) == "string" then
			str_serialize = str_serialize .. string.format("%q", o)
		elseif type(o) == "table" then
			str_serialize = str_serialize .. " {"
			for k,v in pairs(o) do
				str_serialize = str_serialize .. " ["
				serialize(k)
				str_serialize = str_serialize .. "] = "
				serialize(v)
				str_serialize = str_serialize..","
			end
			str_serialize = str_serialize .. "}"
		elseif type(o) == "boolean" then
			str_serialize = str_serialize .. (o and "true" or "false")
		elseif type(o) == "function" then
			str_serialize = str_serialize .. "function"
		else
			error("cannot serialize a " .. type(o))
		end
		return str_serialize
	end

	local path = storage .. appname --!!!!!!!!!!!!!!!!!!!storage .. appname!!!!!!!!!!!!!!!!!!!!!!

	local t = parse_ini(path .. "/sys.txt")

	file_sys = io.open(userlists_path .. "/SysParameters.txt", "w") --!!!!!!!!!!!!!userlists_path!!!!!!!!!!!!!!!!!!!!!

	file_sys:write(string.char(0xFF) .. string.char(0xFE))
	local str
	for s, p in pairs(t) do
		for k, v in pairs(p) do
			str = s .. ";" .. k .. ";" .. v .. ";;1;1;"
			str = string.gsub(str, ".", function(s) return s .. string.char(0x00) end) --utf16
			str = str .. string.char(0x0D) .. string.char(0x00) .. string.char(0x0A) .. string.char(0x00)
			file_sys:write(str)
		end
	end

	file_sys:close()
	--------packageinfo--------
	ai = pm:getApplicationInfo(packageName)

	ApplicationLabel = pm:getApplicationLabel(ai)

	--ApplicationBanner = pm:getApplicationBanner(ai)
	--ApplicationLogo = pm:getApplicationLogo(ai)
	ApplicationIcon = pm:getApplicationIcon(ai)

	build = luajava.bindClass("android.os.Build")

	data = \[\[
		MODEL.lua.packageName ="\]\] .. packageName .. \[\["

		MODEL.lua.ApplicationLabel = "\]\] .. ApplicationLabel .. \[\["

		MODEL.lua.iGO_Path = "\]\] .. path .. \[\["

		MODEL.lua.SDK_INT = \]\] .. build.VERSION.SDK_INT .. \[\[

		MODEL.lua.VERSION_RELEASE = "\]\] .. build.VERSION.RELEASE .. \[\["

		MODEL.lua.heightPixels = \]\] .. tostring(activity:getResources():getDisplayMetrics().heightPixels) .. \[\[

		MODEL.lua.widthPixels = \]\] .. tostring(activity:getResources():getDisplayMetrics().widthPixels) .. \[\[

		MODEL.lua.data_folder_name = "\]\] .. appname .. \[\["
		\]\]

	file_info = io.open(storage .. appname .. "/save/packageinfo.lua", "w")
	file_info:write(Utf8ToAnsi(data))
	file_info:close()

	os.exit()
	    VW_runLuaJava        �   �   �   �   �         chunk               �   �              @  �@ �@  A @ @ E� �� �    @� � 	          ui    lm_SysParametersFiltered    section    refresh    sc_NextStateAnim    st_SysParametersSection    fade           �   �   �   �   �   �   �   �   �   �   �   �   �   �             section     �   �            @@ �@ �� E   F@� F�� \��  � @�   @@ E   F@� �   �@@��@��� �   �@����܀� I� �	��� �       MODEL    lua    widthPixels    heightPixels        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ @�    @@ �@  A @� @ A� �   @� �       MODEL    ui    lm_SysParameters    clear    save 
   doDelayed 2          �   �      
      @� @  E�  F�� F � \�� �   @� �       VW_LoadSysParameters 
   doDelayed    MODEL    lua    RunLuaJavaDelay        �   �            A@  @ �  �@  A �� @A ���  �@ 	�A�� A  � E@ �� �       \@�#    �       dofile 	   % a p p % / s a v e / p a c k a g e i n f o . l u a      MODEL    lua    ApplicationLabel    WAIT     
   translate O   LuaJava is not configured properly or Build.VERSION is greater than Android 11 
   doDelayed �          �   �           D   � � �@  @  �       sc_InfoMessageBox �:         �   �   �   �   �   �             msg    �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         msg           
   �   �   �   �   �   �   �   �   �   �              �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                            @@ �@ ��    �   A @A �A @ � E  �@ �� � @� �       MODEL    *    section    ui    lm_SysParametersFiltered    item    refresh    sc_NextStateAnim    st_SysParametersItem    fade                                                           item                  E�  F�� F � \�� 	@�� �       SELF    title    MODEL    *    section                                    6     
?      @@ �@       ���   @  A @A @� �  �A �A  B J�  � � ŀ � ܀  E� �A \� �@�� A� �  �A@��@� ��@  I���� ��  $  EA �� \� �� � �@ 
 dA  �A �A �� �� � "A J ��  �A � ܁ � A bA �@�I� �@  �       ui    lm_SysParametersFiltered    edited    MODEL    lm_SysParameters    save    screen    msgbox    create_from    line 
   translate 6   The SYS.TXT will be updated. Do you want to continue? 	   
   =   In case of "Organize" sys.txt will be updated and reordered!    sc_translate_VoiceOrLang    Items were changed: %s    button    m_i18n    Ok        ico_syschange.svg 	   Organize    ico_new.svg    Cancel    ico_cancel.svg                     A@  @  �       VW_UpdateSysTXT    as is                            $  $           A@  @  �       VW_UpdateSysTXT    new        $  $  $  $              *  .           @@ �@ �@ @�    @@ �@  A @� @ @�  �       MODEL    ui    lm_SysParameters    clear    save    VW_LoadSysParameters        +  +  +  +  +  ,  ,  ,  ,  ,  -  -  .          ?                                                                                      "  "  "  $  %  %  %  &  (  (  (  .  /  /  /  0  2  2  3  3    6              8  B     &      @@ �@ �� �@ ��   @@ E   F@� F � \�� 	@ �@ �A E   F@� F � \ � �  @  @ ��A ��E  �@ �� � A \@�@�E  �@ �� � A \@� �       MODEL    *    value_orig 	        value    DOUBLE    new        sc_NextStateAnim    st_SysItemDigitsValue    fade           st_SysItemCharsValue     &   9  9  9  9  9  9  :  :  :  :  :  :  :  <  <  <  <  <  <  <  =  =  =  =  >  >  >  >  >  >  >  @  @  @  @  @  @  B        value_type    %           N  Q           @@ �@ �@ E  @  E@  F�� F@� 	@��� @�  �       MODEL    ui    lm_SysParameters    list    current    value 
   inp_Input    sc_back        O  O  O  O  O  O  O  O  O  O  P  P  Q              S  V           E�  ��  �  �@�ƀ�� � \�  	@��  �A  B @B E� F�� F�� K � �� ���ƀ� AC�C�� � �\��	@ � �       SELF    title    VW_Field_View    item~    MODEL    *    item    ui    lm_SysParameters    list    index    lm_SysParametersFiltered 
   get_index    lua    SystemValueIndex        T  T  T  T  T  T  T  T  T  U  U  U  U  U  U  U  U  U  U  U  U  U  U  U  U  U  U  V              W  Y           E�  F�� F@� \�� 	@�� �    
   inp_Input    value    MODEL    *        X  X  X  X  X  X  Y              Z  ^           @@ �@ �@ E  @  @A �� E   F@� F�� F�� �  F�� F�� \�� @  ��   @@ �@ �@ E  @  	�A� �       MODEL    ui    lm_SysParameters    list    current    value    value_orig 	            [  [  [  [  [  [  [  [  [  [  [  [  [  [  [  [  [  [  \  \  \  \  \  \  \  ^              i  l           E�  ��  �  �@�ƀ�� � \�  	@��  �A  B @B E� F�� F�� K � �� ���ƀ� AC�C�� � �\��	@ � �       SELF    title    VW_Field_View    item~    MODEL    *    item    ui    lm_SysParameters    list    index    lm_SysParametersFiltered 
   get_index    lua    SystemValueIndex        j  j  j  j  j  j  j  j  j  k  k  k  k  k  k  k  k  k  k  k  k  k  k  k  k  k  k  l              m  r           @@ �@ �@ E  F@� @ � �A �  @�� E   F�� F@� \�� 	@��� @�  �       MODEL 	   regional 	   keyboard    load_panel_by_type    EInputPanelType    Ext_Numeric    inp_SysItemValue    VALUE_NO_ONCHANGE 	        value    *    sc_ItemDigitsValue_UpdateKeys        n  n  n  n  n  n  n  o  o  o  o  p  p  p  p  p  p  q  q  r              s  y     %      @@ �@ �@ A  @    @@ �@ @A @�    �A �A  B E@ @  �B �� E   F�� F�� F � �@ F�� F�� \�� @  ��   �A �A  B E@ @  	 Å �       MODEL 	   regional 	   keyboard    smartkey_model        on_close_panel    ui    lm_SysParameters    list    current    value    value_orig 	         %   t  t  t  t  t  t  u  u  u  u  u  v  v  v  v  v  v  v  v  v  v  v  v  v  v  v  v  v  v  w  w  w  w  w  w  w  y              |  ~           @@ 	�@� �       MODEL    lua 
   keyb_done        }  }  }  ~              �  �           @� @  �@ �@  A E@ @  E�  F�� F�� 	@ � �       sc_ItemDigitsValue_UpdateKeys    MODEL    ui    lm_SysParameters    list    current    value    inp_SysItemValue        �  �  �  �  �  �  �  �  �  �  �  �  �              �  �           @@ �@    �@  �   @@ �@  A @�  �       MODEL    ui    lm_SysParameters        load        �  �  �  �  �  �  �  �  �  �  �  �              �  �           @�  �       VW_SysParametersReady        �  �  �              �  �    
   �   �@  ƀ�����  �� �A����� A� ܁� � �� �A���� A� ܁�@�  �� ��   ��@ �   � 
      ModelList_iter    MODEL    ui    lm_SysParameters    string    match    section    ([%w%-_]+)    item ����       �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �        section           field           (for generator)          (for state)          (for control)          item          index               �  �    !   E   F@� F�� F�� F � �   �@@��@��@�  �@A��� I� �E   F@� F�� F�� F � ��  ��A��@B�ŀ   A@�@�@ AA� ܀  �� I��� �       MODEL    ui    lm_SysParameters    list    value_orig    value    0 	   1      1 	   0   	   tostring     !   �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �     
   Data_indx                 �  �        @     �  A  �@ ��A�� �� �  U�� 	@���  E� F�� F@� \�� 	@���  	@C� �       UX_Name    plugin~SysChanger    VW_Debugger_Table    start 	   * * * * * * * * * * * * * * * * * * * * W A N D E L      wstring    char "!  	   * * * * * * * * * * * * * * * * * * * *   	   iGO_Path    MODEL    lua    end_ >   ****************************end******************************        �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �          �         
      "   "   "      $   +   +   %   �   :   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                  	  	  	  
                6    B  8  C  C  C  C  C  C  C  D  D  D  E  E  E  E  F  F  F  F  G  I  I  I  J  J  J  J  K  L  M  Q  Q  R  V  V  Y  Y  ^  ^  D  b  b  b  c  c  c  c  d  e  g  g  g  h  h  h  h  l  l  r  r  y  y  b  ~  |  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �        section    �      indx    �      item 	   �       