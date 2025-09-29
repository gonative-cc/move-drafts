# Cross Contract Admin Cap

This package is a Proof of Concept in Sui Move where one module (dao) securely controls another 
(managed) using the capability pattern.

## Core Concepts

1. Capability (AdminCap): The `contract` module defines an `AdminCap` struct. This object acts as a key or proof of authority. Functions that require administrative privileges, like `contract::set_value`, require a reference `&AdminCap` to be passed in. Move enforces that only a holder of the capability can call these functions.

2. Ownership: Upon publication, the `AdminCap` is transferred to the deployer. The deployer then transfers this capability into the DAO object, giving the DAO permanent and exclusive administrative control over the managed module.

3. DAO as Controller: The `dao` module owns the `AdminCap` within its state. When it needs to perform an admin action, its borrows a reference to the `AdminCap` it holds and uses that reference to call admin functions. The capability itself never leaves the `DAO` object.

## How to Use (Conceptual Steps)

1. Publish this package to the Sui network. This will automatically run the `init` function of 
  both modules, creating: a Contract object, DAO object and AdminCap.
2. Transfer Capability: Call the `dao::store_admin_cap` function in a transaction. 
  You will need to pass in the DaoState shared object ID and the `AdminCap` object ID from your address. This will move the `AdminCap` into the DAO's state.
3. Execute via DAO: Call the `dao::execute_contract_set_value` function. You will need to pass the `Contract` shared object ID, along with the new value you want to set. This transaction will succeed because the dao module can provide the required `&AdminCap` to the managed module's function.


## Further exploration

- Instead of hardcoding possible cross contract interaction in the DAO code, we should use PTB.
