LuaQ    ipxvyuo/google_preview.lua           E      @@ @ E     \ 	@   @@ @ E     \ 	@   @@ @ EÀ   \ 	@    @@ @ E À \ 	@   @@ @ EÀ @ \ 	@    @@ @ E À \ 	@    @@ @ EÀ   \ 	@   @@ @ E À \ 	@$    $@  À À   $  @ $À   $  À         MODEL    SETPERSISTENT    lua    google_maps_button_cockpit    BOOL_MODEL    google_maps_button_quick    QMapsObjects    CSTRING_MODEL    Current point    QMapsObjectsIndex 
   INT_MODEL        QMapsTypes    geo    QMapsTypesIndex 	   QBaseMap    roadmap    QBaseMapIndex    VW_ShowGoogleMapsObject    VW_DefaultWebBrowser    VW_GoogleMaps 
   VW_Chrome    VW_GoToGCOORGoogle    VW_WiKi_TTS           )     È   @     A@@   Z@     A@Á@ @  @     A@A    Ú@  @  AAAÁA À  
  	ABE  FAÀFÀ\ ÀÂ A ZA  À AA  Á UÁ	AJA   AAAÁAD   ÀA ÅA ÆÄÂ E  FBÁFÁFÂÁ\   A B Ü ÁA     IÚ   ÀA ÅA ÆÄÂ @ A B Ü ÁA     I  FAFFÁFAFG ÀA ÅA ÆÄÂ E  FÆFBÆFÆFÂÆFBÆFÇFÂÇ\   A B Ü ÁA     I  AAAH   ÀA ÅA ÆÄÂ E  FÆFBÆFÆFÂÆFBÆ  FBFFÂFBFH FFÂÇ\   A B Ü ÁA     I	  W@IÀA ÅA ÆÄÂ E  FÉFÂÉFÊ	  FFÂÁ\   A B Ü ÁA     I  À A
 ÆA @
 ÅÁ
    Ü  EÂ
 B \ ÕAA   .      MODEL    lua 	   QBaseMap    QMapsTypes    QMapsObjects    navigation    car 	   position    streetview ?   https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=    geo    roadmap @   https://www.google.com/maps/search/?api=1&map_action=map&query= D   https://www.google.com/maps/@?api=1&map_action=map&zoom=16&basemap= 	   &center=    Current point    valid    string    gsub 	   tostring 0   longitude = (-?%d+.%d+), latitude = (-?%d+.%d+)    %2,%1    Selected point 
   VIA point    route    list 
   navigated 
   waypoints    size          strapped_position    Destination point 
   has_route 
   lastindex 
   TMC point    sc_GetClosestEventData ÿÿÿÿ   traffic    events    significant_events    VW_GoogleMaps    VW_LongTextToSay 
   translate 	       
   not exist     È                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               $   $   $   %   %   %   %   '   '   '   '   '   '   '   '   '   '   )         MapsObjects     Ç   
   MapsTypes     Ç      BaseMap     Ç      p_gcoor     Ç      QMapsTypes -   Ç      geo ¶   Ç           +   ?     %   E      \ @À  E     \ Z@    @   À   A@A    À ÁÀ  À   A   Å@   Ü@  ÀB @ @ @ @         type    string 	   ansi_u16    ui    LuaJava    LuaJavaActive 
   towstring ·   		local Intent = luajava.newInstance("android.content.Intent")
		local Uri = luajava.bindClass("android.net.Uri")

		Intent:setAction(Intent.ACTION_VIEW)
		Intent:setData(Uri:parse(" 5   "))
		activity:startActivity(Intent)

		os.exit()
		    VW_runLuaJava    java    call    android.open_webpage    sc_back_to_cockpit     %   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   -   -   /   4   4   4   4   8   8   8   :   :   :   :   <   <   <   <   <   =   =   ?         uri     $      uri_string    $      chunk               C   ]     %   E      \ @À  E     \ Z@    @   À   A@A    À ÁÀ  À   A   Å@   Ü@  ÀB @ @ @ @         type    string 	   ansi_u16    ui    LuaJava    LuaJavaActive 
   towstring ì   		pm = activity:getPackageManager()

		browserIntent = luajava.newInstance("android.content.Intent")
		Uri = luajava.bindClass("android.net.Uri")

		browserIntent:setAction(browserIntent.ACTION_VIEW)
		browserIntent:setData(Uri:parse(" U  "))

		browserIntent:addFlags(browserIntent.FLAG_ACTIVITY_NEW_TASK)

		browserIntent:setClassName("com.android.chrome", "com.google.android.apps.chrome.Main") -- was added for "content://com.estrongs.files/storage/0000-0000/Help.html"
		browserIntent:setPackage("com.android.chrome")

		activity:startActivity(browserIntent)

		os.exit()
		    VW_runLuaJava    java    call    android.open_webpage    sc_back_to_cockpit     %   D   D   D   D   D   D   D   D   D   D   D   E   E   E   E   E   E   F   M   M   M   M   W   W   W   X   X   X   X   Z   Z   Z   Z   Z   [   [   ]         uri     $      uri_string    $      chunk               _   q     :    @@@@@À@@@ÀÀA@B@@@À@BÅ@ ÆÃÆÀÃÆ ÄA CÁCAD Æ ÆÄÜ Á [A   FÁ A@  ÅA ÆÅÂ EB FÆFBÆFÆ\   AÂ  Ü Á@ A ÅA ÆÅÂ @   AÂ  Ü ÁE  \A             driving                   walking    
   bicycling       	      MODEL    mydata    vehicle_profile    list    selected_profile    vehicle_type 3   https://www.google.com/maps/dir/?api=1&travelmode= 	   &origin=    string    gsub 	   tostring    navigation    car 	   position 0   longitude = (-?%d+.%d+), latitude = (-?%d+.%d+)    %2,%1    &destination=    VW_GoogleMaps     :   `   a   b   c   d   e   f   g   h   i   j   l   l   l   l   l   l   l   l   l   l   l   l   m   m   m   m   m   n   n   n   n   n   n   n   n   n   n   n   n   n   n   n   o   o   o   o   o   o   o   o   o   o   o   p   p   p   q         point     9      d_mode     9      mode    9      vehicleType    9      uri    9           t   Ï     5   A   @  Å  ÆÀÀ AAAÁA A A Ü    ä    E Á \   Å  Ü UÁ EA  A \   ÅA   Ü   EB  Â \  ÅB   Ü   EC  C \ UA ÀA Á Á $B     A     	   / s a v e / w i k i _ d a t a . l u a   
   towstring    string    sub    MODEL    navigation    car    current_country       	   ansi_u16 ,   Âè íå çàáåçïå÷èëè âèêîíàííÿ êîìàíäè. Çàïèò      íåâäàëèé. @  		local function utf8ToUrlCode(input)
			local output = ""
			for i = 1, #input do
				local char = input:sub(i, i)
				local byte = char:byte()
				output = output .. string.format("%%%02X", byte)
			end
			return output
		end

		path = storage .. appname .. "/save/wiki_data.data"

		local web_query = utf8ToUrlCode(" H   ") --have been converted to utf8 by iGO.lua
		local command = "https://   .wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro&explaintext&titles=" .. web_query

		--adb shell su 0 '[your command goes here]'

		local f_query = io.popen('curl -s "' .. command .. '"', "r") --!!!!!!!!!!!!!!!!!!!!

		local url_str = "   "

		if f_query then
			local url_data = f_query:read("*a")
			f_query:close()
			_, _, url_str = string.find((url_data or 'extract":"' .. url_str .. '"}'), 'extract":"(.+)"}')
		end

		url_str = "wiki_data = \[\[" .. url_str .. "\]\]"

		path = storage .. appname .. " n   "
		file_info = io.open(path, "w")
		file_info:write(Utf8ToAnsi(url_str))
		file_info:close()

		os.exit()
		    VW_runLuaJava 
   doDelayed È                     A   @  Ô   A      Á@À   @ Å  ÆÁ  Ü   E  FBÁ À\U@@û^       	           wstring    sub    byte    format 	   \ u % 0 4 X                                                                                           input           output          (for index)          (for limit)          (for step)          i          char          byte               ¾   Í            A@     U @   À@ À  @ @ A  EÀ    Â   \@   @ B EÀ   \   ä    E@    \@         dofile 	   % a p p %   
   wiki_data     sc_longBack 
   translate O   LuaJava is not configured properly or Build.VERSION is greater than Android 11    sc_InfoMessageBox :     wstring    gsub 
   towstring 	   [ \ ] ? u % w % w % w % w      VW_LongTextToSay        Ç   Ê        E   @  Å  ÆÀÀ @   AA  Ü À \ \ À  BÀ         	      loadstring    return     string    gsub 	   tostring    [\]?u    0x    wstring    char        È   È   È   È   È   È   È   È   È   È   È   È   È   É   É   É   É   É   Ê         s           byte               ¿   ¿   ¿   ¿   ¿   À   À   À   Á   Á   Â   Â   Â   Ä   Ä   Ä   Ä   Ä   Å   Å   Ç   Ç   Ç   Ç   Ç   Ç   Ê   Ç   Ë   Ë   Ë   Í         msg          wiki          
   Dest_file 5   v                                                                           £   £   £   £   ¤   ¤   ¤   ¤   ª   ª   ª   ª   ´   ´   ´   ´   º   º   º   ¼   ¼   ¼   ¾   ¾   Í   Í   ¾   Ï         query     4   
   Dest_file    4      country    4      utf8ToJSON    4      empty_query    4      chunk ,   4       E                                                                                                                                 	   	   	   	   	   	   	   
   
   
   
   
   
   
   )      ?   +   A   A   ]   C   q   _   Ï   t   Ï           