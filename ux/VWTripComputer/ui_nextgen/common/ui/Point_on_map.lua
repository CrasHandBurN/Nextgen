LuaQ    ipxvyuo/Point_on_map.lua           A   $      $@  @  $�  E�  F�� F � �� �� �� I���E�  F�� F � �@ � � �� I� �E�  F�� F � �@ �   �� I���A@ G  d�  G� E� K � �  \@�d@ G@ d� G� d� G� d  G  d@ G@ d�     G� A@ G� d� G  d  G@ d@ G� d� G� E�  F�� F � �@ �� �� I� � �       sc_screen_msgbox_pause    sc_screen_msgbox_resume    MODEL    SETPERSISTENT    lua    Show_NorthUp_HeadUp 
   INT_MODEL        poi_around_for_TC    BOOL_MODEL    SET    routecontrolVisible    routecontrolVisibleID ����   VW_Create_mapside_panel    hook_StartInit 	   register    sc_Point_on_mapSidePanel_place !   sc_Point_on_mapSidePanel_replace     sc_Point_on_mapSidePanel_rotate    sc_Point_on_mapSidePanel_show    sc_Point_on_mapSidePanel_hide    sc_Point_on_mapSidePanel_reset    VW_CheckFitForPOIOnMapID    VW_CheckFitForPOIOnMap    sc_FillSmartPois_bySplitScreen    VW_show_pois    VW_GoToDestinationByGoogle    FromBeginningOrCurrent    CSTRING_MODEL    From current position                       @@ �@ �@ A  � � @� �       MODEL    screen    msgbox    pause_tags    popup                                               
            @@    @��  �@  A @A A� @  �       st_Cockpit 	   isActive    MODEL    screen    msgbox    resume_tags    popup                                      
                              @@ �@ E   F@� F�� �   �@@� A�   �@��@� � �       ui    TripCompSidePanel_route    X    Y    W    H                                                                 !            A@  ��  @�@  �@ �   @�@   A @ @  @A �@  @� �       CREATE    point_on_mapsidepanel    alternatemap    ONMAPCLICK    ONMAPDRAGGED    ONMAPLONGCLICK                 	      @@ E�  F�� F � @ @ @�  �       builtin    invert    MODEL    lua    VIAOrDestination    sc_Point_on_mapSidePanel_reset     	                                                          @@ �@ A�  �  @�@ E� @ �  B E   F@� F�� @ � A  �@ ���  �       MODEL    sound    playchanneltest    ding 	   ! b u t t o n      killDelayed    routecontrolVisibleID    builtin    invert    lua    routecontrolVisible 
   doDelayed �  &   MODEL.lua.routecontrolVisible = false                                                                                                                                 !               #   %            @�  �       VW_Create_mapside_panel        $   $   %               '   /                �   E�  F�� F@� 	@��   E�  F�� F � 	@ �   E�  F�� F@� 	@��   E�  F�� F�� 	@ �   E�  F�� F�� 	@�� �       point_on_mapsidepanel    X    ui    TripCompSidePanel_propertybox    Y    W    H    Z        (   (   (   )   )   )   )   )   *   *   *   *   *   +   +   +   +   +   ,   ,   ,   ,   ,   -   -   -   -   -   /               1   4      	      A@  ��  @�   A�  �  @� �    
   doDelayed       sc_Point_on_mapSidePanel_place       sc_Point_on_mapSidePanel_reset     	   2   2   2   2   3   3   3   3   4               6   L      p      @@ �@ ��    �� � �   ��@� A��� �   @	��   �@A��A��A� B��� �   @��   �@A��A��A�@B��A��B��B���    �   �@A��A��A�@B��A�   �@�ƀ�����@�ƀ�� �܀� ̀��� ��B��� @  ���   �@C��C��C���    �   �@C��C��C��� @  �   �@@� D��� �   @ ��@    �� � �@   A@�@�� �B��� �DE  FA�F��F��\�� � � � �  @�  AE�E�E�� �    AEFAF@��  A�@�   @E  F @F A@ @  �       MODEL    lua    Show_NorthUp_HeadUp    gps    valid    route    list 
   navigated    has_navigable_path 
   waypoints       real_position    size    navigation    car 	   position    VIAOrDestination        builtin 
   direction       map    primary    rotate    point_on_mapsidepanel    set_rotate     p   7   7   7   7   7   7   8   :   :   :   :   :   :   :   :   :   :   :   :   :   :   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   <   >   >   >   >   >   >   ?   ?   ?   ?   ?   ?   A   A   A   A   A   A   A   A   A   B   C   C   C   C   C   C   D   D   D   D   D   D   D   D   D   D   D   D   F   F   F   F   F   F   H   H   H   H   H   H   H   H   J   J   J   J   J   J   L         VIA_pos    h      destination_pos    h      gcoor H   h      angle I   h           N   P            @@ @  �       point_on_mapsidepanel    SHOW        O   O   O   P               R   V               � �   @@ @  �       point_on_mapsidepanel    HIDE        S   S   S   T   T   T   V               X   �     �      @@ �@ F�@ \�� W � � �F@A �  \@ E� \@� C  �   ���� �܀� �   @	��   �@�ƀ����� �܀� �   @��   �@�ƀ�����@�ƀ�ƀ����܀� @ ��   �@�ƀ�����@�ƀ�  AB�B�BAC�BD�� �C� ����܀� � ����   �@�ƀ����܀� @ ��   �@�ƀ����܀� � ��   � ��@�܀� �   @ ��@�   ��    AD�D�D�� E  FA�F��F��\�� �  �E��E��� �   �	 Ƌ	 ƌ	�F�	�F����A ��Gʁ  ��F����GM��O�B���B�FB��BHM��O�B����� @ 	�Ƌ	�ƌ	�F�	�F�	�H��	 �A	 $        ��A���	 ��  A�  �  �A���I �J��ʔ��I �J��ȕ�K ��   �A� � -      MODEL    map    point_on_mapsidepanel    state 	   routemap    enter_state    sc_Point_on_mapSidePanel_place    gps    valid    route    list 
   navigated    has_navigable_path 
   waypoints       real_position    size    navigation    car 	   position    lua    VIAOrDestination    Show_NorthUp_HeadUp    center_posy _   	   car_posy    center_posx 2   	   car_posx    GCOOR    new    lat       lon    center_follow 
   doDelayed       sc_Fit_To_Screen    camera_settings    intersection_zoom    heading_correction    
   available    set_smart_camera        z   z           D � 	@ � �       center        z   z   z   z          	   mapLayer    gcoor_center �   Y   Y   Y   Z   Z   Z   Z   [   [   [   ]   ]   _   a   a   a   a   a   a   a   a   a   a   a   a   a   a   b   b   b   b   b   b   b   b   b   b   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   c   e   e   e   e   e   e   f   f   f   f   f   f   i   i   i   i   i   i   i   i   i   i   i   i   i   i   j   j   j   j   j   l   l   l   l   l   l   m   n   o   p   p   r   r   r   r   r   r   r   r   r   r   r   r   r   r   r   r   r   r   r   s   t   u   v   y   z   z   z   z   z   z   }   }   }   }   }   }            �   �   �   �   �   �   �   �      	   mapLayer    �      VIA_pos    �      destination_pos    �      TopLeft S   �      BottomRight S   �      gcoor_center X   �         VW_getFitbox     �   �            E@  @ �  �@  A W@A  ��  �@  A �A ��� @�   A@ �� ��@   �       killDelayed    VW_CheckFitForPOIOnMapID 
   MSG_Table    line       Point on map    Back to car    sc_Point_on_mapSidePanel_reset 
   doDelayed �     VW_CheckFitForPOIOnMap        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �               �   �            @@ �@ �@ @�   E   F@� F�� F��   �E  FA�F��F��A���� Ɓ��� \A  !�   � �       MODEL    poi 
   resultpoi    clear    ModelList_iter    ui    lm_splitpoi    list    add_poi_by_id    provider_id    id        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         (for generator)          (for state)          (for control)          item          index               �   �        E   F@� F � F�� \�� �� ��E   F@� F � I�@�E  \@�  �E   F@� F � I@A�E   F�� F�� F � \@�  � 	      MODEL    map 
   show_pois       sc_FillSmartPois_bySplitScreen       poi 
   resultpoi    clear        �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      	   mapLayer                �   �      �   
� 	@@�	@@�	@��	@@�	@��	�A�	@B�	@@�	@��	@B�E@ F�� F�� F � �@ ��C��C�@D��� F�� F�� \�� �@ ��D� D� E�@E��� �   @!��� �@  �� �@ ���� �܀� @����  � E� F��A �A �������Ɓ���������� ��  � B \� �@����  � E� F��A �A Ɓ�������� ��  � B \� �@��@ ���� �� �ƀ�� �� ����@��  A	 E� F��A �A �������Ɓ���Ɓ������ ��  � �	 \� �@���  A �DDE�GD �@A�  ���� �	 E� F��B �B �������Ƃ���Ƃ������ ��  � �	 \� �@�����  
 E� F��A �A �������Ɓ���B �DDE�GDBJ�� ������� ��  � B \� �@�ŀ
   �@  ���
 �  A �  �@   � .          driving                   walking    
   bicycling       	      MODEL    mydata    vehicle_profile    list    selected_profile    vehicle_type    route 
   navigated    has_navigable_path 3   https://www.google.com/maps/dir/?api=1&travelmode=    lua    FromBeginningOrCurrent    From very beginning 	   &origin=    string    gsub 	   tostring 
   waypoints    strapped_position 0   longitude = (-?%d+.%d+), latitude = (-?%d+.%d+)    %2,%1    navigation    car 	   position    &waypoints= 	   %2%%2C%1    %7C    &destination= 
   lastindex    VW_GoogleMaps    VW_LongTextToSay    sc_translate_VoiceOrLang    No route at the moment     �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         mode    �      vehicleType    �      uri "   �      (for index) q   �      (for limit) q   �      (for step) q   �      i r   �       A         
                                                                              !      #   #   %   #   /   '   4   1   L   6   P   N   V   R   �   �   X   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �         VW_getFitbox    @       