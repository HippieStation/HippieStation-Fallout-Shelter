/client/proc/get_chromosome_count()
	var/datum/DBQuery/query_get_chromosomes = SSdbcore.NewQuery("SELECT chromosomes FROM [format_table_name("player")] WHERE ckey = '[ckey]'")
	var/CHR_count = 0
	if(query_get_chromosomes.warn_execute())
		if(query_get_chromosomes.NextRow())
			CHR_count = query_get_chromosomes.item[1]

	qdel(query_get_chromosomes)
	return text2num(CHR_count)

/client/proc/set_chromosome_count(CHR_count, ann=TRUE)
	var/datum/DBQuery/query_set_chromosomes = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET chromosomes = '[CHR_count]' WHERE ckey = '[ckey]'")
	query_set_chromosomes.warn_execute()
	qdel(query_set_chromosomes)
	if(ann)
		to_chat(src, "Your new chromosome count is [CHR_count]!")

/client/proc/inc_chromosome_count(CHR_count, ann=TRUE)
	var/datum/DBQuery/query_inc_chromosomes = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET chromosomes = chromosomes + '[CHR_count]' WHERE ckey = '[ckey]'")
	query_inc_chromosomes.warn_execute()
	qdel(query_inc_chromosomes)
	if(ann)
		if(CHR_count >= 0)
			to_chat(src, "<span class='mind_control'>You gain [CHR_count] chromosomes.</span>")
		else
			to_chat(src, "<span class='mind_control'>You lose [CHR_count] chromosomes.</span>")



/client
	var/list/chromosome_items = list()
	var/list/chromosome_items_sorted = list()

/client/proc/update_chromosome_items()
	chromosome_items = list()
	chromosome_items_sorted = list()


	var/datum/DBQuery/query_get_chromosome_purchases
	query_get_chromosome_purchases = SSdbcore.NewQuery("SELECT item_id,item_class FROM [format_table_name("chromosome_item_purchases")] WHERE ckey = '[ckey]'")


	if(!query_get_chromosome_purchases.warn_execute())
		return

	while (query_get_chromosome_purchases.NextRow())
		var/id = query_get_chromosome_purchases.item[1]
		var/class = query_get_chromosome_purchases.item[2]
		chromosome_items += id
		if (class)
			if (!(class in chromosome_items_sorted))
				chromosome_items_sorted[class] = list()
			chromosome_items_sorted[class] += id

	qdel(query_get_chromosome_purchases)

/client/proc/filter_unpurchased_items(list/L, class=null)
	var/list/purchased
	if (class)
		purchased = chromosome_items_sorted[class]
	else
		purchased = chromosome_items
	var/list/filtered = list()
	for (var/key in L)
		if (L[key].chromosome_locked && !(key in purchased))
			continue
		filtered[key] = L[key]
	return filtered

/proc/filter_chromosome_sprite_accessories(list/L)
	var/list/filtered = list()
	for (var/k in L)
		if (L[k].chromosome_locked)
			continue
		filtered[k] = L[k]
	return filtered
