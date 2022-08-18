// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryGaurdians.sol";

/// @title Basic smart wallet with gaurdian functionality
/// @author compoundingbrain
/// @notice basic smart wallet with gaurdians to help the owner recovery the wallet
contract GaurdianSmartWallet is ContractRecoveryGaurdians {
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
