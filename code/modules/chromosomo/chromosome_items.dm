/datum/chromosome_shop_item
	var/name = ""
	var/cost = 0
	var/id = ""
	var/enabled = FALSE

	//shat for icons
	var/icon
	var/icon_state
	var/icon_dir = 2

/datum/chromosome_shop_item/proc/buy(client/C)
	if (!SSdbcore.IsConnected())
		to_chat(C, "<span class='rose bold'>Error! Try again later!</span>")
		return
	var/chromosomes = C.get_chromosome_count()
	if (chromosomes < cost)
		to_chat(C, "<span class='rose bold'>You do not have enough chromosomes to buy the [name]!</span>")
		return
	C.inc_chromosome_count(-cost)
	after_buy(C)
	to_chat(C, "<span class='rose bold'>You bought the [name] for [cost] chromosomes!</span>")

/datum/chromosome_shop_item/proc/after_buy(client/C)
	//giving them the item they bought

/datum/chromosome_shop_item/proc/get_icon(client/C) //getting the icon for the shop
	return icon2html(icon, C, icon_state, icon_dir)



/datum/chromosome_shop_item/only_one //you can only buy this item once
	name = "only one"
	cost = 0 //gl with that one
	enabled = FALSE
	var/class //used for classifying different types of items, like wings, hair, undershirts, etc


/datum/chromosome_shop_item/only_one/buy(client/C)
	C.update_chromosome_items()
	if(id in C.chromosome_items)
		return
	..()

/datum/chromosome_shop_item/only_one/after_buy(client/C)
	var/datum/DBQuery/query_chromosome_item_purchase = SSdbcore.NewQuery("INSERT INTO [format_table_name("chromosome_item_purchases")] (ckey, purchase_date, item_id, item_class) VALUES ('[C.ckey]', Now(), '[id]', '[class]')")
	query_chromosome_item_purchase.warn_execute()
	qdel(query_chromosome_item_purchase)
	C.update_chromosome_items()



/datum/chromosome_shop_item/only_one/moth_wings
	name = "moth wings"
	class = "moth_wings"
	enabled = FALSE

/datum/chromosome_shop_item/only_one/moth_wings/angel
	id = "Angel"
	name = "Angel Moth Wings"
	cost = 30
	enabled = TRUE

	icon = 'icons/mob/wings.dmi'
	icon_state = "m_wings_angel_FRONT"
	icon_dir = 1
