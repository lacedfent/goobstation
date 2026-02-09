/datum/action/cooldown/spell/pointed/resonance_wave
	name = "Resonance Wave"
	desc = "Sends a wave of destructive vibrations in a direction, damaging all enemies in its path."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "voidpull" // placeholder
	sound = 'sound/effects/explosion/explosion_distant.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 25 SECONDS

	invocation = "R'SON'TE!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cast_range = 9

/datum/action/cooldown/spell/pointed/resonance_wave/is_valid_target(atom/cast_on)
	return TRUE

/datum/action/cooldown/spell/pointed/resonance_wave/cast(atom/cast_on)
	. = ..()
	var/turf/start_turf = get_turf(owner)
	var/turf/target_turf = get_turf(cast_on)

	if(!start_turf || !target_turf)
		return

	playsound(start_turf, 'sound/effects/explosion/explosion_distant.ogg', 75, TRUE)

	var/list/turfs_in_line = get_line(start_turf, target_turf)
	for(var/turf/line_turf in turfs_in_line)
		new /obj/effect/temp_visual/resonance_wave(line_turf)

		for(var/mob/living/victim in line_turf)
			if(victim == owner)
				continue
			if(IS_HERETIC_OR_MONSTER(victim))
				continue

			victim.apply_damage(25, BRUTE, wound_bonus = 5)
			victim.adjust_confusion(6 SECONDS)
			victim.adjust_stamina_loss(25)
			victim.Knockdown(1 SECONDS)
			to_chat(victim, span_userdanger("Violent vibrations tear through your body!"))

		sleep(0.1 SECONDS)

/obj/effect/temp_visual/resonance_wave
	icon = 'icons/effects/effects.dmi'
	icon_state = "shockwave" // placeholder
	duration = 0.5 SECONDS
