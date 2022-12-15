#import "../../src/contracts/contract_1/main.mligo" "Main"
#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "./helpers/helper.mligo" "Helper"

let test_not_invited = 
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, _taddr, contr) = Bootstrap.originate_contract(Bootstrap.get_base_storage(accounts.0)) in
    let () = Test.set_source(accounts.1) in
    Helper.accept_admin_failure(contr, Main.Errors.no_admin_invitation)

let test_has_been_invited = 
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, _taddr, contr) = Bootstrap.originate_contract(Bootstrap.get_base_storage(accounts.0)) in
    let () = Test.set_source(accounts.0) in
    Helper.add_admin_success(accounts.1 , contr)
// let test_successful_originate =
//     let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
//     let (_, taddr, _) = Bootstrap.originate_contract(Bootstrap.base_storage) in
//     let () = Test.set_source(accounts.0) in
//     let init_store = Helper.get_storage(taddr) in
//     let () = Test.println(Test.to_string(init_store)) in
//     assert(init_store = Bootstrap.base_storage)

// let test_successful_decrement =
//     let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
//     let (_, taddr, contr) = Bootstrap.originate_contract(Bootstrap.base_storage) in
//     let () = Test.set_source(accounts.0) in
//     let () = assert(Bootstrap.base_storage = Helper.get_storage(taddr)) in
//     let _ = Helper.call_decrement(3, contr) in
//     let modified_store = Helper.get_storage(taddr) in
//     let () = Test.println(Test.to_string(modified_store)) in
//     assert(modified_store = Bootstrap.base_storage - 3)