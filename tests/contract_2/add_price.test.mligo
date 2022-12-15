#import "../../src/contracts/contract_1/main.mligo" "Main"
#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "./helpers/helper.mligo" "Helper"

let not_admin = 
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, _taddr, contr) = Bootstrap.originate_contract(Bootstrap.get_base_storage(accounts.0)) in
    let () = Test.set_source(accounts.1) in
    Helper.add_price_failure(("1546564", 943),contr, Main.Errors.not_admin)

let add_price = 
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, taddr, contr) = Bootstrap.originate_contract(Bootstrap.get_base_storage(accounts.0)) in
    let _ = Helper.add_price_success(("1546564", 943),contr) in
    let modified_store = Helper.get_storage(taddr) in
    match Map.find_opt "1546564" modified_store.tezos_price with
        Some(val) -> 
            if(val = 943) then
                ()
            else
                failwith "Price not added correctly"
        | None -> failwith "User not in the map"