type user = address
type tezos_price_mapping = (string, int) map

type t = {
	admin: user;
	tezos_price: tezos_price_mapping;
}