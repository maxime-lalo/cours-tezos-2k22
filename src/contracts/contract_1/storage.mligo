type user = address
type text = string

type tier = Platinum | Gold | Bronze | Moldu

type user_mapping = (user, (text * tier) ) map
type blacklist_mapping = user list

type admin_mapping = (user, bool) map

type t = {
	user_map : user_mapping;
	user_blacklist: blacklist_mapping;
	admin_list: admin_mapping;
}