/datum/action/cooldown/spell/aoe/sonic_pulse
	name = "Sonic Pulse"
	desc = "Releases a pulse of sonic energy that knocks back and stuns nearby enemies."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "voidpull" // placeholder
	sound = 'sound/effects/explosion/explosion_distant.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS

	invocation = "S'NIC W'VE!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	aoe_radius = 4

/datum/action/cooldown/spell/aoe/sonic_pulse/cast(atom/cast_on)
	. = ..()
	playsound(get_turf(cast_on), 'sound/effects/explosion/explosion_distant.ogg', 75, TRUE)

	for(var/mob/living/nearby_mob in range(aoe_radius, get_turf(cast_on)))
		if(nearby_mob == cast_on)
			continue
		if(IS_HERETIC_OR_MONSTER(nearby_mob))
			continue

		var/distance = get_dist(nearby_mob, cast_on)
		var/throwpower = max(2, aoe_radius - distance + 1)

		nearby_mob.Knockdown(2 SECONDS)
		nearby_mob.adjust_confusion(5 SECONDS)
		nearby_mob.apply_damage(10, BRUTE)
		nearby_mob.adjust_stamina_loss(30)

		var/atom/throw_target = get_edge_target_turf(nearby_mob, get_dir(cast_on, get_step_away(nearby_mob, cast_on)))
		nearby_mob.throw_at(throw_target, throwpower, throwpower)

		to_chat(nearby_mob, span_userdanger("A powerful sonic wave slams into you!"))

/datum/heretic_knowledge/spell/sonic_pulse
	name = "Sonic Pulse"
	desc = "Grants you Sonic Pulse, a spell that releases a wave of sonic energy, \
		knocking back and stunning all nearby enemies."
	gain_text = "The frequency of violence, a note that shatters bone and breaks will."
	action_to_add = /datum/action/cooldown/spell/aoe/sonic_pulse
	cost = 2
	drafting_tier = 5
