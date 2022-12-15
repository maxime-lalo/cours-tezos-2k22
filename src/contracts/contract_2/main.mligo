#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
	AddPrice of Parameter.add_price_param
	| Reset of unit

type return = operation list * Storage.t

// Assert List
let assert_admin(_assert_admin_param, store: Parameter.assert_admin_param * Storage.t) : unit =
	if(Tezos.get_sender() = store.admin) then () else failwith Errors.not_admin


let add_price(add_price_param, store: Parameter.add_price_param * Storage.t) : Storage.t =
	let (timestamp, price) = add_price_param in
	match Map.find_opt timestamp store.tezos_price with
			Some _ -> failwith Errors.timestamp_already_exists
			| None -> 
				let tezos_price: Storage.tezos_price_mapping = Map.add timestamp price store.tezos_price in
				{store with tezos_price}
// Main
let main (action, store : action * Storage.t) : return =
	let new_store : Storage.t = match action with
		AddPrice (price) -> 
			let _ : unit = assert_admin((), store) in
			add_price (price, store)
		| Reset -> { store with tezos_price = Map.empty }
		in
	(([] : operation list), new_store)


// Views
[@view] let get_storage ((),s: unit * Storage.t) : Storage.t = s
[@view] let get_price (timestamp, store : string * Storage.t) : int =
    match Map.find_opt timestamp store.tezos_price with
        Some val -> val
        | None -> failwith Errors.no_entry
