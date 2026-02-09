/datum/heretic_knowledge_tree_column/noise
	route = PATH_NOISE
	ui_bgr = "node_void" // using void node as placeholder
	complexity = "Medium"
	complexity_color = COLOR_YELLOW
	icon = list(
		"icon" = 'icons/obj/weapons/khopesh.dmi',
		"state" = "void_blade", // using void blade as placeholder
		"frame" = 1,
		"dir" = SOUTH,
		"moving" = FALSE,
	)
	icon = list(
		"icon" = 'icons/obj/weapons/khopesh.dmi',
		"state" = "void_blade", // placeholder
		"frame" = 1,
		"dir" = SOUTH,
		"moving" = FALSE,
	)
	description = list(
		"The Path of Noise revolves around sound, vibrations, and sonic manipulation.",
		"Play this path if you enjoy disrupting enemies and controlling the battlefield through sound.",
	)
	pros = list(
		"Strong crowd control through deafening and stunning.",
		"Can silence areas to prevent communication.",
		"Resonance effects deal damage over time.",
	)
	cons = list(
		"Requires good positioning to maximize AoE effects.",
		"Less effective against deaf or sound-immune enemies.",
		"Abilities can be loud and draw attention.",
	)
	tips = list(
		"Your Mansus Grasp applies a mark that causes intense ringing and disorientation.",
		"Sonic Pulse can knock back multiple enemies and interrupt actions.",
		"Use Deafening Shriek to disable enemy communications before attacking.",
		"Resonance builds up on enemies, dealing increasing damage over time.",
		"Your blade vibrates at a frequency that bypasses some armor.",
		"The Silencer Mantle allows you to move silently and create zones of absolute quiet.",
		"Your ascension grants you the ability to become living sound itself.",
	)

	start = /datum/heretic_knowledge/limited_amount/starting/base_noise
	knowledge_tier1 = /datum/heretic_knowledge/spell/sonic_pulse
	guaranteed_side_tier1 = /datum/heretic_knowledge/medallion
	knowledge_tier2 = /datum/heretic_knowledge/spell/deafening_shriek
	guaranteed_side_tier2 = /datum/heretic_knowledge/rifle
	robes = /datum/heretic_knowledge/armor/noise
	knowledge_tier3 = /datum/heretic_knowledge/spell/resonance_wave
	guaranteed_side_tier3 = /datum/heretic_knowledge/summon/ashy // placeholder
	blade = /datum/heretic_knowledge/blade_upgrade/noise
	knowledge_tier4 = /datum/heretic_knowledge/spell/silence_field
	ascension = /datum/heretic_knowledge/ultimate/noise_final

/datum/heretic_knowledge/limited_amount/starting/base_noise
	name = "Resonant Whisper"
	desc = "Opens up the Path of Noise to you. \
		Allows you to transmute a knife and a radio to create a Resonant Blade. \
		You can only create two at a time."
	gain_text = "In the silence between heartbeats, I heard it. The frequency of reality itself, waiting to be tuned."
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/radio = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/noise)
	research_tree_icon_path = 'icons/obj/weapons/khopesh.dmi'
	research_tree_icon_state = "void_blade" // placeholder
	mark_type = /datum/status_effect/eldritch/noise
	eldritch_passive = /datum/status_effect/heretic_passive/noise

/datum/heretic_knowledge/limited_amount/starting/base_noise/on_mansus_grasp(mob/living/source, mob/living/target)
	. = ..()
	to_chat(target, span_userdanger("An overwhelming ringing fills your ears!"))
	target.adjust_confusion(4 SECONDS)
	target.set_jitter_if_lower(20 SECONDS)

/datum/heretic_knowledge/limited_amount/starting/base_noise/trigger_mark(mob/living/source, mob/living/target)
	. = ..()
	if(!.)
		return

	to_chat(target, span_userdanger("The ringing intensifies to unbearable levels!"))
	target.adjust_confusion(8 SECONDS)
	target.Knockdown(2 SECONDS)
	playsound(target, 'sound/effects/screech.ogg', 75, TRUE)


/datum/heretic_knowledge/armor/noise
	desc = "Allows you to transmute a table (or a suit), a radio, and a pair of earmuffs to create a Silencer Mantle. \
		It provides protection from sonic attacks and allows you to move silently. \
		Acts as a focus while hooded."
	gain_text = "The silent watchers move unseen, unheard. Their presence known only by the absence of sound."
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/eldritch/noise)
	research_tree_icon_state = "void_armor" // placeholder
	required_atoms = list(
		list(/obj/structure/table, /obj/item/clothing/suit) = 1,
		/obj/item/radio = 1,
		/obj/item/clothing/ears/earmuffs = 1,
	)

/datum/heretic_knowledge/spell/resonance_wave
	name = "Resonance Wave"
	desc = "Grants you Resonance Wave, a spell that sends out a wave of vibrations, \
		dealing damage over time to all enemies it passes through."
	gain_text = "The frequency that unmakes, the vibration that tears reality apart."
	action_to_add = /datum/action/cooldown/spell/pointed/resonance_wave
	cost = 2

/datum/heretic_knowledge/blade_upgrade/noise
	name = "Resonant Edge"
	desc = "Your blade now vibrates at a frequency that bypasses armor and causes internal damage."
	gain_text = "The blade sings its song of destruction, a frequency that cannot be stopped."
	research_tree_icon_path = 'icons/ui_icons/antags/heretic/knowledge.dmi'
	research_tree_icon_state = "blade_upgrade_ash" // placeholder

/datum/heretic_knowledge/blade_upgrade/noise/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(source == target || !isliving(target))
		return

	target.adjust_confusion(3 SECONDS)
	target.apply_damage(8, BRUTE, wound_bonus = 10, sharpness = SHARP_EDGED, def_zone = BODY_ZONE_CHEST, armor_penetration = 20)
	target.adjust_stamina_loss(10)

/datum/heretic_knowledge/spell/silence_field
	name = "Zone of Silence"
	desc = "Grants you Zone of Silence, a spell that creates an area where no sound can exist, \
		preventing all speech and sound-based abilities."
	gain_text = "In the void between sounds, there is power. The silence that consumes all."
	action_to_add = /datum/action/cooldown/spell/aoe/silence_field
	cost = 2
	research_tree_icon_frame = 5
	is_final_knowledge = TRUE

/datum/heretic_knowledge/ultimate/noise_final
	name = "Resonant Ascension"
	desc = "The ascension ritual of the Path of Noise. \
		Bring 3 corpses with ruptured eardrums to a transmutation rune to complete the ritual. \
		When completed, you become a being of pure sound, gaining immunity to deafness and sonic attacks. \
		You gain the ability to emit constant sonic pulses and can shatter objects with your voice."
	gain_text = "I AM THE FREQUENCY! I AM THE RESONANCE! REALITY ITSELF TREMBLES AT MY VOICE! \
		WITNESS MY ASCENSION, THE SOUND THAT ENDS ALL SILENCE!"

	ascension_achievement = /datum/award/achievement/misc/noise_ascension
	announcement_text = "%SPOOKY% Hear the resonance, for %NAME% has ascended! All shall hear the final note! %SPOOKY%"
	announcement_sound = 'sound/effects/explosion/explosion_distant.ogg' // placeholder

/datum/heretic_knowledge/ultimate/noise_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return

	// Check if they have ear damage (ruptured eardrums)
	if(sacrifice.get_organ_loss(ORGAN_SLOT_EARS) >= 15)
		return TRUE
	return FALSE

/datum/heretic_knowledge/ultimate/noise_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	// Grant immunity to ear damage and deafness
	var/obj/item/organ/ears/our_ears = user.get_organ_slot(ORGAN_SLOT_EARS)
	if(our_ears)
		ADD_TRAIT(our_ears, TRAIT_BRAIN_TRAUMA_IMMUNITY, type)
	ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, type)

	var/datum/action/cooldown/spell/aoe/sonic_pulse/pulse = locate() in user.actions
	if(pulse)
		pulse.cooldown_time *= 0.5
		pulse.aoe_radius += 2

	to_chat(user, span_boldwarning("You have become one with sound itself!"))
