// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeHiddenKitty.sol";

contract Hack {
    constructor(House house) {
        bytes32 solution = keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 69)));
        house.isKittyCatHere(solution);
        selfdestruct(payable(msg.sender));
    }
}

// https://goerli.etherscan.io/address/0x465D8Df4b74Fe213CE11DB0b8E3bF71851dD75c2
contract ChallengeHiddenKittyScript is Script {
    address constant instance = 0x465D8Df4b74Fe213CE11DB0b8E3bF71851dD75c2;

    function run() public {
        vm.startBroadcast();

        House house = House(instance);
        new Hack(house);

        console.log("catFound?", house.catFound());
    }
}
