// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryGuardians.sol";

/// @title Basic smart wallet with guardian functionality
/// @author compoundingbrain
/// @notice basic smart wallet with guardians to help the owner recovery the wallet
contract ExampleGuardianSmartWallet is ContractRecoveryGuardians {
    receive() external payable {}

    fallback() external payable {}

    function depositEther() public payable {}

    function withdrawEther(uint _amount) public payable onlyOwner {
        sendEther(_amount, payable(owner));
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function sendEther(uint _amount, address payable _to)
        public
        payable
        onlyOwner
    {
        require(_amount > 0);
        require(getBalance() >= _amount);
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}
