// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryLogic.sol";

/// @title Account Recovery Gaurdians public functions
/// @author compoundingbrain
/// @notice Simple contract with the functions nessicary to operate the gaurdians system. Designed such that no
/// gaurdian knows who other gaurdians are, and that if a majority of gaurdians votes for a new owner, then a
/// new owner with be added and the previous owner replaced.
contract ContractRecoveryGaurdians is ContractRecoveryLogic {
    /// @notice Public function for the contract owner to add a new gaurdian
    /// @param _gaurdianAddress the address of the gaurdian you would like to add
    function addGaurdian(address _gaurdianAddress) public onlyOwner {
        _addGaurdian(_gaurdianAddress);
    }

    /// @notice Public function for the contract owner to remove a gaurdian
    /// @param _gaurdianAddress the address of the gaurdian you would like to remove
    function removeGaurdian(address _gaurdianAddress) public onlyOwner {
        _removeGaurdian(_gaurdianAddress);
    }

    /// @notice Public function for the contract gaurdians to propose a new owner
    /// @param _newOwnerAddress the address of the proposed new contract owner
    function proposeNewOwner(address _newOwnerAddress) public onlyGaurdian {
        _proposeNewOwner(_newOwnerAddress);
    }

    /// @notice Public function for the contract gaurdians to vote on the proposed new contract owner. Note that
    /// once a majority of gaurdians vote, the contract owner will automatically change to the proposed new contract
    /// owner. Also, just calling this function counts as a yes vote.
    function voteForNewOwner() public onlyGaurdian {
        _voteForNewOwner();
    }

    /// @notice Public function for the contract owner to transfer ownership
    /// @param _newOwnerAddress the address of the new contract owner
    function transferOwnership (_newOwnerAddress) public onlyOwner [
        owner = _newOwnerAddress;
    ]
}
