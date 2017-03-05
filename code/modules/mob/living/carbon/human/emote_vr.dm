/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)

	switch(act)
		if ("mlem")
			message = "mlems their tongue up over their nose. Mlem."
			m_type = 1
		if ("awoo")
			message = "awoos loudly. AwoooOOOOoooo!"
			m_type = 2
		if ("flip")
			var/danger = 2 //Base 1% chance to break something.
			var/list/involved_parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
			for(var/organ_name in involved_parts)
				var/obj/item/organ/external/E = get_organ(organ_name)
				if(!E || E.is_stump() || E.splinted || (E.status & ORGAN_BROKEN))
					involved_parts -= organ_name
					danger += 5

			//Taurs are harder to flip
			if(istype(tail_style, /datum/sprite_accessory/tail/taur))
				danger += 2

			//Check if they are physically capable
			if(src.sleeping || src.resting || src.buckled || src.weakened || src.restrained() || involved_parts.len < 2)
				src << "<span class='warning'>You can't *flip in your current state!</span>"
				return 1
			else
				src.SpinAnimation(7,1)
				message = "does a flip!"
				m_type = 1

				if(prob(danger))
					spawn(10) //Stick the landing.
						var/breaking = pick(involved_parts)
						var/obj/item/organ/external/E = get_organ(breaking)
						if(isSynthetic())
							src.Weaken(5)
							E.droplimb(1,DROPLIMB_EDGE)
							visible_message("<span class='warning'>[src]'s [E.name] flies off!</span>","<span class='warning'>Your flipping seems to have cost you, this time.</span>")
							log_and_message_admins("lost their [breaking] with *flip, ahahah.", src)
						else
							src.Weaken(5)
							E.fracture()
							visible_message("<span class='warning'>[src]'s [E.name] emits a sickening crunch as they land!</span>","<span class='warning'>Your flipping seems to have cost you, this time.</span>")
							log_and_message_admins("broke their [breaking] with *flip, ahahah.", src)

	if (message)
		log_emote("[name]/[key] : [message]")
		custom_emote(m_type,message)
		return 1

	return 0

