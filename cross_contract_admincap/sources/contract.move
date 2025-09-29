// SPDX-License-Identifier: MPL-2.0

/// This module represents a managed state with Admin capability
module cross_contract_admincap::contract;

public struct AdminCap has key, store {
    id: UID,
}

public struct Contract has key {
    id: UID,
    value: u64,
}

/// It creates the initial `Contract` as a shared object and
/// transfers the `AdminCap` to the publisher. The publisher is then
/// responsible for transferring this capability to the DAO.
fun init(ctx: &mut TxContext) {
    // Create the AdminCap.
    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    let ctr = Contract {
        id: object::new(ctx),
        value: 0,
    };
    transfer::transfer(admin_cap, tx_context::sender(ctx));
    transfer::share_object(ctr);
}

public fun set_value(state: &mut Contract, _admin_cap: &AdminCap, new_value: u64) {
    state.value = new_value;
}

public fun value(state: &Contract): u64 {
    state.value
}
