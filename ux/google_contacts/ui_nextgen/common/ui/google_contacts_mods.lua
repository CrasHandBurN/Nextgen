LuaQ !   ipxvyuo/google_contacts_mods.lua              $      $@  @          VW_contact_data_by_id    VW_android_contact_show           {        E   @  \    Ā    Å     Ü UĀ Ā  Ā  @      
   towstring ë  
	local function getContactNameById(contactId)
		local ContactsContract = luajava.bindClass("android.provider.ContactsContract")
		local contentResolver = activity:getContentResolver()
		local uri = ContactsContract.Contacts.CONTENT_URI
		local projection = {ContactsContract.Contacts.DISPLAY_NAME}

		local cursor = contentResolver:query(uri, projection, ContactsContract.Contacts._ID .. " = ?", {tostring(contactId)}, nil)
		if cursor and cursor:moveToFirst() then
			local name = cursor:getString(cursor:getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))
			cursor:close()
			return name
		end

		return nil
	end

	local function getContactPostalAddressById(contactId)
		local ContactsContract = luajava.bindClass("android.provider.ContactsContract")
		local contentResolver = activity:getContentResolver()
		local uri = ContactsContract.Data.CONTENT_URI
		local projection = {
			ContactsContract.CommonDataKinds.StructuredPostal.STREET,
			ContactsContract.CommonDataKinds.StructuredPostal.CITY,
			ContactsContract.CommonDataKinds.StructuredPostal.REGION,
			ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE,
			ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY,
			ContactsContract.CommonDataKinds.StructuredPostal.TYPE
		}
		local selection = ContactsContract.Data.CONTACT_ID .. " = ? AND " .. ContactsContract.Data.MIMETYPE .. " = ?"
		local selectionArgs = {tostring(contactId), ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_ITEM_TYPE}

		local cursor = contentResolver:query(uri, projection, selection, selectionArgs, nil)

		local addressFields = {
			Home = {},
			Work = {},
			Other = {},
		}

		local placeIndication

		if cursor and cursor:moveToFirst() then
			repeat

				local street = cursor:getString(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.STREET))
				local city = cursor:getString(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.CITY))
				local region = cursor:getString(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.REGION))
				local postcode = cursor:getString(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE))
				local country = cursor:getString(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY))
				local type = cursor:getInt(cursor:getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.TYPE))


				if type == ContactsContract.CommonDataKinds.StructuredPostal.TYPE_HOME then
					placeIndication = "Home"
				elseif type == ContactsContract.CommonDataKinds.StructuredPostal.TYPE_WORK then
					placeIndication = "Work"
				elseif type == ContactsContract.CommonDataKinds.StructuredPostal.TYPE_OTHER then
					placeIndication = "Other"
				else
					break
				end

				addressFields\[placeIndication\] = {
					street = street,
					city = city,
					region = region,
					postcode = postcode,
					country = country,
				}

			until not cursor:moveToNext()

			cursor:close()
		end
		return addressFields
	end

	local id = " ð  "

	local addressFields = getContactPostalAddressById(id)

	local path = storage .. appname --!!!!!!!!!!!!!!!!!!!storage .. appname!!!!!!!!!!!!!!!!!!!!!!

	local contact_data = \[\[
	contact_data = {
		contact_name = ansi_u16"\]\] .. getContactNameById(id) .. \[\[",

		home_street = ansi_u16"\]\] .. (addressFields.Home.street or "") .. \[\[",
		home_city = ansi_u16"\]\] .. (addressFields.Home.city or "") .. \[\[",
		home_postcode = ansi_u16"\]\] .. (addressFields.Home.postcode or "") .. \[\[",
		home_state = ansi_u16"\]\] .. (addressFields.Home.region or "") .. \[\[",
		home_country = ansi_u16"\]\] .. (addressFields.Home.country or "") .. \[\[",
		home_coord = GCOOR.new({lat = 0, lon = 0}),

		work_street = ansi_u16"\]\] .. (addressFields.Work.street or "") .. \[\[",
		work_city = ansi_u16"\]\] .. (addressFields.Work.city or "") .. \[\[",
		work_postcode = ansi_u16"\]\] .. (addressFields.Work.postcode or "") .. \[\[",
		work_state = ansi_u16"\]\] .. (addressFields.Work.region or "") .. \[\[",
		work_country = ansi_u16"\]\] .. (addressFields.Work.country or "") .. \[\[",
		work_coord = GCOOR.new({lat = 0, lon = 0}),

		other_street = ansi_u16"\]\] .. (addressFields.Other.street or "")  .. \[\[",
		other_city = ansi_u16"\]\] .. (addressFields.Other.city or "") .. \[\[",
		other_postcode = ansi_u16"\]\] .. (addressFields.Other.postcode or "") .. \[\[",
		other_state = ansi_u16"\]\] .. (addressFields.Other.region or "") .. \[\[",
		other_country = ansi_u16"\]\] .. (addressFields.Other.country or "") .. \[\[",
		other_coord = GCOOR.new({lat = 0, lon = 0}),
	}
		\]\]

	file_info = io.open(path .. "/save/contact_data.lua", "w")
	file_info:write(type(Utf8ToAnsi) == "function" and Utf8ToAnsi(contact_data) or contact_data)
	file_info:close()

	os.exit()
	    VW_runLuaJava           R   R   R   R   R   R   x   x   x   z   z   z   {         id           chunk 
              }           E   @  \    Ā    Å     Ü UĀ Ā  Ā  @      
   towstring 5   	activity:moveTaskToBack(false)
	local contactId = " ë  "
	--local function EditContactById(contactId)
		local ContactsContract = luajava.bindClass("android.provider.ContactsContract")
		local contentResolver = activity:getContentResolver()
		local uri = ContactsContract.Contacts.CONTENT_URI
		local projection = {
			ContactsContract.Contacts._ID,
			ContactsContract.Contacts.LOOKUP_KEY,
			}

		local cursor = contentResolver:query(uri, projection, ContactsContract.Contacts._ID .. " = ?", {tostring(contactId)}, nil)
		if cursor and cursor:moveToFirst() then
			local mcontactKey = cursor:getString(cursor:getColumnIndex(ContactsContract.Contacts.LOOKUP_KEY))

			local contactUri = ContactsContract.Contacts:getLookupUri(contactId, mcontactKey)

			local Intent = luajava.newInstance("android.content.Intent")
			--Intent:setAction(Intent.ACTION_EDIT)
			Intent:setAction(Intent.ACTION_VIEW)
			Intent:setDataAndType(contactUri, ContactsContract.Contacts.CONTENT_ITEM_TYPE)

			activity:startActivity(Intent)
			cursor:close()
		end
	--end
	os.exit()
	    VW_runLuaJava        ~                                                id           chunk 
             {         }              