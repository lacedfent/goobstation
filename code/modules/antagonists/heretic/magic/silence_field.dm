/datum/action/cooldown/spell/aoe/silence_field
	name = "Zone of Silence"
	desc = "Creates a zone where no sound can exist, preventing speech and sound-based abilities."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "voidpull" // placeholder
	sound = null

	school = SCHOOL_FORBIDDEN
	cooldown_time = 45 SECONDS

	invocation = "S'LENCE..."
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	aoe_radius = 4

/datum/action/cooldown/spell/aoe/silence_field/cast(atom/cast_on)
	. = ..()
	new /obj/effect/temp_visual/silence_field(get_turf(cast_on), aoe_radius)

/obj/effect/temp_visual/silence_field
	name = "zone of silence"
	desc = "An eerie zone where no sound exists."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2" // placeholder
	duration = 10 SECONDS
	var/radius = 4

/obj/effect/temp_visual/silence_field/Initialize(mapload, set_radius)
	. = ..()
	if(set_radius)
		radius = set_radius
	START_PROCESSING(SSobj, src)

/obj/effect/temp_visual/silence_field/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/temp_visual/silence_field/process(seconds_per_tick)
	for(var/mob/living/victim in range(radius, src))
		if(IS_HERETIC(victim) || IS_HERETIC_MONSTER(victim))
			continue

		victim.set_silence_if_lower(2 SECONDS)
		if(SPT_PROB(10, seconds_per_tick))
			to_chat(victim, span_warning("You can't make any sound!"))
