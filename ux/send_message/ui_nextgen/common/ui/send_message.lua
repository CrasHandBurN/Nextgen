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
                                                                                                                                                                                                                                                               p_gcoor     e      geo W   e                   	   E      Á@  \  Ô      Á  ÆA Â  I@þ  À  A             wsplit 	   , % s ?      	   "      wjoin 	   ,                                                                              email           t          (for index)          (for limit)          (for step)          i                  ò    Ò   A   @  @ÅÀ     Ü  AA  U  ÀA B@BÀ   @  Å ÆÀÁÆ ÂÆÀÂÆ ÃÆ@ÃÜ    Á À Ê   AA  É  AÁ  Å  BEE Ü    É  AÁ  Å  BEF Ü    É  A  É 
 EÁ   \   Å ÆAÇÆÇÜ   ÅÁ  Â Ü   A  BGBH ÅÂ   Ü UÁ	AEÁ  	 \  AGAI ÅÁ  	 Ü   A  BGBH ÅÂ  Ã	 Ü UÁ	AEÁ  A
 \  AGAI ÅÁ  	 Ü   A  BGBH ÅÂ  
 Ü UÁ	AEÁ   \  AGAI ÅÁ  B Ü   A  BGBH ÅÂ   Ü UÁ	AEÁ   \  AGAI ÅÁ  	 Ü   A  BGBH ÅÂ  C Ü UÁ	AEÁ  Á \  AGAI ÅÁ  	 Ü   A  BGBH ÅÂ  C Ü UÁ	AE FAÇFÍ\ FAZ  EA  AGM \A   6   	   h t t p : / / m a p s . g o o g l e . c o m / ? q =      wstring    gsub 
   towstring 	0   l o n g i t u d e   =   ( - ? % d + . % d + ) ,   l a t i t u d e   =   ( - ? % d + . % d + )   	   % 2 , % 1      MODEL    my    map    select_address    sc_wformat_replace_shield    selected_item    address    long_format 	   .        Current point    sc_translate_VoiceOrLang    I`m here: %s 
   VIA point    Will be there: %s at %s    sc_ShowDayTimeTool    navigation    eta_at_waypoint    Destination point    eta_at_destination 
   TMC point !   Traffic jam starts from here: %s    Email ë  			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.google.android.gm"

			pm:getPackageInfo(Package, pm.GET_ACTIVITIES)

			if pm.NameNotFoundException then
				--Intent = luajava.newInstance("android.content.Intent")
				Uri = luajava.bindClass("android.net.Uri")
				Intent:setAction(Intent.ACTION_SENDTO)
				Intent:setData(Uri:parse("mailto:"))
				--Intent:setType("*/*")
				Intent:putExtra(Intent.EXTRA_EMAIL, ({    lua    MessengerContact_Email n   }))
				Intent:putExtra(Intent.EXTRA_SUBJECT, "Sent from Navigator")
				Intent:putExtra(Intent.EXTRA_TEXT, " 	     |        SendLocation »  ")
				--Intent:putExtra(Intent.EXTRA_STREAM, attachment)
				Intent:setPackage(Package)
				activity:startActivity(Intent)
				--activity:startActivity(Intent:createChooser(Intent, "Choose an email client from..."))
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("market://details?id=" .. Package))

				Intent:setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				activity:startActivity(Intent)
			end

			os.exit()
			 	   WhatsApp ì   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.whatsapp"

			pm:getPackageInfo(Package, pm.GET_ACTIVITIES)

			if pm.NameNotFoundException then
				toNumber = "    MessengerContact_Phone    "
				text = " .  "
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("http://api.whatsapp.com/send?phone=" .. toNumber .. "&text=" .. text))
				activity:startActivity(Intent)
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("market://details?id=" .. Package))

				--if not pm:resolveActivity(Intent, pm) then
				--	Intent:setData(Uri:parse("https://play.google.com/store/apps/details?id=" .. Package))
				--end

				Intent:setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				activity:startActivity(Intent)
			end
			os.exit()
			 	   Telegram ø   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "org.telegram.messenger"

			pm:getPackageInfo(Package, pm.GET_ACTIVITIES)

			if pm.NameNotFoundException then
				--toNumber = " ö  "
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("http://telegram.me/"))
		--Intent:setAction(Intent.ACTION_SENDTO)
        Intent:setType("text/plain")
       -- Intent:setPackage(Package)
        Intent:putExtra(Intent.EXTRA_TEXT, text)
        --mUIActivity.startActivity(Intent.createChooser(myIntent, "Share with"))
				activity:startActivity(Intent)
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("market://details?id=" .. Package))

				--if not pm:resolveActivity(Intent, pm) then
				--	Intent:setData(Uri:parse("https://play.google.com/store/apps/details?id=" .. Package))
				--end

				Intent:setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				activity:startActivity(Intent)
			end
			os.exit()
			    SMS y   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")

			toNumber = "    "
			text = "    "
			Intent:setAction(Intent.ACTION_VIEW)
			Intent:setData(Uri:parse("smsto:"))
			Intent:setType("vnd.android-dir/mms-sms")
			Intent:putExtra("address", toNumber)
			Intent:putExtra("sms_body", text)

			activity:startActivity(Intent)

			os.exit()
			    Viber î   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.viber.voip"

			pm:getPackageInfo(Package, pm.GET_ACTIVITIES)

			if pm.NameNotFoundException then
				toNumber = "   "
				Intent:setAction(Intent.ACTION_SEND)
				Intent:addCategory(Intent.CATEGORY_DEFAULT)
				Intent:setPackage(Package)
				Intent:setData(Uri:parse("sms:" .. toNumber))
				Intent:putExtra("address", toNumber)
				Intent:putExtra("sms_body", text)

				activity:startActivity(Intent)
			else
				Intent:setAction(Intent.ACTION_VIEW)
				Intent:setData(Uri:parse("market://details?id=" .. Package))

				Intent:setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				activity:startActivity(Intent)
			end

			os.exit()
			    Skype ð   			Intent = luajava.newInstance("android.content.Intent")
			Uri = luajava.bindClass("android.net.Uri")
			Package = "com.skype.raider"

			pm:getPackageInfo(Package, pm.GET_ACTIVITIES)

			if pm.NameNotFoundException then
				toNumber = " 	   SendType    VW_runLuaJava     Ò                                                                                        !   !   !   !   !   "   "   "   "   "   "   "   "   "   "   "   #   #   #   #   #   #   #   #   #   #   #   $   $   $   $   $   &   '   4   4   4   4   4   4   4   4   4   6   6   6   6   6   6   6   6   6   6   D   D   D   D   F   N   N   N   N   N   N   N   O   O   O   O   O   O   O   O   O   O   _   _   _   _                                                         ¡   ¡   ¡   ¡   ¢   ¦   ¦   ¦   ¦   ¦   ¦   ¦   §   §   §   §   §   §   §   §   §   §   ±   ±   ±   ±   ²   º   º   º   º   º   º   º   »   »   »   »   »   »   »   »   »   »   Í   Í   Í   Í   Î   Ö   Ö   Ö   Ö   Ö   Ö   Ö   ×   ×   ×   ×   ×   ×   ×   ×   ×   ×   é   é   é   é   í   í   í   í   í   í   í   î   î   î   î   î   î   î   ò         gcoor_l     Ñ      message 
   Ñ      Address    Ñ      phrase <   Ñ      chunk Ã   Ñ         VW_Contact_Email_prep     ü           @       À@  A  @A À   À@ 	@A   À@ 	ÀA        gContact_phrase    MessengerContact    MODEL    lua 	   SendType    Email    ContactType    Phone        ý   ý   þ   þ   þ   þ   þ   þ   ÿ   ÿ   ÿ   ÿ                                    A@  @         sc_SetPopoverListAndOpen    ui.lm_SendLocation_Popover                        Z                                                                                                                                          ò   ò      õ   õ   õ   õ   õ   õ   õ   õ   õ   ö   ö   ö   ö   ö   ö   ö   ö   ö   ö   ö   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ÷   ú   ú   ú   û   û           ú           VW_Contact_Email_prep -   Y       