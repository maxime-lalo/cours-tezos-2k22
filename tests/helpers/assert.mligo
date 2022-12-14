let tx_failure (res, expected_error: test_exec_result * test_exec_error) : unit =
	match res with
		Success _ -> failwith "contract success but expected failure"
		| Fail (error) -> assert(error = expected_error)


let tx_success (res: test_exec_result) : unit =
	match res with
		Success _ -> ()
		| Fail (error) ->
            (match error with 
                Rejected (reject_err) -> 
                    let (err_str, _) = reject_err in
                    failwith err_str
                | Balance_too_low _ -> failwith "contract failed: balance too low"
                | Other s -> failwith s
            )