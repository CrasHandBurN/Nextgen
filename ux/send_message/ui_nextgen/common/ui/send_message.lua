LuaQ    ipxvyuo/send_message.lua           Z      @@ @ E     \ 	@   @@ @ E     \ 	@   @@ @ EÀ   \ 	@    @@ @ E À \ 	@   @@ @ EÀ @ \ 	@    @@ @ E À \ 	@ $   À $@  d      G  E   F@À FÀ  ÅÀ  Ü    IE   F@À FÀ  Å Á A A Ü    IE   F@À FÀ  Å Á AÁ A Ü    I E  @ ÊÀ  Á É $Á  É $ É \@  "      MODEL    SETPERSISTENT    lua    send_message_button_cockpit    BOOL_MODEL    send_message_button_quick    SendLocation    CSTRING_MODEL    Current point    SendLocationIndex 
   INT_MODEL     	   SendType    Email    SendTypeIndex    VW_SendMessage    VW_SendmessagebyLocation    MessengerContact_Name    WSTRING_MODEL 
   translate    Off    MessengerContact_Phone    sc_GetSysEntry 	   messager    phone 	        MessengerContact_Email    email    createState    st_send_messageContact    extends    st_SimpleInputContact    enter    exit                f   J  @  À@  @À@ A@A    @  @À@ A @      I @  ÀA B@BB BÀB  @  ÀA B@BB B@CC @      I @  @ D    @  ÀA B@BB BÅ@  ÆÀÁÆ ÂÆ@ÂÆÂÆ ÂÆ@ÄÜ À C @      IÀ  W E@  @EEÀEÅÀ Ü À  A @      I @   F@F      Å@  Æ ÆÆ@ÆÜ ÆÀ @         Current point    MODEL    navigation    car 	   position    valid 
   VIA point    route    list 
   navigated 
   waypoints    size          strapped_position    Destination point 
   has_route 
   lastindex 
   TMC point    sc_GetClosestEventData ÿÿÿÿ   traffic    events    significant_events    lua    SendLocation    VW_SendmessagebyLocation     f   	   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
                                                                                                                                                                                                                                                               p_gcoor     e      geo W   e                   	   E      Á@  \  Ô      Á  ÆA Â  I@þ  À  A             wsplit 	   , % s ?      	   "      wjoin 	   ,                                                                              email           t          (for index)          (for limit)          (for step)          i                      ¦   A   @  @ÅÀ     Ü  AA  U  ÀA B@BÀ   @  Å ÆÀÁÆ ÂÆÀÂÆ ÃÆ@ÃÜ    Á À Ê   AA  É  AÁ  Å  BEE Ü    É  AÁ  Å  BEF Ü    É  A  É 
 EÁ   \  AGG ÅÁ  Â Ü   A  BGBH ÅÂ   Ü UÁ	AEÁ  	 \   Å ÆAÇÆAÉÜ   ÅÁ  	 Ü   A  BGBH ÅÂ  Ã	 Ü UÁ	AEÁ  A
 \  AGG ÅÁ  Â Ü   A  BGBH ÅÂ  
 Ü UÁ	AEÁ   \  AGG ÅÁ  Â Ü   A  BGBH ÅÂ  C Ü UÁ	AE FAÇFË\ FAZ  EÁ  AGK \A   0   	   h t t p : / / m a p s . g o o g l e . c o m / ? q =      wstring    gsub 
   towstring 	0   l o n g i t u d e   =   ( - ? % d + . % d + ) ,   l a t i t u d e   =   ( - ? % d + . % d + )   	   % 2 , % 1      MODEL    my    map    select_address    sc_wformat_replace_shield    selected_item    address    long_format 	   .        Current point    sc_translate_VoiceOrLang    I`m here: %s 
   VIA point    Will be there: %s at %s    sc_ShowDayTimeTool    navigation    eta_at_waypoint    Destination point    eta_at_destination 
   TMC point !   Traffic jam starts from here: %s    SMS y   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")

			toNumber = "    lua    MessengerContact_Phone    "
			text = " 	     |        SendLocation    "
			Intent:setAction(Intent.ACTION_VIEW)
			Intent:setData(Uri:parse("smsto:"))
			Intent:setType("vnd.android-dir/mms-sms")
			Intent:putExtra("address", toNumber)
			Intent:putExtra("sms_body", text)

			activity:startActivity(Intent)

			os.exit()
			    Email S  			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.google.android.gm"

			Uri = luajava.bindClass("android.net.Uri")
			Intent:setAction(Intent.ACTION_SENDTO)
			Intent:setData(Uri:parse("mailto:"))
			--Intent:setType("*/*")
			Intent:putExtra(Intent.EXTRA_EMAIL, ({    MessengerContact_Email l   }))
			Intent:putExtra(Intent.EXTRA_SUBJECT, "Sent from Navigator")
			Intent:putExtra(Intent.EXTRA_TEXT, "    ")
			--Intent:putExtra(Intent.EXTRA_STREAM, attachment)
			Intent:setPackage(Package)

			activity:startActivity(Intent)

			os.exit()
			 	   WhatsApp    			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.whatsapp"

			toNumber = " Õ  "
			Intent:setAction(Intent.ACTION_VIEW)
			Intent:setData(Uri:parse("http://api.whatsapp.com/send?phone=" .. toNumber .. "&text=" .. text))

			local activities = pm:queryIntentActivities(Intent, 0)
			if activities:size() > 0 then
				activity:startActivity(Intent)
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("https://play.google.com/store/apps/details?id=" .. Package))
				activity:startActivity(Intent)
			end

			os.exit()
			 	   Telegram ¡   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "org.telegram.messenger"

			--toNumber = "   "
			Intent:setAction(Intent.ACTION_VIEW)
			Intent:setData(Uri:parse("http://telegram.me/"))
			--Intent:setAction(Intent.ACTION_SENDTO)
			Intent:setType("text/plain")
			-- Intent:setPackage(Package)
			Intent:putExtra(Intent.EXTRA_TEXT, text)
			--mUIActivity.startActivity(Intent.createChooser(myIntent, "Share with"))

			local activities = pm:queryIntentActivities(Intent, 0)
			if activities:size() > 0 then
				activity:startActivity(Intent)
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("https://play.google.com/store/apps/details?id=" .. Package))
				activity:startActivity(Intent)
			end
			os.exit()
			 	   SendType    VW_runLuaJava     ¦                                                                                        !   !   !   !   !   "   "   "   "   "   "   "   "   "   "   "   #   #   #   #   #   #   #   #   #   #   #   $   $   $   $   $   &   '   +   +   +   +   +   +   +   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   6   6   6   6   7   @   @   @   @   @   @   @   @   @   B   B   B   B   B   B   B   B   B   B   I   I   I   I   J   O   O   O   O   O   O   O   P   P   P   P   P   P   P   P   P   P   ^   ^   ^   ^   _   d   d   d   d   d   d   d   e   e   e   e   e   e   e   e   e   e   w   w   w   w   {   {   {   {   {   {   {   |   |   |   |   |   |   |            gcoor_l     ¥      message 
   ¥      Address    ¥      phrase <   ¥      chunk    ¥         VW_Contact_Email_prep                 @       À@  A  @A À   À@ 	@A   À@ 	ÀA        gContact_phrase    MessengerContact    MODEL    lua 	   SendType    Email    ContactType    Phone                                                                                   A@  @         sc_SetPopoverListAndOpen    ui.lm_SendLocation_Popover                            Z                                                                                                                                                                                                                                                                                       VW_Contact_Email_prep -   Y       