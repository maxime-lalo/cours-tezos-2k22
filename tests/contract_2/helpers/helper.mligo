#import "../../../src/contracts/contract_2/main.mligo" "Main"
#import "../../helpers/assert.mligo" "Assert"

type taddr = (Main.action, Main.Storage.t) typed_address
type contr = Main.action contract

let get_storage(taddr : taddr) =
    Test.get_storage taddr

let call (p, contr : Main.action * contr) =
    Test.transfer_to_contract contr (p) 0mutez

let call_amount(p, contr, amount : Main.action * contr * tez) =
    Test.transfer_to_contract contr (p) amount

let add_price_success(p, contr: (string * int) * contr) = 
    Assert.tx_success(call(AddPrice(p), contr))

let add_price_failure(p, contr, error : (string * int) *contr * string) =
    Assert.tx_failure(call(AddPrice(p), contr), error)