LuaQ     ipxvyuo/button_memory_usage.lua           &      @@ @ E     \ 	@ AĀ   Á@  @ @ @B @ @ @ @   @  @  AĀ Ā Á   E Ā Á@  \ Ī          Ā         MODEL    SETPERSISTENT    lua    memory_usage_in_cockpit    BOOL_MODEL    gFree_Memory_Limit_GC    sc_GetSysEntry    gc    memory_limit    
      period       clear_sound 	   s e t      sc_Garbage_Collector        
       #   E   @  Ä   \Z@  ĀE  FĀĀ F Á \ O@Á  X @     EĀ   \@ E  F@Â FÂ Ā Ä  \@   E  @ Á   E   \@          sc_TimerTool    Memory Usage    MODEL    other    free_memory       gFree_Memory_Limit_GC    collectgarbage    collect    sound    playchanneltest    ding    sc_InfoNotification    sc_translate_VoiceOrLang B   Collect garbage every %s seconds if "free_memory" less then %s MB     #                                                                                                                  trigger     "         period    clear_sound &                                                                                                               
            period    %      clear_sound !   %       