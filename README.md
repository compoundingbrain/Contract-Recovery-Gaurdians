# Contract-Recovery-Gaurdians

Allows a person to recover a smart wallet or any other ownable smart contract by letting the owner add gaurdians who can transfer contract ownership in case the owner losses access to their private keys.

## Description

Written in solidity for EVM and EVM-like blockchains. The reason I made this is so that if the owner of a contract loses their private key, they can recover the contract by having pre-nominated gaurdians, basically their friends, transfer ownership to a new account.

#### Important details about how this works:

1. The owner of the contract must add gaurdians before their lose their keys
2. Only the owner can add/remove gaurdians
3. An owner cannot be a gaurdian
4. The gaurdians can only transfer ownership when a majority of them vote for a new owner

## Quick Start

This assumes you've got your hardhat workspace set up.

```
git clone https://github.com/compoundingbrain/Contract-Recovery-Gaurdians
cd contracts
```

Then have which ever contract you want to have gaurdians on inherit from "ContractRecoveryGaurdians.sol"

#### Example:

```solidity
// SPDX-License-Idenitifer: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryGaurdians.sol";

contract MyContract is ContractRecoveryGaurdians {

    uint luckyNumber = 7;

}
```

Now your contract is able to have gaurdians.

## Usage

To see the availible functions, check out [ContractRecoveryGaurdians.sol](https://github.com/compoundingbrain/Contract-Recovery-Gaurdians/blob/e9fadb803b8cbdf13ee46d7b6ccaf25682f2eb42/contracts/ContractRecoveryGaurdians.sol).

#### Examples using Ethers:

Assumes you've already deployed the contracts.

####

Add a gaurdian as the owner:

```javascript
const transactionResponse = await myContract.addGaurdian(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Remove a gaurdian as the owner:

```javascript
const transactionResponse = await myContract.removeGaurdian(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Propose a new owner as a gaurdian for other gaurdians to vote on:

```javascript
const transactionResponse = await myContract.proposeNewOwner(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Vote on the proposed owner as a gaurdian:

```javascript
const transactionResponse = await myContract.voteForNewOwner();
```

Transfer ownership as the owner:

```javascript
const transactionResponse = await myContract.transferOwnership(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```
*Disclaimer: I am not a pro-programmer nor am I a pro-githubber, so there might be errors in the README and their might be better ways to write the code. I love to learn so if you spot something, let me know.*
