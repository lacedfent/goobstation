/datum/action/cooldown/spell/aoe/deafening_shriek
	name = "Deafening Shriek"
	desc = "Releases an ear-piercing shriek that deafens and disorients all nearby enemies."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "voidpull" // placeholder
	sound = 'sound/effects/screech.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 20 SECONDS

	invocation = "SHR'EK OF S'LENCE!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	aoe_radius = 6

/datum/action/cooldown/spell/aoe/deafening_shriek/cast(atom/cast_on)
	. = ..()
	playsound(get_turf(cast_on), 'sound/effects/screech.ogg', 100, TRUE)

	for(var/mob/living/nearby_mob in range(aoe_radius, get_turf(cast_on)))
		if(nearby_mob == cast_on)
			continue
		if(IS_HERETIC_OR_MONSTER(nearby_mob))
			continue

		nearby_mob.adjust_organ_loss(ORGAN_SLOT_EARS, 20)
		var/obj/item/organ/ears/ears = nearby_mob.get_organ_slot(ORGAN_SLOT_EARS)
		if(ears)
			ears.adjust_temporary_deafness(45 SECONDS)
		nearby_mob.adjust_confusion(12 SECONDS)
		nearby_mob.set_jitter_if_lower(40 SECONDS)
		nearby_mob.adjust_eye_blur(15 SECONDS)
		nearby_mob.adjust_stamina_loss(40)
		nearby_mob.Knockdown(1.5 SECONDS)

		to_chat(nearby_mob, span_userdanger("An unbearable shriek pierces your ears!"))

/datum/heretic_knowledge/spell/deafening_shriek
	name = "Deafening Shriek"
	desc = "Grants you Deafening Shriek, a spell that releases an ear-piercing scream, \
		deafening and disorienting all nearby enemies."
	gain_text = "The sound of silence, preceded by the scream that ends all communication."
	action_to_add = /datum/action/cooldown/spell/aoe/deafening_shriek
	cost = 2
	research_tree_icon_frame = 7
