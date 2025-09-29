// SPDX-License-Identifier: MPL-2.0

/// # DAO Module
///
/// This module represents a simple DAO. It owns the `AdminCap` from the
/// `contract` module and exposes a public function to execute an
/// administrative action on the `Contract`.
module cross_contract_admincap::dao;

use cross_contract_admincap::contract::{AdminCap, Contract};

const E_ADMIN_CAP_ALREADY_STORED: u64 = 1;

// === Structs ===

/// The DAO's main state object. It will own the `AdminCap`.
public struct DAO has key {
    id: UID,
    /// The `AdminCap` is stored inside an Option, allowing the `DAO`
    /// to be created before it receives the capability.
    admin_cap: Option<AdminCap>,
}

// === Init ===

/// This function is called once when the module is published.
/// It creates the shared `DAO` object, which is initially empty.
fun init(ctx: &mut TxContext) {
    transfer::share_object(DAO {
        id: object::new(ctx),
        admin_cap: option::none(),
    });
}

// === Public Functions ===

/// A one-time setup function allowing the current owner of the `AdminCap`
/// to permanently store it within the DAO's state.
public fun store_admin_cap(dao: &mut DAO, cap: AdminCap) {
    // Ensure the cap has not already been stored.
    assert!(option::is_none(&dao.admin_cap), E_ADMIN_CAP_ALREADY_STORED);
    dao.admin_cap.fill(cap);
}

/// The main function where the DAO executes an action on the `contract` module.
public fun execute_contract_set_value(dao: &DAO, ctr: &mut Contract, new_value: u64) {
    let admin_cap_ref = dao.admin_cap.borrow();
    ctr.set_value(admin_cap_ref, new_value);
}
