#import "../../../src/contracts/contract_1/main.mligo" "Main"
#import "../../helpers/assert.mligo" "Assert"

type taddr = (Main.action, Main.Storage.t) typed_address
type contr = Main.action contract

let get_storage(taddr : taddr) =
    Test.get_storage taddr

let call (p, contr : Main.action * contr) =
    Test.transfer_to_contract contr (p) 0mutez

// //Increment functions
// let call_increment (p, contr : int * contr) =
//     call(Increment(p), contr)

// let call_increment_success (p, contr : int * contr) =
//     Assert.tx_success(call_increment(p, contr))

// let call_increment_failure (p, contr, expected_error : int * contr * string) =
//     Assert.tx_failure(call_increment(p, contr), expected_error)

// //Decrement functions
// let call_decrement (p, contr : int * contr) =
//     call(Decrement(p), contr)