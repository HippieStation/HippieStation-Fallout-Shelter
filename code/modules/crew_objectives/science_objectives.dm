/*				SCIENCE OBJECTIVES				*/

/datum/objective/crew/cyborgs //Ported from old Hippie
	explanation_text = "Ensure there are at least (Yell on GitHub, something broke) functioning cyborgs when the shift ends."
	jobs = "researchdirector,roboticist"

/datum/objective/crew/cyborgs/New()
	. = ..()
	target_amount = rand(3,10)
	update_explanation_text()

/datum/objective/crew/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.alive_mob_list)
		if(!(R.stat == DEAD))
			borgcount--
	if(borgcount <= 0)
		return TRUE
	else
		return FALSE

