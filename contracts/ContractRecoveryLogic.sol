// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title Account Recovery Guardians behind the scenes logic
/// @author compoundingbrain
/// @notice Behind the scenes logic that helps the AccountRecoveryGuardians.sol contract provide guardians to help recover a contract
/// @dev Have not optimized the code for gas
contract ContractRecoveryLogic {
    address public owner;
    address[] private guardianAddresses;
    mapping(address => uint) private guardianAddressesToIndex;
    struct NewOwnerProposal {
        address newOwnerAddress;
        uint numberOfVotes;
        mapping(address => bool) guardianHasVoted;
    }
    mapping(address => bool) private guardianHasVoted;
    NewOwnerProposal private newOwnerProposal;
    address public proposedNewOwnerAddress;

    /// @notice only the owner of the contract can use a function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /// @notice only a guardian can use a function
    modifier onlyGuardian() {
        require(_isGuardian(msg.sender));
        _;
    }

    constructor() {
        owner = msg.sender;
        newOwnerProposal.newOwnerAddress = owner;
        proposedNewOwnerAddress = owner;
        guardianAddresses.push(0x0000000000000000000000000000000000000000);
    }

    /// @notice Internal function to add a guardian to help recovery the smart contract.
    /// @param _guardianAddress the address of the guardian you wish to add
    function _addGuardian(address _guardianAddress) internal {
        require(
            _guardianAddress != owner && _isGuardian(_guardianAddress) == false
        );
        guardianAddressesToIndex[_guardianAddress] = guardianAddresses.length;
        guardianAddresses.push(_guardianAddress);
    }

    /// @notice Internal function to remove a guardian to help recovery the smart contract.
    /// @param _guardianAddress the address of the guardian you wish to remove
    function _removeGuardian(address _guardianAddress) internal {
        delete guardianAddresses[guardianAddressesToIndex[_guardianAddress]];
    }

    /// @notice Internal function to check if an address is also a guardian on this contract
    /// @param _guardianAddress the address that you wish to verifiy is a guardian
    function _isGuardian(address _guardianAddress)
        internal
        view
        returns (bool)
    {
        if (guardianAddressesToIndex[_guardianAddress] != 0) {
            return (true);
        } else {
            return (false);
        }
    }

    /// @notice Internal function to propose a new owner of a contract. To be used when the owner loses access
    /// @param _newOwnerAddress the address of the desired new owner
    function _proposeNewOwner(address _newOwnerAddress) internal {
        newOwnerProposal.newOwnerAddress = _newOwnerAddress;
        proposedNewOwnerAddress = _newOwnerAddress;
        newOwnerProposal.numberOfVotes = 0;
        for (uint i = 0; i < guardianAddresses.length; i++) {
            delete newOwnerProposal.guardianHasVoted[guardianAddresses[i]];
        }
    }

    /// @notice Internal function vote on a proposed new owner. Owner will be changed when majority of guardians vote yes
    function _voteForNewOwner() internal {
        require(!newOwnerProposal.guardianHasVoted[msg.sender]);
        newOwnerProposal.guardianHasVoted[msg.sender] = true;
        newOwnerProposal.numberOfVotes++;
        if (
            (newOwnerProposal.numberOfVotes * 10) >
            (((guardianAddresses.length - 1) * 10) / 2)
        ) {
            owner = newOwnerProposal.newOwnerAddress;
            _proposeNewOwner(owner);
            if (_isGuardian(owner)) {
                _removeGuardian(owner);
            }
        }
    }
}
