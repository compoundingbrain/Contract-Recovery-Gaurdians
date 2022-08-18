// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title Account Recovery Gaurdians behind the scenes logic
/// @author compoundingbrain
/// @notice Behind the scenes logic that helps the AccountRecoveryGaurdians.sol contract provide gaurdians to help recover a contract
/// @dev Have not optimized the code for gas
contract ContractRecoveryLogic {
    address public owner;
    address[] private gaurdianAddresses;
    mapping(address => uint) private gaurdianAddressesToIndex;
    struct NewOwnerProposal {
        address newOwnerAddress;
        uint numberOfVotes;
        mapping(address => bool) gaurdianHasVoted;
    }
    mapping(address => bool) private gaurdianHasVoted;
    NewOwnerProposal private newOwnerProposal;
    address public proposedNewOwnerAddress;

    /// @notice only the owner of the contract can use a function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /// @notice only a gaurdian can use a function
    modifier onlyGaurdian() {
        require(_isGaurdian(msg.sender));
        _;
    }

    constructor() {
        owner = msg.sender;
        newOwnerProposal.newOwnerAddress = owner;
        proposedNewOwnerAddress = owner;
        gaurdianAddresses.push(0x0000000000000000000000000000000000000000);
    }

    /// @notice Internal function to add a gaurdian to help recovery the smart contract.
    /// @param _gaurdianAddress the address of the gaurdian you wish to add
    function _addGaurdian(address _gaurdianAddress) internal {
        require(
            _gaurdianAddress != owner && _isGaurdian(_gaurdianAddress) == false
        );
        gaurdianAddressesToIndex[_gaurdianAddress] = gaurdianAddresses.length;
        gaurdianAddresses.push(_gaurdianAddress);
    }

    /// @notice Internal function to remove a gaurdian to help recovery the smart contract.
    /// @param _gaurdianAddress the address of the gaurdian you wish to remove
    function _removeGaurdian(address _gaurdianAddress) internal {
        delete gaurdianAddresses[gaurdianAddressesToIndex[_gaurdianAddress]];
    }

    /// @notice Internal function to check if an address is also a gaurdian on this contract
    /// @param _gaurdianAddress the address that you wish to verifiy is a gaurdian
    function _isGaurdian(address _gaurdianAddress)
        internal
        view
        returns (bool)
    {
        if (gaurdianAddressesToIndex[_gaurdianAddress] != 0) {
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
        for (uint i = 0; i < gaurdianAddresses.length; i++) {
            delete newOwnerProposal.gaurdianHasVoted[gaurdianAddresses[i]];
        }
    }

    /// @notice Internal function vote on a proposed new owner. Owner will be changed when majority of gaurdians vote yes
    function _voteForNewOwner() internal {
        require(!newOwnerProposal.gaurdianHasVoted[msg.sender]);
        newOwnerProposal.gaurdianHasVoted[msg.sender] = true;
        newOwnerProposal.numberOfVotes++;
        if (
            (newOwnerProposal.numberOfVotes * 10) >
            (((gaurdianAddresses.length - 1) * 10) / 2)
        ) {
            owner = newOwnerProposal.newOwnerAddress;
            _proposeNewOwner(owner);
            if (_isGaurdian(owner)) {
                _removeGaurdian(owner);
            }
        }
    }
}
