#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
	SetText of Parameter.set_text_param
	| NukeText of Parameter.nuke_text_param
	| Reset of unit

type return = operation list * Storage.t

let assert_admin(_assert_admin_param, store: Parameter.assert_admin_param * Storage.t) : unit =
	if Tezos.get_sender() <> store.admin then failwith Errors.not_admin else ()

let assert_blacklist(assert_blacklist_param, store : Parameter.assert_blacklist_param * Storage.t) : unit = 
	let is_blacklisted = fun (user : Storage.user) -> if(user = assert_blacklist_param) then failwith Errors.blacklisted else () in
	let _ = List.iter is_blacklisted store.user_blacklist in
	()

let set_text(set_text_param, store : Parameter.set_text_param * Storage.t) : Storage.t =
	let sender: address = Tezos.get_sender() in
	let user_map: Storage.user_mapping = 
		match Map.find_opt sender store.user_map with
			Some _ -> Map.update sender (Some(set_text_param, Moldu)) store.user_map
			| None -> Map.add sender (set_text_param, Moldu) store.user_map
		in
	{ store with user_map }

let nuke_text(nuke_text_param, store : Parameter.nuke_text_param * Storage.t) : Storage.t =
	match Map.find_opt nuke_text_param store.user_map with
		Some _ -> 
			let user_blacklist : Storage.blacklist_mapping = nuke_text_param :: store.user_blacklist in
			let user_map : Storage.user_mapping = Map.remove nuke_text_param store.user_map in
			{ store with user_map; user_blacklist }
		| None -> failwith Errors.text_not_found

let main (action, store : action * Storage.t) : return =
	let sender : address = Tezos.get_sender() in
	let _ = if(sender <> store.admin) then assert_blacklist(sender, store) in
	let new_store : Storage.t = match action with
		SetText (text) -> set_text (text, store)
		| NukeText (user) -> 
			let _ : unit = assert_admin((), store) in 
			nuke_text(user, store)
		| Reset -> { store with user_map = Map.empty }
		in
	(([] : operation list), new_store)

[@view] let get_storage ((),s: unit * Storage.t) : Storage.t = s
