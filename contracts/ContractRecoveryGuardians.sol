// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryLogic.sol";

/// @title Account Recovery Guardians public functions
/// @author compoundingbrain
/// @notice Simple contract with the functions nessicary to operate the guardians system. Designed such that no
/// guardian knows who other guardians are, and that if a majority of guardians votes for a new owner, then a
/// new owner with be added and the previous owner replaced.
contract ContractRecoveryGuardians is ContractRecoveryLogic {
    /// @notice Public function for the contract owner to add a new guardian
    /// @param _guardianAddress the address of the guardian you would like to add
    function addGuardian(address _guardianAddress) public onlyOwner {
        _addGuardian(_guardianAddress);
    }

    /// @notice Public function for the contract owner to remove a guardian
    /// @param _guardianAddress the address of the guardian you would like to remove
    function removeGuardian(address _guardianAddress) public onlyOwner {
        _removeGuardian(_guardianAddress);
    }

    /// @notice Public function for the contract guardians to propose a new owner
    /// @param _newOwnerAddress the address of the proposed new contract owner
    function proposeNewOwner(address _newOwnerAddress) public onlyGuardian {
        _proposeNewOwner(_newOwnerAddress);
    }

    /// @notice Public function for the contract guardians to vote on the proposed new contract owner. Note that
    /// once a majority of guardians vote, the contract owner will automatically change to the proposed new contract
    /// owner. Also, just calling this function counts as a yes vote.
    function voteForNewOwner() public onlyGuardian {
        _voteForNewOwner();
    }

    /// @notice Public function for the contract owner to transfer ownership
    /// @param _newOwnerAddress the address of the new contract owner
    function transferOwnership (_newOwnerAddress) public onlyOwner [
        owner = _newOwnerAddress;
    ]
}
