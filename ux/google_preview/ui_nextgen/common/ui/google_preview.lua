LuaQ    ipxvyuo/google_preview.lua           ?      @@ @ E     \ 	@   @@ @ E     \ 	@   @@ @ EÀ   \ 	@    @@ @ E À \ 	@   @@ @ EÀ @ \ 	@    @@ @ E À \ 	@    @@ @ EÀ   \ 	@   @@ @ E À \ 	@$    $@  À $            MODEL    SETPERSISTENT    lua    google_maps_button_cockpit    BOOL_MODEL    google_maps_button_quick    QMapsObjects    CSTRING_MODEL    Current point    QMapsObjectsIndex 
   INT_MODEL        QMapsTypes    geo    QMapsTypesIndex 	   QBaseMap    roadmap    QBaseMapIndex    VW_ShowGoogleMapsObject    VW_GoogleMaps    W_DefaultWebBrowser           )     È   @     A@@   Z@     A@Á@ @  @     A@A    Ú@  @  AAAÁA À  
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
   MapsTypes     Ç      BaseMap     Ç      p_gcoor     Ç      QMapsTypes -   Ç      geo ¶   Ç           +   B        A      Á@  UÀ   À  @      Ö   	--activity:moveTaskToBack(false)

	local Intent = luajava.newInstance("android.content.Intent")
	local Uri = luajava.bindClass("android.net.Uri")

	Intent:setAction(Intent.ACTION_VIEW)
	Intent:setData(Uri:parse(" e  "))

	--Intent:addFlags(bit32.bor(Intent.FLAG_ACTIVITY_LAUNCH_ADJACENT, Intent.FLAG_ACTIVITY_NEW_TASK, Intent.FLAG_ACTIVITY_MULTIPLE_TASK))
	--local bundle = luajava.newInstance("android.graphics.Rect",0,0,200,200)
	--activity:startActivity(Intent, bundle)

	--Intent:setPackage("com.google.android.apps.maps")
	activity:startActivity(Intent)

	os.exit()
	    VW_runLuaJava        4   4   >   >   @   @   @   B         uri           chunk               D   e        E      \ @À  E     \ @ ÀÿAÀ     Á  UÀ @ À  @         type    wstring 	   tostring ç   	pm = activity:getPackageManager()

	browserIntent = luajava.newInstance("android.content.Intent")
	Uri = luajava.bindClass("android.net.Uri")

	browserIntent:setAction(browserIntent.ACTION_VIEW)
	browserIntent:setData(Uri:parse(" î  "))

	browserIntent:addFlags(browserIntent.FLAG_ACTIVITY_NEW_TASK)

	--browserIntent:addFlags(bit32.bor(browserIntent.FLAG_ACTIVITY_LAUNCH_ADJACENT, browserIntent.FLAG_ACTIVITY_NEW_TASK, browserIntent.FLAG_ACTIVITY_MULTIPLE_TASK))
	--rect = luajava.bindClass("android.graphics.Rect")

	browserIntent:setClassName("com.android.chrome", "com.google.android.apps.chrome.Main") -- was added for "content://com.estrongs.files/storage/0000-0000/Help.html"
	browserIntent:setPackage("com.android.chrome")


		--resolveInfo = pm:resolveActivity(browserIntent, pm.MATCH_DEFAULT_ONLY)

		--packageName = resolveInfo.activityInfo.packageName

		--browserIntent:setPackage(packageName) -- == "android"?????


	activity:startActivity(browserIntent)

	os.exit()
	    VW_runLuaJava        E   E   E   E   E   E   E   E   E   E   M   M   b   b   c   c   c   e         uri           chunk           ?                                                                                                                                 	   	   	   	   	   	   	   
   
   
   
   
   
   
   )      B   +   e   D   e           