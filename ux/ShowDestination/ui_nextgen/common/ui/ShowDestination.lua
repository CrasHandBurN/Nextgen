LuaQ    ipxvyuo/ShowDestination.lua           Ú      @@ @ E  @ Á Á A   \  	@@ d   G d@      GÀ d      G  E   F@Ã FÀ À Â    I E   F@Ã FÀ À Â   I E   F@Ã FÀ À Â   IE   F@Ã FÀ À Â   I E   F@Ã FÀ   Á   IE   F@Ã FÀ   Á  IE   F@Ã FÀ   Á   IJ   @ FÊ   AA  É  AÁ  É  äÀ            A@@EA   ä ÁÊ  @BDE  FÉFBÉ  IÂIÅ  ÆÉÆÊ  ICJE  FÉFÊ  ÃJKCKKÅ  ÆÉÆÃË  ILâAÁ\ 	A ÁLJÁ  ¤A   I  @HIIÍ A   A@@EA   ä ÁÊ   @DE  FÉFBÉ  IÂIÅ  ÆÉÆÊ  ICJE  FÉFÊ  ÃJKCKKÅ  ÆÉÆÃË  ILE  FÉFÎâA Á\ 	A ÁLJÁ  ¤Á   I  @ÁMIIÍ A  ÁN¤ A AA Á  Ê Â E âA ÁÐ Ñ¡AA ÁN¤A    A  F      MODEL    SET    lua    VW_distance_to_destination 
   INT_MODEL    sc_GetSysEntry    ui    destination_proximity ^         sc_Dest_SpeedCheck_Start    sc_Dest_SpeedCheck_Stop    sc_route_finished_Speedcheck    SETPERSISTENT    ShowDestinationBtn    BOOL_MODEL    ShowDestinationBtnQuick    SRStartEnable    SRSEndEnable    SRSEDistanceToDestination X  	   SRSEZoom <   #   SRSEDistanceToDestination_time_out       GCOOR    new    lat    parse_gcoor    N90    lon    E0    SRSSGPSRouteStart    PROXY_BOOL_MODEL    getter    observe    gps    connection_status    navigation    car_pos_valid    valid    dead_reckoning 
   has_route    route    list 
   navigated    has_navigable_path    calculation_todo    is_in_simulation    obs_SRSSGPSRouteStart    var 	   observer 	   ONCHANGE    TRIGGER_ON_START     SRSSGPSRouteEnd    distance_to_destination    obs_SRSSGPSRouteEnd    hook_StartInit 	   register    createState     st_ShowRouteDestinationSettings    extends    st_List    st_Popover    title    'Show Destination' Settings 	   listname '   ui.lm_ShowRouteDestinationSettingsList    hook_DebugSnapshot 
                      @@ @         obs_destination_speedcheck    START                                   
           @@ @              obs_destination_speedcheck    STOP                     	   	   
             gIdleTime_SpeedCheckTime        &     o      @@ @ À@   A À   @A A ÀA  B  @  À    @B    @          @À J   Ê@ 
 A "A É 
  EA   DÁDÅ ÆAÅ E  FBÁFÁFÂÁFÂÅFÁ  BAAÂAÂEAF FFBÆ\ Ü    \  	AEA   DÁDÅ ÆAÅÂ E  FBÁFÁFÂÁFÂÅFÁ  BAAÂAÂEAF FFBÆ\ Ü    \  	AÉ   A@AG É ÉÀGÉÀG b@@ Á 
EÁ 	 ÅA	 "A@	 ÀI @   (      MODEL    navigation    car    current_speed       route    list 
   navigated    calculating           sc_DiscoverySidePanelChange "   You have reached the destination.    ACTION    DestinationCheck 	   POSITION    lat 	   tostring 	   regional    unlocalize_gcoor    builtin    format    %{gcoor[%lat]} 
   waypoints 
   lastindex    strapped_position    lon    %{gcoor[%lon]} 	   DISTANCE    distance_to_destination    VISIBLE    ENABLE 	   SRSEZoom #   SRSEDistanceToDestination_time_out    discoverysidepanel    ui_CheckDestination    ui_Discovery_Zoom    obs_destination_speedcheck    STOP     o                                                                                                                                                                                                                                                                                                       #   #   #   #   #   #   #   #   #      $   $   $   &             gIdleTime_SpeedCheckTime     5   l     Ó      @@ @ À@  A @ E   F@À FÀ FÀÀ F Á FÀ F@Á \ @  A  D   W  '   EÀ    Á  \   @BB Ô   À @ Û@   À  ÇÀ Ê Á JA  ÁA ¢A I  Å   BDDEÂ FÅB À  \  Ü  ÁÅ   BDDEÂ FÅÂ À  \  Ü  ÁI  ABAF IIÁFIÁF â@È  Å@  A Á Ê  EB  ÅÂ âA Ü@Å   Æ ÉÆ@ÉÆÉ  A@@Á@A@E  FAÀFÀFÁÀFÁFÀFAÁ\ AÁI Ü  
 EA
 
 À\A    A@@Á@ÁJ@K AKE FÁË  A@@Á@ÁJ@L Å  ÆAÀÆÀÆÁÀÆÁÊÆÀÆÆAÌÜ \   À ÁÁ  AB   @ Á @ AÂ     Á 
 EB
 \ B Å  ÃNFÜ UÂB E   F Ï F@Ï \ Z    E   F@Â F@Æ \     OO  EÀ F Ð   Å@  Ü ÀÅ@ Á Ü À \ H   D  \@   D      MODEL    route    list 
   navigated 
   waypoints 
   lastindex    strapped_position    VW_AddressByGCOOR    city    navigation    destination_name_short    gDestination_City    ACTION    ShowDestination 	   POSITION    lat 	   tostring 	   regional    unlocalize_gcoor    builtin    format    %{gcoor[%lat]}    lon    %{gcoor[%lon]} 	   DISTANCE    distance_to_destination    VISIBLE    ENABLE    sc_DiscoverySidePanelChange 	   SRSEZoom #   SRSEDistanceToDestination_time_out    discoverysidepanel    ui_weatherDSC    ui_ShowDestination    ui_Discovery_Zoom    sound    voice    format_street_name 	   longname    VW_LongTextToSay    sc_translate_VoiceOrLang    Your destination: %s.     itiner    size       math    max    icon_id    icon_small_id    VW_GetIconByIconID 	   Straight    sc_GetIcon    dir_destination_left    Left    dir_destination_right    Right 	           sc_wVoiceFormat_search_distance       lua    SRSEndEnable    SRSEDistanceToDestination    GCOOR    new    parse_gcoor    N90    E0     Ó   6   6   6   6   6   6   6   6   6   6   6   6   6   6   6   6   6   8   8   8   9   ;   ;   ;   ;   ;   ;   ;   ;   <   <   <   <   <   <   <   <   >   @   @   B   D   D   D   E   F   F   F   F   F   F   F   F   F   F   F   F   G   G   G   G   G   G   G   G   G   G   G   G   H   I   I   I   I   I   J   K   N   N   N   P   P   P   P   P   P   P   P   P   P   P   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   R   U   U   U   U   U   U   X   X   X   X   X   X   X   X   X   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Y   Z   Z   Z   \   ]   ]   ]   ]   ]   ^   ^   _   _   _   _   _   `   c   c   c   c   c   c   c   c   c   c   c   c   c   e   e   e   e   e   e   e   e   e   e   e   e   e   e   e   e   f   f   f   g   g   g   g   h   h   h   h   f   i   j   j   l         gcoor    Ò      a    ²      b    ²      MSG q   ²      last_index    ²      desination_iconID    ²      icon_file_name    ²      phrase    ²         destination_position    VW_Table_onRoute    VW_FieldRefreshEndShow     n   y      <      @@ @     À   À@  A  @A À
   A ÀA  @  À   À@  B  @  @   A @B     À   A B     @   ÀB  C @C C     @   A ÀC  @  @   A  D     @ @              MODEL    lua    SRStartEnable    gps    connection_status       navigation    car_pos_valid    valid    dead_reckoning 
   has_route    route    list 
   navigated    has_navigable_path    calculation_todo    is_in_simulation     <   p   p   p   p   p   p   r   r   r   r   r   r   s   s   s   s   s   s   s   s   s   s   s   s   s   s   s   s   s   s   t   t   t   t   t   t   u   u   u   u   u   u   u   u   v   v   v   v   v   v   w   w   w   w   w   w   w   w   w   y                       	      @@ @     @    @         MODEL    lua    SRSSGPSRouteStart     	                                        VW_FieldRefreshEndShow              F      @@ @     @   À@  A  E   F@À F@Á \ @  @   A ÀA   B À
   À@ @B  @  À   A B  @  @   À@ ÀB     À   À@  C     @   @C C ÀC  D     @   À@ @D  @  @   À@ D     @ @              MODEL    lua    SRSEndEnable    navigation    distance_to_destination    SRSEDistanceToDestination    gps    connection_status       car_pos_valid    valid    dead_reckoning 
   has_route    route    list 
   navigated    has_navigable_path    calculation_todo    is_in_simulation     F                                                                                                                                                                                                                                 ¯   ³     	      @@ @     @    @         MODEL    lua    SRSSGPSRouteEnd     	   °   °   °   °   °   °   ±   ±   ³             VW_FieldRefreshEndShow     ¸   »            @@ @   @@ @         obs_SRSSGPSRouteStart    START    obs_SRSSGPSRouteEnd        ¹   ¹   ¹   º   º   º   »               Æ   Í     
   @       	 Á  D   	@  	Á        UX_Name    plugin~ShowDestination    VW_Debugger_Table    start >   ***************************start*****************************    VW_Table_onRoute >   ****************************end******************************     
   Ç   Ç   É   É   Ê   Ê   Ê   Ë   Ë   Í             VW_Table_onRoute Ú                                             
   
      &   &      (   (   (   (   (   (   (   )   )   )   )   )   )   )   *   *   *   *   *   *   *   +   +   +   +   +   +   +   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   -   -   -   .   .   .   .   .   .   .   0   1   1   1   2   2   2   2   3   3   3   3   1   l   l   l   l   n   n   n   n   n   y   y   y   z   z   z   |   |   |   }   }   }   ~   ~   ~                                                            n                                                                              ¡   ¡   ¡   ¢   ¢   ¢   £   £   £   ¤   ¤   ¤   ¥   ¥   ¥   ¦   ¦   ¦   ¦   ¦   §   §   §   ¨   ¨   ¨   ©   ©   «   «   «      ¬   ®   ®   ®   ³   ³   ³   ´   ´   ´   ´   µ   ®   ¶   ¸   ¸   »   ¸   ½   ½   ½   ¾   ¿   Á   Á   Á   Â   Ã   ½   Æ   Æ   Í   Í   Æ   Í         gIdleTime_SpeedCheckTime    Ù      VW_Table_onRoute F   Ù      destination_position R   Ù      VW_FieldRefreshEndShow V   Ù       