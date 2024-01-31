/obj/item/implant/internal_id
	name = "internal ID implant"

	var/access = list()
//

//sync the implant with the id, most of the code stolen from `/datum/nanite_program/access/on_trigger(comm_message)`
/obj/item/implant/internal_id/activate()

	var/list/potential_items = list()//get a list of the possible places where the ID card can exist in

	potential_items += imp_in.get_active_held_item()
	potential_items += imp_in.get_inactive_held_item()
	potential_items += imp_in.pulling

	if(ishuman(imp_in))
		var/mob/living/carbon/human/H = imp_in
		potential_items += H.wear_id
	else if(isanimal(imp_in))
		var/mob/living/simple_animal/A = imp_in
		potential_items += A.access_card

	var/list/new_access = list()//the new access ID list

	for(var/obj/item/I in potential_items)
		new_access += I.GetAccess()// combine all the access of cards

	access = new_access
	balloon_alert(imp_in, "Access Updated!")
	RegisterSignal(imp_in, COMSIG_MOB_TRIED_ACCESS, PROC_REF(check_access), TRUE)
	. = ..()
//

/obj/item/implant/internal_id/check_access(datum/source, obj/O)
	SIGNAL_HANDLER

	for(var/obj/item/implant/internal_id/internal_id_implant in imp_in.implants)
		return O.check_access_list(internal_id_implant.access)
	return FALSE

//

/obj/item/implanter/internal_id
	name = "implanter (internal ID)"
	imp_type = /obj/item/implant/internal_id
//

/obj/item/implantcase/internal_id
	name = "implant case (internal ID)"
	desc = "A glass case containing an internal ID implant."
	imp_type = /obj/item/implant/internal_id
//
