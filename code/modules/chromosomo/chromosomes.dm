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
		to_chat(src, "<span class='notice'><B>You gain [CHR_count] chromosomes.</B></span>")
