#define DAM_SCALE_FACTOR 0.01
#define METAL_PER_TICK 100
/datum/species/protean
	name =             SPECIES_PROTEAN
	name_plural =      "Proteans"
	blurb =            "Sometimes very advanced civilizations will produce the ability to swap into manufactured, robotic bodies. And sometimes \
						<i>VERY</i> advanced civilizations have the option of 'nanoswarm' bodies. Effectively a single robot body comprised \
						of millions of tiny nanites working in concert to maintain cohesion."
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, dissolving into a cloud of gray dust..."
	knockout_message = "collapses inwards, forming a disordered puddle of gray goo."
	remains_type = /obj/effect/decal/cleanable/ash

	blood_color = "#505050" //This is the same as the 80,80,80 below, but in hex
	flesh_color = "#505050"
	base_color = "#FFFFFF" //Color mult, start out with this

	flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	health_hud_intensity = 2
	num_alternate_languages = 3
	assisted_langs = list(LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	color_mult = TRUE

	breath_type = null
	poison_type = null

	virus_immune =	1
	blood_volume =	0
	min_age =		18
	max_age =		200

	brute_mod =		0.30 // 70% brute reduction
	burn_mod =		1.4 //60% burn weakness
	oxy_mod =		0
 /*
These values assume all limbs are hit by the damage. To get individual limb damages divide by 11.
A worst-case sev 4 emp will do 88 damage pre-mitigation, and 140.8 post-mitigation (as resist is negative) spread out over all the limbs.
A best case sev 4 emp will do 55 pre-mitigation damage. This is 88 damage.
A worst case sev 3 emp will do 66 pre-mitigation damage. This is 105.6 damage.
A best case sev 3 emp will do 44 pre-mitigation damage. This is 70.4 damage.
A worst case sev 2 emp will do 55 pre-mitigation damage. This is 88 damage.
A best case sev 2 emp will do 22 pre-mitigation damage. This is 35.2 damage.
A worst case sev 1 emp will do 33 pre-mitigation damage.This is 52.8 damage.
A best case sev 1 emp will do 11 pre-mitigation damage. This is 17.6 damage.
*/
	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 320 //Default 360
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000

	//Space doesn't bother them
	hazard_low_pressure = -1
	hazard_high_pressure = INFINITY //Totally pressure immune - in human form (blobform is also completely pressure/heat immune, bringing them both in line with each other.)


	//Cold/heat does affect them, but it's done in special ways below
	cold_level_1 = -INFINITY
	cold_level_2 = -INFINITY
	cold_level_3 = -INFINITY
	heat_level_1 = INFINITY
	heat_level_2 = INFINITY
	heat_level_3 = INFINITY

	body_temperature =      290

	siemens_coefficient =   1.4

	rarity_value =          5

	has_organ = list(
		O_BRAIN = /obj/item/organ/internal/mmi_holder/posibrain/nano,
		O_ORCH = /obj/item/organ/internal/nano/orchestrator,
		O_FACT = /obj/item/organ/internal/nano/refactory
		)
	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/nano),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/nano),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/nano),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/nano),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/nano),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/nano),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/nano),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/nano),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/nano),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/nano),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/nano)
		)

	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")

	//These verbs are hidden, for hotkey use only
	inherent_verbs = list(
		/mob/living/carbon/human/proc/nano_regenerate, //These verbs are hidden so you can macro them,
		/mob/living/carbon/human/proc/nano_partswap,
		/mob/living/carbon/human/proc/nano_metalnom,
		/mob/living/carbon/human/proc/nano_blobform,
		/mob/living/carbon/human/proc/nano_set_size,
		/mob/living/carbon/human/proc/nano_change_fitting, //These verbs are displayed normally,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/proc/eat_trash,
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/shred_limb,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color,
		/mob/living/carbon/human/proc/lick_wounds) //prots get all the special verbs since they can't select traits.
	var/global/list/abilities = list()

	var/monochromatic = FALSE //IGNORE ME

/datum/species/protean/New()
	..()
	if(!LAZYLEN(abilities))
		var/list/powertypes = subtypesof(/obj/effect/protean_ability)
		for(var/path in powertypes)
			abilities += new path()

/datum/species/protean/create_organs(var/mob/living/carbon/human/H)
	var/obj/item/nif/saved_nif = H.nif
	if(saved_nif)
		H.nif.unimplant(H) //Needs reference to owner to unimplant right.
		H.nif.moveToNullspace()
	..()
	if(saved_nif)
		saved_nif.quick_implant(H)

/datum/species/protean/get_bodytype(var/mob/living/carbon/human/H)
	if(H)
		return H.impersonate_bodytype || ..()
	return ..()

/datum/species/protean/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.synth_color = TRUE

/datum/species/protean/equip_survival_gear(var/mob/living/carbon/human/H)
	var/obj/item/stack/material/steel/metal_stack = new()
	metal_stack.amount = 3

	var/obj/item/clothing/accessory/permit/nanotech/permit = new()
	permit.set_name(H.real_name)

	if(H.backbag == 1) //Somewhat misleading, 1 == no bag (not boolean)
		H.equip_to_slot_or_del(permit, slot_l_hand)
		H.equip_to_slot_or_del(metal_stack, slot_r_hand)
	else
		H.equip_to_slot_or_del(permit, slot_in_backpack)
		H.equip_to_slot_or_del(metal_stack, slot_in_backpack)

	spawn(0) //Let their real nif load if they have one
		if(!H.nif)
			var/obj/item/nif/bioadap/new_nif = new()
			new_nif.quick_implant(H)
		else
			H.nif.durability = rand(21,25)

/datum/species/protean/hug(var/mob/living/carbon/human/H, var/mob/living/target)
	return ..() //Wut

/datum/species/protean/get_blood_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/get_flesh_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/handle_death(var/mob/living/carbon/human/H)
	to_chat(H,"<span class='warning'>You died as a Protean. Please sit out of the round for at least 30 minutes before respawning, to represent the time it would take to ship a new-you to the station.</span>")
	spawn(1) //This spawn is here so that if the protean_blob calls qdel, it doesn't try to gib the humanform.
		if(H)
			H.gib()

/datum/species/protean/handle_environment_special(var/mob/living/carbon/human/H)
	if((H.getActualBruteLoss() + H.getActualFireLoss()) > H.maxHealth*0.35 && isturf(H.loc)) //So, only if we're not a blob (we're in nullspace) or in someone (or a locker, really, but whatever). The decimal point (0.35 as of now) is the autoblob %hp threshold.
		H.nano_intoblob()
		return ..() //Any instakill shot runtimes since there are no organs after this. No point to not skip these checks, going to nullspace anyway.

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in H.internal_organs
	if(refactory && !(refactory.status & ORGAN_DEAD) && refactory.processingbuffs)

		//MHydrogen adds speeeeeed
		if(refactory.get_stored_material(MAT_METALHYDROGEN) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/mhydrogen, origin = refactory)

		//Uranium adds brute armor
		if(refactory.get_stored_material(MAT_URANIUM) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/uranium, origin = refactory)

		//Gold adds burn armor
		if(refactory.get_stored_material(MAT_GOLD) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/gold, origin = refactory)

		//Silver adds darksight
		if(refactory.get_stored_material(MAT_SILVER) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/silver, origin = refactory)

	return ..()

/datum/species/protean/get_additional_examine_text(var/mob/living/carbon/human/H)
	return ..() //Hmm, what could be done here?

/datum/species/protean/Stat(var/mob/living/carbon/human/H)
	..()
	if(statpanel("Protean"))
		var/obj/item/organ/internal/nano/refactory/refactory = H.nano_get_refactory()
		if(refactory && !(refactory.status & ORGAN_DEAD))
			stat(null, "- -- --- Refactory Metal Storage --- -- -")
			var/max = refactory.max_storage
			for(var/material in refactory.materials)
				var/amount = refactory.get_stored_material(material)
				stat("[capitalize(material)]", "[amount]/[max]")
		else
			stat(null, "- -- --- REFACTORY ERROR! --- -- -")

		stat(null, "- -- --- Abilities (Shift+LMB Examines) --- -- -")
		for(var/ability in abilities)
			var/obj/effect/protean_ability/A = ability
			stat("[A.ability_name]",A.atom_button_text())

// Various modifiers
/datum/modifier/protean
	stacks = MODIFIER_STACK_FORBID
	var/material_use = METAL_PER_TICK
	var/material_name = DEFAULT_WALL_MATERIAL

/datum/modifier/protean/on_applied()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_created_text)

/datum/modifier/protean/on_expire()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_expired_text)

/datum/modifier/protean/check_if_valid()
	//No origin set
	if(!istype(origin))
		expire()

	//No refactory or refactory not processing buffs anymore so you can't be permanently buffed while not consuming materials
	var/obj/item/organ/internal/nano/refactory/refactory = origin.resolve()
	if(!istype(refactory) || refactory.status & ORGAN_DEAD || refactory.processingbuffs == FALSE)
		expire()

	// stops you from consuming materials if the toggle is off
	if(!refactory.use_stored_material(material_name,material_use) && refactory.processingbuffs == TRUE)
		expire()

/datum/modifier/protean/mhydrogen
	name = "Protean Effect - M.Hydrogen"
	desc = "You're affected by the presence of metallic hydrogen."

	on_created_text = "<span class='notice'>You feel yourself accelerate, the metallic hydrogen increasing your speed temporarily.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the metallic hydrogen, and you return to normal speed.</span>"

	material_name = MAT_METALHYDROGEN

	slowdown = -1

/datum/modifier/protean/uranium
	name = "Protean Effect - Uranium"
	desc = "You're affected by the presence of uranium."

	on_created_text = "<span class='notice'>You feel yourself become nearly impervious to physical attacks as uranium is incorporated in your nanites.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the uranium, and you return to your normal nanites.</span>"

	material_name = MAT_URANIUM

	incoming_brute_damage_percent = 0.8

/datum/modifier/protean/gold
	name = "Protean Effect - Gold"
	desc = "You're affected by the presence of gold."

	on_created_text = "<span class='notice'>You feel yourself become more reflective, able to resist heat and fire better for a time.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the gold, and you return to your normal nanites.</span>"

	material_name = MAT_GOLD

	incoming_fire_damage_percent = 0.8

/datum/modifier/protean/silver
	name = "Protean Effect - Silver"
	desc = "You're affected by the presence of silver."

	on_created_text = "<span class='notice'>Your physical control is improved for a time, making it easier to hit targets, and avoid being hit.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the silver, and your motor control returns to normal.</span>"

	material_name = MAT_SILVER

	accuracy = 30
	evasion = 30

/datum/modifier/protean/steel
	name = "Protean Effect - Steel"
	desc = "You're affected by the presence of steel."

	on_created_text = "<span class='notice'>You feel new nanites being produced from your stockpile of steel, healing you slowly.</span>"
	on_expired_text = "<span class='notice'>Your steel supply has either run out, or is no longer needed, and your healing stops.</span>"

	material_name = MAT_STEEL

/datum/modifier/protean/steel/tick()

	..()
	holder.adjustBruteLoss(-9 ,include_robo = TRUE) //Looks high, but these are modified by species resistances to equal out at 3hp/sec.
	holder.adjustFireLoss(-2.14,include_robo = TRUE) //Looks high, but these are modified by species resistances to equal out at 3hp/sec.
	holder.adjustToxLoss(-3)
	holder.radiation = max(holder.radiation - 15, 0)
	
	var/mob/living/carbon/human/H = holder
	for(var/organ in H.internal_organs)
		var/obj/item/organ/O = organ
		// Fix internal damage
		if(O.damage > 0)
			O.damage = max(0,O.damage-0.1)
		// If not damaged, but dead, fix it
		else if(O.status & ORGAN_DEAD)
			O.status &= ~ORGAN_DEAD //Unset dead if we repaired it entirely

// PAN Card
/obj/item/clothing/accessory/permit/nanotech
	name = "\improper P.A.N. card"
	desc = "This is a 'Permit for Advanced Nanotechnology' card. It allows the owner to possess and operate advanced nanotechnology on NanoTrasen property. It must be renewed on a monthly basis."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "permit-pan"
/obj/item/clothing/accessory/permit/nanotech/set_name(var/new_name)
	owner = 1
	if(new_name)
		src.name += " ([new_name])"
		desc += "\nVALID THROUGH END OF: [time2text(world.timeofday, "Month") +" "+ num2text(text2num(time2text(world.timeofday, "YYYY"))+544)]\nREGISTRANT: [new_name]"

#undef DAM_SCALE_FACTOR
#undef METAL_PER_TICK
