/// Syndicate Holographic Decoy Device
/// Creates a holographic copy of the user that walks in a direction to distract enemies
/obj/item/holographic_decoy
	name = "holographic decoy projector"
	desc = "A compact Syndicate device that projects a holographic copy of yourself. The decoy will walk in a chosen direction to distract your enemies."
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "holo_decoy"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5
	throw_speed = 3
	throw_range = 5

	/// Number of charges remaining
	var/charges = 3
	/// Maximum charges
	var/max_charges = 3
	/// Cooldown between uses (in deciseconds)
	var/cooldown_time = 30 SECONDS
	/// Time when the device can be used again
	var/next_use_time = 0

/obj/item/holographic_decoy/examine(mob/user)
	. = ..()
	. += span_notice("It has [charges] charge\s remaining.")
	if(world.time < next_use_time)
		var/time_left = round((next_use_time - world.time) / 10)
		. += span_warning("Recharging... [time_left] second\s remaining.")

/obj/item/holographic_decoy/attack_self(mob/user, modifiers)
	. = ..()
	if(world.time < next_use_time)
		to_chat(user, span_warning("[src] is still recharging!"))
		return

	if(charges <= 0)
		to_chat(user, span_warning("[src] is out of charges!"))
		return

	// Let user pick a direction
	var/direction = tgui_input_list(user, "Choose a direction for the decoy to walk", "Holographic Decoy", list("North", "South", "East", "West", "Cancel"))
	if(!direction || direction == "Cancel")
		return

	var/chosen_dir
	switch(direction)
		if("North")
			chosen_dir = NORTH
		if("South")
			chosen_dir = SOUTH
		if("East")
			chosen_dir = EAST
		if("West")
			chosen_dir = WEST

	create_decoy(user, chosen_dir)
	charges--
	next_use_time = world.time + cooldown_time
	to_chat(user, span_notice("You activate [src]. [charges] charge\s remaining."))
	playsound(src, 'sound/machines/terminal/terminal_processing.ogg', 50, TRUE)

/// Creates and spawns the holographic decoy
/obj/item/holographic_decoy/proc/create_decoy(mob/living/carbon/human/user, direction)
	if(!ishuman(user))
		return

	var/mob/living/simple_animal/hologram/decoy/new_decoy = new(get_turf(user))
	new_decoy.copy_appearance(user)
	new_decoy.walk_direction = direction
	new_decoy.start_walking()

/// The holographic decoy itself - looks almost exactly like the real person
/mob/living/simple_animal/hologram/decoy
	name = "holographic decoy"
	desc = "Something feels... off."
	icon = 'icons/mob/simple/animal.dmi'
	icon_state = "hologram"
	mob_biotypes = NONE
	speak_emote = list("beeps")
	health = 1
	maxHealth = 1
	speed = 1
	harm_intent_damage = 0
	obj_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "passes through"
	attack_verb_simple = "pass through"
	attack_sound = null
	friendly_verb_continuous = "shimmers at"
	friendly_verb_simple = "shimmer at"
	density = FALSE
	pass_flags = PASSGRILLE | PASSGLASS | PASSMOB | PASSMACHINE | PASSSTRUCTURE
	mob_size = MOB_SIZE_HUMAN
	gold_core_spawnable = NO_SPAWN
	del_on_death = TRUE
	loot = list()

	/// Direction the decoy should walk
	var/walk_direction = NORTH
	/// How long the decoy lasts (in deciseconds)
	var/lifetime = 15 SECONDS
	/// When the decoy should despawn
	var/despawn_time

/mob/living/simple_animal/hologram/decoy/Initialize(mapload)
	. = ..()
	despawn_time = world.time + lifetime
	// Make it look almost real - barely transparent
	alpha = 245
	// Extremely subtle effect - hard to notice unless you're looking for it
	add_atom_colour("#F0F8FF", FIXED_COLOUR_PRIORITY)

/// Copies the appearance of the target human
/mob/living/simple_animal/hologram/decoy/proc/copy_appearance(mob/living/carbon/human/target)
	if(!ishuman(target))
		return

	// Copy their appearance completely
	name = target.name
	real_name = target.real_name
	icon = target.icon
	icon_state = target.icon_state
	overlays = target.overlays.Copy()
	// Keep the suspicious desc for those who examine closely

/// Starts the decoy walking
/mob/living/simple_animal/hologram/decoy/proc/start_walking()
	walk(src, walk_direction, speed)
	addtimer(CALLBACK(src, PROC_REF(despawn)), lifetime)

/// Despawns the decoy
/mob/living/simple_animal/hologram/decoy/proc/despawn()
	visible_message(span_notice("[src] flickers and fades away."))
	qdel(src)

/mob/living/simple_animal/hologram/decoy/death(gibbed)
	despawn()
	return ..()

// Decoys can't be attacked normally - things pass through
/mob/living/simple_animal/hologram/decoy/attack_hand(mob/living/carbon/human/user, list/modifiers)
	to_chat(user, span_notice("Your hand passes through [src]!"))
	return

/mob/living/simple_animal/hologram/decoy/attackby(obj/item/item, mob/living/user, params)
	to_chat(user, span_notice("[item] passes through [src]!"))
	return

/mob/living/simple_animal/hologram/decoy/bullet_act(obj/projectile/projectile, def_zone, piercing_hit)
	visible_message(span_notice("[projectile] passes through [src]!"))
	return BULLET_ACT_FORCE_PIERCE
