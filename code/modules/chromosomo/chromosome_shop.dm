//where you hire chromosome assassins
/client/verb/chromosome_shop()
	set category = "OOC"
	set name = "chromosome Shop"
	set desc="The shop for buying things with chromosomes!"

	var/chromosomes = src.get_chromosome_count()
	src.update_chromosome_items()
	var/body = "<body>"
	body += "<div style='font-size: 20px;text-align:center;'><b>chromosome Balance</b>: [chromosomes]</div><br><br>"
	body += "<div style='display:flex;flex-direction:row;justify-content:flex-start;align-items:baseline;flex-wrap:wrap;width:650px;margin:auto;'>"
	body += "<style>"
	body += ".icon-wrapper {width:114px;height:96px;text-align:center;}"
	body += ".icon {-ms-interpolation-mode:nearest-neighbor;width:96px}"
	body += ".item {width:114px;height:140px;display:inline-block;margin:6px;border:solid 2px;cursor:pointer;transition: margin 0.15s, border 0.15s; user-select: none; -ms-user-select:none;} .item:hover {margin:4px;border:solid 4px;}"
	body += ".disabled {cursor: not-allowed !important; opacity: 0.8; filter: grayscale(100%); -webkit-filter: grayscale(100%); background-color:#666;} .disabled:hover{margin:6px !important;border:solid 2px !important;}"
	body += "</style>"
	for (var/item_type in subtypesof(/datum/chromosome_shop_item))
		var/datum/chromosome_shop_item/I = new item_type
		if (I.enabled)
			body += "<div class='item [(I.id in src.chromosome_items) ? "disabled" : ""]' onclick='window.location=\"?chromosome_buy=[I.id]\"'><div class='icon-wrapper'>[I.get_icon(src)]</div><div style='text-align:center;user-select:none; -ms-user-select:none;'>[I.name]</div><div style='text-align:center;font-weight:bold;font-size:18px;user-select:none; -ms-user-select:none;'>[I.cost]CHR</div></div>"
	body += "</div>"
	body += "<br></body>"

	var/datum/browser/popup = new(usr, "chromosomeshop-[REF(src)]", "<div style='font-size: 20px;' align='center'>Welcome to the chromosome Shop!</div>", 700, 500)
	popup.set_content(body)
	popup.open(0)


/client/Topic(href, href_list)
	..()
	if(href_list["chromosome_buy"])
		var/datum/chromosome_shop_item/I
		for(var/item_type in subtypesof(/datum/chromosome_shop_item))
			I = new item_type
			if(I.id == href_list["chromosome_buy"] && I.enabled)
				I.buy(src)
				break
		chromosome_shop()
