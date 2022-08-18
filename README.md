# Contract-Recovery-Guardians

Allows a person to recover a smart wallet or any other ownable smart contract by letting the owner add guardians who can transfer contract ownership in case the owner losses access to their private keys.

### Note: 
I know I misspelled gaurdians in every possible place, but I think it is funny so I'm not changing it yet.

## Description

Written in solidity for EVM and EVM-like blockchains. The reason I made this is so that if the owner of a contract loses their private key, they can recover the contract by having pre-nominated guardians, basically their friends, transfer ownership to a new account.

#### Important details about how this works:

1. The owner of the contract must add guardians before their lose their keys
2. Only the owner can add/remove guardians
3. An owner cannot be a guardian
4. The guardians can only transfer ownership when a majority of them vote for a new owner

## Quick Start

This assumes you've got your hardhat workspace set up.

```
git clone https://github.com/compoundingbrain/Contract-Recovery-Guardians
cd contracts
```

Then have which ever contract you want to have guardians on inherit from "ContractRecoveryGuardians.sol"

#### Example:

```solidity
// SPDX-License-Idenitifer: MIT

pragma solidity ^0.8.0;

import "./ContractRecoveryGuardians.sol";

contract MyContract is ContractRecoveryGuardians {

    uint luckyNumber = 7;

}
```

Now your contract is able to have guardians.

## Usage

To see the availible functions, check out [ContractRecoveryGuardians.sol](https://github.com/compoundingbrain/Contract-Recovery-Guardians/blob/e9fadb803b8cbdf13ee46d7b6ccaf25682f2eb42/contracts/ContractRecoveryGuardians.sol).

#### Examples using Ethers:

Assumes you've already deployed the contracts.

####

Add a guardian as the owner:

```javascript
const transactionResponse = await myContract.addGuardian(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Remove a guardian as the owner:

```javascript
const transactionResponse = await myContract.removeGuardian(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Propose a new owner as a guardian for other guardians to vote on:

```javascript
const transactionResponse = await myContract.proposeNewOwner(
  0x5b38da6a701c568545dcfcb03fcb875f56beddc1
);
```

Vote on the proposed owner as a guardian:

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
